Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94D750DDB0
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiDYKQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiDYKQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E684625C
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 03:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E595560C7D
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC54C385A4;
        Mon, 25 Apr 2022 10:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650881599;
        bh=E8rVmIZUBtahNxMWdOjrv0r3lw4k6Btv+kkmZa36zkk=;
        h=Subject:To:Cc:From:Date:From;
        b=JrwB4w7AXh79+kAyH3qslzizjiaAzsSemS5KNsPAo4NiLPWdOjv8hXdxxEEPs6c4f
         0oQJdyxKE6lU9d17XOFPwMdiBIZBX5q5+vcKJDni0TZnSk4Wq+CAHZPOilZotNfJAc
         VS4lEZ0rqMK67r9ewvpOlQ+OMj293UJTwHR2i1EI=
Subject: FAILED: patch "[PATCH] mm/hwpoison: fix race between hugetlb free/demotion and" failed to apply to 5.17-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        dan.carpenter@oracle.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, shy828301@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 12:13:03 +0200
Message-ID: <165088158320536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 405ce051236cc65b30bbfe490b28ce60ae6aed85 Mon Sep 17 00:00:00 2001
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date: Thu, 21 Apr 2022 16:35:33 -0700
Subject: [PATCH] mm/hwpoison: fix race between hugetlb free/demotion and
 memory_failure_hugetlb()

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
taking refcount, but it's found that it makes code overly complicated,
so move the prechecks in a single hugetlb_lock range.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 53c1b6082a4c..ac2a1d758a80 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -169,6 +169,7 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
+int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -378,6 +379,11 @@ static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
 	return 0;
 }
 
+static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags)
+{
+	return 0;
+}
+
 static inline void putback_active_hugepage(struct page *page)
 {
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e34edb775334..9f44254af8ce 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3197,6 +3197,14 @@ extern int sysctl_memory_failure_recovery;
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f8ca7cca3c1a..3fc721789743 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6785,6 +6785,16 @@ int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
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
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index dcb6bb9cf731..2020944398c9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1498,50 +1498,113 @@ static int try_to_split_thp_page(struct page *page, const char *msg)
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
@@ -1554,14 +1617,6 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 
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
@@ -1712,6 +1773,7 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	int hugetlb = 0;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1739,10 +1801,9 @@ int memory_failure(unsigned long pfn, int flags)
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

