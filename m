Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C292547234C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhLMI5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:57:22 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:44200 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229733AbhLMI5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:57:20 -0500
X-UUID: c6bfc4140b634c7fbbce11598d059603-20211213
X-UUID: c6bfc4140b634c7fbbce11598d059603-20211213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1918819261; Mon, 13 Dec 2021 16:57:18 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 16:57:17 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Dec
 2021 16:57:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 16:57:16 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.4 2/5] memblock: align freed memory map on pageblock boundaries with SPARSEMEM
Date:   Mon, 13 Dec 2021 16:57:07 +0800
Message-ID: <20211213085710.28962-3-mark-pk.tsai@mediatek.com>
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

commit f921f53e089a12a192808ac4319f28727b35dc0f upstream.

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
index 6905dd8bc03f..c0e70e643f92 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -379,14 +379,14 @@ static void __init free_unused_memmap(void)
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
@@ -404,9 +404,11 @@ static void __init free_unused_memmap(void)
 	}
 
 #ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
+		prev_end = ALIGN(prev_end, pageblock_nr_pages);
 		free_memmap(prev_end,
 			    ALIGN(prev_end, PAGES_PER_SECTION));
+	}
 #endif
 }
 
-- 
2.18.0

