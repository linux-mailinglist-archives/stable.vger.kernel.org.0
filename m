Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BAF373A9C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhEEML4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhEEMKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A02613FE;
        Wed,  5 May 2021 12:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216566;
        bh=zkXCsQDib+WMRl0XznmjUtqgFEU6P1lwPjR+kBC5vyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QN/+k0MkrTwIRro6T0wR1nwrPxU/BBNNc51UU5Q1wxkVKQERAU5eW1cyb5+XCej+/
         8XSaFrKpe+/OKtOU8qEeHhdKC2e0EVHKofhfKYiv/3INN16PkM+pryDJbHSEjZrnBg
         Hvq/gxwtZQH8bQjXdyfSoBKH5MjK8NfA8JlmBq64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.11 20/31] swiotlb: respect min_align_mask
Date:   Wed,  5 May 2021 14:06:09 +0200
Message-Id: <20210505112327.328779098@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianxiong Gao <jxgao@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |   41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -471,6 +471,14 @@ static void swiotlb_bounce(phys_addr_t o
 #define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
 
 /*
+ * Return the offset into a iotlb slot required to keep the device happy.
+ */
+static unsigned int swiotlb_align_offset(struct device *dev, u64 addr)
+{
+	return addr & dma_get_min_align_mask(dev) & (IO_TLB_SIZE - 1);
+}
+
+/*
  * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
  */
 static inline unsigned long get_max_slots(unsigned long boundary_mask)
@@ -491,24 +499,29 @@ static unsigned int wrap_index(unsigned
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
@@ -516,6 +529,12 @@ static int find_slots(struct device *dev
 
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
@@ -559,6 +578,7 @@ phys_addr_t swiotlb_tbl_map_single(struc
 		size_t mapping_size, size_t alloc_size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
+	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
 	unsigned int index, i;
 	phys_addr_t tlb_addr;
 
@@ -574,7 +594,7 @@ phys_addr_t swiotlb_tbl_map_single(struc
 		return (phys_addr_t)DMA_MAPPING_ERROR;
 	}
 
-	index = find_slots(dev, alloc_size);
+	index = find_slots(dev, orig_addr, alloc_size + offset);
 	if (index == -1) {
 		if (!(attrs & DMA_ATTR_NO_WARN))
 			dev_warn_ratelimited(dev,
@@ -588,10 +608,10 @@ phys_addr_t swiotlb_tbl_map_single(struc
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
@@ -606,8 +626,9 @@ void swiotlb_tbl_unmap_single(struct dev
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


