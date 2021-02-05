Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BA33102D4
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBECdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:33:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhBECcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 838F864FA7;
        Fri,  5 Feb 2021 02:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492328;
        bh=P6f1F6FJYzZax6vY2IZ9d990X5Oqy/8KsN8hSZGebcU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gOnREfVGwXXZccNnGCGP9ebPlEM7zjV+Rd2SFhID5HhWTvlemThb9Nmygojic4S9Z
         xc+cWVLFPlgUcjAwDhvq5GyqYVKG99ZGqID40vj215pSgaxrdVn2/ngU1ScYsctyx7
         lv27ir17+a2FeuNA8Jz6WdhXDNPHlCREQL8SJx+c=
Date:   Thu, 04 Feb 2021 18:32:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/18] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210205023206.qxjmf4Zwv%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

As a result __free_huge_page would corrupt page(s) already in the buddy
allocator.

Link: https://lkml.kernel.org/r/20210115124942.46403-4-songmuchun@bytedance.com
Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

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
 
@@ -1755,6 +1773,7 @@ int dissolve_free_huge_page(struct page
 {
 	int rc = -EBUSY;
 
+retry:
 	/* Not to disrupt normal path by vainly holding hugetlb_lock */
 	if (!PageHuge(page))
 		return 0;
@@ -1771,6 +1790,26 @@ int dissolve_free_huge_page(struct page
 		int nid = page_to_nid(head);
 		if (h->free_huge_pages - h->resv_huge_pages == 0)
 			goto out;
+
+		/*
+		 * We should make sure that the page is already on the free list
+		 * when it is dissolved.
+		 */
+		if (unlikely(!PageHugeFreed(head))) {
+			spin_unlock(&hugetlb_lock);
+			cond_resched();
+
+			/*
+			 * Theoretically, we should return -EBUSY when we
+			 * encounter this race. In fact, we have a chance
+			 * to successfully dissolve the page if we do a
+			 * retry. Because the race window is quite small.
+			 * If we seize this opportunity, it is an optimization
+			 * for increasing the success rate of dissolving page.
+			 */
+			goto retry;
+		}
+
 		/*
 		 * Move PageHWPoison flag from head page to the raw error page,
 		 * which makes any subpages rather than the error page reusable.
_
