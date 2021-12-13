Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1EA472349
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhLMI5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:57:20 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:44200 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233396AbhLMI5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:57:18 -0500
X-UUID: 1c7e8d82c7184c16b047ba8437b2a428-20211213
X-UUID: 1c7e8d82c7184c16b047ba8437b2a428-20211213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 915342845; Mon, 13 Dec 2021 16:57:16 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 16:57:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 16:57:14 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.4 1/5] memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
Date:   Mon, 13 Dec 2021 16:57:06 +0800
Message-ID: <20211213085710.28962-2-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211213085710.28962-1-mark-pk.tsai@mediatek.com>
References: <20211213085710.28962-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit e2a86800d58639b3acde7eaeb9eb393dca066e08 upstream.

The code that frees unused memory map uses rounds start and end of the
holes that are freed to MAX_ORDER_NR_PAGES to preserve continuity of the
memory map for MAX_ORDER regions.

Lots of core memory management functionality relies on homogeneity of the
memory map within each pageblock which size may differ from MAX_ORDER in
certain configurations.

Although currently, for the architectures that use free_unused_memmap(),
pageblock_order and MAX_ORDER are equivalent, it is cleaner to have common
notation thought mm code.

Replace MAX_ORDER_NR_PAGES with pageblock_nr_pages and update the comments
to make it more clear why the alignment to pageblock boundaries is
required.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
[backport upstream modification in mm/memblock.c to arch/arm/mm/init.c]
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 arch/arm/mm/init.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 7ea4d3b43444..6905dd8bc03f 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -381,11 +381,11 @@ static void __init free_unused_memmap(void)
 				 ALIGN(prev_end, PAGES_PER_SECTION));
 #else
 		/*
-		 * Align down here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank start aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align down here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
-		start = round_down(start, MAX_ORDER_NR_PAGES);
+		start = round_down(start, pageblock_nr_pages);
 #endif
 		/*
 		 * If we had a previous bank, and there is a space
@@ -395,12 +395,12 @@ static void __init free_unused_memmap(void)
 			free_memmap(prev_end, start);
 
 		/*
-		 * Align up here since the VM subsystem insists that the
-		 * memmap entries are valid from the bank end aligned to
-		 * MAX_ORDER_NR_PAGES.
+		 * Align up here since many operations in VM subsystem
+		 * presume that there are no holes in the memory map inside
+		 * a pageblock
 		 */
 		prev_end = ALIGN(memblock_region_memory_end_pfn(reg),
-				 MAX_ORDER_NR_PAGES);
+				 pageblock_nr_pages);
 	}
 
 #ifdef CONFIG_SPARSEMEM
-- 
2.18.0

