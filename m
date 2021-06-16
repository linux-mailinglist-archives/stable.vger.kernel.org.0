Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549D13A8E40
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFPBZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhFPBZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9967161356;
        Wed, 16 Jun 2021 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806593;
        bh=rHRSsmAz4Uacfxb5kv+BqE8Wo9Zjx9aIfdgIONWU1Ik=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ok83/KO1DN1KISf3IdQFiu2ZhVujKe5PNr6nZZmz/1eJ+Ml/zMhMF2zSFyLaogOWA
         kVa++kAqst7Se+YUlvUIPii+wvJzaMaK+ZZFQdThILSL4pCnVZ7ZFMDUxcRLxtQMcj
         M5cIQLR2Qv8UprUpSn+d51+139s/oJ8YZBECXR1A=
Date:   Tue, 15 Jun 2021 18:23:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 01/18] mm,hwpoison: fix race with hugetlb page
 allocation
Message-ID: <20210616012313.cySUhIHf_%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: fix race with hugetlb page allocation

When hugetlb page fault (under overcommitting situation) and
memory_failure() race, VM_BUG_ON_PAGE() is triggered by the following
race:

    CPU0:                           CPU1:

                                    gather_surplus_pages()
                                      page = alloc_surplus_huge_page()
    memory_failure_hugetlb()
      get_hwpoison_page(page)
        __get_hwpoison_page(page)
          get_page_unless_zero(page)
                                      zero = put_page_testzero(page)
                                      VM_BUG_ON_PAGE(!zero, page)
                                      enqueue_huge_page(h, page)
      put_page(page)

__get_hwpoison_page() only checks the page refcount before taking an
additional one for memory error handling, which is not enough because
there's a time window where compound pages have non-zero refcount during
hugetlb page initialization.

So make __get_hwpoison_page() check page status a bit more for hugetlb
pages with get_hwpoison_huge_page().  Checking hugetlb-specific flags
under hugetlb_lock makes sure that the hugetlb page is not transitive. 
It's notable that another new function, HWPoisonHandlable(), is helpful to
prevent a race against other transitive page states (like a generic
compound page just before PageHuge becomes true).

Link: https://lkml.kernel.org/r/20210603233632.2964832-2-nao.horiguchi@gmail.com
Fixes: ead07f6a867b ("mm/memory-failure: introduce get_hwpoison_page() for consistent refcount handling")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   15 +++++++++++++++
 mm/memory-failure.c     |   29 +++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mmhwpoison-fix-race-with-hugetlb-page-allocation
+++ a/include/linux/hugetlb.h
@@ -149,6 +149,7 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -339,6 +340,11 @@ static inline bool isolate_huge_page(str
 	return false;
 }
 
+static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+{
+	return 0;
+}
+
 static inline void putback_active_hugepage(struct page *page)
 {
 }
--- a/mm/hugetlb.c~mmhwpoison-fix-race-with-hugetlb-page-allocation
+++ a/mm/hugetlb.c
@@ -5857,6 +5857,21 @@ unlock:
 	return ret;
 }
 
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
+{
+	int ret = 0;
+
+	*hugetlb = false;
+	spin_lock_irq(&hugetlb_lock);
+	if (PageHeadHuge(page)) {
+		*hugetlb = true;
+		if (HPageFreed(page) || HPageMigratable(page))
+			ret = get_page_unless_zero(page);
+	}
+	spin_unlock_irq(&hugetlb_lock);
+	return ret;
+}
+
 void putback_active_hugepage(struct page *page)
 {
 	spin_lock_irq(&hugetlb_lock);
--- a/mm/memory-failure.c~mmhwpoison-fix-race-with-hugetlb-page-allocation
+++ a/mm/memory-failure.c
@@ -949,6 +949,17 @@ static int page_action(struct page_state
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
+/*
+ * Return true if a page type of a given page is supported by hwpoison
+ * mechanism (while handling could fail), otherwise false.  This function
+ * does not return true for hugetlb or device memory pages, so it's assumed
+ * to be called only in the context where we never have such pages.
+ */
+static inline bool HWPoisonHandlable(struct page *page)
+{
+	return PageLRU(page) || __PageMovable(page);
+}
+
 /**
  * __get_hwpoison_page() - Get refcount for memory error handling:
  * @page:	raw error page (hit by memory error)
@@ -959,8 +970,22 @@ static int page_action(struct page_state
 static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
+	int ret = 0;
+	bool hugetlb = false;
+
+	ret = get_hwpoison_huge_page(head, &hugetlb);
+	if (hugetlb)
+		return ret;
+
+	/*
+	 * This check prevents from calling get_hwpoison_unless_zero()
+	 * for any unsupported type of page in order to reduce the risk of
+	 * unexpected races caused by taking a page refcount.
+	 */
+	if (!HWPoisonHandlable(head))
+		return 0;
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
+	if (PageTransHuge(head)) {
 		/*
 		 * Non anonymous thp exists only in allocation/free time. We
 		 * can't handle such a case correctly, so let's give it up.
@@ -1017,7 +1042,7 @@ try_again:
 			ret = -EIO;
 		}
 	} else {
-		if (PageHuge(p) || PageLRU(p) || __PageMovable(p)) {
+		if (PageHuge(p) || HWPoisonHandlable(p)) {
 			ret = 1;
 		} else {
 			/*
_
