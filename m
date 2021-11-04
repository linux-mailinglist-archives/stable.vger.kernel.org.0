Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CBD445B80
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhKDVKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhKDVKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:10:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E242C061714;
        Thu,  4 Nov 2021 14:07:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t11so9319098plq.11;
        Thu, 04 Nov 2021 14:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxDXlFZv18SaVr7yVerydN4wv6+UR/Mko0Frp1wGsZI=;
        b=iMwewlmHpZlJFiy8dVLPT/9iXgNfMmxF00y8jqrPWIt0QjHkw7YoV0Qic1QC11Db4i
         QhS6LtFsd4CaiTteQrB7OIxgGoTBMgH3Y6aqAaE1A+SmuipRVaF/pTA4/p+CNGbKd+dd
         my/t5L4VYX7jpM/+bgjTcQ5rWu8dy76ougyqfVMqH55bF0p4RXLxqq9E8UnIEWxE1Bbt
         zpNb2NjDHX/hN/TD6GfWuGULscy6W2/VQmym/A3UlsVgVfJWQxKVOzxqVkcG4AfAyLUu
         qHdQmiJnjQZMEG0iMxU6QSqFgMvBmKHBmHsmRl0HcIsvEPgLhJFGrv1s1TOzxumFkBvG
         nrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxDXlFZv18SaVr7yVerydN4wv6+UR/Mko0Frp1wGsZI=;
        b=y0eaHOJR2w+a5SozcQzaQHnvj3FaYwJAo5tIjmYqtufoGgKCeMY5J02BA1DNweSD23
         RI0ybJZ+7FRqsNigVOoZ/FjkvBrw+MK5vvpAPoyPmATHxKqHgYgttF7PCCPUplCamr2M
         Wa+WxzaaCObG6Th/XD+/1bTjtGT7Fp2I8WCpl+4okiA3JFaIcRPV+icdzk9q5QUyXXEg
         5KLjIm4tvF/S9iU2qBaMSYEe5rJ3Py7dhJeFWUEltUUv9aEWrX7ibdZ/s9d56ZeGLVIj
         NJH6C29fg0i1DHMx+C6ZPBNjV3RBkXpvDW5m5Cdgza8Ymxc1ilGymR71IOb8VPkXpqJp
         cNCA==
X-Gm-Message-State: AOAM5325kVx6Xt1k2yy9WpP8J2IBBIyNnfiBu2jsh9+O/NCE7zALYeZT
        fI0CSiwxpawz22jDVdbRcHo=
X-Google-Smtp-Source: ABdhPJzCizhyL/NVth/pWVE9GnmOZclcspfIp5ZqA/5hPzCK9sW0rwa+eYW7fmCn1R78Bzmxg30ffg==
X-Received: by 2002:a17:90a:4212:: with SMTP id o18mr16378748pjg.154.1636060077070;
        Thu, 04 Nov 2021 14:07:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-239-127.hsd1.ca.comcast.net. [73.93.239.127])
        by smtp.gmail.com with ESMTPSA id s69sm4523688pgc.43.2021.11.04.14.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 14:07:56 -0700 (PDT)
From:   Yang Shi <shy828301@gmail.com>
To:     gregkh@linuxfoundation.org, naoya.horiguchi@nec.com,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        willy@infradead.org, osalvador@suse.de, peterx@redhat.com,
        akpm@linux-foundation.org
Cc:     shy828301@gmail.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [stable 5.10 v2 PATCH 2/2] mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
Date:   Thu,  4 Nov 2021 14:07:52 -0700
Message-Id: <20211104210752.390351-2-shy828301@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211104210752.390351-1-shy828301@gmail.com>
References: <20211104210752.390351-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Fixed build failure on stable tree.

 include/linux/page-flags.h | 23 +++++++++++++++++++++++
 mm/huge_memory.c           |  2 ++
 mm/memory-failure.c        | 14 ++++++++++++++
 mm/memory.c                |  9 +++++++++
 mm/page_alloc.c            |  4 +++-
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4f6ba9379112..1e33ba465195 100644
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
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 594368f6134f..8cf6b2dc5332 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2464,6 +2464,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	ClearPageHasHWPoisoned(head);
+
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bd2cd4dd59b6..d76743d9d760 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1367,6 +1367,20 @@ int memory_failure(unsigned long pfn, int flags)
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
diff --git a/mm/memory.c b/mm/memory.c
index 4fe24cd865a7..bc3063351620 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3920,6 +3920,15 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	else
 		page = vmf->page;
 
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
 	 * check even for read faults because we might have lost our CoWed
 	 * page
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8e0f1cec8b0..8fc88df45293 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1232,8 +1232,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageDoubleMap(page);
+			ClearPageHasHWPoisoned(page);
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-- 
2.26.2

