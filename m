Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A672451432
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbhKOUCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344300AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C22633D2;
        Mon, 15 Nov 2021 18:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002525;
        bh=qNAaiD4oRJtdFgsCcRZsICSHAD4rUUz5qklq0epcFww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kO+sS9MG1k/h8EMzHwMesXqHq0iUjvz4fIZ2mnn3FlC6nA0cmEBjDh/jHlAsox0J2
         MMJmq0Hg4ErIjkgLUf8Oxnh4M1j2lv82gMmP6Z5oRbOmgy4EENLkM+MwqACwVx+RzF
         c0dlZCHaWvBT/eKjxIDOVPIFcTBpbpUi1k4mcg1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 601/917] iommu/dma: Fix sync_sg with swiotlb
Date:   Mon, 15 Nov 2021 18:01:36 +0100
Message-Id: <20211115165449.141740772@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

[ Upstream commit 08ae5d4a1ae96b72222e7b02d072bb997ff29dac ]

The is_swiotlb_buffer function takes the physical address of the swiotlb
buffer, not the physical address of the original buffer. The sglist
contains the physical addresses of the original buffer, so for the
sync_sg functions to work properly when a bounce buffer might have been
used, we need to use iommu_iova_to_phys to look up the physical address.
This is what sync_single does, so call that function on each sglist
segment.

The previous code mostly worked because swiotlb does the transfer on map
and unmap. However, any callers which use DMA_ATTR_SKIP_CPU_SYNC with
sglists or which call sync_sg would not have had anything copied to the
bounce buffer.

Fixes: 82612d66d51d ("iommu: Allow the iommu/dma api to use bounce buffers")
Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210929023300.335969-2-stevensd@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 896bea04c347e..c4d205b63c582 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -828,17 +828,13 @@ static void iommu_dma_sync_sg_for_cpu(struct device *dev,
 	struct scatterlist *sg;
 	int i;
 
-	if (dev_is_dma_coherent(dev) && !dev_is_untrusted(dev))
-		return;
-
-	for_each_sg(sgl, sg, nelems, i) {
-		if (!dev_is_dma_coherent(dev))
+	if (dev_is_untrusted(dev))
+		for_each_sg(sgl, sg, nelems, i)
+			iommu_dma_sync_single_for_cpu(dev, sg_dma_address(sg),
+						      sg->length, dir);
+	else if (!dev_is_dma_coherent(dev))
+		for_each_sg(sgl, sg, nelems, i)
 			arch_sync_dma_for_cpu(sg_phys(sg), sg->length, dir);
-
-		if (is_swiotlb_buffer(dev, sg_phys(sg)))
-			swiotlb_sync_single_for_cpu(dev, sg_phys(sg),
-						    sg->length, dir);
-	}
 }
 
 static void iommu_dma_sync_sg_for_device(struct device *dev,
@@ -848,17 +844,14 @@ static void iommu_dma_sync_sg_for_device(struct device *dev,
 	struct scatterlist *sg;
 	int i;
 
-	if (dev_is_dma_coherent(dev) && !dev_is_untrusted(dev))
-		return;
-
-	for_each_sg(sgl, sg, nelems, i) {
-		if (is_swiotlb_buffer(dev, sg_phys(sg)))
-			swiotlb_sync_single_for_device(dev, sg_phys(sg),
-						       sg->length, dir);
-
-		if (!dev_is_dma_coherent(dev))
+	if (dev_is_untrusted(dev))
+		for_each_sg(sgl, sg, nelems, i)
+			iommu_dma_sync_single_for_device(dev,
+							 sg_dma_address(sg),
+							 sg->length, dir);
+	else if (!dev_is_dma_coherent(dev))
+		for_each_sg(sgl, sg, nelems, i)
 			arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
-	}
 }
 
 static dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
-- 
2.33.0



