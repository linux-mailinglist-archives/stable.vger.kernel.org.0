Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B093437C80B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhELQEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235255AbhELP7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C7261952;
        Wed, 12 May 2021 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833533;
        bh=nXDLBNMrHYxJwDY+JVZ/Pfhp5PNeJ7cfxZNcM0lP47I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO4Boc6YHoTfCW+dEkit+AS7uCTgxvOZtq1bUf30nExuazt+4dpvJxaGbTO3kzhQ6
         26FpT+77mZLOQdH1MwPXpX1SGexDer9RfBxfvAB9gj1xyd7wLqEYImcurqSu296pvY
         YltuTE/yZ0xKg3cBEOOh69u+pcGsAX70gsbz7SY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Alain Volmat <alain.volmat@foss.st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 188/601] spi: stm32: Fix use-after-free on unbind
Date:   Wed, 12 May 2021 16:44:25 +0200
Message-Id: <20210512144834.030504168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 79c6246ae8793448c05da86a4c82298eed8549b0 ]

stm32_spi_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: 8d559a64f00b ("spi: stm32: drop devres version of spi_register_master")

Reported-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/1616052290-10887-1-git-send-email-alain.volmat@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 8d8a32d46f2d..0318f02d6212 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1830,7 +1830,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct stm32_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct stm32_spi));
 	if (!master) {
 		dev_err(&pdev->dev, "spi master allocation failed\n");
 		return -ENOMEM;
@@ -1848,18 +1848,16 @@ static int stm32_spi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	spi->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(spi->base)) {
-		ret = PTR_ERR(spi->base);
-		goto err_master_put;
-	}
+	if (IS_ERR(spi->base))
+		return PTR_ERR(spi->base);
 
 	spi->phys_addr = (dma_addr_t)res->start;
 
 	spi->irq = platform_get_irq(pdev, 0);
-	if (spi->irq <= 0) {
-		ret = dev_err_probe(&pdev->dev, spi->irq, "failed to get irq\n");
-		goto err_master_put;
-	}
+	if (spi->irq <= 0)
+		return dev_err_probe(&pdev->dev, spi->irq,
+				     "failed to get irq\n");
+
 	ret = devm_request_threaded_irq(&pdev->dev, spi->irq,
 					spi->cfg->irq_handler_event,
 					spi->cfg->irq_handler_thread,
@@ -1867,20 +1865,20 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(&pdev->dev, "irq%d request failed: %d\n", spi->irq,
 			ret);
-		goto err_master_put;
+		return ret;
 	}
 
 	spi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(spi->clk)) {
 		ret = PTR_ERR(spi->clk);
 		dev_err(&pdev->dev, "clk get failed: %d\n", ret);
-		goto err_master_put;
+		return ret;
 	}
 
 	ret = clk_prepare_enable(spi->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "clk enable failed: %d\n", ret);
-		goto err_master_put;
+		return ret;
 	}
 	spi->clk_rate = clk_get_rate(spi->clk);
 	if (!spi->clk_rate) {
@@ -1976,8 +1974,6 @@ err_dma_release:
 		dma_release_channel(spi->dma_rx);
 err_clk_disable:
 	clk_disable_unprepare(spi->clk);
-err_master_put:
-	spi_master_put(master);
 
 	return ret;
 }
-- 
2.30.2



