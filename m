Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D5A4F3A2F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379280AbiDELkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354469AbiDEKOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C24F69481;
        Tue,  5 Apr 2022 03:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009F4B81C83;
        Tue,  5 Apr 2022 10:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54756C385A2;
        Tue,  5 Apr 2022 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152822;
        bh=6eCefiu0qU3wHhPgqE6IGn/CVT8lbZBRCHYxck/xt6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MczamD5pWusMNAdZe/rjLlRy5EQRat7xyCfRzZTJ33H8DMYRTAaSycVGwVnhabMtM
         waiZAkZRV+lUA72wpm8GJ7Eaxw5BZra34uxRP0tYiuWqyNgwPkJESnz0jF7vrhN7UE
         gpnhRaucxLlkI7b5jkGCZ/6iMKoe0CjR1i/R+KRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@chromium.org>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <jroedel@suse.de>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 908/913] swiotlb: Support aligned swiotlb buffers
Date:   Tue,  5 Apr 2022 09:32:50 +0200
Message-Id: <20220405070407.037113146@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

commit e81e99bacc9f9347bda7808a949c1ce9fcc2bbf4 upstream.

Add an argument to swiotlb_tbl_map_single that specifies the desired
alignment of the allocated buffer. This is used by dma-iommu to ensure
the buffer is aligned to the iova granule size when using swiotlb with
untrusted sub-granule mappings. This addresses an issue where adjacent
slots could be exposed to the untrusted device if IO_TLB_SIZE < iova
granule < PAGE_SIZE.

Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210929023300.335969-7-stevensd@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dma-iommu.c |    4 ++--
 drivers/xen/swiotlb-xen.c |    2 +-
 include/linux/swiotlb.h   |    3 ++-
 kernel/dma/swiotlb.c      |   13 ++++++++-----
 4 files changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -818,8 +818,8 @@ static dma_addr_t iommu_dma_map_page(str
 		size_t padding_size;
 
 		aligned_size = iova_align(iovad, size);
-		phys = swiotlb_tbl_map_single(dev, phys, size,
-					      aligned_size, dir, attrs);
+		phys = swiotlb_tbl_map_single(dev, phys, size, aligned_size,
+					      iova_mask(iovad), dir, attrs);
 
 		if (phys == DMA_MAPPING_ERROR)
 			return DMA_MAPPING_ERROR;
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -380,7 +380,7 @@ static dma_addr_t xen_swiotlb_map_page(s
 	 */
 	trace_swiotlb_bounced(dev, dev_addr, size, swiotlb_force);
 
-	map = swiotlb_tbl_map_single(dev, phys, size, size, dir, attrs);
+	map = swiotlb_tbl_map_single(dev, phys, size, size, 0, dir, attrs);
 	if (map == (phys_addr_t)DMA_MAPPING_ERROR)
 		return DMA_MAPPING_ERROR;
 
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -45,7 +45,8 @@ extern void __init swiotlb_update_mem_at
 
 phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
 		size_t mapping_size, size_t alloc_size,
-		enum dma_data_direction dir, unsigned long attrs);
+		unsigned int alloc_aligned_mask, enum dma_data_direction dir,
+		unsigned long attrs);
 
 extern void swiotlb_tbl_unmap_single(struct device *hwdev,
 				     phys_addr_t tlb_addr,
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -459,7 +459,7 @@ static unsigned int wrap_index(struct io
  * allocate a buffer from that IO TLB pool.
  */
 static int swiotlb_find_slots(struct device *dev, phys_addr_t orig_addr,
-			      size_t alloc_size)
+			      size_t alloc_size, unsigned int alloc_align_mask)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	unsigned long boundary_mask = dma_get_seg_boundary(dev);
@@ -483,6 +483,7 @@ static int swiotlb_find_slots(struct dev
 	stride = (iotlb_align_mask >> IO_TLB_SHIFT) + 1;
 	if (alloc_size >= PAGE_SIZE)
 		stride = max(stride, stride << (PAGE_SHIFT - IO_TLB_SHIFT));
+	stride = max(stride, (alloc_align_mask >> IO_TLB_SHIFT) + 1);
 
 	spin_lock_irqsave(&mem->lock, flags);
 	if (unlikely(nslots > mem->nslabs - mem->used))
@@ -541,7 +542,8 @@ found:
 
 phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		size_t mapping_size, size_t alloc_size,
-		enum dma_data_direction dir, unsigned long attrs)
+		unsigned int alloc_align_mask, enum dma_data_direction dir,
+		unsigned long attrs)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
@@ -561,7 +563,8 @@ phys_addr_t swiotlb_tbl_map_single(struc
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
-	index = swiotlb_find_slots(dev, orig_addr, alloc_size + offset);
+	index = swiotlb_find_slots(dev, orig_addr,
+				   alloc_size + offset, alloc_align_mask);
 	if (index == -1) {
 		if (!(attrs & DMA_ATTR_NO_WARN))
 			dev_warn_ratelimited(dev,
@@ -680,7 +683,7 @@ dma_addr_t swiotlb_map(struct device *de
 	trace_swiotlb_bounced(dev, phys_to_dma(dev, paddr), size,
 			      swiotlb_force);
 
-	swiotlb_addr = swiotlb_tbl_map_single(dev, paddr, size, size, dir,
+	swiotlb_addr = swiotlb_tbl_map_single(dev, paddr, size, size, 0, dir,
 			attrs);
 	if (swiotlb_addr == (phys_addr_t)DMA_MAPPING_ERROR)
 		return DMA_MAPPING_ERROR;
@@ -764,7 +767,7 @@ struct page *swiotlb_alloc(struct device
 	if (!mem)
 		return NULL;
 
-	index = swiotlb_find_slots(dev, 0, size);
+	index = swiotlb_find_slots(dev, 0, size, 0);
 	if (index == -1)
 		return NULL;
 


