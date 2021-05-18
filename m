Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F41387F91
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346985AbhERS0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 14:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C06361209;
        Tue, 18 May 2021 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362322;
        bh=TGkCEnlT57JsHCtzGY8o/IpLCkjHc8mkPMi/DcGMFq8=;
        h=Date:From:To:Subject:From;
        b=KBVsFSl6MKEF4D/g+BQ5hWq4NDRrGeLyJfsYP02XWCq+EE8qqA33rYi0gpuD4TnhX
         Hhq6xpK9yDVvKvuan2MBp+BUrB91w6RXARzX+uwLa5z6sa8j7PFWK4Cq9saQhes4wr
         sl5pB1GGE3sjC5E7S+ISoORCoDObTnUgtiyz33e4=
Date:   Tue, 18 May 2021 11:25:22 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, ilias.apalodimas@linaro.org,
        mcroce@linux.microsoft.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-fix-struct-page-layout-on-32-bit-systems.patch removed from -mm tree
Message-ID: <20210518182522.PAqZ3m6XC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix struct page layout on 32-bit systems
has been removed from the -mm tree.  Its filename was
     mm-fix-struct-page-layout-on-32-bit-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix struct page layout on 32-bit systems

32-bit architectures which expect 8-byte alignment for 8-byte integers and
need 64-bit DMA addresses (arm, mips, ppc) had their struct page
inadvertently expanded in 2019.  When the dma_addr_t was added, it forced
the alignment of the union to 8 bytes, which inserted a 4 byte gap between
'flags' and the union.

Fix this by storing the dma_addr_t in one or two adjacent unsigned longs.
This restores the alignment to that of an unsigned long.  We always
store the low bits in the first word to prevent the PageTail bit from
being inadvertently set on a big endian platform.  If that happened,
get_user_pages_fast() racing against a page which was freed and
reallocated to the page_pool could dereference a bogus compound_head(),
which would be hard to trace back to this cause.

Link: https://lkml.kernel.org/r/20210510153211.1504886-1-willy@infradead.org
Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 include/net/page_pool.h  |   12 +++++++++++-
 net/core/page_pool.c     |   12 +++++++-----
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-fix-struct-page-layout-on-32-bit-systems
+++ a/include/linux/mm_types.h
@@ -97,10 +97,10 @@ struct page {
 		};
 		struct {	/* page_pool used by netstack */
 			/**
-			 * @dma_addr: might require a 64-bit value even on
+			 * @dma_addr: might require a 64-bit value on
 			 * 32-bit architectures.
 			 */
-			dma_addr_t dma_addr;
+			unsigned long dma_addr[2];
 		};
 		struct {	/* slab, slob and slub */
 			union {
--- a/include/net/page_pool.h~mm-fix-struct-page-layout-on-32-bit-systems
+++ a/include/net/page_pool.h
@@ -198,7 +198,17 @@ static inline void page_pool_recycle_dir
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	return page->dma_addr;
+	dma_addr_t ret = page->dma_addr[0];
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
+	return ret;
+}
+
+static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+{
+	page->dma_addr[0] = addr;
+	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+		page->dma_addr[1] = upper_32_bits(addr);
 }
 
 static inline bool is_page_pool_compiled_in(void)
--- a/net/core/page_pool.c~mm-fix-struct-page-layout-on-32-bit-systems
+++ a/net/core/page_pool.c
@@ -174,8 +174,10 @@ static void page_pool_dma_sync_for_devic
 					  struct page *page,
 					  unsigned int dma_sync_size)
 {
+	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
+
 	dma_sync_size = min(dma_sync_size, pool->p.max_len);
-	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
+	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
 					 pool->p.offset, dma_sync_size,
 					 pool->p.dma_dir);
 }
@@ -195,7 +197,7 @@ static bool page_pool_dma_map(struct pag
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
-	page->dma_addr = dma;
+	page_pool_set_dma_addr(page, dma);
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
@@ -331,13 +333,13 @@ void page_pool_release_page(struct page_
 		 */
 		goto skip_dma_unmap;
 
-	dma = page->dma_addr;
+	dma = page_pool_get_dma_addr(page);
 
-	/* When page is unmapped, it cannot be returned our pool */
+	/* When page is unmapped, it cannot be returned to our pool */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
-	page->dma_addr = 0;
+	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch

