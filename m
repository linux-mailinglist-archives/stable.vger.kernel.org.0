Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86370F9B
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 05:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfGWDJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 23:09:08 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:6485 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730884AbfGWDJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 23:09:07 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Jul 2019 20:08:52 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 9484AB24DB;
        Mon, 22 Jul 2019 23:09:02 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <aarcange@redhat.com>,
        <hughd@google.com>, <dave.hansen@intel.com>, <mgorman@suse.de>,
        <riel@redhat.com>, <mhocko@suse.cz>, <jannh@google.com>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <srostedt@vmware.com>,
        <akaher@vmware.com>
Subject: [PATCH 6/8] mm: prevent get_user_pages() from overflowing page refcount
Date:   Tue, 23 Jul 2019 16:38:29 +0530
Message-ID: <1563880111-19058-7-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563880111-19058-1-git-send-email-akaher@vmware.com>
References: <1563880111-19058-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
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
  Ajay: Added local variable 'err' with-in follow_hugetlb_page()
        from 2be7cfed995e, to resolve compilation error
  Srivatsa: Replaced call to get_page_foll() with try_get_page_foll() ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 mm/gup.c     | 43 ++++++++++++++++++++++++++++++++-----------
 mm/hugetlb.c | 16 +++++++++++++++-
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index fae4d1e..171b460 100644
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
@@ -289,7 +293,10 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
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
@@ -1053,6 +1060,20 @@ struct page *get_dump_page(unsigned long addr)
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
@@ -1082,9 +1103,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		head = compound_head(page);
 
-		if (!page_cache_get_speculative(head))
+		head = try_get_compound_head(page, 1);
+		if (!head)
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
@@ -1141,8 +1162,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pmd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pmd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1187,8 +1208,8 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pud_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pud_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1229,8 +1250,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pgd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pgd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fd932e7..3a1501e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3886,6 +3886,7 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
+	int err = -EFAULT;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -3957,6 +3958,19 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
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
-- 
2.7.4

