Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5785642554C
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 16:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhJGOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 10:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241688AbhJGOY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 10:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0839D61029;
        Thu,  7 Oct 2021 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633616583;
        bh=cDImrHkODIjoZYTu7Fo7pz+mDtNH2oOBxxOOoeVLwrU=;
        h=Subject:To:From:Date:From;
        b=j34nOeDGg4LmINm0IH8ws4I2tBe/iq24Lsf1U/vRUYqBhItbVWY+arrFdAHdLcqUf
         lyUahCS8H5qd9B7S8EogpKGOqZcjK8SZYWA3sz3WtuB/BSAdwWw6/LOYLeDvMmKi0T
         fC5nQu4yM0z8S+Q+QFKET6HpdWqreh0I7ATSxxhc=
Subject: patch "Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed" added to tty-testing
To:     johan@kernel.org, gregkh@linuxfoundation.org, pali@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Oct 2021 16:23:01 +0200
Message-ID: <163361658180179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From d02b006b29de14968ba4afa998bede0d55469e29 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 7 Oct 2021 15:31:46 +0200
Subject: Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed
 field"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit 32262e2e429cdb31f9e957e997d53458762931b7.

The commit in question claims to determine the inverse of
serial8250_get_divisor() but failed to notice that some drivers override
the default implementation using a get_divisor() callback.

This means that the computed line-speed values can be completely wrong
and results in regular TCSETS requests failing (the incorrect values
would also be passed to any overridden set_divisor() callback).

Similarly, it also failed to honour the old (deprecated) ASYNC_SPD_FLAGS
and would break applications relying on those when re-encoding the
actual line speed.

There are also at least two quirks, UART_BUG_QUOT and an OMAP1510
workaround, which were happily ignored and that are now broken.

Finally, even if the offending commit were to be implemented correctly,
this is a new feature and not something which should be backported to
stable.

Cc: Pali Rohár <pali@kernel.org>
Fixes: 32262e2e429c ("serial: 8250: Fix reporting real baudrate value in c_ospeed field")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211007133146.28949-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index dc6900b2daa8..66374704747e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2584,19 +2584,6 @@ static unsigned int serial8250_get_divisor(struct uart_port *port,
 	return serial8250_do_get_divisor(port, baud, frac);
 }
 
-static unsigned int serial8250_compute_baud_rate(struct uart_port *port,
-						 unsigned int quot)
-{
-	if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8001)
-		return port->uartclk / 4;
-	else if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8002)
-		return port->uartclk / 8;
-	else if (port->type == PORT_NPCM)
-		return DIV_ROUND_CLOSEST(port->uartclk - 2 * (quot + 2), 16 * (quot + 2));
-	else
-		return DIV_ROUND_CLOSEST(port->uartclk, 16 * quot);
-}
-
 static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 					    tcflag_t c_cflag)
 {
@@ -2727,14 +2714,11 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
-	baud = serial8250_compute_baud_rate(port, quot);
 
 	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
-	if (tty_termios_baud_rate(termios))
-		tty_termios_encode_baud_rate(termios, baud, baud);
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
@@ -2766,7 +2750,6 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	baud = serial8250_get_baud_rate(port, termios, old);
 	quot = serial8250_get_divisor(port, baud, &frac);
-	baud = serial8250_compute_baud_rate(port, quot);
 
 	/*
 	 * Ok, we're now changing the port state.  Do it with
-- 
2.33.0


