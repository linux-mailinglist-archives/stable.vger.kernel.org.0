Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE545DFF8
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbhKYRuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243657AbhKYRsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 12:48:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 181B26112E;
        Thu, 25 Nov 2021 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637862294;
        bh=4Vn35Pzp4d6yF3CRQ4ZWZdQJ/igkvJCi+qeqXauwy84=;
        h=Subject:To:From:Date:From;
        b=nRH9JCxWXRMpHcIB7O2Fn3BFgMukryntYQM74RDyGVsILQeeoJtL1HTWbqZVyyr6O
         Hi2MgNdGYYolXzolj1zU1h8Rz4xwzFwmWlmVuZ8ElmdejVfb4udofPVDwXIlWFPiqR
         T83cVpJrtB6QpNPdacYIwWhBVCNXoAXdAMItV/6E=
Subject: patch "serial: 8250_pci: rewrite pericom_do_set_divisor()" added to tty-linus
To:     jay.dolan@accesio.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Nov 2021 18:42:29 +0100
Message-ID: <1637862149167146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_pci: rewrite pericom_do_set_divisor()

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bb1201d4b38ec67bd9a871cf86b0cc10f28b15b5 Mon Sep 17 00:00:00 2001
From: Jay Dolan <jay.dolan@accesio.com>
Date: Mon, 22 Nov 2021 14:06:04 +0200
Subject: serial: 8250_pci: rewrite pericom_do_set_divisor()

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
 drivers/tty/serial/8250/8250_pci.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index b793d848aeb6..60f8fffdfd77 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1324,29 +1324,33 @@ pericom_do_set_divisor(struct uart_port *port, unsigned int baud,
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
-- 
2.34.0


