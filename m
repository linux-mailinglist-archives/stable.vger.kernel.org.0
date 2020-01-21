Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C9B14377B
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 08:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgAUHRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 02:17:23 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59997 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUHRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 02:17:23 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1itnmm-0000az-78; Tue, 21 Jan 2020 08:17:16 +0100
Received: from ukl by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1itnmk-0005Fy-Au; Tue, 21 Jan 2020 08:17:14 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andre Renaud <arenaud@designa-electronics.com>,
        Fabio Estevam <festevam@gmail.com>,
        Andy Duan <fugang.duan@nxp.com>
Cc:     linux-imx@nxp.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] serial: imx: fix a race condition in receive path
Date:   Tue, 21 Jan 2020 08:17:02 +0100
Message-Id: <20200121071702.20150-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200120211232.21329-1-u.kleine-koenig@pengutronix.de>
References: <20200120211232.21329-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The main irq handler function starts by first masking disabled
interrupts in the status register values to ensure to only handle
enabled interrupts. This is important as when the RX path in the
hardware is disabled reading the RX fifo results in an external abort.

This checking must be done under the port lock, otherwise the following
can happen:

     CPU1                            | CPU2
                                     |
     irq triggers as there are chars |
     in the RX fifo                  |
				     | grab port lock
     imx_uart_int finds RRDY enabled |
     and calls imx_uart_rxint which  |
     has to wait for port lock       |
                                     | disable RX (e.g. because we're
                                     | using RS485 with !RX_DURING_TX)
                                     |
                                     | release port lock
     read from RX fifo with RX       |
     disabled => exception           |

So take the port lock only once in imx_uart_int() instead of in the
functions called from there.

Reported-by: Andre Renaud <arenaud@designa-electronics.com>
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Changes since v1, sent with
Message-Id: <20200120211232.21329-1-u.kleine-koenig@pengutronix.de>:

 - Fix
	drivers/tty/serial/imx.c:812:19: warning: unused variable 'port' [-Wunused-variable]

 drivers/tty/serial/imx.c | 51 ++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a9e20e6c63ad..dd3120c5db2b 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -700,22 +700,33 @@ static void imx_uart_start_tx(struct uart_port *port)
 	}
 }
 
-static irqreturn_t imx_uart_rtsint(int irq, void *dev_id)
+static irqreturn_t __imx_uart_rtsint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
 	u32 usr1;
 
-	spin_lock(&sport->port.lock);
-
 	imx_uart_writel(sport, USR1_RTSD, USR1);
 	usr1 = imx_uart_readl(sport, USR1) & USR1_RTSS;
 	uart_handle_cts_change(&sport->port, !!usr1);
 	wake_up_interruptible(&sport->port.state->port.delta_msr_wait);
 
-	spin_unlock(&sport->port.lock);
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t imx_uart_rtsint(int irq, void *dev_id)
+{
+	struct imx_port *sport = dev_id;
+	irqreturn_t ret;
+
+	spin_lock(&sport->port.lock);
+
+	ret = __imx_uart_rtsint(irq, dev_id);
+
+	spin_unlock(&sport->port.lock);
+
+	return ret;
+}
+
 static irqreturn_t imx_uart_txint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
@@ -726,14 +737,12 @@ static irqreturn_t imx_uart_txint(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t imx_uart_rxint(int irq, void *dev_id)
+static irqreturn_t __imx_uart_rxint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
 	unsigned int rx, flg, ignored = 0;
 	struct tty_port *port = &sport->port.state->port;
 
-	spin_lock(&sport->port.lock);
-
 	while (imx_uart_readl(sport, USR2) & USR2_RDR) {
 		u32 usr2;
 
@@ -792,11 +801,25 @@ static irqreturn_t imx_uart_rxint(int irq, void *dev_id)
 	}
 
 out:
-	spin_unlock(&sport->port.lock);
 	tty_flip_buffer_push(port);
+
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t imx_uart_rxint(int irq, void *dev_id)
+{
+	struct imx_port *sport = dev_id;
+	irqreturn_t ret;
+
+	spin_lock(&sport->port.lock);
+
+	ret = __imx_uart_rxint(irq, dev_id);
+
+	spin_unlock(&sport->port.lock);
+
+	return ret;
+}
+
 static void imx_uart_clear_rx_errors(struct imx_port *sport);
 
 /*
@@ -855,6 +878,8 @@ static irqreturn_t imx_uart_int(int irq, void *dev_id)
 	unsigned int usr1, usr2, ucr1, ucr2, ucr3, ucr4;
 	irqreturn_t ret = IRQ_NONE;
 
+	spin_lock(&sport->port.lock);
+
 	usr1 = imx_uart_readl(sport, USR1);
 	usr2 = imx_uart_readl(sport, USR2);
 	ucr1 = imx_uart_readl(sport, UCR1);
@@ -888,27 +913,25 @@ static irqreturn_t imx_uart_int(int irq, void *dev_id)
 		usr2 &= ~USR2_ORE;
 
 	if (usr1 & (USR1_RRDY | USR1_AGTIM)) {
-		imx_uart_rxint(irq, dev_id);
+		__imx_uart_rxint(irq, dev_id);
 		ret = IRQ_HANDLED;
 	}
 
 	if ((usr1 & USR1_TRDY) || (usr2 & USR2_TXDC)) {
-		imx_uart_txint(irq, dev_id);
+		imx_uart_transmit_buffer(sport);
 		ret = IRQ_HANDLED;
 	}
 
 	if (usr1 & USR1_DTRD) {
 		imx_uart_writel(sport, USR1_DTRD, USR1);
 
-		spin_lock(&sport->port.lock);
 		imx_uart_mctrl_check(sport);
-		spin_unlock(&sport->port.lock);
 
 		ret = IRQ_HANDLED;
 	}
 
 	if (usr1 & USR1_RTSD) {
-		imx_uart_rtsint(irq, dev_id);
+		__imx_uart_rtsint(irq, dev_id);
 		ret = IRQ_HANDLED;
 	}
 
@@ -923,6 +946,8 @@ static irqreturn_t imx_uart_int(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
+	spin_unlock(&sport->port.lock);
+
 	return ret;
 }
 
-- 
2.25.0

