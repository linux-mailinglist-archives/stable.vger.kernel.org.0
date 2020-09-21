Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4B4272F64
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgIUQ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A033023A05;
        Mon, 21 Sep 2020 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706670;
        bh=HMu/HokD/40n5wtsJzDHKfGBoJ+UQNB7FtxnSHWbdGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxLBe2BGb4B8yZhWIPVCeueA7uvwXYzdJusI9jSqosjuBPFtjoTLHCDiOUamIQF7m
         ZFvA8sjV+YO3wU8IS90omQ6sXp2wgDlqexs5EZ7rL70VrKcLpgFe0Y8ZYr/I4l+8Ih
         YSzl1aGEDTjDNw0u+0GwkiiXMyr3ZgswJlc2OSU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirisha Ganta <shiganta@in.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 046/118] powerpc/book3s64/radix: Fix boot failure with large amount of guest memory
Date:   Mon, 21 Sep 2020 18:27:38 +0200
Message-Id: <20200921162038.446609098@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 103a8542cb35b5130f732d00b0419a594ba1b517 ]

If the hypervisor doesn't support hugepages, the kernel ends up allocating a large
number of page table pages. The early page table allocation was wrongly
setting the max memblock limit to ppc64_rma_size with radix translation
which resulted in boot failure as shown below.

Kernel panic - not syncing:
early_alloc_pgtable: Failed to allocate 16777216 bytes align=0x1000000 nid=-1 from=0x0000000000000000 max_addr=0xffffffffffffffff
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.8.0-24.9-default+ #2
 Call Trace:
 [c0000000016f3d00] [c0000000007c6470] dump_stack+0xc4/0x114 (unreliable)
 [c0000000016f3d40] [c00000000014c78c] panic+0x164/0x418
 [c0000000016f3dd0] [c000000000098890] early_alloc_pgtable+0xe0/0xec
 [c0000000016f3e60] [c0000000010a5440] radix__early_init_mmu+0x360/0x4b4
 [c0000000016f3ef0] [c000000001099bac] early_init_mmu+0x1c/0x3c
 [c0000000016f3f10] [c00000000109a320] early_setup+0x134/0x170

This was because the kernel was checking for the radix feature before we enable the
feature via mmu_features. This resulted in the kernel using hash restrictions on
radix.

Rework the early init code such that the kernel boot with memblock restrictions
as imposed by hash. At that point, the kernel still hasn't finalized the
translation the kernel will end up using.

We have three different ways of detecting radix.

1. dt_cpu_ftrs_scan -> used only in case of PowerNV
2. ibm,pa-features -> Used when we don't use cpu_dt_ftr_scan
3. CAS -> Where we negotiate with hypervisor about the supported translation.

We look at 1 or 2 early in the boot and after that, we look at the CAS vector to
finalize the translation the kernel will use. We also support a kernel command
line option (disable_radix) to switch to hash.

Update the memblock limit after mmu_early_init_devtree() if the kernel is going
to use radix translation. This forces some of the memblock allocations we do before
mmu_early_init_devtree() to be within the RMA limit.

Fixes: 2bfd65e45e87 ("powerpc/mm/radix: Add radix callbacks for early init routines")
Reported-by: Shirisha Ganta <shiganta@in.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200828100852.426575-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/mmu.h | 10 +++++-----
 arch/powerpc/mm/book3s64/radix_pgtable.c | 15 ---------------
 arch/powerpc/mm/init_64.c                | 11 +++++++++--
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/include/asm/book3s/64/mmu.h
index 5393a535240c7..dfbbffa0eb2e2 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -228,14 +228,14 @@ static inline void early_init_mmu_secondary(void)
 
 extern void hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
 					 phys_addr_t first_memblock_size);
-extern void radix__setup_initial_memory_limit(phys_addr_t first_memblock_base,
-					 phys_addr_t first_memblock_size);
 static inline void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 					      phys_addr_t first_memblock_size)
 {
-	if (early_radix_enabled())
-		return radix__setup_initial_memory_limit(first_memblock_base,
-						   first_memblock_size);
+	/*
+	 * Hash has more strict restrictions. At this point we don't
+	 * know which translations we will pick. Hence go with hash
+	 * restrictions.
+	 */
 	return hash__setup_initial_memory_limit(first_memblock_base,
 					   first_memblock_size);
 }
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index c2989c1718839..1e9a298020a63 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -654,21 +654,6 @@ void radix__mmu_cleanup_all(void)
 	}
 }
 
-void radix__setup_initial_memory_limit(phys_addr_t first_memblock_base,
-				phys_addr_t first_memblock_size)
-{
-	/*
-	 * We don't currently support the first MEMBLOCK not mapping 0
-	 * physical on those processors
-	 */
-	BUG_ON(first_memblock_base != 0);
-
-	/*
-	 * Radix mode is not limited by RMA / VRMA addressing.
-	 */
-	ppc64_rma_size = ULONG_MAX;
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index bc73abf0bc25e..ef566fc43933e 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -431,9 +431,16 @@ void __init mmu_early_init_devtree(void)
 	if (!(mfmsr() & MSR_HV))
 		early_check_vec5();
 
-	if (early_radix_enabled())
+	if (early_radix_enabled()) {
 		radix__early_init_devtree();
-	else
+		/*
+		 * We have finalized the translation we are going to use by now.
+		 * Radix mode is not limited by RMA / VRMA addressing.
+		 * Hence don't limit memblock allocations.
+		 */
+		ppc64_rma_size = ULONG_MAX;
+		memblock_set_current_limit(MEMBLOCK_ALLOC_ANYWHERE);
+	} else
 		hash__early_init_devtree();
 }
 #endif /* CONFIG_PPC_BOOK3S_64 */
-- 
2.25.1



