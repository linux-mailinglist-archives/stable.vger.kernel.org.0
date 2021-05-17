Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6336538362A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244399AbhEQP3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244142AbhEQP1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698A561CAA;
        Mon, 17 May 2021 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262201;
        bh=tc2KOuYG0tEDjQ57RGaQX3frUhQcgUEZOdWRNm4kWuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vce2cUhCHQEBFqrBfI6hIf8apVpDYpXG3f+OvwE+RMcdmQzOi2/9s2U0ZLc4wpkK0
         u+EUMQhiQkikG6DizOSXQh7Hzzgudhbl+HQgQn+MRIDEkyRPr/arDVOtGGuNq3p1xt
         CN93bvV0Qy8GzfHXP3v1lfUaounw/hYdvt3W9+gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/289] dmaengine: idxd: fix cdev setup and free device lifetime issues
Date:   Mon, 17 May 2021 16:00:57 +0200
Message-Id: <20210517140309.608967895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 04922b7445a1950b86f130a1fe8c52cc27b3e30b ]

The char device setup and cleanup has device lifetime issues regarding when
parts are initialized and cleaned up. The initialization of struct device is
done incorrectly. device_initialize() needs to be called on the 'struct
device' and then additional changes can be added. The ->release() function
needs to be setup via device_type before dev_set_name() to allow proper
cleanup. The change re-parents the cdev under the wq->conf_dev to get
natural reference inheritance. No known dependency on the old device path exists.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: 42d279f9137a ("dmaengine: idxd: add char driver to expose submission portal to userland")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/161852987721.2203940.1478218825576630810.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c  | 129 ++++++++++++++-------------------------
 drivers/dma/idxd/idxd.h  |   7 ++-
 drivers/dma/idxd/init.c  |   2 +-
 drivers/dma/idxd/irq.c   |   4 +-
 drivers/dma/idxd/sysfs.c |  10 ++-
 5 files changed, 63 insertions(+), 89 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index c3976156db2f..4da88578ed64 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -35,15 +35,15 @@ struct idxd_user_context {
 	unsigned int flags;
 };
 
-enum idxd_cdev_cleanup {
-	CDEV_NORMAL = 0,
-	CDEV_FAILED,
-};
-
 static void idxd_cdev_dev_release(struct device *dev)
 {
-	dev_dbg(dev, "releasing cdev device\n");
-	kfree(dev);
+	struct idxd_cdev *idxd_cdev = container_of(dev, struct idxd_cdev, dev);
+	struct idxd_cdev_context *cdev_ctx;
+	struct idxd_wq *wq = idxd_cdev->wq;
+
+	cdev_ctx = &ictx[wq->idxd->type];
+	ida_simple_remove(&cdev_ctx->minor_ida, idxd_cdev->minor);
+	kfree(idxd_cdev);
 }
 
 static struct device_type idxd_cdev_device_type = {
@@ -58,14 +58,11 @@ static inline struct idxd_cdev *inode_idxd_cdev(struct inode *inode)
 	return container_of(cdev, struct idxd_cdev, cdev);
 }
 
-static inline struct idxd_wq *idxd_cdev_wq(struct idxd_cdev *idxd_cdev)
-{
-	return container_of(idxd_cdev, struct idxd_wq, idxd_cdev);
-}
-
 static inline struct idxd_wq *inode_wq(struct inode *inode)
 {
-	return idxd_cdev_wq(inode_idxd_cdev(inode));
+	struct idxd_cdev *idxd_cdev = inode_idxd_cdev(inode);
+
+	return idxd_cdev->wq;
 }
 
 static int idxd_cdev_open(struct inode *inode, struct file *filp)
@@ -172,11 +169,10 @@ static __poll_t idxd_cdev_poll(struct file *filp,
 	struct idxd_user_context *ctx = filp->private_data;
 	struct idxd_wq *wq = ctx->wq;
 	struct idxd_device *idxd = wq->idxd;
-	struct idxd_cdev *idxd_cdev = &wq->idxd_cdev;
 	unsigned long flags;
 	__poll_t out = 0;
 
-	poll_wait(filp, &idxd_cdev->err_queue, wait);
+	poll_wait(filp, &wq->err_queue, wait);
 	spin_lock_irqsave(&idxd->dev_lock, flags);
 	if (idxd->sw_err.valid)
 		out = EPOLLIN | EPOLLRDNORM;
@@ -198,98 +194,67 @@ int idxd_cdev_get_major(struct idxd_device *idxd)
 	return MAJOR(ictx[idxd->type].devt);
 }
 
-static int idxd_wq_cdev_dev_setup(struct idxd_wq *wq)
+int idxd_wq_add_cdev(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
-	struct idxd_cdev *idxd_cdev = &wq->idxd_cdev;
-	struct idxd_cdev_context *cdev_ctx;
+	struct idxd_cdev *idxd_cdev;
+	struct cdev *cdev;
 	struct device *dev;
-	int minor, rc;
+	struct idxd_cdev_context *cdev_ctx;
+	int rc, minor;
 
-	idxd_cdev->dev = kzalloc(sizeof(*idxd_cdev->dev), GFP_KERNEL);
-	if (!idxd_cdev->dev)
+	idxd_cdev = kzalloc(sizeof(*idxd_cdev), GFP_KERNEL);
+	if (!idxd_cdev)
 		return -ENOMEM;
 
-	dev = idxd_cdev->dev;
-	dev->parent = &idxd->pdev->dev;
-	dev_set_name(dev, "%s/wq%u.%u", idxd_get_dev_name(idxd),
-		     idxd->id, wq->id);
-	dev->bus = idxd_get_bus_type(idxd);
-
+	idxd_cdev->wq = wq;
+	cdev = &idxd_cdev->cdev;
+	dev = &idxd_cdev->dev;
 	cdev_ctx = &ictx[wq->idxd->type];
 	minor = ida_simple_get(&cdev_ctx->minor_ida, 0, MINORMASK, GFP_KERNEL);
 	if (minor < 0) {
-		rc = minor;
-		kfree(dev);
-		goto ida_err;
-	}
-
-	dev->devt = MKDEV(MAJOR(cdev_ctx->devt), minor);
-	dev->type = &idxd_cdev_device_type;
-	rc = device_register(dev);
-	if (rc < 0) {
-		dev_err(&idxd->pdev->dev, "device register failed\n");
-		goto dev_reg_err;
+		kfree(idxd_cdev);
+		return minor;
 	}
 	idxd_cdev->minor = minor;
 
-	return 0;
-
- dev_reg_err:
-	ida_simple_remove(&cdev_ctx->minor_ida, MINOR(dev->devt));
-	put_device(dev);
- ida_err:
-	idxd_cdev->dev = NULL;
-	return rc;
-}
-
-static void idxd_wq_cdev_cleanup(struct idxd_wq *wq,
-				 enum idxd_cdev_cleanup cdev_state)
-{
-	struct idxd_cdev *idxd_cdev = &wq->idxd_cdev;
-	struct idxd_cdev_context *cdev_ctx;
-
-	cdev_ctx = &ictx[wq->idxd->type];
-	if (cdev_state == CDEV_NORMAL)
-		cdev_del(&idxd_cdev->cdev);
-	device_unregister(idxd_cdev->dev);
-	/*
-	 * The device_type->release() will be called on the device and free
-	 * the allocated struct device. We can just forget it.
-	 */
-	ida_simple_remove(&cdev_ctx->minor_ida, idxd_cdev->minor);
-	idxd_cdev->dev = NULL;
-	idxd_cdev->minor = -1;
-}
-
-int idxd_wq_add_cdev(struct idxd_wq *wq)
-{
-	struct idxd_cdev *idxd_cdev = &wq->idxd_cdev;
-	struct cdev *cdev = &idxd_cdev->cdev;
-	struct device *dev;
-	int rc;
+	device_initialize(dev);
+	dev->parent = &wq->conf_dev;
+	dev->bus = idxd_get_bus_type(idxd);
+	dev->type = &idxd_cdev_device_type;
+	dev->devt = MKDEV(MAJOR(cdev_ctx->devt), minor);
 
-	rc = idxd_wq_cdev_dev_setup(wq);
+	rc = dev_set_name(dev, "%s/wq%u.%u", idxd_get_dev_name(idxd),
+			  idxd->id, wq->id);
 	if (rc < 0)
-		return rc;
+		goto err;
 
-	dev = idxd_cdev->dev;
+	wq->idxd_cdev = idxd_cdev;
 	cdev_init(cdev, &idxd_cdev_fops);
-	cdev_set_parent(cdev, &dev->kobj);
-	rc = cdev_add(cdev, dev->devt, 1);
+	rc = cdev_device_add(cdev, dev);
 	if (rc) {
 		dev_dbg(&wq->idxd->pdev->dev, "cdev_add failed: %d\n", rc);
-		idxd_wq_cdev_cleanup(wq, CDEV_FAILED);
-		return rc;
+		goto err;
 	}
 
-	init_waitqueue_head(&idxd_cdev->err_queue);
 	return 0;
+
+ err:
+	put_device(dev);
+	wq->idxd_cdev = NULL;
+	return rc;
 }
 
 void idxd_wq_del_cdev(struct idxd_wq *wq)
 {
-	idxd_wq_cdev_cleanup(wq, CDEV_NORMAL);
+	struct idxd_cdev *idxd_cdev;
+	struct idxd_cdev_context *cdev_ctx;
+
+	cdev_ctx = &ictx[wq->idxd->type];
+	idxd_cdev = wq->idxd_cdev;
+	wq->idxd_cdev = NULL;
+	cdev_device_del(&idxd_cdev->cdev, &idxd_cdev->dev);
+	put_device(&idxd_cdev->dev);
 }
 
 int idxd_cdev_register(void)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index adf30dc23685..eef6996ecc59 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -71,10 +71,10 @@ enum idxd_wq_type {
 };
 
 struct idxd_cdev {
+	struct idxd_wq *wq;
 	struct cdev cdev;
-	struct device *dev;
+	struct device dev;
 	int minor;
-	struct wait_queue_head err_queue;
 };
 
 #define IDXD_ALLOCATED_BATCH_SIZE	128U
@@ -99,7 +99,8 @@ struct idxd_dma_chan {
 struct idxd_wq {
 	void __iomem *dportal;
 	struct device conf_dev;
-	struct idxd_cdev idxd_cdev;
+	struct idxd_cdev *idxd_cdev;
+	struct wait_queue_head err_queue;
 	struct idxd_device *idxd;
 	int id;
 	enum idxd_wq_type type;
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index fa8c4228f358..f4c7ce8cb399 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -175,7 +175,7 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		wq->id = i;
 		wq->idxd = idxd;
 		mutex_init(&wq->wq_lock);
-		wq->idxd_cdev.minor = -1;
+		init_waitqueue_head(&wq->err_queue);
 		wq->max_xfer_bytes = idxd->max_xfer_bytes;
 		wq->max_batch_size = idxd->max_batch_size;
 		wq->wqcfg = devm_kzalloc(dev, idxd->wqcfg_size, GFP_KERNEL);
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 6bb1c1773aae..fc9579180705 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -75,7 +75,7 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			struct idxd_wq *wq = &idxd->wqs[id];
 
 			if (wq->type == IDXD_WQT_USER)
-				wake_up_interruptible(&wq->idxd_cdev.err_queue);
+				wake_up_interruptible(&wq->err_queue);
 		} else {
 			int i;
 
@@ -83,7 +83,7 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 				struct idxd_wq *wq = &idxd->wqs[i];
 
 				if (wq->type == IDXD_WQT_USER)
-					wake_up_interruptible(&wq->idxd_cdev.err_queue);
+					wake_up_interruptible(&wq->err_queue);
 			}
 		}
 
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 7566b573d546..7b41cdff1a2c 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1052,8 +1052,16 @@ static ssize_t wq_cdev_minor_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct idxd_wq *wq = container_of(dev, struct idxd_wq, conf_dev);
+	int minor = -1;
 
-	return sprintf(buf, "%d\n", wq->idxd_cdev.minor);
+	mutex_lock(&wq->wq_lock);
+	if (wq->idxd_cdev)
+		minor = wq->idxd_cdev->minor;
+	mutex_unlock(&wq->wq_lock);
+
+	if (minor == -1)
+		return -ENXIO;
+	return sysfs_emit(buf, "%d\n", minor);
 }
 
 static struct device_attribute dev_attr_wq_cdev_minor =
-- 
2.30.2



