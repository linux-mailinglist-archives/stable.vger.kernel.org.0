Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2009E29B8F2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802114AbgJ0Ppj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801070AbgJ0Pii (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:38:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0297B2225E;
        Tue, 27 Oct 2020 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813115;
        bh=jINZ05+7S+/hECbiMinuJvF6bUFd5uXWWpLI95jG/yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcq5Br79H8ZoRyAsi2WMAyOdf17CW8AG17O9flFDLqapU/zvqQ5FKLm9NDtGwzjPd
         R19vkEa2e0xedIUX6zeFYNg42ZkxofoUI6KXIkpdbrRB2kAuwQqUCzmsqNyOTsZ477
         HdYQ1oLIcP1440WznjUAsVRFD5WQFHMotZGivL8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Cheloha <cheloha@linux.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 412/757] pseries/drmem: dont cache node id in drmem_lmb struct
Date:   Tue, 27 Oct 2020 14:51:02 +0100
Message-Id: <20201027135509.895436145@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Cheloha <cheloha@linux.ibm.com>

[ Upstream commit e5e179aa3a39c818db8fbc2dce8d2cd24adaf657 ]

At memory hot-remove time we can retrieve an LMB's nid from its
corresponding memory_block.  There is no need to store the nid
in multiple locations.

Note that lmb_to_memblock() uses find_memory_block() to get the
corresponding memory_block.  As find_memory_block() runs in sub-linear
time this approach is negligibly slower than what we do at present.

In exchange for this lookup at hot-remove time we no longer need to
call memory_add_physaddr_to_nid() during drmem_init() for each LMB.
On powerpc, memory_add_physaddr_to_nid() is a linear search, so this
spares us an O(n^2) initialization during boot.

On systems with many LMBs that initialization overhead is palpable and
disruptive.  For example, on a box with 249854 LMBs we're seeing
drmem_init() take upwards of 30 seconds to complete:

[   53.721639] drmem: initializing drmem v2
[   80.604346] watchdog: BUG: soft lockup - CPU#65 stuck for 23s! [swapper/0:1]
[   80.604377] Modules linked in:
[   80.604389] CPU: 65 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc2+ #4
[   80.604397] NIP:  c0000000000a4980 LR: c0000000000a4940 CTR: 0000000000000000
[   80.604407] REGS: c0002dbff8493830 TRAP: 0901   Not tainted  (5.6.0-rc2+)
[   80.604412] MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 44000248  XER: 0000000d
[   80.604431] CFAR: c0000000000a4a38 IRQMASK: 0
[   80.604431] GPR00: c0000000000a4940 c0002dbff8493ac0 c000000001904400 c0003cfffffede30
[   80.604431] GPR04: 0000000000000000 c000000000f4095a 000000000000002f 0000000010000000
[   80.604431] GPR08: c0000bf7ecdb7fb8 c0000bf7ecc2d3c8 0000000000000008 c00c0002fdfb2001
[   80.604431] GPR12: 0000000000000000 c00000001e8ec200
[   80.604477] NIP [c0000000000a4980] hot_add_scn_to_nid+0xa0/0x3e0
[   80.604486] LR [c0000000000a4940] hot_add_scn_to_nid+0x60/0x3e0
[   80.604492] Call Trace:
[   80.604498] [c0002dbff8493ac0] [c0000000000a4940] hot_add_scn_to_nid+0x60/0x3e0 (unreliable)
[   80.604509] [c0002dbff8493b20] [c000000000087c10] memory_add_physaddr_to_nid+0x20/0x60
[   80.604521] [c0002dbff8493b40] [c0000000010d4880] drmem_init+0x25c/0x2f0
[   80.604530] [c0002dbff8493c10] [c000000000010154] do_one_initcall+0x64/0x2c0
[   80.604540] [c0002dbff8493ce0] [c0000000010c4aa0] kernel_init_freeable+0x2d8/0x3a0
[   80.604550] [c0002dbff8493db0] [c000000000010824] kernel_init+0x2c/0x148
[   80.604560] [c0002dbff8493e20] [c00000000000b648] ret_from_kernel_thread+0x5c/0x74
[   80.604567] Instruction dump:
[   80.604574] 392918e8 e9490000 e90a000a e92a0000 80ea000c 1d080018 3908ffe8 7d094214
[   80.604586] 7fa94040 419d00dc e9490010 714a0088 <2faa0008> 409e00ac e9490000 7fbe5040
[   89.047390] drmem: 249854 LMB(s)

With a patched kernel on the same machine we're no longer seeing the
soft lockup.  drmem_init() now completes in negligible time, even when
the LMB count is large.

Fixes: b2d3b5ee66f2 ("powerpc/pseries: Track LMB nid instead of using device tree")
Signed-off-by: Scott Cheloha <cheloha@linux.ibm.com>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200811015115.63677-1-cheloha@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/drmem.h              | 21 ----------------
 arch/powerpc/mm/drmem.c                       |  6 +----
 .../platforms/pseries/hotplug-memory.c        | 24 ++++++++++++-------
 3 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/drmem.h b/arch/powerpc/include/asm/drmem.h
index 6fb928605ed13..030a19d922132 100644
--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -15,9 +15,6 @@ struct drmem_lmb {
 	u32     drc_index;
 	u32     aa_index;
 	u32     flags;
-#ifdef CONFIG_MEMORY_HOTPLUG
-	int	nid;
-#endif
 };
 
 struct drmem_lmb_info {
@@ -121,22 +118,4 @@ static inline void invalidate_lmb_associativity_index(struct drmem_lmb *lmb)
 	lmb->aa_index = 0xffffffff;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static inline void lmb_set_nid(struct drmem_lmb *lmb)
-{
-	lmb->nid = memory_add_physaddr_to_nid(lmb->base_addr);
-}
-static inline void lmb_clear_nid(struct drmem_lmb *lmb)
-{
-	lmb->nid = -1;
-}
-#else
-static inline void lmb_set_nid(struct drmem_lmb *lmb)
-{
-}
-static inline void lmb_clear_nid(struct drmem_lmb *lmb)
-{
-}
-#endif
-
 #endif /* _ASM_POWERPC_LMB_H */
diff --git a/arch/powerpc/mm/drmem.c b/arch/powerpc/mm/drmem.c
index b2eeea39684ca..9af3832c9d8dc 100644
--- a/arch/powerpc/mm/drmem.c
+++ b/arch/powerpc/mm/drmem.c
@@ -389,10 +389,8 @@ static void __init init_drmem_v1_lmbs(const __be32 *prop)
 	if (!drmem_info->lmbs)
 		return;
 
-	for_each_drmem_lmb(lmb) {
+	for_each_drmem_lmb(lmb)
 		read_drconf_v1_cell(lmb, &prop);
-		lmb_set_nid(lmb);
-	}
 }
 
 static void __init init_drmem_v2_lmbs(const __be32 *prop)
@@ -437,8 +435,6 @@ static void __init init_drmem_v2_lmbs(const __be32 *prop)
 
 			lmb->aa_index = dr_cell.aa_index;
 			lmb->flags = dr_cell.flags;
-
-			lmb_set_nid(lmb);
 		}
 	}
 }
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 5d545b78111f9..0ea976d1cac47 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -354,25 +354,32 @@ static int dlpar_add_lmb(struct drmem_lmb *);
 
 static int dlpar_remove_lmb(struct drmem_lmb *lmb)
 {
+	struct memory_block *mem_block;
 	unsigned long block_sz;
 	int rc;
 
 	if (!lmb_is_removable(lmb))
 		return -EINVAL;
 
+	mem_block = lmb_to_memblock(lmb);
+	if (mem_block == NULL)
+		return -EINVAL;
+
 	rc = dlpar_offline_lmb(lmb);
-	if (rc)
+	if (rc) {
+		put_device(&mem_block->dev);
 		return rc;
+	}
 
 	block_sz = pseries_memory_block_size();
 
-	__remove_memory(lmb->nid, lmb->base_addr, block_sz);
+	__remove_memory(mem_block->nid, lmb->base_addr, block_sz);
+	put_device(&mem_block->dev);
 
 	/* Update memory regions for memory remove */
 	memblock_remove(lmb->base_addr, block_sz);
 
 	invalidate_lmb_associativity_index(lmb);
-	lmb_clear_nid(lmb);
 	lmb->flags &= ~DRCONF_MEM_ASSIGNED;
 
 	return 0;
@@ -591,7 +598,7 @@ static int dlpar_memory_remove_by_ic(u32 lmbs_to_remove, u32 drc_index)
 static int dlpar_add_lmb(struct drmem_lmb *lmb)
 {
 	unsigned long block_sz;
-	int rc;
+	int nid, rc;
 
 	if (lmb->flags & DRCONF_MEM_ASSIGNED)
 		return -EINVAL;
@@ -602,11 +609,13 @@ static int dlpar_add_lmb(struct drmem_lmb *lmb)
 		return rc;
 	}
 
-	lmb_set_nid(lmb);
 	block_sz = memory_block_size_bytes();
 
+	/* Find the node id for this address. */
+	nid = memory_add_physaddr_to_nid(lmb->base_addr);
+
 	/* Add the memory */
-	rc = __add_memory(lmb->nid, lmb->base_addr, block_sz);
+	rc = __add_memory(nid, lmb->base_addr, block_sz);
 	if (rc) {
 		invalidate_lmb_associativity_index(lmb);
 		return rc;
@@ -614,9 +623,8 @@ static int dlpar_add_lmb(struct drmem_lmb *lmb)
 
 	rc = dlpar_online_lmb(lmb);
 	if (rc) {
-		__remove_memory(lmb->nid, lmb->base_addr, block_sz);
+		__remove_memory(nid, lmb->base_addr, block_sz);
 		invalidate_lmb_associativity_index(lmb);
-		lmb_clear_nid(lmb);
 	} else {
 		lmb->flags |= DRCONF_MEM_ASSIGNED;
 	}
-- 
2.25.1



