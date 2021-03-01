Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB33285C9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhCAQ6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235942AbhCAQxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6C264F2B;
        Mon,  1 Mar 2021 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616446;
        bh=TWXoJ6lgeSQ7BibcpBI2MVTVJnH+o09sijQRaHhDNcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uz3rkjBFp3qVmbo77ijNgJSU2sAxBcnja2cTQwrLJmmjwlGjgSnKjNyB9VnDOR76p
         CzRJ+CtjcV8raz77YlOG02IAkjQ0ngkrVZFSbzNJ4n8lXg//DaMiK/5pJzEDKC77aS
         AENF+JEJB0pfZv0ACZejA01JdzEieVqlRwiLECkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 154/176] mm: hugetlb: fix a race between freeing and dissolving the page
Date:   Mon,  1 Mar 2021 17:13:47 +0100
Message-Id: <20210301161028.664192563@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 7ffddd499ba6122b1a07828f023d1d67629aa017 upstream

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

The race window is between put_page() and dissolve_free_huge_page().

We should make sure that the page is already on the free list when it is
dissolved.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -69,6 +69,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
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
 
@@ -866,6 +881,7 @@ static void enqueue_huge_page(struct hst
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -883,6 +899,7 @@ static struct page *dequeue_huge_page_no
 		return NULL;
 	list_move(&page->lru, &h->hugepage_activelist);
 	set_page_refcounted(page);
+	ClearPageHugeFreed(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
 	return page;
@@ -1315,6 +1332,7 @@ static void prep_new_huge_page(struct hs
 	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 	put_page(page); /* free it into the hugepage allocator */
 }
@@ -1478,6 +1496,7 @@ int dissolve_free_huge_page(struct page
 {
 	int rc = 0;
 
+retry:
 	spin_lock(&hugetlb_lock);
 	if (PageHuge(page) && !page_count(page)) {
 		struct page *head = compound_head(page);
@@ -1487,6 +1506,26 @@ int dissolve_free_huge_page(struct page
 			rc = -EBUSY;
 			goto out;
 		}
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


