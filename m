Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17F666CAAB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjAPRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjAPRFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:05:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A1438E99
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23049B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5BEC433EF;
        Mon, 16 Jan 2023 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887610;
        bh=WffJwtvQwD6dMyfriVZawGNyrPicy2NAZmolTExur+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7N7ZPzzIYtMNWvIbz22N9pMRmiHsoyfyhxpyslh2F9aTU6eDBCxFLNyjeGaL3qj6
         GEGOINgF8cWr//vaK16YKck8yFEx9jSrQqYzJhFPJwimdo5AZ8H1iXA6ryKqR5OKRZ
         V/H08WDyGd2rwEohx9rMxO8WyXLaAwvC0bdZ6+sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/521] serial: tegra: Add PIO mode support
Date:   Mon, 16 Jan 2023 16:47:57 +0100
Message-Id: <20230116154856.775594483@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 1dce2df3ee06e4f10fd9b8919a0f2e90e0ac3188 ]

Add PIO mode support in receive and transmit path with RX interrupt
trigger of 16 bytes for Tegra194 and older chips.

Signed-off-by: Shardar Shariff Md <smohammed@nvidia.com>
Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/1567572187-29820-13-git-send-email-kyarlagadda@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 109a951a9f1f ("serial: tegra: Read DMA status before terminating")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 117 ++++++++++++++++++++++--------
 1 file changed, 86 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index e11d19742cf6..d6f5d73ba1e8 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -139,6 +139,8 @@ struct tegra_uart_port {
 	int					n_adjustable_baud_rates;
 	int					required_rate;
 	int					configured_rate;
+	bool					use_rx_pio;
+	bool					use_tx_pio;
 };
 
 static void tegra_uart_start_next_tx(struct tegra_uart_port *tup);
@@ -524,7 +526,7 @@ static void tegra_uart_start_next_tx(struct tegra_uart_port *tup)
 	if (!count)
 		return;
 
-	if (count < TEGRA_UART_MIN_DMA)
+	if (tup->use_tx_pio || count < TEGRA_UART_MIN_DMA)
 		tegra_uart_start_pio_tx(tup, count);
 	else if (BYTES_TO_ALIGN(tail) > 0)
 		tegra_uart_start_pio_tx(tup, BYTES_TO_ALIGN(tail));
@@ -746,6 +748,18 @@ static void tegra_uart_handle_modem_signal_change(struct uart_port *u)
 		uart_handle_cts_change(&tup->uport, msr & UART_MSR_CTS);
 }
 
+static void do_handle_rx_pio(struct tegra_uart_port *tup)
+{
+	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
+	struct tty_port *port = &tup->uport.state->port;
+
+	tegra_uart_handle_rx_pio(tup, port);
+	if (tty) {
+		tty_flip_buffer_push(port);
+		tty_kref_put(tty);
+	}
+}
+
 static irqreturn_t tegra_uart_isr(int irq, void *data)
 {
 	struct tegra_uart_port *tup = data;
@@ -759,7 +773,7 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 	while (1) {
 		iir = tegra_uart_read(tup, UART_IIR);
 		if (iir & UART_IIR_NO_INT) {
-			if (is_rx_int) {
+			if (!tup->use_rx_pio && is_rx_int) {
 				tegra_uart_handle_rx_dma(tup);
 				if (tup->rx_in_progress) {
 					ier = tup->ier_shadow;
@@ -787,7 +801,7 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 		case 4: /* End of data */
 		case 6: /* Rx timeout */
 		case 2: /* Receive */
-			if (!is_rx_int) {
+			if (!tup->use_rx_pio && !is_rx_int) {
 				is_rx_int = true;
 				/* Disable Rx interrupts */
 				ier = tup->ier_shadow;
@@ -797,6 +811,8 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 					UART_IER_RTOIE | TEGRA_UART_IER_EORD);
 				tup->ier_shadow = ier;
 				tegra_uart_write(tup, ier, UART_IER);
+			} else {
+				do_handle_rx_pio(tup);
 			}
 			break;
 
@@ -815,6 +831,7 @@ static irqreturn_t tegra_uart_isr(int irq, void *data)
 static void tegra_uart_stop_rx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
+	struct tty_port *port = &tup->uport.state->port;
 	struct dma_tx_state state;
 	unsigned long ier;
 
@@ -832,9 +849,13 @@ static void tegra_uart_stop_rx(struct uart_port *u)
 	tup->ier_shadow = ier;
 	tegra_uart_write(tup, ier, UART_IER);
 	tup->rx_in_progress = 0;
-	dmaengine_terminate_all(tup->rx_dma_chan);
-	dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
-	tegra_uart_rx_buffer_push(tup, state.residue);
+	if (tup->rx_dma_chan && !tup->use_rx_pio) {
+		dmaengine_terminate_all(tup->rx_dma_chan);
+		dmaengine_tx_status(tup->rx_dma_chan, tup->rx_cookie, &state);
+		tegra_uart_rx_buffer_push(tup, state.residue);
+	} else {
+		tegra_uart_handle_rx_pio(tup, port);
+	}
 }
 
 static void tegra_uart_hw_deinit(struct tegra_uart_port *tup)
@@ -885,8 +906,10 @@ static void tegra_uart_hw_deinit(struct tegra_uart_port *tup)
 	tup->rx_in_progress = 0;
 	tup->tx_in_progress = 0;
 
-	tegra_uart_dma_channel_free(tup, true);
-	tegra_uart_dma_channel_free(tup, false);
+	if (!tup->use_rx_pio)
+		tegra_uart_dma_channel_free(tup, true);
+	if (!tup->use_tx_pio)
+		tegra_uart_dma_channel_free(tup, false);
 
 	clk_disable_unprepare(tup->uart_clk);
 }
@@ -931,10 +954,14 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 */
 	tup->fcr_shadow = UART_FCR_ENABLE_FIFO;
 
-	if (tup->cdata->max_dma_burst_bytes == 8)
-		tup->fcr_shadow |= UART_FCR_R_TRIG_10;
-	else
-		tup->fcr_shadow |= UART_FCR_R_TRIG_01;
+	if (tup->use_rx_pio) {
+		tup->fcr_shadow |= UART_FCR_R_TRIG_11;
+	} else {
+		if (tup->cdata->max_dma_burst_bytes == 8)
+			tup->fcr_shadow |= UART_FCR_R_TRIG_10;
+		else
+			tup->fcr_shadow |= UART_FCR_R_TRIG_01;
+	}
 
 	tup->fcr_shadow |= TEGRA_UART_TX_TRIG_16B;
 	tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
@@ -962,19 +989,23 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * (115200, N, 8, 1) so that the receive DMA buffer may be
 	 * enqueued
 	 */
-	tup->lcr_shadow = TEGRA_UART_DEFAULT_LSR;
 	ret = tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
 	if (ret < 0) {
 		dev_err(tup->uport.dev, "Failed to set baud rate\n");
 		return ret;
 	}
-	tup->fcr_shadow |= UART_FCR_DMA_SELECT;
-	tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
+	if (!tup->use_rx_pio) {
+		tup->lcr_shadow = TEGRA_UART_DEFAULT_LSR;
+		tup->fcr_shadow |= UART_FCR_DMA_SELECT;
+		tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
 
-	ret = tegra_uart_start_rx_dma(tup);
-	if (ret < 0) {
-		dev_err(tup->uport.dev, "Not able to start Rx DMA\n");
-		return ret;
+		ret = tegra_uart_start_rx_dma(tup);
+		if (ret < 0) {
+			dev_err(tup->uport.dev, "Not able to start Rx DMA\n");
+			return ret;
+		}
+	} else {
+		tegra_uart_write(tup, tup->fcr_shadow, UART_FCR);
 	}
 	tup->rx_in_progress = 1;
 
@@ -996,7 +1027,12 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 * both the EORD as well as RX_TIMEOUT - SW sees RX_TIMEOUT first
 	 * then the EORD.
 	 */
-	tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE | TEGRA_UART_IER_EORD;
+	if (!tup->use_rx_pio)
+		tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE |
+			TEGRA_UART_IER_EORD;
+	else
+		tup->ier_shadow = UART_IER_RLSI | UART_IER_RTOIE | UART_IER_RDI;
+
 	tegra_uart_write(tup, tup->ier_shadow, UART_IER);
 	return 0;
 }
@@ -1091,16 +1127,22 @@ static int tegra_uart_startup(struct uart_port *u)
 	struct tegra_uart_port *tup = to_tegra_uport(u);
 	int ret;
 
-	ret = tegra_uart_dma_channel_allocate(tup, false);
-	if (ret < 0) {
-		dev_err(u->dev, "Tx Dma allocation failed, err = %d\n", ret);
-		return ret;
+	if (!tup->use_tx_pio) {
+		ret = tegra_uart_dma_channel_allocate(tup, false);
+		if (ret < 0) {
+			dev_err(u->dev, "Tx Dma allocation failed, err = %d\n",
+				ret);
+			return ret;
+		}
 	}
 
-	ret = tegra_uart_dma_channel_allocate(tup, true);
-	if (ret < 0) {
-		dev_err(u->dev, "Rx Dma allocation failed, err = %d\n", ret);
-		goto fail_rx_dma;
+	if (!tup->use_rx_pio) {
+		ret = tegra_uart_dma_channel_allocate(tup, true);
+		if (ret < 0) {
+			dev_err(u->dev, "Rx Dma allocation failed, err = %d\n",
+				ret);
+			goto fail_rx_dma;
+		}
 	}
 
 	ret = tegra_uart_hw_init(tup);
@@ -1118,9 +1160,11 @@ static int tegra_uart_startup(struct uart_port *u)
 	return 0;
 
 fail_hw_init:
-	tegra_uart_dma_channel_free(tup, true);
+	if (!tup->use_rx_pio)
+		tegra_uart_dma_channel_free(tup, true);
 fail_rx_dma:
-	tegra_uart_dma_channel_free(tup, false);
+	if (!tup->use_tx_pio)
+		tegra_uart_dma_channel_free(tup, false);
 	return ret;
 }
 
@@ -1317,7 +1361,6 @@ static int tegra_uart_parse_dt(struct platform_device *pdev,
 	int count;
 	int n_entries;
 
-
 	port = of_alias_get_id(np, "serial");
 	if (port < 0) {
 		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", port);
@@ -1327,6 +1370,18 @@ static int tegra_uart_parse_dt(struct platform_device *pdev,
 
 	tup->enable_modem_interrupt = of_property_read_bool(np,
 					"nvidia,enable-modem-interrupt");
+
+	index = of_property_match_string(np, "dma-names", "rx");
+	if (index < 0) {
+		tup->use_rx_pio = true;
+		dev_info(&pdev->dev, "RX in PIO mode\n");
+	}
+	index = of_property_match_string(np, "dma-names", "tx");
+	if (index < 0) {
+		tup->use_tx_pio = true;
+		dev_info(&pdev->dev, "TX in PIO mode\n");
+	}
+
 	n_entries = of_property_count_u32_elems(np, "nvidia,adjust-baud-rates");
 	if (n_entries > 0) {
 		tup->n_adjustable_baud_rates = n_entries / 3;
-- 
2.35.1



