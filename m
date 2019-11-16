Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6EFED43
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfKPPmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbfKPPmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C39B420733;
        Sat, 16 Nov 2019 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918971;
        bh=sgtYBds0vlLgYVSZg75gyqmnkTu5AZWC7qxCtXuwRSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehl8uc5HXzzkhqib2b5a6Ok3+AHhCerbVuEIeaPkqtm1iCDAfLrYoi4A4k1CIBvPz
         XSI9UphBFB2TkD0zb7hgVXqc2H6kEdKj7kuv+cdaAZ1srl/O7oiIuR/2Bs7cLIbQvv
         AbW685RxwhSDYnQe/kd9UswjfU6HVkfxBDU5PmGU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 086/237] swiotlb: do not panic on mapping failures
Date:   Sat, 16 Nov 2019 10:38:41 -0500
Message-Id: <20191116154113.7417-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 8088546832aa2c0d8f99dd56edf6384f8a9b63b3 ]

All properly written drivers now have error handling in the
dma_map_single / dma_map_page callers.  As swiotlb_tbl_map_single already
prints a useful warning when running out of swiotlb pool space we can
also remove swiotlb_full entirely as it serves no purpose now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 4f8a6dbf0b609..2a8c41f12d450 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -761,34 +761,6 @@ static bool swiotlb_free_buffer(struct device *dev, size_t size,
 	return true;
 }
 
-static void
-swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
-	     int do_panic)
-{
-	if (swiotlb_force == SWIOTLB_NO_FORCE)
-		return;
-
-	/*
-	 * Ran out of IOMMU space for this operation. This is very bad.
-	 * Unfortunately the drivers cannot handle this operation properly.
-	 * unless they check for dma_mapping_error (most don't)
-	 * When the mapping is small enough return a static buffer to limit
-	 * the damage, or panic when the transfer is too big.
-	 */
-	dev_err_ratelimited(dev, "DMA: Out of SW-IOMMU space for %zu bytes\n",
-			    size);
-
-	if (size <= io_tlb_overflow || !do_panic)
-		return;
-
-	if (dir == DMA_BIDIRECTIONAL)
-		panic("DMA: Random memory could be DMA accessed\n");
-	if (dir == DMA_FROM_DEVICE)
-		panic("DMA: Random memory could be DMA written\n");
-	if (dir == DMA_TO_DEVICE)
-		panic("DMA: Random memory could be DMA read\n");
-}
-
 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.  The
  * physical address to use is returned.
@@ -817,10 +789,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 
 	/* Oh well, have to allocate and map a bounce buffer. */
 	map = map_single(dev, phys, size, dir, attrs);
-	if (map == SWIOTLB_MAP_ERROR) {
-		swiotlb_full(dev, size, dir, 1);
+	if (map == SWIOTLB_MAP_ERROR)
 		return __phys_to_dma(dev, io_tlb_overflow_buffer);
-	}
 
 	dev_addr = __phys_to_dma(dev, map);
 
@@ -954,7 +924,6 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 			if (map == SWIOTLB_MAP_ERROR) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
-				swiotlb_full(hwdev, sg->length, dir, 0);
 				attrs |= DMA_ATTR_SKIP_CPU_SYNC;
 				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 						       attrs);
-- 
2.20.1

