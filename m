Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C828A3227DE
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhBWJcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:32:00 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:40765 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232252AbhBWJ3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPMP7ZL_1614072544;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPMP7ZL_1614072544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:04 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 4/6] aoe: register default groups with device_add_disk()
Date:   Tue, 23 Feb 2021 17:28:57 +0800
Message-Id: <20210223092859.17033-5-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit 95cf7809bf9169fec4e4b7bb24b8069d8f354f96 upstream.

Register default sysfs groups during device_add_disk() to avoid a
race condition with udev during startup.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ed L. Cachin <ed.cashin@acm.org>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/block/aoe/aoe.h    |  1 -
 drivers/block/aoe/aoeblk.c | 21 +++++++--------------
 drivers/block/aoe/aoedev.c |  1 -
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index c0ebda1283cc..015c68017a1c 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -201,7 +201,6 @@ int aoeblk_init(void);
 void aoeblk_exit(void);
 void aoeblk_gdalloc(void *);
 void aoedisk_rm_debugfs(struct aoedev *d);
-void aoedisk_rm_sysfs(struct aoedev *d);
 
 int aoechr_init(void);
 void aoechr_exit(void);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 429ebb84b592..ff770e7d9e52 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -177,10 +177,15 @@ static struct attribute *aoe_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group attr_group = {
+static const struct attribute_group aoe_attr_group = {
 	.attrs = aoe_attrs,
 };
 
+static const struct attribute_group *aoe_attr_groups[] = {
+	&aoe_attr_group,
+	NULL,
+};
+
 static const struct file_operations aoe_debugfs_fops = {
 	.open = aoe_debugfs_open,
 	.read = seq_read,
@@ -219,17 +224,6 @@ aoedisk_rm_debugfs(struct aoedev *d)
 	d->debugfs = NULL;
 }
 
-static int
-aoedisk_add_sysfs(struct aoedev *d)
-{
-	return sysfs_create_group(&disk_to_dev(d->gd)->kobj, &attr_group);
-}
-void
-aoedisk_rm_sysfs(struct aoedev *d)
-{
-	sysfs_remove_group(&disk_to_dev(d->gd)->kobj, &attr_group);
-}
-
 static int
 aoeblk_open(struct block_device *bdev, fmode_t mode)
 {
@@ -417,8 +411,7 @@ aoeblk_gdalloc(void *vp)
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
-	add_disk(gd);
-	aoedisk_add_sysfs(d);
+	device_add_disk(NULL, gd, aoe_attr_groups);
 	aoedisk_add_debugfs(d);
 
 	spin_lock_irqsave(&d->lock, flags);
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 41060e9cedf2..f29a140cdbc1 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -275,7 +275,6 @@ freedev(struct aoedev *d)
 	del_timer_sync(&d->timer);
 	if (d->gd) {
 		aoedisk_rm_debugfs(d);
-		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
 		put_disk(d->gd);
 		blk_cleanup_queue(d->blkq);
-- 
2.27.0

