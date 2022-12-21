Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6426538AC
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiLUWcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiLUWck (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78EAFF0;
        Wed, 21 Dec 2022 14:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 015BBCE1810;
        Wed, 21 Dec 2022 22:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C763C43398;
        Wed, 21 Dec 2022 22:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661952;
        bh=J1bfbDc7oe7s95YrwY5YCfUyCN4K1eobm2GpGAd9G7c=;
        h=Date:To:From:Subject:From;
        b=EoiqTTPQfh1kpA3uxFN4t4ePJzJlUei1g97jYk6uLbQtdB40JYThIf99ht20q1wf7
         +Z+Ws9Br74Ms+BH7ZFTnPFmATkDP7/W8ee0IM4iOWphZN92Gx5ktLDiCtMXnw3aWe7
         RXh24KBoM/f6rFkdIBCoM048mdy6bVQiJQmpM4WY=
Date:   Wed, 21 Dec 2022 14:32:31 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, linmiaohe@huawei.com,
        jthoughton@google.com, david@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-really-allocate-vma-lock-for-all-sharable-vmas.patch removed from -mm tree
Message-Id: <20221221223232.3C763C43398@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: really allocate vma lock for all sharable vmas
has been removed from the -mm tree.  Its filename was
     hugetlb-really-allocate-vma-lock-for-all-sharable-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: really allocate vma lock for all sharable vmas
Date: Mon, 12 Dec 2022 15:50:41 -0800

Commit bbff39cc6cbc ("hugetlb: allocate vma lock for all sharable vmas")
removed the pmd sharable checks in the vma lock helper routines.  However,
it left the functional version of helper routines behind #ifdef
CONFIG_ARCH_WANT_HUGE_PMD_SHARE.  Therefore, the vma lock is not being
used for sharable vmas on architectures that do not support pmd sharing. 
On these architectures, a potential fault/truncation race is exposed that
could leave pages in a hugetlb file past i_size until the file is removed.

Move the functional vma lock helpers outside the ifdef, and remove the
non-functional stubs.  Since the vma lock is not just for pmd sharing,
rename the routine __vma_shareable_flags_pmd.

Link: https://lkml.kernel.org/r/20221212235042.178355-1-mike.kravetz@oracle.com
Fixes: bbff39cc6cbc ("hugetlb: allocate vma lock for all sharable vmas")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  333 +++++++++++++++++++++----------------------------
 1 file changed, 148 insertions(+), 185 deletions(-)

--- a/mm/hugetlb.c~hugetlb-really-allocate-vma-lock-for-all-sharable-vmas
+++ a/mm/hugetlb.c
@@ -255,6 +255,152 @@ static inline struct hugepage_subpool *s
 	return subpool_inode(file_inode(vma->vm_file));
 }
 
+/*
+ * hugetlb vma_lock helper routines
+ */
+static bool __vma_shareable_lock(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
+		vma->vm_private_data;
+}
+
+void hugetlb_vma_lock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_write(&vma_lock->rw_sema);
+	}
+}
+
+int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+	if (!__vma_shareable_lock(vma))
+		return 1;
+
+	return down_write_trylock(&vma_lock->rw_sema);
+}
+
+void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		lockdep_assert_held(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_release(struct kref *kref)
+{
+	struct hugetlb_vma_lock *vma_lock = container_of(kref,
+			struct hugetlb_vma_lock, refs);
+
+	kfree(vma_lock);
+}
+
+static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
+{
+	struct vm_area_struct *vma = vma_lock->vma;
+
+	/*
+	 * vma_lock structure may or not be released as a result of put,
+	 * it certainly will no longer be attached to vma so clear pointer.
+	 * Semaphore synchronizes access to vma_lock->vma field.
+	 */
+	vma_lock->vma = NULL;
+	vma->vm_private_data = NULL;
+	up_write(&vma_lock->rw_sema);
+	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+}
+
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
+{
+	/*
+	 * Only present in sharable vmas.
+	 */
+	if (!vma || !__vma_shareable_lock(vma))
+		return;
+
+	if (vma->vm_private_data) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock;
+
+	/* Only establish in (flags) sharable vmas */
+	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	/* Should never get here with non-NULL vm_private_data */
+	if (vma->vm_private_data)
+		return;
+
+	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
+	if (!vma_lock) {
+		/*
+		 * If we can not allocate structure, then vma can not
+		 * participate in pmd sharing.  This is only a possible
+		 * performance enhancement and memory saving issue.
+		 * However, the lock is also used to synchronize page
+		 * faults with truncation.  If the lock is not present,
+		 * unlikely races could leave pages in a file past i_size
+		 * until the file is removed.  Warn in the unlikely case of
+		 * allocation failure.
+		 */
+		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
+		return;
+	}
+
+	kref_init(&vma_lock->refs);
+	init_rwsem(&vma_lock->rw_sema);
+	vma_lock->vma = vma;
+	vma->vm_private_data = vma_lock;
+}
+
 /* Helper that removes a struct file_region from the resv_map cache and returns
  * it for use.
  */
@@ -6613,7 +6759,8 @@ bool hugetlb_reserve_pages(struct inode
 	}
 
 	/*
-	 * vma specific semaphore used for pmd sharing synchronization
+	 * vma specific semaphore used for pmd sharing and fault/truncation
+	 * synchronization
 	 */
 	hugetlb_vma_lock_alloc(vma);
 
@@ -6869,149 +7016,6 @@ void adjust_range_if_pmd_sharing_possibl
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
-static bool __vma_shareable_flags_pmd(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
-}
-
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_write(&vma_lock->rw_sema);
-	}
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-	if (!__vma_shareable_flags_pmd(vma))
-		return 1;
-
-	return down_write_trylock(&vma_lock->rw_sema);
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		lockdep_assert_held(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-	struct hugetlb_vma_lock *vma_lock = container_of(kref,
-			struct hugetlb_vma_lock, refs);
-
-	kfree(vma_lock);
-}
-
-static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
-{
-	struct vm_area_struct *vma = vma_lock->vma;
-
-	/*
-	 * vma_lock structure may or not be released as a result of put,
-	 * it certainly will no longer be attached to vma so clear pointer.
-	 * Semaphore synchronizes access to vma_lock->vma field.
-	 */
-	vma_lock->vma = NULL;
-	vma->vm_private_data = NULL;
-	up_write(&vma_lock->rw_sema);
-	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-	/*
-	 * Only present in sharable vmas.
-	 */
-	if (!vma || !__vma_shareable_flags_pmd(vma))
-		return;
-
-	if (vma->vm_private_data) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock;
-
-	/* Only establish in (flags) sharable vmas */
-	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
-		return;
-
-	/* Should never get here with non-NULL vm_private_data */
-	if (vma->vm_private_data)
-		return;
-
-	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
-	if (!vma_lock) {
-		/*
-		 * If we can not allocate structure, then vma can not
-		 * participate in pmd sharing.  This is only a possible
-		 * performance enhancement and memory saving issue.
-		 * However, the lock is also used to synchronize page
-		 * faults with truncation.  If the lock is not present,
-		 * unlikely races could leave pages in a file past i_size
-		 * until the file is removed.  Warn in the unlikely case of
-		 * allocation failure.
-		 */
-		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
-		return;
-	}
-
-	kref_init(&vma_lock->refs);
-	init_rwsem(&vma_lock->rw_sema);
-	vma_lock->vma = vma;
-	vma->vm_private_data = vma_lock;
-}
-
 /*
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
@@ -7100,47 +7104,6 @@ int huge_pmd_unshare(struct mm_struct *m
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	return 1;
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-}
-
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch
hugetlb-initialize-variable-to-avoid-compiler-warning.patch

