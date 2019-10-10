Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88B6D25AC
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388153AbfJJIkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387545AbfJJIkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F1220B7C;
        Thu, 10 Oct 2019 08:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696841;
        bh=y2bEQBdf2i+65jKxhqGXFchMma96qIpxAeXE0iW0uOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnQtQx3qDS+J3joXAziQevLwnEksmf6rQNHk2L0kZ9/zyhmsfU+/WTqgSgfdCPWqD
         998po47xJS5sLGuPIJznijFAn1zSC4sLmQcDoEqjzeMvIWkiabl0Mhs9XM2tFvNtaw
         XBsjW28k6nnDnRXkEAFUzcb5w2LxrJZuxcFMUIk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 035/148] powerpc/mm: Fix an Oops in kasan_mmu_init()
Date:   Thu, 10 Oct 2019 10:34:56 +0200
Message-Id: <20191010083613.280565075@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit cbd18991e24fea2c31da3bb117c83e4a3538cd11 upstream.

Uncompressing Kernel Image ... OK
   Loading Device Tree to 01ff7000, end 01fff74f ... OK
[    0.000000] printk: bootconsole [udbg0] enabled
[    0.000000] BUG: Unable to handle kernel data access at 0xf818c000
[    0.000000] Faulting instruction address: 0xc0013c7c
[    0.000000] Thread overran stack, or stack corrupted
[    0.000000] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.000000] BE PAGE_SIZE=16K PREEMPT
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.3.0-rc4-s3k-dev-00743-g5abe4a3e8fd3-dirty #2080
[    0.000000] NIP:  c0013c7c LR: c0013310 CTR: 00000000
[    0.000000] REGS: c0c5ff38 TRAP: 0300   Not tainted  (5.3.0-rc4-s3k-dev-00743-g5abe4a3e8fd3-dirty)
[    0.000000] MSR:  00001032 <ME,IR,DR,RI>  CR: 99033955  XER: 80002100
[    0.000000] DAR: f818c000 DSISR: 82000000
[    0.000000] GPR00: c0013310 c0c5fff0 c0ad6ac0 c0c600c0 f818c031 82000000 00000000 ffffffff
[    0.000000] GPR08: 00000000 f1f1f1f1 c0013c2c c0013304 99033955 00400008 00000000 07ff9598
[    0.000000] GPR16: 00000000 07ffb94c 00000000 00000000 00000000 00000000 00000000 f818cfb2
[    0.000000] GPR24: 00000000 00000000 00001000 ffffffff 00000000 c07dbf80 00000000 f818c000
[    0.000000] NIP [c0013c7c] do_page_fault+0x50/0x904
[    0.000000] LR [c0013310] handle_page_fault+0xc/0x38
[    0.000000] Call Trace:
[    0.000000] Instruction dump:
[    0.000000] be010080 91410014 553fe8fe 3d40c001 3d20f1f1 7d800026 394a3c2c 3fffe000
[    0.000000] 6129f1f1 900100c4 9181007c 91410018 <913f0000> 3d2001f4 6129f4f4 913f0004

Don't map the early shadow page read-only yet when creating the new
page tables for the real shadow memory, otherwise the memblock
allocations that immediately follows to create the real shadow pages
that are about to replace the early shadow page trigger a page fault
if they fall into the region being worked on at the moment.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fe86886fb8db44360417cee0dc515ad47ca6ef72.1566382750.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/kasan/kasan_init_32.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -34,7 +34,7 @@ static int __ref kasan_init_shadow_page_
 {
 	pmd_t *pmd;
 	unsigned long k_cur, k_next;
-	pgprot_t prot = kasan_prot_ro();
+	pgprot_t prot = slab_is_available() ? kasan_prot_ro() : PAGE_KERNEL;
 
 	pmd = pmd_offset(pud_offset(pgd_offset_k(k_start), k_start), k_start);
 
@@ -110,9 +110,22 @@ static int __ref kasan_init_region(void
 static void __init kasan_remap_early_shadow_ro(void)
 {
 	pgprot_t prot = kasan_prot_ro();
+	unsigned long k_start = KASAN_SHADOW_START;
+	unsigned long k_end = KASAN_SHADOW_END;
+	unsigned long k_cur;
+	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
 	kasan_populate_pte(kasan_early_shadow_pte, prot);
 
+	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
+		pmd_t *pmd = pmd_offset(pud_offset(pgd_offset_k(k_cur), k_cur), k_cur);
+		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
+
+		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
+			continue;
+
+		__set_pte_at(&init_mm, k_cur, ptep, pfn_pte(PHYS_PFN(pa), prot), 0);
+	}
 	flush_tlb_kernel_range(KASAN_SHADOW_START, KASAN_SHADOW_END);
 }
 


