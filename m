Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD31E5668
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 07:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgE1FUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 01:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgE1FUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 01:20:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11EC214D8;
        Thu, 28 May 2020 05:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590643248;
        bh=8tCTkuTf5baAgcrzO+4dGrd4I82G8UI7OYXJcM8GIWE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RolBtyCNalA5BEpnBE1qMs42A0JC7nvB/R7djh0EiLlS5AK6CWdzgx5aLYvt5HKis
         WT6mppgWjtJKOKtAzJ6NbukIgfkPh+pQnwy7dqSJV2yZBOEHq71nrY5LrM3YTjXRuJ
         mSXZ1nXMx0/T+hGrYSyU0ySzR1TOd+cflKw5Yjs0=
Date:   Wed, 27 May 2020 22:20:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 3/5] mm: remove VM_BUG_ON(PageSlab()) from
 page_mapcount()
Message-ID: <20200528052047.tDxIOLXzt%akpm@linux-foundation.org>
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Replace superfluous VM_BUG_ON() with comment about correct usage.

Technically reverts commit 1d148e218a0d0566b1c06f2f45f1436d53b049b2
("mm: add VM_BUG_ON_PAGE() to page_mapcount()"), but context have changed.

Function isolate_migratepages_block() runs some checks out of lru_lock
when choose pages for migration.  After checking PageLRU() it checks extra
page references by comparing page_count() and page_mapcount().  Between
these two checks page could be removed from lru, freed and taken by slab.

As a result this race triggers VM_BUG_ON(PageSlab()) in page_mapcount().
Race window is tiny. For certain workload this happens around once a year.

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

Code in isolate_migratepages_block() was added in commit 119d6d59dcc0
("mm, compaction: avoid isolating pinned pages") before adding VM_BUG_ON
into page_mapcount().

This race has been predicted in 2015 by Vlastimil Babka (see link below).

[akpm@linux-foundation.org: comment tweaks, per Hugh]
Link: http://lkml.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
Link: https://lore.kernel.org/lkml/557710E1.6060103@suse.cz/
Link: https://lore.kernel.org/linux-mm/158937872515.474360.5066096871639561424.stgit@buzz/T/ (v1)
Fixes: 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to page_mapcount()")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-remove-vm_bug_onpageslab-from-page_mapcount
+++ a/include/linux/mm.h
@@ -782,6 +782,11 @@ static inline void *kvcalloc(size_t n, s
 
 extern void kvfree(const void *addr);
 
+/*
+ * Mapcount of compound page as a whole, does not include mapped sub-pages.
+ *
+ * Must be called only for compound pages or any their tail sub-pages.
+ */
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
@@ -801,10 +806,16 @@ static inline void page_mapcount_reset(s
 
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
_
