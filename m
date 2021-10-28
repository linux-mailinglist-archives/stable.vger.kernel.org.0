Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017A643F1E0
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 23:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhJ1Vik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 17:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhJ1Vij (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736BE61056;
        Thu, 28 Oct 2021 21:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456971;
        bh=dJQQEMdt0xvUwN3UWZ9lg3BwGuIrm9dAROXC/APbYn8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HyCt3UQCrx1xij2iby1bOWqV6EajwQ7nXUiAxpHhd4g6fhMlIll7z5cetWzlxhMNw
         Y2Dy0K1HVQLXp672aH6HJYGrbFXS3uA/vdYzhVDMcNCs/UBj1LfJD5X1NEm5XuqQWB
         ALAoY5s4brvOlSinkfCA7nbFUX97Y/SWx9dO1my0=
Date:   Thu, 28 Oct 2021 14:36:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 03/11] mm: filemap: check if THP has hwpoisoned
 subpage for PMD page fault
Message-ID: <20211028213611.-fbyoks-F%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: filemap: check if THP has hwpoisoned subpage for PMD page fault

When handling shmem page fault the THP with corrupted subpage could be PMD
mapped if certain conditions are satisfied.  But kernel is supposed to
send SIGBUS when trying to map hwpoisoned page.

There are two paths which may do PMD map: fault around and regular fault.

Before commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") the thing was even worse in fault around path.  The THP could
be PMD mapped as long as the VMA fits regardless what subpage is accessed
and corrupted.  After this commit as long as head page is not corrupted
the THP could be PMD mapped.

In the regular fault path the THP could be PMD mapped as long as the
corrupted page is not accessed and the VMA fits.

This loophole could be fixed by iterating every subpage to check if any of
them is hwpoisoned or not, but it is somewhat costly in page fault path.

So introduce a new page flag called HasHWPoisoned on the first tail page. 
It indicates the THP has hwpoisoned subpage(s).  It is set if any subpage
of THP is found hwpoisoned by memory failure and after the refcount is
bumped successfully, then cleared when the THP is freed or split.

The soft offline path doesn't need this since soft offline handler just
marks a subpage hwpoisoned when the subpage is migrated successfully.  But
shmem THP didn't get split then migrated at all.

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
---

 include/linux/page-flags.h |   23 +++++++++++++++++++++++
 mm/huge_memory.c           |    2 ++
 mm/memory-failure.c        |   14 ++++++++++++++
 mm/memory.c                |    9 +++++++++
 mm/page_alloc.c            |    4 +++-
 5 files changed, 51 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault
+++ a/include/linux/page-flags.h
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
--- a/mm/huge_memory.c~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault
+++ a/mm/huge_memory.c
@@ -2426,6 +2426,8 @@ static void __split_huge_page(struct pag
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = lock_page_lruvec(head);
 
+	ClearPageHasHWPoisoned(head);
+
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond EOF: drop them from page cache */
--- a/mm/memory.c~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault
+++ a/mm/memory.c
@@ -3907,6 +3907,15 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		return ret;
 
 	/*
+	 * Just backoff if any subpage of a THP is corrupted otherwise
+	 * the corrupted page may mapped by PMD silently to escape the
+	 * check.  This kind of THP just can be PTE mapped.  Access to
+	 * the corrupted subpage should trigger SIGBUS as expected.
+	 */
+	if (unlikely(PageHasHWPoisoned(page)))
+		return ret;
+
+	/*
 	 * Archs like ppc64 need additional space to store information
 	 * related to pte entry. Use the preallocated table for that.
 	 */
--- a/mm/memory-failure.c~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault
+++ a/mm/memory-failure.c
@@ -1694,6 +1694,20 @@ try_again:
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
--- a/mm/page_alloc.c~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault
+++ a/mm/page_alloc.c
@@ -1312,8 +1312,10 @@ static __always_inline bool free_pages_p
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageDoubleMap(page);
+			ClearPageHasHWPoisoned(page);
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
_
