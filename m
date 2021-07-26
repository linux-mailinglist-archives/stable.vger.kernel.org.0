Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049033D5F48
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhGZPR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237465AbhGZPPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A58716108E;
        Mon, 26 Jul 2021 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314950;
        bh=zEPMFOrrDZmF3EtVdUi4LvZ7JY1C4TBrDX6pNu7DI5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwZ3NAA9Z004ieEjqkDiN0eiI1ChYK+giF0GcKQFWRGIMpmxxzzcJuJMLYMzBjcPn
         x56H2KyRCSe04IqlE3EwNVo0PxUSTyJqjlmKmd47QVF3El2PzUc5HnawCvXoyeC9YJ
         ROWPEyIJcOItPrBeKm+oae02JhhJgzNE+EHz+Q+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/108] spi: stm32: Use dma_request_chan() instead dma_request_slave_channel()
Date:   Mon, 26 Jul 2021 17:38:32 +0200
Message-Id: <20210726153832.693976986@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 0a454258febb73e4c60d7f5d9a02d1a8c64fdfb8 ]

dma_request_slave_channel() is a wrapper on top of dma_request_chan()
eating up the error code.

By using dma_request_chan() directly the driver can support deferred
probing against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20191212135550.4634-10-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 3af6a5a3a4b2..8c308279c535 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1908,17 +1908,29 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	master->transfer_one = stm32_spi_transfer_one;
 	master->unprepare_message = stm32_spi_unprepare_msg;
 
-	spi->dma_tx = dma_request_slave_channel(spi->dev, "tx");
-	if (!spi->dma_tx)
+	spi->dma_tx = dma_request_chan(spi->dev, "tx");
+	if (IS_ERR(spi->dma_tx)) {
+		ret = PTR_ERR(spi->dma_tx);
+		spi->dma_tx = NULL;
+		if (ret == -EPROBE_DEFER)
+			goto err_clk_disable;
+
 		dev_warn(&pdev->dev, "failed to request tx dma channel\n");
-	else
+	} else {
 		master->dma_tx = spi->dma_tx;
+	}
+
+	spi->dma_rx = dma_request_chan(spi->dev, "rx");
+	if (IS_ERR(spi->dma_rx)) {
+		ret = PTR_ERR(spi->dma_rx);
+		spi->dma_rx = NULL;
+		if (ret == -EPROBE_DEFER)
+			goto err_dma_release;
 
-	spi->dma_rx = dma_request_slave_channel(spi->dev, "rx");
-	if (!spi->dma_rx)
 		dev_warn(&pdev->dev, "failed to request rx dma channel\n");
-	else
+	} else {
 		master->dma_rx = spi->dma_rx;
+	}
 
 	if (spi->dma_tx || spi->dma_rx)
 		master->can_dma = stm32_spi_can_dma;
@@ -1930,13 +1942,13 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "spi master registration failed: %d\n",
 			ret);
-		goto err_dma_release;
+		goto err_pm_disable;
 	}
 
 	if (!master->cs_gpios) {
 		dev_err(&pdev->dev, "no CS gpios available\n");
 		ret = -EINVAL;
-		goto err_dma_release;
+		goto err_pm_disable;
 	}
 
 	for (i = 0; i < master->num_chipselect; i++) {
@@ -1960,13 +1972,13 @@ static int stm32_spi_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 err_dma_release:
 	if (spi->dma_tx)
 		dma_release_channel(spi->dma_tx);
 	if (spi->dma_rx)
 		dma_release_channel(spi->dma_rx);
-
-	pm_runtime_disable(&pdev->dev);
 err_clk_disable:
 	clk_disable_unprepare(spi->clk);
 err_master_put:
-- 
2.30.2



