Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B006747234F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhLMI50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:57:26 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:46392 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233443AbhLMI5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:57:25 -0500
X-UUID: aa3e7304b7e74dfe86d2c5b143814ee6-20211213
X-UUID: aa3e7304b7e74dfe86d2c5b143814ee6-20211213
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1386785207; Mon, 13 Dec 2021 16:57:21 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 13 Dec 2021 16:57:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 16:57:20 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.4 4/5] arm: extend pfn_valid to take into account freed memory map alignment
Date:   Mon, 13 Dec 2021 16:57:09 +0800
Message-ID: <20211213085710.28962-5-mark-pk.tsai@mediatek.com>
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

commit a4d5613c4dc6d413e0733e37db9d116a2a36b9f3 upstream.

When unused memory map is freed the preserved part of the memory map is
extended to match pageblock boundaries because lots of core mm
functionality relies on homogeneity of the memory map within pageblock
boundaries.

Since pfn_valid() is used to check whether there is a valid memory map
entry for a PFN, make it return true also for PFNs that have memory map
entries even if there is no actual memory populated there.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 arch/arm/mm/init.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c0e70e643f92..c30b4b2f8de9 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -176,11 +176,22 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 int pfn_valid(unsigned long pfn)
 {
 	phys_addr_t addr = __pfn_to_phys(pfn);
+	unsigned long pageblock_size = PAGE_SIZE * pageblock_nr_pages;
 
 	if (__phys_to_pfn(addr) != pfn)
 		return 0;
 
-	return memblock_is_map_memory(__pfn_to_phys(pfn));
+	/*
+	 * If address less than pageblock_size bytes away from a present
+	 * memory chunk there still will be a memory map entry for it
+	 * because we round freed memory map to the pageblock boundaries.
+	 */
+	if (memblock_overlaps_region(&memblock.memory,
+				     ALIGN_DOWN(addr, pageblock_size),
+				     pageblock_size))
+		return 1;
+
+	return 0;
 }
 EXPORT_SYMBOL(pfn_valid);
 #endif
-- 
2.18.0

