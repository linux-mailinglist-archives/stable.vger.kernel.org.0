Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8753CAAD5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243326AbhGOTPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244277AbhGOTOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FC7A613E5;
        Thu, 15 Jul 2021 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376208;
        bh=lvvCD7LTgbBk2JIxI9izZinDD1lKzbLj21Xxw1OsM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VSE1n6LxX/UgoWcw5acIwp8z6qymz2BJZkvo/29YwQcnZXoOHMp2OZ+vrEv7hTuH
         IrRUnx4tqhcfkIYp0lvBZItsTceaSd31yVGmWHycrYpQI/7V9ryqEPBVLwgEa3+ah+
         Vl8BW3i3Q0RF6RtEa4WE6xS+VORCjUW8tFNzipxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhanglianjie <zhanglianjie@uniontech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 174/266] MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops
Date:   Thu, 15 Jul 2021 20:38:49 +0200
Message-Id: <20210715182642.808286801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



