Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41BC14517E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgAVJya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbgAVJd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC3B24673;
        Wed, 22 Jan 2020 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685635;
        bh=EVjgaJW8OE5sV1Q9fTEbc2fZ13z60TLkZJ4lEhs+L4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIWgB/TJ5pAf+dh2yvyBwY3MKr5wpmNYgVFqGWBpRycyo9DHotnY0Dj8obP9uPtFq
         b1fsu4fL5klORFzhVPDVA7Lxs1DaG41aO/r69FA8tTC5t67Tqb/Vsl7yonY3gt0dIL
         jcOomAjmX51hxic++pWv7pcIB6DbJL8upFV18f0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 07/97] arm64: mm: BUG on unsupported manipulations of live kernel mappings
Date:   Wed, 22 Jan 2020 10:28:11 +0100
Message-Id: <20200122092756.943196447@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit e98216b52176ba2bfa4bdb02f178f4d08832d465 upstream.

Now that we take care not manipulate the live kernel page tables in a
way that may lead to TLB conflicts, the case where a table mapping is
replaced by a block mapping can no longer occur. So remove the handling
of this at the PUD and PMD levels, and instead, BUG() on any occurrence
of live kernel page table manipulations that modify anything other than
the permission bits.

Since mark_rodata_ro() is the only caller where the kernel mappings that
are being manipulated are actually live, drop the various conditional
flush_tlb_all() invocations, and add a single call to mark_rodata_ro()
instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |   70 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 27 deletions(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -28,8 +28,6 @@
 #include <linux/memblock.h>
 #include <linux/fs.h>
 #include <linux/io.h>
-#include <linux/slab.h>
-#include <linux/stop_machine.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -95,6 +93,17 @@ static phys_addr_t __init early_pgtable_
 	return phys;
 }
 
+static bool pgattr_change_is_safe(u64 old, u64 new)
+{
+	/*
+	 * The following mapping attributes may be updated in live
+	 * kernel mappings without the need for break-before-make.
+	 */
+	static const pteval_t mask = PTE_PXN | PTE_RDONLY | PTE_WRITE;
+
+	return old  == 0 || new  == 0 || ((old ^ new) & ~mask) == 0;
+}
+
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, unsigned long pfn,
 				  pgprot_t prot,
@@ -115,8 +124,17 @@ static void alloc_init_pte(pmd_t *pmd, u
 
 	pte = pte_set_fixmap_offset(pmd, addr);
 	do {
+		pte_t old_pte = *pte;
+
 		set_pte(pte, pfn_pte(pfn, prot));
 		pfn++;
+
+		/*
+		 * After the PTE entry has been populated once, we
+		 * only allow updates to the permission attributes.
+		 */
+		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
+
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	pte_clear_fixmap();
@@ -146,27 +164,27 @@ static void alloc_init_pmd(pud_t *pud, u
 
 	pmd = pmd_set_fixmap_offset(pud, addr);
 	do {
+		pmd_t old_pmd = *pmd;
+
 		next = pmd_addr_end(addr, end);
+
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0 &&
 		      allow_block_mappings) {
-			pmd_t old_pmd =*pmd;
 			pmd_set_huge(pmd, phys, prot);
+
 			/*
-			 * Check for previous table entries created during
-			 * boot (__create_page_tables) and flush them.
+			 * After the PMD entry has been populated once, we
+			 * only allow updates to the permission attributes.
 			 */
-			if (!pmd_none(old_pmd)) {
-				flush_tlb_all();
-				if (pmd_table(old_pmd)) {
-					phys_addr_t table = pmd_page_paddr(old_pmd);
-					if (!WARN_ON_ONCE(slab_is_available()))
-						memblock_free(table, PAGE_SIZE);
-				}
-			}
+			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
+						      pmd_val(*pmd)));
 		} else {
 			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
 				       prot, pgtable_alloc);
+
+			BUG_ON(pmd_val(old_pmd) != 0 &&
+			       pmd_val(old_pmd) != pmd_val(*pmd));
 		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
@@ -204,33 +222,28 @@ static void alloc_init_pud(pgd_t *pgd, u
 
 	pud = pud_set_fixmap_offset(pgd, addr);
 	do {
+		pud_t old_pud = *pud;
+
 		next = pud_addr_end(addr, end);
 
 		/*
 		 * For 4K granule only, attempt to put down a 1GB block
 		 */
 		if (use_1G_block(addr, next, phys) && allow_block_mappings) {
-			pud_t old_pud = *pud;
 			pud_set_huge(pud, phys, prot);
 
 			/*
-			 * If we have an old value for a pud, it will
-			 * be pointing to a pmd table that we no longer
-			 * need (from swapper_pg_dir).
-			 *
-			 * Look up the old pmd table and free it.
+			 * After the PUD entry has been populated once, we
+			 * only allow updates to the permission attributes.
 			 */
-			if (!pud_none(old_pud)) {
-				flush_tlb_all();
-				if (pud_table(old_pud)) {
-					phys_addr_t table = pud_page_paddr(old_pud);
-					if (!WARN_ON_ONCE(slab_is_available()))
-						memblock_free(table, PAGE_SIZE);
-				}
-			}
+			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
+						      pud_val(*pud)));
 		} else {
 			alloc_init_pmd(pud, addr, next, phys, prot,
 				       pgtable_alloc, allow_block_mappings);
+
+			BUG_ON(pud_val(old_pud) != 0 &&
+			       pud_val(old_pud) != pud_val(*pud));
 		}
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
@@ -396,6 +409,9 @@ void mark_rodata_ro(void)
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
 	create_mapping_late(__pa(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
+
+	/* flush the TLBs after updating live kernel mappings */
+	flush_tlb_all();
 }
 
 static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,


