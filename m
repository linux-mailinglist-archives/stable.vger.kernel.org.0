Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF85451E0A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352297AbhKPAey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344496AbhKOTYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F347D6044F;
        Mon, 15 Nov 2021 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002728;
        bh=p/bBHOzMnYHbXloJE5bVdMu+tYIQkFKk6pqC4oMgdXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOggkLCM/gYJrZ/xYOeV0O7Y7yLIAcrmey8+c1b0EZqMfVsxRc0ECFJ2uYP81oMVN
         SRmevGvv8Xrq3KTATdsrFJCxvHV9kcuJzLIF9vC8btL2EHZnJGf9z28dkjJyYC8fJT
         oY4+cN/n441pw2TUz66ll+YJ/QqJro4E5luXaVcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 676/917] powerpc/nohash: Fix __ptep_set_access_flags() and ptep_set_wrprotect()
Date:   Mon, 15 Nov 2021 18:02:51 +0100
Message-Id: <20211115165451.812322052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit b1b93cb7e794e914787bf7d9936b57a149cdee4f ]

Commit 26973fa5ac0e ("powerpc/mm: use pte helpers in generic code")
changed those two functions to use pte helpers to determine which
bits to clear and which bits to set.

This change was based on the assumption that bits to be set/cleared
are always the same and can be determined by applying the pte
manipulation helpers on __pte(0).

But on platforms like book3e, the bits depend on whether the page
is a user page or not.

For the time being it more or less works because of _PAGE_EXEC being
used for user pages only and exec right being set at all time on
kernel page. But following patch will clean that and output of
pte_mkexec() will depend on the page being a user or kernel page.

Instead of trying to make an even more complicated helper where bits
would become dependent on the final pte value, come back to a more
static situation like before commit 26973fa5ac0e ("powerpc/mm: use
pte helpers in generic code"), by introducing an 8xx specific
version of __ptep_set_access_flags() and ptep_set_wrprotect().

Fixes: 26973fa5ac0e ("powerpc/mm: use pte helpers in generic code")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/922bdab3a220781bae2360ff3dd5adb7fe4d34f1.1635226743.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pgtable.h | 17 +++++++--------
 arch/powerpc/include/asm/nohash/32/pte-8xx.h | 22 ++++++++++++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/nohash/32/pgtable.h b/arch/powerpc/include/asm/nohash/32/pgtable.h
index f06ae00f2a65e..ac0a5ff48c3ad 100644
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -306,30 +306,29 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
+#ifndef ptep_set_wrprotect
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	unsigned long clr = ~pte_val(pte_wrprotect(__pte(~0)));
-	unsigned long set = pte_val(pte_wrprotect(__pte(0)));
-
-	pte_update(mm, addr, ptep, clr, set, 0);
+	pte_update(mm, addr, ptep, _PAGE_RW, 0, 0);
 }
+#endif
 
+#ifndef __ptep_set_access_flags
 static inline void __ptep_set_access_flags(struct vm_area_struct *vma,
 					   pte_t *ptep, pte_t entry,
 					   unsigned long address,
 					   int psize)
 {
-	pte_t pte_set = pte_mkyoung(pte_mkdirty(pte_mkwrite(pte_mkexec(__pte(0)))));
-	pte_t pte_clr = pte_mkyoung(pte_mkdirty(pte_mkwrite(pte_mkexec(__pte(~0)))));
-	unsigned long set = pte_val(entry) & pte_val(pte_set);
-	unsigned long clr = ~pte_val(entry) & ~pte_val(pte_clr);
+	unsigned long set = pte_val(entry) &
+			    (_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
 	int huge = psize > mmu_virtual_psize ? 1 : 0;
 
-	pte_update(vma->vm_mm, address, ptep, clr, set, huge);
+	pte_update(vma->vm_mm, address, ptep, 0, set, huge);
 
 	flush_tlb_page(vma, address);
 }
+#endif
 
 static inline int pte_young(pte_t pte)
 {
diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index fcc48d590d888..1a89ebdc3acc9 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -136,6 +136,28 @@ static inline pte_t pte_mkhuge(pte_t pte)
 
 #define pte_mkhuge pte_mkhuge
 
+static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, pte_t *p,
+				     unsigned long clr, unsigned long set, int huge);
+
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_update(mm, addr, ptep, 0, _PAGE_RO, 0);
+}
+#define ptep_set_wrprotect ptep_set_wrprotect
+
+static inline void __ptep_set_access_flags(struct vm_area_struct *vma, pte_t *ptep,
+					   pte_t entry, unsigned long address, int psize)
+{
+	unsigned long set = pte_val(entry) & (_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_EXEC);
+	unsigned long clr = ~pte_val(entry) & _PAGE_RO;
+	int huge = psize > mmu_virtual_psize ? 1 : 0;
+
+	pte_update(vma->vm_mm, address, ptep, clr, set, huge);
+
+	flush_tlb_page(vma, address);
+}
+#define __ptep_set_access_flags __ptep_set_access_flags
+
 static inline unsigned long pgd_leaf_size(pgd_t pgd)
 {
 	if (pgd_val(pgd) & _PMD_PAGE_8M)
-- 
2.33.0



