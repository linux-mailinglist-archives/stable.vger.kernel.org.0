Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD25732AF43
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbhCCAQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446884AbhCBMNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:13:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D6364F77;
        Tue,  2 Mar 2021 11:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686257;
        bh=hikb7K0g/VjrzeNHBAzMlfdSAzCNLajWEGlhXvjyap0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBY7xm+s0U0Mz1v2K77Vhm7mv07UwezMTJ5nogUUBynk4u7vLxewKQd/arS4Wi4om
         0ws7cwm4q0+B3i9C9VNBpdbAWSOBm/gfExapzAu8uo5gwBl5WB6L0fa3YzfIBKPTNw
         lomqEqq2WlmIej89LvyVdpfVm2cdbMcT7jUpptsVs2mm/WoOZ8BibJP6MkA5AVB+9g
         vaw6EcokABCQMXQk6S3LD2Cr5qY38imQSzOTt1UY08EXnIKPvZFlRA55Nx9FOBEBJ1
         gN/JavAFcJMizzu7hxcjw2yPfmAtpjivDFqIV6bNVHy/ga1EBvdKRhBAS3YuxG6Nor
         oomt2DWILMHjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alex@ghiti.fr>,
        Dmitry Vyukov <dvyukov@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 40/47] riscv: Get rid of MAX_EARLY_MAPPING_SIZE
Date:   Tue,  2 Mar 2021 06:56:39 -0500
Message-Id: <20210302115646.62291-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit 0f02de4481da684aad6589aed0ea47bd1ab391c9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 608082fb9a6c..e8921e78a292 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -222,8 +222,6 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 pgd_t trampoline_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
 pte_t fixmap_pte[PTRS_PER_PTE] __page_aligned_bss;
 
-#define MAX_EARLY_MAPPING_SIZE	SZ_128M
-
 pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
@@ -298,13 +296,7 @@ static void __init create_pte_mapping(pte_t *ptep,
 
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
@@ -326,11 +318,9 @@ static pmd_t *get_pmd_virt_late(phys_addr_t pa)
 
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
@@ -448,7 +438,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	uintptr_t va, pa, end_va;
 	uintptr_t load_pa = (uintptr_t)(&_start);
 	uintptr_t load_sz = (uintptr_t)(&_end) - load_pa;
-	uintptr_t map_size = best_map_size(load_pa, MAX_EARLY_MAPPING_SIZE);
+	uintptr_t map_size;
 #ifndef __PAGETABLE_PMD_FOLDED
 	pmd_t fix_bmap_spmd, fix_bmap_epmd;
 #endif
@@ -460,12 +450,11 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
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
-- 
2.30.1

