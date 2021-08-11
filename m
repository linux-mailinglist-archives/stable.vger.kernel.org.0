Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A63E92DE
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 15:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhHKNmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 09:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhHKNmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 09:42:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0DB760FA0;
        Wed, 11 Aug 2021 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628689313;
        bh=LWKT/XlWW6r43708akQ/YJmJ2WRlCw9TDzGke2pxA10=;
        h=From:To:Cc:Subject:Date:From;
        b=IdVF5moXtsjCSfhcaOQfqS+E3V30eqxPcHmpqJ4EiAFVRKIriapKIuAKWegTm9SbK
         7EMUdGdJxRbJUF89G63se/UwcYktm/jmZMvlaRjVMib76c/BEJKb62/FQiA0Va3Pq9
         HzhFTiAYuTMU4EikLVBQCjQYqwYP0gm3+nsPfAWBq9aL/t1gGLn3gF0BggoCp6Lig0
         w/flfjcW519ige9heLW0rPUmRF42V+S3S1adE8DiwytoOYk3CRhOf3qVHerB4HI8yg
         /eu+YNOiGVIIum41TLd0z2bjaur6nqDyvbkAU6hPs/D7+uoufStEdWXVctFj5P1UHi
         vYTfuLjTckYyg==
From:   Mike Rapoport <rppt@kernel.org>
To:     stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH stable 5.10] mm: make zone_to_nid() and zone_set_nid() available for DISCONTIGMEM
Date:   Wed, 11 Aug 2021 16:41:39 +0300
Message-Id: <20210811134139.5451-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Since the commit ce6ee46e0f39 ("mm/page_alloc: fix memory map
initialization for descending nodes") initialization of the memory map
relies on availability of zone_to_nid() and zone_set_nid methods to link
struct page to a node.

But in 5.10 zone_to_nid() is only defined for NUMA, but not for
DISCONTIGMEM which causes crashes on m68k systems with two memory banks.

For instance on ARAnyM with both ST-RAM and FastRAM atari_defconfig build
produces the following crash:

Unable to handle kernel access at virtual address (ptrval)
Oops: 00000000
Modules linked in:
PC: [<0005fbbc>] bpf_prog_alloc_no_stats+0x5c/0xba
SR: 2200  SP: (ptrval)  a2: 016daa90
d0: 0000000c    d1: 00000200    d2: 00000001    d3: 00000cc0
d4: 016d1f80    d5: 00034da6    a0: 305c2800    a1: 305c2a00
Process swapper (pid: 1, task=(ptrval))
Frame format=7 eff addr=31800000 ssw=0445 faddr=31800000
wb 1 stat/addr/data: 0000 00000000 00000000
wb 2 stat/addr/data: 0000 00000000 00000000
wb 3 stat/addr/data: 00c5 31800000 00000001
push data: 00000000 00000000 00000000 00000000
Stack from 3058fec8:
        00000dc0 00000000 004addc2 3058ff16 0005fc34 00000238 00000000 00000210
        004addc2 3058ff16 00281ae0 00000238 00000000 00000000 004addc2 004bc7ec
        004aea9e 0048b0c0 3058ff16 00460042 004ba4d2 3058ff8c 004ade6a 0000007e
        0000210e 0000007e 00000002 016d1f80 00034da6 000020b4 00000000 004b4764
        004bc7ec 00000000 004b4760 004bc7c0 004b4744 001e4cb2 00010001 016d1fe5
        016d1ff0 004994d2 003e1589 016d1f80 00412b8c 0000007e 00000001 00000001
Call Trace: [<004addc2>] sock_init+0x0/0xaa
 [<0005fc34>] bpf_prog_alloc+0x1a/0x66
 [<004addc2>] sock_init+0x0/0xaa
 [<00281ae0>] bpf_prog_create+0x2e/0x7c
 [<004addc2>] sock_init+0x0/0xaa
 [<004aea9e>] ptp_classifier_init+0x22/0x44
 [<004ade6a>] sock_init+0xa8/0xaa
 [<0000210e>] do_one_initcall+0x5a/0x150
 [<00034da6>] parse_args+0x0/0x208
 [<000020b4>] do_one_initcall+0x0/0x150
 [<001e4cb2>] strcpy+0x0/0x1c
 [<00010001>] stwotoxd+0x5/0x1c
 [<004994d2>] kernel_init_freeable+0x154/0x1a6
 [<001e4cb2>] strcpy+0x0/0x1c
 [<0049951a>] kernel_init_freeable+0x19c/0x1a6
 [<004addc2>] sock_init+0x0/0xaa
 [<00321510>] kernel_init+0x0/0xd8
 [<00321518>] kernel_init+0x8/0xd8
 [<00321510>] kernel_init+0x0/0xd8
 [<00002890>] ret_from_kernel_thread+0xc/0x14

Code: 204b 200b 4cdf 180c 4e75 700c e0aa 3682 <2748> 001c 214b 0140 022b
ffbf 0002 206b 001c 2008 0680 0000 0108 2140 0108 2140
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Using CONFIG_NEED_MULTIPLE_NODES rather than CONFIG_NUMA to guard
definitions of zone_to_nid() and zone_set_nid() fixes the issue.

Reported-by: Mikael Pettersson <mikpelinux@gmail.com>
Fixes: ce6ee46e0f39 ("mm/page_alloc: fix memory map initialization for descending nodes")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Mikael Pettersson <mikpelinux@gmail.com>
---
 include/linux/mmzone.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9d0c454d23cd..63b550403317 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -445,7 +445,7 @@ struct zone {
 	 */
 	long lowmem_reserve[MAX_NR_ZONES];
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	int node;
 #endif
 	struct pglist_data	*zone_pgdat;
@@ -896,7 +896,7 @@ static inline bool populated_zone(struct zone *zone)
 	return zone->present_pages;
 }
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 static inline int zone_to_nid(struct zone *zone)
 {
 	return zone->node;
-- 
2.28.0

