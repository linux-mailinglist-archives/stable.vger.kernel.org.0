Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768C910D2E6
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 10:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfK2JE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 04:04:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:54004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbfK2JEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 04:04:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B91E6B271;
        Fri, 29 Nov 2019 09:04:23 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ajay Kaher <akaher@vmware.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.14] mm, gup: add missing refcount overflow checks on s390
Date:   Fri, 29 Nov 2019 10:03:50 +0100
Message-Id: <20191129090351.3507-3-vbabka@suse.cz>
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
overflowing page refcount") was backported to 4.14.y stable as commit
04198de24771. The backport however missed that in 4.14, there are several
arch-specific gup.c versions with fast gup implementations, so these do not
prevent refcount overflow.

This stable-only commit fixes the s390 version, and is based on the backport in
SUSE SLES/openSUSE 4.12-based kernels.

The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
problem for those architectures, and I don't feel confident enough to patch
them.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 arch/s390/mm/gup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 05c8abd864f1..9bce54eac0b0 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -39,7 +39,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		head = compound_head(page);
-		if (!page_cache_get_speculative(head))
+		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+		    || !page_cache_get_speculative(head)))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(head);
@@ -77,7 +78,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
@@ -151,7 +153,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
-- 
2.24.0

