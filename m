Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101E6383862
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbhEQPwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345117AbhEQPuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7248961D4D;
        Mon, 17 May 2021 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262747;
        bh=0XE+QnL3JHPR+TgN9Ik6jfg9PYkegZ2Y/++OLng3eos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASZNghtaYN/nZ4J3MxmjAUWAtxILEKYwLi21kBE1QNYc4C1TJwt2QdAf2LYXU++fI
         RIqC0Fg13/H0ov0rzDmQ7vx0KKmqsVwlH2h1RUciJwkflWExrUIpUfuEhdDFl/Mg6D
         U7DRyK2ywAbkAGnTfVJds9zxkpW+EVdkUoMXlYKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 265/289] mm: fix struct page layout on 32-bit systems
Date:   Mon, 17 May 2021 16:03:10 +0200
Message-Id: <20210517140314.070650269@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 9ddb3c14afba8bc5950ed297f02d4ae05ff35cd1 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_types.h |    4 ++--
 include/net/page_pool.h  |   12 +++++++++++-
 net/core/page_pool.c     |   12 +++++++-----
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
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
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -191,7 +191,17 @@ static inline void page_pool_recycle_dir
 
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
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -172,8 +172,10 @@ static void page_pool_dma_sync_for_devic
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
@@ -224,7 +226,7 @@ static struct page *__page_pool_alloc_pa
 		put_page(page);
 		return NULL;
 	}
-	page->dma_addr = dma;
+	page_pool_set_dma_addr(page, dma);
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
@@ -292,13 +294,13 @@ void page_pool_release_page(struct page_
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


