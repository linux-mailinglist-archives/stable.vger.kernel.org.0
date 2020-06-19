Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD42017CC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgFSQn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388476AbgFSOn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD022168B;
        Fri, 19 Jun 2020 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577807;
        bh=uFwyZt1jxmvhD48DavXd5qLHB47tEeS/Z/5wVKXfbQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE6O7PhZfTgJYu1q0yHPED01VVMfSRneKL7D7e9cK1gI0UUFyWDK3MjTfAMqMmyu6
         aBWDbo46N9XztKVs9eq7rxFCX0ZNIjmzeYVKZsBSuX6vB1A+1NVr6OHxr3ggMoA5so
         ZMJQk13UKxav6+zMJ2AtgUwuhAw9/ZBkngYRsJXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 098/128] mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()
Date:   Fri, 19 Jun 2020 16:33:12 +0200
Message-Id: <20200619141625.314982137@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

commit c444eb564fb16645c172d550359cb3d75fe8a040 upstream.

Write protect anon page faults require an accurate mapcount to decide
if to break the COW or not. This is implemented in the THP path with
reuse_swap_page() ->
page_trans_huge_map_swapcount()/page_trans_huge_mapcount().

If the COW triggers while the other processes sharing the page are
under a huge pmd split, to do an accurate reading, we must ensure the
mapcount isn't computed while it's being transferred from the head
page to the tail pages.

reuse_swap_cache() already runs serialized by the page lock, so it's
enough to add the page lock around __split_huge_pmd_locked too, in
order to add the missing serialization.

Note: the commit in "Fixes" is just to facilitate the backporting,
because the code before such commit didn't try to do an accurate THP
mapcount calculation and it instead used the page_count() to decide if
to COW or not. Both the page_count and the pin_count are THP-wide
refcounts, so they're inaccurate if used in
reuse_swap_page(). Reverting such commit (besides the unrelated fix to
the local anon_vma assignment) would have also opened the window for
memory corruption side effects to certain workloads as documented in
such commit header.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Jann Horn <jannh@google.com>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 6d0a07edd17c ("mm: thp: calculate the mapcount correctly for THP pages during WP faults")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1755,6 +1755,8 @@ void __split_huge_pmd(struct vm_area_str
 	spinlock_t *ptl;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
+	bool was_locked = false;
+	pmd_t _pmd;
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
 	ptl = pmd_lock(mm, pmd);
@@ -1764,11 +1766,32 @@ void __split_huge_pmd(struct vm_area_str
 	 * pmd against. Otherwise we can end up replacing wrong page.
 	 */
 	VM_BUG_ON(freeze && !page);
-	if (page && page != pmd_page(*pmd))
-	        goto out;
+	if (page) {
+		VM_WARN_ON_ONCE(!PageLocked(page));
+		was_locked = true;
+		if (page != pmd_page(*pmd))
+			goto out;
+	}
 
+repeat:
 	if (pmd_trans_huge(*pmd)) {
-		page = pmd_page(*pmd);
+		if (!page) {
+			page = pmd_page(*pmd);
+			if (unlikely(!trylock_page(page))) {
+				get_page(page);
+				_pmd = *pmd;
+				spin_unlock(ptl);
+				lock_page(page);
+				spin_lock(ptl);
+				if (unlikely(!pmd_same(*pmd, _pmd))) {
+					unlock_page(page);
+					put_page(page);
+					page = NULL;
+					goto repeat;
+				}
+				put_page(page);
+			}
+		}
 		if (PageMlocked(page))
 			clear_page_mlock(page);
 	} else if (!pmd_devmap(*pmd))
@@ -1776,6 +1799,8 @@ void __split_huge_pmd(struct vm_area_str
 	__split_huge_pmd_locked(vma, pmd, haddr, freeze);
 out:
 	spin_unlock(ptl);
+	if (!was_locked && page)
+		unlock_page(page);
 	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
 }
 


