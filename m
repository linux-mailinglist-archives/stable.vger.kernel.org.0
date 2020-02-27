Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBB3171EDC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733052AbgB0Oal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387649AbgB0OEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0146020578;
        Thu, 27 Feb 2020 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812293;
        bh=+Ageaz9hjQCs8xoZUS3femTFGabZap9P1XDvmO90B2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEUMAlaGBZvqUTjxpeP/8JddSlKLUzgwhsaoBeM2iwLk4xT72ZvO9Vbvx3QIRq5AB
         lwEpvchiN6tqYoesjvFwIcN+NJlkhKUm11EG1Z42NSjFSFG7p67+TeH2pdkrIYcdVr
         yOwHQNp8iU3j04hz9dFxHA/tCByMITxwzvazgIRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Case <ryandcase@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/97] tty: serial: qcom_geni_serial: Remove xfer_mode variable
Date:   Thu, 27 Feb 2020 14:37:06 +0100
Message-Id: <20200227132224.027856915@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Case <ryandcase@chromium.org>

[ Upstream commit bdc05a8a3f822ca0662464055f902faf760da6be ]

The driver only supports FIFO mode so setting and checking this variable
is unnecessary. If DMA support is ever added then such checks can be
introduced.

Signed-off-by: Ryan Case <ryandcase@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 67 ++++++++++-----------------
 1 file changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 080fa1d1ecbfd..4182129925dec 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -101,7 +101,6 @@ struct qcom_geni_serial_port {
 	u32 tx_fifo_depth;
 	u32 tx_fifo_width;
 	u32 rx_fifo_depth;
-	enum geni_se_xfer_mode xfer_mode;
 	bool setup;
 	int (*handle_rx)(struct uart_port *uport, u32 bytes, bool drop);
 	unsigned int baud;
@@ -547,29 +546,20 @@ static int handle_rx_uart(struct uart_port *uport, u32 bytes, bool drop)
 static void qcom_geni_serial_start_tx(struct uart_port *uport)
 {
 	u32 irq_en;
-	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 	u32 status;
 
-	if (port->xfer_mode == GENI_SE_FIFO) {
-		/*
-		 * readl ensures reading & writing of IRQ_EN register
-		 * is not re-ordered before checking the status of the
-		 * Serial Engine.
-		 */
-		status = readl(uport->membase + SE_GENI_STATUS);
-		if (status & M_GENI_CMD_ACTIVE)
-			return;
+	status = readl(uport->membase + SE_GENI_STATUS);
+	if (status & M_GENI_CMD_ACTIVE)
+		return;
 
-		if (!qcom_geni_serial_tx_empty(uport))
-			return;
+	if (!qcom_geni_serial_tx_empty(uport))
+		return;
 
-		irq_en = readl(uport->membase +	SE_GENI_M_IRQ_EN);
-		irq_en |= M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN;
+	irq_en = readl(uport->membase +	SE_GENI_M_IRQ_EN);
+	irq_en |= M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN;
 
-		writel(DEF_TX_WM, uport->membase +
-						SE_GENI_TX_WATERMARK_REG);
-		writel(irq_en, uport->membase +	SE_GENI_M_IRQ_EN);
-	}
+	writel(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(irq_en, uport->membase +	SE_GENI_M_IRQ_EN);
 }
 
 static void qcom_geni_serial_stop_tx(struct uart_port *uport)
@@ -579,12 +569,8 @@ static void qcom_geni_serial_stop_tx(struct uart_port *uport)
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
 	irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
-	irq_en &= ~M_CMD_DONE_EN;
-	if (port->xfer_mode == GENI_SE_FIFO) {
-		irq_en &= ~M_TX_FIFO_WATERMARK_EN;
-		writel(0, uport->membase +
-				     SE_GENI_TX_WATERMARK_REG);
-	}
+	irq_en &= ~(M_CMD_DONE_EN | M_TX_FIFO_WATERMARK_EN);
+	writel(0, uport->membase + SE_GENI_TX_WATERMARK_REG);
 	writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
 	status = readl(uport->membase + SE_GENI_STATUS);
 	/* Possible stop tx is called multiple times. */
@@ -614,15 +600,13 @@ static void qcom_geni_serial_start_rx(struct uart_port *uport)
 
 	geni_se_setup_s_cmd(&port->se, UART_START_READ, 0);
 
-	if (port->xfer_mode == GENI_SE_FIFO) {
-		irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
-		irq_en |= S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN;
-		writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
+	irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
+	irq_en |= S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN;
+	writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
 
-		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
-		irq_en |= M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN;
-		writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
-	}
+	irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
+	irq_en |= M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN;
+	writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
 }
 
 static void qcom_geni_serial_stop_rx(struct uart_port *uport)
@@ -632,15 +616,13 @@ static void qcom_geni_serial_stop_rx(struct uart_port *uport)
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 	u32 irq_clear = S_CMD_DONE_EN;
 
-	if (port->xfer_mode == GENI_SE_FIFO) {
-		irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
-		irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
-		writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
+	irq_en = readl(uport->membase + SE_GENI_S_IRQ_EN);
+	irq_en &= ~(S_RX_FIFO_WATERMARK_EN | S_RX_FIFO_LAST_EN);
+	writel(irq_en, uport->membase + SE_GENI_S_IRQ_EN);
 
-		irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
-		irq_en &= ~(M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN);
-		writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
-	}
+	irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
+	irq_en &= ~(M_RX_FIFO_WATERMARK_EN | M_RX_FIFO_LAST_EN);
+	writel(irq_en, uport->membase + SE_GENI_M_IRQ_EN);
 
 	status = readl(uport->membase + SE_GENI_STATUS);
 	/* Possible stop rx is called multiple times. */
@@ -878,7 +860,6 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	 * Make an unconditional cancel on the main sequencer to reset
 	 * it else we could end up in data loss scenarios.
 	 */
-	port->xfer_mode = GENI_SE_FIFO;
 	if (uart_console(uport))
 		qcom_geni_serial_poll_tx_done(uport);
 	geni_se_config_packing(&port->se, BITS_PER_BYTE, port->tx_bytes_pw,
@@ -886,7 +867,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	geni_se_config_packing(&port->se, BITS_PER_BYTE, port->rx_bytes_pw,
 						false, false, true);
 	geni_se_init(&port->se, UART_RX_WM, port->rx_fifo_depth - 2);
-	geni_se_select_mode(&port->se, port->xfer_mode);
+	geni_se_select_mode(&port->se, GENI_SE_FIFO);
 	if (!uart_console(uport)) {
 		port->rx_fifo = devm_kcalloc(uport->dev,
 			port->rx_fifo_depth, sizeof(u32), GFP_KERNEL);
-- 
2.20.1



