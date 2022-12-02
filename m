Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240616406D1
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiLBM2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiLBM2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25658D648
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669984078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3IQT7HVPdE5UCXxrPvYWxf1yUdiJyVxk5WLvcPgmxZA=;
        b=UhH2msk1WuW9hU3m2Tw9Xo1XOod9Oa5X7mpFacwj/KP+aQli78542FI0QhE+mvMUQJIHpf
        ttPHlxBCrdkORItTWwRdZCRNMQVN4t1Js68iKZN3xHjOvpHdXBYd53x9Q1wbW2voIT6MST
        LfzitArF8gqwTB4//UloxEwZmeI+t7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-6wnuje_JMaatQLLlcIK-6g-1; Fri, 02 Dec 2022 07:27:55 -0500
X-MC-Unique: 6wnuje_JMaatQLLlcIK-6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C324185A78F;
        Fri,  2 Dec 2022 12:27:54 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.193.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 887AA63A57;
        Fri,  2 Dec 2022 12:27:51 +0000 (UTC)
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
Subject: [PATCH RFC] mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date:   Fri,  2 Dec 2022 13:27:48 +0100
Message-Id: <20221202122748.113774-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, we don't enable writenotify when enabling userfaultfd-wp on
a shared writable mapping (for now we only support SHMEM). The consequence
is that vma->vm_page_prot will still include write permissions, to be set
as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
page migration, ...).

This is problematic for uffd-wp: we'd have to manually check for
a uffd-wp PTE and manually write-protect that PTE, which is error prone
and the logic is the wrong way around. Prone to such issues is any code
that uses vma->vm_page_prot to set PTE permissions: primarily pte_modify()
and mk_pte(), but there might be more (move_pte() looked suspicious at
first but the protection parameter is essentially unused).

Instead, let's enable writenotify -- just like we do for softdirty
tracking -- such that PTEs will be mapped write-protected as default
and we will only allow selected PTEs that are defintly safe to be
mapped without write-protection (see can_change_pte_writable()) to be
writable. This reverses the logic and implicitly fixes and prevents any
such uffd-wp issues.

Note that when enabling userfaultfd-wp, there is no need to walk page
tables to enforce the new default protection for the PTEs: we know that
they cannot be uffd-wp'ed yet, because that can only happen afterwards.

For example, this fixes page migration and mprotect() to not map a
uffd-wp'ed PTE writable. In theory, this should also fix when NUMA-hinting
remaps pages in such (shmem) mappings -- if NUMA-hinting is applicable to
shmem with uffd as well.

Running the mprotect() reproducer [1] without this commit:
  $ ./uffd-wp-mprotect
  FAIL: uffd-wp did not fire
Running the mprotect() reproducer with this commit:
  $ ./uffd-wp-mprotect
  PASS: uffd-wp fired

[1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u

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

Based on latest upstream. userfaultfd selftests seem to pass.

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
index 74a84eb33b90..ce7526aa5d61 100644
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

base-commit: a4412fdd49dc011bcc2c0d81ac4cab7457092650
-- 
2.38.1

