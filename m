Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C06B49BE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjCJPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjCJPOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A204B856B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 262FD61962
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD6CC433EF;
        Fri, 10 Mar 2023 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460698;
        bh=gRA5i6Ll8uZb9FpMjQsSfqxpmPmNk4NjAq3XzDaUMt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wntfVPQGZHornHr2NF81jGzytL2Cqxvru/9sZdlfFLRwg6UB7sJCMuW/TW4ntwZ7L
         B1UBOMT3Xmfdx+ZEiRwuqudXPemviWa9akAglXzadoL7y+7/5bx1KgjhGWJ0BKDCva
         OWXpoULizyxqO1UFvqbhPlVHgnZ/QP32qH4QvACY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Sistare <steven.sistare@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 422/529] vfio/type1: prevent underflow of locked_vm via exec()
Date:   Fri, 10 Mar 2023 14:39:25 +0100
Message-Id: <20230310133824.541147277@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Steve Sistare <steven.sistare@oracle.com>

commit 046eca5018f8a5dd1dc2cedf87fb5843b9ea3026 upstream.

When a vfio container is preserved across exec, the task does not change,
but it gets a new mm with locked_vm=0, and loses the count from existing
dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
to a large unsigned value, and a subsequent dma map request fails with
ENOMEM in __account_locked_vm.

To avoid underflow, grab and save the mm at the time a dma is mapped.
Use that mm when adjusting locked_vm, rather than re-acquiring the saved
task's mm, which may have changed.  If the saved mm is dead, do nothing.

locked_vm is incremented for existing mappings in a subsequent patch.

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-3-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   41 +++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -96,6 +96,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -391,8 +392,8 @@ static int vfio_lock_acct(struct vfio_dm
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
+	mm = dma->mm;
+	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
@@ -666,8 +667,8 @@ static int vfio_pin_page_external(struct
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
@@ -677,7 +678,7 @@ static int vfio_pin_page_external(struct
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vfio_lock_acct(dma, 1, false);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -1031,6 +1032,7 @@ static void vfio_remove_dma(struct vfio_
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	kfree(dma);
 	iommu->dma_avail++;
@@ -1452,29 +1454,15 @@ static int vfio_dma_do_map(struct vfio_i
 	 * against the locked memory limit and we need to be able to do both
 	 * outside of this call path as pinning can be asynchronous via the
 	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires a
-	 * task_struct and VM locked pages requires an mm_struct, however
-	 * holding an indefinite mm reference is not recommended, therefore we
-	 * only hold a reference to a task.  We could hold a reference to
-	 * current, however QEMU uses this call path through vCPU threads,
-	 * which can be killed resulting in a NULL mm and failure in the unmap
-	 * path when called via a different thread.  Avoid this problem by
-	 * using the group_leader as threads within the same group require
-	 * both CLONE_THREAD and CLONE_VM and will therefore use the same
-	 * mm_struct.
-	 *
-	 * Previously we also used the task for testing CAP_IPC_LOCK at the
-	 * time of pinning and accounting, however has_capability() makes use
-	 * of real_cred, a copy-on-write field, so we can't guarantee that it
-	 * matches group_leader, or in fact that it might not change by the
-	 * time it's evaluated.  If a process were to call MAP_DMA with
-	 * CAP_IPC_LOCK but later drop it, it doesn't make sense that they
-	 * possibly see different results for an iommu_mapped vfio_dma vs
-	 * externally mapped.  Therefore track CAP_IPC_LOCK in vfio_dma at the
-	 * time of calling MAP_DMA.
+	 * task_struct. Save the group_leader so that all DMA tracking uses
+	 * the same task, to make debugging easier.  VM locked pages requires
+	 * an mm_struct, so grab the mm in case the task dies.
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = current->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
@@ -2998,9 +2986,8 @@ static int vfio_iommu_type1_dma_rw_chunk
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
-
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -EPERM;
 
 	if (kthread)


