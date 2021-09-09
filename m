Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1059A404F12
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbhIIMQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350475AbhIIMNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D49361A59;
        Thu,  9 Sep 2021 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188145;
        bh=e4DRZx/VtfqC41DV1FiYS0p26W6OqaMolJo8boE3nZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h769yLhcv7/B4d+UKZHgvsHhnsKEXKkgUlg311u+784q6CXqw2sHT/D/zLeH85FlE
         /X3MGJuqd1p8h4c/LSeYijJ1jWHOOZI+3OVpmSAjgt1Dd0/Q4ubsTCWSz9A8m6sPG5
         PT0znNlnLX+2z3HWwTm+JsfWNCxpo/+EYje/TuSphcjB1lvvLRlNg8r5FeixY/Gtwe
         sKVX4yRqvitpnOeKt9AQRUQTYp5ULyjzFBc6VC8iqCv7w/oLj+hDz0rF/aRRLjZJb/
         m5OJCbwx65aYRHvR4EoQ6klta5LS77Oe5OVKxGILzokT7D3+FA37DutjPudVkyZWzp
         qykAxHSxvZaDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 116/219] spi: tegra20-slink: Improve runtime PM usage
Date:   Thu,  9 Sep 2021 07:44:52 -0400
Message-Id: <20210909114635.143983-116-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit e4bb903fda0e9bbafa1338dcd2ee5e4d3ccc50da ]

The Tegra SPI driver supports runtime PM, which controls the clock
enable state, but the clk is also enabled separately from the RPM
at the driver probe time, and thus, stays always on. Fix it.

Runtime PM now is always available on Tegra, hence there is no need to
check the RPM presence in the driver anymore. Remove these checks.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210731192731.5869-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 73 +++++++++++----------------------
 1 file changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 6a726c95ac7a..501eca1d0f89 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1061,33 +1061,12 @@ static int tegra_slink_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Can not get clock %d\n", ret);
 		goto exit_free_master;
 	}
-	ret = clk_prepare(tspi->clk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Clock prepare failed %d\n", ret);
-		goto exit_free_master;
-	}
-	ret = clk_enable(tspi->clk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Clock enable failed %d\n", ret);
-		goto exit_clk_unprepare;
-	}
-
-	spi_irq = platform_get_irq(pdev, 0);
-	tspi->irq = spi_irq;
-	ret = request_threaded_irq(tspi->irq, tegra_slink_isr,
-			tegra_slink_isr_thread, IRQF_ONESHOT,
-			dev_name(&pdev->dev), tspi);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
-					tspi->irq);
-		goto exit_clk_disable;
-	}
 
 	tspi->rst = devm_reset_control_get_exclusive(&pdev->dev, "spi");
 	if (IS_ERR(tspi->rst)) {
 		dev_err(&pdev->dev, "can not get reset\n");
 		ret = PTR_ERR(tspi->rst);
-		goto exit_free_irq;
+		goto exit_free_master;
 	}
 
 	tspi->max_buf_size = SLINK_FIFO_DEPTH << 2;
@@ -1095,7 +1074,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 
 	ret = tegra_slink_init_dma_param(tspi, true);
 	if (ret < 0)
-		goto exit_free_irq;
+		goto exit_free_master;
 	ret = tegra_slink_init_dma_param(tspi, false);
 	if (ret < 0)
 		goto exit_rx_dma_free;
@@ -1106,16 +1085,9 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	init_completion(&tspi->xfer_completion);
 
 	pm_runtime_enable(&pdev->dev);
-	if (!pm_runtime_enabled(&pdev->dev)) {
-		ret = tegra_slink_runtime_resume(&pdev->dev);
-		if (ret)
-			goto exit_pm_disable;
-	}
-
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
 		dev_err(&pdev->dev, "pm runtime get failed, e = %d\n", ret);
-		pm_runtime_put_noidle(&pdev->dev);
 		goto exit_pm_disable;
 	}
 
@@ -1123,33 +1095,43 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	udelay(2);
 	reset_control_deassert(tspi->rst);
 
+	spi_irq = platform_get_irq(pdev, 0);
+	tspi->irq = spi_irq;
+	ret = request_threaded_irq(tspi->irq, tegra_slink_isr,
+				   tegra_slink_isr_thread, IRQF_ONESHOT,
+				   dev_name(&pdev->dev), tspi);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
+			tspi->irq);
+		goto exit_pm_put;
+	}
+
 	tspi->def_command_reg  = SLINK_M_S;
 	tspi->def_command2_reg = SLINK_CS_ACTIVE_BETWEEN;
 	tegra_slink_writel(tspi, tspi->def_command_reg, SLINK_COMMAND);
 	tegra_slink_writel(tspi, tspi->def_command2_reg, SLINK_COMMAND2);
-	pm_runtime_put(&pdev->dev);
 
 	master->dev.of_node = pdev->dev.of_node;
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
-		goto exit_pm_disable;
+		goto exit_free_irq;
 	}
+
+	pm_runtime_put(&pdev->dev);
+
 	return ret;
 
+exit_free_irq:
+	free_irq(spi_irq, tspi);
+exit_pm_put:
+	pm_runtime_put(&pdev->dev);
 exit_pm_disable:
 	pm_runtime_disable(&pdev->dev);
-	if (!pm_runtime_status_suspended(&pdev->dev))
-		tegra_slink_runtime_suspend(&pdev->dev);
+
 	tegra_slink_deinit_dma_param(tspi, false);
 exit_rx_dma_free:
 	tegra_slink_deinit_dma_param(tspi, true);
-exit_free_irq:
-	free_irq(spi_irq, tspi);
-exit_clk_disable:
-	clk_disable(tspi->clk);
-exit_clk_unprepare:
-	clk_unprepare(tspi->clk);
 exit_free_master:
 	spi_master_put(master);
 	return ret;
@@ -1162,8 +1144,7 @@ static int tegra_slink_remove(struct platform_device *pdev)
 
 	free_irq(tspi->irq, tspi);
 
-	clk_disable(tspi->clk);
-	clk_unprepare(tspi->clk);
+	pm_runtime_disable(&pdev->dev);
 
 	if (tspi->tx_dma_chan)
 		tegra_slink_deinit_dma_param(tspi, false);
@@ -1171,10 +1152,6 @@ static int tegra_slink_remove(struct platform_device *pdev)
 	if (tspi->rx_dma_chan)
 		tegra_slink_deinit_dma_param(tspi, true);
 
-	pm_runtime_disable(&pdev->dev);
-	if (!pm_runtime_status_suspended(&pdev->dev))
-		tegra_slink_runtime_suspend(&pdev->dev);
-
 	return 0;
 }
 
-- 
2.30.2

