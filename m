Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54A42F0740
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 13:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbhAJMmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 07:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJMmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 07:42:16 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF78C0617A4
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 04:41:36 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e2so8038606plt.12
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 04:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3gDuLjEjqpY5hJrgoP0zbm1oa1HSY0dQY30oFlgAYQ=;
        b=rWeFaHhdx26QIcu4oFq9jt4fdoiwTTEMHiX0GcDFnvXCNSEGXKNUOhSowItykhSP+s
         MU2lB7VGPKOpR26dagIJbSrZ0z4DQUseP8TI1Hr8218icPt2CE59nrthBPoGc5+2L0py
         GldzLHOZ/qQ22eoxfirNB/sX7sTFkGnYQS4NQwdHXLZ95tD8fo3K17CN+WvUYYuirXhr
         TpF+IMj8yyO/hRNwe/nRuTb4oq+CLbVTwC4ZMsGRxI8qPFxdbhi6TNcVuZv0oM+ZLqNg
         4jK9h5RHhQ6APoWqIDlwAfx9/2k67z/4jNjM/HkPqSz2S5XOK+/rLaWpDAKaMrYgYVJT
         m2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3gDuLjEjqpY5hJrgoP0zbm1oa1HSY0dQY30oFlgAYQ=;
        b=DFiTh2E7nkdXmDmlDqLZj4X1S6ImZnn8PkF0I1LB8jp37T3OatLeI9G5j5LX99uvTm
         pkKfWgNY6N3QQEPK/oIlSmLMvyMqfa6GQ4YcYAPTyHoAlYeqxC1kr2aEXzhmcLYPI3Vc
         2YZM6YlCB2QjPopq/lTCn/aBo2K3g+sfGTb8dGfMTpSybxRRqupiMGXpu2yecCmahy3A
         M/fXrx+6RvH6TvM/b0RhTD/NUGP/Ne93Q0PaFaD+Dqo2wumEyMrmeRel8jOW/1q1rDR0
         R6V9w40E2Sk3gpuhqkC0KSYndFfhdlpkreFJ1n4w35yWfWEe1UOFHDrNJ1/JkRGo4R5q
         u8VQ==
X-Gm-Message-State: AOAM5321f0s1FaVarncYnj4ndv+UPnMAxVFytycjKBfgiEXTBQtsiGGx
        KPpu+uwEztl1z9fINUE8GyHpMA==
X-Google-Smtp-Source: ABdhPJzWrZDYsSoIxdfRxNA612sIivazrBh4X8Socv1b7/yltfVgFXyC4/ghwU7KuryYYJvTKH3CpQ==
X-Received: by 2002:a17:90a:4402:: with SMTP id s2mr12942473pjg.37.1610282495977;
        Sun, 10 Jan 2021 04:41:35 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id p9sm16176960pfq.136.2021.01.10.04.41.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Jan 2021 04:41:35 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v3 3/6] mm: hugetlb: fix a race between freeing and dissolving the page
Date:   Sun, 10 Jan 2021 20:40:14 +0800
Message-Id: <20210110124017.86750-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210110124017.86750-1-songmuchun@bytedance.com>
References: <20210110124017.86750-1-songmuchun@bytedance.com>
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

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4741d60f8955..4a9011e12175 100644
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
 
@@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
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
-- 
2.11.0

