Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED31EA960
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgFASBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbgFASBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80C2A2065C;
        Mon,  1 Jun 2020 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034478;
        bh=vqPe5wXWGtJi+pj6tIvR74j3GVkV7y51TSDQ7QNwyqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCXnZoKqoa+DWWf9tYP1hFDDMuSxrQaUd43HC4QXsDEmiXdeyOPIP03PgPLCI9uO7
         g9iMWizc6uptFO/RrKig1jtIKe6gbk8Y1VOg31vqPZNX0Qa6glpHHW1xwTCz3B0T2/
         Kk+gNWz/maehAytoV+3uRZqLHYeU5PLTXmGFn3pY=
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
Subject: [PATCH 4.14 48/77] mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()
Date:   Mon,  1 Jun 2020 19:53:53 +0200
Message-Id: <20200601174024.954046040@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
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
index 858ce84ac7c5..6f852d5fbada 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -549,6 +549,11 @@ static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
 
 extern void kvfree(const void *addr);
 
+/*
+ * Mapcount of compound page as a whole, does not include mapped sub-pages.
+ *
+ * Must be called only for compound pages or any their tail sub-pages.
+ */
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
@@ -568,10 +573,16 @@ static inline void page_mapcount_reset(struct page *page)
 
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



