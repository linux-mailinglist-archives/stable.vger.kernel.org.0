Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E3817F9E6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgCJNBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbgCJNBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D152468C;
        Tue, 10 Mar 2020 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845259;
        bh=FMmLwfHpyJGEYDfcJbbf8o4v84coP75xaSgbbjb5eKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEs8qV5kzdycxVqtAs44ekpQBvW+giXN5yKN2XnJlTNf9Z3NEvvEMdNB97tpseluK
         i6c3BsZ1EAGUUPJuF97d/+sD2Ze/4AZyzRgtBBnCV5QTDGfUBvErlBrZ7T6+8ogqcf
         aJbdcnbmc6s5skHAUxuV+BmFoggdhN6FqwWhZwTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Justin He <Justin.He@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 081/189] mm: avoid data corruption on CoW fault into PFN-mapped VMA
Date:   Tue, 10 Mar 2020 13:38:38 +0100
Message-Id: <20200310123647.851968509@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

commit c3e5ea6ee574ae5e845a40ac8198de1fb63bb3ab upstream.

Jeff Moyer has reported that one of xfstests triggers a warning when run
on DAX-enabled filesystem:

	WARNING: CPU: 76 PID: 51024 at mm/memory.c:2317 wp_page_copy+0xc40/0xd50
	...
	wp_page_copy+0x98c/0xd50 (unreliable)
	do_wp_page+0xd8/0xad0
	__handle_mm_fault+0x748/0x1b90
	handle_mm_fault+0x120/0x1f0
	__do_page_fault+0x240/0xd70
	do_page_fault+0x38/0xd0
	handle_page_fault+0x10/0x30

The warning happens on failed __copy_from_user_inatomic() which tries to
copy data into a CoW page.

This happens because of race between MADV_DONTNEED and CoW page fault:

	CPU0					CPU1
 handle_mm_fault()
   do_wp_page()
     wp_page_copy()
       do_wp_page()
					madvise(MADV_DONTNEED)
					  zap_page_range()
					    zap_pte_range()
					      ptep_get_and_clear_full()
					      <TLB flush>
	 __copy_from_user_inatomic()
	 sees empty PTE and fails
	 WARN_ON_ONCE(1)
	 clear_page()

The solution is to re-try __copy_from_user_inatomic() under PTL after
checking that PTE is matches the orig_pte.

The second copy attempt can still fail, like due to non-readable PTE, but
there's nothing reasonable we can do about, except clearing the CoW page.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Justin He <Justin.He@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: http://lkml.kernel.org/r/20200218154151.13349-1-kirill.shutemov@linux.intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2221,7 +2221,7 @@ static inline bool cow_user_page(struct
 	bool ret;
 	void *kaddr;
 	void __user *uaddr;
-	bool force_mkyoung;
+	bool locked = false;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = vmf->address;
@@ -2246,11 +2246,11 @@ static inline bool cow_user_page(struct
 	 * On architectures with software "accessed" bits, we would
 	 * take a double page fault, so mark it accessed here.
 	 */
-	force_mkyoung = arch_faults_on_old_pte() && !pte_young(vmf->orig_pte);
-	if (force_mkyoung) {
+	if (arch_faults_on_old_pte() && !pte_young(vmf->orig_pte)) {
 		pte_t entry;
 
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+		locked = true;
 		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 			/*
 			 * Other thread has already handled the fault
@@ -2274,18 +2274,37 @@ static inline bool cow_user_page(struct
 	 * zeroes.
 	 */
 	if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+		if (locked)
+			goto warn;
+
+		/* Re-validate under PTL if the page is still mapped */
+		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+		locked = true;
+		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
+			/* The PTE changed under us. Retry page fault. */
+			ret = false;
+			goto pte_unlock;
+		}
+
 		/*
-		 * Give a warn in case there can be some obscure
-		 * use-case
+		 * The same page can be mapped back since last copy attampt.
+		 * Try to copy again under PTL.
 		 */
-		WARN_ON_ONCE(1);
-		clear_page(kaddr);
+		if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+			/*
+			 * Give a warn in case there can be some obscure
+			 * use-case
+			 */
+warn:
+			WARN_ON_ONCE(1);
+			clear_page(kaddr);
+		}
 	}
 
 	ret = true;
 
 pte_unlock:
-	if (force_mkyoung)
+	if (locked)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	kunmap_atomic(kaddr);
 	flush_dcache_page(dst);


