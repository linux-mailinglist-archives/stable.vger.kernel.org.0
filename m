Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EE53AF0C0
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhFUQwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhFUQuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D906613E9;
        Mon, 21 Jun 2021 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293300;
        bh=DTdE6AkAOZ9bgUSZqgZTzSc4lGf74S9EoZ3oVtIhUwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMyxJq0LHR36q8p51CCpIcLfb41tPzyPftgjFKv8f13PGLbY+YI83kR8+HN4Yr3OM
         bYD5HBbQyE9qCrCB+1YOZya6sDFQ95Pgy+YId6aid3w+nDJ02MaPSgFVYULilrXPkE
         MbMqxEr+JEKg6X9qKrddBGKdBNUFMeV9cMyrS2r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 166/178] mm,hwpoison: fix race with hugetlb page allocation
Date:   Mon, 21 Jun 2021 18:16:20 +0200
Message-Id: <20210621154928.395678837@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 25182f05ffed0b45602438693e4eed5d7f3ebadd upstream.

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
It's notable that another new function, HWPoisonHandlable(), is helpful
to prevent a race against other transitive page states (like a generic
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   15 +++++++++++++++
 mm/memory-failure.c     |   29 +++++++++++++++++++++++++++--
 3 files changed, 48 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -145,6 +145,7 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
+int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 void putback_active_hugepage(struct page *page);
 void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
@@ -330,6 +331,11 @@ static inline bool isolate_huge_page(str
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
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5664,6 +5664,21 @@ unlock:
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
 	spin_lock(&hugetlb_lock);
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
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


