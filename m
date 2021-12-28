Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F1A48076C
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhL1Idg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhL1Idg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 03:33:36 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79390C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:33:35 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id r22so29483701ljk.11
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nJRzWslgNccgxG4MIf29u0dhy3dS/6NTua8/ag1MF6I=;
        b=YZNz0zzHup1F6p1NUDdzGKz8SLAK8zlR+jXl1z1U/Dnk5UsdEhHSk8fGPxhQf0VgNL
         MtgaTG1OYyQC16nCcNYnbI7qQL5eCtcWNatYAM9HSo8yzU+A859+YXo25J5Uluri84xb
         sWgYcZ6VCbqw+h1PdcDoFgjfi2TA40r4YARHs2YL9YNjazPH7cDPLgv1e/4JWyHIp9w4
         aFf6p6ryDX2OTW9FNg3ayKiVnTnB5InnF92XCnw+tkFYSowDu8reYCoPjmxxi23ea1xf
         CFSQTYyAq9I94B8gDGFfTo8VMLdiq1OkpRjVb+5S2IjtR5R4iFfqzP6sCHaRCsJnh+ut
         aTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nJRzWslgNccgxG4MIf29u0dhy3dS/6NTua8/ag1MF6I=;
        b=sWq0IAu7TBCTjatCnkOKlXS0yJy9rh1tJOXeq8iCm32a9SP5YQXhITYuSbaa9DLDcl
         HLGWpZNHH2rcMf9Y9IYte1fpIXJNqUwCzj8SqGJDbT8kvVqCS08HrLcclQZUfcY9QRbH
         PP64FA3z/HZqQZSMuhShnTewDpdH8kCiKPFdZ88kXqenhjRl7mLF7bG7vxbiaPl5fCls
         GVsmYkrndjWXEhZ+nt7dvkaa/Z8QlK6xubNyjiqapsZ6+5E4/7rhplWnOLa9xAnY/HeV
         U0gfk386xBy2KvN7PkpGLLuUpoH6Jnz5H9Y9aqa0p5Clp0+TgBFlV8K+hT1YgBGoRuXH
         9QIw==
X-Gm-Message-State: AOAM532TYp+ivtZ5+X3ct0Av6vi7fj602oxfn04ZZeXBI7ObtjnzpWsR
        AHJTsdQdEWZEZmNHZlrvrxGqBs4X7c5QMg==
X-Google-Smtp-Source: ABdhPJxPRI8VoNELzenU0jZ89rIaINl1Ne/OFf/a2oSZw15dQRAj+mmZDK9b9ZZoV9PZ50UiaQzIVg==
X-Received: by 2002:a05:651c:1993:: with SMTP id bx19mr1274195ljb.472.1640680413495;
        Tue, 28 Dec 2021 00:33:33 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id b17sm1865046lfq.238.2021.12.28.00.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 00:33:33 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: [PATCH backport for 5.4] tee: handle lookup of shm with reference count 0
Date:   Tue, 28 Dec 2021 09:32:55 +0100
Message-Id: <20211228083255.1350258-1-jens.wiklander@linaro.org>
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
[JW: backport to 5.4-stable]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_shm.c   | 177 +++++++++++++++-------------------------
 include/linux/tee_drv.h |   4 +-
 2 files changed, 69 insertions(+), 112 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index d6491e973fa4..0d5ae8053049 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -1,26 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2015-2016, Linaro Limited
+ * Copyright (c) 2015-2017, 2019-2021 Linaro Limited
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
 
@@ -52,51 +44,6 @@ static void tee_shm_release(struct tee_shm *shm)
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
@@ -137,6 +84,7 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 		goto err_dev_put;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags | TEE_SHM_POOL;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -159,21 +107,6 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
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
@@ -182,10 +115,6 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 	}
 
 	return shm;
-err_rem:
-	mutex_lock(&teedev->mutex);
-	idr_remove(&teedev->idr, shm->id);
-	mutex_unlock(&teedev->mutex);
 err_pool_free:
 	poolm->ops->free(poolm, shm);
 err_kfree:
@@ -268,6 +197,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags | TEE_SHM_REGISTER;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -309,22 +239,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
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
@@ -352,6 +266,35 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
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
@@ -364,10 +307,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
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
 
@@ -377,17 +321,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
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
 
@@ -494,10 +428,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
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
@@ -509,7 +448,25 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
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
index cd15c1b7fae0..e08ace76eba6 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -178,7 +178,7 @@ void tee_device_unregister(struct tee_device *teedev);
  * @offset:	offset of buffer in user space
  * @pages:	locked pages from userspace
  * @num_pages:	number of locked pages
- * @dmabuf:	dmabuf used to for exporting to user space
+ * @refcount:	reference counter
  * @flags:	defined by TEE_SHM_* in tee_drv.h
  * @id:		unique id of a shared memory object on this device
  *
@@ -195,7 +195,7 @@ struct tee_shm {
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

