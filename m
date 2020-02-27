Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8A4171C15
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388272AbgB0OIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388268AbgB0OIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:08:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5367924697;
        Thu, 27 Feb 2020 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812515;
        bh=cX2MjCzWKPYkIQ0+jMchJDpZqpV5ZTe8WmRQ/EV9tLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofiNe8l+oZ55TVF/Ueh6XTLSKKgOmypySUrKsD20ZxcmEewn5f2BBVBNewxj5u8kB
         04l8B7GLP3/eZizkQE3kxVKPns87kzespJZOOjSAK6DGA/6tfvUr91BKkbaTyWzu/n
         hKf6o1s2BGmR/ddSv/MzGVaH5uosnCV6LsrFbbeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 047/135] powerpc/hugetlb: Fix 512k hugepages on 8xx with 16k page size
Date:   Thu, 27 Feb 2020 14:36:27 +0100
Message-Id: <20200227132236.128376395@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit f2b67ef90b0d5eca0f2255e02cf2f620bc0ddcdb upstream.

Commit 55c8fc3f4930 ("powerpc/8xx: reintroduce 16K pages with HW
assistance") redefined pte_t as a struct of 4 pte_basic_t, because
in 16K pages mode there are four identical entries in the
page table. But the size of hugepage tables is calculated based
of the size of (void *). Therefore, we end up with page tables
of size 1k instead of 4k for 512k pages.

As 512k hugepage tables are the same size as standard page tables,
ie 4k, use the standard page tables instead of PGT_CACHE tables.

Fixes: 3fb69c6a1a13 ("powerpc/8xx: Enable 512k hugepage support with HW assistance")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/90ec56a2315be602494619ed0223bba3b0b8d619.1580997007.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hugetlbpage.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -53,20 +53,24 @@ static int __hugepte_alloc(struct mm_str
 	if (pshift >= pdshift) {
 		cachep = PGT_CACHE(PTE_T_ORDER);
 		num_hugepd = 1 << (pshift - pdshift);
+		new = NULL;
 	} else if (IS_ENABLED(CONFIG_PPC_8xx)) {
-		cachep = PGT_CACHE(PTE_INDEX_SIZE);
+		cachep = NULL;
 		num_hugepd = 1;
+		new = pte_alloc_one(mm);
 	} else {
 		cachep = PGT_CACHE(pdshift - pshift);
 		num_hugepd = 1;
+		new = NULL;
 	}
 
-	if (!cachep) {
+	if (!cachep && !new) {
 		WARN_ONCE(1, "No page table cache created for hugetlb tables");
 		return -ENOMEM;
 	}
 
-	new = kmem_cache_alloc(cachep, pgtable_gfp_flags(mm, GFP_KERNEL));
+	if (cachep)
+		new = kmem_cache_alloc(cachep, pgtable_gfp_flags(mm, GFP_KERNEL));
 
 	BUG_ON(pshift > HUGEPD_SHIFT_MASK);
 	BUG_ON((unsigned long)new & HUGEPD_SHIFT_MASK);
@@ -97,7 +101,10 @@ static int __hugepte_alloc(struct mm_str
 	if (i < num_hugepd) {
 		for (i = i - 1 ; i >= 0; i--, hpdp--)
 			*hpdp = __hugepd(0);
-		kmem_cache_free(cachep, new);
+		if (cachep)
+			kmem_cache_free(cachep, new);
+		else
+			pte_free(mm, new);
 	} else {
 		kmemleak_ignore(new);
 	}
@@ -324,8 +331,7 @@ static void free_hugepd_range(struct mmu
 	if (shift >= pdshift)
 		hugepd_free(tlb, hugepte);
 	else if (IS_ENABLED(CONFIG_PPC_8xx))
-		pgtable_free_tlb(tlb, hugepte,
-				 get_hugepd_cache_index(PTE_INDEX_SIZE));
+		pgtable_free_tlb(tlb, hugepte, 0);
 	else
 		pgtable_free_tlb(tlb, hugepte,
 				 get_hugepd_cache_index(pdshift - shift));
@@ -639,12 +645,13 @@ static int __init hugetlbpage_init(void)
 		 * if we have pdshift and shift value same, we don't
 		 * use pgt cache for hugepd.
 		 */
-		if (pdshift > shift && IS_ENABLED(CONFIG_PPC_8xx))
-			pgtable_cache_add(PTE_INDEX_SIZE);
-		else if (pdshift > shift)
-			pgtable_cache_add(pdshift - shift);
-		else if (IS_ENABLED(CONFIG_PPC_FSL_BOOK3E) || IS_ENABLED(CONFIG_PPC_8xx))
+		if (pdshift > shift) {
+			if (!IS_ENABLED(CONFIG_PPC_8xx))
+				pgtable_cache_add(pdshift - shift);
+		} else if (IS_ENABLED(CONFIG_PPC_FSL_BOOK3E) ||
+			   IS_ENABLED(CONFIG_PPC_8xx)) {
 			pgtable_cache_add(PTE_T_ORDER);
+		}
 
 		configured = true;
 	}


