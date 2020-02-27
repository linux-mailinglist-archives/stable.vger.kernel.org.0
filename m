Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA0171ED5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387644AbgB0OEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbgB0OEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA2E20578;
        Thu, 27 Feb 2020 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812291;
        bh=eT0ZxAO+2EbiL8VJpZs7lboEN5e1zWIFkgir1z7McpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGaP/kAKOJltXhNjM0dPHI9VYYOHAHSbwoIZblcJsB/rAHVQXGdhYhnWw/sQ0QPTD
         kw7jAtmtcSyi5ljvyHT+33HnANxdoEdYgjN/lpMzssv8/rdIRxbwgLgBpHLK4EmuoS
         ErhFAncNBBx3EPJanr4fRwZY9Ckqvb4PXRSNSipY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Case <ryandcase@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/97] tty: serial: qcom_geni_serial: Remove set_rfr_wm() and related variables
Date:   Thu, 27 Feb 2020 14:37:05 +0100
Message-Id: <20200227132223.864425794@linuxfoundation.org>
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

[ Upstream commit a85fb9ce1fab34a3216fd4d769fede643dbc68d4 ]

The variables of tx_wm and rx_wm were set to the same define value in
all cases, never updated, and the define was sometimes used
interchangably. Remove the variables/function and use the fixed value.

Signed-off-by: Ryan Case <ryandcase@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 4824869a4080d..080fa1d1ecbfd 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -85,7 +85,7 @@
 #define DEF_FIFO_DEPTH_WORDS	16
 #define DEF_TX_WM		2
 #define DEF_FIFO_WIDTH_BITS	32
-#define UART_CONSOLE_RX_WM	2
+#define UART_RX_WM		2
 #define MAX_LOOPBACK_CFG	3
 
 #ifdef CONFIG_CONSOLE_POLL
@@ -101,9 +101,6 @@ struct qcom_geni_serial_port {
 	u32 tx_fifo_depth;
 	u32 tx_fifo_width;
 	u32 rx_fifo_depth;
-	u32 tx_wm;
-	u32 rx_wm;
-	u32 rx_rfr;
 	enum geni_se_xfer_mode xfer_mode;
 	bool setup;
 	int (*handle_rx)(struct uart_port *uport, u32 bytes, bool drop);
@@ -361,9 +358,7 @@ static int qcom_geni_serial_get_char(struct uart_port *uport)
 static void qcom_geni_serial_poll_put_char(struct uart_port *uport,
 							unsigned char c)
 {
-	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
-
-	writel(port->tx_wm, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
 	qcom_geni_serial_setup_tx(uport, 1);
 	WARN_ON(!qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_TX_FIFO_WATERMARK_EN, true));
@@ -571,7 +566,7 @@ static void qcom_geni_serial_start_tx(struct uart_port *uport)
 		irq_en = readl(uport->membase +	SE_GENI_M_IRQ_EN);
 		irq_en |= M_TX_FIFO_WATERMARK_EN | M_CMD_DONE_EN;
 
-		writel(port->tx_wm, uport->membase +
+		writel(DEF_TX_WM, uport->membase +
 						SE_GENI_TX_WATERMARK_REG);
 		writel(irq_en, uport->membase +	SE_GENI_M_IRQ_EN);
 	}
@@ -840,17 +835,6 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
 		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
 }
 
-static void set_rfr_wm(struct qcom_geni_serial_port *port)
-{
-	/*
-	 * Set RFR (Flow off) to FIFO_DEPTH - 2.
-	 * RX WM level at 10% RX_FIFO_DEPTH.
-	 * TX WM level at 10% TX_FIFO_DEPTH.
-	 */
-	port->rx_rfr = port->rx_fifo_depth - 2;
-	port->rx_wm = UART_CONSOLE_RX_WM;
-	port->tx_wm = DEF_TX_WM;
-}
 
 static void qcom_geni_serial_shutdown(struct uart_port *uport)
 {
@@ -889,7 +873,6 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 
 	get_tx_fifo_size(port);
 
-	set_rfr_wm(port);
 	writel(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
 	/*
 	 * Make an unconditional cancel on the main sequencer to reset
@@ -902,7 +885,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 						false, true, false);
 	geni_se_config_packing(&port->se, BITS_PER_BYTE, port->rx_bytes_pw,
 						false, false, true);
-	geni_se_init(&port->se, port->rx_wm, port->rx_rfr);
+	geni_se_init(&port->se, UART_RX_WM, port->rx_fifo_depth - 2);
 	geni_se_select_mode(&port->se, port->xfer_mode);
 	if (!uart_console(uport)) {
 		port->rx_fifo = devm_kcalloc(uport->dev,
-- 
2.20.1



