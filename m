Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE65A4C9
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfF1TG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:06:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0EB215EA;
        Fri, 28 Jun 2019 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748817;
        bh=Hcr37edVDv1puvP90Zk9vIhKiwMUIAOxP+eTaq+Phjo=;
        h=Date:From:To:Subject:From;
        b=Y3eH5ql6rLqwN+mcKskNa6lh6Oe+E7uku6AujQ3lVpQPAWI1otUriRi8HiAubImHx
         ttmP4RVRZaGOkMNEUKdv1KP18o0sQHjjF4d5EvducDpC4oCUqOCdgH5Jj3QdNh3cki
         42nBU2wIaFYQyVsyRurm9gAoB4KZ/Wl4GenaDROs=
Date:   Fri, 28 Jun 2019 12:06:56 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jerry.t.chen@intel.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        osalvador@suse.de, qiuxu.zhuo@intel.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, xishi.qiuxishi@alibaba-inc.com
Subject:  [patch 07/15] mm: hugetlb: soft-offline:
 dissolve_free_huge_page() return zero on !PageHuge
Message-ID: <20190628190656.mui-ICRnR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[n-horiguchi@ah.jp.nec.com: v3]
  Link: http://lkml.kernel.org/r/1560761476-4651-3-git-send-email-n-horiguchi@ah.jp.nec.comLink: http://lkml.kernel.org/r/1560154686-18497-3-git-send-email-n-horiguchi@ah.jp.nec.com
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

 mm/hugetlb.c        |   29 ++++++++++++++++++++---------
 mm/memory-failure.c |    5 +----
 2 files changed, 21 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-soft-offline-dissolve_free_huge_page-return-zero-on-pagehuge
+++ a/mm/hugetlb.c
@@ -1510,16 +1510,29 @@ static int free_pool_huge_page(struct hs
 
 /*
  * Dissolve a given free hugepage into free buddy pages. This function does
- * nothing for in-use (including surplus) hugepages. Returns -EBUSY if the
- * dissolution fails because a give page is not a free hugepage, or because
- * free hugepages are fully reserved.
+ * nothing for in-use hugepages and non-hugepages.
+ * This function returns values like below:
+ *
+ *  -EBUSY: failed to dissolved free hugepages or the hugepage is in-use
+ *          (allocated or reserved.)
+ *       0: successfully dissolved free hugepages or the page is not a
+ *          hugepage (considered as already dissolved)
  */
 int dissolve_free_huge_page(struct page *page)
 {
 	int rc = -EBUSY;
 
+	/* Not to disrupt normal path by vainly holding hugetlb_lock */
+	if (!PageHuge(page))
+		return 0;
+
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
@@ -1564,11 +1577,9 @@ int dissolve_free_huge_pages(unsigned lo
 
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
