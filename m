Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D5232B247
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbhCCAxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1580921AbhCBSW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 13:22:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE8560295;
        Tue,  2 Mar 2021 18:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614709304;
        bh=ISDrXxWHSH+zFovoD5AGTuD09XaOpEusjNmd/Hylyis=;
        h=Subject:To:From:Date:From;
        b=sPvRACaVTTwR0D6ZIs/ao45KxTG+TvCsWnptHMFf8nhZXsr6g8P7k98MguFy/EUrp
         /pmuVhcLpQYYJ8rfO6JE056M6nY/RqgREn1Ypm0lvZiAe78+JG0OgRyWIdpIDf1ydZ
         dpmZCNXPTx64jJJtVwcLU1TU4xhLdjNXozeBoaqY=
Subject: patch "Revert "serial: max310x: rework RX interrupt handling"" added to tty-linus
To:     shc_work@mail.ru, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, thomas.petazzoni@bootlin.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 19:21:42 +0100
Message-ID: <1614709302126254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: max310x: rework RX interrupt handling"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 511a9d5dc2d4d541704d25faf7f6fc2a71a2fd9d Mon Sep 17 00:00:00 2001
From: Alexander Shiyan <shc_work@mail.ru>
Date: Wed, 17 Feb 2021 11:06:08 +0300
Subject: Revert "serial: max310x: rework RX interrupt handling"

This reverts commit fce3c5c1a2d9cd888f2987662ce17c0c651916b2.

FIFO is triggered 4 intervals after receiving a byte, it's good
when we don't care about the time of reception, but are only
interested in the presence of any activity on the line.
Unfortunately, this method is not suitable for all tasks,
for example, the RS-485 protocol will not work properly,
since the state machine must track the request-response time
and after the timeout expires, a decision is made that the device
on the line is not responding.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Link: https://lore.kernel.org/r/20210217080608.31192-1-shc_work@mail.ru
Fixes: fce3c5c1a2d9 ("serial: max310x: rework RX interrupt handling")
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 9795b2e8b0b2..1b61d26bb7af 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1056,9 +1056,9 @@ static int max310x_startup(struct uart_port *port)
 	max310x_port_update(port, MAX310X_MODE1_REG,
 			    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);
 
-	/* Reset FIFOs */
-	max310x_port_write(port, MAX310X_MODE2_REG,
-			   MAX310X_MODE2_FIFORST_BIT);
+	/* Configure MODE2 register & Reset FIFOs*/
+	val = MAX310X_MODE2_RXEMPTINV_BIT | MAX310X_MODE2_FIFORST_BIT;
+	max310x_port_write(port, MAX310X_MODE2_REG, val);
 	max310x_port_update(port, MAX310X_MODE2_REG,
 			    MAX310X_MODE2_FIFORST_BIT, 0);
 
@@ -1086,27 +1086,8 @@ static int max310x_startup(struct uart_port *port)
 	/* Clear IRQ status register */
 	max310x_port_read(port, MAX310X_IRQSTS_REG);
 
-	/*
-	 * Let's ask for an interrupt after a timeout equivalent to
-	 * the receiving time of 4 characters after the last character
-	 * has been received.
-	 */
-	max310x_port_write(port, MAX310X_RXTO_REG, 4);
-
-	/*
-	 * Make sure we also get RX interrupts when the RX FIFO is
-	 * filling up quickly, so get an interrupt when half of the RX
-	 * FIFO has been filled in.
-	 */
-	max310x_port_write(port, MAX310X_FIFOTRIGLVL_REG,
-			   MAX310X_FIFOTRIGLVL_RX(MAX310X_FIFO_SIZE / 2));
-
-	/* Enable RX timeout interrupt in LSR */
-	max310x_port_write(port, MAX310X_LSR_IRQEN_REG,
-			   MAX310X_LSR_RXTO_BIT);
-
-	/* Enable LSR, RX FIFO trigger, CTS change interrupts */
-	val = MAX310X_IRQ_LSR_BIT  | MAX310X_IRQ_RXFIFO_BIT | MAX310X_IRQ_TXEMPTY_BIT;
+	/* Enable RX, TX, CTS change interrupts */
+	val = MAX310X_IRQ_RXEMPTY_BIT | MAX310X_IRQ_TXEMPTY_BIT;
 	max310x_port_write(port, MAX310X_IRQEN_REG, val | MAX310X_IRQ_CTS_BIT);
 
 	return 0;
-- 
2.30.1


