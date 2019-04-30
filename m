Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165ADF729
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfD3L4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbfD3Lsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C0820449;
        Tue, 30 Apr 2019 11:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624926;
        bh=YLgDBj29fs5z7tKNSm5DCu3BMVVy8eo/o3FNyZrZx0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTmPl364WAVd6xgCCSpfFShEYNxpwWc4+711hb+jqeRhqx1W4Errdi7oFknazN4sA
         c0MOnqbcMGYwWM/Ad0ASHGyjxaS83aIuFcZlLvEL4cjpkottUqQqkCfslfkLNXqqju
         mFdbwqqEhCURtnJ0veSroWNa3fUMBWmE5cWEiI/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.0 25/89] RDMA/ucontext: Fix regression with disassociate
Date:   Tue, 30 Apr 2019 13:38:16 +0200
Message-Id: <20190430113611.189238783@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 67f269b37f9b4d52c5e7f97acea26c0852e9b8a1 upstream.

When this code was consolidated the intention was that the VMA would
become backed by anonymous zero pages after the zap_vma_pte - however this
very subtly relied on setting the vm_ops = NULL and clearing the VM_SHARED
bits to transform the VMA into an anonymous VMA. Since the vm_ops was
removed this broke.

Now userspace gets a SIGBUS if it touches the vma after disassociation.

Instead of converting the VMA to anonymous provide a fault handler that
puts a zero'd page into the VMA when user-space touches it after
disassociation.

Cc: stable@vger.kernel.org
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Fixes: 5f9794dc94f5 ("RDMA/ucontext: Add a core API for mmaping driver IO memory")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs.h      |    1 
 drivers/infiniband/core/uverbs_main.c |   52 ++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -160,6 +160,7 @@ struct ib_uverbs_file {
 
 	struct mutex umap_lock;
 	struct list_head umaps;
+	struct page *disassociate_page;
 
 	struct idr		idr;
 	/* spinlock protects write access to idr */
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -208,6 +208,9 @@ void ib_uverbs_release_file(struct kref
 		kref_put(&file->async_file->ref,
 			 ib_uverbs_release_async_event_file);
 	put_device(&file->device->dev);
+
+	if (file->disassociate_page)
+		__free_pages(file->disassociate_page, 0);
 	kfree(file);
 }
 
@@ -876,9 +879,50 @@ static void rdma_umap_close(struct vm_ar
 	kfree(priv);
 }
 
+/*
+ * Once the zap_vma_ptes has been called touches to the VMA will come here and
+ * we return a dummy writable zero page for all the pfns.
+ */
+static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
+{
+	struct ib_uverbs_file *ufile = vmf->vma->vm_file->private_data;
+	struct rdma_umap_priv *priv = vmf->vma->vm_private_data;
+	vm_fault_t ret = 0;
+
+	if (!priv)
+		return VM_FAULT_SIGBUS;
+
+	/* Read only pages can just use the system zero page. */
+	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
+		vmf->page = ZERO_PAGE(vmf->vm_start);
+		get_page(vmf->page);
+		return 0;
+	}
+
+	mutex_lock(&ufile->umap_lock);
+	if (!ufile->disassociate_page)
+		ufile->disassociate_page =
+			alloc_pages(vmf->gfp_mask | __GFP_ZERO, 0);
+
+	if (ufile->disassociate_page) {
+		/*
+		 * This VMA is forced to always be shared so this doesn't have
+		 * to worry about COW.
+		 */
+		vmf->page = ufile->disassociate_page;
+		get_page(vmf->page);
+	} else {
+		ret = VM_FAULT_SIGBUS;
+	}
+	mutex_unlock(&ufile->umap_lock);
+
+	return ret;
+}
+
 static const struct vm_operations_struct rdma_umap_ops = {
 	.open = rdma_umap_open,
 	.close = rdma_umap_close,
+	.fault = rdma_umap_fault,
 };
 
 static struct rdma_umap_priv *rdma_user_mmap_pre(struct ib_ucontext *ucontext,
@@ -888,6 +932,9 @@ static struct rdma_umap_priv *rdma_user_
 	struct ib_uverbs_file *ufile = ucontext->ufile;
 	struct rdma_umap_priv *priv;
 
+	if (!(vma->vm_flags & VM_SHARED))
+		return ERR_PTR(-EINVAL);
+
 	if (vma->vm_end - vma->vm_start != size)
 		return ERR_PTR(-EINVAL);
 
@@ -991,7 +1038,7 @@ void uverbs_user_mmap_disassociate(struc
 		 * at a time to get the lock ordering right. Typically there
 		 * will only be one mm, so no big deal.
 		 */
-		down_write(&mm->mmap_sem);
+		down_read(&mm->mmap_sem);
 		if (!mmget_still_valid(mm))
 			goto skip_mm;
 		mutex_lock(&ufile->umap_lock);
@@ -1005,11 +1052,10 @@ void uverbs_user_mmap_disassociate(struc
 
 			zap_vma_ptes(vma, vma->vm_start,
 				     vma->vm_end - vma->vm_start);
-			vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
 		}
 		mutex_unlock(&ufile->umap_lock);
 	skip_mm:
-		up_write(&mm->mmap_sem);
+		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
 }


