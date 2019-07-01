Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006CE4401B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389907AbfFMQDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731388AbfFMIrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7E7206BA;
        Thu, 13 Jun 2019 08:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415658;
        bh=RFCWp1QQvBC7YqUpaBc5qui5fLYQBWtD0INLpwBJ4pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+82pr1xtBkyyzWhDBfcoK+njTgQ1sLmQorE6hMXalS181+XoxeaFi7YKq+ewipXr
         9UTrQG6soZu7JZ0GIF7vFY0Orw09wm2bIM59kBPs5wCnpBYSDzx0ReJ9GHuBxRs1XH
         cq3CtmvdeSJGkkxmQolDE9c8swuzz91BxIjHTd4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 080/155] powerpc/pseries: Track LMB nid instead of using device tree
Date:   Thu, 13 Jun 2019 10:33:12 +0200
Message-Id: <20190613075657.511784132@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b2d3b5ee66f2a04a918cc043cec0c9ed3de58f40 ]

When removing memory we need to remove the memory from the node
it was added to instead of looking up the node it should be in
in the device tree.

During testing we have seen scenarios where the affinity for a
LMB changes due to a partition migration or PRRN event. In these
cases the node the LMB exists in may not match the node the device
tree indicates it belongs in. This can lead to a system crash
when trying to DLPAR remove the LMB after a migration or PRRN
event. The current code looks up the node in the device tree to
remove the LMB from, the crash occurs when we try to offline this
node and it does not have any data, i.e. node_data[nid] == NULL.

36:mon> e
cpu 0x36: Vector: 300 (Data Access) at [c0000001828b7810]
    pc: c00000000036d08c: try_offline_node+0x2c/0x1b0
    lr: c0000000003a14ec: remove_memory+0xbc/0x110
    sp: c0000001828b7a90
   msr: 800000000280b033
   dar: 9a28
 dsisr: 40000000
  current = 0xc0000006329c4c80
  paca    = 0xc000000007a55200   softe: 0        irq_happened: 0x01
    pid   = 76926, comm = kworker/u320:3

36:mon> t
[link register   ] c0000000003a14ec remove_memory+0xbc/0x110
[c0000001828b7a90] c00000000006a1cc arch_remove_memory+0x9c/0xd0 (unreliable)
[c0000001828b7ad0] c0000000003a14e0 remove_memory+0xb0/0x110
[c0000001828b7b20] c0000000000c7db4 dlpar_remove_lmb+0x94/0x160
[c0000001828b7b60] c0000000000c8ef8 dlpar_memory+0x7e8/0xd10
[c0000001828b7bf0] c0000000000bf828 handle_dlpar_errorlog+0xf8/0x160
[c0000001828b7c60] c0000000000bf8cc pseries_hp_work_fn+0x3c/0xa0
[c0000001828b7c90] c000000000128cd8 process_one_work+0x298/0x5a0
[c0000001828b7d20] c000000000129068 worker_thread+0x88/0x620
[c0000001828b7dc0] c00000000013223c kthread+0x1ac/0x1c0
[c0000001828b7e30] c00000000000b45c ret_from_kernel_thread+0x5c/0x80

To resolve this we need to track the node a LMB belongs to when
it is added to the system so we can remove it from that node instead
of the node that the device tree indicates it should belong to.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/drmem.h              | 21 +++++++++++++++++++
 arch/powerpc/mm/drmem.c                       |  6 +++++-
 .../platforms/pseries/hotplug-memory.c        | 17 +++++++--------
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/drmem.h b/arch/powerpc/include/asm/drmem.h
index 7c1d8e74b25d..7f3279b014db 100644
--- a/arch/powerpc/include/asm/drmem.h
+++ b/arch/powerpc/include/asm/drmem.h
@@ -17,6 +17,9 @@ struct drmem_lmb {
 	u32     drc_index;
 	u32     aa_index;
 	u32     flags;
+#ifdef CONFIG_MEMORY_HOTPLUG
+	int	nid;
+#endif
 };
 
 struct drmem_lmb_info {
@@ -104,4 +107,22 @@ static inline void invalidate_lmb_associativity_index(struct drmem_lmb *lmb)
 	lmb->aa_index = 0xffffffff;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static inline void lmb_set_nid(struct drmem_lmb *lmb)
+{
+	lmb->nid = memory_add_physaddr_to_nid(lmb->base_addr);
+}
+static inline void lmb_clear_nid(struct drmem_lmb *lmb)
+{
+	lmb->nid = -1;
+}
+#else
+static inline void lmb_set_nid(struct drmem_lmb *lmb)
+{
+}
+static inline void lmb_clear_nid(struct drmem_lmb *lmb)
+{
+}
+#endif
+
 #endif /* _ASM_POWERPC_LMB_H */
diff --git a/arch/powerpc/mm/drmem.c b/arch/powerpc/mm/drmem.c
index 3f1803672c9b..641891df2046 100644
--- a/arch/powerpc/mm/drmem.c
+++ b/arch/powerpc/mm/drmem.c
@@ -366,8 +366,10 @@ static void __init init_drmem_v1_lmbs(const __be32 *prop)
 	if (!drmem_info->lmbs)
 		return;
 
-	for_each_drmem_lmb(lmb)
+	for_each_drmem_lmb(lmb) {
 		read_drconf_v1_cell(lmb, &prop);
+		lmb_set_nid(lmb);
+	}
 }
 
 static void __init init_drmem_v2_lmbs(const __be32 *prop)
@@ -412,6 +414,8 @@ static void __init init_drmem_v2_lmbs(const __be32 *prop)
 
 			lmb->aa_index = dr_cell.aa_index;
 			lmb->flags = dr_cell.flags;
+
+			lmb_set_nid(lmb);
 		}
 	}
 }
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index d291b618a559..47087832f8b2 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -379,7 +379,7 @@ static int dlpar_add_lmb(struct drmem_lmb *);
 static int dlpar_remove_lmb(struct drmem_lmb *lmb)
 {
 	unsigned long block_sz;
-	int nid, rc;
+	int rc;
 
 	if (!lmb_is_removable(lmb))
 		return -EINVAL;
@@ -389,14 +389,14 @@ static int dlpar_remove_lmb(struct drmem_lmb *lmb)
 		return rc;
 
 	block_sz = pseries_memory_block_size();
-	nid = memory_add_physaddr_to_nid(lmb->base_addr);
 
-	__remove_memory(nid, lmb->base_addr, block_sz);
+	__remove_memory(lmb->nid, lmb->base_addr, block_sz);
 
 	/* Update memory regions for memory remove */
 	memblock_remove(lmb->base_addr, block_sz);
 
 	invalidate_lmb_associativity_index(lmb);
+	lmb_clear_nid(lmb);
 	lmb->flags &= ~DRCONF_MEM_ASSIGNED;
 
 	return 0;
@@ -653,7 +653,7 @@ static int dlpar_memory_remove_by_ic(u32 lmbs_to_remove, u32 drc_index)
 static int dlpar_add_lmb(struct drmem_lmb *lmb)
 {
 	unsigned long block_sz;
-	int nid, rc;
+	int rc;
 
 	if (lmb->flags & DRCONF_MEM_ASSIGNED)
 		return -EINVAL;
@@ -664,13 +664,11 @@ static int dlpar_add_lmb(struct drmem_lmb *lmb)
 		return rc;
 	}
 
+	lmb_set_nid(lmb);
 	block_sz = memory_block_size_bytes();
 
-	/* Find the node id for this address */
-	nid = memory_add_physaddr_to_nid(lmb->base_addr);
-
 	/* Add the memory */
-	rc = __add_memory(nid, lmb->base_addr, block_sz);
+	rc = __add_memory(lmb->nid, lmb->base_addr, block_sz);
 	if (rc) {
 		invalidate_lmb_associativity_index(lmb);
 		return rc;
@@ -678,8 +676,9 @@ static int dlpar_add_lmb(struct drmem_lmb *lmb)
 
 	rc = dlpar_online_lmb(lmb);
 	if (rc) {
-		__remove_memory(nid, lmb->base_addr, block_sz);
+		__remove_memory(lmb->nid, lmb->base_addr, block_sz);
 		invalidate_lmb_associativity_index(lmb);
+		lmb_clear_nid(lmb);
 	} else {
 		lmb->flags |= DRCONF_MEM_ASSIGNED;
 	}
-- 
2.20.1



