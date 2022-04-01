Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F624EF46E
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348915AbiDAOyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351843AbiDAOth (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:49:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32082908B1;
        Fri,  1 Apr 2022 07:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DB4B824D8;
        Fri,  1 Apr 2022 14:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A3EC2BBE4;
        Fri,  1 Apr 2022 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823984;
        bh=sl/L3IoLhbxSi+8SA2V9tdINBn6+oqofJHpHEInNECk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCKIMbXodDYszSNtvXX6AUSUkwkmqGBjAdtUucBwuIEP6ZfV5fZ0lwK0VqA7sdPYv
         MN27/XnXOEP8HRC+Fd8RkEY4Yp1lGgplwf5CQ5l4IlsdVTtfbD4QeDNG7XZTCTVaBp
         9xvBvTiEBsKl3FqafQS2IH2pjJSNnmHl5cGqGQy/CHGEtbm0uFicj925V17NtBzCR7
         1yOf6ZpYH7Hjf0wWj+MxcOUGiOWKAxKf8Ze2umv/slvfXtnDN0yMGxSOSme+IVBQRY
         vEWgMcthylV7alOJE7Kh7zIVmRpn+bYdTKZwFWVSObzNiwtO0iFzZx9KA5jxBT+tJm
         6KaCchpZvaPMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Maxime Bizon <mbizon@freebox.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, ruscur@russell.cc,
        jniethe5@gmail.com, dja@axtens.net, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 40/98] powerpc/set_memory: Avoid spinlock recursion in change_page_attr()
Date:   Fri,  1 Apr 2022 10:36:44 -0400
Message-Id: <20220401143742.1952163-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit a4c182ecf33584b9b2d1aa9dad073014a504c01f ]

Commit 1f9ad21c3b38 ("powerpc/mm: Implement set_memory() routines")
included a spin_lock() to change_page_attr() in order to
safely perform the three step operations. But then
commit 9f7853d7609d ("powerpc/mm: Fix set_memory_*() against
concurrent accesses") modify it to use pte_update() and do
the operation safely against concurrent access.

In the meantime, Maxime reported some spinlock recursion.

[   15.351649] BUG: spinlock recursion on CPU#0, kworker/0:2/217
[   15.357540]  lock: init_mm+0x3c/0x420, .magic: dead4ead, .owner: kworker/0:2/217, .owner_cpu: 0
[   15.366563] CPU: 0 PID: 217 Comm: kworker/0:2 Not tainted 5.15.0+ #523
[   15.373350] Workqueue: events do_free_init
[   15.377615] Call Trace:
[   15.380232] [e4105ac0] [800946a4] do_raw_spin_lock+0xf8/0x120 (unreliable)
[   15.387340] [e4105ae0] [8001f4ec] change_page_attr+0x40/0x1d4
[   15.393413] [e4105b10] [801424e0] __apply_to_page_range+0x164/0x310
[   15.400009] [e4105b60] [80169620] free_pcp_prepare+0x1e4/0x4a0
[   15.406045] [e4105ba0] [8016c5a0] free_unref_page+0x40/0x2b8
[   15.411979] [e4105be0] [8018724c] kasan_depopulate_vmalloc_pte+0x6c/0x94
[   15.418989] [e4105c00] [801424e0] __apply_to_page_range+0x164/0x310
[   15.425451] [e4105c50] [80187834] kasan_release_vmalloc+0xbc/0x134
[   15.431898] [e4105c70] [8015f7a8] __purge_vmap_area_lazy+0x4e4/0xdd8
[   15.438560] [e4105d30] [80160d10] _vm_unmap_aliases.part.0+0x17c/0x24c
[   15.445283] [e4105d60] [801642d0] __vunmap+0x2f0/0x5c8
[   15.450684] [e4105db0] [800e32d0] do_free_init+0x68/0x94
[   15.456181] [e4105dd0] [8005d094] process_one_work+0x4bc/0x7b8
[   15.462283] [e4105e90] [8005d614] worker_thread+0x284/0x6e8
[   15.468227] [e4105f00] [8006aaec] kthread+0x1f0/0x210
[   15.473489] [e4105f40] [80017148] ret_from_kernel_thread+0x14/0x1c

Remove the read / modify / write sequence to make the operation atomic
and remove the spin_lock() in change_page_attr().

To do the operation atomically, we can't use pte modification helpers
anymore. Because all platforms have different combination of bits, it
is not easy to use those bits directly. But all have the
_PAGE_KERNEL_{RO/ROX/RW/RWX} set of flags. All we need it to compare
two sets to know which bits are set or cleared.

For instance, by comparing _PAGE_KERNEL_ROX and _PAGE_KERNEL_RO you
know which bit gets cleared and which bit get set when changing exec
permission.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/all/20211212112152.GA27070@sakura/
Link: https://lore.kernel.org/r/43c3c76a1175ae6dc1a3d3b5c3f7ecb48f683eea.1640344012.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pageattr.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index edea388e9d3f..8812454e70ff 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -15,12 +15,14 @@
 #include <asm/pgtable.h>
 
 
+static pte_basic_t pte_update_delta(pte_t *ptep, unsigned long addr,
+				    unsigned long old, unsigned long new)
+{
+	return pte_update(&init_mm, addr, ptep, old & ~new, new & ~old, 0);
+}
+
 /*
- * Updates the attributes of a page in three steps:
- *
- * 1. take the page_table_lock
- * 2. install the new entry with the updated attributes
- * 3. flush the TLB
+ * Updates the attributes of a page atomically.
  *
  * This sequence is safe against concurrent updates, and also allows updating the
  * attributes of a page currently being executed or accessed.
@@ -28,41 +30,33 @@
 static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 {
 	long action = (long)data;
-	pte_t pte;
-
-	spin_lock(&init_mm.page_table_lock);
-
-	pte = ptep_get(ptep);
 
-	/* modify the PTE bits as desired, then apply */
+	/* modify the PTE bits as desired */
 	switch (action) {
 	case SET_MEMORY_RO:
-		pte = pte_wrprotect(pte);
+		/* Don't clear DIRTY bit */
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RW & ~_PAGE_DIRTY, _PAGE_KERNEL_RO);
 		break;
 	case SET_MEMORY_RW:
-		pte = pte_mkwrite(pte_mkdirty(pte));
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_RW);
 		break;
 	case SET_MEMORY_NX:
-		pte = pte_exprotect(pte);
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_ROX, _PAGE_KERNEL_RO);
 		break;
 	case SET_MEMORY_X:
-		pte = pte_mkexec(pte);
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_ROX);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
 
-	pte_update(&init_mm, addr, ptep, ~0UL, pte_val(pte), 0);
-
 	/* See ptesync comment in radix__set_pte_at() */
 	if (radix_enabled())
 		asm volatile("ptesync": : :"memory");
 
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 
-	spin_unlock(&init_mm.page_table_lock);
-
 	return 0;
 }
 
-- 
2.34.1

