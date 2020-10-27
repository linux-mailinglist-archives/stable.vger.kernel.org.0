Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB0829C2C4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902361AbgJ0Ocx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902356AbgJ0Ocw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E930020709;
        Tue, 27 Oct 2020 14:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809171;
        bh=9wyVaFFZ0hXO3eJjKqw5F28OtNTfpaXe/XlgF5X9tdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIUEp92evk7fLzm6yuQ5PPt4wv00WCGr3Z8gcFhEEt1l7tkL83pdHtOl6JJdN8uDl
         qGa3B1qOrrOqDmgsWYB4LqtwkGhOjlcwxP+wASnJFytCKtPWf/9PB1DigYq+QYmUcs
         Xg4HDxvGsHJ1e2H7gn9/Rdt7A+1+4waQFBHjioGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/408] spi: spi-s3c64xx: Check return values
Date:   Tue, 27 Oct 2020 14:50:39 +0100
Message-Id: <20201027135459.781263253@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 2f4db6f705c5cba85d23836c19b44d9687dc1334 ]

Check return values in prepare_dma() and s3c64xx_spi_config() and
propagate errors upwards.

Fixes: 788437273fa8 ("spi: s3c64xx: move to generic dmaengine API")
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Link: https://lore.kernel.org/r/20201002122243.26849-4-l.stelmach@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 50 ++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 322f75f89c713..1d948fee1a039 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -122,6 +122,7 @@
 
 struct s3c64xx_spi_dma_data {
 	struct dma_chan *ch;
+	dma_cookie_t cookie;
 	enum dma_transfer_direction direction;
 };
 
@@ -264,12 +265,13 @@ static void s3c64xx_spi_dmacb(void *data)
 	spin_unlock_irqrestore(&sdd->lock, flags);
 }
 
-static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
+static int prepare_dma(struct s3c64xx_spi_dma_data *dma,
 			struct sg_table *sgt)
 {
 	struct s3c64xx_spi_driver_data *sdd;
 	struct dma_slave_config config;
 	struct dma_async_tx_descriptor *desc;
+	int ret;
 
 	memset(&config, 0, sizeof(config));
 
@@ -293,12 +295,24 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 
 	desc = dmaengine_prep_slave_sg(dma->ch, sgt->sgl, sgt->nents,
 				       dma->direction, DMA_PREP_INTERRUPT);
+	if (!desc) {
+		dev_err(&sdd->pdev->dev, "unable to prepare %s scatterlist",
+			dma->direction == DMA_DEV_TO_MEM ? "rx" : "tx");
+		return -ENOMEM;
+	}
 
 	desc->callback = s3c64xx_spi_dmacb;
 	desc->callback_param = dma;
 
-	dmaengine_submit(desc);
+	dma->cookie = dmaengine_submit(desc);
+	ret = dma_submit_error(dma->cookie);
+	if (ret) {
+		dev_err(&sdd->pdev->dev, "DMA submission failed");
+		return -EIO;
+	}
+
 	dma_async_issue_pending(dma->ch);
+	return 0;
 }
 
 static void s3c64xx_spi_set_cs(struct spi_device *spi, bool enable)
@@ -348,11 +362,12 @@ static bool s3c64xx_spi_can_dma(struct spi_master *master,
 	return xfer->len > (FIFO_LVL_MASK(sdd) >> 1) + 1;
 }
 
-static void s3c64xx_enable_datapath(struct s3c64xx_spi_driver_data *sdd,
+static int s3c64xx_enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 				    struct spi_transfer *xfer, int dma_mode)
 {
 	void __iomem *regs = sdd->regs;
 	u32 modecfg, chcfg;
+	int ret = 0;
 
 	modecfg = readl(regs + S3C64XX_SPI_MODE_CFG);
 	modecfg &= ~(S3C64XX_SPI_MODE_TXDMA_ON | S3C64XX_SPI_MODE_RXDMA_ON);
@@ -378,7 +393,7 @@ static void s3c64xx_enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 		chcfg |= S3C64XX_SPI_CH_TXCH_ON;
 		if (dma_mode) {
 			modecfg |= S3C64XX_SPI_MODE_TXDMA_ON;
-			prepare_dma(&sdd->tx_dma, &xfer->tx_sg);
+			ret = prepare_dma(&sdd->tx_dma, &xfer->tx_sg);
 		} else {
 			switch (sdd->cur_bpw) {
 			case 32:
@@ -410,12 +425,17 @@ static void s3c64xx_enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 			writel(((xfer->len * 8 / sdd->cur_bpw) & 0xffff)
 					| S3C64XX_SPI_PACKET_CNT_EN,
 					regs + S3C64XX_SPI_PACKET_CNT);
-			prepare_dma(&sdd->rx_dma, &xfer->rx_sg);
+			ret = prepare_dma(&sdd->rx_dma, &xfer->rx_sg);
 		}
 	}
 
+	if (ret)
+		return ret;
+
 	writel(modecfg, regs + S3C64XX_SPI_MODE_CFG);
 	writel(chcfg, regs + S3C64XX_SPI_CH_CFG);
+
+	return 0;
 }
 
 static u32 s3c64xx_spi_wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
@@ -548,9 +568,10 @@ static int s3c64xx_wait_for_pio(struct s3c64xx_spi_driver_data *sdd,
 	return 0;
 }
 
-static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
+static int s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 {
 	void __iomem *regs = sdd->regs;
+	int ret;
 	u32 val;
 
 	/* Disable Clock */
@@ -598,7 +619,9 @@ static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 
 	if (sdd->port_conf->clk_from_cmu) {
 		/* The src_clk clock is divided internally by 2 */
-		clk_set_rate(sdd->src_clk, sdd->cur_speed * 2);
+		ret = clk_set_rate(sdd->src_clk, sdd->cur_speed * 2);
+		if (ret)
+			return ret;
 	} else {
 		/* Configure Clock */
 		val = readl(regs + S3C64XX_SPI_CLK_CFG);
@@ -612,6 +635,8 @@ static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 		val |= S3C64XX_SPI_ENCLK_ENABLE;
 		writel(val, regs + S3C64XX_SPI_CLK_CFG);
 	}
+
+	return 0;
 }
 
 #define XFER_DMAADDR_INVALID DMA_BIT_MASK(32)
@@ -654,7 +679,9 @@ static int s3c64xx_spi_transfer_one(struct spi_master *master,
 		sdd->cur_bpw = bpw;
 		sdd->cur_speed = speed;
 		sdd->cur_mode = spi->mode;
-		s3c64xx_spi_config(sdd);
+		status = s3c64xx_spi_config(sdd);
+		if (status)
+			return status;
 	}
 
 	if (!is_polling(sdd) && (xfer->len > fifo_len) &&
@@ -681,10 +708,15 @@ static int s3c64xx_spi_transfer_one(struct spi_master *master,
 		/* Start the signals */
 		s3c64xx_spi_set_cs(spi, true);
 
-		s3c64xx_enable_datapath(sdd, xfer, use_dma);
+		status = s3c64xx_enable_datapath(sdd, xfer, use_dma);
 
 		spin_unlock_irqrestore(&sdd->lock, flags);
 
+		if (status) {
+			dev_err(&spi->dev, "failed to enable data path for transfer: %d\n", status);
+			break;
+		}
+
 		if (use_dma)
 			status = s3c64xx_wait_for_dma(sdd, xfer);
 		else
-- 
2.25.1



