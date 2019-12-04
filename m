Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892F0113301
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbfLDSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbfLDSNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:13:50 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3C2F206DF;
        Wed,  4 Dec 2019 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483229;
        bh=osEXV0FwrCCNyBYKCk+cgRyj4+wj5wEU5wmwMpQtlF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTiyjsHcCU/Q0B8WAN5Oe2SEDW/Eh9wrz6Su+2AnnmxDQq9Ltnzc9mCmj2Z4PcUAP
         cBOuevAivn57SY42cS+/KnuuW0RfPUVTZkyvTVpZu0Rao4C/NWiMrE5aQ1RpGvPKmn
         iJa/sFgcaGkquvnRhKwZw9HhXToOO8EbAby02Tuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/125] mm, gup: add missing refcount overflow checks on x86 and s390
Date:   Wed,  4 Dec 2019 18:56:50 +0100
Message-Id: <20191204175325.500930880@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
overflowing page refcount") was backported to 4.9.y stable as commit
2ed768cfd895. The backport however missed that in 4.9, there are several
arch-specific gup.c versions with fast gup implementations, so these do not
prevent refcount overflow.

This is partially fixed for x86 in stable-only commit d73af79742e7 ("x86, mm,
gup: prevent get_page() race with munmap in paravirt guest"). This stable-only
commit adds missing parts to x86 version, as well as s390 version, both taken
from the SUSE SLES/openSUSE 4.12-based kernels.

The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
problem for those architectures, and I don't feel confident enough to patch
them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gup.c |  9 ++++++---
 arch/x86/mm/gup.c  | 10 ++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 97fc449a74707..33a940389a6d1 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -38,7 +38,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
+		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+		    || !page_cache_get_speculative(head)))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(head);
@@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
@@ -150,7 +152,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index d7db45bdfb3bd..551fc7fea046d 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -202,10 +202,12 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
 			undo_dev_pagemap(nr, nr_start, pages);
 			return 0;
 		}
+		if (unlikely(!try_get_page(page))) {
+			put_dev_pagemap(pgmap);
+			return 0;
+		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
-		get_page(page);
-		put_dev_pagemap(pgmap);
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
@@ -230,6 +232,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 
 	refs = 0;
 	head = pmd_page(pmd);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
@@ -289,6 +293,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 
 	refs = 0;
 	head = pud_page(pud);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-- 
2.20.1



