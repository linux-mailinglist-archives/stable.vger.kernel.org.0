Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DDD20178C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388833AbgFSQkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388803AbgFSOqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13ADD2083B;
        Fri, 19 Jun 2020 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577967;
        bh=a0TYNNyjIBJLR9POMM4mf+WZOZYMq1Rla4RkEy3DSIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoF0VHU9CJvEWyA3fwVkPd5xIfk2bG5Y0dCJPSgPSTvsV0SCYb75NAvXx8NFbzGCs
         uBqyIoMo3YChjERC4aIshhlKip224XKDLLEFTRPbwCI52REs0L5aGiNlwBY579ylnV
         Rv1l1oVsAgXtpLN4fZuGrqFFFCgUCqETFCakO4lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 4.14 008/190] serial: imx: Fix handling of TC irq in combination with DMA
Date:   Fri, 19 Jun 2020 16:30:53 +0200
Message-Id: <20200619141633.883957087@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 1866541492641c02874bf51f9d8712b5510f2c64 upstream.

When using RS485 half duplex the Transmitter Complete irq is needed to
determine the moment when the transmitter can be disabled. When using
DMA this irq must only be enabled when DMA has completed to transfer all
data. Otherwise the CPU might busily trigger this irq which is not
properly handled and so the also pending irq for the DMA transfer cannot
trigger.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[Backport to v4.14]
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -538,6 +538,11 @@ static void dma_tx_callback(void *data)
 
 	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&sport->port))
 		imx_dma_tx(sport);
+	else if (sport->port.rs485.flags & SER_RS485_ENABLED) {
+		temp = readl(sport->port.membase + UCR4);
+		temp |= UCR4_TCEN;
+		writel(temp, sport->port.membase + UCR4);
+	}
 
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
@@ -555,6 +560,10 @@ static void imx_dma_tx(struct imx_port *
 	if (sport->dma_is_txing)
 		return;
 
+	temp = readl(sport->port.membase + UCR4);
+	temp &= ~UCR4_TCEN;
+	writel(temp, sport->port.membase + UCR4);
+
 	sport->tx_bytes = uart_circ_chars_pending(xmit);
 
 	if (xmit->tail < xmit->head || xmit->head == 0) {
@@ -617,10 +626,15 @@ static void imx_start_tx(struct uart_por
 		if (!(port->rs485.flags & SER_RS485_RX_DURING_TX))
 			imx_stop_rx(port);
 
-		/* enable transmitter and shifter empty irq */
-		temp = readl(port->membase + UCR4);
-		temp |= UCR4_TCEN;
-		writel(temp, port->membase + UCR4);
+		/*
+		 * Enable transmitter and shifter empty irq only if DMA is off.
+		 * In the DMA case this is done in the tx-callback.
+		 */
+		if (!sport->dma_is_enabled) {
+			temp = readl(port->membase + UCR4);
+			temp |= UCR4_TCEN;
+			writel(temp, port->membase + UCR4);
+		}
 	}
 
 	if (!sport->dma_is_enabled) {


