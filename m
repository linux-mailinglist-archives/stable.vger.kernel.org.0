Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C8037B098
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 23:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhEKVO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 17:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhEKVOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 17:14:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53C40613C1;
        Tue, 11 May 2021 21:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620767608;
        bh=FaNqLXn0xP+HfLPemhVvI3HjnZNesqWTpZFJgCh7Zg4=;
        h=Date:From:To:Subject:From;
        b=T6P9+S7gipP0bjOp+fzbAWbZRv94ckRkkIQXpTuFrVTwS30mzwnmya5xvGaUu/kTI
         H69NG/X0dOI241HsBWotVr1iAyEjXerjD2Ecat+My1YIJT4YIIAjIhQgdYULNbSEB0
         DOIheqA0MWiOQUF8KBmH2fqQr2EFK7sNhi/5NYJU=
Date:   Tue, 11 May 2021 14:13:27 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, songmuchun@bytedance.com,
        stable@vger.kernel.org, tony.luck@intel.com
Subject:  + mmhwpoison-fix-race-with-compound-page-allocation.patch
 added to -mm tree
Message-ID: <20210511211327.ac1sYg2xy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: fix race with compound page allocation
has been added to the -mm tree.  Its filename is
     mmhwpoison-fix-race-with-compound-page-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-fix-race-with-compound-page-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-fix-race-with-compound-page-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmhwpoison-fix-race-with-compound-page-allocation.patch
mmhwpoison-make-get_hwpoison_page-call-get_any_page.patch

