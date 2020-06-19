Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632452009F1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgFSNYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbgFSNYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:34 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92604C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:32 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l17so8833806qki.9
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tSlflZnjRytpuaKut1glzNKna4qPmgn8PR7ZFAqsqOo=;
        b=daaHqCYwwcgYXrgT5BPLRG3lkhmPiUUKTxtD13WTocwl0liwlHU+LO+TyrImDMe06B
         BipNgxrFM+zaLspZTBtjZFpi2mUBSI7E92lTjbnfjt05NG3aKrPPcWEvMvh00agasXoS
         XAoBsofcgBwTsTfAMuumYzTJODzoYitWLW51iUxsNkaI4V0j0oIR03clRQWK8kvAnb3+
         n2zsGM62BnUNn5dktvh7rbEjsHGnZqp+orPJqCSstCV/B+Lf95sXLLmKLC1Gw3m8VSGO
         9Ka+gM4UxPA2ldCyyoIxJnVd9pfP0ziQTYaboFxqtVRs1uKkLpVq053hv1DtV5WePF+k
         FKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tSlflZnjRytpuaKut1glzNKna4qPmgn8PR7ZFAqsqOo=;
        b=MvZk3zUtVj+XiPT2lclu9kaK/vpYKoIlRVrwzOXLKHSZPKLUirfYPsZPK0RDjXB4Xw
         44VXuVivxOH1bN+hpRZfhJ9BLI4ei8Gy/DMqsX+B9cOUFIiDyYbuv1kRzo+SYYyEyB8g
         8O7hu42ALMBZYCr+7s5F0JUBd2tJTcrttBTBEEV4BkQrjC3tLYdMoFU2W0CbYL9e3JnT
         ubFQLXE/OGuqY0vmdEjy+312qG+lrzLP9bFvCZfLABGcn5I9t1Xkb7rr8+CSnoutgAcd
         SpVRxjflZBRHxpEpqkB7RtlzxHioYhNYxF8s5r2U2N6lZn+5cH7vQx6ua+PmdKHoAy+O
         qtaw==
X-Gm-Message-State: AOAM532EazNvtzPzgcxG5miua1n8xbzVzc8VRF9/yd4E7Xx2tTAa02e9
        Q3AJXuOP9fyQGRCxYdGG6x5wN3G7Jvs=
X-Google-Smtp-Source: ABdhPJy4paViUgyD3/uoRqDYN1hImpGXaZyQKlu0RDmwL/ZJKGN1hZXzx6dor/axhSpIyIY3wvbNVg==
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr3397797qkn.104.1592573071365;
        Fri, 19 Jun 2020 06:24:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:30 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 3/7] mm: initialize MAX_ORDER_NR_PAGES at a time instead of doing larger sections
Date:   Fri, 19 Jun 2020 09:24:21 -0400
Message-Id: <20200619132425.425063-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

commit 0e56acae4b4dd4a9fbe897854ab83a109e2a9e11 upstream.

Add yet another iterator, for_each_free_mem_range_in_zone_from, and then
use it to support initializing and freeing pages in groups no larger than
MAX_ORDER_NR_PAGES.  By doing this we can greatly improve the cache
locality of the pages while we do several loops over them in the init and
freeing process.

We are able to tighten the loops further as a result of the "from"
iterator as we can perform the initial checks for first_init_pfn in our
first call to the iterator, and continue without the need for those checks
via the "from" iterator.  I have added this functionality in the function
called deferred_init_mem_pfn_range_in_zone that primes the iterator and
causes us to exit if we encounter any failure.

On my x86_64 test system with 384GB of memory per node I saw a reduction
in initialization time from 1.85s to 1.38s as a result of this patch.

Link: http://lkml.kernel.org/r/20190405221231.12227.85836.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <yi.z.zhang@linux.intel.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/memblock.h |  16 ++++
 mm/page_alloc.c          | 162 +++++++++++++++++++++++++++++----------
 2 files changed, 137 insertions(+), 41 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 76b3d92b096e..f787c7a9b42c 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -255,6 +255,22 @@ void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end);	\
 	     i != U64_MAX;					\
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
+
+/**
+ * for_each_free_mem_range_in_zone_from - iterate through zone specific
+ * free memblock areas from a given point
+ * @i: u64 used as loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in a specific
+ * zone, continuing from current position. Available as soon as memblock is
+ * initialized.
+ */
+#define for_each_free_mem_pfn_range_in_zone_from(i, zone, p_start, p_end) \
+	for (; i != U64_MAX;					  \
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8eb3c44c3c13..a287d7a7dc33 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1533,16 +1533,100 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 	return (nr_pages);
 }
 
+/*
+ * This function is meant to pre-load the iterator for the zone init.
+ * Specifically it walks through the ranges until we are caught up to the
+ * first_init_pfn value and exits there. If we never encounter the value we
+ * return false indicating there are no valid ranges left.
+ */
+static bool __init
+deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
+				    unsigned long *spfn, unsigned long *epfn,
+				    unsigned long first_init_pfn)
+{
+	u64 j;
+
+	/*
+	 * Start out by walking through the ranges in this zone that have
+	 * already been initialized. We don't need to do anything with them
+	 * so we just need to flush them out of the system.
+	 */
+	for_each_free_mem_pfn_range_in_zone(j, zone, spfn, epfn) {
+		if (*epfn <= first_init_pfn)
+			continue;
+		if (*spfn < first_init_pfn)
+			*spfn = first_init_pfn;
+		*i = j;
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Initialize and free pages. We do it in two loops: first we initialize
+ * struct page, then free to buddy allocator, because while we are
+ * freeing pages we can access pages that are ahead (computing buddy
+ * page in __free_one_page()).
+ *
+ * In order to try and keep some memory in the cache we have the loop
+ * broken along max page order boundaries. This way we will not cause
+ * any issues with the buddy page computation.
+ */
+static unsigned long __init
+deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
+		       unsigned long *end_pfn)
+{
+	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
+	unsigned long spfn = *start_pfn, epfn = *end_pfn;
+	unsigned long nr_pages = 0;
+	u64 j = *i;
+
+	/* First we loop through and initialize the page values */
+	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
+		unsigned long t;
+
+		if (mo_pfn <= *start_pfn)
+			break;
+
+		t = min(mo_pfn, *end_pfn);
+		nr_pages += deferred_init_pages(zone, *start_pfn, t);
+
+		if (mo_pfn < *end_pfn) {
+			*start_pfn = mo_pfn;
+			break;
+		}
+	}
+
+	/* Reset values and now loop through freeing pages as needed */
+	swap(j, *i);
+
+	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
+		unsigned long t;
+
+		if (mo_pfn <= spfn)
+			break;
+
+		t = min(mo_pfn, epfn);
+		deferred_free_pages(spfn, t);
+
+		if (mo_pfn <= epfn)
+			break;
+	}
+
+	return nr_pages;
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
+	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
+	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
-	unsigned long nr_pages = 0;
-	unsigned long spfn, epfn, first_init_pfn, flags;
-	int zid;
 	struct zone *zone;
-	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+	int zid;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -1568,22 +1652,20 @@ static int __init deferred_init_memmap(void *data)
 		if (first_init_pfn < zone_end_pfn(zone))
 			break;
 	}
-	first_init_pfn = max(zone->zone_start_pfn, first_init_pfn);
+
+	/* If the zone is empty somebody else may have cleared out the zone */
+	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+						 first_init_pfn))
+		goto zone_empty;
 
 	/*
-	 * Initialize and free pages. We do it in two loops: first we initialize
-	 * struct page, than free to buddy allocator, because while we are
-	 * freeing pages we can access pages that are ahead (computing buddy
-	 * page in __free_one_page()).
+	 * Initialize and free pages in MAX_ORDER sized increments so
+	 * that we can avoid introducing any issues with the buddy
+	 * allocator.
 	 */
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		nr_pages += deferred_init_pages(zone, spfn, epfn);
-	}
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		deferred_free_pages(spfn, epfn);
-	}
+	while (spfn < epfn)
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+zone_empty:
 	pgdat_resize_unlock(pgdat, &flags);
 
 	/* Sanity check that the next zone really is unpopulated */
@@ -1616,9 +1698,9 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 {
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
 	pg_data_t *pgdat = zone->zone_pgdat;
-	unsigned long nr_pages = 0;
-	unsigned long first_init_pfn, spfn, epfn, t, flags;
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
+	unsigned long spfn, epfn, flags;
+	unsigned long nr_pages = 0;
 	u64 i;
 
 	/* Only the last zone may have deferred pages */
@@ -1647,37 +1729,35 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 		return true;
 	}
 
-	first_init_pfn = max(zone->zone_start_pfn, first_deferred_pfn);
-
-	if (first_init_pfn >= pgdat_end_pfn(pgdat)) {
+	/* If the zone is empty somebody else may have cleared out the zone */
+	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+						 first_deferred_pfn)) {
+		pgdat->first_deferred_pfn = ULONG_MAX;
 		pgdat_resize_unlock(pgdat, &flags);
-		return false;
+		return true;
 	}
 
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
+	/*
+	 * Initialize and free pages in MAX_ORDER sized increments so
+	 * that we can avoid introducing any issues with the buddy
+	 * allocator.
+	 */
+	while (spfn < epfn) {
+		/* update our first deferred PFN for this section */
+		first_deferred_pfn = spfn;
+
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
 
-		while (spfn < epfn && nr_pages < nr_pages_needed) {
-			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
-			first_deferred_pfn = min(t, epfn);
-			nr_pages += deferred_init_pages(zone, spfn,
-							first_deferred_pfn);
-			spfn = first_deferred_pfn;
-		}
+		/* We should only stop along section boundaries */
+		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
+			continue;
 
+		/* If our quota has been met we can stop here */
 		if (nr_pages >= nr_pages_needed)
 			break;
 	}
 
-	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
-		spfn = max_t(unsigned long, first_init_pfn, spfn);
-		epfn = min_t(unsigned long, first_deferred_pfn, epfn);
-		deferred_free_pages(spfn, epfn);
-
-		if (first_deferred_pfn == epfn)
-			break;
-	}
-	pgdat->first_deferred_pfn = first_deferred_pfn;
+	pgdat->first_deferred_pfn = spfn;
 	pgdat_resize_unlock(pgdat, &flags);
 
 	return nr_pages > 0;
-- 
2.25.1

