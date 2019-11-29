Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC410D2E8
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfK2JE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 04:04:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:54006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfK2JE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 04:04:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8F0EB259;
        Fri, 29 Nov 2019 09:04:23 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ajay Kaher <akaher@vmware.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.9 1/1] mm, gup: add missing refcount overflow checks on x86 and s390
Date:   Fri, 29 Nov 2019 10:03:49 +0100
Message-Id: <20191129090351.3507-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191129090351.3507-1-vbabka@suse.cz>
References: <20191129090351.3507-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/s390/mm/gup.c |  9 ++++++---
 arch/x86/mm/gup.c  | 10 ++++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 97fc449a7470..33a940389a6d 100644
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
index d7db45bdfb3b..551fc7fea046 100644
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
2.24.0

