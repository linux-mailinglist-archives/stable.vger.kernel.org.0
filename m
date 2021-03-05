Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F297832E904
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhCEMaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232213AbhCEM3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B0F865013;
        Fri,  5 Mar 2021 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947387;
        bh=kCqfsKVOdvUUjOZS5SshL+wSWQWwHicqWJSj0RFLn/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHi41UVqXLgn/h4xxupLPSTYj1bQWWHl/hrdeAGI2KnD9CMI36hnXS/FZ6dXlnFBO
         UvBctNbdSqnbbJXS5VFfFtqV+lM0IrdMYcktC72sc4wDz/aWKxBBCznv1sBTz1jf5A
         SmCoc+uaYgRJ82gF2KeCmK1iNoiI1Fu/cG/mERT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 017/102] riscv: Get rid of MAX_EARLY_MAPPING_SIZE
Date:   Fri,  5 Mar 2021 13:20:36 +0100
Message-Id: <20210305120904.123324088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

commit 0f02de4481da684aad6589aed0ea47bd1ab391c9 upstream.

At early boot stage, we have a whole PGDIR to map the kernel, so there
is no need to restrict the early mapping size to 128MB. Removing this
define also allows us to simplify some compile time logic.

This fixes large kernel mappings with a size greater than 128MB, as it
is the case for syzbot kernels whose size was just ~130MB.

Note that on rv64, for now, we are then limited to PGDIR size for early
mapping as we can't use PGD mappings (see [1]). That should be enough
given the relative small size of syzbot kernels compared to PGDIR_SIZE
which is 1GB.

[1] https://lore.kernel.org/lkml/20200603153608.30056-1-alex@ghiti.fr/

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -222,8 +222,6 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __pag
 pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 pte_t fixmap_pte[PTRS_PER_PTE] __page_aligned_bss;
 
-#define MAX_EARLY_MAPPING_SIZE	SZ_128M
-
 pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
@@ -298,13 +296,7 @@ static void __init create_pte_mapping(pt
 
 pmd_t trampoline_pmd[PTRS_PER_PMD] __page_aligned_bss;
 pmd_t fixmap_pmd[PTRS_PER_PMD] __page_aligned_bss;
-
-#if MAX_EARLY_MAPPING_SIZE < PGDIR_SIZE
-#define NUM_EARLY_PMDS		1UL
-#else
-#define NUM_EARLY_PMDS		(1UL + MAX_EARLY_MAPPING_SIZE / PGDIR_SIZE)
-#endif
-pmd_t early_pmd[PTRS_PER_PMD * NUM_EARLY_PMDS] __initdata __aligned(PAGE_SIZE);
+pmd_t early_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 pmd_t early_dtb_pmd[PTRS_PER_PMD] __initdata __aligned(PAGE_SIZE);
 
 static pmd_t *__init get_pmd_virt_early(phys_addr_t pa)
@@ -326,11 +318,9 @@ static pmd_t *get_pmd_virt_late(phys_add
 
 static phys_addr_t __init alloc_pmd_early(uintptr_t va)
 {
-	uintptr_t pmd_num;
+	BUG_ON((va - PAGE_OFFSET) >> PGDIR_SHIFT);
 
-	pmd_num = (va - PAGE_OFFSET) >> PGDIR_SHIFT;
-	BUG_ON(pmd_num >= NUM_EARLY_PMDS);
-	return (uintptr_t)&early_pmd[pmd_num * PTRS_PER_PMD];
+	return (uintptr_t)early_pmd;
 }
 
 static phys_addr_t __init alloc_pmd_fixmap(uintptr_t va)
@@ -448,7 +438,7 @@ asmlinkage void __init setup_vm(uintptr_
 	uintptr_t va, pa, end_va;
 	uintptr_t load_pa = (uintptr_t)(&_start);
 	uintptr_t load_sz = (uintptr_t)(&_end) - load_pa;
-	uintptr_t map_size = best_map_size(load_pa, MAX_EARLY_MAPPING_SIZE);
+	uintptr_t map_size;
 #ifndef __PAGETABLE_PMD_FOLDED
 	pmd_t fix_bmap_spmd, fix_bmap_epmd;
 #endif
@@ -460,12 +450,11 @@ asmlinkage void __init setup_vm(uintptr_
 	 * Enforce boot alignment requirements of RV32 and
 	 * RV64 by only allowing PMD or PGD mappings.
 	 */
-	BUG_ON(map_size == PAGE_SIZE);
+	map_size = PMD_SIZE;
 
 	/* Sanity check alignment and size */
 	BUG_ON((PAGE_OFFSET % PGDIR_SIZE) != 0);
 	BUG_ON((load_pa % map_size) != 0);
-	BUG_ON(load_sz > MAX_EARLY_MAPPING_SIZE);
 
 	pt_ops.alloc_pte = alloc_pte_early;
 	pt_ops.get_pte_virt = get_pte_virt_early;


