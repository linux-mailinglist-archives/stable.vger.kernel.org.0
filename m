Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2145C621
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349463AbhKXOFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353754AbhKXOCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C5361A7B;
        Wed, 24 Nov 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759408;
        bh=mIc9zoBwSAu9YM8iq3vde0cJhMvZvFexR1p/8EjIv8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjNB2hHqGqxYoiUOQYm++JiHsyhBE2fbKL9iMsVPVasWN7+3O1Z3eq2e2jxpLZMU8
         rk9QB9UPAmKJYlbDNyCglnf9g666WBa3/ztVqc9+AIqxWKs1aMFpThyUmRhNY4X6ES
         3dtBLTYRwY+QJ9kqhiDKcXPbvGU258+dnYpLWhKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 198/279] kmap_local: dont assume kmap PTEs are linear arrays in memory
Date:   Wed, 24 Nov 2021 12:58:05 +0100
Message-Id: <20211124115725.572318724@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 825c43f50e3aa811a291ffcb40e02fbf6d91ba86 upstream.

The kmap_local conversion broke the ARM architecture, because the new
code assumes that all PTEs used for creating kmaps form a linear array
in memory, and uses array indexing to look up the kmap PTE belonging to
a certain kmap index.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    1 +
 mm/Kconfig       |    3 +++
 mm/highmem.c     |   32 +++++++++++++++++++++-----------
 3 files changed, 25 insertions(+), 11 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1455,6 +1455,7 @@ config HIGHMEM
 	bool "High Memory Support"
 	depends on MMU
 	select KMAP_LOCAL
+	select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 	help
 	  The address space of ARM processors is only 4 Gigabytes large
 	  and it has to accommodate user address space, kernel address
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -887,6 +887,9 @@ config MAPPING_DIRTY_HELPERS
 config KMAP_LOCAL
 	bool
 
+config KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
+	bool
+
 # struct io_mapping based helper.  Selected by drivers that need them
 config IO_MAPPING
 	bool
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -504,16 +504,22 @@ static inline int kmap_local_calc_idx(in
 
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
 
@@ -525,9 +531,10 @@ void *__kmap_local_pfn_prot(unsigned lon
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
@@ -560,7 +567,7 @@ EXPORT_SYMBOL(__kmap_local_page_prot);
 void kunmap_local_indexed(void *vaddr)
 {
 	unsigned long addr = (unsigned long) vaddr & PAGE_MASK;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int idx;
 
 	if (addr < __fix_to_virt(FIX_KMAP_END) ||
@@ -585,8 +592,9 @@ void kunmap_local_indexed(void *vaddr)
 	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
 	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 
+	kmap_pte = kmap_get_pte(addr, idx);
 	arch_kmap_local_pre_unmap(addr);
-	pte_clear(&init_mm, addr, kmap_pte - idx);
+	pte_clear(&init_mm, addr, kmap_pte);
 	arch_kmap_local_post_unmap(addr);
 	current->kmap_ctrl.pteval[kmap_local_idx()] = __pte(0);
 	kmap_local_idx_pop();
@@ -608,7 +616,7 @@ EXPORT_SYMBOL(kunmap_local_indexed);
 void __kmap_local_sched_out(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int i;
 
 	/* Clear kmaps */
@@ -635,8 +643,9 @@ void __kmap_local_sched_out(void)
 		idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 
 		addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+		kmap_pte = kmap_get_pte(addr, idx);
 		arch_kmap_local_pre_unmap(addr);
-		pte_clear(&init_mm, addr, kmap_pte - idx);
+		pte_clear(&init_mm, addr, kmap_pte);
 		arch_kmap_local_post_unmap(addr);
 	}
 }
@@ -644,7 +653,7 @@ void __kmap_local_sched_out(void)
 void __kmap_local_sched_in(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte = kmap_get_pte();
+	pte_t *kmap_pte;
 	int i;
 
 	/* Restore kmaps */
@@ -664,7 +673,8 @@ void __kmap_local_sched_in(void)
 		/* See comment in __kmap_local_sched_out() */
 		idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 		addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-		set_pte_at(&init_mm, addr, kmap_pte - idx, pteval);
+		kmap_pte = kmap_get_pte(addr, idx);
+		set_pte_at(&init_mm, addr, kmap_pte, pteval);
 		arch_kmap_local_post_map(addr, pteval);
 	}
 }


