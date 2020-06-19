Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7520139A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403867AbgFSPMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403859AbgFSPMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:12:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF5F2158C;
        Fri, 19 Jun 2020 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579526;
        bh=9H/ayrhInPhbiryYv+WI4UkOCHnSdm8qAYqXHb8mIZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLaMoPhfD8jVNRLy+Gqu6slARhxN3QklxtBTFyKdwurQJtG2CDUq4igC2VWop+TPj
         jOWGf7csSd3wzdE35OWDdYIjiQhGODEo/wOjf91gO+jbp+w1vwActGlLkjRb/K5vFo
         1TVi5ssLZR+6ODpXkVwfAElX6uzxD+r5rKdqat0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 169/261] mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()
Date:   Fri, 19 Jun 2020 16:33:00 +0200
Message-Id: <20200619141658.011212429@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
@@ -2301,6 +2301,8 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
+	bool was_locked = false;
+	pmd_t _pmd;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
@@ -2313,11 +2315,32 @@ void __split_huge_pmd(struct vm_area_str
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
 	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
@@ -2325,6 +2348,8 @@ void __split_huge_pmd(struct vm_area_str
 	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 out:
 	spin_unlock(ptl);
+	if (!was_locked && page)
+		unlock_page(page);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.
 	 * They are 3 cases to consider inside __split_huge_pmd_locked():


