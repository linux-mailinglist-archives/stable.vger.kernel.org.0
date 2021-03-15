Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53033BA1C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhCOOIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhCOOCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5AD64EF1;
        Mon, 15 Mar 2021 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816944;
        bh=wYn9ekKjGJS6jyTe0348dfUT899Q5inpi3XsKOBw0Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLnEXFTZmjRHnmh8iF7i+5cDfvN/gxM0HYXxSl2+3NtHfl5wbDy6raRCfltcZFVSK
         gyTYY7sD0VbOSRBvV7CZs6xV3IAzHPcLe8A6/9NRx+5HZprj3ZJ6NHTb0j+HdLvz7w
         t4aeUoFz2YOBW6L5jt4/53f8dWxu4A6ZnRv69DlA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 5.11 218/306] Revert "serial: max310x: rework RX interrupt handling"
Date:   Mon, 15 Mar 2021 14:54:41 +0100
Message-Id: <20210315135514.986319633@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alexander Shiyan <shc_work@mail.ru>

commit 2334de198fed3da72e9785ecdd691d101aa96e77 upstream.

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
 drivers/tty/serial/max310x.c |   29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1056,9 +1056,9 @@ static int max310x_startup(struct uart_p
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
 
@@ -1086,27 +1086,8 @@ static int max310x_startup(struct uart_p
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


