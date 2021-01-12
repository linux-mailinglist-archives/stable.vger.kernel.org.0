Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA33D2F276D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 05:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbhALE54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 23:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733273AbhALE54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 23:57:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CA33225AB;
        Tue, 12 Jan 2021 04:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610427435;
        bh=I2uFxUg/rcbbAgX3Wx1MNoUXKNn13iuJJ5aTgIPBk4Y=;
        h=Date:From:To:Subject:From;
        b=Cmxg2Ar76rETllG8udSxN+2wlxX6Ew0TR0DyaD+QxgKZPwJFcKr+UEzkdKokpE0CQ
         DVeFqcVc7DhbXmpPx8UhcStHIZyl7cId8eEYf3DkERoOtY6eF7zi9aEEOrWim6PWGw
         zBDg2j3smspvGXtSJ3yZXjuZMoU+sGF+zfQMMnG8=
Date:   Mon, 11 Jan 2021 20:57:14 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject:  +
 mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch added
 to -mm tree
Message-ID: <20210112045714.R3O20039Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix a race between freeing and dissolving the page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix a race between freeing and dissolving the page

There is a race condition between __free_huge_page()
and dissolve_free_huge_page().

CPU0:                         CPU1:

// page_count(page) == 1
put_page(page)
  __free_huge_page(page)
                              dissolve_free_huge_page(page)
                                spin_lock(&hugetlb_lock)
                                // PageHuge(page) && !page_count(page)
                                update_and_free_page(page)
                                // page is freed to the buddy
                                spin_unlock(&hugetlb_lock)
    spin_lock(&hugetlb_lock)
    clear_page_huge_active(page)
    enqueue_huge_page(page)
    // It is wrong, the page is already freed
    spin_unlock(&hugetlb_lock)

The race windows is between put_page() and dissolve_free_huge_page().

We should make sure that the page is already on the free list
when it is dissolved.

Link: https://lkml.kernel.org/r/20210110124017.86750-4-songmuchun@bytedance.com
Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page
+++ a/mm/hugetlb.c
@@ -79,6 +79,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
 static int num_fault_mutexes;
 struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
+static inline bool PageHugeFreed(struct page *head)
+{
+	return page_private(head + 4) == -1UL;
+}
+
+static inline void SetPageHugeFreed(struct page *head)
+{
+	set_page_private(head + 4, -1UL);
+}
+
+static inline void ClearPageHugeFreed(struct page *head)
+{
+	set_page_private(head + 4, 0);
+}
+
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
@@ -1028,6 +1043,7 @@ static void enqueue_huge_page(struct hst
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1044,6 +1060,7 @@ static struct page *dequeue_huge_page_no
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
+		ClearPageHugeFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		return page;
@@ -1505,6 +1522,7 @@ static void prep_new_huge_page(struct hs
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 }
 
@@ -1771,6 +1789,14 @@ int dissolve_free_huge_page(struct page
 		int nid = page_to_nid(head);
 		if (h->free_huge_pages - h->resv_huge_pages == 0)
 			goto out;
+
+		/*
+		 * We should make sure that the page is already on the free list
+		 * when it is dissolved.
+		 */
+		if (unlikely(!PageHugeFreed(head)))
+			goto out;
+
 		/*
 		 * Move PageHWPoison flag from head page to the raw error page,
 		 * which makes any subpages rather than the error page reusable.
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch

