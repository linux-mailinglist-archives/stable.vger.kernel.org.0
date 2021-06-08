Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1393A0149
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhFHSux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235427AbhFHSsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:48:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D34C613AE;
        Tue,  8 Jun 2021 18:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177487;
        bh=vpe24IN7mdw0kyHzQBQ0OrAbcyGE970a+F6HCOQdGsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBvV8TKUdOCCj4JUL5vpVwdmT8Z4SNqOa7xctGneah2vIlV5c7N4K4vGbum3MqVtd
         JPbV8JuJGZZqRBKPQPWOtQjhBApvjGB8itdD3sPO670f/Ic60DQDPGyMLtbau/idZA
         HX3935If0ngrNhDIcBhC/fdAepO+pf4La1stgcr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Song Liu <songliubraving@fb.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 68/78] mm/filemap: fix storing to a THP shadow entry
Date:   Tue,  8 Jun 2021 20:27:37 +0200
Message-Id: <20210608175937.568255713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -856,7 +856,6 @@ noinline int __add_to_page_cache_locked(
 	int huge = PageHuge(page);
 	struct mem_cgroup *memcg;
 	int error;
-	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
@@ -872,21 +871,41 @@ noinline int __add_to_page_cache_locked(
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
@@ -894,7 +913,7 @@ noinline int __add_to_page_cache_locked(
 			__inc_node_page_state(page, NR_FILE_PAGES);
 unlock:
 		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp_mask & GFP_RECLAIM_MASK));
+	} while (xas_nomem(&xas, gfp_mask));
 
 	if (xas_error(&xas))
 		goto error;


