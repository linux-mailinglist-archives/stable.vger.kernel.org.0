Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AE244C7EE
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhKJS5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233882AbhKJSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCCF8619E2;
        Wed, 10 Nov 2021 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570120;
        bh=/jMNOIqB4o/yce2G50LTcVhimeS/QFIYZdj3LckjS7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WeYRPJGOf7N55fTUtgfl6PyDi/m0hF9N9uTPJvi2lPZMgcc/eDZ87e18wT9zUQ2G+
         rL/JchHLufi/pQpOvnxhzsO0MUbfNJs1/O6UzPvTnm549m36Vs9+l+jVsJC6HD7Mqu
         eqIN63rtGYxHZVwDgmVkdf+EyU3EnI7ATC7lO9ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 05/21] mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
Date:   Wed, 10 Nov 2021 19:43:51 +0100
Message-Id: <20211110182003.138254569@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/page-flags.h |   23 +++++++++++++++++++++++
 mm/huge_memory.c           |    2 ++
 mm/memory-failure.c        |   14 ++++++++++++++
 mm/memory.c                |    9 +++++++++
 mm/page_alloc.c            |    4 +++-
 5 files changed, 51 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -169,6 +169,15 @@ enum pageflags {
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
 
@@ -701,6 +710,20 @@ PAGEFLAG_FALSE(DoubleMap)
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
  * For pages that are never mapped to userspace (and aren't PageSlab),
  * page_type may be used.  Because it is initialised to -1, we invert the
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2464,6 +2464,8 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	ClearPageHasHWPoisoned(head);
+
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1367,6 +1367,20 @@ int memory_failure(unsigned long pfn, in
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
 			return -EBUSY;
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3921,6 +3921,15 @@ vm_fault_t finish_fault(struct vm_fault
 		page = vmf->page;
 
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
 	 * check even for read faults because we might have lost our CoWed
 	 * page
 	 */
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1232,8 +1232,10 @@ static __always_inline bool free_pages_p
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageDoubleMap(page);
+			ClearPageHasHWPoisoned(page);
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);


