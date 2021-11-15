Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CB4452190
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbhKPBFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245541AbhKOTUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7183863285;
        Mon, 15 Nov 2021 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001394;
        bh=Nmz4VyTXKSFV24VeiDop/P5upM2q6TSxs0qacMal3Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffizQ45i+KHjFuOz55nT6kM5ofiuY2kt62x3eNEN1ndcxsYBU7qSAvMqAeBDIhT7E
         o7YGQT5jbKAB3YlXV0AcNXmjqLMB3OtD1dowL0vF9rylTbnYRGvdVzu0j5rBPz0KZZ
         oB5xDuB53ihG6bGfjUvPbSb0pkuabXi9CEcb1hTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.15 175/917] serial: 8250: Fix reporting real baudrate value in c_ospeed field
Date:   Mon, 15 Nov 2021 17:54:30 +0100
Message-Id: <20211115165434.707185250@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

commit 32262e2e429cdb31f9e957e997d53458762931b7 upstream.

In most cases it is not possible to set exact baudrate value to hardware.

So fix reporting real baudrate value which was set to hardware via c_ospeed
termios field. It can be retrieved by ioctl(TCGETS2) from userspace.

Real baudrate value is calculated from chosen hardware divisor and base
clock. It is implemented in a new function serial8250_compute_baud_rate()
which is inverse of serial8250_get_divisor() function.

With this change is fixed also UART timeout value (it is updated via
uart_update_timeout() function), which is calculated from the now fixed
baudrate value too.

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210927093704.19768-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2584,6 +2584,19 @@ static unsigned int serial8250_get_divis
 	return serial8250_do_get_divisor(port, baud, frac);
 }
 
+static unsigned int serial8250_compute_baud_rate(struct uart_port *port,
+						 unsigned int quot)
+{
+	if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8001)
+		return port->uartclk / 4;
+	else if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8002)
+		return port->uartclk / 8;
+	else if (port->type == PORT_NPCM)
+		return DIV_ROUND_CLOSEST(port->uartclk - 2 * (quot + 2), 16 * (quot + 2));
+	else
+		return DIV_ROUND_CLOSEST(port->uartclk, 16 * quot);
+}
+
 static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 					    tcflag_t c_cflag)
 {
@@ -2725,11 +2738,14 @@ void serial8250_update_uartclk(struct ua
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
+	baud = serial8250_compute_baud_rate(port, quot);
 
 	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
@@ -2763,6 +2779,7 @@ serial8250_do_set_termios(struct uart_po
 
 	baud = serial8250_get_baud_rate(port, termios, old);
 	quot = serial8250_get_divisor(port, baud, &frac);
+	baud = serial8250_compute_baud_rate(port, quot);
 
 	/*
 	 * Ok, we're now changing the port state.  Do it with


