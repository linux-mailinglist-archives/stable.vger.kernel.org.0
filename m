Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB4411F0C
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfEBPZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfEBPZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9BBA21734;
        Thu,  2 May 2019 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810743;
        bh=7/ArnvMDTDjNqheHlVaR2ef1murRUtc7CpjitUMGWsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpu6N91RRjwVu04eJhUreyVNSObDAG9MBAHNlw1XA3xGcDebNVZe0eplpd5lzE/hp
         c9fcOfSaLmZfoSi5dnU5ZoRTaLR2poelUWSaIpzw0E3c7OUQCWguzKgyXgsR1Lykz9
         xwzzyM5gDWrinHrwGq59w13+YF8SxGtYb8gbJhig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 05/72] mm: prevent get_user_pages() from overflowing page refcount
Date:   Thu,  2 May 2019 17:20:27 +0200
Message-Id: <20190502143333.866262625@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/gup.c     |   45 ++++++++++++++++++++++++++++++++++-----------
 mm/hugetlb.c |   13 +++++++++++++
 2 files changed, 47 insertions(+), 11 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -153,7 +153,10 @@ retry:
 	}
 
 	if (flags & FOLL_GET) {
-		get_page(page);
+		if (unlikely(!try_get_page(page))) {
+			page = ERR_PTR(-ENOMEM);
+			goto out;
+		}
 
 		/* drop the pgmap reference now that we hold the page */
 		if (pgmap) {
@@ -296,7 +299,10 @@ retry_locked:
 			if (pmd_trans_unstable(pmd))
 				ret = -EBUSY;
 		} else {
-			get_page(page);
+			if (unlikely(!try_get_page(page))) {
+				spin_unlock(ptl);
+				return ERR_PTR(-ENOMEM);
+			}
 			spin_unlock(ptl);
 			lock_page(page);
 			ret = split_huge_page(page);
@@ -480,7 +486,10 @@ static int get_gate_page(struct mm_struc
 		if (is_device_public_page(*page))
 			goto unmap;
 	}
-	get_page(*page);
+	if (unlikely(!try_get_page(*page))) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
 out:
 	ret = 0;
 unmap:
@@ -1368,6 +1377,20 @@ static void undo_dev_pagemap(int *nr, in
 	}
 }
 
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
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 int write, struct page **pages, int *nr)
@@ -1402,9 +1425,9 @@ static int gup_pte_range(pmd_t pmd, unsi
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		head = compound_head(page);
 
-		if (!page_cache_get_speculative(head))
+		head = try_get_compound_head(page, 1);
+		if (!head)
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
@@ -1543,8 +1566,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pmd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pmd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1581,8 +1604,8 @@ static int gup_huge_pud(pud_t orig, pud_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pud_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pud_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1618,8 +1641,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_
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
@@ -4299,6 +4299,19 @@ long follow_hugetlb_page(struct mm_struc
 
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


