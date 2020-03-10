Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74F217FEB5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCJMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgCJMl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D9924691;
        Tue, 10 Mar 2020 12:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844116;
        bh=LLaSdrmZ9Iz2pk+3jQlRiMdI3hBI5As06AGko4bF3m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZwK/4utbhoGJ18Nk/P1fcKxr+DZDsM4VtLlvct7nasy/Sc96mvrcdp1tPQoP7Xdd
         mW2Est42lbkhT2P4KdM2ICqJNWmlRrysoYFxw6vYgoQ21cfrJAUpG+L0z27gHX840M
         2OCn79IQVC8BmWw0Dx8o8Z944bwppSwgILpNzuLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4.4 36/72] mm: prevent get_user_pages() from overflowing page refcount
Date:   Tue, 10 Mar 2020 13:38:49 +0100
Message-Id: <20200310123610.209767863@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8fde12ca79aff9b5ba951fce1a2641901b8d8e64 upstream.

If the page refcount wraps around past zero, it will be freed while
there are still four billion references to it.  One of the possible
avenues for an attacker to try to make this happen is by doing direct IO
on a page multiple times.  This patch makes get_user_pages() refuse to
take a new page reference if there are already more than two billion
references to the page.

Reported-by: Jann Horn <jannh@google.com>
Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ 4.4.y backport notes:
  Ajay:     - Added local variable 'err' with-in follow_hugetlb_page()
              from 2be7cfed995e, to resolve compilation error
            - Added page_ref_count()
            - Added missing refcount overflow checks on x86 and s390
              (Vlastimil, thanks for this change)
  Srivatsa: - Replaced call to get_page_foll() with try_get_page_foll() ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/gup.c |    6 ++++--
 arch/x86/mm/gup.c  |    9 ++++++++-
 include/linux/mm.h |    5 +++++
 mm/gup.c           |   42 +++++++++++++++++++++++++++++++++---------
 mm/hugetlb.c       |   16 +++++++++++++++-
 5 files changed, 65 insertions(+), 13 deletions(-)

--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -37,7 +37,8 @@ static inline int gup_pte_range(pmd_t *p
 			return 0;
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		if (!page_cache_get_speculative(page))
+		if (WARN_ON_ONCE(page_ref_count(page) < 0)
+		    || !page_cache_get_speculative(page))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(page);
@@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pm
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
 	}
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -95,7 +95,10 @@ static noinline int gup_pte_range(pmd_t
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		get_page(page);
+		if (unlikely(!try_get_page(page))) {
+			pte_unmap(ptep);
+			return 0;
+		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
@@ -132,6 +135,8 @@ static noinline int gup_huge_pmd(pmd_t p
 
 	refs = 0;
 	head = pmd_page(pmd);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
@@ -208,6 +213,8 @@ static noinline int gup_huge_pud(pud_t p
 
 	refs = 0;
 	head = pud_page(pud);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -488,6 +488,11 @@ static inline void get_huge_page_tail(st
 
 extern bool __get_page_tail(struct page *page);
 
+static inline int page_ref_count(struct page *page)
+{
+	return atomic_read(&page->_count);
+}
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) atomic_read(&page->_count) + 127u <= 127u)
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -126,8 +126,12 @@ retry:
 		}
 	}
 
-	if (flags & FOLL_GET)
-		get_page_foll(page);
+	if (flags & FOLL_GET) {
+		if (unlikely(!try_get_page_foll(page))) {
+			page = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -289,7 +293,10 @@ static int get_gate_page(struct mm_struc
 			goto unmap;
 		*page = pte_page(*pte);
 	}
-	get_page(*page);
+	if (unlikely(!try_get_page(*page))) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
 out:
 	ret = 0;
 unmap:
@@ -1053,6 +1060,20 @@ struct page *get_dump_page(unsigned long
  */
 #ifdef CONFIG_HAVE_GENERIC_RCU_GUP
 
+/*
+ * Return the compund head page with ref appropriately incremented,
+ * or NULL if that failed.
+ */
+static inline struct page *try_get_compound_head(struct page *page, int refs)
+{
+	struct page *head = compound_head(page);
+	if (WARN_ON_ONCE(atomic_read(&head->_count) < 0))
+		return NULL;
+	if (unlikely(!page_cache_add_speculative(head, refs)))
+		return NULL;
+	return head;
+}
+
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 int write, struct page **pages, int *nr)
@@ -1083,6 +1104,9 @@ static int gup_pte_range(pmd_t pmd, unsi
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
+		if (WARN_ON_ONCE(page_ref_count(page) < 0))
+			goto pte_unmap;
+
 		if (!page_cache_get_speculative(page))
 			goto pte_unmap;
 
@@ -1139,8 +1163,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pmd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pmd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1185,8 +1209,8 @@ static int gup_huge_pud(pud_t orig, pud_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pud_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pud_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1227,8 +1251,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pgd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pgd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3886,6 +3886,7 @@ long follow_hugetlb_page(struct mm_struc
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
+	int err = -EFAULT;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -3957,6 +3958,19 @@ long follow_hugetlb_page(struct mm_struc
 
 		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
 		page = pte_page(huge_ptep_get(pte));
+
+		/*
+		 * Instead of doing 'try_get_page_foll()' below in the same_page
+		 * loop, just check the count once here.
+		 */
+		if (unlikely(page_count(page) <= 0)) {
+			if (pages) {
+				spin_unlock(ptl);
+				remainder = 0;
+				err = -ENOMEM;
+				break;
+			}
+		}
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
@@ -3983,7 +3997,7 @@ same_page:
 	*nr_pages = remainder;
 	*position = vaddr;
 
-	return i ? i : -EFAULT;
+	return i ? i : err;
 }
 
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,


