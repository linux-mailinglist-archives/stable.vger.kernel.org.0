Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8EF648BDA
	for <lists+stable@lfdr.de>; Sat, 10 Dec 2022 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLJAo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 19:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 19:44:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F86F48B;
        Fri,  9 Dec 2022 16:44:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3894262343;
        Sat, 10 Dec 2022 00:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D4FC433D2;
        Sat, 10 Dec 2022 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670633063;
        bh=sxHZadGjABtclYEkRKPebRbqmMM4q2jnIzJAH1kU+1k=;
        h=Date:To:From:Subject:From;
        b=q7zW4c8QzlCfeZvtokAp9wvnV3CVQ0YMSShq4/CBLPiNpCdugWS1r6m33ufUMXjaz
         3PZZfqD5TPBolLsPlPnQ0v7CX0sE2a11cllOzne/lo/AdRHbiviE0nqgfU4LWTGHie
         B2fVFP6G5Aid1wzxnoaaX+akgGnP1vTNlfxv3dPA=
Date:   Fri, 09 Dec 2022 16:44:22 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, nadav.amit@gmail.com,
        ives@codesandbox.io, hughd@google.com, apopple@nvidia.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20221210004423.94D4FC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1648,7 +1664,7 @@ static int userfaultfd_unregister(struct
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

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-v2.patch
mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit-fix.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch
selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch
selftests-vm-cow-fix-compile-warning-on-32bit.patch
selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

