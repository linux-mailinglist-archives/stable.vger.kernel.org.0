Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11289261DA8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgIHTkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgIHPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:54:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193AD22527;
        Tue,  8 Sep 2020 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579548;
        bh=8w86BAGh2NaIATIPhTQJxE5p6gV6QgJwp/4rjGabC8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeghQupDFZFB/UDQRSiaZfP4TpjqeWCrguV9wdtKkmVaRwq1QsRdxYrAfjIxvmgFj
         XFITZO+dtz+cICdUzUnsmWzYNyzmM4PvkbYa8WOOyok9MDiQLxNj15d4DrCrhAqlPb
         NloDsKegtgPi8xREJxyudIJQ8ghwSxz+riYmVHts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.8 124/186] arc: fix memory initialization for systems with two memory banks
Date:   Tue,  8 Sep 2020 17:24:26 +0200
Message-Id: <20200908152247.645093657@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 4af22ded0ecf23adea1b26ea264c53f9f1cfc310 upstream.

Rework of memory map initialization broke initialization of ARC systems
with two memory banks. Before these changes, memblock was not aware of
nodes configuration and the memory map was always allocated from the
"lowmem" bank. After the addition of node information to memblock, the core
mm attempts to allocate the memory map for the "highmem" bank from its
node. The access to this memory using __va() fails because it can be only
accessed using kmap.

Anther problem that was uncovered is that {min,max}_high_pfn are calculated
from u64 high_mem_start variable which prevents truncation to 32-bit
physical address and the PFN values are above the node and zone boundaries.

Use phys_addr_t type for high_mem_start and high_mem_size to ensure
correspondence between PFNs and highmem zone boundaries and reserve the
entire highmem bank until mem_init() to avoid accesses to it before highmem
is enabled.

To test this:
1. Enable HIGHMEM in ARC config
2. Enable 2 memory banks in haps_hs.dts (uncomment the 2nd bank)

Fixes: 51930df5801e ("mm: free_area_init: allow defining max_zone_pfn in descending order")
Cc: stable@vger.kernel.org   [5.8]
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
[vgupta: added instructions to test highmem]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/mm/init.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -27,8 +27,8 @@ static unsigned long low_mem_sz;
 
 #ifdef CONFIG_HIGHMEM
 static unsigned long min_high_pfn, max_high_pfn;
-static u64 high_mem_start;
-static u64 high_mem_sz;
+static phys_addr_t high_mem_start;
+static phys_addr_t high_mem_sz;
 #endif
 
 #ifdef CONFIG_DISCONTIGMEM
@@ -70,6 +70,7 @@ void __init early_init_dt_add_memory_arc
 		high_mem_sz = size;
 		in_use = 1;
 		memblock_add_node(base, size, 1);
+		memblock_reserve(base, size);
 #endif
 	}
 
@@ -158,7 +159,7 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
+	max_zone_pfn[ZONE_HIGHMEM] = min_low_pfn;
 
 	high_memory = (void *)(min_high_pfn << PAGE_SHIFT);
 	kmap_init();
@@ -167,22 +168,26 @@ void __init setup_arch_memory(void)
 	free_area_init(max_zone_pfn);
 }
 
-/*
- * mem_init - initializes memory
- *
- * Frees up bootmem
- * Calculates and displays memory available/used
- */
-void __init mem_init(void)
+static void __init highmem_init(void)
 {
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
 
-	reset_all_zones_managed_pages();
+	memblock_free(high_mem_start, high_mem_sz);
 	for (tmp = min_high_pfn; tmp < max_high_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
 #endif
+}
 
+/*
+ * mem_init - initializes memory
+ *
+ * Frees up bootmem
+ * Calculates and displays memory available/used
+ */
+void __init mem_init(void)
+{
 	memblock_free_all();
+	highmem_init();
 	mem_init_print_info(NULL);
 }


