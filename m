Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DE8355D16
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhDFUoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245587AbhDFUoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21030C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:22 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m5so11417042pgu.21
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=84b9/Hy7tDyIiEgPRaS9kBQP0Ow9dcTO1RIaZqzs5eY=;
        b=sX3lb8sONvj/s8+XrWRO3JRLIllxsDQp2kBPRWnPYxRllc+S5lErYL31d6jQDHsG8H
         pRTqmvzMMBzB/IbYsFBjblMG2mUUEwFqwAmr3dWV9okQZbPz87m+2ICVbR6eUNM19ocR
         sN62n5IQiCdjIgYmiE1jQp1g+ELMAwAlwOjS3Yz4xVy0AW0mqoIF+gKyK0dsgeZpwx69
         LroZ/YDRQCs49tl+LkhVS3eTg3LHhH0Xr83v4lsBmvqZCo6tx1Lra84epUfiHElbALIw
         +m8IZHZN9bUS/w/wKbpYqVd31dsXcNOZ0B1G4IAQ/QQXES9sSuz8SK0Dos36nufPINrL
         jQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=84b9/Hy7tDyIiEgPRaS9kBQP0Ow9dcTO1RIaZqzs5eY=;
        b=srPr1tJ7PDAnqAgw3Vlw01JiqkVTjo7YMEUwBl8Fpns7HFHXuQ3cxCpcWgkdsHGTVo
         YpFAPtKzbKeDLjXfEMZeLWPU4FAaTWSN8bX3mZDntu6FkxID5XZag9pQxr/d4Z5lJXNs
         41DjYUShSlaHmJXjR5Y1RF+5o/3RuJEuKgdCMQimL0jxJ6yk8GWk28TnV7Y7CEnAYsSS
         tVvhELjXtfznLpsEyvkjQ+Hl9H030lTB3c6Ljah6CzDYDByosQPLO4fUvTHlqLzQOOH2
         YbwCZvqIE9JUGaOnoI34cWsFOAjo/ycUyJoskMGtMMVmoYaKE0Qar25XCDZxmeuNn4Jk
         O0KQ==
X-Gm-Message-State: AOAM530n7rIwmFnQRT2o8wb2whi7ZmVie7DDYnLCADi2DEFtgahr7WtX
        YgLqrZ1Q17s7n2k0uUNmyZ6AiC1aGUuN83nqGhQTKI6GkRNFqbObCmTSncRURBnqdEVYopEJxT1
        HAbmLm61faBqTtpsujKWH2ZltRHtrskurL0psgoP/D8P6JMOlQYUeGoeTGwY=
X-Google-Smtp-Source: ABdhPJxgsevPNWjq1sjtRVLYLm/cN0nAcr0U0sMZ7RhG6G5vTsarZUdhxau9z1hekfyKUk0dEWguM5Gjzw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:aa7:9478:0:b029:1fd:1fc1:bdfe with SMTP id
 t24-20020aa794780000b02901fd1fc1bdfemr29359587pfq.57.1617741861319; Tue, 06
 Apr 2021 13:44:21 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:24 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-6-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 5/8] swiotlb: refactor swiotlb_tbl_map_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit 26a7e094783d ("swiotlb: refactor swiotlb_tbl_map_single")'

Split out a bunch of a self-contained helpers to make the function easier
to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 181 +++++++++++++++++++++----------------------
 1 file changed, 88 insertions(+), 93 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 10c20010710c..46286c0d38e2 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -449,137 +449,132 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 	}
 }
 
-phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
-				   dma_addr_t tbl_dma_addr,
-				   phys_addr_t orig_addr,
-				   size_t mapping_size,
-				   size_t alloc_size,
-				   enum dma_data_direction dir,
-				   unsigned long attrs)
+#define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
+/*
+ * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
+ */
+static inline unsigned long get_max_slots(unsigned long boundary_mask)
 {
-	unsigned long flags;
-	phys_addr_t tlb_addr;
-	unsigned int nslots, stride, index, wrap;
-	int i;
-	unsigned long mask;
-	unsigned long offset_slots;
-	unsigned long max_slots;
-	unsigned long tmp_io_tlb_used;
-
-	if (no_iotlb_memory)
-		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
-
-	if (mem_encrypt_active())
-		pr_warn_once("Memory encryption is active and system is using DMA bounce buffers\n");
-
-	if (mapping_size > alloc_size) {
-		dev_warn_once(hwdev, "Invalid sizes (mapping: %zd bytes, alloc: %zd bytes)",
-			      mapping_size, alloc_size);
-		return (phys_addr_t)DMA_MAPPING_ERROR;
-	}
-
-	mask = dma_get_seg_boundary(hwdev);
+	if (boundary_mask == ~0UL)
+		return 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
+	return nr_slots(boundary_mask + 1);
+}
 
-	tbl_dma_addr &= mask;
+static unsigned int wrap_index(unsigned int index)
+{
+	if (index >= io_tlb_nslabs)
+		return 0;
+	return index;
+}
 
-	offset_slots = nr_slots(tbl_dma_addr);
+/*
+ * Find a suitable number of IO TLB entries size that will fit this request and
+ * allocate a buffer from that IO TLB pool.
+ */
+static int find_slots(struct device *dev,
+		dma_addr_t tbl_dma_addr, size_t alloc_size)
+{
+	unsigned long boundary_mask = dma_get_seg_boundary(dev);
+	tbl_dma_addr = tbl_dma_addr & boundary_mask;
+	unsigned long max_slots = get_max_slots(boundary_mask);
+	unsigned int nslots = nr_slots(alloc_size), stride = 1;
+	unsigned int index, wrap, count = 0, i;
+	unsigned long flags;
 
-	/*
-	 * Carefully handle integer overflow which can occur when mask == ~0UL.
-	 */
-	max_slots = mask + 1
-		    ? nr_slots(mask + 1)
-		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
+	BUG_ON(!nslots);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = nr_slots(alloc_size);
 	if (alloc_size >= PAGE_SIZE)
-		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
-	else
-		stride = 1;
-
-	BUG_ON(!nslots);
+		stride <<= (PAGE_SHIFT - IO_TLB_SHIFT);
 
-	/*
-	 * Find suitable number of IO TLB entries size that will fit this
-	 * request and allocate a buffer from that IO TLB pool.
-	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
-
 	if (unlikely(nslots > io_tlb_nslabs - io_tlb_used))
 		goto not_found;
 
-	index = ALIGN(io_tlb_index, stride);
-	if (index >= io_tlb_nslabs)
-		index = 0;
-	wrap = index;
-
+	index = wrap = wrap_index(ALIGN(io_tlb_index, stride));
 	do {
-		while (iommu_is_span_boundary(index, nslots, offset_slots,
-					      max_slots)) {
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
-			if (index == wrap)
-				goto not_found;
-		}
-
 		/*
 		 * If we find a slot that indicates we have 'nslots' number of
 		 * contiguous buffers, we allocate the buffers from that slot
 		 * and mark the entries as '0' indicating unavailable.
 		 */
-		if (io_tlb_list[index] >= nslots) {
-			int count = 0;
-
-			for (i = index; i < (int) (index + nslots); i++)
-				io_tlb_list[i] = 0;
-			for (i = index - 1;
-			     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
-			     io_tlb_list[i]; i--)
-				io_tlb_list[i] = ++count;
-			tlb_addr = io_tlb_start + (index << IO_TLB_SHIFT);
-
-			/*
-			 * Update the indices to avoid searching in the next
-			 * round.
-			 */
-			io_tlb_index = ((index + nslots) < io_tlb_nslabs
-					? (index + nslots) : 0);
-
-			goto found;
+		if (!iommu_is_span_boundary(index, nslots,
+					    nr_slots(tbl_dma_addr),
+					    max_slots)) {
+			if (io_tlb_list[index] >= nslots)
+				goto found;
 		}
-		index += stride;
-		if (index >= io_tlb_nslabs)
-			index = 0;
+		index = wrap_index(index + stride);
 	} while (index != wrap);
 
 not_found:
-	tmp_io_tlb_used = io_tlb_used;
-
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-	if (!(attrs & DMA_ATTR_NO_WARN) && printk_ratelimit())
-		dev_warn(hwdev, "swiotlb buffer is full (sz: %zd bytes), total %lu (slots), used %lu (slots)\n",
-			 alloc_size, io_tlb_nslabs, tmp_io_tlb_used);
-	return (phys_addr_t)DMA_MAPPING_ERROR;
+	return -1;
+
 found:
+	for (i = index; i < index + nslots; i++)
+		io_tlb_list[i] = 0;
+	for (i = index - 1;
+	     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
+	     io_tlb_list[i]; i--)
+		io_tlb_list[i] = ++count;
+
+	/*
+	 * Update the indices to avoid searching in the next round.
+	 */
+	if (index + nslots < io_tlb_nslabs)
+		io_tlb_index = index + nslots;
+	else
+		io_tlb_index = 0;
 	io_tlb_used += nslots;
+
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	return index;
+}
+
+phys_addr_t swiotlb_tbl_map_single(struct device *dev,
+		dma_addr_t tbl_dma_addr, phys_addr_t orig_addr,
+		size_t mapping_size, size_t alloc_size,
+		enum dma_data_direction dir, unsigned long attrs)
+{
+	unsigned int index, i;
+	phys_addr_t tlb_addr;
+
+	if (no_iotlb_memory)
+		panic("Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
+
+	if (mem_encrypt_active())
+		pr_warn_once("Memory encryption is active and system is using DMA bounce buffers\n");
+
+	if (mapping_size > alloc_size) {
+		dev_warn_once(dev, "Invalid sizes (mapping: %zd bytes, alloc: %zd bytes)",
+			      mapping_size, alloc_size);
+		return (phys_addr_t)DMA_MAPPING_ERROR;
+	}
 
+	index = find_slots(dev, tbl_dma_addr, alloc_size);
+	if (index == -1) {
+		if (!(attrs & DMA_ATTR_NO_WARN))
+			dev_warn_ratelimited(dev,
+	"swiotlb buffer is full (sz: %zd bytes), total %lu (slots), used %lu (slots)\n",
+				 alloc_size, io_tlb_nslabs, io_tlb_used);
+		return (phys_addr_t)DMA_MAPPING_ERROR;
+	}
 	/*
 	 * Save away the mapping from the original address to the DMA address.
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
+	for (i = 0; i < nr_slots(alloc_size); i++)
+		io_tlb_orig_addr[index + i] = slot_addr(orig_addr, i);
+
+	tlb_addr = slot_addr(io_tlb_start, index);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
 		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
-
 	return tlb_addr;
 }
 
-- 
2.27.0

