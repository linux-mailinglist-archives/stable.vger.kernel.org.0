Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3665B2A9963
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKFQXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKFQXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 11:23:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FB02151B;
        Fri,  6 Nov 2020 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604679796;
        bh=SdAYGB8CPdfKHrDNEAuthq9jWMzapE/eXevqi1RH4V8=;
        h=Subject:To:From:Date:From;
        b=M17nO7t60Y55DxZsSElgbp+otzae8wL7BrqdnpI8vz0vsHKy2Q3TDzK974oCKNAn+
         FvkYjN5Ehv5DzHkUTGRhBZUaerz2dHf+bIFJpmpWEgp5C7AycrJbyJFP8UYAF5V4PQ
         JM6Wb2z0rNwUZ1LQ5tXu6Fo7AK0OnuCkrDk4uA1Y=
Subject: patch "serial: 8250_mtk: Fix uart_get_baud_rate warning" added to tty-linus
To:     tientzu@chromium.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 17:24:02 +0100
Message-ID: <160467984279206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_mtk: Fix uart_get_baud_rate warning

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 912ab37c798770f21b182d656937072b58553378 Mon Sep 17 00:00:00 2001
From: Claire Chang <tientzu@chromium.org>
Date: Mon, 2 Nov 2020 20:07:49 +0800
Subject: serial: 8250_mtk: Fix uart_get_baud_rate warning

Mediatek 8250 port supports speed higher than uartclk / 16. If the baud
rates in both the new and the old termios setting are higher than
uartclk / 16, the WARN_ON in uart_get_baud_rate() will be triggered.
Passing NULL as the old termios so uart_get_baud_rate() will use
uartclk / 16 - 1 as the new baud rate which will be replaced by the
original baud rate later by tty_termios_encode_baud_rate() in
mtk8250_set_termios().

Fixes: 551e553f0d4a ("serial: 8250_mtk: Fix high-speed baud rates clamping")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Link: https://lore.kernel.org/r/20201102120749.374458-1-tientzu@chromium.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index 41f4120abdf2..fa876e2c13e5 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -317,7 +317,7 @@ mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	 */
 	baud = tty_termios_baud_rate(termios);
 
-	serial8250_do_set_termios(port, termios, old);
+	serial8250_do_set_termios(port, termios, NULL);
 
 	tty_termios_encode_baud_rate(termios, baud, baud);
 
-- 
2.29.2


