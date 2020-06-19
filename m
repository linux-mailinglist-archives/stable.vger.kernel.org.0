Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A382009EE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgFSNYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731869AbgFSNYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:31 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15629C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:31 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id p15so4404567qvr.9
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8y/YllEdEGxfASabN0Utx6EvcdyUqsP0NNVjLEHWBv8=;
        b=lCY6XvGTLkeQiMXik5Xrmi4R1kOY2n3RlRgIxHr0J/yRCj/ep6FnddWJ3N+kQyMNp+
         DgBmGnPppXrijRP5dAk+7US6xWU9AmZXcDC1y4g+hf1wVJetRIA7CfZ4p3Afi/wGCfno
         qd4q0md5MtgVhhpYaz1s5FukZU7IrmdFN8P+U/B7qkltw2Yt38hxs9bEiZ30vSP4PEZY
         1whCkbzCJMSBk2fFxHncP2UvptWJlvBvYGJYvwc3deq7+kI8yp2BQwktCQkVUSBsT+Va
         aytJho67GWJ7V5kioam2baQ0tL2XJWeNF0d4KQT1XGfw3gnOUZJ6vts6QO+xR/IkIds2
         Dqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8y/YllEdEGxfASabN0Utx6EvcdyUqsP0NNVjLEHWBv8=;
        b=qqHw9W3xwOAM0tbsdtl5hZwZgNjLwrDrP3EWwUSywHDza7X/s0myAg5/OwnSZ0cnnR
         j9OJjBdh4DxjyGebfpNJ46t1ZZ8bKk5UKMs5DEj8C2B9F0fZIZ2zFA7tujUPLU8IogAh
         HTy22KND3aFJhR/WVbwgZ2z1HMxnIyLr6Irxc8NjgSpiZwCMYATXoMH1axFWEq8ZA5OM
         Ue2U2ZKjByn7XXFMblu2AgMVut8gvcJz1d4iWxu1G/gN536nmYaWjbQybt2/2udFG1oz
         I8TiGuoNg2ac5qJ703gXkE3WhOWtJMK6C/54dPplbl1lIM4nDfGhW3S7x+rp1qS6f8rC
         SXAQ==
X-Gm-Message-State: AOAM53111qU4X65gKsS3XozcTFqvyzS7HCtyCJHxPklL32zxDPLWqwg+
        dhygKkCIkmMUYyKvFd8gottwWg+n5IM=
X-Google-Smtp-Source: ABdhPJzQi5zGA98+gotHBhhQKcdRjygj/9pn0ShuPx/a/fcfby4cwXXOO2TsN2LiqagpAhwAWgrjtQ==
X-Received: by 2002:a0c:fa47:: with SMTP id k7mr8400094qvo.132.1592573069945;
        Fri, 19 Jun 2020 06:24:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:29 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 2/7] mm: implement new zone specific memblock iterator
Date:   Fri, 19 Jun 2020 09:24:20 -0400
Message-Id: <20200619132425.425063-2-pasha.tatashin@soleen.com>
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

commit 837566e7e08e3f89444166444836a8a49b9f9322 upstream.

Introduce a new iterator for_each_free_mem_pfn_range_in_zone.

This iterator will take care of making sure a given memory range provided
is in fact contained within a zone.  It takes are of all the bounds
checking we were doing in deferred_grow_zone, and deferred_init_memmap.
In addition it should help to speed up the search a bit by iterating until
the end of a range is greater than the start of the zone pfn range, and
will exit completely if the start is beyond the end of the zone.

Link: http://lkml.kernel.org/r/20190405221225.12227.22573.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <yi.z.zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/memblock.h | 25 ++++++++++++++++
 mm/memblock.c            | 64 ++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c          | 31 ++++++++-----------
 3 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 2acdd046df2d..76b3d92b096e 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -232,6 +232,31 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
+				  unsigned long *out_spfn,
+				  unsigned long *out_epfn);
+/**
+ * for_each_free_mem_range_in_zone - iterate through zone specific free
+ * memblock areas
+ * @i: u64 used as loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in a specific
+ * zone. Available once memblock and an empty zone is initialized. The main
+ * assumption is that the zone start, end, and pgdat have been associated.
+ * This way we can use the zone to determine NUMA node, and if a given part
+ * of the memblock is valid for the zone.
+ */
+#define for_each_free_mem_pfn_range_in_zone(i, zone, p_start, p_end)	\
+	for (i = 0,							\
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end);	\
+	     i != U64_MAX;					\
+	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
+
 /**
  * for_each_free_mem_range - iterate through free memblock areas
  * @i: u64 used as loop variable
diff --git a/mm/memblock.c b/mm/memblock.c
index bb4e32c6b19e..65e40a97f99e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1230,6 +1230,70 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+/**
+ * __next_mem_pfn_range_in_zone - iterator for for_each_*_range_in_zone()
+ *
+ * @idx: pointer to u64 loop variable
+ * @zone: zone in which all of the memory blocks reside
+ * @out_spfn: ptr to ulong for start pfn of the range, can be %NULL
+ * @out_epfn: ptr to ulong for end pfn of the range, can be %NULL
+ *
+ * This function is meant to be a zone/pfn specific wrapper for the
+ * for_each_mem_range type iterators. Specifically they are used in the
+ * deferred memory init routines and as such we were duplicating much of
+ * this logic throughout the code. So instead of having it in multiple
+ * locations it seemed like it would make more sense to centralize this to
+ * one new iterator that does everything they need.
+ */
+void __init_memblock
+__next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
+			     unsigned long *out_spfn, unsigned long *out_epfn)
+{
+	int zone_nid = zone_to_nid(zone);
+	phys_addr_t spa, epa;
+	int nid;
+
+	__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
+			 &memblock.memory, &memblock.reserved,
+			 &spa, &epa, &nid);
+
+	while (*idx != U64_MAX) {
+		unsigned long epfn = PFN_DOWN(epa);
+		unsigned long spfn = PFN_UP(spa);
+
+		/*
+		 * Verify the end is at least past the start of the zone and
+		 * that we have at least one PFN to initialize.
+		 */
+		if (zone->zone_start_pfn < epfn && spfn < epfn) {
+			/* if we went too far just stop searching */
+			if (zone_end_pfn(zone) <= spfn) {
+				*idx = U64_MAX;
+				break;
+			}
+
+			if (out_spfn)
+				*out_spfn = max(zone->zone_start_pfn, spfn);
+			if (out_epfn)
+				*out_epfn = min(zone_end_pfn(zone), epfn);
+
+			return;
+		}
+
+		__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
+				 &memblock.memory, &memblock.reserved,
+				 &spa, &epa, &nid);
+	}
+
+	/* signal end of iteration */
+	if (out_spfn)
+		*out_spfn = ULONG_MAX;
+	if (out_epfn)
+		*out_epfn = 0;
+}
+
+#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 static phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c86a117acb5b..8eb3c44c3c13 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1537,11 +1537,9 @@ static unsigned long  __init deferred_init_pages(struct zone *zone,
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
-	int nid = pgdat->node_id;
 	unsigned long start = jiffies;
 	unsigned long nr_pages = 0;
 	unsigned long spfn, epfn, first_init_pfn, flags;
-	phys_addr_t spa, epa;
 	int zid;
 	struct zone *zone;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
@@ -1578,14 +1576,12 @@ static int __init deferred_init_memmap(void *data)
 	 * freeing pages we can access pages that are ahead (computing buddy
 	 * page in __free_one_page()).
 	 */
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 		nr_pages += deferred_init_pages(zone, spfn, epfn);
 	}
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 		deferred_free_pages(spfn, epfn);
 	}
 	pgdat_resize_unlock(pgdat, &flags);
@@ -1593,8 +1589,8 @@ static int __init deferred_init_memmap(void *data)
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
-	pr_info("node %d initialised, %lu pages in %ums\n", nid, nr_pages,
-					jiffies_to_msecs(jiffies - start));
+	pr_info("node %d initialised, %lu pages in %ums\n",
+		pgdat->node_id,	nr_pages, jiffies_to_msecs(jiffies - start));
 
 	pgdat_init_report_one_done();
 	return 0;
@@ -1618,13 +1614,11 @@ static int __init deferred_init_memmap(void *data)
 static noinline bool __init
 deferred_grow_zone(struct zone *zone, unsigned int order)
 {
-	int nid = zone_to_nid(zone);
-	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
+	pg_data_t *pgdat = zone->zone_pgdat;
 	unsigned long nr_pages = 0;
 	unsigned long first_init_pfn, spfn, epfn, t, flags;
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
-	phys_addr_t spa, epa;
 	u64 i;
 
 	/* Only the last zone may have deferred pages */
@@ -1660,9 +1654,8 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 		return false;
 	}
 
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
 
 		while (spfn < epfn && nr_pages < nr_pages_needed) {
 			t = ALIGN(spfn + PAGES_PER_SECTION, PAGES_PER_SECTION);
@@ -1676,9 +1669,9 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 			break;
 	}
 
-	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
-		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
-		epfn = min_t(unsigned long, first_deferred_pfn, PFN_DOWN(epa));
+	for_each_free_mem_pfn_range_in_zone(i, zone, &spfn, &epfn) {
+		spfn = max_t(unsigned long, first_init_pfn, spfn);
+		epfn = min_t(unsigned long, first_deferred_pfn, epfn);
 		deferred_free_pages(spfn, epfn);
 
 		if (first_deferred_pfn == epfn)
-- 
2.25.1

