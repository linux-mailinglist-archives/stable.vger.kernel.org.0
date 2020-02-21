Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B552F1678AB
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgBUHoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:44:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbgBUHoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83915207FD;
        Fri, 21 Feb 2020 07:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271042;
        bh=gy6cSk/mJ9DL3eoxl/R33L4+8ze4UUWArDMHb+InQKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erVDM82bc/gO7s0gB+mssSPxiBfYccJUcxOl7qvD9SxIdy7rg4cLg2BmEvjFH5ide
         QS5SOdG8d8TqWPTvI33BmYrZ+s4kszP0IBp8OI9PKwEJi7VwYruNvucrar7x61cwWC
         In2fVKe9S/rdopf9RCtpxjUq/mPqGlULypoh9Qkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 018/399] dmaengine: ti: edma: add missed operations
Date:   Fri, 21 Feb 2020 08:35:43 +0100
Message-Id: <20200221072404.100592581@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



