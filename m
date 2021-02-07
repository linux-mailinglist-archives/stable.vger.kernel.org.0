Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC131240B
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 12:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBGLsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 06:48:21 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:58629 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhBGLsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 06:48:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UO44qw0_1612698429;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO44qw0_1612698429)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 19:47:09 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] aoe: close udev startup race condition as default groups
Date:   Sun,  7 Feb 2021 19:46:55 +0800
Message-Id: <20210207114656.32141-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.
commit 95cf7809bf9169fec4e4b7bb24b8069d8f354f96 upstream.

Similar to commit 9e07f4e24379 ("zram: close udev startup race condition
as default groups"), this is a merge of [1, 2], since [1] may be too
large size to be merged into -stable tree.

[1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
[2] 95cf7809bf91, aoe: register default groups with device_add_disk()

Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/block/aoe/aoe.h    |  1 -
 drivers/block/aoe/aoeblk.c | 20 +++++++-------------
 drivers/block/aoe/aoedev.c |  1 -
 3 files changed, 7 insertions(+), 15 deletions(-)

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
index 429ebb84b592..769f3a10054e 100644
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
@@ -417,8 +411,8 @@ aoeblk_gdalloc(void *vp)
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
+	disk_to_dev(gd)->groups = aoe_attr_groups;
 	add_disk(gd);
-	aoedisk_add_sysfs(d);
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

