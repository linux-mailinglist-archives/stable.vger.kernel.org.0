Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13F48076E
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhL1Iea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhL1Iea (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 03:34:30 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A174C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:34:29 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id x4so12014036ljc.6
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEO3msYWqm6yJxgPgaBJSakGQZD4QkDwiMV+7+bf/L4=;
        b=mzyixoKXswY6PaUEb2xEfXGqtsvRzGYgKE2bfsguxoqRtZtWrJU2c9iusJK1XjtrXt
         Zjkfhg8wU5L1x1AF+hm/fBK3Z5C5pnX1rKyiUNbyRycyN5si9ZHjFliuny+8bV5c0jCd
         p0J/JFklL/XTbCvVh3nwLOfc3mDK3Pt3xzJgCNPO8Q9RR/n5jup42DgGB3VvfLB2laSg
         WORemPzfQc9+KWOQVPfBd1sgjYk99pAomBTX+L/TdTtsKNY/NuBwaYw7i6qFB0nDPdqI
         V7xJs2GUMwnNxdtpfx5YXK98JYfvsj111FoBuMUQFpDitAYylWeBL/5TJCBQJ+cyTN4e
         6sHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fEO3msYWqm6yJxgPgaBJSakGQZD4QkDwiMV+7+bf/L4=;
        b=G4LhOnkBoXDAf3gcv0IMVvAQ+77PyGqqmXSnH8WJHu7edov2hk45qsYPanvCqpR9ow
         vHnU2f4JDfHgbkt+F+mKqCgtIpYC1WtKpCnsAJFbZyQFK1z5iJodt36DkkVfNovMTTtR
         OqG5Ra+54zRhhlNlrsDTRF2tFxBYfKGbwRIAqWxsRzzKpP/6tIkVW+Xpw9xC1WyavJdO
         j22ylupzm6wc0FoqG6xETOS2477pVuaeC+GDYz/Yw0pnza3Ww+dgA6lm7805txkN4uk5
         GzKbRBn31ZFuNi+oexd+MYXxyFFyAvdVgtnOGmo0JsGPHc0N/eVNbdKO5nEBFvuYtIea
         XJTA==
X-Gm-Message-State: AOAM530kxtY10ZHtary1EzZtI4DUg9Ys9CCIEpnPQDrRJTovM84xQmd1
        THxJhr7U8mzxEMXdnkSl4YC0FdIBcoMd7Q==
X-Google-Smtp-Source: ABdhPJx8LmERKtf/4YrIuMoJ9klgOnf9/vA9ySqJ5SykMGB5KQH4wLT3ocFu+DX/I4RYcDl/gChUxg==
X-Received: by 2002:a2e:6e0d:: with SMTP id j13mr16183525ljc.124.1640680467596;
        Tue, 28 Dec 2021 00:34:27 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id f27sm1154591lfk.266.2021.12.28.00.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 00:34:27 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: [PATCH backport for 4.19] tee: handle lookup of shm with reference count 0
Date:   Tue, 28 Dec 2021 09:34:20 +0100
Message-Id: <20211228083420.1350472-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[JW: backport to 4.19-stable]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_shm.c   | 177 +++++++++++++++-------------------------
 include/linux/tee_drv.h |   4 +-
 2 files changed, 69 insertions(+), 112 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 0b9ab1d0dd45..5fd5aa5f0a1d 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2015-2016, Linaro Limited
+ * Copyright (c) 2015-2017, 2019-2021 Linaro Limited
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -11,25 +11,17 @@
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
-
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	if (shm->ctx)
-		list_del(&shm->link);
-	mutex_unlock(&teedev->mutex);
-
 	if (shm->flags & TEE_SHM_POOL) {
 		struct tee_shm_pool_mgr *poolm;
 
@@ -61,51 +53,6 @@ static void tee_shm_release(struct tee_shm *shm)
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
-	/* Refuse sharing shared memory provided by application */
-	if (shm->flags & TEE_SHM_REGISTER)
-		return -EINVAL;
-
-	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
-			       size, vma->vm_page_prot);
-}
-
-static const struct dma_buf_ops tee_shm_dma_buf_ops = {
-	.map_dma_buf = tee_shm_op_map_dma_buf,
-	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
-	.release = tee_shm_op_release,
-	.map = tee_shm_op_map,
-	.mmap = tee_shm_op_mmap,
-};
-
 static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 				       struct tee_device *teedev,
 				       size_t size, u32 flags)
@@ -146,6 +93,7 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 		goto err_dev_put;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags | TEE_SHM_POOL;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -168,21 +116,6 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
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
-
 	if (ctx) {
 		teedev_ctx_get(ctx);
 		mutex_lock(&teedev->mutex);
@@ -191,10 +124,6 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 	}
 
 	return shm;
-err_rem:
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	mutex_unlock(&teedev->mutex);
 err_pool_free:
 	poolm->ops->free(poolm, shm);
 err_kfree:
@@ -259,6 +188,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags | TEE_SHM_REGISTER;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -299,22 +229,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
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
-			teedev->desc->ops->shm_unregister(ctx, shm);
-			goto err;
-		}
-	}
-
 	mutex_lock(&teedev->mutex);
 	list_add_tail(&shm->link, &ctx->list_shm);
 	mutex_unlock(&teedev->mutex);
@@ -342,6 +256,35 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(tee_shm_register);
 
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
+	/* Refuse sharing shared memory provided by application */
+	if (shm->flags & TEE_SHM_USER_MAPPED)
+		return -EINVAL;
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
@@ -354,10 +297,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
 	if (!(shm->flags & TEE_SHM_DMA_BUF))
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
 
@@ -367,17 +311,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
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
 
@@ -484,10 +418,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
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
@@ -499,7 +438,25 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
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
+		 * IDR before releasing the mutex. This will guarantee that
+		 * the refcount_inc() in tee_shm_get_from_id() never starts
+		 * from 0.
+		 */
+		idr_remove(&teedev->idr, shm->id);
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
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index a2b3dfcee0b5..535f2ecf3c16 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -177,7 +177,7 @@ void tee_device_unregister(struct tee_device *teedev);
  * @offset:	offset of buffer in user space
  * @pages:	locked pages from userspace
  * @num_pages:	number of locked pages
- * @dmabuf:	dmabuf used to for exporting to user space
+ * @refcount:	reference counter
  * @flags:	defined by TEE_SHM_* in tee_drv.h
  * @id:		unique id of a shared memory object on this device
  *
@@ -194,7 +194,7 @@ struct tee_shm {
 	unsigned int offset;
 	struct page **pages;
 	size_t num_pages;
-	struct dma_buf *dmabuf;
+	refcount_t refcount;
 	u32 flags;
 	int id;
 };
-- 
2.31.1

