Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F1469F79
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391103AbhLFPpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48954 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376296AbhLFPd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED5C6133C;
        Mon,  6 Dec 2021 15:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7138AC34902;
        Mon,  6 Dec 2021 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804596;
        bh=b9hSnik2Nr6mPn2zRPr+Twdy9HcRDoOkiTuSNVZv4AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhaIpV5QwLgN6GBqTXwYP4/vtohpOiG9xbH7zqWawVx2Kr+/nYf3MX4jTx8jiHT0L
         MU3Gg3XIWLzp/dGBSZdWxmbs/r+cx1LfYjErRXFKWg9PnZVYN/tpieLDXilJOStPtl
         LXsgOITH4y3wCnVSvS7GWhVm0w9fFqwe25dO1OnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Dolan <jay.dolan@accesio.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 202/207] serial: 8250_pci: rewrite pericom_do_set_divisor()
Date:   Mon,  6 Dec 2021 15:57:36 +0100
Message-Id: <20211206145617.278002001@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Dolan <jay.dolan@accesio.com>

commit bb1201d4b38ec67bd9a871cf86b0cc10f28b15b5 upstream.

Have pericom_do_set_divisor() use the uartclk instead of a hard coded
value to work with different speed crystals. Tested with 14.7456 and 24
MHz crystals.

Have pericom_do_set_divisor() always calculate the divisor rather than
call serial8250_do_set_divisor() for rates below baud_base.

Do not write registers or call serial8250_do_set_divisor() if valid
divisors could not be found.

Fixes: 6bf4e42f1d19 ("serial: 8250: Add support for higher baud rates to Pericom chips")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jay Dolan <jay.dolan@accesio.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211122120604.3909-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1349,29 +1349,33 @@ pericom_do_set_divisor(struct uart_port
 {
 	int scr;
 	int lcr;
-	int actual_baud;
-	int tolerance;
 
-	for (scr = 5 ; scr <= 15 ; scr++) {
-		actual_baud = 921600 * 16 / scr;
-		tolerance = actual_baud / 50;
+	for (scr = 16; scr > 4; scr--) {
+		unsigned int maxrate = port->uartclk / scr;
+		unsigned int divisor = max(maxrate / baud, 1U);
+		int delta = maxrate / divisor - baud;
 
-		if ((baud < actual_baud + tolerance) &&
-			(baud > actual_baud - tolerance)) {
+		if (baud > maxrate + baud / 50)
+			continue;
 
+		if (delta > baud / 50)
+			divisor++;
+
+		if (divisor > 0xffff)
+			continue;
+
+		/* Update delta due to possible divisor change */
+		delta = maxrate / divisor - baud;
+		if (abs(delta) < baud / 50) {
 			lcr = serial_port_in(port, UART_LCR);
 			serial_port_out(port, UART_LCR, lcr | 0x80);
-
-			serial_port_out(port, UART_DLL, 1);
-			serial_port_out(port, UART_DLM, 0);
+			serial_port_out(port, UART_DLL, divisor & 0xff);
+			serial_port_out(port, UART_DLM, divisor >> 8 & 0xff);
 			serial_port_out(port, 2, 16 - scr);
 			serial_port_out(port, UART_LCR, lcr);
 			return;
-		} else if (baud > actual_baud) {
-			break;
 		}
 	}
-	serial8250_do_set_divisor(port, baud, quot, quot_frac);
 }
 static int pci_pericom_setup(struct serial_private *priv,
 		  const struct pciserial_board *board,


