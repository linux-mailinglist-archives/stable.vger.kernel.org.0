Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A552A3BD02D
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhGFLcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235849AbhGFLa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35D5361DCD;
        Tue,  6 Jul 2021 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570518;
        bh=Ww0TzZHtaUT5LYnKFZ3fmFAe+pRCnhdhpKfT7Z/wy+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvUzzLgGDLhTgoUGJ0gKE87Lagm5PBVN6G5ukkQUDwCjN4eaBJxKnSSMm0p/tomF5
         OPSdxLl+LdO+/69j0+0Pyb5lqBNBGiNEgyk7CrJyLoKbJKr2c2d05RoI0wuUuYvpK+
         gqFi8AEiuOkUKanRg+XKKEh9dSUgFlWiQM4Z3oXMbTu2q2jWRf0YFO1k1xjvkL6nJz
         x/V0B7NBPFZJpLxs4etpUMK6m1/A9b4JshcazufqkFvNT+loVDXDNPzSSu9nuyMWev
         x31UkTCrw3aDC42RPRdsHaLKTp3JV9+qV7+c/5HslYRWEV9rptvou6nY6RCaJjNluC
         rLU8EK4sGDbIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhanglianjie <zhanglianjie@uniontech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 158/160] MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops
Date:   Tue,  6 Jul 2021 07:18:24 -0400
Message-Id: <20210706111827.2060499-158-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhanglianjie <zhanglianjie@uniontech.com>

[ Upstream commit 6817c944430d00f71ccaa9c99ff5b0096aeb7873 ]

The cause of the problem is as follows:
1. when cat /sys/devices/system/memory/memory0/valid_zones,
   test_pages_in_a_zone() will be called.
2. test_pages_in_a_zone() finds the zone according to stat_pfn = 0.
   The smallest pfn of the numa node in the mips architecture is 128,
   and the page corresponding to the previous 0~127 pfn is not
   initialized (page->flags is 0xFFFFFFFF)
3. The nid and zonenum obtained using page_zone(pfn_to_page(0)) are out
   of bounds in the corresponding array,
   &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)],
   access to the out-of-bounds zone member variables appear abnormal,
   resulting in Oops.
Therefore, it is necessary to keep the page between 0 and the minimum
pfn to prevent Oops from appearing.

Signed-off-by: zhanglianjie <zhanglianjie@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/numa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index a8f57bf01285..a791863ed352 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -118,6 +118,9 @@ static void __init node_mem_init(unsigned int node)
 		if (node_end_pfn(0) >= (0xffffffff >> PAGE_SHIFT))
 			memblock_reserve((node_addrspace_offset | 0xfe000000),
 					 32 << 20);
+
+		/* Reserve pfn range 0~node[0]->node_start_pfn */
+		memblock_reserve(0, PAGE_SIZE * start_pfn);
 	}
 }
 
-- 
2.30.2

