Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536483547FC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhDEVDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbhDEVDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160A8C061793
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:03:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id jp20so368235pjb.2
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ukibw0pzDXFOw0CkkcldEv36NCXzg19soxuRUFuwOOg=;
        b=XQxuN2Jo1HK1KRVsWLqHCSpFIXKzCsv9Zp4g2y74XD/nsINPP62fby0eqRnCrZM0Eh
         6qfl4lOlusq7SiuIxOlzLmBBvXBRFIWpbrTRP6Nyici7bb1FpCEls8jpPn6spo1d/qtN
         52YNrUSvi0Sogaudo+u0klHfh4GcW9cE44Xy922fdVLWWJrrY6rpxWa4xCwocqS2dW8l
         2Lgb4Yb45xO2tnQEvA5Dsl8SRQmMu6MP2CgaBPNgu2ZRNeBOck7nYXxZUWRIVJcBvJfy
         dmSuv49M9NZ/IFaSVgHQYlXlspILXnmK4ZRRXuXFUtefStwphjiyEG/GGoYG+UpDcWr9
         2kRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ukibw0pzDXFOw0CkkcldEv36NCXzg19soxuRUFuwOOg=;
        b=RKtBGHA4O8cTyEOvCNVKgFyRArWZeTbXtLJF1KikfPJl36jVnhals/WIacznA8eHpd
         +11qvlQ8X2ZHBVBz29CXMvWBIpy0eDp0aNZ1ebgsxfXeRa1Qbf6PNPa8TL/qfC/mmZaA
         X/g56rpaMCTGhmjaICPfxUaYfThD8VKcKQsXng90fWzOafD6C4ZZvpUJ/w+k/arGtskK
         Z8i37hzEC8CuMUbnFWyFXuXunqDLakMe8a5UeMouPfLUtP19QIdb7OT9B0dsG6fiEn0E
         0azTMJjkpRyBvUQbw4cvo6DzH47ftwSsWkMp1j+zmZjap5zL169HqRaQ2o4uovBucqlo
         uvrw==
X-Gm-Message-State: AOAM5304q0OJXkXCidMNEirxpjAk4mJAWEmjP6i0W0bwao3CvgbiV3Fo
        6CQf10Y6k9jFhkoqWXf/+0YH1DrpE4r03DlToIogRSCtUlWxZpN+4GMzVbtXb0PUS8mpTW5ei2Y
        u+TE2nqGe3fhYpXZpPvGpYODvmkhbqT7b9Tn1deZLsftL9qQ+a2Wr+4BzEHU=
X-Google-Smtp-Source: ABdhPJzPKEZufxeBLFkTxjZ0sxUT1UCCnRZAXjhEAXA4NJ+16lUPeREUyhEQAERYItKXUm+jB1duzp5+Rg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:d351:b029:e8:ba10:e6f5 with SMTP id
 l17-20020a170902d351b02900e8ba10e6f5mr16726012plk.82.1617656586439; Mon, 05
 Apr 2021 14:03:06 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:27 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-6-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 5/8] swiotlb: refactor swiotlb_tbl_map_single
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
 kernel/dma/swiotlb.c | 177 +++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 91 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 47d5dfeffd0a..a3c0ccc53b8d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -452,134 +452,129 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 	}
 }
 
-phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t orig_addr,
-		size_t mapping_size, size_t alloc_size,
-		enum dma_data_direction dir, unsigned long attrs)
+#define slot_addr(start, idx)  ((start) + ((idx) << IO_TLB_SHIFT))
+/*
+ * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
+ */
+static inline unsigned long get_max_slots(unsigned long boundary_mask)
 {
-	dma_addr_t tbl_dma_addr = phys_to_dma_unencrypted(hwdev, io_tlb_start);
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
-
-	tbl_dma_addr &= mask;
+	if (boundary_mask == ~0UL)
+		return 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
+	return nr_slots(boundary_mask + 1);
+}
 
-	offset_slots = nr_slots(tbl_dma_addr);
+static unsigned int wrap_index(unsigned int index)
+{
+	if (index >= io_tlb_nslabs)
+		return 0;
+	return index;
+}
 
-	/*
-	 * Carefully handle integer overflow which can occur when mask == ~0UL.
-	 */
-	max_slots = mask + 1
-		    ? nr_slots(mask + 1)
-		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
+/*
+ * Find a suitable number of IO TLB entries size that will fit this request and
+ * allocate a buffer from that IO TLB pool.
+ */
+static int find_slots(struct device *dev, size_t alloc_size)
+{
+	unsigned long boundary_mask = dma_get_seg_boundary(dev);
+	dma_addr_t tbl_dma_addr =
+		phys_to_dma_unencrypted(dev, io_tlb_start) & boundary_mask;
+	unsigned long max_slots = get_max_slots(boundary_mask);
+	unsigned int nslots = nr_slots(alloc_size), stride = 1;
+	unsigned int index, wrap, count = 0, i;
+	unsigned long flags;
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
+		stride <<= (PAGE_SHIFT - IO_TLB_SHIFT);
 
-	BUG_ON(!nslots);
-
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
 
+phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
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
+			mapping_size, alloc_size);
+		return (phys_addr_t)DMA_MAPPING_ERROR;
+	}
+
+	index = find_slots(dev, alloc_size);
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

