Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5D3547D3
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhDEUwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDEUwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:16 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12EEC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:52:07 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id dz17so9128194qvb.14
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qGCFG/gO/B7b5MwvfM8xERm20q/aYd0P02DYslBm23Y=;
        b=dX8HXyuAX5fEo7AoHlKup6rRKkV3dnPTnRjNyuqc8mT9LfMPwOFvqbs52uXNkRpvTM
         qGN1qaSVA5cEDHUk6S1s2GXfSTEDtdVuvGlDXkwQLbWOp9bDBoKGYPS1ETiHFlqMIF3m
         8byx7fXLOnEsupmv46s3Ml6vL7b7Iwn6fqVouJ7eBppJngx+B4sOJSc+lqx/UmNokJTK
         felrnQa9K86MQ2ljru7EGOyFv83ObJPxZQ1G1RRNuGJiXICuRkG2IDJZOw+nSfSF8MK/
         qec5quMVvuTr8VprQ2UktbXXXQIVDSG4df+5YlKTJ8wN/VTDFnZlXtZ3o95Te0NTKOCf
         fyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qGCFG/gO/B7b5MwvfM8xERm20q/aYd0P02DYslBm23Y=;
        b=YTg8pabfAPOqbN4uG6zLvRh/Sa3Dxbx0YI3EsTh516y+HyQB4gonnE+cqyiHKGys4b
         BYxgzygPFZiTkPtVtnzDbTpl/NMI1PIBtzCaF2RYW9H63uDvP9GTnMn0+Jo10oAn5MXo
         ov+KMavHRiFVxsIorewfqpiPb2yzY4ZZ73Wcaa96IdRR8cBWZVaSA9cQNMzoNuDCtYW5
         1auI4uh9ltqW6yPHaJGduOmVXkYTx0WWPsBRaJHzgiU3ZmAborWsjCna08T0H2929RuI
         oWM1Kvz36Fc9FfwxoOIl6vyBnw+sKCvc4nySmonk+qIPd4pdvW9ONTq+p1z86VqiufM2
         LRgw==
X-Gm-Message-State: AOAM533K41lUGA4jBN8kTjaOL5QpTMmlhDapbCbAiuAWdLeo7/WolFga
        uI2QAG+cNOSUX70Y9uBWieu01w51SEU8nI7xVMAE5EnWlgTmzUQ8wrm0rCD78wyRVgnUyeaq2GD
        mK4BMlpWelW0ggliDl875zpmUGacPinX/DcFD7lUItY4ZT9GHQ8l9FhAGuIc=
X-Google-Smtp-Source: ABdhPJy1FJm8wntl3mY/8bqe+pKttR3pF7gkZRclO8jzYz0d9V3cXsgH4HF38uQOPx17405/P2je926YDw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:ad4:5a14:: with SMTP id ei20mr25051256qvb.1.1617655926916;
 Mon, 05 Apr 2021 13:52:06 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:08 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-8-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 7/8] swiotlb: respect min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

    
From: Christoph Hellwig <hch@lst.de>
 
'commit 1f221a0d0dbf ("swiotlb: respect min_align_mask")'

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
 kernel/dma/swiotlb.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index faf51614f02e..e3719c623cc4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -450,6 +450,15 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 }
 
 #define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
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
@@ -471,24 +480,28 @@ static unsigned int wrap_index(unsigned int index)
  * Find a suitable number of IO TLB entries size that will fit this request and
  * allocate a buffer from that IO TLB pool.
  */
-static int find_slots(struct device *dev,
-	       	dma_addr_t tbl_dma_addr, size_t alloc_size)
+static int find_slots(struct device *dev, dma_addr_t tbl_dma_addr,
+		phys_addr_t orig_addr, size_t alloc_size)
 {
 	unsigned long boundary_mask = dma_get_seg_boundary(dev);
 	tbl_dma_addr = tbl_dma_addr & boundary_mask;
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
@@ -496,6 +509,12 @@ static int find_slots(struct device *dev,
 
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
@@ -540,6 +559,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev,
 		size_t mapping_size, size_t alloc_size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
+	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
 	unsigned int index, i;
 	phys_addr_t tlb_addr;
 
@@ -555,7 +575,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev,
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
-	index = find_slots(dev, tbl_dma_addr, alloc_size);
+	index = find_slots(dev, tbl_dma_addr, orig_addr, alloc_size + offset);
 	if (index == -1) {
 		if (!(attrs & DMA_ATTR_NO_WARN))
 			dev_warn_ratelimited(dev,
@@ -568,10 +588,10 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev,
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
@@ -586,8 +606,9 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
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
2.27.0

