Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BDE1480F5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbgAXLP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390172AbgAXLPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:55 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C25520704;
        Fri, 24 Jan 2020 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864554;
        bh=4+vDnNxDOzWwXS6Pl+LPqraw4p2SepR5noKFu3SFbY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WD+/urHV2Vy7aMacqJEP+wSnqt/t9hIYedT1eO9CK4Q3grNQJEnIWRQ0tUfMJRbw7
         1rxMBkrW8KeQ9dOsy8mySb/JA5rYr35Bc0lAqwJGZ719IuZ6bnX1oy3/9FSbXcqfqk
         2rpNlwLN8LU1hxjFUHiMR0wEJ+tvrKIQcADnQXDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 285/639] spi: tegra114: flush fifos
Date:   Fri, 24 Jan 2020 10:27:35 +0100
Message-Id: <20200124093122.561234693@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index b1b726673f850..5114b80084722 100644
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



