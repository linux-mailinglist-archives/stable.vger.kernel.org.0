Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6F1F2BE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfEOMGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729362AbfEOLKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F312168B;
        Wed, 15 May 2019 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918609;
        bh=CX3+NgyXHWJ/A5jbSUuIf6vviov4VbQA1rAfKKbRaXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCD+vYCJ8Q/MUyGp7E2c3+W6X3rJEtkzaHruetcDJ3U7xG6HI3zV2HUHz6KCnMMBT
         iaFItEGXD0MbKrVFHtc1wPBygMACaq8oiYb3milQ0We72/ZfBfMzdykJygMePEPro1
         upSPtTwVZdig3ZdXwbD9ZiynErqoYOow/8DuFa+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 197/266] x86/mm: Use WRITE_ONCE() when setting PTEs
Date:   Wed, 15 May 2019 12:55:04 +0200
Message-Id: <20190515090729.610153491@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 9bc4f28af75a91aea0ae383f50b0a430c4509303 upstream.

When page-table entries are set, the compiler might optimize their
assignment by using multiple instructions to set the PTE. This might
turn into a security hazard if the user somehow manages to use the
interim PTE. L1TF does not make our lives easier, making even an interim
non-present PTE a security hazard.

Using WRITE_ONCE() to set PTEs and friends should prevent this potential
security hazard.

I skimmed the differences in the binary with and without this patch. The
differences are (obviously) greater when CONFIG_PARAVIRT=n as more
code optimizations are possible. For better and worse, the impact on the
binary with this patch is pretty small. Skimming the code did not cause
anything to jump out as a security hazard, but it seems that at least
move_soft_dirty_pte() caused set_pte_at() to use multiple writes.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Link: https://lkml.kernel.org/r/20180902181451.80520-1-namit@vmware.com
[bwh: Backported to 4.4:
 - Drop changes in pmdp_establish(), native_set_p4d(), pudp_set_access_flags()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable_64.h |   16 ++++++++--------
 arch/x86/mm/pgtable.c             |    6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -44,15 +44,15 @@ struct mm_struct;
 void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte);
 
 
-static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
-				    pte_t *ptep)
+static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
-	*ptep = native_make_pte(0);
+	WRITE_ONCE(*ptep, pte);
 }
 
-static inline void native_set_pte(pte_t *ptep, pte_t pte)
+static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
 {
-	*ptep = pte;
+	native_set_pte(ptep, native_make_pte(0));
 }
 
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
@@ -62,7 +62,7 @@ static inline void native_set_pte_atomic
 
 static inline void native_set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-	*pmdp = pmd;
+	WRITE_ONCE(*pmdp, pmd);
 }
 
 static inline void native_pmd_clear(pmd_t *pmd)
@@ -98,7 +98,7 @@ static inline pmd_t native_pmdp_get_and_
 
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
-	*pudp = pud;
+	WRITE_ONCE(*pudp, pud);
 }
 
 static inline void native_pud_clear(pud_t *pud)
@@ -131,7 +131,7 @@ static inline pgd_t *native_get_shadow_p
 
 static inline void native_set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
-	*pgdp = kaiser_set_shadow_pgd(pgdp, pgd);
+	WRITE_ONCE(*pgdp, kaiser_set_shadow_pgd(pgdp, pgd));
 }
 
 static inline void native_pgd_clear(pgd_t *pgd)
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -247,7 +247,7 @@ static void pgd_mop_up_pmds(struct mm_st
 		if (pgd_val(pgd) != 0) {
 			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
 
-			pgdp[i] = native_make_pgd(0);
+			pgd_clear(&pgdp[i]);
 
 			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
 			pmd_free(mm, pmd);
@@ -424,7 +424,7 @@ int ptep_set_access_flags(struct vm_area
 	int changed = !pte_same(*ptep, entry);
 
 	if (changed && dirty) {
-		*ptep = entry;
+		set_pte(ptep, entry);
 		pte_update_defer(vma->vm_mm, address, ptep);
 	}
 
@@ -441,7 +441,7 @@ int pmdp_set_access_flags(struct vm_area
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	if (changed && dirty) {
-		*pmdp = entry;
+		set_pmd(pmdp, entry);
 		pmd_update_defer(vma->vm_mm, address, pmdp);
 		/*
 		 * We had a write-protection fault here and changed the pmd


