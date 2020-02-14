Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9292415F4E5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgBNPtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbgBNPtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0657B217F4;
        Fri, 14 Feb 2020 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695352;
        bh=gy6cSk/mJ9DL3eoxl/R33L4+8ze4UUWArDMHb+InQKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYkIDO7Hbs5dKI6M2CECkVcEgualeKP24JIOVXXQh1XY4X6UCXF5loMyhpfJQyopv
         0Ia9gFT4QqZ+7j0ITkEJnJ5zlEzSLbQRkGyGX0pfqdDGyR2ttJ4xgw+dTGplPDlR9L
         loQVbknkyyy0DZauk0FGl9WtrbNfwN4Mdpc8BIfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 014/542] dmaengine: ti: edma: add missed operations
Date:   Fri, 14 Feb 2020 10:40:06 -0500
Message-Id: <20200214154854.6746-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 2a03c1314506557277829562dd2ec5c11a6ea914 ]

The driver forgets to call pm_runtime_disable and pm_runtime_put_sync in
probe failure and remove.
Add the calls and modify probe failure handling to fix it.

To simplify the fix, the patch adjusts the calling order and merges checks
for devm_kcalloc.

Fixes: 2b6b3b742019 ("ARM/dmaengine: edma: Merge the two drivers under drivers/dma/")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20191124052855.6472-1-hslester96@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 756a3c951dc72..0628ee4bf1b41 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2289,13 +2289,6 @@ static int edma_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENODEV;
 
-	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0) {
-		dev_err(dev, "pm_runtime_get_sync() failed\n");
-		return ret;
-	}
-
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
@@ -2326,27 +2319,31 @@ static int edma_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ecc);
 
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "pm_runtime_get_sync() failed\n");
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
 	/* Get eDMA3 configuration from IP */
 	ret = edma_setup_from_hw(dev, info, ecc);
 	if (ret)
-		return ret;
+		goto err_disable_pm;
 
 	/* Allocate memory based on the information we got from the IP */
 	ecc->slave_chans = devm_kcalloc(dev, ecc->num_channels,
 					sizeof(*ecc->slave_chans), GFP_KERNEL);
-	if (!ecc->slave_chans)
-		return -ENOMEM;
 
 	ecc->slot_inuse = devm_kcalloc(dev, BITS_TO_LONGS(ecc->num_slots),
 				       sizeof(unsigned long), GFP_KERNEL);
-	if (!ecc->slot_inuse)
-		return -ENOMEM;
 
 	ecc->channels_mask = devm_kcalloc(dev,
 					   BITS_TO_LONGS(ecc->num_channels),
 					   sizeof(unsigned long), GFP_KERNEL);
-	if (!ecc->channels_mask)
-		return -ENOMEM;
+	if (!ecc->slave_chans || !ecc->slot_inuse || !ecc->channels_mask)
+		goto err_disable_pm;
 
 	/* Mark all channels available initially */
 	bitmap_fill(ecc->channels_mask, ecc->num_channels);
@@ -2388,7 +2385,7 @@ static int edma_probe(struct platform_device *pdev)
 				       ecc);
 		if (ret) {
 			dev_err(dev, "CCINT (%d) failed --> %d\n", irq, ret);
-			return ret;
+			goto err_disable_pm;
 		}
 		ecc->ccint = irq;
 	}
@@ -2404,7 +2401,7 @@ static int edma_probe(struct platform_device *pdev)
 				       ecc);
 		if (ret) {
 			dev_err(dev, "CCERRINT (%d) failed --> %d\n", irq, ret);
-			return ret;
+			goto err_disable_pm;
 		}
 		ecc->ccerrint = irq;
 	}
@@ -2412,7 +2409,8 @@ static int edma_probe(struct platform_device *pdev)
 	ecc->dummy_slot = edma_alloc_slot(ecc, EDMA_SLOT_ANY);
 	if (ecc->dummy_slot < 0) {
 		dev_err(dev, "Can't allocate PaRAM dummy slot\n");
-		return ecc->dummy_slot;
+		ret = ecc->dummy_slot;
+		goto err_disable_pm;
 	}
 
 	queue_priority_mapping = info->queue_priority_mapping;
@@ -2512,6 +2510,9 @@ static int edma_probe(struct platform_device *pdev)
 
 err_reg1:
 	edma_free_slot(ecc, ecc->dummy_slot);
+err_disable_pm:
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -2542,6 +2543,8 @@ static int edma_remove(struct platform_device *pdev)
 	if (ecc->dma_memcpy)
 		dma_async_device_unregister(ecc->dma_memcpy);
 	edma_free_slot(ecc, ecc->dummy_slot);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 	return 0;
 }
-- 
2.20.1

