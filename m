Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58873882AE
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352721AbhERWVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:21:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4126AC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ep2-20020a17090ae642b029015f2a97b10fso1380178pjb.6
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VdA5J5YV6brJDzrQC2mlhZfibBecErfzJdRDJYY/yP8=;
        b=sS75MRltc/5JsDF+Y0yMOO5Z9U//x0J1/jPqJtTK/gGRJwKd0DyIyeu0/GP9OOs9jS
         kiR0ehkeItDjJXLXYILLQnFd6boXKiOvbQAZ73gRaB9tKnN2W3hmDsFC+giWwDmZ7IY1
         U0mQlaP8NMruTo5KlYLp36GREG+XlauCw+oglLECAZvbjpWyvriOmRdX4QI5wDj5TJMN
         w2uMdS0A1jgv32Ijw/FekPa0uFTBaw+LWj4FOOwYiHHI3Uq1HizzljjObun5ggmnXStx
         iKLwdV/dKsBxGIrLEYn5jrTqAgRn93pqIjV8q9RujxezdrlA7cbCHrlys9wH0eYInyfG
         OA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VdA5J5YV6brJDzrQC2mlhZfibBecErfzJdRDJYY/yP8=;
        b=Ikjk6Q6Xe5N2g4w0x2kLRkfiUbGx2SK0UFpLIkVQvm++1VYbgUMQMw0HpVMuCAl6je
         n/rttfGENe6K56dnGhS+It6FHtCJyGDtoi1QFUSu6mfEyx+Pq9u35WRsdYPXOFgkGhTr
         RLq3cEbLuEJTmr101O2MNpPSIunXq2V2S1O1rgcjuaBWTNBNWnolZCm5X10OUGWabojT
         cM/vsj8P7018aKzZLUZbbzfmEUMOYtNPk3e3zEvJIw/PfrJlRmLIQ/fsqiV+yXEYgKHr
         CfhkEDfEo3pza+bXcsj2dcqj+OdBpdTuyfbRcoBYsr556AUkYYePka3K2c4FOoFbx/Q2
         LDSQ==
X-Gm-Message-State: AOAM530l+f0URhCD7Ts5Y8IRofXLmtAxIYYx9oWxMvKuHMRBR+BW+Wgj
        Sy7HxTHsBaO4GnhX8zW0/uCfgzbM4BltUj1pMap+k/YZEtBBcbQqQ6UKYmmUn3PMWsC67d9pNqf
        asfhMgZS+rDARL/rAc2sqGO6euFcBwIW7HQMttA88N/W+oRn9EFjWNXIjQWg=
X-Google-Smtp-Source: ABdhPJzHNI4HFvSuns71m0zsbLyFVJZPCWqPxb7K+oK6+Yx6l1s7jKCo9CMsm9i/i3+eU6URVZbDrW55qQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:b285:b029:ef:9419:b91c with SMTP id
 u5-20020a170902b285b02900ef9419b91cmr7018595plr.21.1621376381710; Tue, 18 May
 2021 15:19:41 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:18 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-9-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 8/9] swiotlb: respect min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Upstream: 1f221a0d0dbf0e48ef3a9c62871281d6a7819f05
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f4e18ae33507..743bf7e36385 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -454,6 +454,15 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 }
 
 #define slot_addr(start, idx)  ((start) + ((idx) << IO_TLB_SHIFT))
+
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
@@ -475,24 +484,29 @@ static unsigned int wrap_index(unsigned int index)
  * Find a suitable number of IO TLB entries size that will fit this request and
  * allocate a buffer from that IO TLB pool.
  */
-static int find_slots(struct device *dev, size_t alloc_size)
+static int find_slots(struct device *dev, phys_addr_t orig_addr,
+		      size_t alloc_size)
 {
         unsigned long boundary_mask = dma_get_seg_boundary(dev);
         dma_addr_t tbl_dma_addr =
                 __phys_to_dma(dev, io_tlb_start) & boundary_mask;
         unsigned long max_slots = get_max_slots(boundary_mask);
-        unsigned int nslots = nr_slots(alloc_size), stride = 1;
+	unsigned int iotlb_align_mask =
+	    dma_get_min_align_mask(dev) & ~(IO_TLB_SIZE - 1);
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
-               stride <<= (PAGE_SHIFT - IO_TLB_SHIFT);
+		stride = max(stride, stride << (PAGE_SHIFT - IO_TLB_SHIFT));
 
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	if (unlikely(nslots > io_tlb_nslabs - io_tlb_used))
@@ -500,6 +514,12 @@ static int find_slots(struct device *dev, size_t alloc_size)
 
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
@@ -545,6 +565,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, dma_addr_t dma_addr,
                                    size_t alloc_size, enum dma_data_direction dir,
                                    unsigned long attrs)
  {
+	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
         unsigned int index, i;
         phys_addr_t tlb_addr;
 
@@ -560,7 +581,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, dma_addr_t dma_addr,
                 return (phys_addr_t)DMA_MAPPING_ERROR;
         }
 
-        index = find_slots(dev, alloc_size);
+	index = find_slots(dev, orig_addr, alloc_size + offset);
         if (index == -1) {
                 if (!(attrs & DMA_ATTR_NO_WARN))
                         dev_warn_ratelimited(dev,
@@ -574,10 +595,10 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, dma_addr_t dma_addr,
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-        for (i = 0; i < nr_slots(alloc_size); i++)
+	for (i = 0; i < nr_slots(alloc_size + offset); i++)
                 io_tlb_orig_addr[index + i] = slot_addr(orig_addr, i);
 
-        tlb_addr = slot_addr(io_tlb_start, index);
+	tlb_addr = slot_addr(io_tlb_start, index) + offset;
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
@@ -593,8 +614,9 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
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
2.31.1.751.gd2f1c929bd-goog

