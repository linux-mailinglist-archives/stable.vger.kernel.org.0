Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22264421F
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388614AbfFMQTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731092AbfFMIjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:39:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FB520851;
        Thu, 13 Jun 2019 08:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415191;
        bh=Oj9lC4E4fNDIiLHZLgNIyB1OHsCLkEcjAQZIg2Zh/UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSvk08vYCjY+X83ni7p+IHZs53C7tmmJK/kXb1kLOJKrMqt0pPrQUkJfv8FnTcrdc
         KNQIhB2e5YtE74a0erjZNUyttLe5k1fJvonchxvldgdfOqvMMucOHdPuGbnQoe+SdW
         yNFqFCzyr9rIcKbc1T5D7oZQrVBW9i5G97uim3R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linxu Fang <fanglinxu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/118] mem-hotplug: fix node spanned pages when we have a node with only ZONE_MOVABLE
Date:   Thu, 13 Jun 2019 10:32:27 +0200
Message-Id: <20190613075644.223755562@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 299c83dce9ea3a79bb4b5511d2cb996b6b8e5111 ]

342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option") and
later patches rewrote the calculation of node spanned pages.

e506b99696a2 ("mem-hotplug: fix node spanned pages when we have a movable
node"), but the current code still has problems,

When we have a node with only zone_movable and the node id is not zero,
the size of node spanned pages is double added.

That's because we have an empty normal zone, and zone_start_pfn or
zone_end_pfn is not between arch_zone_lowest_possible_pfn and
arch_zone_highest_possible_pfn, so we need to use clamp to constrain the
range just like the commit <96e907d13602> (bootmem: Reimplement
__absent_pages_in_range() using for_each_mem_pfn_range()).

e.g.
Zone ranges:
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
  Normal   [mem 0x0000000100000000-0x000000023fffffff]
Movable zone start for each node
  Node 0: 0x0000000100000000
  Node 1: 0x0000000140000000
Early memory node ranges
  node   0: [mem 0x0000000000001000-0x000000000009efff]
  node   0: [mem 0x0000000000100000-0x00000000bffdffff]
  node   0: [mem 0x0000000100000000-0x000000013fffffff]
  node   1: [mem 0x0000000140000000-0x000000023fffffff]

node 0 DMA	spanned:0xfff   present:0xf9e   absent:0x61
node 0 DMA32	spanned:0xff000 present:0xbefe0	absent:0x40020
node 0 Normal	spanned:0	present:0	absent:0
node 0 Movable	spanned:0x40000 present:0x40000 absent:0
On node 0 totalpages(node_present_pages): 1048446
node_spanned_pages:1310719
node 1 DMA	spanned:0	    present:0		absent:0
node 1 DMA32	spanned:0	    present:0		absent:0
node 1 Normal	spanned:0x100000    present:0x100000	absent:0
node 1 Movable	spanned:0x100000    present:0x100000	absent:0
On node 1 totalpages(node_present_pages): 2097152
node_spanned_pages:2097152
Memory: 6967796K/12582392K available (16388K kernel code, 3686K rwdata,
4468K rodata, 2160K init, 10444K bss, 5614596K reserved, 0K
cma-reserved)

It shows that the current memory of node 1 is double added.
After this patch, the problem is fixed.

node 0 DMA	spanned:0xfff   present:0xf9e   absent:0x61
node 0 DMA32	spanned:0xff000 present:0xbefe0	absent:0x40020
node 0 Normal	spanned:0	present:0	absent:0
node 0 Movable	spanned:0x40000 present:0x40000 absent:0
On node 0 totalpages(node_present_pages): 1048446
node_spanned_pages:1310719
node 1 DMA	spanned:0	    present:0		absent:0
node 1 DMA32	spanned:0	    present:0		absent:0
node 1 Normal	spanned:0	    present:0		absent:0
node 1 Movable	spanned:0x100000    present:0x100000	absent:0
On node 1 totalpages(node_present_pages): 1048576
node_spanned_pages:1048576
memory: 6967796K/8388088K available (16388K kernel code, 3686K rwdata,
4468K rodata, 2160K init, 10444K bss, 1420292K reserved, 0K
cma-reserved)

Link: http://lkml.kernel.org/r/1554178276-10372-1-git-send-email-fanglinxu@huawei.com
Signed-off-by: Linxu Fang <fanglinxu@huawei.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8e6932a140b8..2d04bd2e1ced 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5937,13 +5937,15 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long *zone_end_pfn,
 					unsigned long *ignored)
 {
+	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
+	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
 	/* Get the start and end of the zone */
-	*zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
-	*zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
+	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
+	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 				node_start_pfn, node_end_pfn,
 				zone_start_pfn, zone_end_pfn);
-- 
2.20.1



