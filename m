Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDC7451345
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347983AbhKOTte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245538AbhKOTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA1C63273;
        Mon, 15 Nov 2021 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001397;
        bh=6wigUDftue6ESw8/GhTsQCB/PTXBa0z/UrYpA7Uwcm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NL9DV9q67QqQfE+kvyzIuVsL4SSm7mGj98ZrneU/2zsu9AwcR9cM77e1q7ElFO5W
         tQTDyjrP83SRHovTZzbdT8J/U/mQ9cl63AeiAdWNMBrc/8tguYZMEf6C3kTE4YxWwX
         KkwAfAHSplveiGRBsp/SPvT0qx9wvIfIgxfzchkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 176/917] Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed field"
Date:   Mon, 15 Nov 2021 17:54:31 +0100
Message-Id: <20211115165434.740019460@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d02b006b29de14968ba4afa998bede0d55469e29 upstream.

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
 drivers/tty/serial/8250/8250_port.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2584,19 +2584,6 @@ static unsigned int serial8250_get_divis
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
@@ -2738,14 +2725,11 @@ void serial8250_update_uartclk(struct ua
 
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
@@ -2779,7 +2763,6 @@ serial8250_do_set_termios(struct uart_po
 
 	baud = serial8250_get_baud_rate(port, termios, old);
 	quot = serial8250_get_divisor(port, baud, &frac);
-	baud = serial8250_compute_baud_rate(port, quot);
 
 	/*
 	 * Ok, we're now changing the port state.  Do it with


