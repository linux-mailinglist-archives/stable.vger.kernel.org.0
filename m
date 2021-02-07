Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA9312409
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 12:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGLsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 06:48:14 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:35212 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhBGLru (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 06:47:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UO4Kl.H_1612698427;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO4Kl.H_1612698427)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 19:47:08 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] virtio-blk: close udev startup race condition as default groups
Date:   Sun,  7 Feb 2021 19:46:54 +0800
Message-Id: <20210207114656.32141-2-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.
commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 upstream.

Similar to commit 9e07f4e24379 ("zram: close udev startup race condition
as default groups"), this is a merge of [1, 2], since [1] may be too
large size to be merged into -stable tree.

This issue has been introduced since v2.6.36 by [3].

[1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
[2] e982c4d0a29b, virtio-blk: modernize sysfs attribute creation
[3] a5eb9e4ff18a, virtio_blk: Add 'serial' attribute to virtio-blk devices (v2)

Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/block/virtio_blk.c | 67 ++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 075523777a4a..52e3327581f9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -423,8 +423,8 @@ static int minor_to_index(int minor)
 	return minor >> PART_BITS;
 }
 
-static ssize_t virtblk_serial_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t serial_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	int err;
@@ -443,7 +443,7 @@ static ssize_t virtblk_serial_show(struct device *dev,
 	return err;
 }
 
-static DEVICE_ATTR(serial, 0444, virtblk_serial_show, NULL);
+static DEVICE_ATTR_RO(serial);
 
 /* The queue's logical block size must be set before calling this */
 static void virtblk_update_capacity(struct virtio_blk *vblk, bool resize)
@@ -619,8 +619,8 @@ static const char *const virtblk_cache_types[] = {
 };
 
 static ssize_t
-virtblk_cache_type_store(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t count)
+cache_type_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct virtio_blk *vblk = disk->private_data;
@@ -638,8 +638,7 @@ virtblk_cache_type_store(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-virtblk_cache_type_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
+cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct virtio_blk *vblk = disk->private_data;
@@ -649,12 +648,38 @@ virtblk_cache_type_show(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, 40, "%s\n", virtblk_cache_types[writeback]);
 }
 
-static const struct device_attribute dev_attr_cache_type_ro =
-	__ATTR(cache_type, 0444,
-	       virtblk_cache_type_show, NULL);
-static const struct device_attribute dev_attr_cache_type_rw =
-	__ATTR(cache_type, 0644,
-	       virtblk_cache_type_show, virtblk_cache_type_store);
+static DEVICE_ATTR_RW(cache_type);
+
+static struct attribute *virtblk_attrs[] = {
+	&dev_attr_serial.attr,
+	&dev_attr_cache_type.attr,
+	NULL,
+};
+
+static umode_t virtblk_attrs_are_visible(struct kobject *kobj,
+		struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+	struct virtio_blk *vblk = disk->private_data;
+	struct virtio_device *vdev = vblk->vdev;
+
+	if (a == &dev_attr_cache_type.attr &&
+	    !virtio_has_feature(vdev, VIRTIO_BLK_F_CONFIG_WCE))
+		return S_IRUGO;
+
+	return a->mode;
+}
+
+static const struct attribute_group virtblk_attr_group = {
+	.attrs = virtblk_attrs,
+	.is_visible = virtblk_attrs_are_visible,
+};
+
+static const struct attribute_group *virtblk_attr_groups[] = {
+	&virtblk_attr_group,
+	NULL,
+};
 
 static int virtblk_init_request(struct blk_mq_tag_set *set, struct request *rq,
 		unsigned int hctx_idx, unsigned int numa_node)
@@ -858,24 +883,10 @@ static int virtblk_probe(struct virtio_device *vdev)
 	virtblk_update_capacity(vblk, false);
 	virtio_device_ready(vdev);
 
+	disk_to_dev(vblk->disk)->groups = virtblk_attr_groups;
 	device_add_disk(&vdev->dev, vblk->disk);
-	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
-	if (err)
-		goto out_del_disk;
-
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_CONFIG_WCE))
-		err = device_create_file(disk_to_dev(vblk->disk),
-					 &dev_attr_cache_type_rw);
-	else
-		err = device_create_file(disk_to_dev(vblk->disk),
-					 &dev_attr_cache_type_ro);
-	if (err)
-		goto out_del_disk;
 	return 0;
 
-out_del_disk:
-	del_gendisk(vblk->disk);
-	blk_cleanup_queue(vblk->disk->queue);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
 out_put_disk:
-- 
2.27.0

