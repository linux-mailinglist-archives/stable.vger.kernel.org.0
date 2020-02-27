Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE9F17201A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbgB0NxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730848AbgB0NxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A96F21D7E;
        Thu, 27 Feb 2020 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811592;
        bh=WJTTeYFlJE9QSkAJVQ5AUme3l7PlwYgX7y3eaAQpA3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffd09K57IOKb8NM7kETCAXUeYTekhBoCcKR3wRJfYxevJNcnxprZxiRsCcpIT+g4p
         y3/0mA2C2CoCcLdykiCA21ZBj77y585BoZul4Js3xnyAMOA0DReMshJxBilubcw45O
         2jjFKw9CCa3FFrRlobWuM912WMXwo87W7OfDisUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 4.14 026/237] serial: imx: ensure that RX irqs are off if RX is off
Date:   Thu, 27 Feb 2020 14:34:00 +0100
Message-Id: <20200227132258.304552782@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 76821e222c189b81d553b855ee7054340607eb46 upstream.

Make sure that UCR1.RXDMAEN and UCR1.ATDMAEN (for the DMA case) and
UCR1.RRDYEN (for the PIO case) are off iff UCR1.RXEN is disabled. This
ensures that the fifo isn't read with RX disabled which results in an
exception.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[Backport to v4.14]
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |  116 +++++++++++++++++++++++++++++++----------------
 1 file changed, 78 insertions(+), 38 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -80,7 +80,7 @@
 #define UCR1_IDEN	(1<<12) /* Idle condition interrupt */
 #define UCR1_ICD_REG(x) (((x) & 3) << 10) /* idle condition detect */
 #define UCR1_RRDYEN	(1<<9)	/* Recv ready interrupt enable */
-#define UCR1_RDMAEN	(1<<8)	/* Recv ready DMA enable */
+#define UCR1_RXDMAEN	(1<<8)	/* Recv ready DMA enable */
 #define UCR1_IREN	(1<<7)	/* Infrared interface enable */
 #define UCR1_TXMPTYEN	(1<<6)	/* Transimitter empty interrupt enable */
 #define UCR1_RTSDEN	(1<<5)	/* RTS delta interrupt enable */
@@ -355,6 +355,30 @@ static void imx_port_rts_auto(struct imx
 /*
  * interrupts disabled on entry
  */
+static void imx_start_rx(struct uart_port *port)
+{
+	struct imx_port *sport = (struct imx_port *)port;
+	unsigned int ucr1, ucr2;
+
+	ucr1 = readl(port->membase + UCR1);
+	ucr2 = readl(port->membase + UCR2);
+
+	ucr2 |= UCR2_RXEN;
+
+	if (sport->dma_is_enabled) {
+		ucr1 |= UCR1_RXDMAEN | UCR1_ATDMAEN;
+	} else {
+		ucr1 |= UCR1_RRDYEN;
+	}
+
+	/* Write UCR2 first as it includes RXEN */
+	writel(ucr2, port->membase + UCR2);
+	writel(ucr1, port->membase + UCR1);
+}
+
+/*
+ * interrupts disabled on entry
+ */
 static void imx_stop_tx(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
@@ -378,9 +402,10 @@ static void imx_stop_tx(struct uart_port
 			imx_port_rts_active(sport, &temp);
 		else
 			imx_port_rts_inactive(sport, &temp);
-		temp |= UCR2_RXEN;
 		writel(temp, port->membase + UCR2);
 
+		imx_start_rx(port);
+
 		temp = readl(port->membase + UCR4);
 		temp &= ~UCR4_TCEN;
 		writel(temp, port->membase + UCR4);
@@ -393,7 +418,7 @@ static void imx_stop_tx(struct uart_port
 static void imx_stop_rx(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
-	unsigned long temp;
+	unsigned long ucr1, ucr2;
 
 	if (sport->dma_is_enabled && sport->dma_is_rxing) {
 		if (sport->port.suspended) {
@@ -404,12 +429,18 @@ static void imx_stop_rx(struct uart_port
 		}
 	}
 
-	temp = readl(sport->port.membase + UCR2);
-	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
+	ucr1 = readl(sport->port.membase + UCR1);
+	ucr2 = readl(sport->port.membase + UCR2);
 
-	/* disable the `Receiver Ready Interrrupt` */
-	temp = readl(sport->port.membase + UCR1);
-	writel(temp & ~UCR1_RRDYEN, sport->port.membase + UCR1);
+	if (sport->dma_is_enabled) {
+		ucr1 &= ~(UCR1_RXDMAEN | UCR1_ATDMAEN);
+	} else {
+		ucr1 &= ~UCR1_RRDYEN;
+	}
+	writel(ucr1, port->membase + UCR1);
+
+	ucr2 &= ~UCR2_RXEN;
+	writel(ucr2, port->membase + UCR2);
 }
 
 /*
@@ -581,10 +612,11 @@ static void imx_start_tx(struct uart_por
 			imx_port_rts_active(sport, &temp);
 		else
 			imx_port_rts_inactive(sport, &temp);
-		if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
-			temp &= ~UCR2_RXEN;
 		writel(temp, port->membase + UCR2);
 
+		if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
+			imx_stop_rx(port);
+
 		/* enable transmitter and shifter empty irq */
 		temp = readl(port->membase + UCR4);
 		temp |= UCR4_TCEN;
@@ -1206,7 +1238,7 @@ static void imx_enable_dma(struct imx_po
 
 	/* set UCR1 */
 	temp = readl(sport->port.membase + UCR1);
-	temp |= UCR1_RDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN;
+	temp |= UCR1_RXDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN;
 	writel(temp, sport->port.membase + UCR1);
 
 	temp = readl(sport->port.membase + UCR2);
@@ -1224,7 +1256,7 @@ static void imx_disable_dma(struct imx_p
 
 	/* clear UCR1 */
 	temp = readl(sport->port.membase + UCR1);
-	temp &= ~(UCR1_RDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN);
+	temp &= ~(UCR1_RXDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN);
 	writel(temp, sport->port.membase + UCR1);
 
 	/* clear UCR2 */
@@ -1289,11 +1321,9 @@ static int imx_startup(struct uart_port
 	writel(USR1_RTSD | USR1_DTRD, sport->port.membase + USR1);
 	writel(USR2_ORE, sport->port.membase + USR2);
 
-	if (sport->dma_is_inited && !sport->dma_is_enabled)
-		imx_enable_dma(sport);
-
 	temp = readl(sport->port.membase + UCR1);
-	temp |= UCR1_RRDYEN | UCR1_UARTEN;
+	temp &= ~UCR1_RRDYEN;
+	temp |= UCR1_UARTEN;
 	if (sport->have_rtscts)
 			temp |= UCR1_RTSDEN;
 
@@ -1332,14 +1362,13 @@ static int imx_startup(struct uart_port
 	 */
 	imx_enable_ms(&sport->port);
 
-	/*
-	 * Start RX DMA immediately instead of waiting for RX FIFO interrupts.
-	 * In our iMX53 the average delay for the first reception dropped from
-	 * approximately 35000 microseconds to 1000 microseconds.
-	 */
-	if (sport->dma_is_enabled) {
-		imx_disable_rx_int(sport);
+	if (sport->dma_is_inited) {
+		imx_enable_dma(sport);
 		start_rx_dma(sport);
+	} else {
+		temp = readl(sport->port.membase + UCR1);
+		temp |= UCR1_RRDYEN;
+		writel(temp, sport->port.membase + UCR1);
 	}
 
 	spin_unlock_irqrestore(&sport->port.lock, flags);
@@ -1386,7 +1415,8 @@ static void imx_shutdown(struct uart_por
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 	temp = readl(sport->port.membase + UCR1);
-	temp &= ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN);
+	temp &= ~(UCR1_TXMPTYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN |
+		  UCR1_RXDMAEN | UCR1_ATDMAEN);
 
 	writel(temp, sport->port.membase + UCR1);
 	spin_unlock_irqrestore(&sport->port.lock, flags);
@@ -1659,7 +1689,7 @@ static int imx_poll_init(struct uart_por
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long flags;
-	unsigned long temp;
+	unsigned long ucr1, ucr2;
 	int retval;
 
 	retval = clk_prepare_enable(sport->clk_ipg);
@@ -1673,16 +1703,29 @@ static int imx_poll_init(struct uart_por
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
-	temp = readl(sport->port.membase + UCR1);
+	/*
+	 * Be careful about the order of enabling bits here. First enable the
+	 * receiver (UARTEN + RXEN) and only then the corresponding irqs.
+	 * This prevents that a character that already sits in the RX fifo is
+	 * triggering an irq but the try to fetch it from there results in an
+	 * exception because UARTEN or RXEN is still off.
+	 */
+	ucr1 = readl(port->membase + UCR1);
+	ucr2 = readl(port->membase + UCR2);
+
 	if (is_imx1_uart(sport))
-		temp |= IMX1_UCR1_UARTCLKEN;
-	temp |= UCR1_UARTEN | UCR1_RRDYEN;
-	temp &= ~(UCR1_TXMPTYEN | UCR1_RTSDEN);
-	writel(temp, sport->port.membase + UCR1);
+		ucr1 |= IMX1_UCR1_UARTCLKEN;
 
-	temp = readl(sport->port.membase + UCR2);
-	temp |= UCR2_RXEN;
-	writel(temp, sport->port.membase + UCR2);
+	ucr1 |= UCR1_UARTEN;
+	ucr1 &= ~(UCR1_TXMPTYEN | UCR1_RTSDEN | UCR1_RRDYEN);
+
+	ucr2 |= UCR2_RXEN;
+
+	writel(ucr1, sport->port.membase + UCR1);
+	writel(ucr2, sport->port.membase + UCR2);
+
+	/* now enable irqs */
+	writel(ucr1 | UCR1_RRDYEN, sport->port.membase + UCR1);
 
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
@@ -1742,11 +1785,8 @@ static int imx_rs485_config(struct uart_
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
-		temp = readl(sport->port.membase + UCR2);
-		temp |= UCR2_RXEN;
-		writel(temp, sport->port.membase + UCR2);
-	}
+	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+		imx_start_rx(port);
 
 	port->rs485 = *rs485conf;
 


