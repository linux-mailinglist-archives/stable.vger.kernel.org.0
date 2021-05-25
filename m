Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9DF390D08
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhEYXre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 19:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhEYXrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 19:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F086B60FDC;
        Tue, 25 May 2021 23:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986363;
        bh=u5dH1eG4eFhS8UxG/M0Z7iVWLOq6bt7ilq7ongIgx3g=;
        h=Date:From:To:Subject:From;
        b=hAddtAm8ydsjJE1NxjxNMApImJIRP59ttrMM2nTCX/dUwcRFt4s1I3q8CXKV0o7Sj
         Wkb8KNGSguAs44u2u/XYMYYto6hfU+0JTAvCISPhbp6ei49GUB4pavEYLQkTLjLBhg
         ptObLLwrE0eOj30UhSACYvy9F7e85pgP1gojGf0U=
Date:   Tue, 25 May 2021 16:46:02 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        tony.luck@intel.com
Subject:  [to-be-updated]
 mmhwpoison-fix-race-with-hugetlb-page-allocation.patch removed from -mm
 tree
Message-ID: <20210525234602.5UKGJV5W8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: fix race with hugetlb page allocation
has been removed from the -mm tree.  Its filename was
     mmhwpoison-fix-race-with-hugetlb-page-allocation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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
additional one for memory error handling, which is wrong because there's a
time window where compound pages have non-zero refcount during
initialization.  So make __get_hwpoison_page() check page status a bit
more for hugetlb pages.

Link: https://lkml.kernel.org/r/20210518231259.2553203-2-nao.horiguchi@gmail.com
Fixes: ead07f6a867b ("mm/memory-failure: introduce get_hwpoison_page() for consistent refcount handling")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   15 +++++++++++++++
 mm/memory-failure.c     |    8 +++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

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
@@ -5847,6 +5847,21 @@ unlock:
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
@@ -959,8 +959,14 @@ static int page_action(struct page_state
 static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
+	int ret = 0;
+	bool hugetlb = false;
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
+	ret = get_hwpoison_huge_page(head, &hugetlb);
+	if (hugetlb)
+		return ret;
+
+	if (PageTransHuge(head)) {
 		/*
 		 * Non anonymous thp exists only in allocation/free time. We
 		 * can't handle such a case correctly, so let's give it up.
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch
mmhwpoison-send-sigbus-with-error-virutal-address.patch

