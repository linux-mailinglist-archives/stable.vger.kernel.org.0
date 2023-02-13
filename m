Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3A069494B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjBMO6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjBMO6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAE11C7FA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A9CB8125F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E947AC433D2;
        Mon, 13 Feb 2023 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300243;
        bh=Z2Bzz69Yq77/4sUTL4JztDuef8lhfC0FwsuSg/n13jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCu9wHbg5E+xdc2w0ypLhECSnxgC83mcjIHPwbTwZfJgf2U3lmhpLAOuVc4k9k92M
         bH01Wp2qzpLnK4cUzx2Mz6lLIhWGUrrUoOm/QT40cKCXX+Ch74FfUQ7IS7tTOconjW
         vVchRTo70++9LYAFXi4wP3vOwDg/hCyjWRtWOS+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaohe Lin <linmiaohe@huawei.com>,
        Huang Ying <ying.huang@intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        David Hildenbrand <david@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.15 04/67] mm/migration: return errno when isolate_huge_page failed
Date:   Mon, 13 Feb 2023 15:48:45 +0100
Message-Id: <20230213144732.533780756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 7ce82f4c3f3ead13a9d9498768e3b1a79975c4d8 ]

We might fail to isolate huge page due to e.g.  the page is under
migration which cleared HPageMigratable.  We should return errno in this
case rather than always return 1 which could confuse the user, i.e.  the
caller might think all of the memory is migrated while the hugetlb page is
left behind.  We make the prototype of isolate_huge_page consistent with
isolate_lru_page as suggested by Huang Ying and rename isolate_huge_page
to isolate_hugetlb as suggested by Muchun to improve the readability.

Link: https://lkml.kernel.org/r/20220530113016.16663-4-linmiaohe@huawei.com
Fixes: e8db67eb0ded ("mm: migrate: move_pages() supports thp migration")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Reported-by: kernel test robot <lkp@intel.com> (build error)
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 73bdf65ea748 ("migrate: hugetlb: check for hugetlb shared PMD in node migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h |  6 +++---
 mm/gup.c                |  2 +-
 mm/hugetlb.c            | 11 +++++------
 mm/memory-failure.c     |  2 +-
 mm/memory_hotplug.c     |  2 +-
 mm/mempolicy.c          |  2 +-
 mm/migrate.c            |  7 ++++---
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cac25ad9d643f..f98d747f983b9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -166,7 +166,7 @@ bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_huge_page(struct page *page, struct list_head *list);
+int isolate_hugetlb(struct page *page, struct list_head *list);
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
@@ -354,9 +354,9 @@ static inline pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 	return NULL;
 }
 
-static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+static inline int isolate_hugetlb(struct page *page, struct list_head *list)
 {
-	return false;
+	return -EBUSY;
 }
 
 static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
diff --git a/mm/gup.c b/mm/gup.c
index 2370565a81dc3..0a1839b325747 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1877,7 +1877,7 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
 		 */
 		if (!is_pinnable_page(head)) {
 			if (PageHuge(head)) {
-				if (!isolate_huge_page(head, &movable_page_list))
+				if (isolate_hugetlb(head, &movable_page_list))
 					isolation_error_count++;
 			} else {
 				if (!PageLRU(head) && drain_allow) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8599f16d4aa4f..2f5c1b2456ef2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2656,8 +2656,7 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		if (!isolate_huge_page(old_page, list))
-			ret = -EBUSY;
+		ret = isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!HPageFreed(old_page)) {
@@ -2733,7 +2732,7 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && isolate_huge_page(head, list))
+	if (page_count(head) && !isolate_hugetlb(head, list))
 		ret = 0;
 	else if (!page_count(head))
 		ret = alloc_and_dissolve_huge_page(h, head, list);
@@ -6277,15 +6276,15 @@ follow_huge_pgd(struct mm_struct *mm, unsigned long address, pgd_t *pgd, int fla
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-bool isolate_huge_page(struct page *page, struct list_head *list)
+int isolate_hugetlb(struct page *page, struct list_head *list)
 {
-	bool ret = true;
+	int ret = 0;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!PageHeadHuge(page) ||
 	    !HPageMigratable(page) ||
 	    !get_page_unless_zero(page)) {
-		ret = false;
+		ret = -EBUSY;
 		goto unlock;
 	}
 	ClearHPageMigratable(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2ad0f45800916..9f9dd968fbe3c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2106,7 +2106,7 @@ static bool isolate_page(struct page *page, struct list_head *pagelist)
 	bool lru = PageLRU(page);
 
 	if (PageHuge(page)) {
-		isolated = isolate_huge_page(page, pagelist);
+		isolated = !isolate_hugetlb(page, pagelist);
 	} else {
 		if (lru)
 			isolated = !isolate_lru_page(page);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9fd0be32a281e..81f2a97c886c9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1704,7 +1704,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 
 		if (PageHuge(page)) {
 			pfn = page_to_pfn(head) + compound_nr(head) - 1;
-			isolate_huge_page(head, &source);
+			isolate_hugetlb(head, &source);
 			continue;
 		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4472be6f123db..8687781b41c96 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -604,7 +604,7 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
-		if (!isolate_huge_page(page, qp->pagelist) &&
+		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate page but allow migrating pages
diff --git a/mm/migrate.c b/mm/migrate.c
index 7da052c6cf1ea..dd50b1cc089e0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -134,7 +134,7 @@ static void putback_movable_page(struct page *page)
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_huge_page().
+ * and isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1722,8 +1722,9 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			isolate_huge_page(page, pagelist);
-			err = 1;
+			err = isolate_hugetlb(page, pagelist);
+			if (!err)
+				err = 1;
 		}
 	} else {
 		struct page *head;
-- 
2.39.0



