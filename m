Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BBA2F7AA3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbhAOMwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388482AbhAOMwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 07:52:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEEEC0617A7
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:25 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n7so5962237pgg.2
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SURxKip/mYhGMjUhZ4z0ytkBtEFScnH+ZvTCaUzxn2g=;
        b=MAimcbY5VsTKL/RaGaw4hIl8R9xImx+LUTRLJVzSdfL7kG+q7uWjOLYNRnOA1NKImV
         9CvO995egFhsKUKUSwvsjXXNCEjAgQGuO/bM9Lvssk/40vSBgY83ISDADN2s9zXvoMFM
         krNsjbH+OH3PZij2ap32x7TcQrhN5aOGFympAuk+/pPGSUy/2CQPC1w+fBxxK2U9B1FF
         oivOaww9QNpmKkjgIGQAMZLGi0IitEq3Q8rleu/VDxkel1aOzLBwXZBHVdC24m9qWrO/
         LVUZ6ma90SGca09LcCN2UHAx/h1xMoQsSR16ZH+12gIyptgn+ZHtOUuBwdVldlWAmYNH
         kKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SURxKip/mYhGMjUhZ4z0ytkBtEFScnH+ZvTCaUzxn2g=;
        b=HNwCJZN48gqQ9HVjkKHfmTZOSsP/51i0T1QnOwnwEWpYqqufbZTsbvMGpSWKZtQ6IQ
         3k8adgwtTgAmXQX59u28W6hV1+ydxNWYDWWdSeVxGASzRqythyV9P+B2VsflJQh8bIDN
         UEx3WQWsW34h342JVvR+e66+MdaPIjOYLUEMxvuNtwN53z+hza7TYvTn1cVaDOnmODkM
         VzktUIhxi2RDTSEc/bQsdY/D3RZPnHuJNHAW73zjulRG50YH6wFyRVMmjjqGQWq74qfj
         NnEreK/LbYpkIKjGq1n+ox75GpXR4bP8xIlC4PBFU6ZlcNk0UCSG19L/ugOol5hN7tF5
         bTrg==
X-Gm-Message-State: AOAM532aWBxvOUORNSIZLMWDRceBs1KJxrI5lVC0ud/ZHW4NSrwT/E+P
        qSGo2CmercjkRbmTkfwf/hRP6PBv7tMyAr5xvzA=
X-Google-Smtp-Source: ABdhPJxxYQDcef8kwkMh6J61KL1JdqF9D4h57D3AcxgVwSS/v61gjpqzyebdv++OOEWmh63fWsTZeQ==
X-Received: by 2002:a62:864e:0:b029:1ab:e82c:d724 with SMTP id x75-20020a62864e0000b02901abe82cd724mr12462709pfd.9.1610715084805;
        Fri, 15 Jan 2021 04:51:24 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id c5sm8193600pjo.4.2021.01.15.04.51.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 04:51:23 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v6 3/5] mm: hugetlb: fix a race between freeing and dissolving the page
Date:   Fri, 15 Jan 2021 20:49:40 +0800
Message-Id: <20210115124942.46403-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210115124942.46403-1-songmuchun@bytedance.com>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4741d60f8955..b99fe4a2b435 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
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
 
@@ -1028,6 +1043,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
 	list_move(&page->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	SetPageHugeFreed(page);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1044,6 +1060,7 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
+		ClearPageHugeFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		return page;
@@ -1504,6 +1521,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 	spin_lock(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
+	ClearPageHugeFreed(page);
 	spin_unlock(&hugetlb_lock);
 }
 
@@ -1754,6 +1772,7 @@ int dissolve_free_huge_page(struct page *page)
 {
 	int rc = -EBUSY;
 
+retry:
 	/* Not to disrupt normal path by vainly holding hugetlb_lock */
 	if (!PageHuge(page))
 		return 0;
@@ -1770,6 +1789,26 @@ int dissolve_free_huge_page(struct page *page)
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
-- 
2.11.0

