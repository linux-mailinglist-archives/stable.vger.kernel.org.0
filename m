Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684E630CBD5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhBBThN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhBBNzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:55:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 461CC64F6D;
        Tue,  2 Feb 2021 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273490;
        bh=na+4D5poYsMqroUihQDj3Ziyc+EQ/HWCRjKo6etYIgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKHza6LqdKdSioaaW9L2vI6+sXwgCceudOa0ovbbXdP+Ygx+uLx/FJwfQA9DkkNLM
         GiQSxiM0AUuKbmS1xkMJiArlc/o2M/BwH/p7eA+y9OKlgizwuyFQ3Ou1SIJo3uaOd1
         fMxovJEyOQ0nTUp7UVm//RDCeipF/rtHyXruqzIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Yong Wu <yong.wu@mediatek.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/142] of/device: Update dma_range_map only when dev has valid dma-ranges
Date:   Tue,  2 Feb 2021 14:38:10 +0100
Message-Id: <20210202133002.937091939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 89c7cb1608ac3c7ecc19436469f35ed12da97e1d ]

The commit e0d072782c73 ("dma-mapping: introduce DMA range map,
supplanting dma_pfn_offset") always update dma_range_map even though it was
already set, like in the sunxi_mbus driver. the issue is reported at [1].
This patch avoid this(Updating it only when dev has valid dma-ranges).

Meanwhile, dma_range_map contains the devices' dma_ranges information,
This patch moves dma_range_map before of_iommu_configure. The iommu
driver may need to know the dma_address requirements of its iommu
consumer devices.

[1] https://lore.kernel.org/linux-arm-kernel/5c7946f3-b56e-da00-a750-be097c7ceb32@arm.com/

CC: Frank Rowand <frowand.list@gmail.com>
Fixes: e0d072782c73 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset"),
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210119105203.15530-1-yong.wu@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/device.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index aedfaaafd3e7e..1122daa8e2736 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -162,9 +162,11 @@ int of_dma_configure_id(struct device *dev, struct device_node *np,
 	mask = DMA_BIT_MASK(ilog2(end) + 1);
 	dev->coherent_dma_mask &= mask;
 	*dev->dma_mask &= mask;
-	/* ...but only set bus limit if we found valid dma-ranges earlier */
-	if (!ret)
+	/* ...but only set bus limit and range map if we found valid dma-ranges earlier */
+	if (!ret) {
 		dev->bus_dma_limit = end;
+		dev->dma_range_map = map;
+	}
 
 	coherent = of_dma_is_coherent(np);
 	dev_dbg(dev, "device is%sdma coherent\n",
@@ -172,6 +174,9 @@ int of_dma_configure_id(struct device *dev, struct device_node *np,
 
 	iommu = of_iommu_configure(dev, np, id);
 	if (PTR_ERR(iommu) == -EPROBE_DEFER) {
+		/* Don't touch range map if it wasn't set from a valid dma-ranges */
+		if (!ret)
+			dev->dma_range_map = NULL;
 		kfree(map);
 		return -EPROBE_DEFER;
 	}
@@ -181,7 +186,6 @@ int of_dma_configure_id(struct device *dev, struct device_node *np,
 
 	arch_setup_dma_ops(dev, dma_start, size, iommu, coherent);
 
-	dev->dma_range_map = map;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_dma_configure_id);
-- 
2.27.0



