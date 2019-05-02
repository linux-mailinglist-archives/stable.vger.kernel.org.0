Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58D011F66
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfEBPYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfEBPYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F073020B7C;
        Thu,  2 May 2019 15:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810662;
        bh=LmuzgzsK29FiEFdBTUOSiAOaeUrj2ZutR/Tsns6qF1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UD4f3WtR6h2K1xGI/cjmF3Enftx4z6dnHnOGYsZtxAHWJPX7MWVAVIOHEY1nVFpb2
         G9Wn4/F9AFTQjKzXGx/rv/lTsf+ICQ0UpCGzntv0v35OvbqrG+tOcosUqLaggOlbsQ
         UvKogFhd0xcewrai6As8EGZb/qf7Qoy5xg/mMBNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 06/49] mm: prevent get_user_pages() from overflowing page refcount
Date:   Thu,  2 May 2019 17:20:43 +0200
Message-Id: <20190502143324.847288707@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
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
@@ -280,7 +283,10 @@ retry_locked:
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
@@ -464,7 +470,10 @@ static int get_gate_page(struct mm_struc
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
@@ -1365,6 +1374,20 @@ static void undo_dev_pagemap(int *nr, in
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
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 int write, struct page **pages, int *nr)
@@ -1399,9 +1422,9 @@ static int gup_pte_range(pmd_t pmd, unsi
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
-		head = compound_head(page);
 
-		if (!page_cache_get_speculative(head))
+		head = try_get_compound_head(page, 1);
+		if (!head)
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
@@ -1537,8 +1560,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pmd_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pmd_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1575,8 +1598,8 @@ static int gup_huge_pud(pud_t orig, pud_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(pud_page(orig));
-	if (!page_cache_add_speculative(head, refs)) {
+	head = try_get_compound_head(pud_page(orig), refs);
+	if (!head) {
 		*nr -= refs;
 		return 0;
 	}
@@ -1612,8 +1635,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_
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
@@ -4255,6 +4255,19 @@ long follow_hugetlb_page(struct mm_struc
 
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


