Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0453CDDEE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345005AbhGSPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344299AbhGSO7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286A86124B;
        Mon, 19 Jul 2021 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709176;
        bh=ppXR8ltNU7s8CedI67fAiIUmh+fxPgkzVoQ0NtumQyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCD5Evkv68sYenjvbECUVVq4hjJVNZ/XvdiqfTmEL3s1QHB/4KrCv+jA6iWgB9WR4
         sQOQ+L+V6aArC5wzoCF7W34yB+p3Z/XeU4BAnSr6twXpbucGHAXBMhIjwCYrjZwHsl
         ioW9AcWB3bF5CxnCs4BE07trDrG5UJxDMpB5HHqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 281/421] serial: mvebu-uart: clarify the baud rate derivation
Date:   Mon, 19 Jul 2021 16:51:32 +0200
Message-Id: <20210719144956.089384852@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 0e4cf69ede8751d25f733cd7a6f954c5b505fa03 upstream.

The current comment in ->set_baud_rate() is rather incomplete as it
fails to describe what are the actual stages for the baudrate
derivation. Replace this comment with something more explicit and
close to the functional specification. Also adapt the variable names
to it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mvebu-uart.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -72,6 +72,7 @@
 #define  BRDV_BAUD_MASK         0x3FF
 
 #define UART_OSAMP		0x14
+#define  OSAMP_DEFAULT_DIVISOR	16
 
 #define MVEBU_NR_UARTS		2
 
@@ -444,23 +445,28 @@ static void mvebu_uart_shutdown(struct u
 static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
 	struct mvebu_uart *mvuart = to_mvuart(port);
-	unsigned int baud_rate_div;
+	unsigned int d_divisor, m_divisor;
 	u32 brdv;
 
 	if (IS_ERR(mvuart->clk))
 		return -PTR_ERR(mvuart->clk);
 
 	/*
-	 * The UART clock is divided by the value of the divisor to generate
-	 * UCLK_OUT clock, which is 16 times faster than the baudrate.
-	 * This prescaler can achieve all standard baudrates until 230400.
-	 * Higher baudrates could be achieved for the extended UART by using the
-	 * programmable oversampling stack (also called fractional divisor).
+	 * The baudrate is derived from the UART clock thanks to two divisors:
+	 *   > D ("baud generator"): can divide the clock from 2 to 2^10 - 1.
+	 *   > M ("fractional divisor"): allows a better accuracy for
+	 *     baudrates higher than 230400.
+	 *
+	 * As the derivation of M is rather complicated, the code sticks to its
+	 * default value (x16) when all the prescalers are zeroed, and only
+	 * makes use of D to configure the desired baudrate.
 	 */
-	baud_rate_div = DIV_ROUND_UP(port->uartclk, baud * 16);
+	m_divisor = OSAMP_DEFAULT_DIVISOR;
+	d_divisor = DIV_ROUND_UP(port->uartclk, baud * m_divisor);
+
 	brdv = readl(port->membase + UART_BRDV);
 	brdv &= ~BRDV_BAUD_MASK;
-	brdv |= baud_rate_div;
+	brdv |= d_divisor;
 	writel(brdv, port->membase + UART_BRDV);
 
 	return 0;


