Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F663C4B33
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhGLG4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240797AbhGLGxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5391C610CD;
        Mon, 12 Jul 2021 06:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072659;
        bh=JQwM40WNdPqzcQ7fMsFA9WLHrmw7Mf8lh8qEUkgf8Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBFtt5O/yvOotpIutXcyys4AL8DFCCDlwi05qjwj5q0JLEQvJqSvflqUVxozT1T7m
         ooyS27Cwtoyw5wR49pn3nAFmLl3l1TxdB9UnKlyi6W20ZnDPhSm1pkfs0OfFKmHsbt
         sZDMGpZ+tZRApZAPJUgiOUOIVzYfO7SzA5RWrijc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 528/593] serial: 8250: Actually allow UPF_MAGIC_MULTIPLIER baud rates
Date:   Mon, 12 Jul 2021 08:11:28 +0200
Message-Id: <20210712060951.329572417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 78bcae8616ac277d6cb7f38e211493948ed73e30 ]

Support for magic baud rate divisors of 32770 and 32769 used with SMSC
Super I/O chips for extra baud rates of 230400 and 460800 respectively
where base rate is 115200[1] has been added around Linux 2.5.64, which
predates our repo history, but the origin could be identified as commit
2a717aad772f ("Merge with Linux 2.5.64.") with the old MIPS/Linux repo
also at: <git://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git>.

Code that is now in `serial8250_do_get_divisor' was added back then to
`serial8250_get_divisor', but that code would only ever trigger if one
of the higher baud rates was actually requested, and that cannot ever
happen, because the earlier call to `serial8250_get_baud_rate' never
returns them.  This is because it calls `uart_get_baud_rate' with the
maximum requested being the base rate, that is clk/16 or 115200 for SMSC
chips at their nominal clock rate.

Fix it then and allow UPF_MAGIC_MULTIPLIER baud rates to be selected, by
requesting the maximum baud rate of clk/4 rather than clk/16 if the flag
has been set.  Also correct the minimum baud rate, observing that these
ports only support actual (non-magic) divisors of up to 32767 only.


[1] "FDC37M81x, PC98/99 Compliant Enhanced Super I/O Controller with
    Keyboard/Mouse Wake-Up", Standard Microsystems Corporation, Rev.
    03/27/2000, Table 31 - "Baud Rates", p. 77

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2105190412280.29169@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 6e141429c980..6d9c494bed7d 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2635,6 +2635,21 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
 					     struct ktermios *old)
 {
 	unsigned int tolerance = port->uartclk / 100;
+	unsigned int min;
+	unsigned int max;
+
+	/*
+	 * Handle magic divisors for baud rates above baud_base on SMSC
+	 * Super I/O chips.  Enable custom rates of clk/4 and clk/8, but
+	 * disable divisor values beyond 32767, which are unavailable.
+	 */
+	if (port->flags & UPF_MAGIC_MULTIPLIER) {
+		min = port->uartclk / 16 / UART_DIV_MAX >> 1;
+		max = (port->uartclk + tolerance) / 4;
+	} else {
+		min = port->uartclk / 16 / UART_DIV_MAX;
+		max = (port->uartclk + tolerance) / 16;
+	}
 
 	/*
 	 * Ask the core to calculate the divisor for us.
@@ -2642,9 +2657,7 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
 	 * slower than nominal still match standard baud rates without
 	 * causing transmission errors.
 	 */
-	return uart_get_baud_rate(port, termios, old,
-				  port->uartclk / 16 / UART_DIV_MAX,
-				  (port->uartclk + tolerance) / 16);
+	return uart_get_baud_rate(port, termios, old, min, max);
 }
 
 /*
-- 
2.30.2



