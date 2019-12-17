Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D16122CC3
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfLQNTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 08:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfLQNTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 08:19:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 302E020716;
        Tue, 17 Dec 2019 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576588784;
        bh=v6EqHX14jEFJF9s/HmLSW/tksnZaFXnDrRA9SPtBpYI=;
        h=Subject:To:From:Date:From;
        b=cCEr4zwiMKVrnH6rbhyc5iKA8IHfO1CouenuTQ5cWYCZ1lwgUwn5N1HXFM7DSnhpl
         0hkEbQ30MpjjKtE8/sJnj1/Qm2f1rFM24DTVs64FVw4VIQ2/WRyJZzUvkNKq8/bRsS
         NKm9hLvRx0MT4q9XKgcTJlIdEyfrvDBOd7f2Oa0Q=
Subject: patch "tty/serial: atmel: fix out of range clock divider handling" added to tty-linus
To:     david.engraf@sysgo.com, gregkh@linuxfoundation.org,
        ludovic.desroches@microchip.com, richard.genoud@gmail.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 14:19:42 +0100
Message-ID: <1576588782114140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty/serial: atmel: fix out of range clock divider handling

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cb47b9f8630ae3fa3f5fbd0c7003faba7abdf711 Mon Sep 17 00:00:00 2001
From: David Engraf <david.engraf@sysgo.com>
Date: Mon, 16 Dec 2019 09:54:03 +0100
Subject: tty/serial: atmel: fix out of range clock divider handling

Use MCK_DIV8 when the clock divider is > 65535. Unfortunately the mode
register was already written thus the clock selection is ignored.

Fix by doing the baud rate calulation before setting the mode.

Fixes: 5bf5635ac170 ("tty/serial: atmel: add fractional baud rate support")
Signed-off-by: David Engraf <david.engraf@sysgo.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191216085403.17050-1-david.engraf@sysgo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c | 43 ++++++++++++++++---------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a8dc8af83f39..1ba9bc667e13 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2270,27 +2270,6 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 		mode |= ATMEL_US_USMODE_NORMAL;
 	}
 
-	/* set the mode, clock divisor, parity, stop bits and data size */
-	atmel_uart_writel(port, ATMEL_US_MR, mode);
-
-	/*
-	 * when switching the mode, set the RTS line state according to the
-	 * new mode, otherwise keep the former state
-	 */
-	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
-		unsigned int rts_state;
-
-		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
-			/* let the hardware control the RTS line */
-			rts_state = ATMEL_US_RTSDIS;
-		} else {
-			/* force RTS line to low level */
-			rts_state = ATMEL_US_RTSEN;
-		}
-
-		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
-	}
-
 	/*
 	 * Set the baud rate:
 	 * Fractional baudrate allows to setup output frequency more
@@ -2317,6 +2296,28 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (!(port->iso7816.flags & SER_ISO7816_ENABLED))
 		atmel_uart_writel(port, ATMEL_US_BRGR, quot);
+
+	/* set the mode, clock divisor, parity, stop bits and data size */
+	atmel_uart_writel(port, ATMEL_US_MR, mode);
+
+	/*
+	 * when switching the mode, set the RTS line state according to the
+	 * new mode, otherwise keep the former state
+	 */
+	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
+		unsigned int rts_state;
+
+		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
+			/* let the hardware control the RTS line */
+			rts_state = ATMEL_US_RTSDIS;
+		} else {
+			/* force RTS line to low level */
+			rts_state = ATMEL_US_RTSEN;
+		}
+
+		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
+	}
+
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_TXEN | ATMEL_US_RXEN);
 	atmel_port->tx_stopped = false;
-- 
2.24.1


