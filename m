Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918802EDDC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbfE3Dlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbfE3DVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:17 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F07F249E9;
        Thu, 30 May 2019 03:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186476;
        bh=EgEBR+LW7aPityi0nSX6jest/8qVjEOqYTWihBjxUd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1UKHKFVqBMh/CLjwsAiWPTN4zuUGV7WXEuk/ioccdJw47GMhF9nR55uLb9cFwKXP
         B8mlraLmF8ph17dx6IxmA0ssuFZdDyNdRk2+fvZZpOzekttt4cZrh42V1pzqeK1olk
         /elfli+4eJOYEQcXFHTwzMJf6fL3ohXn+jXoeNZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 109/128] spi: tegra114: reset controller on probe
Date:   Wed, 29 May 2019 20:07:21 -0700
Message-Id: <20190530030454.205476919@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 019194933339b3e9b486639c8cb3692020844d65 ]

Fixes: SPI driver can be built as module so perform SPI controller reset
on probe to make sure it is in valid state before initiating transfer.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 73779cecc3bbc..705f515863d4f 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1067,27 +1067,19 @@ static int tegra_spi_probe(struct platform_device *pdev)
 
 	spi_irq = platform_get_irq(pdev, 0);
 	tspi->irq = spi_irq;
-	ret = request_threaded_irq(tspi->irq, tegra_spi_isr,
-			tegra_spi_isr_thread, IRQF_ONESHOT,
-			dev_name(&pdev->dev), tspi);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
-					tspi->irq);
-		goto exit_free_master;
-	}
 
 	tspi->clk = devm_clk_get(&pdev->dev, "spi");
 	if (IS_ERR(tspi->clk)) {
 		dev_err(&pdev->dev, "can not get clock\n");
 		ret = PTR_ERR(tspi->clk);
-		goto exit_free_irq;
+		goto exit_free_master;
 	}
 
 	tspi->rst = devm_reset_control_get(&pdev->dev, "spi");
 	if (IS_ERR(tspi->rst)) {
 		dev_err(&pdev->dev, "can not get reset\n");
 		ret = PTR_ERR(tspi->rst);
-		goto exit_free_irq;
+		goto exit_free_master;
 	}
 
 	tspi->max_buf_size = SPI_FIFO_DEPTH << 2;
@@ -1095,7 +1087,7 @@ static int tegra_spi_probe(struct platform_device *pdev)
 
 	ret = tegra_spi_init_dma_param(tspi, true);
 	if (ret < 0)
-		goto exit_free_irq;
+		goto exit_free_master;
 	ret = tegra_spi_init_dma_param(tspi, false);
 	if (ret < 0)
 		goto exit_rx_dma_free;
@@ -1117,18 +1109,32 @@ static int tegra_spi_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "pm runtime get failed, e = %d\n", ret);
 		goto exit_pm_disable;
 	}
+
+	reset_control_assert(tspi->rst);
+	udelay(2);
+	reset_control_deassert(tspi->rst);
 	tspi->def_command1_reg  = SPI_M_S;
 	tegra_spi_writel(tspi, tspi->def_command1_reg, SPI_COMMAND1);
 	pm_runtime_put(&pdev->dev);
+	ret = request_threaded_irq(tspi->irq, tegra_spi_isr,
+				   tegra_spi_isr_thread, IRQF_ONESHOT,
+				   dev_name(&pdev->dev), tspi);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
+			tspi->irq);
+		goto exit_pm_disable;
+	}
 
 	master->dev.of_node = pdev->dev.of_node;
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
-		goto exit_pm_disable;
+		goto exit_free_irq;
 	}
 	return ret;
 
+exit_free_irq:
+	free_irq(spi_irq, tspi);
 exit_pm_disable:
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
@@ -1136,8 +1142,6 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	tegra_spi_deinit_dma_param(tspi, false);
 exit_rx_dma_free:
 	tegra_spi_deinit_dma_param(tspi, true);
-exit_free_irq:
-	free_irq(spi_irq, tspi);
 exit_free_master:
 	spi_master_put(master);
 	return ret;
-- 
2.20.1



