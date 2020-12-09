Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDC02D4D0E
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 22:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388097AbgLIVoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 16:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgLIVn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 16:43:56 -0500
From:   Mike Rapoport <rppt@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm: memblock: enforce overlap of memory.memblock and memory.reserved
Date:   Wed,  9 Dec 2020 23:43:03 +0200
Message-Id: <20201209214304.6812-2-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201209214304.6812-1-rppt@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

memblock does not require that the reserved memory ranges will be a subset
of memblock.memory.

As the result there maybe reserved pages that are not in the range of any
zone or node because zone and node boundaries are detected based on
memblock.memory and pages that only present in memblock.reserved are not
taken into account during zone/node size detection.

Make sure that all ranges in memblock.reserved are added to memblock.memory
before calculating node and zone boundaries.

Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 24 ++++++++++++++++++++++++
 mm/page_alloc.c          |  7 +++++++
 3 files changed, 32 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index ef131255cedc..e64dae2dd1ce 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -120,6 +120,7 @@ int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 unsigned long memblock_free_all(void);
 void reset_node_managed_pages(pg_data_t *pgdat);
 void reset_all_zones_managed_pages(void);
+void memblock_enforce_memory_reserved_overlap(void);
 
 /* Low level functions */
 void __next_mem_range(u64 *idx, int nid, enum memblock_flags flags,
diff --git a/mm/memblock.c b/mm/memblock.c
index b68ee86788af..9277aca642b2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1857,6 +1857,30 @@ void __init_memblock memblock_trim_memory(phys_addr_t align)
 	}
 }
 
+/**
+ * memblock_enforce_memory_reserved_overlap - make sure every range in
+ * @memblock.reserved is covered by @memblock.memory
+ *
+ * The data in @memblock.memory is used to detect zone and node boundaries
+ * during initialization of the memory map and the page allocator. Make
+ * sure that every memory range present in @memblock.reserved is also added
+ * to @memblock.memory even if the architecture specific memory
+ * initialization failed to do so
+ */
+void __init memblock_enforce_memory_reserved_overlap(void)
+{
+	phys_addr_t start, end;
+	int nid;
+	u64 i;
+
+	__for_each_mem_range(i, &memblock.reserved, &memblock.memory,
+			     NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, &nid) {
+		pr_warn("memblock: reserved range [%pa-%pa] is not in memory\n",
+			&start, &end);
+		memblock_add_node(start, (end - start), nid);
+	}
+}
+
 void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
 	memblock.current_limit = limit;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eaa227a479e4..dbc57dbbacd8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7436,6 +7436,13 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
+	/*
+	 * Some architectures (e.g. x86) have reserved pages outside of
+	 * memblock.memory. Make sure these pages are taken into account
+	 * when detecting zone and node boundaries
+	 */
+	memblock_enforce_memory_reserved_overlap();
+
 	start_pfn = find_min_pfn_with_active_regions();
 	descending = arch_has_descending_max_zone_pfns();
 
-- 
2.28.0

