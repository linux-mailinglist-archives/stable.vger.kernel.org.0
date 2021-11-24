Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6E45BCCB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244750AbhKXMc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344195AbhKXMai (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C96061353;
        Wed, 24 Nov 2021 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756347;
        bh=Y3qF/cDXSfTxftZwMyDOSHa/r+PpkDPpBigcRGhW2K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E00DAg7YMDE53ABjlbMKD8JUidxCJASHI1GnLj3oeLEHjTxFcGS3wblc07I2bgAol
         4AAm7ClSPhTZL7YFYYbDjEozRI4FauX/qQcrtngC6X7zCGey7NRxgOTMUtciSmdRJh
         6AUYtav2z9PJP0DuylsyG42KmCLPNnswu+qAAIIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.14 054/251] serial: core: Fix initializing and restoring termios speed
Date:   Wed, 24 Nov 2021 12:54:56 +0100
Message-Id: <20211124115712.126766727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 027b57170bf8bb6999a28e4a5f3d78bf1db0f90c upstream.

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
---
 drivers/tty/serial/serial_core.c |   16 ++++++++++++++--
 include/linux/console.h          |    2 ++
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -232,7 +232,11 @@ static int uart_port_startup(struct tty_
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
@@ -300,8 +304,11 @@ static void uart_shutdown(struct tty_str
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
@@ -2076,8 +2083,11 @@ uart_set_options(struct uart_port *port,
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
@@ -2211,6 +2221,8 @@ int uart_resume_port(struct uart_driver
 		 */
 		memset(&termios, 0, sizeof(struct ktermios));
 		termios.c_cflag = uport->cons->cflag;
+		termios.c_ispeed = uport->cons->ispeed;
+		termios.c_ospeed = uport->cons->ospeed;
 
 		/*
 		 * If that's unset, use the tty termios setting.
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -145,6 +145,8 @@ struct console {
 	short	flags;
 	short	index;
 	int	cflag;
+	uint	ispeed;
+	uint	ospeed;
 	void	*data;
 	struct	 console *next;
 };


