Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EDA36C5E1
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhD0MNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 08:13:40 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:51116 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235410AbhD0MNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 08:13:39 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 33738400E1;
        Tue, 27 Apr 2021 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1619525576; bh=d7ROy3cYQCkmR+Q3KN4iMTu5vZ0ws556TwzYVn7dLrI=;
        h=From:To:Cc:Subject:Date:From;
        b=Wj2Oi1+HgAJ0wYHpXo+sNmYeO/Fh/zhanURxYvtXjbubvSbkrSikbqnksmGeP4+gK
         WT2BQsWNSKOyCNW31PSOuvSJ2V+UC/jKhAAwzMv2EKPYsV9dYHo1fX6vJUHyyVtiFf
         U222V+9BmwOWqXNttx7pvXS1IO8EQ4FeSJuEnl135/bmtfZXEDr9lHPp1Rf+swUtRA
         gZJxutv22tb6RUW3GB7zGBfcRjSYBU5zUIs/SXI2wiCoJ9l4iJKyACe0oTwprGSeFy
         2p0AVJqR1H4r/1ngFOEqr+WflbUPJrmhwcEVUjghFU7MblRxYjTQSxbkanWfwWklDX
         Uc1hdSwMgaO3w==
Received: from ru20arcgnu1.internal.synopsys.com (ru20arcgnu1.internal.synopsys.com [10.121.9.48])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6E34EA005E;
        Tue, 27 Apr 2021 12:12:52 +0000 (UTC)
X-SNPS-Relay: synopsys.com
From:   Vladimir Isaev <Vladimir.Isaev@synopsys.com>
To:     linux-snps-arc@lists.infradead.org
Cc:     linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rppt@linux.ibm.com,
        Vladimir Isaev <Vladimir.Isaev@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] ARC: Use 40-bit physical page mask for PAE
Date:   Tue, 27 Apr 2021 15:12:37 +0300
Message-Id: <20210427121237.2889-1-isaev@synopsys.com>
X-Mailer: git-send-email 2.16.2
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

32-bit PAGE_MASK can not be used as a mask for physical addresses
when PAE is enabled. PAGE_MASK_PHYS must be used for physical
addresses instead of PAGE_MASK.

Without this, init gets SIGSEGV if pte_modify was called:

potentially unexpected fatal signal 11.
Path: /bin/busybox
CPU: 0 PID: 1 Comm: init Not tainted 5.12.0-rc5-00003-g1e43c377a79f-dirty
Insn could not be fetched
    @No matching VMA found
ECR: 0x00040000 EFA: 0x00000000 ERET: 0x00000000
STAT: 0x80080082 [IE U     ]   BTA: 0x00000000
 SP: 0x5f9ffe44  FP: 0x00000000 BLK: 0xaf3d4
LPS: 0x000d093e LPE: 0x000d0950 LPC: 0x00000000
r00: 0x00000002 r01: 0x5f9fff14 r02: 0x5f9fff20
r03: 0x00000000 r04: 0x00000a48 r05: 0x001855b8
r06: 0x00186654 r07: 0x00010034 r08: 0x000000e2
r09: 0x00000007 r10: 0x00000000 r11: 0x00000000
r12: 0x00000000 r13: 0x00000001 r14: 0x00000002
r15: 0x5f9fff14 r16: 0x5f9fff20 r17: 0x001855d0
r18: 0x00000001 r19: 0x00000000 r20: 0x00000000
r21: 0x00000000 r22: 0x00000000 r23: 0x00000000
r24: 0x00000000 r25: 0x0018a488
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Signed-off-by: Vladimir Isaev <isaev@synopsys.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: stable@vger.kernel.org
---
Changes for v2:
 - PHYSICAL_PAGE_MASK -> PAGE_MASK_PHYS
 - off variable in ioremap_prot is now unsigned int and uses PAGE_MASK
 - Revised commit message
---
 arch/arc/include/asm/page.h      | 12 ++++++++++++
 arch/arc/include/asm/pgtable.h   | 12 +++---------
 arch/arc/include/uapi/asm/page.h |  1 -
 arch/arc/mm/ioremap.c            |  5 +++--
 arch/arc/mm/tlb.c                |  2 +-
 5 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index ad9b7fe4dba3..4a9d33372fe2 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -7,6 +7,18 @@
 
 #include <uapi/asm/page.h>
 
+#ifdef CONFIG_ARC_HAS_PAE40
+
+#define MAX_POSSIBLE_PHYSMEM_BITS	40
+#define PAGE_MASK_PHYS			(0xff00000000ull | PAGE_MASK)
+
+#else /* CONFIG_ARC_HAS_PAE40 */
+
+#define MAX_POSSIBLE_PHYSMEM_BITS	32
+#define PAGE_MASK_PHYS			PAGE_MASK
+
+#endif /* CONFIG_ARC_HAS_PAE40 */
+
 #ifndef __ASSEMBLY__
 
 #define clear_page(paddr)		memset((paddr), 0, PAGE_SIZE)
diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
index 163641726a2b..5878846f00cf 100644
--- a/arch/arc/include/asm/pgtable.h
+++ b/arch/arc/include/asm/pgtable.h
@@ -107,8 +107,8 @@
 #define ___DEF (_PAGE_PRESENT | _PAGE_CACHEABLE)
 
 /* Set of bits not changed in pte_modify */
-#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_SPECIAL)
-
+#define _PAGE_CHG_MASK	(PAGE_MASK_PHYS | _PAGE_ACCESSED | _PAGE_DIRTY | \
+							   _PAGE_SPECIAL)
 /* More Abbrevaited helpers */
 #define PAGE_U_NONE     __pgprot(___DEF)
 #define PAGE_U_R        __pgprot(___DEF | _PAGE_READ)
@@ -132,13 +132,7 @@
 #define PTE_BITS_IN_PD0		(_PAGE_GLOBAL | _PAGE_PRESENT | _PAGE_HW_SZ)
 #define PTE_BITS_RWX		(_PAGE_EXECUTE | _PAGE_WRITE | _PAGE_READ)
 
-#ifdef CONFIG_ARC_HAS_PAE40
-#define PTE_BITS_NON_RWX_IN_PD1	(0xff00000000 | PAGE_MASK | _PAGE_CACHEABLE)
-#define MAX_POSSIBLE_PHYSMEM_BITS 40
-#else
-#define PTE_BITS_NON_RWX_IN_PD1	(PAGE_MASK | _PAGE_CACHEABLE)
-#define MAX_POSSIBLE_PHYSMEM_BITS 32
-#endif
+#define PTE_BITS_NON_RWX_IN_PD1	(PAGE_MASK_PHYS | _PAGE_CACHEABLE)
 
 /**************************************************************************
  * Mapping of vm_flags (Generic VM) to PTE flags (arch specific)
diff --git a/arch/arc/include/uapi/asm/page.h b/arch/arc/include/uapi/asm/page.h
index 2a97e2718a21..2a4ad619abfb 100644
--- a/arch/arc/include/uapi/asm/page.h
+++ b/arch/arc/include/uapi/asm/page.h
@@ -33,5 +33,4 @@
 
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-
 #endif /* _UAPI__ASM_ARC_PAGE_H */
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
index fac4adc90204..95c649fbc95a 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -53,9 +53,10 @@ EXPORT_SYMBOL(ioremap);
 void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
 			   unsigned long flags)
 {
+	unsigned int off;
 	unsigned long vaddr;
 	struct vm_struct *area;
-	phys_addr_t off, end;
+	phys_addr_t end;
 	pgprot_t prot = __pgprot(flags);
 
 	/* Don't allow wraparound, zero size */
@@ -72,7 +73,7 @@ void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
 
 	/* Mappings have to be page-aligned */
 	off = paddr & ~PAGE_MASK;
-	paddr &= PAGE_MASK;
+	paddr &= PAGE_MASK_PHYS;
 	size = PAGE_ALIGN(end + 1) - paddr;
 
 	/*
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index 9bb3c24f3677..9c7c68247289 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -576,7 +576,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr_unaligned,
 		      pte_t *ptep)
 {
 	unsigned long vaddr = vaddr_unaligned & PAGE_MASK;
-	phys_addr_t paddr = pte_val(*ptep) & PAGE_MASK;
+	phys_addr_t paddr = pte_val(*ptep) & PAGE_MASK_PHYS;
 	struct page *page = pfn_to_page(pte_pfn(*ptep));
 
 	create_tlb(vma, vaddr, ptep);
-- 
2.16.2

