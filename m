Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F37137E8F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgAKKLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:11:15 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0430B2077C;
        Sat, 11 Jan 2020 10:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737474;
        bh=xJ7/B4KBXzx5OXRvHnZsIqkqsBgtNmYt0nNagaE3OXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lgv6q6k8W+LdSLhdRdTDE4DvuQmBl7reyVrizWBxBuclKB+pPb5u0ljv9F+JtM3H+
         m4yLydXfIpTSR563N5Q8UE7KppSeqcUV1UF38cDM/+nIJdfqpOYQfeFRRtbc+WNGzF
         ZjfMS/gptuT+ZHjIQzeJ9wQYcfUw4ZhjZRbG4YCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: [PATCH 4.14 45/62] mmc: block: Fix bug when removing RPMB chardev
Date:   Sat, 11 Jan 2020 10:50:27 +0100
Message-Id: <20200111094850.709826109@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 1c87f73578497a6c3cc77bcbfd2e5bf15fe753c7 upstream.

I forgot to account for the fact that the device core holds a
reference to a device added with device_initialize() that need
to be released with a corresponding put_device() to reach a 0
refcount at the end of the lifecycle.

This led to a NULL pointer reference when freeing the device
when e.g. unbidning the host device in sysfs.

Fix this and use the device .release() callback to free the
IDA and free:ing the memory used by the RPMB device.

Before this patch:

/sys/bus/amba/drivers/mmci-pl18x$ echo 80114000.sdi4_per2 > unbind
[   29.797332] mmc3: card 0001 removed
[   29.810791] Unable to handle kernel NULL pointer dereference at
               virtual address 00000050
[   29.818878] pgd = de70c000
[   29.821624] [00000050] *pgd=1e70a831, *pte=00000000, *ppte=00000000
[   29.827911] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[   29.833282] Modules linked in:
[   29.836334] CPU: 1 PID: 154 Comm: sh Not tainted
               4.14.0-rc3-00039-g83318e309566-dirty #736
[   29.844604] Hardware name: ST-Ericsson Ux5x0 platform (Device Tree Support)
[   29.851562] task: de572700 task.stack: de742000
[   29.856079] PC is at kernfs_find_ns+0x8/0x100
[   29.860443] LR is at kernfs_find_and_get_ns+0x30/0x48

After this patch:

/sys/bus/amba/drivers/mmci-pl18x$ echo 80005000.sdi4_per2 > unbind
[   20.623382] mmc3: card 0001 removed

Fixes: 97548575bef3 ("mmc: block: Convert RPMB to a character device")
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2323,9 +2323,7 @@ static int mmc_rpmb_chrdev_open(struct i
 
 	get_device(&rpmb->dev);
 	filp->private_data = rpmb;
-	mutex_lock(&open_lock);
-	rpmb->md->usage++;
-	mutex_unlock(&open_lock);
+	mmc_blk_get(rpmb->md->disk);
 
 	return nonseekable_open(inode, filp);
 }
@@ -2336,9 +2334,7 @@ static int mmc_rpmb_chrdev_release(struc
 						  struct mmc_rpmb_data, chrdev);
 
 	put_device(&rpmb->dev);
-	mutex_lock(&open_lock);
-	rpmb->md->usage--;
-	mutex_unlock(&open_lock);
+	mmc_blk_put(rpmb->md);
 
 	return 0;
 }
@@ -2354,6 +2350,13 @@ static const struct file_operations mmc_
 #endif
 };
 
+static void mmc_blk_rpmb_device_release(struct device *dev)
+{
+	struct mmc_rpmb_data *rpmb = dev_get_drvdata(dev);
+
+	ida_simple_remove(&mmc_rpmb_ida, rpmb->id);
+	kfree(rpmb);
+}
 
 static int mmc_blk_alloc_rpmb_part(struct mmc_card *card,
 				   struct mmc_blk_data *md,
@@ -2372,8 +2375,10 @@ static int mmc_blk_alloc_rpmb_part(struc
 		return devidx;
 
 	rpmb = kzalloc(sizeof(*rpmb), GFP_KERNEL);
-	if (!rpmb)
+	if (!rpmb) {
+		ida_simple_remove(&mmc_rpmb_ida, devidx);
 		return -ENOMEM;
+	}
 
 	snprintf(rpmb_name, sizeof(rpmb_name),
 		 "mmcblk%u%s", card->host->index, subname ? subname : "");
@@ -2384,6 +2389,7 @@ static int mmc_blk_alloc_rpmb_part(struc
 	rpmb->dev.bus = &mmc_rpmb_bus_type;
 	rpmb->dev.devt = MKDEV(MAJOR(mmc_rpmb_devt), rpmb->id);
 	rpmb->dev.parent = &card->dev;
+	rpmb->dev.release = mmc_blk_rpmb_device_release;
 	device_initialize(&rpmb->dev);
 	dev_set_drvdata(&rpmb->dev, rpmb);
 	rpmb->md = md;
@@ -2393,7 +2399,7 @@ static int mmc_blk_alloc_rpmb_part(struc
 	ret = cdev_device_add(&rpmb->chrdev, &rpmb->dev);
 	if (ret) {
 		pr_err("%s: could not add character device\n", rpmb_name);
-		goto out_remove_ida;
+		goto out_put_device;
 	}
 
 	list_add(&rpmb->node, &md->rpmbs);
@@ -2408,18 +2414,16 @@ static int mmc_blk_alloc_rpmb_part(struc
 
 	return 0;
 
-out_remove_ida:
-	ida_simple_remove(&mmc_rpmb_ida, rpmb->id);
-	kfree(rpmb);
+out_put_device:
+	put_device(&rpmb->dev);
 	return ret;
 }
 
 static void mmc_blk_remove_rpmb_part(struct mmc_rpmb_data *rpmb)
+
 {
 	cdev_device_del(&rpmb->chrdev, &rpmb->dev);
-	device_del(&rpmb->dev);
-	ida_simple_remove(&mmc_rpmb_ida, rpmb->id);
-	kfree(rpmb);
+	put_device(&rpmb->dev);
 }
 
 /* MMC Physical partitions consist of two boot partitions and


