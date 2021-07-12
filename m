Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5C3C55CC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346151AbhGLIMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353925AbhGLIDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5E261179;
        Mon, 12 Jul 2021 07:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076726;
        bh=jm2Iup3lq8BVomhM/OOMz7wuqeobhhoLGZRqjpsdqVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaNQeO0ryzVkh5XbIkcbRypZLjLZSeIDcpALJR7Nm6Q8Bf45Fck0813Hs6imhiHyR
         S4ROsKR8V7bwyJxk9fYQKLCDTEjQSmIluL5Kh5YmXy9O3tiRMh1qTX3gXPoV87qqmJ
         LmpwGc9BCXGcOWC2tO1iQxh7Bc/BTRJ1B8WH4bPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Youquan Song <youquan.song@intel.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 767/800] hugetlb: remove prep_compound_huge_page cleanup
Date:   Mon, 12 Jul 2021 08:13:10 +0200
Message-Id: <20210712061048.402119642@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 48b8d744ea841b8adf8d07bfe7a2d55f22e4d179 ]

Patch series "Fix prep_compound_gigantic_page ref count adjustment".

These patches address the possible race between
prep_compound_gigantic_page and __page_cache_add_speculative as described
by Jann Horn in [1].

The first patch simply removes the unnecessary/obsolete helper routine
prep_compound_huge_page to make the actual fix a little simpler.

The second patch is the actual fix and has a detailed explanation in the
commit message.

This potential issue has existed for almost 10 years and I am unaware of
anyone actually hitting the race.  I did not cc stable, but would be happy
to squash the patches and send to stable if anyone thinks that is a good
idea.

[1] https://lore.kernel.org/linux-mm/CAG48ez23q0Jy9cuVnwAe7t_fdhMk2S7N5Hdi-GLcCeq5bsfLxw@mail.gmail.com/

This patch (of 2):

I could not think of a reliable way to recreate the issue for testing.
Rather, I 'simulated errors' to exercise all the error paths.

The routine prep_compound_huge_page is a simple wrapper to call either
prep_compound_gigantic_page or prep_compound_page.  However, it is only
called from gather_bootmem_prealloc which only processes gigantic pages.
Eliminate the routine and call prep_compound_gigantic_page directly.

Link: https://lkml.kernel.org/r/20210622021423.154662-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210622021423.154662-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5ba5a0da6d57..65e0e8642ded 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1318,8 +1318,6 @@ static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
 
-static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
-static void prep_compound_gigantic_page(struct page *page, unsigned int order);
 #else /* !CONFIG_CONTIG_ALLOC */
 static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
 					int nid, nodemask_t *nodemask)
@@ -2625,16 +2623,10 @@ found:
 	return 1;
 }
 
-static void __init prep_compound_huge_page(struct page *page,
-		unsigned int order)
-{
-	if (unlikely(order > (MAX_ORDER - 1)))
-		prep_compound_gigantic_page(page, order);
-	else
-		prep_compound_page(page, order);
-}
-
-/* Put bootmem huge pages into the standard lists after mem_map is up */
+/*
+ * Put bootmem huge pages into the standard lists after mem_map is up.
+ * Note: This only applies to gigantic (order > MAX_ORDER) pages.
+ */
 static void __init gather_bootmem_prealloc(void)
 {
 	struct huge_bootmem_page *m;
@@ -2643,20 +2635,19 @@ static void __init gather_bootmem_prealloc(void)
 		struct page *page = virt_to_page(m);
 		struct hstate *h = m->hstate;
 
+		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(page_count(page) != 1);
-		prep_compound_huge_page(page, huge_page_order(h));
+		prep_compound_gigantic_page(page, huge_page_order(h));
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		put_page(page); /* free it into the hugepage allocator */
 
 		/*
-		 * If we had gigantic hugepages allocated at boot time, we need
-		 * to restore the 'stolen' pages to totalram_pages in order to
-		 * fix confusing memory reports from free(1) and another
-		 * side-effects, like CommitLimit going negative.
+		 * We need to restore the 'stolen' pages to totalram_pages
+		 * in order to fix confusing memory reports from free(1) and
+		 * other side-effects, like CommitLimit going negative.
 		 */
-		if (hstate_is_gigantic(h))
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+		adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 }
-- 
2.30.2



