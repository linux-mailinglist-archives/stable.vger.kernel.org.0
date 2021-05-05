Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED50373A68
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhEEMKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhEEMJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A164961176;
        Wed,  5 May 2021 12:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216524;
        bh=6zNtDsAgB5bMSkA8ViPnx8VnboOtKU7dasZ2/fYghwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcYuEXIof04bskZQQG04j6PvOkctlXXtxXmYKgrVFxSnriaqU+WeZEkvBDZEa5R4n
         Rr3hKXxVBJaLRC7Jmo0t0auUzwpwyQ01B+m1AWV59AV4VJ7fr2H7BuKbIDuTSSGAYC
         zkAk5e/Dbu+4zlQQJ0YPkUdPkSuAVuMAm897+YwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.11 14/31] swiotlb: add a IO_TLB_SIZE define
Date:   Wed,  5 May 2021 14:06:03 +0200
Message-Id: <20210505112327.128659745@linuxfoundation.org>
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

commit: b5d7ccb7aac3895c2138fe0980a109116ce15eff

Add a new IO_TLB_SIZE define instead open coding it using
IO_TLB_SHIFT all over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/swiotlb.h |    1 +
 kernel/dma/swiotlb.c    |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,6 +29,7 @@ enum swiotlb_force {
  * controllable.
  */
 #define IO_TLB_SHIFT 11
+#define IO_TLB_SIZE (1 << IO_TLB_SHIFT)
 
 /* default to 64MB */
 #define IO_TLB_DEFAULT_SIZE (64UL<<20)
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -491,20 +491,20 @@ phys_addr_t swiotlb_tbl_map_single(struc
 
 	tbl_dma_addr &= mask;
 
-	offset_slots = ALIGN(tbl_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	offset_slots = ALIGN(tbl_dma_addr, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 
 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    ? ALIGN(mask + 1, IO_TLB_SIZE) >> IO_TLB_SHIFT
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -598,7 +598,7 @@ void swiotlb_tbl_unmap_single(struct dev
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
@@ -649,7 +649,7 @@ void swiotlb_tbl_sync_single(struct devi
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
+	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
@@ -707,7 +707,7 @@ dma_addr_t swiotlb_map(struct device *de
 
 size_t swiotlb_max_mapping_size(struct device *dev)
 {
-	return ((size_t)1 << IO_TLB_SHIFT) * IO_TLB_SEGSIZE;
+	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE;
 }
 
 bool is_swiotlb_active(void)


