Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33BC5C59C
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 00:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAWXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 18:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfGAWXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 18:23:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5152173E;
        Mon,  1 Jul 2019 22:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562019781;
        bh=56rgKPQbLBbUgG4Gz2/Zqqme9DyC8lj0CybexU+SOZo=;
        h=Date:From:To:Subject:From;
        b=Q9/UOPZwqwJxFGfYgOADdS5N48ppLDYgZHvqEKIHuOIIkxRCP80AxoUEUx9EED6R4
         F6P3g7tpCrmuoHMJW2NPdDEFymRbRTYfLNQNSVJUBvIk8ztDqopdb5dJaG5BS4cPCc
         iWH0Ij+1fP+f6nzTckYubbNYIT/vDyGMXCY0oa58=
Date:   Mon, 01 Jul 2019 15:23:00 -0700
From:   akpm@linux-foundation.org
To:     jerry.t.chen@intel.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, qiuxu.zhuo@intel.com, stable@vger.kernel.org,
        xishi.qiuxishi@alibaba-inc.com
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-soft-offline-dissolve=5Ffree=5Fhuge=5Fpage-retur?=
 =?US-ASCII?Q?n-zero-on-pagehuge.patch?= removed from -mm tree
Message-ID: <20190701222300.g4nVDeWtl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on !PageHuge
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on !PageHuge

madvise(MADV_SOFT_OFFLINE) often returns -EBUSY when calling soft offline
for hugepages with overcommitting enabled.  That was caused by the
suboptimal code in current soft-offline code.  See the following part:

    ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
                            MIGRATE_SYNC, MR_MEMORY_FAILURE);
    if (ret) {
            ...
    } else {
            /*
             * We set PG_hwpoison only when the migration source hugepage
             * was successfully dissolved, because otherwise hwpoisoned
             * hugepage remains on free hugepage list, then userspace will
             * find it as SIGBUS by allocation failure. That's not expected
             * in soft-offlining.
             */
            ret = dissolve_free_huge_page(page);
            if (!ret) {
                    if (set_hwpoison_free_buddy_page(page))
                            num_poisoned_pages_inc();
            }
    }
    return ret;

Here dissolve_free_huge_page() returns -EBUSY if the migration source page
was freed into buddy in migrate_pages(), but even in that case we actually
has a chance that set_hwpoison_free_buddy_page() succeeds.  So that means
current code gives up offlining too early now.

dissolve_free_huge_page() checks that a given hugepage is suitable for
dissolving, where we should return success for !PageHuge() case because
the given hugepage is considered as already dissolved.

This change also affects other callers of dissolve_free_huge_page(), which
are cleaned up together.

Link: http://lkml.kernel.org/r/1560154686-18497-3-git-send-email-n-horiguchi@ah.jp.nec.com
Fixes: 6bc9b56433b76 ("mm: fix race on soft-offlining")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Chen, Jerry T <jerry.t.chen@intel.com>
Tested-by: Chen, Jerry T <jerry.t.chen@intel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>
Cc: "Chen, Jerry T" <jerry.t.chen@intel.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: <stable@vger.kernel.org>	[4.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |   15 +++++++++------
 mm/memory-failure.c |    5 +----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge
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
--- a/mm/memory-failure.c~mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge
+++ a/mm/memory-failure.c
@@ -1856,11 +1856,8 @@ static int soft_offline_in_use_page(stru
 
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


