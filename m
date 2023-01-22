Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B441D676FA4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjAVPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAVPXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB5F18B30
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3908BB80B20
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEABC433EF;
        Sun, 22 Jan 2023 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401018;
        bh=ygbZxrIl4h1lfsOpwuNg4+wa6qh5FOs800MIauU6D7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtS2om9Wt7WTlTcOpkkqjGWtt3BQ3/pSOgiOmaVTfWqGDHHzceEham073sTZkdzDO
         NzUG5Tu9Y4WmecInMwmJ2OSE3nlGQr68pP0f/uU/6JaOMuRc9/HBjknOPP3uhP/nUe
         NgC0uqu69OJGGzaaCDWvW9H3X8cUxKBCYFKSltQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Hildenbrand <david@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 079/193] mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date:   Sun, 22 Jan 2023 16:03:28 +0100
Message-Id: <20230122150249.971390067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 51d3d5eb74ff53b92dcff48b30ae2ed8edd85a32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |   28 ++++++++++++++++++++++------
 mm/mmap.c        |    4 ++++
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
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
--- a/mm/mmap.c
+++ b/mm/mmap.c
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


