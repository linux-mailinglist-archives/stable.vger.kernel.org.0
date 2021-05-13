Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D270C38006D
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 00:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhEMWh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 18:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMWh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 18:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D8561354;
        Thu, 13 May 2021 22:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620945407;
        bh=RHkDFrKOGPRBMRUyUq8BjVwKJ1MGUHZe42Na54TkwIU=;
        h=Date:From:To:Subject:From;
        b=0sqSVwlrG0MVZHkPDu0U4Mbuq3DDITeQg6KyrVKfmo2k80CohtQu0KxrSYbZn3L0k
         v7TtFSyLyAXHgKucOod10M4B6OuA7IM5dQLtIGeFWb+JD+ApWYT0V+EHgHIwxmWUvJ
         SoHIo5iOTY64sFZT5b/rvsnqr5fI5iqFfxOx6VZ0=
Date:   Thu, 13 May 2021 15:36:46 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com,
        stable@vger.kernel.org, tony.luck@intel.com
Subject:  [to-be-updated]
 mmhwpoison-fix-race-with-compound-page-allocation.patch removed from -mm
 tree
Message-ID: <20210513223646.uLNGuWjfZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: fix race with compound page allocation
has been removed from the -mm tree.  Its filename was
     mmhwpoison-fix-race-with-compound-page-allocation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: fix race with compound page allocation

When hugetlb page fault (under overcommiting situation) and
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

__get_hwpoison_page() only checks page refcount before taking additional
one for memory error handling, which is wrong because there's time windows
where compound pages have non-zero refcount during initialization.

So make __get_hwpoison_page() check page status a bit more for a few types
of compound pages.  PageSlab() check is added because otherwise "non
anonymous thp" path is wrongly chosen.

Link: https://lkml.kernel.org/r/20210511151016.2310627-2-nao.horiguchi@gmail.com
Fixes: ead07f6a867b ("mm/memory-failure: introduce get_hwpoison_page() for consistent refcount handling")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   55 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 21 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-fix-race-with-compound-page-allocation
+++ a/mm/memory-failure.c
@@ -960,30 +960,43 @@ static int __get_hwpoison_page(struct pa
 {
 	struct page *head = compound_head(page);
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
+	if (PageCompound(page)) {
+		if (PageSlab(page)) {
+			return get_page_unless_zero(page);
+		} else if (PageHuge(head)) {
+			int ret = 0;
 
-	if (get_page_unless_zero(head)) {
-		if (head == compound_head(page))
-			return 1;
-
-		pr_info("Memory failure: %#lx cannot catch tail\n",
-			page_to_pfn(page));
-		put_page(head);
+			spin_lock(&hugetlb_lock);
+			if (!PageHuge(head))
+				ret = -EBUSY;
+			else if (HPageFreed(head) || HPageMigratable(head))
+				ret = get_page_unless_zero(head);
+			spin_unlock(&hugetlb_lock);
+			return ret;
+		} else if (PageTransHuge(head)) {
+			/*
+			 * Non anonymous thp exists only in allocation/free time. We
+			 * can't handle such a case correctly, so let's give it up.
+			 * This should be better than triggering BUG_ON when kernel
+			 * tries to touch the "partially handled" page.
+			 */
+			if (!PageAnon(head)) {
+				pr_err("Memory failure: %#lx: non anonymous thp\n",
+				       page_to_pfn(page));
+				return 0;
+			}
+			if (get_page_unless_zero(head)) {
+				if (head == compound_head(page))
+					return 1;
+				pr_info("Memory failure: %#lx cannot catch tail\n",
+					page_to_pfn(page));
+				put_page(head);
+			}
+		}
+		return 0;
 	}
 
-	return 0;
+	return get_page_unless_zero(page);
 }
 
 /*
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


