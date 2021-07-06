Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FC3BCEB8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhGFL1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234334AbhGFLYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50EBB61C95;
        Tue,  6 Jul 2021 11:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570300;
        bh=lvvCD7LTgbBk2JIxI9izZinDD1lKzbLj21Xxw1OsM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZ1tmjefZ/BfQw5Txy6t8Si1y6kNLNvrUpzWjez8Sqxa+5GDOp1gsuoNOinpQiaDG
         oiZJLUauVUjvrFJYs9sMLMR6gYt4HbuDnHqnrU9uN3A6w0R/W4p9oZ3bUXRgYEK+mg
         5y6uPntzCLHMW10fFClfS3SydnEyZKqb23BjkQtt21+qSfJaDAwg1z/bCnshXyKUSe
         magCO7XEfEDFvRAfbAGwiPejyw9whOoS1Lz+Ww6EVGWupYrYZAfxomIHMmbEQgEGdp
         VNC1rYSM+CRlfegxPLvO6QHHG0rI3Z0Rm5lxOWszqDTJyYItFABLVA+hjnxwCV7cwI
         yQyJtIi8Gv08A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhanglianjie <zhanglianjie@uniontech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 187/189] MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops
Date:   Tue,  6 Jul 2021 07:14:07 -0400
Message-Id: <20210706111409.2058071-187-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index fa9b4a487a47..e8e3e48c5333 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -129,6 +129,9 @@ static void __init node_mem_init(unsigned int node)
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

