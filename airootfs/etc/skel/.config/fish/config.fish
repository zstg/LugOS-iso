if status is-interactive
    # vim:fileencoding=utf-8:foldmethod=marker
    # Commands to run in interactive sessions can go here
    source (/usr/bin/starship init fish --print-full-init | psub)
    # set -gx fish_key_bindings fish_vi_key_bindings
    if [ "$IS_VTERM" != "1" ];
	fish_vi_key_bindings
    else
	fish_default_key_bindings
    end
    source ~/.config/fish/aliases
    set -x MANROFFOPT "-c"
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set fish_greeting
    echo > ~/.local/share/fish/fish_history
    alias clh='echo > ~/.local/share/fish/fish_history && exec fish'
    abbr -a pacman sudo pacman
    abbr -a s sudo
    abbr -a md mkdir -p
    function fish_user_key_bindings
	bind --preset -M insert \el forward-char
	bind --preset -M insert \eh backward-char
	bind --preset -M insert \ew forward-word
	bind --preset -M insert \eb backward-word
	bind --preset -M insert \cH backward-kill-word
	bind --preset -M insert \e\[3\;5~ kill-word
	bind --preset -M insert \ca beginning-of-line
	bind --preset -M insert \ce end-of-line
	bind --preset -M insert \cc 'echo; commandline | cat; commandline ""; commandline -f repaint'
    end
    source ~/.config/fish/git.fish
    tokyonight-dark # function to display in tokyonight-dark colours
end

# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
    switch (commandline -t)
	case "!"
	    commandline -t $history[1]; commandline -f repaint
	case "*"
	    commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
	case "!"
	    commandline -t ""
	    commandline -f history-token-search-backward
	case "*"
	    commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
	command cp -r $from $to
    else
	command cp $argv
    end
end

