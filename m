Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC1E14E2C1
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgA3Sya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgA3SkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FDEA22522;
        Thu, 30 Jan 2020 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409606;
        bh=DspzJDUHTXPx0jz/6oKJEFjHGQ/zjLf7xzoZQN8szFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQw5w91cD41etikzG8rYJyLKH8n/jT+Lz4QRjPWG6VYbfl+yhRgA/8QzaXWg9Wn6Q
         N8hNPoqQGGiC1YM7H36+w+swuwgTKtsAMgObLug8haVXIfvsDgy5SEpT1VRkjN8xdL
         y982vXLV0iS+1a9qGl6zEAIWzymCrs80Y1CdYRYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andre Renaud <arenaud@designa-electronics.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5.5 18/56] serial: imx: fix a race condition in receive path
Date:   Thu, 30 Jan 2020 19:38:35 +0100
Message-Id: <20200130183612.561249887@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 101aa46bd221b768dfff8ef3745173fc8dbb85ee upstream.

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
Link: https://lore.kernel.org/r/20200121071702.20150-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |   51 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -700,22 +700,33 @@ static void imx_uart_start_tx(struct uar
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
@@ -726,14 +737,12 @@ static irqreturn_t imx_uart_txint(int ir
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
 
@@ -792,11 +801,25 @@ static irqreturn_t imx_uart_rxint(int ir
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
@@ -855,6 +878,8 @@ static irqreturn_t imx_uart_int(int irq,
 	unsigned int usr1, usr2, ucr1, ucr2, ucr3, ucr4;
 	irqreturn_t ret = IRQ_NONE;
 
+	spin_lock(&sport->port.lock);
+
 	usr1 = imx_uart_readl(sport, USR1);
 	usr2 = imx_uart_readl(sport, USR2);
 	ucr1 = imx_uart_readl(sport, UCR1);
@@ -888,27 +913,25 @@ static irqreturn_t imx_uart_int(int irq,
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
 
@@ -923,6 +946,8 @@ static irqreturn_t imx_uart_int(int irq,
 		ret = IRQ_HANDLED;
 	}
 
+	spin_unlock(&sport->port.lock);
+
 	return ret;
 }
 


