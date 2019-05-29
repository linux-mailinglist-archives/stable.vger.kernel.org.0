Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B572D56E
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 08:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfE2GWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 02:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfE2GWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 02:22:32 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3DE20657;
        Wed, 29 May 2019 06:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559110951;
        bh=iskw882tsSUixkMiTSryEhIUHAGAE1h2Sju1oylRluo=;
        h=Date:From:To:Subject:From;
        b=JHuX3G/i5yr9OPeG+F16g7wVMO7wydlz9jXv1ubpXfYccHlI715Z1V3h1Y6GUerLN
         +LUJspUUl1n+S/rgy0Yh9BX8iJg2WTtcYJsiq/RoXNGmjrfBfOYIaOeJgk59YZxs6h
         Ss1rnL24uuzGY/blRe+q8XS2xovdJm0pj17yZNSk=
Date:   Tue, 28 May 2019 23:22:31 -0700
From:   akpm@linux-foundation.org
To:     jerry.t.chen@intel.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        qiuxu.zhuo@intel.com, stable@vger.kernel.org
Subject:  [to-be-updated]
 mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch
 removed from -mm tree
Message-ID: <20190529062231.qyprvrMWA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: soft-offline: fix wrong return value of soft offline
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: soft-offline: fix wrong return value of soft offline

Soft offline events for hugetlb pages return -EBUSY when page migration
succeeded and dissolve_free_huge_page() failed, which can happen when
there're surplus hugepages.  We should judge pass/fail of soft offline by
checking whether the raw error page was finally contained or not (i.e. 
the result of set_hwpoison_free_buddy_page()), so this behavior is wrong.

This problem was introduced by the following change of commit 6bc9b56433b76
("mm: fix race on soft-offlining"):

                    if (ret > 0)
                            ret = -EIO;
            } else {
    -               if (PageHuge(page))
    -                       dissolve_free_huge_page(page);
    +               /*
    +                * We set PG_hwpoison only when the migration source hugepage
    +                * was successfully dissolved, because otherwise hwpoisoned
    +                * hugepage remains on free hugepage list, then userspace will
    +                * find it as SIGBUS by allocation failure. That's not expected
    +                * in soft-offlining.
    +                */
    +               ret = dissolve_free_huge_page(page);
    +               if (!ret) {
    +                       if (set_hwpoison_free_buddy_page(page))
    +                               num_poisoned_pages_inc();
    +               }
            }
            return ret;
     }

so a simple fix is to restore the PageHuge precheck, but my code reading
shows that we already have PageHuge check in dissolve_free_huge_page()
with hugetlb_lock, which is better place to check it.  And currently
dissolve_free_huge_page() returns -EBUSY for !PageHuge but that's simply
wrong because that that case should be considered as success (meaning that
"the given hugetlb was already dissolved.")

This change affects other callers of dissolve_free_huge_page(), which are
also cleaned up by this patch.

Link: http://lkml.kernel.org/r/1558937200-18544-1-git-send-email-n-horiguchi@ah.jp.nec.com
Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Chen, Jerry T <jerry.t.chen@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |   15 +++++++++------
 mm/memory-failure.c |    7 +++----
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline
+++ a/mm/hugetlb.c
@@ -1519,7 +1519,12 @@ int dissolve_free_huge_page(struct page
 	int rc = -EBUSY;
 
 	spin_lock(&hugetlb_lock);
-	if (PageHuge(page) && !page_count(page)) {
+	if (!PageHuge(page)) {
+		rc = 0;
+		goto out;
+	}
+
+	if (!page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
 		int nid = page_to_nid(head);
@@ -1564,11 +1569,9 @@ int dissolve_free_huge_pages(unsigned lo
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order) {
 		page = pfn_to_page(pfn);
-		if (PageHuge(page) && !page_count(page)) {
-			rc = dissolve_free_huge_page(page);
-			if (rc)
-				break;
-		}
+		rc = dissolve_free_huge_page(page);
+		if (rc)
+			break;
 	}
 
 	return rc;
--- a/mm/memory-failure.c~mm-hugetlb-soft-offline-fix-wrong-return-value-of-soft-offline
+++ a/mm/memory-failure.c
@@ -1733,6 +1733,8 @@ static int soft_offline_huge_page(struct
 		if (!ret) {
 			if (set_hwpoison_free_buddy_page(page))
 				num_poisoned_pages_inc();
+			else
+				ret = -EBUSY;
 		}
 	}
 	return ret;
@@ -1857,11 +1859,8 @@ static int soft_offline_in_use_page(stru
 
 static int soft_offline_free_page(struct page *page)
 {
-	int rc = 0;
-	struct page *head = compound_head(page);
+	int rc = dissolve_free_huge_page(page);
 
-	if (PageHuge(head))
-		rc = dissolve_free_huge_page(page);
 	if (!rc) {
 		if (set_hwpoison_free_buddy_page(page))
 			num_poisoned_pages_inc();
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


