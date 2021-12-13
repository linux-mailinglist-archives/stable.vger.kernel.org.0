Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB9472553
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhLMJnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33858 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233165AbhLMJlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:49 -0500
X-UUID: 5ae59474788643ddbbfff08c069c2b61-20211213
X-UUID: 5ae59474788643ddbbfff08c069c2b61-20211213
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 256012185; Mon, 13 Dec 2021 17:41:44 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 13 Dec 2021 17:41:42 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 17:41:42 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.10 2/5] memblock: align freed memory map on pageblock boundaries with SPARSEMEM
Date:   Mon, 13 Dec 2021 17:41:32 +0800
Message-ID: <20211213094135.1798-3-mark-pk.tsai@mediatek.com>
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

[ Upstream commit f921f53e089a12a192808ac4319f28727b35dc0f ]

When CONFIG_SPARSEMEM=y the ranges of the memory map that are freed are not
aligned to the pageblock boundaries which breaks assumptions about
homogeneity of the memory map throughout core mm code.

Make sure that the freed memory map is always aligned on pageblock
boundaries regardless of the memory model selection.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
[backport upstream modification in mm/memblock.c to arch/arm/mm/init.c]
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 arch/arm/mm/init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8440b6027598..7fd049cbc5b0 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -313,14 +313,14 @@ static void __init free_unused_memmap(void)
 		 */
 		start = min(start,
 				 ALIGN(prev_end, PAGES_PER_SECTION));
-#else
+#endif
 		/*
 		 * Align down here since many operations in VM subsystem
 		 * presume that there are no holes in the memory map inside
 		 * a pageblock
 		 */
 		start = round_down(start, pageblock_nr_pages);
-#endif
+
 		/*
 		 * If we had a previous bank, and there is a space
 		 * between the current bank and the previous, free it.
@@ -337,9 +337,11 @@ static void __init free_unused_memmap(void)
 	}
 
 #ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
+		prev_end = ALIGN(end, pageblock_nr_pages);
 		free_memmap(prev_end,
 			    ALIGN(prev_end, PAGES_PER_SECTION));
+	}
 #endif
 }
 
-- 
2.18.0

