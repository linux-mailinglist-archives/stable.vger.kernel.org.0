Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5492D1910B2
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgCXNWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgCXNWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:22:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2219D206F6;
        Tue, 24 Mar 2020 13:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056126;
        bh=+6r54pYE6c6pWRBI3zLvQWXkupOAk+wCQJBuWB6nwXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQP6b3nQXDE5Mzol4Hb474NqdVOOOYwpfGS0mSQ0j3087StqsPNwHQy2lpz00+fcm
         STGrRgZJozlIOua4jScUGKuEZZSc8evUJGSdL0b3nEdXMtGjYRncAzSor/3m6zfk+u
         pA9+ElcD+N80+riWzYJHGw4lCkh4/N9KFXG/j09k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 003/119] spi: spi-omap2-mcspi: Support probe deferral for DMA channels
Date:   Tue, 24 Mar 2020 14:09:48 +0100
Message-Id: <20200324130808.352666447@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 32f2fc5dc3992b4b60cc6b1a6a31be605cc9c3a2 ]

dma_request_channel() can return -EPROBE_DEFER, if DMA driver is not
ready. Currently driver just falls back to PIO mode on probe deferral.
Fix this by requesting all required channels during probe and
propagating EPROBE_DEFER error code.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200204124816.16735-3-vigneshr@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c |   77 ++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -974,20 +974,12 @@ static int omap2_mcspi_setup_transfer(st
  * Note that we currently allow DMA only if we get a channel
  * for both rx and tx. Otherwise we'll do PIO for both rx and tx.
  */
-static int omap2_mcspi_request_dma(struct spi_device *spi)
+static int omap2_mcspi_request_dma(struct omap2_mcspi *mcspi,
+				   struct omap2_mcspi_dma *mcspi_dma)
 {
-	struct spi_master	*master = spi->master;
-	struct omap2_mcspi	*mcspi;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	int ret = 0;
 
-	mcspi = spi_master_get_devdata(master);
-	mcspi_dma = mcspi->dma_channels + spi->chip_select;
-
-	init_completion(&mcspi_dma->dma_rx_completion);
-	init_completion(&mcspi_dma->dma_tx_completion);
-
-	mcspi_dma->dma_rx = dma_request_chan(&master->dev,
+	mcspi_dma->dma_rx = dma_request_chan(mcspi->dev,
 					     mcspi_dma->dma_rx_ch_name);
 	if (IS_ERR(mcspi_dma->dma_rx)) {
 		ret = PTR_ERR(mcspi_dma->dma_rx);
@@ -995,7 +987,7 @@ static int omap2_mcspi_request_dma(struc
 		goto no_dma;
 	}
 
-	mcspi_dma->dma_tx = dma_request_chan(&master->dev,
+	mcspi_dma->dma_tx = dma_request_chan(mcspi->dev,
 					     mcspi_dma->dma_tx_ch_name);
 	if (IS_ERR(mcspi_dma->dma_tx)) {
 		ret = PTR_ERR(mcspi_dma->dma_tx);
@@ -1004,20 +996,40 @@ static int omap2_mcspi_request_dma(struc
 		mcspi_dma->dma_rx = NULL;
 	}
 
+	init_completion(&mcspi_dma->dma_rx_completion);
+	init_completion(&mcspi_dma->dma_tx_completion);
+
 no_dma:
 	return ret;
 }
 
+static void omap2_mcspi_release_dma(struct spi_master *master)
+{
+	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
+	struct omap2_mcspi_dma	*mcspi_dma;
+	int i;
+
+	for (i = 0; i < master->num_chipselect; i++) {
+		mcspi_dma = &mcspi->dma_channels[i];
+
+		if (mcspi_dma->dma_rx) {
+			dma_release_channel(mcspi_dma->dma_rx);
+			mcspi_dma->dma_rx = NULL;
+		}
+		if (mcspi_dma->dma_tx) {
+			dma_release_channel(mcspi_dma->dma_tx);
+			mcspi_dma->dma_tx = NULL;
+		}
+	}
+}
+
 static int omap2_mcspi_setup(struct spi_device *spi)
 {
 	int			ret;
 	struct omap2_mcspi	*mcspi = spi_master_get_devdata(spi->master);
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
-	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
-
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
@@ -1042,13 +1054,6 @@ static int omap2_mcspi_setup(struct spi_
 		}
 	}
 
-	if (!mcspi_dma->dma_rx || !mcspi_dma->dma_tx) {
-		ret = omap2_mcspi_request_dma(spi);
-		if (ret)
-			dev_warn(&spi->dev, "not using DMA for McSPI (%d)\n",
-				 ret);
-	}
-
 	ret = pm_runtime_get_sync(mcspi->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(mcspi->dev);
@@ -1065,12 +1070,8 @@ static int omap2_mcspi_setup(struct spi_
 
 static void omap2_mcspi_cleanup(struct spi_device *spi)
 {
-	struct omap2_mcspi	*mcspi;
-	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs;
 
-	mcspi = spi_master_get_devdata(spi->master);
-
 	if (spi->controller_state) {
 		/* Unlink controller state from context save list */
 		cs = spi->controller_state;
@@ -1079,19 +1080,6 @@ static void omap2_mcspi_cleanup(struct s
 		kfree(cs);
 	}
 
-	if (spi->chip_select < spi->master->num_chipselect) {
-		mcspi_dma = &mcspi->dma_channels[spi->chip_select];
-
-		if (mcspi_dma->dma_rx) {
-			dma_release_channel(mcspi_dma->dma_rx);
-			mcspi_dma->dma_rx = NULL;
-		}
-		if (mcspi_dma->dma_tx) {
-			dma_release_channel(mcspi_dma->dma_tx);
-			mcspi_dma->dma_tx = NULL;
-		}
-	}
-
 	if (gpio_is_valid(spi->cs_gpio))
 		gpio_free(spi->cs_gpio);
 }
@@ -1302,6 +1290,9 @@ static bool omap2_mcspi_can_dma(struct s
 	if (spi_controller_is_slave(master))
 		return true;
 
+	master->dma_rx = mcspi_dma->dma_rx;
+	master->dma_tx = mcspi_dma->dma_tx;
+
 	return (xfer->len >= DMA_MIN_BYTES);
 }
 
@@ -1464,6 +1455,11 @@ static int omap2_mcspi_probe(struct plat
 	for (i = 0; i < master->num_chipselect; i++) {
 		sprintf(mcspi->dma_channels[i].dma_rx_ch_name, "rx%d", i);
 		sprintf(mcspi->dma_channels[i].dma_tx_ch_name, "tx%d", i);
+
+		status = omap2_mcspi_request_dma(mcspi,
+						 &mcspi->dma_channels[i]);
+		if (status == -EPROBE_DEFER)
+			goto free_master;
 	}
 
 	status = platform_get_irq(pdev, 0);
@@ -1501,6 +1497,7 @@ disable_pm:
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_master:
+	omap2_mcspi_release_dma(master);
 	spi_master_put(master);
 	return status;
 }
@@ -1510,6 +1507,8 @@ static int omap2_mcspi_remove(struct pla
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
+	omap2_mcspi_release_dma(master);
+
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
 	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);


