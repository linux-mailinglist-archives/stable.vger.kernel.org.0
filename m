Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDDC10BA3F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfK0VBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbfK0VBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DEC020862;
        Wed, 27 Nov 2019 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888473;
        bh=sgtYBds0vlLgYVSZg75gyqmnkTu5AZWC7qxCtXuwRSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZj98cSbR3ZxhV4SezhQsJPt6MmzkCOKTn63KErh2qeH1L4air0MlGP6eO5NOs6YA
         3k/r90rjG08IfBqf4Du002bYq+aBwtybWTiW6R0O9QIlqEkRLIBKNOBF23YQM5uBXI
         q6iCH/skxMcBafGAMIBBo2AxBd3fBxI0pdL5p540=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/306] swiotlb: do not panic on mapping failures
Date:   Wed, 27 Nov 2019 21:29:15 +0100
Message-Id: <20191127203123.013432076@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



