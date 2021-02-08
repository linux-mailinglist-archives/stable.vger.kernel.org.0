Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120773136C7
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhBHPPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhBHPLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:11:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872FD64EC7;
        Mon,  8 Feb 2021 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796912;
        bh=uXYX5JDHS/P8PrJrn60cRnNZemSFFuq40KBRzs6aCzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DN2fDzHAgP2URbiTu0xUrF233LmW9CuBjMeQWtvLYRU7u0tDLdN0I1jQsjVdFr9qP
         fKS5He7fQ87rzxI7rjZ+75u76EA02dPBgVq0Ytf+FqBEBdmLXsd+CzBN/UenXu5njX
         uqNDff4UNjgfHqdDn0Kq5fFf6+Ql5O8FAP7gphsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 31/38] mm: thp: fix MADV_REMOVE deadlock on shmem THP
Date:   Mon,  8 Feb 2021 16:01:18 +0100
Message-Id: <20210208145807.405105895@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 1c2f67308af4c102b4e1e6cd6f69819ae59408e0 upstream.

Sergey reported deadlock between kswapd correctly doing its usual
lock_page(page) followed by down_read(page->mapping->i_mmap_rwsem), and
madvise(MADV_REMOVE) on an madvise(MADV_HUGEPAGE) area doing
down_write(page->mapping->i_mmap_rwsem) followed by lock_page(page).

This happened when shmem_fallocate(punch hole)'s unmap_mapping_range()
reaches zap_pmd_range()'s call to __split_huge_pmd().  The same deadlock
could occur when partially truncating a mapped huge tmpfs file, or using
fallocate(FALLOC_FL_PUNCH_HOLE) on it.

__split_huge_pmd()'s page lock was added in 5.8, to make sure that any
concurrent use of reuse_swap_page() (holding page lock) could not catch
the anon THP's mapcounts and swapcounts while they were being split.

Fortunately, reuse_swap_page() is never applied to a shmem or file THP
(not even by khugepaged, which checks PageSwapCache before calling), and
anonymous THPs are never created in shmem or file areas: so that
__split_huge_pmd()'s page lock can only be necessary for anonymous THPs,
on which there is no risk of deadlock with i_mmap_rwsem.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2101161409470.2022@eggly.anvils
Fixes: c444eb564fb1 ("mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2278,7 +2278,7 @@ void __split_huge_pmd(struct vm_area_str
 	spinlock_t *ptl;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
-	bool was_locked = false;
+	bool do_unlock_page = false;
 	pmd_t _pmd;
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
@@ -2291,7 +2291,6 @@ void __split_huge_pmd(struct vm_area_str
 	VM_BUG_ON(freeze && !page);
 	if (page) {
 		VM_WARN_ON_ONCE(!PageLocked(page));
-		was_locked = true;
 		if (page != pmd_page(*pmd))
 			goto out;
 	}
@@ -2300,19 +2299,29 @@ repeat:
 	if (pmd_trans_huge(*pmd)) {
 		if (!page) {
 			page = pmd_page(*pmd);
-			if (unlikely(!trylock_page(page))) {
-				get_page(page);
-				_pmd = *pmd;
-				spin_unlock(ptl);
-				lock_page(page);
-				spin_lock(ptl);
-				if (unlikely(!pmd_same(*pmd, _pmd))) {
-					unlock_page(page);
+			/*
+			 * An anonymous page must be locked, to ensure that a
+			 * concurrent reuse_swap_page() sees stable mapcount;
+			 * but reuse_swap_page() is not used on shmem or file,
+			 * and page lock must not be taken when zap_pmd_range()
+			 * calls __split_huge_pmd() while i_mmap_lock is held.
+			 */
+			if (PageAnon(page)) {
+				if (unlikely(!trylock_page(page))) {
+					get_page(page);
+					_pmd = *pmd;
+					spin_unlock(ptl);
+					lock_page(page);
+					spin_lock(ptl);
+					if (unlikely(!pmd_same(*pmd, _pmd))) {
+						unlock_page(page);
+						put_page(page);
+						page = NULL;
+						goto repeat;
+					}
 					put_page(page);
-					page = NULL;
-					goto repeat;
 				}
-				put_page(page);
+				do_unlock_page = true;
 			}
 		}
 		if (PageMlocked(page))
@@ -2322,7 +2331,7 @@ repeat:
 	__split_huge_pmd_locked(vma, pmd, haddr, freeze);
 out:
 	spin_unlock(ptl);
-	if (!was_locked && page)
+	if (do_unlock_page)
 		unlock_page(page);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.


