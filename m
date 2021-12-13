Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E28472350
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhLMI51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:57:27 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:44392 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233396AbhLMI5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:57:24 -0500
X-UUID: 1337d85adb1e49c39142813cd0d51fa6-20211213
X-UUID: 1337d85adb1e49c39142813cd0d51fa6-20211213
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 554406322; Mon, 13 Dec 2021 16:57:20 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 13 Dec 2021 16:57:18 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 16:57:18 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.4 3/5] memblock: ensure there is no overflow in memblock_overlaps_region()
Date:   Mon, 13 Dec 2021 16:57:08 +0800
Message-ID: <20211213085710.28962-4-mark-pk.tsai@mediatek.com>
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

commit 023accf5cdc1e504a9b04187ec23ff156fe53d90 upstream.

There maybe an overflow in memblock_overlaps_region() if it is called with
base and size such that

	base + size > PHYS_ADDR_MAX

Make sure that memblock_overlaps_region() caps the size to prevent such
overflow and remove now duplicated call to memblock_cap_size() from
memblock_is_region_reserved().

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 mm/memblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 4de2af293f47..e13003ed6ee7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -164,6 +164,8 @@ bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
 {
 	unsigned long i;
 
+	memblock_cap_size(base, &size);
+
 	for (i = 0; i < type->cnt; i++)
 		if (memblock_addrs_overlap(base, size, type->regions[i].base,
 					   type->regions[i].size))
@@ -1764,7 +1766,6 @@ bool __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t siz
  */
 bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
-	memblock_cap_size(base, &size);
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
-- 
2.18.0

