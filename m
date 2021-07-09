Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD623C24AF
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhGINYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhGINYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D104613C1;
        Fri,  9 Jul 2021 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836898;
        bh=dDKMi0zp8pkKY41FXuaw0VPsam86raLjIg5X5xwmNOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOTk0t4qd+1Wf3QKAVLvM7thZwu1UBqyJW025J///gCoNtjoOV5neviKPury0/pkB
         5O8BVbFKD/UxIcjkqz+rcQ+o4RlH6qYcg36ZO1P01EOCvMx8EwHp0EuAkWWgwOSBca
         VWPcMRvg6mVj6rcLY3lAMyNGB8UISP5imWKzEFF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neel Natu <neelnatu@google.com>,
        Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Zhang Yi <wetpzy@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/34] mm, futex: fix shared futex pgoff on shmem huge page
Date:   Fri,  9 Jul 2021 15:20:37 +0200
Message-Id: <20210709131655.942081262@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit fe19bd3dae3d15d2fbfdb3de8839a6ea0fe94264 ]

If more than one futex is placed on a shmem huge page, it can happen
that waking the second wakes the first instead, and leaves the second
waiting: the key's shared.pgoff is wrong.

When 3.11 commit 13d60f4b6ab5 ("futex: Take hugepages into account when
generating futex_key"), the only shared huge pages came from hugetlbfs,
and the code added to deal with its exceptional page->index was put into
hugetlb source.  Then that was missed when 4.8 added shmem huge pages.

page_to_pgoff() is what others use for this nowadays: except that, as
currently written, it gives the right answer on hugetlbfs head, but
nonsense on hugetlbfs tails.  Fix that by calling hugetlbfs-specific
hugetlb_basepage_index() on PageHuge tails as well as on head.

Yes, it's unconventional to declare hugetlb_basepage_index() there in
pagemap.h, rather than in hugetlb.h; but I do not expect anything but
page_to_pgoff() ever to need it.

[akpm@linux-foundation.org: give hugetlb_basepage_index() prototype the correct scope]

Link: https://lkml.kernel.org/r/b17d946b-d09-326e-b42a-52884c36df32@google.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Reported-by: Neel Natu <neelnatu@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zhang Yi <wetpzy@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: leave redundant #include <linux/hugetlb.h>
in kernel/futex.c, to avoid conflict over the header files included.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 16 ----------------
 include/linux/pagemap.h | 13 +++++++------
 kernel/futex.c          |  2 +-
 mm/hugetlb.c            |  5 +----
 4 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c129c1c14c5f..2df83a659818 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -477,17 +477,6 @@ static inline int hstate_index(struct hstate *h)
 	return h - hstates;
 }
 
-pgoff_t __basepage_index(struct page *page);
-
-/* Return page->index in PAGE_SIZE units */
-static inline pgoff_t basepage_index(struct page *page)
-{
-	if (!PageCompound(page))
-		return page->index;
-
-	return __basepage_index(page);
-}
-
 extern int dissolve_free_huge_page(struct page *page);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
@@ -582,11 +571,6 @@ static inline int hstate_index(struct hstate *h)
 	return 0;
 }
 
-static inline pgoff_t basepage_index(struct page *page)
-{
-	return page->index;
-}
-
 static inline int dissolve_free_huge_page(struct page *page)
 {
 	return 0;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index b1bd2186e6d2..33b63b2a163f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -403,7 +403,7 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
 }
 
 /*
- * Get index of the page with in radix-tree
+ * Get index of the page within radix-tree (but not for hugetlb pages).
  * (TODO: remove once hugetlb pages will have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_index(struct page *page)
@@ -422,15 +422,16 @@ static inline pgoff_t page_to_index(struct page *page)
 	return pgoff;
 }
 
+extern pgoff_t hugetlb_basepage_index(struct page *page);
+
 /*
- * Get the offset in PAGE_SIZE.
- * (TODO: hugepage should have ->index in PAGE_SIZE)
+ * Get the offset in PAGE_SIZE (even for hugetlb pages).
+ * (TODO: hugetlb pages should have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-
+	if (unlikely(PageHuge(page)))
+		return hugetlb_basepage_index(page);
 	return page_to_index(page);
 }
 
diff --git a/kernel/futex.c b/kernel/futex.c
index 526ebcff5a0a..3c67da9b8408 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -719,7 +719,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = basepage_index(tail);
+		key->shared.pgoff = page_to_pgoff(tail);
 		rcu_read_unlock();
 	}
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c69f12e4c149..ebcf26bc4cd4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1391,15 +1391,12 @@ int PageHeadHuge(struct page *page_head)
 	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 
-pgoff_t __basepage_index(struct page *page)
+pgoff_t hugetlb_basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
 	pgoff_t index = page_index(page_head);
 	unsigned long compound_idx;
 
-	if (!PageHuge(page_head))
-		return page_index(page);
-
 	if (compound_order(page_head) >= MAX_ORDER)
 		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
 	else
-- 
2.30.2



