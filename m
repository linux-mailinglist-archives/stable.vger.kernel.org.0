Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7825744F7D6
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 13:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhKNMZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 07:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhKNMZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 07:25:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F3146109E;
        Sun, 14 Nov 2021 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636892581;
        bh=pleVVYb1ovkIJxbrRQPTA5UjrSZKMHkr+RT2JbrqW3g=;
        h=Subject:To:Cc:From:Date:From;
        b=WPRKQDQJP4W0D+z7V8QrLRMS37OibP68tMrn/MhswnxKojLcA3lU4W6T/A+y3bYG4
         ehFNHTzJtiuSGBunBUVK8WIRKT9Glx+BfOt3kleUzlwQERGiAmjIxPsf4kSEwVeh4n
         T/km9AJs7DyVMF3T0BuYLES6Hnd7atVpHxG3lBiU=
Subject: FAILED: patch "[PATCH] serial: core: Fix initializing and restoring termios speed" failed to apply to 4.4-stable tree
To:     pali@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 13:22:58 +0100
Message-ID: <1636892578230164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 027b57170bf8bb6999a28e4a5f3d78bf1db0f90c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Sat, 2 Oct 2021 15:09:00 +0200
Subject: [PATCH] serial: core: Fix initializing and restoring termios speed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit edc6afc54968 ("tty: switch to ktermios and new framework")
termios speed is no longer stored only in c_cflag member but also in new
additional c_ispeed and c_ospeed members. If BOTHER flag is set in c_cflag
then termios speed is stored only in these new members.

Therefore to correctly restore termios speed it is required to store also
ispeed and ospeed members, not only cflag member.

In case only cflag member with BOTHER flag is restored then functions
tty_termios_baud_rate() and tty_termios_input_baud_rate() returns baudrate
stored in c_ospeed / c_ispeed member, which is zero as it was not restored
too. If reported baudrate is invalid (e.g. zero) then serial core functions
report fallback baudrate value 9600. So it means that in this case original
baudrate is lost and kernel changes it to value 9600.

Simple reproducer of this issue is to boot kernel with following command
line argument: "console=ttyXXX,86400" (where ttyXXX is the device name).
For speed 86400 there is no Bnnn constant and therefore kernel has to
represent this speed via BOTHER c_cflag. Which means that speed is stored
only in c_ospeed and c_ispeed members, not in c_cflag anymore.

If bootloader correctly configures serial device to speed 86400 then kernel
prints boot log to early console at speed speed 86400 without any issue.
But after kernel starts initializing real console device ttyXXX then speed
is changed to fallback value 9600 because information about speed was lost.

This patch fixes above issue by storing and restoring also ispeed and
ospeed members, which are required for BOTHER flag.

Fixes: edc6afc54968 ("[PATCH] tty: switch to ktermios and new framework")
Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20211002130900.9518-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0e2e35ab64c7..1e738f265eea 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -222,7 +222,11 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 	if (retval == 0) {
 		if (uart_console(uport) && uport->cons->cflag) {
 			tty->termios.c_cflag = uport->cons->cflag;
+			tty->termios.c_ispeed = uport->cons->ispeed;
+			tty->termios.c_ospeed = uport->cons->ospeed;
 			uport->cons->cflag = 0;
+			uport->cons->ispeed = 0;
+			uport->cons->ospeed = 0;
 		}
 		/*
 		 * Initialise the hardware port settings.
@@ -290,8 +294,11 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
-		if (uport && uart_console(uport) && tty)
+		if (uport && uart_console(uport) && tty) {
 			uport->cons->cflag = tty->termios.c_cflag;
+			uport->cons->ispeed = tty->termios.c_ispeed;
+			uport->cons->ospeed = tty->termios.c_ospeed;
+		}
 
 		if (!tty || C_HUPCL(tty))
 			uart_port_dtr_rts(uport, 0);
@@ -2094,8 +2101,11 @@ uart_set_options(struct uart_port *port, struct console *co,
 	 * Allow the setting of the UART parameters with a NULL console
 	 * too:
 	 */
-	if (co)
+	if (co) {
 		co->cflag = termios.c_cflag;
+		co->ispeed = termios.c_ispeed;
+		co->ospeed = termios.c_ospeed;
+	}
 
 	return 0;
 }
@@ -2229,6 +2239,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 		 */
 		memset(&termios, 0, sizeof(struct ktermios));
 		termios.c_cflag = uport->cons->cflag;
+		termios.c_ispeed = uport->cons->ispeed;
+		termios.c_ospeed = uport->cons->ospeed;
 
 		/*
 		 * If that's unset, use the tty termios setting.
diff --git a/include/linux/console.h b/include/linux/console.h
index 20874db50bc8..a97f277cfdfa 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -149,6 +149,8 @@ struct console {
 	short	flags;
 	short	index;
 	int	cflag;
+	uint	ispeed;
+	uint	ospeed;
 	void	*data;
 	struct	 console *next;
 };

