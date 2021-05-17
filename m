Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A213830BA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhEQOaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239288AbhEQO2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECF4861582;
        Mon, 17 May 2021 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260856;
        bh=ayrtXFfexLm21Ax+2aCcvnfelywZrTIyJQle+XrJDzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwvUKNNbJZU3QwkHpxJFPObUd9p/8j72lpJfgbExLdbG0+DJxBy0nlSEzMtrv3bJ4
         nx3rLtXpi0kG5cp+BQ1PBQlQx3dvzd8x0/jgs34F/dDqZsv/oEtf7h5OpDWdQdywo5
         xgiEWu9xBOxXg8AVXzZkoC6iCkSZkSPD9Boq7YiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Isaev <isaev@synopsys.com>,
        kernel test robot <lkp@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.12 249/363] ARC: mm: PAE: use 40-bit physical page mask
Date:   Mon, 17 May 2021 16:01:55 +0200
Message-Id: <20210517140311.008721558@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Isaev <isaev@synopsys.com>

commit c5f756d8c6265ebb1736a7787231f010a3b782e5 upstream.

32-bit PAGE_MASK can not be used as a mask for physical addresses
when PAE is enabled. PAGE_MASK_PHYS must be used for physical
addresses instead of PAGE_MASK.

Without this, init gets SIGSEGV if pte_modify was called:

| potentially unexpected fatal signal 11.
| Path: /bin/busybox
| CPU: 0 PID: 1 Comm: init Not tainted 5.12.0-rc5-00003-g1e43c377a79f-dirty
| Insn could not be fetched
|     @No matching VMA found
|  ECR: 0x00040000 EFA: 0x00000000 ERET: 0x00000000
| STAT: 0x80080082 [IE U     ]   BTA: 0x00000000
|  SP: 0x5f9ffe44  FP: 0x00000000 BLK: 0xaf3d4
| LPS: 0x000d093e LPE: 0x000d0950 LPC: 0x00000000
| r00: 0x00000002 r01: 0x5f9fff14 r02: 0x5f9fff20
| ...
| Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Signed-off-by: Vladimir Isaev <isaev@synopsys.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/page.h      |   12 ++++++++++++
 arch/arc/include/asm/pgtable.h   |   12 +++---------
 arch/arc/include/uapi/asm/page.h |    1 -
 arch/arc/mm/ioremap.c            |    5 +++--
 arch/arc/mm/tlb.c                |    2 +-
 5 files changed, 19 insertions(+), 13 deletions(-)

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
--- a/arch/arc/include/uapi/asm/page.h
+++ b/arch/arc/include/uapi/asm/page.h
@@ -33,5 +33,4 @@
 
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-
 #endif /* _UAPI__ASM_ARC_PAGE_H */
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
@@ -72,7 +73,7 @@ void __iomem *ioremap_prot(phys_addr_t p
 
 	/* Mappings have to be page-aligned */
 	off = paddr & ~PAGE_MASK;
-	paddr &= PAGE_MASK;
+	paddr &= PAGE_MASK_PHYS;
 	size = PAGE_ALIGN(end + 1) - paddr;
 
 	/*
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -576,7 +576,7 @@ void update_mmu_cache(struct vm_area_str
 		      pte_t *ptep)
 {
 	unsigned long vaddr = vaddr_unaligned & PAGE_MASK;
-	phys_addr_t paddr = pte_val(*ptep) & PAGE_MASK;
+	phys_addr_t paddr = pte_val(*ptep) & PAGE_MASK_PHYS;
 	struct page *page = pfn_to_page(pte_pfn(*ptep));
 
 	create_tlb(vma, vaddr, ptep);


