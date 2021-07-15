Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA193CA772
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241051AbhGOSx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239873AbhGOSxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 532E9613D7;
        Thu, 15 Jul 2021 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375036;
        bh=GptNHRxt4NSFEH5/XvLFiuhi1vJsblNqdlsj4pppnKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GF9nD/nUm9gddXEUv0XPHlfH8i5iRpN/7z8Bv3/jhPwEUFs+b5s3wCrLu9YT89Xtr
         1tQR39A1IVIc1Wy0Ysdfic+WX3L5YtQrkypqOFszNA5RN5iIktLRM1L1QXoTjT6Vds
         07/ajePffoiK5skGe+UTKMZMiA5zWwWkzh6rZC0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhanglianjie <zhanglianjie@uniontech.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/215] MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops
Date:   Thu, 15 Jul 2021 20:38:23 +0200
Message-Id: <20210715182622.760276781@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index cf9459f79f9b..e4c461df3ee6 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -182,6 +182,9 @@ static void __init node_mem_init(unsigned int node)
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



