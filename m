Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B048D24BC1E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgHTMkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgHTJqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:46:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3A020724;
        Thu, 20 Aug 2020 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916806;
        bh=wSHvmKQ7atSTQ8yN7yJJy/Pj4YYN1b9eIHfGnRLXgks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHRXpLW1dpV7tYTgw7JLRzYm0xwLo2d6P32bcCYp2cDwY3W+mOn1soEr4mB+63aHk
         +/t5KuHbv6WwRldnaY1cc0YxDZmRXcA8zuTAIq4/rSrt+fVeYVktYjQ4W2wsU+zwnL
         jzRhgHzea89K62sjCXkRUEYIq+6/H2QBXicVSLyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 053/152] khugepaged: collapse_pte_mapped_thp() protect the pmd lock
Date:   Thu, 20 Aug 2020 11:20:20 +0200
Message-Id: <20200820091556.438301784@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 119a5fc16105b2b9383a6e2a7800b2ef861b2975 upstream.

When retract_page_tables() removes a page table to make way for a huge
pmd, it holds huge page lock, i_mmap_lock_write, mmap_write_trylock and
pmd lock; but when collapse_pte_mapped_thp() does the same (to handle the
case when the original mmap_write_trylock had failed), only
mmap_write_trylock and pmd lock are held.

That's not enough.  One machine has twice crashed under load, with "BUG:
spinlock bad magic" and GPF on 6b6b6b6b6b6b6b6b.  Examining the second
crash, page_vma_mapped_walk_done()'s spin_unlock of pvmw->ptl (serving
page_referenced() on a file THP, that had found a page table at *pmd)
discovers that the page table page and its lock have already been freed by
the time it comes to unlock.

Follow the example of retract_page_tables(), but we only need one of huge
page lock or i_mmap_lock_write to secure against this: because it's the
narrower lock, and because it simplifies collapse_pte_mapped_thp() to know
the hpage earlier, choose to rely on huge page lock here.

Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021213070.27773@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/khugepaged.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1294,7 +1294,7 @@ void collapse_pte_mapped_thp(struct mm_s
 {
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = find_vma(mm, haddr);
-	struct page *hpage = NULL;
+	struct page *hpage;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, _pmd;
 	spinlock_t *ptl;
@@ -1314,9 +1314,17 @@ void collapse_pte_mapped_thp(struct mm_s
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
+	hpage = find_lock_page(vma->vm_file->f_mapping,
+			       linear_page_index(vma, haddr));
+	if (!hpage)
+		return;
+
+	if (!PageHead(hpage))
+		goto drop_hpage;
+
 	pmd = mm_find_pmd(mm, haddr);
 	if (!pmd)
-		return;
+		goto drop_hpage;
 
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 
@@ -1335,30 +1343,11 @@ void collapse_pte_mapped_thp(struct mm_s
 
 		page = vm_normal_page(vma, addr, *pte);
 
-		if (!page || !PageCompound(page))
-			goto abort;
-
-		if (!hpage) {
-			hpage = compound_head(page);
-			/*
-			 * The mapping of the THP should not change.
-			 *
-			 * Note that uprobe, debugger, or MAP_PRIVATE may
-			 * change the page table, but the new page will
-			 * not pass PageCompound() check.
-			 */
-			if (WARN_ON(hpage->mapping != vma->vm_file->f_mapping))
-				goto abort;
-		}
-
 		/*
-		 * Confirm the page maps to the correct subpage.
-		 *
-		 * Note that uprobe, debugger, or MAP_PRIVATE may change
-		 * the page table, but the new page will not pass
-		 * PageCompound() check.
+		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
+		 * page table, but the new page will not be a subpage of hpage.
 		 */
-		if (WARN_ON(hpage + i != page))
+		if (hpage + i != page)
 			goto abort;
 		count++;
 	}
@@ -1377,7 +1366,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	pte_unmap_unlock(start_pte, ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
-	if (hpage) {
+	if (count) {
 		page_ref_sub(hpage, count);
 		add_mm_counter(vma->vm_mm, mm_counter_file(hpage), -count);
 	}
@@ -1388,10 +1377,15 @@ void collapse_pte_mapped_thp(struct mm_s
 	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	pte_free(mm, pmd_pgtable(_pmd));
+
+drop_hpage:
+	unlock_page(hpage);
+	put_page(hpage);
 	return;
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	goto drop_hpage;
 }
 
 static int khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)


