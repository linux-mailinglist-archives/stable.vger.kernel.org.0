Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3643750AC02
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 01:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442570AbiDUXi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 19:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiDUXi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 19:38:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417D81260A;
        Thu, 21 Apr 2022 16:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED888B829A7;
        Thu, 21 Apr 2022 23:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83927C385A5;
        Thu, 21 Apr 2022 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584134;
        bh=lhRBJD/80fHH3oIZnKfupQJnQk/e8LTnMOu6tI8M3WI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=TPAb8GDUS/2bal1hjKxcfgefgJM4U7YfrbHBhuwoJBRGdubKl2Py2g3kaCnPA9T37
         V0EV37sJ4FuTDeopW5WfJoZhz7ZU16lCaeoTlIUJbOAH2hXFsg0tJU/bVs/Q/VSKuX
         Cj8ejA0sKnAHZsDKdlCuJu0G8dZZFdN3Qz6qPHSo=
Date:   Thu, 21 Apr 2022 16:35:33 -0700
To:     stable@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        dan.carpenter@oracle.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 01/13] mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()
Message-Id: <20220421233534.83927C385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()

There is a race condition between memory_failure_hugetlb() and hugetlb
free/demotion, which causes setting PageHWPoison flag on the wrong page. 
The one simple result is that wrong processes can be killed, but another
(more serious) one is that the actual error is left unhandled, so no one
prevents later access to it, and that might lead to more serious results
like consuming corrupted data.

Think about the below race window:

  CPU 1                                   CPU 2
  memory_failure_hugetlb
  struct page *head = compound_head(p);
                                          hugetlb page might be freed to
                                          buddy, or even changed to another
                                          compound page.

  get_hwpoison_page -- page is not what we want now...

The current code first does prechecks roughly and then reconfirms after
taking refcount, but it's found that it makes code overly complicated, so
move the prechecks in a single hugetlb_lock range.

A newly introduced function, try_memory_failure_hugetlb(), always takes
hugetlb_lock (even for non-hugetlb pages).  That can be improved, but
memory_failure() is rare in principle, so should not be a big problem.

Link: https://lkml.kernel.org/r/20220408135323.1559401-2-naoya.horiguchi@linux.dev
Fixes: 761ad8d7c7b5 ("mm: hwpoison: introduce memory_failure_hugetlb()")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +
 include/linux/mm.h      |    8 ++
 mm/hugetlb.c            |   10 ++
 mm/memory-failure.c     |  145 ++++++++++++++++++++++++++------------
 4 files changed, 127 insertions(+), 42 deletions(-)

--- a/include/linux/hugetlb.h~mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb
+++ a/include/linux/hugetlb.h
@@ -169,6 +169,7 @@ long hugetlb_unreserve_pages(struct inod
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -377,6 +378,11 @@ static inline int get_hwpoison_huge_page
 {
 	return 0;
 }
+
+static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	return 0;
+}
 
 static inline void putback_active_hugepage(struct page *page)
 {
--- a/include/linux/mm.h~mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb
+++ a/include/linux/mm.h
@@ -3197,6 +3197,14 @@ extern int sysctl_memory_failure_recover
 extern void shake_page(struct page *p);
 extern atomic_long_t num_poisoned_pages __read_mostly;
 extern int soft_offline_page(unsigned long pfn, int flags);
+#ifdef CONFIG_MEMORY_FAILURE
+extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags);
+#else
+static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	return 0;
+}
+#endif
 
 #ifndef arch_memory_failure
 static inline int arch_memory_failure(unsigned long pfn, int flags)
--- a/mm/hugetlb.c~mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb
+++ a/mm/hugetlb.c
@@ -6785,6 +6785,16 @@ int get_hwpoison_huge_page(struct page *
 	return ret;
 }
 
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	int ret;
+
+	spin_lock_irq(&hugetlb_lock);
+	ret = __get_huge_page_for_hwpoison(pfn, flags);
+	spin_unlock_irq(&hugetlb_lock);
+	return ret;
+}
+
 void putback_active_hugepage(struct page *page)
 {
 	spin_lock_irq(&hugetlb_lock);
--- a/mm/memory-failure.c~mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb
+++ a/mm/memory-failure.c
@@ -1498,50 +1498,113 @@ static int try_to_split_thp_page(struct
 	return 0;
 }
 
-static int memory_failure_hugetlb(unsigned long pfn, int flags)
+/*
+ * Called from hugetlb code with hugetlb_lock held.
+ *
+ * Return values:
+ *   0             - free hugepage
+ *   1             - in-use hugepage
+ *   2             - not a hugepage
+ *   -EBUSY        - the hugepage is busy (try to retry)
+ *   -EHWPOISON    - the hugepage is already hwpoisoned
+ */
+int __get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct page *head = compound_head(page);
+	int ret = 2;	/* fallback to normal page handling */
+	bool count_increased = false;
+
+	if (!PageHeadHuge(head))
+		goto out;
+
+	if (flags & MF_COUNT_INCREASED) {
+		ret = 1;
+		count_increased = true;
+	} else if (HPageFreed(head) || HPageMigratable(head)) {
+		ret = get_page_unless_zero(head);
+		if (ret)
+			count_increased = true;
+	} else {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (TestSetPageHWPoison(head)) {
+		ret = -EHWPOISON;
+		goto out;
+	}
+
+	return ret;
+out:
+	if (count_increased)
+		put_page(head);
+	return ret;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+/*
+ * Taking refcount of hugetlb pages needs extra care about race conditions
+ * with basic operations like hugepage allocation/free/demotion.
+ * So some of prechecks for hwpoison (pinning, and testing/setting
+ * PageHWPoison) should be done in single hugetlb_lock range.
+ */
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
-	struct page *p = pfn_to_page(pfn);
-	struct page *head = compound_head(p);
 	int res;
+	struct page *p = pfn_to_page(pfn);
+	struct page *head;
 	unsigned long page_flags;
+	bool retry = true;
 
-	if (TestSetPageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: already hardware poisoned\n",
-		       pfn);
-		res = -EHWPOISON;
-		if (flags & MF_ACTION_REQUIRED)
+	*hugetlb = 1;
+retry:
+	res = get_huge_page_for_hwpoison(pfn, flags);
+	if (res == 2) { /* fallback to normal page handling */
+		*hugetlb = 0;
+		return 0;
+	} else if (res == -EHWPOISON) {
+		pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
+		if (flags & MF_ACTION_REQUIRED) {
+			head = compound_head(p);
 			res = kill_accessing_process(current, page_to_pfn(head), flags);
+		}
 		return res;
+	} else if (res == -EBUSY) {
+		if (retry) {
+			retry = false;
+			goto retry;
+		}
+		action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
+		return res;
+	}
+
+	head = compound_head(p);
+	lock_page(head);
+
+	if (hwpoison_filter(p)) {
+		ClearPageHWPoison(head);
+		res = -EOPNOTSUPP;
+		goto out;
 	}
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED)) {
-		res = get_hwpoison_page(p, flags);
-		if (!res) {
-			lock_page(head);
-			if (hwpoison_filter(p)) {
-				if (TestClearPageHWPoison(head))
-					num_poisoned_pages_dec();
-				unlock_page(head);
-				return -EOPNOTSUPP;
-			}
-			unlock_page(head);
-			res = MF_FAILED;
-			if (__page_handle_poison(p)) {
-				page_ref_inc(p);
-				res = MF_RECOVERED;
-			}
-			action_result(pfn, MF_MSG_FREE_HUGE, res);
-			return res == MF_RECOVERED ? 0 : -EBUSY;
-		} else if (res < 0) {
-			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
-			return -EBUSY;
+	/*
+	 * Handling free hugepage.  The possible race with hugepage allocation
+	 * or demotion can be prevented by PageHWPoison flag.
+	 */
+	if (res == 0) {
+		unlock_page(head);
+		res = MF_FAILED;
+		if (__page_handle_poison(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
 		}
+		action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
-	lock_page(head);
-
 	/*
 	 * The page could have changed compound pages due to race window.
 	 * If this happens just bail out.
@@ -1554,14 +1617,6 @@ static int memory_failure_hugetlb(unsign
 
 	page_flags = head->flags;
 
-	if (hwpoison_filter(p)) {
-		if (TestClearPageHWPoison(head))
-			num_poisoned_pages_dec();
-		put_page(p);
-		res = -EOPNOTSUPP;
-		goto out;
-	}
-
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
@@ -1588,6 +1643,12 @@ out:
 	unlock_page(head);
 	return res;
 }
+#else
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+{
+	return 0;
+}
+#endif
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
@@ -1712,6 +1773,7 @@ int memory_failure(unsigned long pfn, in
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	int hugetlb = 0;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1739,10 +1801,9 @@ int memory_failure(unsigned long pfn, in
 	}
 
 try_again:
-	if (PageHuge(p)) {
-		res = memory_failure_hugetlb(pfn, flags);
+	res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
+	if (hugetlb)
 		goto unlock_mutex;
-	}
 
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
_
