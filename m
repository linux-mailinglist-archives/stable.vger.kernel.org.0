Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8098445AF5D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 23:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhKWWtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 17:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239209AbhKWWtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86B4660F5D;
        Tue, 23 Nov 2021 22:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707567;
        bh=CjK9xsn4H3U9NeHt5Y+GXMaZjEqU+EF/ck8iUGAYkhA=;
        h=Date:From:To:Subject:From;
        b=MSrgB8VTcGOa3nmwMiiz4l8U9UsMDXXJOKDNbHA2vijuxC8bXZ6xzS+EVYZq71v/e
         oZ5LJ5EU0aPOB5oFavZ6DH0Mb4k0OqqeB8JUFdamY7S7aaumurrLqSgaDPMNNygrLe
         55HJWFOPVKMoV+f41zDCs0A/bmB4DS3cSYSs8MUk=
Date:   Tue, 23 Nov 2021 14:46:06 -0800
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, linus.walleij@linaro.org,
        mm-commits@vger.kernel.org, quanyang.wang@windriver.com,
        rmk+kernel@armlinux.org.uk, stable@vger.kernel.org,
        tglx@linutronix.de
Subject:  [merged]
 kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory.patch removed
 from -mm tree
Message-ID: <20211123224606.8VJDTHqFj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kmap_local: don't assume kmap PTEs are linear arrays in memory
has been removed from the -mm tree.  Its filename was
     kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ard Biesheuvel <ardb@kernel.org>
Subject: kmap_local: don't assume kmap PTEs are linear arrays in memory

The kmap_local conversion broke the ARM architecture, because the new code
assumes that all PTEs used for creating kmaps form a linear array in
memory, and uses array indexing to look up the kmap PTE belonging to a
certain kmap index.

On ARM, this cannot work, not only because the PTE pages may be
non-adjacent in memory, but also because ARM/!LPAE interleaves hardware
entries and extended entries (carrying software-only bits) in a way that
is not compatible with array indexing.

Fortunately, this only seems to affect configurations with more than 8
CPUs, due to the way the per-CPU kmap slots are organized in memory.

Work around this by permitting an architecture to set a Kconfig symbol
that signifies that the kmap PTEs do not form a lineary array in memory,
and so the only way to locate the appropriate one is to walk the page
tables.

Link: https://lore.kernel.org/linux-arm-kernel/20211026131249.3731275-1-ardb@kernel.org/
Link: https://lkml.kernel.org/r/20211116094737.7391-1-ardb@kernel.org
Fixes: 2a15ba82fa6c ("ARM: highmem: Switch to generic kmap atomic")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reported-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    1 +
 mm/Kconfig       |    3 +++
 mm/highmem.c     |   32 +++++++++++++++++++++-----------
 3 files changed, 25 insertions(+), 11 deletions(-)

--- a/arch/arm/Kconfig~kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory
+++ a/arch/arm/Kconfig
@@ -1463,6 +1463,7 @@ config HIGHMEM
 	bool "High Memory Support"
 	depends on MMU
 	select KMAP_LOCAL
+	select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 	help
 	  The address space of ARM processors is only 4 Gigabytes large
 	  and it has to accommodate user address space, kernel address
--- a/mm/highmem.c~kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory
+++ a/mm/highmem.c
@@ -503,16 +503,22 @@ static inline int kmap_local_calc_idx(in
 
 static pte_t *__kmap_pte;
 
-static pte_t *kmap_get_pte(void)
+static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
 {
+	if (IS_ENABLED(CONFIG_KMAP_LOCAL_NON_LINEAR_PTE_ARRAY))
+		/*
+		 * Set by the arch if __kmap_pte[-idx] does not produce
+		 * the correct entry.
+		 */
+		return virt_to_kpte(vaddr);
 	if (!__kmap_pte)
 		__kmap_pte = virt_to_kpte(__fix_to_virt(FIX_KMAP_BEGIN));
-	return __kmap_pte;
+	return &__kmap_pte[-idx];
 }
 
 void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
 {
-	pte_t pteval, *kmap_pte = kmap_get_pte();
+	pte_t pteval, *kmap_pte;
 	unsigned long vaddr;
 	int idx;
 
@@ -524,9 +530,10 @@ void *__kmap_local_pfn_prot(unsigned lon
 	preempt_disable();
 	idx = arch_kmap_local_map_idx(kmap_local_idx_push(), pfn);
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	BUG_ON(!pte_none(*(kmap_pte - idx)));
+	kmap_pte = kmap_get_pte(vaddr, idx);
+	BUG_ON(!pte_none(*kmap_pte));
 	pteval = pfn_pte(pfn, prot);
-	arch_kmap_local_set_pte(&init_mm, vaddr, kmap_pte - idx, pteval);
+	arch_kmap_local_set_pte(&init_mm, vaddr, kmap_pte, pteval);
 	arch_kmap_local_post_map(vaddr, pteval);
 	current->kmap_ctrl.pteval[kmap_local_idx()] = pteval;
 	preempt_enable();
@@ -559,7 +566,7 @@ EXPORT_SYMBOL(__kmap_local_page_prot);
 void kunmap_local_indexed(void *vaddr)
 {
 	unsigned long addr = (unsigned long) vaddr & PAGE_MASK;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int idx;
 
 	if (addr < __fix_to_virt(FIX_KMAP_END) ||
@@ -584,8 +591,9 @@ void kunmap_local_indexed(void *vaddr)
 	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
 	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 
+	kmap_pte = kmap_get_pte(addr, idx);
 	arch_kmap_local_pre_unmap(addr);
-	pte_clear(&init_mm, addr, kmap_pte - idx);
+	pte_clear(&init_mm, addr, kmap_pte);
 	arch_kmap_local_post_unmap(addr);
 	current->kmap_ctrl.pteval[kmap_local_idx()] = __pte(0);
 	kmap_local_idx_pop();
@@ -607,7 +615,7 @@ EXPORT_SYMBOL(kunmap_local_indexed);
 void __kmap_local_sched_out(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int i;
 
 	/* Clear kmaps */
@@ -634,8 +642,9 @@ void __kmap_local_sched_out(void)
 		idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 
 		addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+		kmap_pte = kmap_get_pte(addr, idx);
 		arch_kmap_local_pre_unmap(addr);
-		pte_clear(&init_mm, addr, kmap_pte - idx);
+		pte_clear(&init_mm, addr, kmap_pte);
 		arch_kmap_local_post_unmap(addr);
 	}
 }
@@ -643,7 +652,7 @@ void __kmap_local_sched_out(void)
 void __kmap_local_sched_in(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int i;
 
 	/* Restore kmaps */
@@ -663,7 +672,8 @@ void __kmap_local_sched_in(void)
 		/* See comment in __kmap_local_sched_out() */
 		idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 		addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-		set_pte_at(&init_mm, addr, kmap_pte - idx, pteval);
+		kmap_pte = kmap_get_pte(addr, idx);
+		set_pte_at(&init_mm, addr, kmap_pte, pteval);
 		arch_kmap_local_post_map(addr, pteval);
 	}
 }
--- a/mm/Kconfig~kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory
+++ a/mm/Kconfig
@@ -890,6 +890,9 @@ config MAPPING_DIRTY_HELPERS
 config KMAP_LOCAL
 	bool
 
+config KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
+	bool
+
 # struct io_mapping based helper.  Selected by drivers that need them
 config IO_MAPPING
 	bool
_

Patches currently in -mm which might be from ardb@kernel.org are


