Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD28039E81D
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFGUNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbhFGUNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:13:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F079C061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=E3qCx7yNSXPElqXf2jrMqchRIpAkhuiLb3Dnk5MxaSo=; b=A98C7XrAHjEv5vQK3E8ArK+RB8
        BPX50RuGt+zNJHC9ujfmkGhz+xwD3mtAy7FRLG2w2xeXNAazH9HcGEKhybkmzoa/G0upSFOe3AoVm
        yhIm6JmFdKKEdHdM9u6x604KbakxdQxAaEoUgS2yXW20V/mDBKcuqYzhNV2+hnuWGzAl0e3XKRJW6
        u5yVGydufW8uClvhgweXT0NvWxg+nuX1oW6kfS7jrxrUOQ6DMNfbMwJ9JuVB9Imda7f1Krq9cZUy2
        imJqA6XyyJvtS8ZQNINYlntBrdHoTLSPfhbnupEQvCTZEoUjzZiY8DWi1GCSdkU3SMeShGeCueTSP
        S+5BYuTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqLZb-00GCOy-4q; Mon, 07 Jun 2021 20:10:23 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Song Liu <songliubraving@fb.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] mm/filemap: fix storing to a THP shadow entry
Date:   Mon,  7 Jun 2021 21:08:45 +0100
Message-Id: <20210607200845.3860579-5-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607200845.3860579-1-willy@infradead.org>
References: <20210607200845.3860579-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 198b62f83eef1d605d70eca32759c92cdcc14175 upstream

When a THP is removed from the page cache by reclaim, we replace it with a
shadow entry that occupies all slots of the XArray previously occupied by
the THP.  If the user then accesses that page again, we only allocate a
single page, but storing it into the shadow entry replaces all entries
with that one page.  That leads to bugs like

page dumped because: VM_BUG_ON_PAGE(page_to_pgoff(page) != offset)
------------[ cut here ]------------
kernel BUG at mm/filemap.c:2529!

https://bugzilla.kernel.org/show_bug.cgi?id=206569

This is hard to reproduce with mainline, but happens regularly with the
THP patchset (as so many more THPs are created).  This solution is take
from the THP patchset.  It splits the shadow entry into order-0 pieces at
the time that we bring a new page into cache.

Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Link: https://lkml.kernel.org/r/20200903183029.14930-4-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/filemap.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index db542b494883..c10e237cc2c6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -856,7 +856,6 @@ noinline int __add_to_page_cache_locked(struct page *page,
 	int huge = PageHuge(page);
 	struct mem_cgroup *memcg;
 	int error;
-	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
@@ -872,21 +871,41 @@ noinline int __add_to_page_cache_locked(struct page *page,
 	get_page(page);
 	page->mapping = mapping;
 	page->index = offset;
+	gfp_mask &= GFP_RECLAIM_MASK;
 
 	do {
+		unsigned int order = xa_get_order(xas.xa, xas.xa_index);
+		void *entry, *old = NULL;
+
+		if (order > thp_order(page))
+			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
+					order, gfp_mask);
 		xas_lock_irq(&xas);
-		old = xas_load(&xas);
-		if (old && !xa_is_value(old))
-			xas_set_err(&xas, -EEXIST);
+		xas_for_each_conflict(&xas, entry) {
+			old = entry;
+			if (!xa_is_value(entry)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+		}
+
+		if (old) {
+			if (shadowp)
+				*shadowp = old;
+			/* entry may have been split before we acquired lock */
+			order = xa_get_order(xas.xa, xas.xa_index);
+			if (order > thp_order(page)) {
+				xas_split(&xas, old, order);
+				xas_reset(&xas);
+			}
+		}
+
 		xas_store(&xas, page);
 		if (xas_error(&xas))
 			goto unlock;
 
-		if (xa_is_value(old)) {
+		if (old)
 			mapping->nrexceptional--;
-			if (shadowp)
-				*shadowp = old;
-		}
 		mapping->nrpages++;
 
 		/* hugetlb pages do not participate in page cache accounting */
@@ -894,7 +913,7 @@ noinline int __add_to_page_cache_locked(struct page *page,
 			__inc_node_page_state(page, NR_FILE_PAGES);
 unlock:
 		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
+	} while (xas_nomem(&xas, gfp_mask));
 
 	if (xas_error(&xas))
 		goto error;
-- 
2.30.2

