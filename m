Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63E93882AB
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352718AbhERWU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:57 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7969C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f19-20020a056a002393b02902d8b0956281so6321026pfc.19
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U+Cylb2srYEXBpVSWZyMZ6EsfSeCcdDvcZ7KxfK651A=;
        b=PTEfATxQf46imZF/WN8c6fb3AWEtVEPHFIK5ue16CEOX8nGSLwACljchxya/XcZ5Yy
         r47bsMHfV716tfD7AhtJOiSLp8LJqVpYDkZD0uazQAO4FiI73uiCTAex30VkUgwoguJo
         CerHpDIOWr/zGG0m1uvNDjCwp5I0jI2UGJziVArAOk01B77A+EgwKq2UuZ8ezaeZyz82
         AmMV1279OZ4X861DHwvFB3gNqtvupyZ5M3TbcUCadp6xJHJUKsNOgYiLIpnaMvOrTZh6
         VRY2w/UGqFJOs7iNNfnAYuLqUmrbJy6hUFLo7OKhc3GBf3qmbJJ905Xb2OGX5icxMz8S
         NlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U+Cylb2srYEXBpVSWZyMZ6EsfSeCcdDvcZ7KxfK651A=;
        b=aGs+MHYiX8hMvRtQTRTgm8ru+YLhCw5bs/EqIDhKV6azKHhPxxqxp8fHHmWOTEGTWO
         m2scnrAdKFFVYl85bX1Js7uvk5+G6AfzW5WGniY7a6s+Iy5E/7ClH/ICnyk/D5Bm0Xkv
         qEB/Ka1thahp3VBAz1y8TrKQ6yc9XHW4W0HKsUssK0tYXSecML1m0pc2aBGansmDOuqp
         P6mEwUZAvcZFRFVk1xO6s5hiJPwwEsO/cO9QJTmxNGEh/PQuHJbvcQYGUnaLgUdmqjI8
         U+TEcLg7Zhr84Iir9qQXm1G8bhyHtpeoD2fDxi/8to3Zb4k0E21XfiCtXyOwkVa1nXUQ
         +jGA==
X-Gm-Message-State: AOAM532YJNwb2X5/5usMDFJ0yxBt+/lavcSolrTRKRyQmxfnycrLyihO
        +eyhs502JDDsAULO/L+cWnDK1oahXmf08374qjIdumb+bYVHu4H3r9pOHQLO2TVkU0s7M7tcU4V
        ygwa1JC4gii3EpeDC1nE5mEyv+lwUcBAwJl26DPE2T976dQtuAGgnQO9CM/k=
X-Google-Smtp-Source: ABdhPJzSwG4+tgn75Knqk9D11skUTbIXDn5xNrxPc5LbGJ7kotwuWS9uadtFHC6nXYSp3omNBcHJXNR9kw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:4898:: with SMTP id
 b24mr7504196pjh.110.1621376378360; Tue, 18 May 2021 15:19:38 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:16 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-7-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 6/9] swiotlb: refactor swiotlb_tbl_map_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Split out a bunch of a self-contained helpers to make the function easier
to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: 26a7e094783d482f3e125f09945a5bb1d867b2e6
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 184 +++++++++++++++++++++----------------------
 1 file changed, 91 insertions(+), 93 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index af22c3c5e488..d71f05a33aa4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -453,133 +453,132 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 	}
 }
 
-phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
-				   dma_addr_t tbl_dma_addr,
-				   phys_addr_t orig_addr,
-				   size_t mapping_size,
-				   size_t alloc_size,
-				   enum dma_data_direction dir,
-				   unsigned long attrs)
+#define slot_addr(start, idx)  ((start) + ((idx) << IO_TLB_SHIFT))
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
+static int find_slots(struct device *dev, size_t alloc_size)
+{
+	unsigned long boundary_mask = dma_get_seg_boundary(dev);
+	dma_addr_t tbl_dma_addr =
+		__phys_to_dma(dev, io_tlb_start) & boundary_mask;
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
+	       stride <<= (PAGE_SHIFT - IO_TLB_SHIFT);
 
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
+					   nr_slots(tbl_dma_addr),
+					   max_slots)) {
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
-	io_tlb_used += nslots;
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
+
+	io_tlb_used += nslots;
+
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	return index;
+}
+
+phys_addr_t swiotlb_tbl_map_single(struct device *dev, dma_addr_t dma_addr,
+				   phys_addr_t orig_addr, size_t mapping_size,
+				   size_t alloc_size,
+				   enum dma_data_direction dir,
+				   unsigned long attrs)
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
-- 
2.31.1.751.gd2f1c929bd-goog

