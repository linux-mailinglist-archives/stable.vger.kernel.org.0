Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE518101817
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfKSFfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbfKSFfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC3621783;
        Tue, 19 Nov 2019 05:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141700;
        bh=2/j4KmKRBuQKRP03CURvKCeNJQx6DOj4oH59pezYbNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MO1tDc/SwQvS8ePG4j7/w9n1VtQVtsHrreC1bN81J5jm3JVvo6SQ6VQhKml8jTuNw
         vAS+jvdTbnuRH6CJlE2l1PTyYiMLVIamxptsO2jhV75rl3Da2bsJL/JCiruGaYscR1
         8Wf4jvFAbhl6QGlkGh2iNlZL1FkLHTXf/0cKvJY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 251/422] spi: mediatek: Dont modify spi_transfer when transfer.
Date:   Tue, 19 Nov 2019 06:17:28 +0100
Message-Id: <20191119051415.253065441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



