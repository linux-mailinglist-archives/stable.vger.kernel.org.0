Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D0147CED
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733270AbgAXJzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731598AbgAXJze (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:55:34 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F37A214AF;
        Fri, 24 Jan 2020 09:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859733;
        bh=+EhiJQedu288jQ8Y70lmgBW13Is2te00VfipNtIyRjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2zABBWweDEMFVz28l+PhmC3y9X3rEA0TRAsed46EQE8kTUjXYGHk87OZM/XXPXfw
         CMY7GS5oUaHT48P+ERavKpoZ8EjzKpzLKbvSqmC51NyyYI6s323wQkg9ZJG8/7G5nN
         YL3Zdh7hZMeW1BgWwLrJfUsgHrwmXrNFaDqZsbcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 159/343] spi: tegra114: flush fifos
Date:   Fri, 24 Jan 2020 10:29:37 +0100
Message-Id: <20200124092940.875823527@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit c4fc9e5b28ff787e35137c2cc13316bb11d7657b ]

Fixes: Flush TX and RX FIFOs before start of new transfer and on FIFO
overflow or underrun errors.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 39 +++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 4878d5e00c669..18dfbd57c61f2 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -499,22 +499,37 @@ static int tegra_spi_start_rx_dma(struct tegra_spi_data *tspi, int len)
 	return 0;
 }
 
-static int tegra_spi_start_dma_based_transfer(
-		struct tegra_spi_data *tspi, struct spi_transfer *t)
+static int tegra_spi_flush_fifos(struct tegra_spi_data *tspi)
 {
-	u32 val;
-	unsigned int len;
-	int ret = 0;
+	unsigned long timeout = jiffies + HZ;
 	u32 status;
 
-	/* Make sure that Rx and Tx fifo are empty */
 	status = tegra_spi_readl(tspi, SPI_FIFO_STATUS);
 	if ((status & SPI_FIFO_EMPTY) != SPI_FIFO_EMPTY) {
-		dev_err(tspi->dev, "Rx/Tx fifo are not empty status 0x%08x\n",
-			(unsigned)status);
-		return -EIO;
+		status |= SPI_RX_FIFO_FLUSH | SPI_TX_FIFO_FLUSH;
+		tegra_spi_writel(tspi, status, SPI_FIFO_STATUS);
+		while ((status & SPI_FIFO_EMPTY) != SPI_FIFO_EMPTY) {
+			status = tegra_spi_readl(tspi, SPI_FIFO_STATUS);
+			if (time_after(jiffies, timeout)) {
+				dev_err(tspi->dev,
+					"timeout waiting for fifo flush\n");
+				return -EIO;
+			}
+
+			udelay(1);
+		}
 	}
 
+	return 0;
+}
+
+static int tegra_spi_start_dma_based_transfer(
+		struct tegra_spi_data *tspi, struct spi_transfer *t)
+{
+	u32 val;
+	unsigned int len;
+	int ret = 0;
+
 	val = SPI_DMA_BLK_SET(tspi->curr_dma_words - 1);
 	tegra_spi_writel(tspi, val, SPI_DMA_BLK);
 
@@ -779,6 +794,9 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
 	dev_dbg(tspi->dev, "The def 0x%x and written 0x%x\n",
 		tspi->def_command1_reg, (unsigned)command1);
 
+	ret = tegra_spi_flush_fifos(tspi);
+	if (ret < 0)
+		return ret;
 	if (total_fifo_words > SPI_FIFO_DEPTH)
 		ret = tegra_spi_start_dma_based_transfer(tspi, t);
 	else
@@ -876,6 +894,7 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 			    (tspi->cur_direction & DATA_DIR_RX))
 				dmaengine_terminate_all(tspi->rx_dma_chan);
 			ret = -EIO;
+			tegra_spi_flush_fifos(tspi);
 			reset_control_assert(tspi->rst);
 			udelay(2);
 			reset_control_deassert(tspi->rst);
@@ -929,6 +948,7 @@ static irqreturn_t handle_cpu_based_xfer(struct tegra_spi_data *tspi)
 			tspi->status_reg);
 		dev_err(tspi->dev, "CpuXfer 0x%08x:0x%08x\n",
 			tspi->command1_reg, tspi->dma_control_reg);
+		tegra_spi_flush_fifos(tspi);
 		reset_control_assert(tspi->rst);
 		udelay(2);
 		reset_control_deassert(tspi->rst);
@@ -1001,6 +1021,7 @@ static irqreturn_t handle_dma_based_xfer(struct tegra_spi_data *tspi)
 			tspi->status_reg);
 		dev_err(tspi->dev, "DmaXfer 0x%08x:0x%08x\n",
 			tspi->command1_reg, tspi->dma_control_reg);
+		tegra_spi_flush_fifos(tspi);
 		reset_control_assert(tspi->rst);
 		udelay(2);
 		reset_control_deassert(tspi->rst);
-- 
2.20.1



