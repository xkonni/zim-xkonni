# vim:et sts=2 sw=2 ft=zsh

_prompt_xkonni_vimode() {
  case ${KEYMAP} in
    vicmd) print -n '%S%#%s' ;;
    *) print -n '%#' ;;
  esac
}

_prompt_xkonni_keymap_select() {
  zle reset-prompt
  zle -R
}
if autoload -Uz is-at-least && is-at-least 5.3; then
  autoload -Uz add-zle-hook-widget && \
      add-zle-hook-widget -Uz keymap-select _prompt_xkonni_keymap_select
else
  zle -N zle-keymap-select _prompt_xkonni_keymap_select
fi

# use extended color palette if available
if (( terminfo[colors] >= 999 )); then
  if (( ! ${+COLOR_BLACK} )) typeset -g COLOR_BLACK=235           # 0
  if (( ! ${+COLOR_RED} )) typeset -g COLOR_RED=160               # 1
  if (( ! ${+COLOR_GREEN} )) typeset -g COLOR_GREEN=70            # 2
  if (( ! ${+COLOR_YELLOW} )) typeset -g COLOR_YELLOW=220         # 3
  if (( ! ${+COLOR_BLUE} )) typeset -g COLOR_BLUE=33              # 4
  if (( ! ${+COLOR_MAGENTA} )) typeset -g COLOR_MAGENTA=135       # 5
  if (( ! ${+COLOR_CYAN} )) typeset -g COLOR_CYAN=75              # 6
  if (( ! ${+COLOR_WHITE} )) typeset -g COLOR_WHITE=245           # 7
else
  if (( ! ${+COLOR_BLACK} )) typeset -g COLOR_BLACK=black         # 0
  if (( ! ${+COLOR_RED} )) typeset -g COLOR_RED=red               # 1
  if (( ! ${+COLOR_GREEN} )) typeset -g COLOR_GREEN=green         # 2
  if (( ! ${+COLOR_YELLOW} )) typeset -g COLOR_YELLOW=yellow      # 3
  if (( ! ${+COLOR_BLUE} )) typeset -g COLOR_BLUE=blue            # 4
  if (( ! ${+COLOR_MAGENTA} )) typeset -g COLOR_MAGENTA=magenta   # 5
  if (( ! ${+COLOR_CYAN} )) typeset -g COLOR_CYAN=cyan            # 6
  if (( ! ${+COLOR_WHITE} )) typeset -g COLOR_WHITE=white         # 7
fi
typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

autoload -Uz add-zsh-hook
# Depends on duration-info module to show last command duration
if (( ${+functions[duration-info-preexec]} && \
    ${+functions[duration-info-precmd]} )); then
  zstyle ':zim:duration-info' format ' took %B%F{yellow}%d%f%b'
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi
# Depends on git-info module to show git information
typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format 'HEAD (%c)'
  zstyle ':zim:git-info:action' format ' (${(U):-%s})'
  zstyle ':zim:git-info:stashed' format '# '            #   
  zstyle ':zim:git-info:unindexed' format ' '          #   
  zstyle ':zim:git-info:indexed' format ' '            #   
  zstyle ':zim:git-info:ahead' format '> '              # 
  zstyle ':zim:git-info:behind' format '< '             # 
  zstyle ':zim:git-info:keys' format \
      'status' '%F{${COLOR_RED}}%S%I%i%A%B' \
      'prompt' '  %%B%F{${COLOR_YELLOW}}%b%c%s${(e)git_info[status]:+" ${(e)git_info[status]}"}%f%%b '
  add-zsh-hook precmd git-info
fi

  # E0B0:  E0B1:  E0B2:  E0B3:  276F: ❯ 2770: ❮
PS1='
%(2L.%B%F{${COLOR_MAGENTA}}⇆ (%L)%f%b .)%(!.%B%F{${COLOR_CYAN}}%n%f%b  .${SSH_TTY:+"%B%F{${COLOR_CYAN}}%n%f%b  "})${SSH_TTY:+"%B%F{${COLOR_GREEN}}%m%f%b  "}%B%F{${COLOR_BLUE}}%~%f%b${(e)git_info[prompt]}${VIRTUAL_ENV:+" via %B%F{yellow}${VIRTUAL_ENV:t}%b%f"}${duration_info}
%B%(1j.%F{${COLOR_BLUE}}*%f .)%(?.%F{${COLOR_GREEN}}.%F{${COLOR_RED}}%? )$(_prompt_xkonni_vimode)%f%b '
unset RPS1
