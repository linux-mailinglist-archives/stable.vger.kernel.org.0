Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D71B3C4B0C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhGLGz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241359AbhGLGy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F59608FE;
        Mon, 12 Jul 2021 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072730;
        bh=6iy8O0B+SMbd8vfWmHYMquyJzN3tVl3wtZ6sgaYTYc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Crz4se6EvqSnN8BsS0IPKPJ7UjTzM8cqVwxM/tKpnSrl3yiqAkcP+gKTQBavxP7wX
         fTlCR92DqZg6YglTfBBuscjMWbRvumVW/BNk9/FjcRtFzhtVxaiLIHVLRuLFlgxFmA
         ZAbz3EHAnJG3+Xa8TC8ohyLvJXXeWD9lapAw029U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Jann Horn <jannh@google.com>,
        Youquan Song <youquan.song@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 569/593] hugetlb: address ref count racing in prep_compound_gigantic_page
Date:   Mon, 12 Jul 2021 08:12:09 +0200
Message-Id: <20210712060957.472489781@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 7118fc2906e2925d7edb5ed9c8a57f2a5f23b849 ]

In [1], Jann Horn points out a possible race between
prep_compound_gigantic_page and __page_cache_add_speculative.  The root
cause of the possible race is prep_compound_gigantic_page uncondittionally
setting the ref count of pages to zero.  It does this because
prep_compound_gigantic_page is handed a 'group' of pages from an allocator
and needs to convert that group of pages to a compound page.  The ref
count of each page in this 'group' is one as set by the allocator.
However, the ref count of compound page tail pages must be zero.

The potential race comes about when ref counted pages are returned from
the allocator.  When this happens, other mm code could also take a
reference on the page.  __page_cache_add_speculative is one such example.
Therefore, prep_compound_gigantic_page can not just set the ref count of
pages to zero as it does today.  Doing so would lose the reference taken
by any other code.  This would lead to BUGs in code checking ref counts
and could possibly even lead to memory corruption.

There are two possible ways to address this issue.

1) Make all allocators of gigantic groups of pages be able to return a
   properly constructed compound page.

2) Make prep_compound_gigantic_page be more careful when constructing a
   compound page.

This patch takes approach 2.

In prep_compound_gigantic_page, use cmpxchg to only set ref count to zero
if it is one.  If the cmpxchg fails, call synchronize_rcu() in the hope
that the extra ref count will be driopped during a rcu grace period.  This
is not a performance critical code path and the wait should be
accceptable.  If the ref count is still inflated after the grace period,
then undo any modifications made and return an error.

Currently prep_compound_gigantic_page is type void and does not return
errors.  Modify the two callers to check for and handle error returns.  On
error, the caller must free the 'group' of pages as they can not be used
to form a gigantic page.  After freeing pages, the runtime caller
(alloc_fresh_huge_page) will retry the allocation once.  Boot time
allocations can not be retried.

The routine prep_compound_page also unconditionally sets the ref count of
compound page tail pages to zero.  However, in this case the buddy
allocator is constructing a compound page from freshly allocated pages.
The ref count on those freshly allocated pages is already zero, so the
set_page_count(p, 0) is unnecessary and could lead to confusion.  Just
remove it.

[1] https://lore.kernel.org/linux-mm/CAG48ez23q0Jy9cuVnwAe7t_fdhMk2S7N5Hdi-GLcCeq5bsfLxw@mail.gmail.com/

Link: https://lkml.kernel.org/r/20210622021423.154662-3-mike.kravetz@oracle.com
Fixes: 58a84aa92723 ("thp: set compound tail page _count to zero")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c    | 72 +++++++++++++++++++++++++++++++++++++++++++------
 mm/page_alloc.c |  1 -
 2 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fa6b0ac6c280..2c29f9b426a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1552,9 +1552,9 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	spin_unlock(&hugetlb_lock);
 }
 
-static void prep_compound_gigantic_page(struct page *page, unsigned int order)
+static bool prep_compound_gigantic_page(struct page *page, unsigned int order)
 {
-	int i;
+	int i, j;
 	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
@@ -1576,11 +1576,48 @@ static void prep_compound_gigantic_page(struct page *page, unsigned int order)
 		 * after get_user_pages().
 		 */
 		__ClearPageReserved(p);
+		/*
+		 * Subtle and very unlikely
+		 *
+		 * Gigantic 'page allocators' such as memblock or cma will
+		 * return a set of pages with each page ref counted.  We need
+		 * to turn this set of pages into a compound page with tail
+		 * page ref counts set to zero.  Code such as speculative page
+		 * cache adding could take a ref on a 'to be' tail page.
+		 * We need to respect any increased ref count, and only set
+		 * the ref count to zero if count is currently 1.  If count
+		 * is not 1, we call synchronize_rcu in the hope that a rcu
+		 * grace period will cause ref count to drop and then retry.
+		 * If count is still inflated on retry we return an error and
+		 * must discard the pages.
+		 */
+		if (!page_ref_freeze(p, 1)) {
+			pr_info("HugeTLB unexpected inflated ref count on freshly allocated page\n");
+			synchronize_rcu();
+			if (!page_ref_freeze(p, 1))
+				goto out_error;
+		}
 		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
 	atomic_set(compound_pincount_ptr(page), 0);
+	return true;
+
+out_error:
+	/* undo tail page modifications made above */
+	p = page + 1;
+	for (j = 1; j < i; j++, p = mem_map_next(p, page, j)) {
+		clear_compound_head(p);
+		set_page_refcounted(p);
+	}
+	/* need to clear PG_reserved on remaining tail pages  */
+	for (; j < nr_pages; j++, p = mem_map_next(p, page, j))
+		__ClearPageReserved(p);
+	set_compound_order(page, 0);
+	page[1].compound_nr = 0;
+	__ClearPageHead(page);
+	return false;
 }
 
 /*
@@ -1700,7 +1737,9 @@ static struct page *alloc_fresh_huge_page(struct hstate *h,
 		nodemask_t *node_alloc_noretry)
 {
 	struct page *page;
+	bool retry = false;
 
+retry:
 	if (hstate_is_gigantic(h))
 		page = alloc_gigantic_page(h, gfp_mask, nid, nmask);
 	else
@@ -1709,8 +1748,21 @@ static struct page *alloc_fresh_huge_page(struct hstate *h,
 	if (!page)
 		return NULL;
 
-	if (hstate_is_gigantic(h))
-		prep_compound_gigantic_page(page, huge_page_order(h));
+	if (hstate_is_gigantic(h)) {
+		if (!prep_compound_gigantic_page(page, huge_page_order(h))) {
+			/*
+			 * Rare failure to convert pages to compound page.
+			 * Free pages and try again - ONCE!
+			 */
+			free_gigantic_page(page, huge_page_order(h));
+			if (!retry) {
+				retry = true;
+				goto retry;
+			}
+			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
+			return NULL;
+		}
+	}
 	prep_new_huge_page(h, page, page_to_nid(page));
 
 	return page;
@@ -2490,10 +2542,14 @@ static void __init gather_bootmem_prealloc(void)
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(page_count(page) != 1);
-		prep_compound_gigantic_page(page, huge_page_order(h));
-		WARN_ON(PageReserved(page));
-		prep_new_huge_page(h, page, page_to_nid(page));
-		put_page(page); /* free it into the hugepage allocator */
+		if (prep_compound_gigantic_page(page, huge_page_order(h))) {
+			WARN_ON(PageReserved(page));
+			prep_new_huge_page(h, page, page_to_nid(page));
+			put_page(page); /* add to the hugepage allocator */
+		} else {
+			free_gigantic_page(page, huge_page_order(h));
+			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
+		}
 
 		/*
 		 * We need to restore the 'stolen' pages to totalram_pages
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e30d88efd7fb..3fd7f82d6f7f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -701,7 +701,6 @@ void prep_compound_page(struct page *page, unsigned int order)
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-		set_page_count(p, 0);
 		p->mapping = TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
-- 
2.30.2



