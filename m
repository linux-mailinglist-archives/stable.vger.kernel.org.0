Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B1036EEFB
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbhD2Rfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD2Rfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64C0C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c2-20020a1709027242b02900e9636a90acso29231450pll.12
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P+y0Cx6YlUcuB23DD5kQr2szixapkEODz5+veEbGVLo=;
        b=e+X87rCeApjEWuD9YWo5Ejv5aehOiYGuDUYK/lxddBwshBY9xPI/yUVMxtuf80ve7+
         8ronD5vd5KLQm3MXck5yERca901kOHUqN+cwyOpIaKubkE+KDTamNM0RmFXbq29FoqI7
         Ci9M4hsZcotbgoTrc050L3ZIRTvTFh84LHXFT0IIYQ7cdaKXFyOOrpjHPiVjClT4EFYS
         aRm0TupS0a04pNfAlqYugMxugsSmgiKg8uk1U8H7JRkOVTRkfdt6xOoSu1oUYMhDYM5d
         GRdEM9pQbBEe6M4WP3stYstFg7bvC1KlZNqXNUnOdoiTSuz6KRGrcTtWxhw/etM+Kjbz
         pZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P+y0Cx6YlUcuB23DD5kQr2szixapkEODz5+veEbGVLo=;
        b=RbprEJcr3fcIkSLEyM9lIr+HwHoKAwKAGp7CVRysfkMg+ksQLJEIU+GMzulXUhUMvJ
         yArz7uxemdgO/1CAQgAx3x6jqZGQ5w+rPUVk2uhyQYxIyDHazSvm0sUjXZ4n0fmTgUp2
         FiT83GxDVCOAifjuyvo3y0Ljp6UPGUrz3fqbC7EwetKOe4zLGUVhd5GrBdVgWdBdjCMV
         LubdVHMIJqXr3m6q0isr7OhWlSdnLYf7dz2Rb40SKuzQocunb6a/wVuU7r0L+WGJWM8I
         ICNONDJKiJu24Ybe0COjP00pIGWGgaAXnINII28RG6ZSemBYpYLQW2o9kdWqWzoHaPGR
         KoFg==
X-Gm-Message-State: AOAM533ZWBcNI3gpYiywWN62BLOooVtrp6obW2GQmPAhRi9px2ozNfu2
        kFpRTE9H6LtSqKTbrWpYUP5qktNRpvh1n4zAafVpZ/4Nanzl6hbVSsAdBRhdE/Tqbr/1plPYJfn
        /pmqr7vOAXhi9A2pYz8VfQNz7HP/gb2vOkE7breGygQJjSvprz9Sh0cAzbkg=
X-Google-Smtp-Source: ABdhPJwHsjs4p1YVOF5dY0oTz8EVuQDNh/HjTXZrHAA+T4+yXU+c4HX9+Fmo9WJxM/WZJA4kH1IfUbsBZQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:e892:b029:ec:d257:b8a2 with SMTP id
 w18-20020a170902e892b02900ecd257b8a2mr749353plg.15.1619717691204; Thu, 29 Apr
 2021 10:34:51 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:14 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-9-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 8/9] swiotlb: respect min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: 1f221a0d0dbf0e48ef3a9c62871281d6a7819f05

swiotlb: respect min_align_mask

Respect the min_align_mask in struct device_dma_parameters in swiotlb.

There are two parts to it:
 1) for the lower bits of the alignment inside the io tlb slot, just
    extent the size of the allocation and leave the start of the slot
     empty
 2) for the high bits ensure we find a slot that matches the high bits
    of the alignment to avoid wasting too much memory

Based on an earlier patch from Jianxiong Gao <jxgao@google.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index b8f82f96c4c2..ba4055a192e4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -454,6 +454,14 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 
 #define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
 
+/*
+ * Return the offset into a iotlb slot required to keep the device happy.
+ */
+static unsigned int swiotlb_align_offset(struct device *dev, u64 addr)
+{
+	return addr & dma_get_min_align_mask(dev) & (IO_TLB_SIZE - 1);
+}
+
 /*
  * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
  */
@@ -475,24 +483,29 @@ static unsigned int wrap_index(unsigned int index)
  * Find a suitable number of IO TLB entries size that will fit this request and
  * allocate a buffer from that IO TLB pool.
  */
-static int find_slots(struct device *dev, size_t alloc_size)
+static int find_slots(struct device *dev, phys_addr_t orig_addr,
+		size_t alloc_size)
 {
 	unsigned long boundary_mask = dma_get_seg_boundary(dev);
 	dma_addr_t tbl_dma_addr =
 		phys_to_dma_unencrypted(dev, io_tlb_start) & boundary_mask;
 	unsigned long max_slots = get_max_slots(boundary_mask);
-	unsigned int nslots = nr_slots(alloc_size), stride = 1;
+	unsigned int iotlb_align_mask =
+		dma_get_min_align_mask(dev) & ~(IO_TLB_SIZE - 1);
+	unsigned int nslots = nr_slots(alloc_size), stride;
 	unsigned int index, wrap, count = 0, i;
 	unsigned long flags;
 
 	BUG_ON(!nslots);
 
 	/*
-	 * For mappings greater than or equal to a page, we limit the stride
-	 * (and hence alignment) to a page size.
+	 * For mappings with an alignment requirement don't bother looping to
+	 * unaligned slots once we found an aligned one.  For allocations of
+	 * PAGE_SIZE or larger only look for page aligned allocations.
 	 */
+	stride = (iotlb_align_mask >> IO_TLB_SHIFT) + 1;
 	if (alloc_size >= PAGE_SIZE)
-		stride <<= (PAGE_SHIFT - IO_TLB_SHIFT);
+		stride = max(stride, stride << (PAGE_SHIFT - IO_TLB_SHIFT));
 
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	if (unlikely(nslots > io_tlb_nslabs - io_tlb_used))
@@ -500,6 +513,12 @@ static int find_slots(struct device *dev, size_t alloc_size)
 
 	index = wrap = wrap_index(ALIGN(io_tlb_index, stride));
 	do {
+		if ((slot_addr(tbl_dma_addr, index) & iotlb_align_mask) !=
+		    (orig_addr & iotlb_align_mask)) {
+			index = wrap_index(index + 1);
+			continue;
+		}
+
 		/*
 		 * If we find a slot that indicates we have 'nslots' number of
 		 * contiguous buffers, we allocate the buffers from that slot
@@ -543,6 +562,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		size_t mapping_size, size_t alloc_size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
+	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
 	unsigned int index, i;
 	phys_addr_t tlb_addr;
 
@@ -558,7 +578,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
-	index = find_slots(dev, alloc_size);
+	index = find_slots(dev, orig_addr, alloc_size + offset);
 	if (index == -1) {
 		if (!(attrs & DMA_ATTR_NO_WARN))
 			dev_warn_ratelimited(dev,
@@ -572,10 +592,10 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	for (i = 0; i < nr_slots(alloc_size); i++)
+	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		io_tlb_orig_addr[index + i] = slot_addr(orig_addr, i);
 
-	tlb_addr = slot_addr(io_tlb_start, index);
+	tlb_addr = slot_addr(io_tlb_start, index) + offset;
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
@@ -590,8 +610,9 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = nr_slots(alloc_size);
-	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	unsigned int offset = swiotlb_align_offset(hwdev, tlb_addr);
+	int i, count, nslots = nr_slots(alloc_size + offset);
+	int index = (tlb_addr - offset - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
 	/*
-- 
2.31.1.498.g6c1eba8ee3d-goog

