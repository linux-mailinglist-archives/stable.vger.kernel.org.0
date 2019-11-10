Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6DF655F
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfKJDG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbfKJCpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144C721850;
        Sun, 10 Nov 2019 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353949;
        bh=2/j4KmKRBuQKRP03CURvKCeNJQx6DOj4oH59pezYbNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEqk8GXFJebo2GNPwcMhw+baY8F0kBH/mKQyDdptznvjuO/rFbRrozCgrSEov7Ddz
         tRMiWJZXjIpMqUm7ofPe1iOVNpFBgBJc7Sohvz/VUfhiZdg8nY7aaDxvf3Gk7acMqD
         yZncVw//MuH1lZh86+Zibvp/GrUJjDc5/5Y8+vII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Shih <pihsun@chromium.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 007/109] spi: mediatek: Don't modify spi_transfer when transfer.
Date:   Sat,  9 Nov 2019 21:43:59 -0500
Message-Id: <20191110024541.31567-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Shih <pihsun@chromium.org>

[ Upstream commit 00bca73bfca4fb0ab089b94cad0fc83d8b49c25f ]

Mediatek SPI driver modifies some fields (tx_buf, rx_buf, len, tx_dma,
rx_dma) of the spi_transfer* passed in when doing transfer_one and in
interrupt handler. This is somewhat unexpected, and there are some
caller (e.g. Cr50 spi driver) that reuse the spi_transfer for multiple
messages. Add a field to record how many bytes have been transferred,
and calculate the right len / buffer based on it instead.

Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>

Change-Id: I23e218cd964f16c0b2b26127d4a5ca6529867673
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 86bf45667a040..3dc31627c6558 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -98,6 +98,7 @@ struct mtk_spi {
 	struct clk *parent_clk, *sel_clk, *spi_clk;
 	struct spi_transfer *cur_transfer;
 	u32 xfer_len;
+	u32 num_xfered;
 	struct scatterlist *tx_sgl, *rx_sgl;
 	u32 tx_sgl_len, rx_sgl_len;
 	const struct mtk_spi_compatible *dev_comp;
@@ -385,6 +386,7 @@ static int mtk_spi_fifo_transfer(struct spi_master *master,
 
 	mdata->cur_transfer = xfer;
 	mdata->xfer_len = min(MTK_SPI_MAX_FIFO_SIZE, xfer->len);
+	mdata->num_xfered = 0;
 	mtk_spi_prepare_transfer(master, xfer);
 	mtk_spi_setup_packet(master);
 
@@ -415,6 +417,7 @@ static int mtk_spi_dma_transfer(struct spi_master *master,
 	mdata->tx_sgl_len = 0;
 	mdata->rx_sgl_len = 0;
 	mdata->cur_transfer = xfer;
+	mdata->num_xfered = 0;
 
 	mtk_spi_prepare_transfer(master, xfer);
 
@@ -482,7 +485,7 @@ static int mtk_spi_setup(struct spi_device *spi)
 
 static irqreturn_t mtk_spi_interrupt(int irq, void *dev_id)
 {
-	u32 cmd, reg_val, cnt, remainder;
+	u32 cmd, reg_val, cnt, remainder, len;
 	struct spi_master *master = dev_id;
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
 	struct spi_transfer *trans = mdata->cur_transfer;
@@ -497,36 +500,38 @@ static irqreturn_t mtk_spi_interrupt(int irq, void *dev_id)
 		if (trans->rx_buf) {
 			cnt = mdata->xfer_len / 4;
 			ioread32_rep(mdata->base + SPI_RX_DATA_REG,
-				     trans->rx_buf, cnt);
+				     trans->rx_buf + mdata->num_xfered, cnt);
 			remainder = mdata->xfer_len % 4;
 			if (remainder > 0) {
 				reg_val = readl(mdata->base + SPI_RX_DATA_REG);
-				memcpy(trans->rx_buf + (cnt * 4),
-					&reg_val, remainder);
+				memcpy(trans->rx_buf +
+					mdata->num_xfered +
+					(cnt * 4),
+					&reg_val,
+					remainder);
 			}
 		}
 
-		trans->len -= mdata->xfer_len;
-		if (!trans->len) {
+		mdata->num_xfered += mdata->xfer_len;
+		if (mdata->num_xfered == trans->len) {
 			spi_finalize_current_transfer(master);
 			return IRQ_HANDLED;
 		}
 
-		if (trans->tx_buf)
-			trans->tx_buf += mdata->xfer_len;
-		if (trans->rx_buf)
-			trans->rx_buf += mdata->xfer_len;
-
-		mdata->xfer_len = min(MTK_SPI_MAX_FIFO_SIZE, trans->len);
+		len = trans->len - mdata->num_xfered;
+		mdata->xfer_len = min(MTK_SPI_MAX_FIFO_SIZE, len);
 		mtk_spi_setup_packet(master);
 
-		cnt = trans->len / 4;
-		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, trans->tx_buf, cnt);
+		cnt = len / 4;
+		iowrite32_rep(mdata->base + SPI_TX_DATA_REG,
+				trans->tx_buf + mdata->num_xfered, cnt);
 
-		remainder = trans->len % 4;
+		remainder = len % 4;
 		if (remainder > 0) {
 			reg_val = 0;
-			memcpy(&reg_val, trans->tx_buf + (cnt * 4), remainder);
+			memcpy(&reg_val,
+				trans->tx_buf + (cnt * 4) + mdata->num_xfered,
+				remainder);
 			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
 		}
 
-- 
2.20.1

