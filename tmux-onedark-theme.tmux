#!/bin/bash

getHexFromLine() {
	trimmedLine="$(echo -e "$1" | tr -d '[:space:]')"
	HEX=$(echo "$trimmedLine" | awk -F ':' '{print $2}')
}

# $1 should be the xresources line
# $2 should be the tmux color to set
setColorFromHex() {
	getHexFromLine "$line"
	prefix="tmux_"
	command="$prefix$2=$HEX"
	export "${command?}"
}

Xresources=~/.Xresources.colors

while read -r line; do
	#skip empty lines
	[ -z "$line" ] && continue
	case $line in

	*color15*)
		setColorFromHex "$line" light_white
		;;
	*color14*)
		setColorFromHex "$line" light_cyan
		;;
	*color13*)
		setColorFromHex "$line" light_magenta
		;;
	*color12*)
		setColorFromHex "$line" light_blue
		;;
	*color11*)
		setColorFromHex "$line" light_yellow
		;;
	*color10*)
		setColorFromHex "$line" light_green
		;;
	*color9*)
		setColorFromHex "$line" light_red
		;;
	*color8*)
		setColorFromHex "$line" light_black
		;;
	*color7*)
		setColorFromHex "$line" white
		;;
	*color6*)
		setColorFromHex "$line" cyan
		;;
	*color5*)
		setColorFromHex "$line" magenta
		;;
	*color4*)
		setColorFromHex "$line" blue
		;;
	*color3*)
		setColorFromHex "$line" yellow
		;;
	*color2*)
		setColorFromHex "$line" green
		;;
	*color1*)
		setColorFromHex "$line" red
		;;
	*color0*)
		setColorFromHex "$line" black
		;;
	esac
done <$Xresources

onedark_black=${tmux_black:-"#282c34"}
onedark_blue=${tmux_blue:-"#57a5e5"}
onedark_yellow=${tmux_yellow:-"#dbb671"}
onedark_red=${tmux_red:-"#de5d68"}
onedark_white=${tmux_white:-"#a7aab0"}
onedark_green=${tmux_green:-"#8fb573"}
onedark_visual_grey=${tmux_light_black:-"#3e4452"}
onedark_comment_grey="#5c6370"

get() {
	local option=$1
	local default_value=$2
	local option_value="$(tmux show-option -gqv "$option")"

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

setw() {
	local option=$1
	local value=$2
	tmux set-window-option -gq "$option" "$value"
}

set "status" "on"
set "status-justify" "left"

set "status-left-length" "100"
set "status-right-length" "100"
set "status-right-attr" "none"

set "message-fg" "$onedark_white"
set "message-bg" "$onedark_black"

set "message-command-fg" "$onedark_white"
set "message-command-bg" "$onedark_black"

set "status-attr" "none"
set "status-left-attr" "none"

setw "window-status-fg" "$onedark_black"
setw "window-status-bg" "$onedark_black"
setw "window-status-attr" "none"

setw "window-status-activity-bg" "$onedark_black"
setw "window-status-activity-fg" "$onedark_black"
setw "window-status-activity-attr" "none"

setw "window-status-separator" ""

set "window-style" "fg=$onedark_comment_grey"
set "window-active-style" "fg=$onedark_white"

set "pane-border-fg" "$onedark_white"
set "pane-border-bg" "$onedark_black"
set "pane-active-border-fg" "$onedark_green"
set "pane-active-border-bg" "$onedark_black"

set "display-panes-active-colour" "$onedark_yellow"
set "display-panes-colour" "$onedark_blue"

set "status-bg" "$onedark_black"
set "status-fg" "$onedark_white"

set "@prefix_highlight_fg" "$onedark_black"
set "@prefix_highlight_bg" "$onedark_green"
set "@prefix_highlight_copy_mode_attr" "fg=$onedark_black,bg=$onedark_green"
set "@prefix_highlight_output_prefix" "  "

status_widgets=$(get "@onedark_widgets")
time_format=$(get "@onedark_time_format" "%R")
date_format=$(get "@onedark_date_format" "%d/%m/%Y")

set "status-right" "#[fg=$onedark_white,bg=$onedark_black,nounderscore,noitalics]${time_format}  ${date_format} #[fg=$onedark_visual_grey,bg=$onedark_black]#[fg=$onedark_visual_grey,bg=$onedark_visual_grey]#[fg=$onedark_white, bg=$onedark_visual_grey]${status_widgets} #[fg=$onedark_green,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_black,bg=$onedark_green,bold] #h #[fg=$onedark_yellow, bg=$onedark_green]#[fg=$onedark_red,bg=$onedark_yellow]"
set "status-left" "#[fg=$onedark_black,bg=$onedark_green,bold] #S #{prefix_highlight}#[fg=$onedark_green,bg=$onedark_black,nobold,nounderscore,noitalics]"

set "window-status-format" "#[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_black] #I  #W #[fg=$onedark_black,bg=$onedark_black,nobold,nounderscore,noitalics]"
set "window-status-current-format" "#[fg=$onedark_black,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_white,bg=$onedark_visual_grey,nobold] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_black,nobold,nounderscore,noitalics]"
