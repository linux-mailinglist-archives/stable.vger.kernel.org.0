Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103B54408B8
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhJ3M2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 08:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231907AbhJ3M2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 08:28:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E7A61075;
        Sat, 30 Oct 2021 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635596754;
        bh=wE2rbxnQYFEAYgQ12l/VQiVhsAvdqJredQ1WKrxVQFA=;
        h=Subject:To:Cc:From:Date:From;
        b=DjoPMTkavkbR8r0T4B3fFxXq/TWtiP2O9DIXKxS73au6YnV1liOvIaU94OBsIGV+Y
         XjE0SUMwEBC37peHMttKi3FEbm9kO3d0sUS15n5RIZ5T8x2pF859koQuRnP1VyJTYJ
         np0OnPATkiLisOjNmNVp98afdk+4a/UpOQDeQS64=
Subject: FAILED: patch "[PATCH] mm: filemap: check if THP has hwpoisoned subpage for PMD page" failed to apply to 4.9-stable tree
To:     shy828301@gmail.com, akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:25:48 +0200
Message-ID: <1635596748176145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eac96c3efdb593df1a57bb5b95dbe037bfa9a522 Mon Sep 17 00:00:00 2001
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 28 Oct 2021 14:36:11 -0700
Subject: [PATCH] mm: filemap: check if THP has hwpoisoned subpage for PMD page
 fault

When handling shmem page fault the THP with corrupted subpage could be
PMD mapped if certain conditions are satisfied.  But kernel is supposed
to send SIGBUS when trying to map hwpoisoned page.

There are two paths which may do PMD map: fault around and regular
fault.

Before commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") the thing was even worse in fault around path.  The THP
could be PMD mapped as long as the VMA fits regardless what subpage is
accessed and corrupted.  After this commit as long as head page is not
corrupted the THP could be PMD mapped.

In the regular fault path the THP could be PMD mapped as long as the
corrupted page is not accessed and the VMA fits.

This loophole could be fixed by iterating every subpage to check if any
of them is hwpoisoned or not, but it is somewhat costly in page fault
path.

So introduce a new page flag called HasHWPoisoned on the first tail
page.  It indicates the THP has hwpoisoned subpage(s).  It is set if any
subpage of THP is found hwpoisoned by memory failure and after the
refcount is bumped successfully, then cleared when the THP is freed or
split.

The soft offline path doesn't need this since soft offline handler just
marks a subpage hwpoisoned when the subpage is migrated successfully.
But shmem THP didn't get split then migrated at all.

Link: https://lkml.kernel.org/r/20211020210755.23964-3-shy828301@gmail.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a558d67ee86f..fbfd3fad48f2 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -171,6 +171,15 @@ enum pageflags {
 	/* Compound pages. Stored in first tail page's flags */
 	PG_double_map = PG_workingset,
 
+#ifdef CONFIG_MEMORY_FAILURE
+	/*
+	 * Compound pages. Stored in first tail page's flags.
+	 * Indicates that at least one subpage is hwpoisoned in the
+	 * THP.
+	 */
+	PG_has_hwpoisoned = PG_mappedtodisk,
+#endif
+
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -668,6 +677,20 @@ PAGEFLAG_FALSE(DoubleMap)
 	TESTSCFLAG_FALSE(DoubleMap)
 #endif
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+/*
+ * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
+ * compound page.
+ *
+ * This flag is set by hwpoison handler.  Cleared by THP split or free page.
+ */
+PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+#else
+PAGEFLAG_FALSE(HasHWPoisoned)
+	TESTSCFLAG_FALSE(HasHWPoisoned)
+#endif
+
 /*
  * Check if a page is currently marked HWPoisoned. Note that this check is
  * best effort only and inherently racy: there is no way to synchronize with
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 92192cb086c7..c5142d237e48 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2426,6 +2426,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = lock_page_lruvec(head);
 
+	ClearPageHasHWPoisoned(head);
+
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond EOF: drop them from page cache */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 73f68699e7ab..bdbbb32211a5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1694,6 +1694,20 @@ int memory_failure(unsigned long pfn, int flags)
 	}
 
 	if (PageTransHuge(hpage)) {
+		/*
+		 * The flag must be set after the refcount is bumped
+		 * otherwise it may race with THP split.
+		 * And the flag can't be set in get_hwpoison_page() since
+		 * it is called by soft offline too and it is just called
+		 * for !MF_COUNT_INCREASE.  So here seems to be the best
+		 * place.
+		 *
+		 * Don't need care about the above error handling paths for
+		 * get_hwpoison_page() since they handle either free page
+		 * or unhandlable page.  The refcount is bumped iff the
+		 * page is a valid handlable page.
+		 */
+		SetPageHasHWPoisoned(hpage);
 		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			res = -EBUSY;
diff --git a/mm/memory.c b/mm/memory.c
index adf9b9ef8277..c52be6d6b605 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3906,6 +3906,15 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 	if (compound_order(page) != HPAGE_PMD_ORDER)
 		return ret;
 
+	/*
+	 * Just backoff if any subpage of a THP is corrupted otherwise
+	 * the corrupted page may mapped by PMD silently to escape the
+	 * check.  This kind of THP just can be PTE mapped.  Access to
+	 * the corrupted subpage should trigger SIGBUS as expected.
+	 */
+	if (unlikely(PageHasHWPoisoned(page)))
+		return ret;
+
 	/*
 	 * Archs like ppc64 need additional space to store information
 	 * related to pte entry. Use the preallocated table for that.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3ec39552d00f..23d3339ac4e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1312,8 +1312,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageDoubleMap(page);
+			ClearPageHasHWPoisoned(page);
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);

