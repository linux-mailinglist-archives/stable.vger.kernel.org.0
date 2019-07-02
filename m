Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C185CB50
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfGBIMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbfGBIMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:12:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3998020659;
        Tue,  2 Jul 2019 08:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055166;
        bh=IHVZSb+9KZcY+NwRW1gMyaH2wKojBuiMeGUOBuwWubw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYSzjOoMYQju2yxPLk+HaOFIrGzeXuXbx6IPT6ucuVR6QnQAG46a3FTOrXqwXP1ia
         rmf5v8ympIcEsDQWUWjEWGBymyhGwOWgKcp6FroTbeiQWjoeCcJZfcVKi/+If5o5TF
         bJH5upf2SDB6C5NIDb8SuOCHUmfUyO0E5JGgqKY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Chen, Jerry T" <jerry.t.chen@intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@kernel.org>,
        Xishi Qiu <xishi.qiuxishi@alibaba-inc.com>,
        "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 14/55] mm: hugetlb: soft-offline: dissolve_free_huge_page() return zero on !PageHuge
Date:   Tue,  2 Jul 2019 10:01:22 +0200
Message-Id: <20190702080124.778004694@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit faf53def3b143df11062d87c12afe6afeb6f8cc7 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c        |   29 ++++++++++++++++++++---------
 mm/memory-failure.c |    5 +----
 2 files changed, 21 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1491,16 +1491,29 @@ static int free_pool_huge_page(struct hs
 
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
@@ -1545,11 +1558,9 @@ int dissolve_free_huge_pages(unsigned lo
 
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
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1859,11 +1859,8 @@ static int soft_offline_in_use_page(stru
 
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


