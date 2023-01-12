Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B8E666779
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 01:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbjALAPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 19:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjALAPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 19:15:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4E9140AE;
        Wed, 11 Jan 2023 16:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C8DB81D81;
        Thu, 12 Jan 2023 00:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0543C433F0;
        Thu, 12 Jan 2023 00:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482504;
        bh=B6OWPurxWCxUw2V9s+PcyfX6vEKMm4cBPNklC7AMSQE=;
        h=Date:To:From:Subject:From;
        b=K7kCY5yyhv8e+U7CWb4oxt+JPEvbJaAk/B1GHKKYxRLrycyRv73TqNBCjlh8E33Pj
         GqoaqybRQ0iM2r0tIzlWj8FuMkaAqRJ04LHbrhzjP/YPe28stt/o60nESC382g7bs7
         ojZXMFfqyXlHV+I6EZp1cjhOgTrTB0dBuyGctQ5g=
Date:   Wed, 11 Jan 2023 16:15:03 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, nadav.amit@gmail.com,
        ives@codesandbox.io, hughd@google.com, apopple@nvidia.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch removed from -mm tree
Message-Id: <20230112001504.C0543C433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date: Fri, 9 Dec 2022 09:09:12 +0100

Currently, we don't enable writenotify when enabling userfaultfd-wp on a
shared writable mapping (for now only shmem and hugetlb).  The consequence
is that vma->vm_page_prot will still include write permissions, to be set
as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
page migration, ...).

So far, vma->vm_page_prot is assumed to be a safe default, meaning that we
only add permissions (e.g., mkwrite) but not remove permissions (e.g.,
wrprotect).  For example, when enabling softdirty tracking, we enable
writenotify.  With uffd-wp on shared mappings, that changed.  More details
on vma->vm_page_prot semantics were summarized in [1].

This is problematic for uffd-wp: we'd have to manually check for a uffd-wp
PTEs/PMDs and manually write-protect PTEs/PMDs, which is error prone. 
Prone to such issues is any code that uses vma->vm_page_prot to set PTE
permissions: primarily pte_modify() and mk_pte().

Instead, let's enable writenotify such that PTEs/PMDs/...  will be mapped
write-protected as default and we will only allow selected PTEs that are
definitely safe to be mapped without write-protection (see
can_change_pte_writable()) to be writable.  In the future, we might want
to enable write-bit recovery -- e.g., can_change_pte_writable() -- at more
locations, for example, also when removing uffd-wp protection.

This fixes two known cases:

(a) remove_migration_pte() mapping uffd-wp'ed PTEs writable, resulting
    in uffd-wp not triggering on write access.
(b) do_numa_page() / do_huge_pmd_numa_page() mapping uffd-wp'ed PTEs/PMDs
    writable, resulting in uffd-wp not triggering on write access.

Note that do_numa_page() / do_huge_pmd_numa_page() can be reached even
without NUMA hinting (which currently doesn't seem to be applicable to
shmem), for example, by using uffd-wp with a PROT_WRITE shmem VMA.  On
such a VMA, userfaultfd-wp is currently non-functional.

Note that when enabling userfaultfd-wp, there is no need to walk page
tables to enforce the new default protection for the PTEs: we know that
they cannot be uffd-wp'ed yet, because that can only happen after enabling
uffd-wp for the VMA in general.

Also note that this makes mprotect() on ranges with uffd-wp'ed PTEs not
accidentally set the write bit -- which would result in uffd-wp not
triggering on later write access.  This commit makes uffd-wp on shmem
behave just like uffd-wp on anonymous memory in that regard, even though,
mixing mprotect with uffd-wp is controversial.

[1] https://lkml.kernel.org/r/92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com

Link: https://lkml.kernel.org/r/20221209080912.7968-1-david@redhat.com
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Debugged-by: Peter Xu <peterx@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   28 ++++++++++++++++++++++------
 mm/mmap.c        |    4 ++++
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma
+++ a/fs/userfaultfd.c
@@ -108,6 +108,21 @@ static bool userfaultfd_is_initialized(s
 	return ctx->features & UFFD_FEATURE_INITIALIZED;
 }
 
+static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
+				     vm_flags_t flags)
+{
+	const bool uffd_wp_changed = (vma->vm_flags ^ flags) & VM_UFFD_WP;
+
+	vma->vm_flags = flags;
+	/*
+	 * For shared mappings, we want to enable writenotify while
+	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
+	 * recalculate vma->vm_page_prot whenever userfaultfd-wp changes.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && uffd_wp_changed)
+		vma_set_page_prot(vma);
+}
+
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -618,7 +633,8 @@ static void userfaultfd_event_wait_compl
 		for_each_vma(vmi, vma) {
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-				vma->vm_flags &= ~__VM_UFFD_FLAGS;
+				userfaultfd_set_vm_flags(vma,
+							 vma->vm_flags & ~__VM_UFFD_FLAGS);
 			}
 		}
 		mmap_write_unlock(mm);
@@ -652,7 +668,7 @@ int dup_userfaultfd(struct vm_area_struc
 	octx = vma->vm_userfaultfd_ctx.ctx;
 	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~__VM_UFFD_FLAGS;
+		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 		return 0;
 	}
 
@@ -733,7 +749,7 @@ void mremap_userfaultfd_prep(struct vm_a
 	} else {
 		/* Drop uffd context if remap feature not enabled */
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~__VM_UFFD_FLAGS;
+		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 	}
 }
 
@@ -895,7 +911,7 @@ static int userfaultfd_release(struct in
 			prev = vma;
 		}
 
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
 	mmap_write_unlock(mm);
@@ -1463,7 +1479,7 @@ static int userfaultfd_register(struct u
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
@@ -1651,7 +1667,7 @@ static int userfaultfd_unregister(struct
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 
 	skip:
--- a/mm/mmap.c~mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma
+++ a/mm/mmap.c
@@ -1524,6 +1524,10 @@ int vma_wants_writenotify(struct vm_area
 	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
 		return 1;
 
+	/* Do we need write faults for uffd-wp tracking? */
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	/* Specialty mapping? */
 	if (vm_flags & VM_PFNMAP)
 		return 0;
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch
selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

