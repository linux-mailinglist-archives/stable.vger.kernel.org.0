Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22434F4392
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfKHJik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:39622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730221AbfKHJi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B32AAD77;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.4 5/8] mm: prevent get_user_pages() from overflowing page refcount
Date:   Fri,  8 Nov 2019 10:38:11 +0100
Message-Id: <20191108093814.16032-6-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108093814.16032-1-vbabka@suse.cz>
References: <20191108093814.16032-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8fde12ca79aff9b5ba951fce1a2641901b8d8e64 upstream.

[ 4.4 backport: there's get_page_foll(), so add try_get_page()-like checks
                in there, enabled by a new parameter, which is false where
                upstream patch doesn't replace get_page() with try_get_page()
                (the THP and hugetlb callers).
		In gup_pte_range(), we don't expect tail pages, so just check
                page ref count instead of try_get_compound_head()
		Also patch arch-specific variants of gup.c for x86 and s390,
		leaving mips, sh, sparc alone				      ]

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
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 arch/s390/mm/gup.c |  6 ++++--
 arch/x86/mm/gup.c  |  9 ++++++++-
 mm/gup.c           | 39 +++++++++++++++++++++++++++++++--------
 mm/huge_memory.c   |  2 +-
 mm/hugetlb.c       | 18 ++++++++++++++++--
 mm/internal.h      | 12 +++++++++---
 6 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 7ad41be8b373..bdaa5f7b652c 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -37,7 +37,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 			return 0;
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		if (!page_cache_get_speculative(page))
+		if (unlikely(WARN_ON_ONCE(page_ref_count(page) < 0)
+		    || !page_cache_get_speculative(page)))
 			return 0;
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_page(page);
@@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
+	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
+	    || !page_cache_add_speculative(head, refs))) {
 		*nr -= refs;
 		return 0;
 	}
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 7d2542ad346a..6612d532e42e 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -95,7 +95,10 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
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
@@ -132,6 +135,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 
 	refs = 0;
 	head = pmd_page(pmd);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
@@ -208,6 +213,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 
 	refs = 0;
 	head = pud_page(pud);
+	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
+		return 0;
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
diff --git a/mm/gup.c b/mm/gup.c
index 71e9d0093a35..fc8e2dca99fc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -127,7 +127,10 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 
 	if (flags & FOLL_GET)
-		get_page_foll(page);
+		if (!get_page_foll(page, true)) {
+			page = ERR_PTR(-ENOMEM);
+			goto out;
+		}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -289,7 +292,10 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
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
@@ -1053,6 +1059,20 @@ struct page *get_dump_page(unsigned long addr)
  */
 #ifdef CONFIG_HAVE_GENERIC_RCU_GUP
 
+/*
+ * Return the compund head page with ref appropriately incremented,
+ * or NULL if that failed.
+ */
+static inline struct page *try_get_compound_head(struct page *page, int refs)
+{
+	struct page *head = compound_head(page);
+	if (WARN_ON_ONCE(page_ref_count(head) < 0))
+		return NULL;
+	if (unlikely(!page_cache_add_speculative(head, refs)))
+		return NULL;
+	return head;
+}
+
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 int write, struct page **pages, int *nr)
@@ -1083,6 +1103,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
+		if (WARN_ON_ONCE(page_ref_count(page) < 0))
+			goto pte_unmap;
+
 		if (!page_cache_get_speculative(page))
 			goto pte_unmap;
 
@@ -1139,8 +1162,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pmd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pmd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1185,8 +1208,8 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pud_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pud_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1227,8 +1250,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pgd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pgd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 465786cd6490..6087277981a6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1322,7 +1322,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	if (flags & FOLL_GET)
-		get_page_foll(page);
+		get_page_foll(page, false);
 
 out:
 	return page;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fd932e7a25dd..b4a8a18fa3a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3886,6 +3886,7 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
+	int err = -EFAULT;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -3957,10 +3958,23 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
 		page = pte_page(huge_ptep_get(pte));
+
+		/*
+		 * Instead of doing 'try_get_page()' below in the same_page
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
-			get_page_foll(pages[i]);
+			get_page_foll(pages[i], false);
 		}
 
 		if (vmas)
@@ -3983,7 +3997,7 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	*nr_pages = remainder;
 	*position = vaddr;
 
-	return i ? i : -EFAULT;
+	return i ? i : err;
 }
 
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
diff --git a/mm/internal.h b/mm/internal.h
index a6639c72780a..b52041969d06 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -93,23 +93,29 @@ static inline void __get_page_tail_foll(struct page *page,
  * follow_page() and it must be called while holding the proper PT
  * lock while the pte (or pmd_trans_huge) is still mapping the page.
  */
-static inline void get_page_foll(struct page *page)
+static inline bool get_page_foll(struct page *page, bool check)
 {
-	if (unlikely(PageTail(page)))
+	if (unlikely(PageTail(page))) {
 		/*
 		 * This is safe only because
 		 * __split_huge_page_refcount() can't run under
 		 * get_page_foll() because we hold the proper PT lock.
 		 */
+		if (check && WARN_ON_ONCE(
+				page_ref_count(compound_head(page)) <= 0))
+			return false;
 		__get_page_tail_foll(page, true);
-	else {
+	} else {
 		/*
 		 * Getting a normal page or the head of a compound page
 		 * requires to already have an elevated page->_count.
 		 */
 		VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
+		if (check && WARN_ON_ONCE(page_ref_count(page) <= 0))
+			return false;
 		atomic_inc(&page->_count);
 	}
+	return true;
 }
 
 extern unsigned long highest_memmap_pfn;
-- 
2.23.0

