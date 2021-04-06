Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F7355D19
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347191AbhDFUof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbhDFUoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCD7C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 125so18627026ybd.17
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1q2WLX2SJVm5gIMUK41Ls485gZbqDoZ6mKHMugtTze0=;
        b=JevCM2PIJmFNVhNwEKX8rxyNNpZ7T5Zqr35yIGOBUwbKkAMGs3I0iPeu8W2CTN5s7h
         Q4KIIrFz8fdVRDyjhvhVg1S1e7VVBcJY3C3CSwI/NOg+INiVg4uMOGrFUEb6EZfp8tJE
         k4oHM3bVFAKmZRUap7mhslml9yUy/qMgBrrIZ6lT0ZusDrzgG2lz9/c704FV4pUbC3+v
         3i8gD2u5c4yL7e09rn1W6Azpfz8O0sTu4+5t/8Zg/OdIlE1ykH2S4FWOzk5gQAdlmZZo
         ca8OmDRt5s366zOG/bPktlslagSxkbq6y1YovSqighEE1yhKuQYCy63gQhwEfujJsKf7
         u/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1q2WLX2SJVm5gIMUK41Ls485gZbqDoZ6mKHMugtTze0=;
        b=UBAICyd9g7nyC7YDIaKzvDmb6vPyzDrL14W3cgAIfHYEapKa6KWvLTPvUswxU14kQ0
         w4h7+QqQ30+BMBcHGeUAZIVkD/6jwvEpOrwAnaAma/OsGxJu0dAHf6vuUAahrrpOR7Rl
         q7ocMmI7TZ/s0riZ6/61gt3SGwOXBjkxCUwlHxFs3/X4d+t3VvfInC5nXNbe2X5qEihz
         XZTWweDvMybODwSJzRwMSz+Pbw7MBlX+EMKcl2TNn/KkhDP5j/pE8JEkde3zfDIjqJt8
         iLJUEH0R1B0WDmw9GjQ3GmA2Wj9QS19Hv6PDRfOWy4bZG947q0URCYP8f03EhIAbYIRZ
         wbBQ==
X-Gm-Message-State: AOAM533bF5J8E0F5vGPtS3YL/BwPolj/pIHajHJna5DFtHzTup9b3JE3
        cSqiURJRHtbGYwfYtCQM2BQOSLBeLL9YCfXf5YMc8mvqz3EKDxBC8WvOkynrroMgOGLNIojA4Yg
        xZKnF9xEXpiAAMZtuGVZUHTYYJGMspc31UlAzZDrLtai51OmkzO+zX8/Sbl8=
X-Google-Smtp-Source: ABdhPJwY77soFnp8fhRIwnNinPh0oXBRo4n3qbcTKgbSgHEOCxqE2VTteVVW+S5Zok4uBoBTgBm3nb93vg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a25:9245:: with SMTP id e5mr38653154ybo.434.1617741864670;
 Tue, 06 Apr 2021 13:44:24 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:26 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-8-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 7/8] swiotlb: respect min_align_mask
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
index 388c5e2a684e..deadf1f210e5 100644
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
-		dma_addr_t tbl_dma_addr, size_t alloc_size)
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

