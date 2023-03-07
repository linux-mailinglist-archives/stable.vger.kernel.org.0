Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1162A6AED8E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjCGSFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjCGSFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:05:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F2C4E5C9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB7C361509
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF4C433D2;
        Tue,  7 Mar 2023 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211887;
        bh=Kf4U3z9o1Jis115Nt0QAsxq4847OoVkrqJJWO984S1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUy7PD/EqMtNizg+d5bsx+5eoEzFKsXapZjSkZJZhKIfsqqO9EoBSTmB0GDJ3FkaE
         gidAUJtYwnS4bCTLL7LtPXOj/Mm57MbXmbQpsrWxdwYTGwEN1pVWBJBNP4tuwG7kKV
         fIZvwvKGHgZpKWYZWoy+0ExzQ/MgBAAXZpYj6ybY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Sistare <steven.sistare@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.2 0993/1001] vfio/type1: restore locked_vm
Date:   Tue,  7 Mar 2023 18:02:45 +0100
Message-Id: <20230307170105.377939093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Sistare <steven.sistare@oracle.com>

commit 90fdd158a695d70403163f9a0e4efc5b20f3fd3e upstream.

When a vfio container is preserved across exec or fork-exec, the new
task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
not count against the task's RLIMIT_MEMLOCK.

To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
used and the dma's mm has changed, add the dma's locked_vm count to
the new mm->locked_vm, subject to the rlimit, and subtract it from the
old mm->locked_vm.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-5-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/vfio_iommu_type1.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1591,6 +1591,38 @@ static bool vfio_iommu_iova_dma_valid(st
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	struct task_struct *task = current->group_leader;
+	struct mm_struct *mm = current->mm;
+	long npage = dma->locked_vm;
+	bool lock_cap;
+	int ret;
+
+	if (mm == dma->mm)
+		return 0;
+
+	lock_cap = capable(CAP_IPC_LOCK);
+	ret = mm_lock_acct(task, mm, lock_cap, npage);
+	if (ret)
+		return ret;
+
+	if (mmget_not_zero(dma->mm)) {
+		mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage);
+		mmput(dma->mm);
+	}
+
+	if (dma->task != task) {
+		put_task_struct(dma->task);
+		dma->task = get_task_struct(task);
+	}
+	mmdrop(dma->mm);
+	dma->mm = mm;
+	mmgrab(dma->mm);
+	dma->lock_cap = lock_cap;
+	return 0;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1640,6 +1672,9 @@ static int vfio_dma_do_map(struct vfio_i
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;


