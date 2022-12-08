Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF5646ECF
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 12:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiLHLmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 06:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLHLmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 06:42:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61AD69301
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 03:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670499707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g5xBDwwbAPMXsVLc87QM3XiQi+bNxIe4VXdcPfLTTBs=;
        b=FaLvOEv2QIHCcR7/iGtp3kT7fxYRvROJvU5A2omhHibjKQkGWdnmdwfadzuSd6IpX54Q7l
        IRJwhJgO+NoysW0Soj70SipbeAAEPUyzGQ6xau+onmg+/BA4PBf27wLmphPPlB+uFdpxBd
        EwcCaTOBO/xbn0UItoJoPvuSZ9YMZSY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-EO_ZK0zzM32kIRDyvyIDqg-1; Thu, 08 Dec 2022 06:41:43 -0500
X-MC-Unique: EO_ZK0zzM32kIRDyvyIDqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 647163803911;
        Thu,  8 Dec 2022 11:41:43 +0000 (UTC)
Received: from t480s.in.tum.de (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E5FA40C2064;
        Thu,  8 Dec 2022 11:41:40 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Peter Xu <peterx@redhat.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v1] mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date:   Thu,  8 Dec 2022 12:41:37 +0100
Message-Id: <20221208114137.35035-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, we don't enable writenotify when enabling userfaultfd-wp on
a shared writable mapping (for now only shmem and hugetlb). The consequence
is that vma->vm_page_prot will still include write permissions, to be set
as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
page migration, ...).

So far, vma->vm_page_prot is assumed to be a safe default, meaning that
we only add permissions (e.g., mkwrite) but not remove permissions (e.g.,
wrprotect). For example, when enabling softdirty tracking, we enable
writenotify. With uffd-wp on shared mappings, that changed. More details
on vma->vm_page_prot semantics were summarized in [1].

This is problematic for uffd-wp: we'd have to manually check for
a uffd-wp PTEs/PMDs and manually write-protect PTEs/PMDs, which is error
prone. Prone to such issues is any code that uses vma->vm_page_prot to set
PTE permissions: primarily pte_modify() and mk_pte().

Instead, let's enable writenotify such that PTEs/PMDs/... will be mapped
write-protected as default and we will only allow selected PTEs that are
definitely safe to be mapped without write-protection (see
can_change_pte_writable()) to be writable. In the future, we might want
to enable write-bit recovery -- e.g., can_change_pte_writable() -- at
more locations, for example, also when removing uffd-wp protection.

This fixes two known cases:

(a) remove_migration_pte() mapping uffd-wp'ed PTEs writable, resulting
    in uffd-wp not triggering on write access.
(b) do_numa_page() / do_huge_pmd_numa_page() mapping uffd-wp'ed PTEs/PMDs
    writable, resulting in uffd-wp not triggering on write access.

Note that do_numa_page() / do_huge_pmd_numa_page() can be reached even
without NUMA hinting (which currently doesn't seem to be applicable to
shmem), for example, by using uffd-wp with a PROT_WRITE shmem VMA.
On such a VMA, userfaultfd-wp is currently non-functional.

Note that when enabling userfaultfd-wp, there is no need to walk page
tables to enforce the new default protection for the PTEs: we know that
they cannot be uffd-wp'ed yet, because that can only happen after
enabling uffd-wp for the VMA in general.

Also note that this makes mprotect() on ranges with uffd-wp'ed PTEs not
accidentally set the write bit -- which would result in uffd-wp not
triggering on later write access. This commit makes uffd-wp on shmem behave
just like uffd-wp on anonymous memory (iow, less special) in that regard,
even though, mixing mprotect with uffd-wp is controversial.

[1] https://lkml.kernel.org/r/92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com

Reported-by: Ives van Hoorne <ives@codesandbox.io>
Debugged-by: Peter Xu <peterx@redhat.com>
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

As discussed in [2], this is supposed to replace the fix by Peter:
  [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when recover
  pte

This survives vm/selftests and my reproducers:
* migrating pages that are uffd-wp'ed using mbind() on a machine with 2
  NUMA nodes
* Using a PROT_WRITE mapping with uffd-wp
* Using a PROT_READ|PROT_WRITE mapping with uffd-wp'ed pages and
  mprotect()'ing it PROT_WRITE
* Using a PROT_READ|PROT_WRITE mapping with uffd-wp'ed pages and
  temporarily mprotect()'ing it PROT_READ

uffd-wp properly triggers in all cases. On v8.1-rc8, all mre reproducers
fail.

It would be good to get some more testing feedback and review.

[2] https://lkml.kernel.org/r/20221202122748.113774-1-david@redhat.com

---
 fs/userfaultfd.c | 28 ++++++++++++++++++++++------
 mm/mmap.c        |  4 ++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 98ac37e34e3d..fb0733f2e623 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -108,6 +108,21 @@ static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
 	return ctx->features & UFFD_FEATURE_INITIALIZED;
 }
 
+static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
+				     vm_flags_t flags)
+{
+	const bool uffd_wp = !!((vma->vm_flags | flags) & VM_UFFD_WP);
+
+	vma->vm_flags = flags;
+	/*
+	 * For shared mappings, we want to enable writenotify while
+	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
+	 * recalculate vma->vm_page_prot whenever userfaultfd-wp is involved.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && uffd_wp)
+		vma_set_page_prot(vma);
+}
+
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -618,7 +633,8 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 		for_each_vma(vmi, vma) {
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-				vma->vm_flags &= ~__VM_UFFD_FLAGS;
+				userfaultfd_set_vm_flags(vma,
+							 vma->vm_flags & ~__VM_UFFD_FLAGS);
 			}
 		}
 		mmap_write_unlock(mm);
@@ -652,7 +668,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 	octx = vma->vm_userfaultfd_ctx.ctx;
 	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~__VM_UFFD_FLAGS;
+		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 		return 0;
 	}
 
@@ -733,7 +749,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 	} else {
 		/* Drop uffd context if remap feature not enabled */
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		vma->vm_flags &= ~__VM_UFFD_FLAGS;
+		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
 	}
 }
 
@@ -895,7 +911,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 			prev = vma;
 		}
 
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
 	mmap_write_unlock(mm);
@@ -1463,7 +1479,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
@@ -1651,7 +1667,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 * the next vma was merged into the current one and
 		 * the current one has not been updated yet.
 		 */
-		vma->vm_flags = new_flags;
+		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 
 	skip:
diff --git a/mm/mmap.c b/mm/mmap.c
index a5eb2f175da0..6033d20198b0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1525,6 +1525,10 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
 		return 1;
 
+	/* Do we need write faults for uffd-wp tracking? */
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	/* Specialty mapping? */
 	if (vm_flags & VM_PFNMAP)
 		return 0;

base-commit: 8ed710da2873c2aeb3bb805864a699affaf1d03b
-- 
2.38.1

