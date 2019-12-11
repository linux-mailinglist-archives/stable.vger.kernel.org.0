Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6C11B557
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfLKPT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbfLKPT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7009F2073D;
        Wed, 11 Dec 2019 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077566;
        bh=Jr7OP2ExagPThx4x6gxb2VIob/AQyrcBJ5/rYVQqNVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFBaG3WpQ/Z/wH7t+x+gQ5aZuYEXYRRZgrxmlKB8zQSktFGq0C3XzhBcQ6X2nYC1u
         IXZTycgvjtmf0DGvYon+s/PF/feZUv9VgO+NXkBB7RdNh9E+0JoTEAuFOxXnY2/WqG
         2YurgXqrDm4akcRI3kH+XfY9Md0gcOP9bKqwoTj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/243] media: coda: fix memory corruption in case more than 32 instances are opened
Date:   Wed, 11 Dec 2019 16:04:09 +0100
Message-Id: <20191211150344.985875952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 649cfc2bdfeeb98ff7d8fdff0af3f8fb9c8da50f ]

The ffz() return value is undefined if the instance mask does not
contain any zeros. If it returned 32, the following set_bit would
corrupt the debugfs_root pointer.
Switch to IDA for context index allocation. This also removes the
artificial 32 instance limit for all except CodaDx6.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c | 26 +++++++++--------------
 drivers/media/platform/coda/coda.h        |  3 ++-
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 4b0220f40b425..fccc771d23a51 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -17,6 +17,7 @@
 #include <linux/firmware.h>
 #include <linux/gcd.h>
 #include <linux/genalloc.h>
+#include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -2101,17 +2102,6 @@ int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
 	return coda_queue_init(priv, dst_vq);
 }
 
-static int coda_next_free_instance(struct coda_dev *dev)
-{
-	int idx = ffz(dev->instance_mask);
-
-	if ((idx < 0) ||
-	    (dev->devtype->product == CODA_DX6 && idx > CODADX6_MAX_INSTANCES))
-		return -EBUSY;
-
-	return idx;
-}
-
 /*
  * File operations
  */
@@ -2120,7 +2110,8 @@ static int coda_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct coda_dev *dev = video_get_drvdata(vdev);
-	struct coda_ctx *ctx = NULL;
+	struct coda_ctx *ctx;
+	unsigned int max = ~0;
 	char *name;
 	int ret;
 	int idx;
@@ -2129,12 +2120,13 @@ static int coda_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 
-	idx = coda_next_free_instance(dev);
+	if (dev->devtype->product == CODA_DX6)
+		max = CODADX6_MAX_INSTANCES - 1;
+	idx = ida_alloc_max(&dev->ida, max, GFP_KERNEL);
 	if (idx < 0) {
 		ret = idx;
 		goto err_coda_max;
 	}
-	set_bit(idx, &dev->instance_mask);
 
 	name = kasprintf(GFP_KERNEL, "context%d", idx);
 	if (!name) {
@@ -2243,8 +2235,8 @@ err_clk_per:
 err_pm_get:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-	clear_bit(ctx->idx, &dev->instance_mask);
 err_coda_name_init:
+	ida_free(&dev->ida, ctx->idx);
 err_coda_max:
 	kfree(ctx);
 	return ret;
@@ -2286,7 +2278,7 @@ static int coda_release(struct file *file)
 	pm_runtime_put_sync(&dev->plat_dev->dev);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-	clear_bit(ctx->idx, &dev->instance_mask);
+	ida_free(&dev->ida, ctx->idx);
 	if (ctx->ops->release)
 		ctx->ops->release(ctx);
 	debugfs_remove_recursive(ctx->debugfs_entry);
@@ -2747,6 +2739,7 @@ static int coda_probe(struct platform_device *pdev)
 
 	mutex_init(&dev->dev_mutex);
 	mutex_init(&dev->coda_mutex);
+	ida_init(&dev->ida);
 
 	dev->debugfs_root = debugfs_create_dir("coda", NULL);
 	if (!dev->debugfs_root)
@@ -2834,6 +2827,7 @@ static int coda_remove(struct platform_device *pdev)
 	coda_free_aux_buf(dev, &dev->tempbuf);
 	coda_free_aux_buf(dev, &dev->workbuf);
 	debugfs_remove_recursive(dev->debugfs_root);
+	ida_destroy(&dev->ida);
 	return 0;
 }
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 2469ca1dc5985..8df02c32781ee 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -16,6 +16,7 @@
 #define __CODA_H__
 
 #include <linux/debugfs.h>
+#include <linux/idr.h>
 #include <linux/irqreturn.h>
 #include <linux/mutex.h>
 #include <linux/kfifo.h>
@@ -95,7 +96,7 @@ struct coda_dev {
 	struct workqueue_struct	*workqueue;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct list_head	instances;
-	unsigned long		instance_mask;
+	struct ida		ida;
 	struct dentry		*debugfs_root;
 };
 
-- 
2.20.1



