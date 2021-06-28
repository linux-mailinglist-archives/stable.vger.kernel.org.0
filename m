Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258293B63A9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhF1O6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236991AbhF1O4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4382D61CBD;
        Mon, 28 Jun 2021 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891220;
        bh=oO6EIyldQjJsqP1lPh3DBLz16DFAm1yJLgofTCK44xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOhhTuQqQKjGOm/Uye3Vvm/56MAwe2ZXFoC2QEvDMS/55B6B88zzeXIKHqL6OM/ia
         TIX49U1U7NkZtLNigKj5eEC3os86MRvHosRxUoBGACMPSEGdeuffraOaEoapjDLoH0
         8rOh2SiBcHMjneY/EjsAiME0Js6BDPUqGh2WLx56pHTTA4tp+irJsfV7J6EYaHYBP6
         5JTRBnvdh2Nci4bYtxSCUABZL/bqQMvBkh8stawKeCV+z6joqVBT6gAlyuKHaukZYs
         ysQyDLJOAyoACxrOqdIHugQHyBNzVkwX6Lq9wy6MQt3KBsJEFkq9wljI+whYXHhPpN
         rtf1pS3lUldrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/71] mm: hwpoison: change PageHWPoison behavior on hugetlb pages
Date:   Mon, 28 Jun 2021 10:39:09 -0400
Message-Id: <20210628144003.34260-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

[ Upstream commit b37ff71cc626a0c1b5e098ff9a0b723815f6aaeb ]

We'd like to narrow down the error region in memory error on hugetlb
pages.  However, currently we set PageHWPoison flags on all subpages in
the error hugepage and add # of subpages to num_hwpoison_pages, which
doesn't fit our purpose.

So this patch changes the behavior and we only set PageHWPoison on the
head page then increase num_hwpoison_pages only by 1.  This is a
preparation for narrow-down part which comes in later patches.

Link: http://lkml.kernel.org/r/1496305019-5493-4-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swapops.h |  9 -----
 mm/memory-failure.c     | 87 ++++++++++++-----------------------------
 2 files changed, 24 insertions(+), 72 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 5c3a5f3e7eec..c5ff7b217ee6 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -196,15 +196,6 @@ static inline void num_poisoned_pages_dec(void)
 	atomic_long_dec(&num_poisoned_pages);
 }
 
-static inline void num_poisoned_pages_add(long num)
-{
-	atomic_long_add(num, &num_poisoned_pages);
-}
-
-static inline void num_poisoned_pages_sub(long num)
-{
-	atomic_long_sub(num, &num_poisoned_pages);
-}
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d6524dce43b2..ad156b42d2ad 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1010,22 +1010,6 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	return ret;
 }
 
-static void set_page_hwpoison_huge_page(struct page *hpage)
-{
-	int i;
-	int nr_pages = 1 << compound_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		SetPageHWPoison(hpage + i);
-}
-
-static void clear_page_hwpoison_huge_page(struct page *hpage)
-{
-	int i;
-	int nr_pages = 1 << compound_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		ClearPageHWPoison(hpage + i);
-}
-
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1051,7 +1035,6 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	struct page *hpage;
 	struct page *orig_head;
 	int res;
-	unsigned int nr_pages;
 	unsigned long page_flags;
 
 	if (!sysctl_memory_failure_recovery)
@@ -1065,24 +1048,23 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 
 	p = pfn_to_page(pfn);
 	orig_head = hpage = compound_head(p);
+
+	/* tmporary check code, to be updated in later patches */
+	if (PageHuge(p)) {
+		if (TestSetPageHWPoison(hpage)) {
+			pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
+			return 0;
+		}
+		goto tmp;
+	}
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
 		return 0;
 	}
 
-	/*
-	 * Currently errors on hugetlbfs pages are measured in hugepage units,
-	 * so nr_pages should be 1 << compound_order.  OTOH when errors are on
-	 * transparent hugepages, they are supposed to be split and error
-	 * measurement is done in normal page units.  So nr_pages should be one
-	 * in this case.
-	 */
-	if (PageHuge(p))
-		nr_pages = 1 << compound_order(hpage);
-	else /* normal page or thp */
-		nr_pages = 1;
-	num_poisoned_pages_add(nr_pages);
+tmp:
+	num_poisoned_pages_inc();
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1110,12 +1092,11 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 			if (PageHWPoison(hpage)) {
 				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
 				    || (p != hpage && TestSetPageHWPoison(hpage))) {
-					num_poisoned_pages_sub(nr_pages);
+					num_poisoned_pages_dec();
 					unlock_page(hpage);
 					return 0;
 				}
 			}
-			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
 			action_result(pfn, MF_MSG_FREE_HUGE,
 				      res ? MF_IGNORED : MF_DELAYED);
@@ -1138,7 +1119,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 				pr_err("Memory failure: %#lx: thp split failed\n",
 					pfn);
 			if (TestClearPageHWPoison(p))
-				num_poisoned_pages_sub(nr_pages);
+				num_poisoned_pages_dec();
 			put_hwpoison_page(p);
 			return -EBUSY;
 		}
@@ -1202,14 +1183,14 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 */
 	if (!PageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_sub(nr_pages);
+		num_poisoned_pages_dec();
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			num_poisoned_pages_sub(nr_pages);
+			num_poisoned_pages_dec();
 		unlock_page(hpage);
 		put_hwpoison_page(hpage);
 		return 0;
@@ -1228,14 +1209,6 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 		put_hwpoison_page(hpage);
 		return 0;
 	}
-	/*
-	 * Set PG_hwpoison on all pages in an error hugepage,
-	 * because containment is done in hugepage unit for now.
-	 * Since we have done TestSetPageHWPoison() for the head page with
-	 * page lock held, we can safely set PG_hwpoison bits on tail pages.
-	 */
-	if (PageHuge(p))
-		set_page_hwpoison_huge_page(hpage);
 
 	/*
 	 * It's very difficult to mess with pages currently under IO
@@ -1407,7 +1380,6 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
-	unsigned int nr_pages;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -1452,8 +1424,6 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(page);
-
 	if (!get_hwpoison_page(p)) {
 		/*
 		 * Since HWPoisoned hugepage should have non-zero refcount,
@@ -1483,10 +1453,8 @@ int unpoison_memory(unsigned long pfn)
 	if (TestClearPageHWPoison(page)) {
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 pfn, &unpoison_rs);
-		num_poisoned_pages_sub(nr_pages);
+		num_poisoned_pages_dec();
 		freeit = 1;
-		if (PageHuge(page))
-			clear_page_hwpoison_huge_page(page);
 	}
 	unlock_page(page);
 
@@ -1612,14 +1580,10 @@ static int soft_offline_huge_page(struct page *page, int flags)
 			ret = -EIO;
 	} else {
 		/* overcommit hugetlb page will be freed to buddy */
-		if (PageHuge(page)) {
-			set_page_hwpoison_huge_page(hpage);
+		SetPageHWPoison(page);
+		if (PageHuge(page))
 			dequeue_hwpoisoned_huge_page(hpage);
-			num_poisoned_pages_add(1 << compound_order(hpage));
-		} else {
-			SetPageHWPoison(page);
-			num_poisoned_pages_inc();
-		}
+		num_poisoned_pages_inc();
 	}
 	return ret;
 }
@@ -1728,15 +1692,12 @@ static int soft_offline_in_use_page(struct page *page, int flags)
 
 static void soft_offline_free_page(struct page *page)
 {
-	if (PageHuge(page)) {
-		struct page *hpage = compound_head(page);
+	struct page *head = compound_head(page);
 
-		set_page_hwpoison_huge_page(hpage);
-		if (!dequeue_hwpoisoned_huge_page(hpage))
-			num_poisoned_pages_add(1 << compound_order(hpage));
-	} else {
-		if (!TestSetPageHWPoison(page))
-			num_poisoned_pages_inc();
+	if (!TestSetPageHWPoison(head)) {
+		num_poisoned_pages_inc();
+		if (PageHuge(head))
+			dequeue_hwpoisoned_huge_page(head);
 	}
 }
 
-- 
2.30.2

