Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C2C451180
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244075AbhKOTJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243917AbhKOTGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35845633E2;
        Mon, 15 Nov 2021 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000218;
        bh=CFXS1u4qRTc7afPfjhlRHbeAmzRsEPpHU+N06nAlPA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXMRuZBdLn6xoowB8ZvkBLcAGcvHAU7nkUfnzuuRbnd9Njf5aJNdShNq8sOswO+Yc
         npOW87puNZhVo5G1tC32cwsLk/ZVJvXtDmYD9WOC/T+iSRQO9CHt/U/COhfoTK8AnM
         A579XE1E9yoCMqWyQJUWnSe50vjVONhtDg39SXw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@chromium.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 581/849] iommu/dma: Fix arch_sync_dma for map
Date:   Mon, 15 Nov 2021 18:01:04 +0100
Message-Id: <20211115165439.906695972@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

[ Upstream commit 06e620345d544e559b2961cb5a676ec9c80c8950 ]

When calling arch_sync_dma, we need to pass it the memory that's
actually being used for dma. When using swiotlb bounce buffers, this is
the bounce buffer. Move arch_sync_dma into the __iommu_dma_map_swiotlb
helper, so it can use the bounce buffer address if necessary.

Now that iommu_dma_map_sg delegates to a function which takes care of
architectural syncing in the untrusted device case, the call to
iommu_dma_sync_sg_for_device can be moved so it only occurs for trusted
devices. Doing the sync for untrusted devices before mapping never
really worked, since it needs to be able to target swiotlb buffers.

This also moves the architectural sync to before the call to
__iommu_dma_map, to guarantee that untrusted devices can't see stale
data they shouldn't see.

Fixes: 82612d66d51d ("iommu: Allow the iommu/dma api to use bounce buffers")
Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20210929023300.335969-3-stevensd@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 6f0df629353fd..f27f8d20fe68b 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -576,6 +576,9 @@ static dma_addr_t __iommu_dma_map_swiotlb(struct device *dev, phys_addr_t phys,
 		memset(padding_start, 0, padding_size);
 	}
 
+	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		arch_sync_dma_for_device(phys, org_size, dir);
+
 	iova = __iommu_dma_map(dev, phys, aligned_size, prot, dma_mask);
 	if (iova == DMA_MAPPING_ERROR && is_swiotlb_buffer(phys))
 		swiotlb_tbl_unmap_single(dev, phys, org_size, dir, attrs);
@@ -850,14 +853,9 @@ static dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
 	bool coherent = dev_is_dma_coherent(dev);
-	dma_addr_t dma_handle;
 
-	dma_handle = __iommu_dma_map_swiotlb(dev, phys, size, dma_get_mask(dev),
+	return __iommu_dma_map_swiotlb(dev, phys, size, dma_get_mask(dev),
 			coherent, dir, attrs);
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    dma_handle != DMA_MAPPING_ERROR)
-		arch_sync_dma_for_device(phys, size, dir);
-	return dma_handle;
 }
 
 static void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
@@ -1000,12 +998,12 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	    iommu_deferred_attach(dev, domain))
 		return 0;
 
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		iommu_dma_sync_sg_for_device(dev, sg, nents, dir);
-
 	if (dev_is_untrusted(dev))
 		return iommu_dma_map_sg_swiotlb(dev, sg, nents, dir, attrs);
 
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		iommu_dma_sync_sg_for_device(dev, sg, nents, dir);
+
 	/*
 	 * Work out how much IOVA space we need, and align the segments to
 	 * IOVA granules for the IOMMU driver to handle. With some clever
-- 
2.33.0



