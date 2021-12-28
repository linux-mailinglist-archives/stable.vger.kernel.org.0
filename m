Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2187E480772
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 09:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhL1IfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 03:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhL1IfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 03:35:10 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E08C061574
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:35:10 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h2so29377438lfv.9
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 00:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvIkZbvOgvA3vk4sK2ntrPrUDNftwiaaZqwx2chsKT0=;
        b=HAun6Cu/Zogjap0oZUq/XjY2gZl9LkiG30CBzuQBZlXbC7EcC3wcfmNqaD1GzrUHIZ
         axfIePA2BqXr8fk0k7yfcK94+GcToMRl/d/Fjrb50etkZwCmzagv3CoQq+M20HA6X6ah
         uXBAz7UZwXmcI/3VQ0Dq5JTEotm7YcAtz4NqCMKDI1SSj5Pexv/K2F+KhI+G9QVR5vGU
         ryWTrJijcCYPTNIQ3eclwk/0N/Bz4Z2istKwxOaFDimsiJtM4kBAnJINxCwKf2A6l4da
         Nerh0/vWY+s6wN3FO6raHyYp1U7M3PTjqtTB+YiCJPThfOYsRMZf/MnNa/MAiyGJm8EY
         QguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvIkZbvOgvA3vk4sK2ntrPrUDNftwiaaZqwx2chsKT0=;
        b=4UZnG8V97tplSFTS2IvehsoGUZNlk6h2TZXYLrcmb1LmUJGZ17TmfjUSY0Jq2vAsZ2
         qIZgKir2XxxvOGNmWOLW8GXEzmiB63TDbCQrD5BpIZmQ0yDuttGaulK38zKyw7f27mmP
         c/A7ZY0d/z9xXlkjgB7uynIGtql3XSO0Vka4vZXYtFIL2+10OElXFgYtOhYYKtrlr4zf
         du2HeQMbjxuJNKCya34o/J+YENQC4RUIu5YkIr9LdFJtqj+PYrVcNyn4ER2Yf5l3A2sH
         O9r9tVy3+gD55fJUbhbXy/uxMw2vBaw7p2dLx5q425tjYiDLkeZusRWymd0PgA94Qt6+
         OC0g==
X-Gm-Message-State: AOAM533r7CpiW3dvyRtKgXmIlIAtHptzake1/6McHBcONYeqLQP73Lyf
        pnN/l7AFDvyy5nAFpyH/gtq7YQggaXRfoQ==
X-Google-Smtp-Source: ABdhPJwmjsXTMEX6kPTrssOuNF6BnSakNhZ3UzsQwr+Hn5RqL8HXymAA5q8DwhE7RO5uqyFXiAgCdg==
X-Received: by 2002:a05:6512:114e:: with SMTP id m14mr16114347lfg.414.1640680507440;
        Tue, 28 Dec 2021 00:35:07 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id c16sm1872722lfv.29.2021.12.28.00.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 00:35:07 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: [PATCH backport for 4.14] tee: handle lookup of shm with reference count 0
Date:   Tue, 28 Dec 2021 09:35:01 +0100
Message-Id: <20211228083501.1350554-1-jens.wiklander@linaro.org>
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
[JW: backported to 4.14-stable]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_private.h |   4 +-
 drivers/tee/tee_shm.c     | 155 +++++++++++++++-----------------------
 2 files changed, 63 insertions(+), 96 deletions(-)

diff --git a/drivers/tee/tee_private.h b/drivers/tee/tee_private.h
index 21cb6be8bce9..4ef325f782d1 100644
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
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index ea3ce4e17b85..b8f171b9658b 100644
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
@@ -42,53 +35,6 @@ static void tee_shm_release(struct tee_shm *shm)
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
@@ -135,6 +81,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
 		goto err_dev_put;
 	}
 
+	refcount_set(&shm->refcount, 1);
 	shm->flags = flags;
 	shm->teedev = teedev;
 	shm->ctx = ctx;
@@ -157,29 +104,11 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
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
@@ -190,6 +119,31 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
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
 
@@ -327,10 +272,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
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
-- 
2.31.1

