Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD32F43D1
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 06:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbhAMF0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 00:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbhAMF0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 00:26:33 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881D0C0617A3
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n10so751001pgl.10
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 21:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JlQZQVrOm402ulHFjYHU+1nImQj/z6C/J2SHh6gZPrk=;
        b=ujayAIQH7e5D07vHiW8ktnM5b+1Sj0HSbBPecs9gbudPs6Gv3oWDdnyOFdH38A5eoV
         EvMMnU9FgwoYk1vghm+TAafxj45NdEG7v65EG2XTFOjwtTS0fqGmuBykLlZaXAmKluNq
         gLMMRGSswPNoNA1IdD7Pv/aImOdpFtgTu3s3qFXKokNIhsjDi1M9+a3FpM5na3PC32MA
         OWVoLNsEucG1t72DMPtUPB0B3iB6gVheQ9RDr5qs6UtF9qCNLDoq+76i+JTJfpYh+b4l
         /3B0SQyesOGSFdCS6lThNm4lVo+G8umqvRHU8MfQtA/ZlQg4tSBHd1CJyL9K5o9IqtQN
         zECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlQZQVrOm402ulHFjYHU+1nImQj/z6C/J2SHh6gZPrk=;
        b=fq3dVxRrO4OMeVRDen1c2Sr/eWoAdcLCq/9jTXvfZEAUsx6uiPQBkBkd5GGxw9O/Yo
         8s0rkhh5aWICJNLl0adTuPlez65tmVkMGzeawaYrqUMMUkrCSA4SeFtE0is7ceFQkeaU
         +oqqh+6eHd0xY6Vlk+B9zuFoLn7Xu7fzysqYF9Qta7Gk4LUEdMmbh9BIQyHLMUS1Axv+
         MWzVGbaNFvrN0/6xY3Kxf4FVR6+qG969UBKQfh7bZnGNK37ToqWrDJnokYM/LJmT0jkp
         pSqFdEgUN6UXR+1R6tKczagqZ2DCYpYwsv6rFtevRHg0XzVuksBEEScKy/bPuwWb2h4o
         ucuQ==
X-Gm-Message-State: AOAM530WEgawIvlm8xoGddhth+0oC4unVl33pweVFhlxQIfuEls/XHUN
        4xW0QD96Tzzjl7pacvU/T2Q4qx75WCpNKCHhSTs=
X-Google-Smtp-Source: ABdhPJxPLRQfjsTnvt/HmlGnGJNCjHsOsPGMcbaQEqmWlQVyc40MLv2lELMjR5jMm2y+VTHq3wbtcQ==
X-Received: by 2002:aa7:843a:0:b029:19d:b279:73c9 with SMTP id q26-20020aa7843a0000b029019db27973c9mr447437pfn.3.1610515544150;
        Tue, 12 Jan 2021 21:25:44 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id x15sm893081pfa.80.2021.01.12.21.25.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 21:25:43 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org
Cc:     n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v4 3/6] mm: hugetlb: fix a race between freeing and dissolving the page
Date:   Wed, 13 Jan 2021 13:22:06 +0800
Message-Id: <20210113052209.75531-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210113052209.75531-1-songmuchun@bytedance.com>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
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
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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

