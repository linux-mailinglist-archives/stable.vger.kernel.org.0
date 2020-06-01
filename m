Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441F31EAE0E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgFASEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgFASEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:04:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B07F206E2;
        Mon,  1 Jun 2020 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034691;
        bh=HfDsW7E7FnbB8ARdUvhq0rfqvewORS1KytEwONRTS0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=067COvTN8iDmDJ0VssX8yX1O1cmihJ0swps9A5Oec+lcDqMlyf8DFt4x82JHB8MAf
         MrkATZqyjqQ1v1jFqAEHxYs/wVTuG3hI7jK4l62jGeDxLyGtsW6IHtQbwT8ndQA95H
         azyd07XUMyPa3qrF3Zw2JMDnUALZE4eC/d6aBJvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 65/95] mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()
Date:   Mon,  1 Jun 2020 19:54:05 +0200
Message-Id: <20200601174031.285173461@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit 6988f31d558aa8c744464a7f6d91d34ada48ad12 ]

Replace superfluous VM_BUG_ON() with comment about correct usage.

Technically reverts commit 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to
page_mapcount()"), but context lines have changed.

Function isolate_migratepages_block() runs some checks out of lru_lock
when choose pages for migration.  After checking PageLRU() it checks
extra page references by comparing page_count() and page_mapcount().
Between these two checks page could be removed from lru, freed and taken
by slab.

As a result this race triggers VM_BUG_ON(PageSlab()) in page_mapcount().
Race window is tiny.  For certain workload this happens around once a
year.

    page:ffffea0105ca9380 count:1 mapcount:0 mapping:ffff88ff7712c180 index:0x0 compound_mapcount: 0
    flags: 0x500000000008100(slab|head)
    raw: 0500000000008100 dead000000000100 dead000000000200 ffff88ff7712c180
    raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
    page dumped because: VM_BUG_ON_PAGE(PageSlab(page))
    ------------[ cut here ]------------
    kernel BUG at ./include/linux/mm.h:628!
    invalid opcode: 0000 [#1] SMP NOPTI
    CPU: 77 PID: 504 Comm: kcompactd1 Tainted: G        W         4.19.109-27 #1
    Hardware name: Yandex T175-N41-Y3N/MY81-EX0-Y3N, BIOS R05 06/20/2019
    RIP: 0010:isolate_migratepages_block+0x986/0x9b0

The code in isolate_migratepages_block() was added in commit
119d6d59dcc0 ("mm, compaction: avoid isolating pinned pages") before
adding VM_BUG_ON into page_mapcount().

This race has been predicted in 2015 by Vlastimil Babka (see link
below).

[akpm@linux-foundation.org: comment tweaks, per Hugh]
Fixes: 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to page_mapcount()")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
Link: https://lore.kernel.org/lkml/557710E1.6060103@suse.cz/
Link: https://lore.kernel.org/linux-mm/158937872515.474360.5066096871639561424.stgit@buzz/T/ (v1)
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 45f10f5896b7..b1092046ebef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -602,6 +602,11 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 
 extern void kvfree(const void *addr);
 
+/*
+ * Mapcount of compound page as a whole, does not include mapped sub-pages.
+ *
+ * Must be called only for compound pages or any their tail sub-pages.
+ */
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
@@ -621,10 +626,16 @@ static inline void page_mapcount_reset(struct page *page)
 
 int __page_mapcount(struct page *page);
 
+/*
+ * Mapcount of 0-order page; when compound sub-page, includes
+ * compound_mapcount().
+ *
+ * Result is undefined for pages which cannot be mapped into userspace.
+ * For example SLAB or special types of pages. See function page_has_type().
+ * They use this place in struct page differently.
+ */
 static inline int page_mapcount(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-
 	if (unlikely(PageCompound(page)))
 		return __page_mapcount(page);
 	return atomic_read(&page->_mapcount) + 1;
-- 
2.25.1



