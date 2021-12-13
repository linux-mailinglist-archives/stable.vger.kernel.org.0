Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB3472552
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbhLMJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:23 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33780 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234929AbhLMJlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:47 -0500
X-UUID: c1913f5a5384476e88f193dc0fca9cd0-20211213
X-UUID: c1913f5a5384476e88f193dc0fca9cd0-20211213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 855756119; Mon, 13 Dec 2021 17:41:44 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 17:41:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 17:41:43 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.10 4/5] arm: extend pfn_valid to take into account freed memory map alignment
Date:   Mon, 13 Dec 2021 17:41:34 +0800
Message-ID: <20211213094135.1798-5-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211213094135.1798-1-mark-pk.tsai@mediatek.com>
References: <20211213094135.1798-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit a4d5613c4dc6d413e0733e37db9d116a2a36b9f3 ]

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
index 7fd049cbc5b0..15af4dd52426 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -125,11 +125,22 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 int pfn_valid(unsigned long pfn)
 {
 	phys_addr_t addr = __pfn_to_phys(pfn);
+	unsigned long pageblock_size = PAGE_SIZE * pageblock_nr_pages;
 
 	if (__phys_to_pfn(addr) != pfn)
 		return 0;
 
-	return memblock_is_map_memory(addr);
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

