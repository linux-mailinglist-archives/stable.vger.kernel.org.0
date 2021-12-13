Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD2472550
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhLMJnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:20 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:37768 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233163AbhLMJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:45 -0500
X-UUID: 3a67a27478eb489bba3522b22854af66-20211213
X-UUID: 3a67a27478eb489bba3522b22854af66-20211213
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 247211187; Mon, 13 Dec 2021 17:41:40 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 17:41:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 17:41:39 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux@armlinux.org.uk>, <rppt@linux.ibm.com>, <tony@atomide.com>,
        <wangkefeng.wang@huawei.com>, <mark-pk.tsai@mediatek.com>,
        <yj.chiang@mediatek.com>
Subject: [PATCH 5.10 0/5] memblock, arm: fixes for freeing of the memory map
Date:   Mon, 13 Dec 2021 17:41:30 +0800
Message-ID: <20211213094135.1798-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When linux memory is not aligned with page block size and have hole in zone,
the 5.4-lts arm kernel might crash in move_freepages() as Kefen Wang reported in [1].
Backport the upstream fix commits by Mike Rapoport [2] to 5.4 can fix this issue.

And free_unused_memmap() of arm and arm64 are moved to generic mm/memblock in
the below upstream commit, so I applied the first two patches to free_unused_memmap()
in arch/arm/mm/init.c.

(4f5b0c178996 arm, arm64: move free_unused_memmap() to generic mm)

[1] https://lore.kernel.org/lkml/2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com/
[2] https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/#t

Mike Rapoport (5):
  memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
  memblock: align freed memory map on pageblock boundaries with
    SPARSEMEM
  memblock: ensure there is no overflow in memblock_overlaps_region()
  arm: extend pfn_valid to take into account freed memory map alignment
  arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM

 arch/arm/mm/init.c    | 37 +++++++++++++++++++++++++------------
 arch/arm/mm/ioremap.c |  4 +++-
 mm/memblock.c         |  3 ++-
 3 files changed, 30 insertions(+), 14 deletions(-)

-- 
2.18.0

