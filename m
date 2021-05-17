Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F02383593
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbhEQPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244089AbhEQPSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EBE61C73;
        Mon, 17 May 2021 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262020;
        bh=K9jm3lQXIJXrJPBmrlBsloqGvVATvMESbRmNo2MUQDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXiFwShUIuew2m3u5aq3exWzhRI5HRAxExdUOc9r9W5ROUn3eBAuerK52LYlc/WLu
         7EROOdkJw2zfzrYSGoODqqVrNnLvDMxki7ln8DJBPC01FmJY+AsyQnDLXdRJ6OQOB3
         IdVdAST7t/+WLJP8Lzy6HtQeVdydYurw1Lee425E=
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
Subject: [PATCH 5.4 125/141] mm: fix struct page layout on 32-bit systems
Date:   Mon, 17 May 2021 16:02:57 +0200
Message-Id: <20210517140247.027645278@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
 net/core/page_pool.c     |    6 +++---
 3 files changed, 16 insertions(+), 6 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -95,10 +95,10 @@ struct page {
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
@@ -185,7 +185,17 @@ static inline void page_pool_release_pag
 
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
@@ -157,7 +157,7 @@ static struct page *__page_pool_alloc_pa
 		put_page(page);
 		return NULL;
 	}
-	page->dma_addr = dma;
+	page_pool_set_dma_addr(page, dma);
 
 skip_dma_map:
 	/* Track how many pages are held 'in-flight' */
@@ -216,12 +216,12 @@ static void __page_pool_clean_page(struc
 	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
 		goto skip_dma_unmap;
 
-	dma = page->dma_addr;
+	dma = page_pool_get_dma_addr(page);
 	/* DMA unmap */
 	dma_unmap_page_attrs(pool->p.dev, dma,
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC);
-	page->dma_addr = 0;
+	page_pool_set_dma_addr(page, 0);
 skip_dma_unmap:
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.


