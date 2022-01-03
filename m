Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DDE48320A
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiACOX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiACOX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:23:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF03C0613B3;
        Mon,  3 Jan 2022 06:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD52ECE1115;
        Mon,  3 Jan 2022 14:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C713C36AED;
        Mon,  3 Jan 2022 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219803;
        bh=YY1sQW1FVgUDuvcrNZ+Ekd3A5LSMeFM0G9tfngmySUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL4DZkYShdiJ1VWVWR/2Kt9Qjk+qM36WeZ/4sNa8LnjePiiA+UtXij5On2yqbko6Z
         vxHbx8dRTv1IngdJzk9euALYOj+GX/VU9MeoSXxNV076nSiAhBDUbyShw4N7jBQkgd
         q+9tkgFP5lYqwd3roOM8P/BnQsAnhxTWSkdAeZzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Patrik Lantz <patrik.lantz@axis.com>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 4.14 02/19] tee: handle lookup of shm with reference count 0
Date:   Mon,  3 Jan 2022 15:21:19 +0100
Message-Id: <20220103142052.148600283@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
References: <20220103142052.068378906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

commit dfd0743f1d9ea76931510ed150334d571fbab49d upstream.

Since the tee subsystem does not keep a strong reference to its idle
shared memory buffers, it races with other threads that try to destroy a
shared memory through a close of its dma-buf fd or by unmapping the
memory.

In tee_shm_get_from_id() when a lookup in teedev->idr has been
successful, it is possible that the tee_shm is in the dma-buf teardown
path, but that path is blocked by the teedev mutex. Since we don't have
an API to tell if the tee_shm is in the dma-buf teardown path or not we
must find another way of detecting this condition.

Fix this by doing the reference counting directly on the tee_shm using a
new refcount_t refcount field. dma-buf is replaced by using
anon_inode_getfd() instead, this separates the life-cycle of the
underlying file from the tee_shm. tee_shm_put() is updated to hold the
mutex when decreasing the refcount to 0 and then remove the tee_shm from
teedev->idr before releasing the mutex. This means that the tee_shm can
never be found unless it has a refcount larger than 0.

Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Lars Persson <larper@axis.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Reported-by: Patrik Lantz <patrik.lantz@axis.com>
[JW: backported to 4.14-stable]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_private.h |    4 -
 drivers/tee/tee_shm.c     |  155 ++++++++++++++++++----------------------------
 2 files changed, 63 insertions(+), 96 deletions(-)

--- a/drivers/tee/tee_private.h
+++ b/drivers/tee/tee_private.h
@@ -31,7 +31,7 @@ struct tee_device;
  * @paddr:	physical address of the shared memory
  * @kaddr:	virtual address of the shared memory
  * @size:	size of shared memory
- * @dmabuf:	dmabuf used to for exporting to user space
+ * @refcount:	reference counter
  * @flags:	defined by TEE_SHM_* in tee_drv.h
  * @id:		unique id of a shared memory object on this device
  */
@@ -42,7 +42,7 @@ struct tee_shm {
 	phys_addr_t paddr;
 	void *kaddr;
 	size_t size;
-	struct dma_buf *dmabuf;
+	refcount_t refcount;
 	u32 flags;
 	int id;
 };
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2015-2016, Linaro Limited
+ * Copyright (c) 2015-2017, 2019-2021 Linaro Limited
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -11,26 +11,19 @@
  * GNU General Public License for more details.
  *
  */
+#include <linux/anon_inodes.h>
 #include <linux/device.h>
-#include <linux/dma-buf.h>
-#include <linux/fdtable.h>
 #include <linux/idr.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
 #include "tee_private.h"
 
-static void tee_shm_release(struct tee_shm *shm)
+static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
 {
-	struct tee_device *teedev = shm->teedev;
 	struct tee_shm_pool_mgr *poolm;
 
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	if (shm->ctx)
-		list_del(&shm->link);
-	mutex_unlock(&teedev->mutex);
-
 	if (shm->flags & TEE_SHM_DMA_BUF)
 		poolm = &teedev->pool->dma_buf_mgr;
 	else
@@ -42,53 +35,6 @@ static void tee_shm_release(struct tee_s
 	tee_device_put(teedev);
 }
 
-static struct sg_table *tee_shm_op_map_dma_buf(struct dma_buf_attachment
-			*attach, enum dma_data_direction dir)
-{
-	return NULL;
-}
-
-static void tee_shm_op_unmap_dma_buf(struct dma_buf_attachment *attach,
-				     struct sg_table *table,
-				     enum dma_data_direction dir)
-{
-}
-
-static void tee_shm_op_release(struct dma_buf *dmabuf)
-{
-	struct tee_shm *shm = dmabuf->priv;
-
-	tee_shm_release(shm);
-}
-
-static void *tee_shm_op_map_atomic(struct dma_buf *dmabuf, unsigned long pgnum)
-{
-	return NULL;
-}
-
-static void *tee_shm_op_map(struct dma_buf *dmabuf, unsigned long pgnum)
-{
-	return NULL;
-}
-
-static int tee_shm_op_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
-{
-	struct tee_shm *shm = dmabuf->priv;
-	size_t size = vma->vm_end - vma->vm_start;
-
-	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
-			       size, vma->vm_page_prot);
-}
-
-static const struct dma_buf_ops tee_shm_dma_buf_ops = {
-	.map_dma_buf = tee_shm_op_map_dma_buf,
-	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
-	.release = tee_shm_op_release,
-	.map_atomic = tee_shm_op_map_atomic,
-	.map = tee_shm_op_map,
-	.mmap = tee_shm_op_mmap,
-};
-
 /**
  * tee_shm_alloc() - Allocate shared memory
  * @ctx:	Context that allocates the shared memory
@@ -135,6 +81,7 @@ struct tee_shm *tee_shm_alloc(struct tee
 		goto err_dev_put;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -157,29 +104,11 @@ struct tee_shm *tee_shm_alloc(struct tee
 		goto err_pool_free;
 	}
 
-	if (flags & TEE_SHM_DMA_BUF) {
-		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
-
-		exp_info.ops = &tee_shm_dma_buf_ops;
-		exp_info.size = shm->size;
-		exp_info.flags = O_RDWR;
-		exp_info.priv = shm;
-
-		shm->dmabuf = dma_buf_export(&exp_info);
-		if (IS_ERR(shm->dmabuf)) {
-			ret = ERR_CAST(shm->dmabuf);
-			goto err_rem;
-		}
-	}
 	mutex_lock(&teedev->mutex);
 	list_add_tail(&shm->link, &ctx->list_shm);
 	mutex_unlock(&teedev->mutex);
 
 	return shm;
-err_rem:
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	mutex_unlock(&teedev->mutex);
 err_pool_free:
 	poolm->ops->free(poolm, shm);
 err_kfree:
@@ -190,6 +119,31 @@ err_dev_put:
 }
 EXPORT_SYMBOL_GPL(tee_shm_alloc);
 
+static int tee_shm_fop_release(struct inode *inode, struct file *filp)
+{
+	tee_shm_put(filp->private_data);
+	return 0;
+}
+
+static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct tee_shm *shm = filp->private_data;
+	size_t size = vma->vm_end - vma->vm_start;
+
+	/* check for overflowing the buffer's size */
+	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
+			       size, vma->vm_page_prot);
+}
+
+static const struct file_operations tee_shm_fops = {
+	.owner = THIS_MODULE,
+	.release = tee_shm_fop_release,
+	.mmap = tee_shm_fop_mmap,
+};
+
 /**
  * tee_shm_get_fd() - Increase reference count and return file descriptor
  * @shm:	Shared memory handle
@@ -203,10 +157,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
 	if ((shm->flags & req_flags) != req_flags)
 		return -EINVAL;
 
-	get_dma_buf(shm->dmabuf);
-	fd = dma_buf_fd(shm->dmabuf, O_CLOEXEC);
+	/* matched by tee_shm_put() in tee_shm_op_release() */
+	refcount_inc(&shm->refcount);
+	fd = anon_inode_getfd("tee_shm", &tee_shm_fops, shm, O_RDWR);
 	if (fd < 0)
-		dma_buf_put(shm->dmabuf);
+		tee_shm_put(shm);
 	return fd;
 }
 
@@ -216,17 +171,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
  */
 void tee_shm_free(struct tee_shm *shm)
 {
-	/*
-	 * dma_buf_put() decreases the dmabuf reference counter and will
-	 * call tee_shm_release() when the last reference is gone.
-	 *
-	 * In the case of driver private memory we call tee_shm_release
-	 * directly instead as it doesn't have a reference counter.
-	 */
-	if (shm->flags & TEE_SHM_DMA_BUF)
-		dma_buf_put(shm->dmabuf);
-	else
-		tee_shm_release(shm);
+	tee_shm_put(shm);
 }
 EXPORT_SYMBOL_GPL(tee_shm_free);
 
@@ -327,10 +272,15 @@ struct tee_shm *tee_shm_get_from_id(stru
 	teedev = ctx->teedev;
 	mutex_lock(&teedev->mutex);
 	shm = idr_find(&teedev->idr, id);
+	/*
+	 * If the tee_shm was found in the IDR it must have a refcount
+	 * larger than 0 due to the guarantee in tee_shm_put() below. So
+	 * it's safe to use refcount_inc().
+	 */
 	if (!shm || shm->ctx != ctx)
 		shm = ERR_PTR(-EINVAL);
-	else if (shm->flags & TEE_SHM_DMA_BUF)
-		get_dma_buf(shm->dmabuf);
+	else
+		refcount_inc(&shm->refcount);
 	mutex_unlock(&teedev->mutex);
 	return shm;
 }
@@ -353,7 +303,24 @@ EXPORT_SYMBOL_GPL(tee_shm_get_id);
  */
 void tee_shm_put(struct tee_shm *shm)
 {
-	if (shm->flags & TEE_SHM_DMA_BUF)
-		dma_buf_put(shm->dmabuf);
+	struct tee_device *teedev = shm->teedev;
+	bool do_release = false;
+
+	mutex_lock(&teedev->mutex);
+	if (refcount_dec_and_test(&shm->refcount)) {
+		/*
+		 * refcount has reached 0, we must now remove it from the
+		 * IDR before releasing the mutex.  This will guarantee
+		 * that the refcount_inc() in tee_shm_get_from_id() never
+		 * starts from 0.
+		 */
+		if (shm->ctx)
+			list_del(&shm->link);
+		do_release = true;
+	}
+	mutex_unlock(&teedev->mutex);
+
+	if (do_release)
+		tee_shm_release(teedev, shm);
 }
 EXPORT_SYMBOL_GPL(tee_shm_put);


