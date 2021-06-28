Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C233B616A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhF1Of4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234503AbhF1Ocr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE20C61C8D;
        Mon, 28 Jun 2021 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890466;
        bh=TEEUEh2VRLBTDSvGoGsAkUgTSmBhHK/L847s9BUMRGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jps4usfX4biq4MWgj9VNsa+q/lWEU87c5m2D80CeAIdbF5K0NQcPbFNkzlSHYh8ul
         CSDD2d4jmUgGnkI0s+takKcFSyOyTolUgfWyODWpoPEdmgn49SRLjY2Uh0bVwb/XzA
         +vhyMGLlcdzRQyipsVdwhPaTLe1dJeSrWcb5yzRT+7SBFiYJc4z2zl/cHEGk0sreiI
         4jJB1UNmqcazPfqijw4wdivRs++VksiBQYfdHonvcHk/qXpEQF+42kkutbZcZQJa8r
         ZQ3xgxeheDh2CKx8ssSog9sI3vNw6FaPKxU0JGEePBrWEAVgF4BVBRPS8+qnjvL9XX
         3BZbZYdletQEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>, Neel Natu <neelnatu@google.com>,
        Matthew Wilcox <willy@infradead.org>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 092/101] mm, futex: fix shared futex pgoff on shmem huge page
Date:   Mon, 28 Jun 2021 10:25:58 -0400
Message-Id: <20210628142607.32218-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit fe19bd3dae3d15d2fbfdb3de8839a6ea0fe94264 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h | 16 ----------------
 include/linux/pagemap.h | 13 +++++++------
 kernel/futex.c          |  3 +--
 mm/hugetlb.c            |  5 +----
 4 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b5807f23caf8..5b68c9787f7c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -628,17 +628,6 @@ static inline int hstate_index(struct hstate *h)
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
@@ -871,11 +860,6 @@ static inline int hstate_index(struct hstate *h)
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
index b032f094a782..fcb3f040102a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -501,7 +501,7 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
 }
 
 /*
- * Get index of the page with in radix-tree
+ * Get index of the page within radix-tree (but not for hugetlb pages).
  * (TODO: remove once hugetlb pages will have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_index(struct page *page)
@@ -520,15 +520,16 @@ static inline pgoff_t page_to_index(struct page *page)
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
index 3136aba17772..98a6e1b80bfe 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -35,7 +35,6 @@
 #include <linux/jhash.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
-#include <linux/hugetlb.h>
 #include <linux/freezer.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
@@ -652,7 +651,7 @@ static int get_futex_key(u32 __user *uaddr, bool fshared, union futex_key *key,
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = basepage_index(tail);
+		key->shared.pgoff = page_to_pgoff(tail);
 		rcu_read_unlock();
 	}
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc1006a32733..d4f89c2f9544 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1635,15 +1635,12 @@ struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
 	return NULL;
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

