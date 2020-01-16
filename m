Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98BE213F635
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbgAPRFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387502AbgAPRFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA97F20728;
        Thu, 16 Jan 2020 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194321;
        bh=w6wJVyJd/kuPH8qGD/8P6BTNCcpOsgYiYAKAiUexPA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLBe0WM5Jn5GbB0wqBenH8ShF2pXCwow6GwqcxjeGvHJVHZ3BuZw1dUqiecnj0mfv
         9S+GECfWMr/lezj8SIqxF7A5wTFmTDR0pH7rLVzBUR4UhkUMv07dskrgn2ep5dMseX
         Y0Ii4CjpQ8zGCfZteNLvp4upWlYK3xnECigzwN+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 4.19 270/671] spi: tegra114: configure dma burst size to fifo trig level
Date:   Thu, 16 Jan 2020 11:58:28 -0500
Message-Id: <20200116170509.12787-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit f4ce428c41fb22e3ed55496dded94df44cb920fa ]

Fixes: Configure DMA burst size to be same as SPI TX/RX trigger levels
to avoid mismatch.

SPI FIFO trigger levels are calculated based on the transfer length.
So this patch moves DMA slave configuration to happen before start
of DMAs.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 52 ++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 5114b8008472..09cfae3abce2 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -529,6 +529,8 @@ static int tegra_spi_start_dma_based_transfer(
 	u32 val;
 	unsigned int len;
 	int ret = 0;
+	u8 dma_burst;
+	struct dma_slave_config dma_sconfig = {0};
 
 	val = SPI_DMA_BLK_SET(tspi->curr_dma_words - 1);
 	tegra_spi_writel(tspi, val, SPI_DMA_BLK);
@@ -540,12 +542,16 @@ static int tegra_spi_start_dma_based_transfer(
 		len = tspi->curr_dma_words * 4;
 
 	/* Set attention level based on length of transfer */
-	if (len & 0xF)
+	if (len & 0xF) {
 		val |= SPI_TX_TRIG_1 | SPI_RX_TRIG_1;
-	else if (((len) >> 4) & 0x1)
+		dma_burst = 1;
+	} else if (((len) >> 4) & 0x1) {
 		val |= SPI_TX_TRIG_4 | SPI_RX_TRIG_4;
-	else
+		dma_burst = 4;
+	} else {
 		val |= SPI_TX_TRIG_8 | SPI_RX_TRIG_8;
+		dma_burst = 8;
+	}
 
 	if (tspi->cur_direction & DATA_DIR_TX)
 		val |= SPI_IE_TX;
@@ -556,7 +562,18 @@ static int tegra_spi_start_dma_based_transfer(
 	tegra_spi_writel(tspi, val, SPI_DMA_CTL);
 	tspi->dma_control_reg = val;
 
+	dma_sconfig.device_fc = true;
 	if (tspi->cur_direction & DATA_DIR_TX) {
+		dma_sconfig.dst_addr = tspi->phys + SPI_TX_FIFO;
+		dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dma_sconfig.dst_maxburst = dma_burst;
+		ret = dmaengine_slave_config(tspi->tx_dma_chan, &dma_sconfig);
+		if (ret < 0) {
+			dev_err(tspi->dev,
+				"DMA slave config failed: %d\n", ret);
+			return ret;
+		}
+
 		tegra_spi_copy_client_txbuf_to_spi_txbuf(tspi, t);
 		ret = tegra_spi_start_tx_dma(tspi, len);
 		if (ret < 0) {
@@ -567,6 +584,16 @@ static int tegra_spi_start_dma_based_transfer(
 	}
 
 	if (tspi->cur_direction & DATA_DIR_RX) {
+		dma_sconfig.src_addr = tspi->phys + SPI_RX_FIFO;
+		dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dma_sconfig.src_maxburst = dma_burst;
+		ret = dmaengine_slave_config(tspi->rx_dma_chan, &dma_sconfig);
+		if (ret < 0) {
+			dev_err(tspi->dev,
+				"DMA slave config failed: %d\n", ret);
+			return ret;
+		}
+
 		/* Make the dma buffer to read by dma */
 		dma_sync_single_for_device(tspi->dev, tspi->rx_dma_phys,
 				tspi->dma_buf_size, DMA_FROM_DEVICE);
@@ -626,7 +653,6 @@ static int tegra_spi_init_dma_param(struct tegra_spi_data *tspi,
 	u32 *dma_buf;
 	dma_addr_t dma_phys;
 	int ret;
-	struct dma_slave_config dma_sconfig;
 
 	dma_chan = dma_request_slave_channel_reason(tspi->dev,
 					dma_to_memory ? "rx" : "tx");
@@ -646,19 +672,6 @@ static int tegra_spi_init_dma_param(struct tegra_spi_data *tspi,
 		return -ENOMEM;
 	}
 
-	if (dma_to_memory) {
-		dma_sconfig.src_addr = tspi->phys + SPI_RX_FIFO;
-		dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dma_sconfig.src_maxburst = 0;
-	} else {
-		dma_sconfig.dst_addr = tspi->phys + SPI_TX_FIFO;
-		dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dma_sconfig.dst_maxburst = 0;
-	}
-
-	ret = dmaengine_slave_config(dma_chan, &dma_sconfig);
-	if (ret)
-		goto scrub;
 	if (dma_to_memory) {
 		tspi->rx_dma_chan = dma_chan;
 		tspi->rx_dma_buf = dma_buf;
@@ -669,11 +682,6 @@ static int tegra_spi_init_dma_param(struct tegra_spi_data *tspi,
 		tspi->tx_dma_phys = dma_phys;
 	}
 	return 0;
-
-scrub:
-	dma_free_coherent(tspi->dev, tspi->dma_buf_size, dma_buf, dma_phys);
-	dma_release_channel(dma_chan);
-	return ret;
 }
 
 static void tegra_spi_deinit_dma_param(struct tegra_spi_data *tspi,
-- 
2.20.1

