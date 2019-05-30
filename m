Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896AD2F505
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfE3Enm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbfE3DMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C871A24481;
        Thu, 30 May 2019 03:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185928;
        bh=k/DFDhT28fNL96xS6/KX2l6JDpDseEomSmkyL5TdaSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvZ0p0ZwZ6WXO3nqGmsgf9+pZzXXYqbh8giMiOXzhj0FZFNeH0We40r9Ci5+VwsPK
         79WByEqLcz2nLMFCwwbmApSt6ce2IaD3UKYEo7ejciG8/6QVW/TrXLr8tUaMZ/9R1D
         Ws6wrRbKlRiS3QnjPY5NfriW/u36xqnmcjQ690ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar D <mkumard@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 321/405] dmaengine: tegra210-adma: use devm_clk_*() helpers
Date:   Wed, 29 May 2019 20:05:19 -0700
Message-Id: <20190530030556.994716092@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f6ed6491d565c336a360471e0c29228e34f4380e ]

adma driver is using pm_clk_*() interface for managing clock resources.
With this it is observed that clocks remain ON always. This happens on
Tegra devices which use BPMP co-processor to manage clock resources,
where clocks are enabled during prepare phase. This is necessary because
clocks to BPMP are always blocking. When pm_clk_*() interface is used on
such Tegra devices, clock prepare count is not balanced till remove call
happens for the driver and hence clocks are seen ON always. Thus this
patch replaces pm_clk_*() with devm_clk_*() framework.

Suggested-by: Mohan Kumar D <mkumard@nvidia.com>
Reviewed-by: Jonathan Hunter <jonathanh@nvidia.com>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra210-adma.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index 9aa35a7f13692..1477cce33dbe5 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -22,7 +22,6 @@
 #include <linux/of_device.h>
 #include <linux/of_dma.h>
 #include <linux/of_irq.h>
-#include <linux/pm_clock.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
@@ -141,6 +140,7 @@ struct tegra_adma {
 	struct dma_device		dma_dev;
 	struct device			*dev;
 	void __iomem			*base_addr;
+	struct clk			*ahub_clk;
 	unsigned int			nr_channels;
 	unsigned long			rx_requests_reserved;
 	unsigned long			tx_requests_reserved;
@@ -637,8 +637,9 @@ static int tegra_adma_runtime_suspend(struct device *dev)
 	struct tegra_adma *tdma = dev_get_drvdata(dev);
 
 	tdma->global_cmd = tdma_read(tdma, ADMA_GLOBAL_CMD);
+	clk_disable_unprepare(tdma->ahub_clk);
 
-	return pm_clk_suspend(dev);
+	return 0;
 }
 
 static int tegra_adma_runtime_resume(struct device *dev)
@@ -646,10 +647,11 @@ static int tegra_adma_runtime_resume(struct device *dev)
 	struct tegra_adma *tdma = dev_get_drvdata(dev);
 	int ret;
 
-	ret = pm_clk_resume(dev);
-	if (ret)
+	ret = clk_prepare_enable(tdma->ahub_clk);
+	if (ret) {
+		dev_err(dev, "ahub clk_enable failed: %d\n", ret);
 		return ret;
-
+	}
 	tdma_write(tdma, ADMA_GLOBAL_CMD, tdma->global_cmd);
 
 	return 0;
@@ -693,13 +695,11 @@ static int tegra_adma_probe(struct platform_device *pdev)
 	if (IS_ERR(tdma->base_addr))
 		return PTR_ERR(tdma->base_addr);
 
-	ret = pm_clk_create(&pdev->dev);
-	if (ret)
-		return ret;
-
-	ret = of_pm_clk_add_clk(&pdev->dev, "d_audio");
-	if (ret)
-		goto clk_destroy;
+	tdma->ahub_clk = devm_clk_get(&pdev->dev, "d_audio");
+	if (IS_ERR(tdma->ahub_clk)) {
+		dev_err(&pdev->dev, "Error: Missing ahub controller clock\n");
+		return PTR_ERR(tdma->ahub_clk);
+	}
 
 	pm_runtime_enable(&pdev->dev);
 
@@ -776,8 +776,6 @@ static int tegra_adma_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 rpm_disable:
 	pm_runtime_disable(&pdev->dev);
-clk_destroy:
-	pm_clk_destroy(&pdev->dev);
 
 	return ret;
 }
@@ -795,7 +793,6 @@ static int tegra_adma_remove(struct platform_device *pdev)
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	pm_clk_destroy(&pdev->dev);
 
 	return 0;
 }
-- 
2.20.1



