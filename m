Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AF7333E69
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhCJN0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhCJNZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC92965076;
        Wed, 10 Mar 2021 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382719;
        bh=sgVJ+WOVytuzFlmq7rCaFiHs9BRA/2rO2xCfhESZ41Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qfKyZPbHKtqQbm2CcsvMOINMmZDhgAL0KqXP1danTfYonq7CXLWU8mmQcRQ2ZCpE
         w6Ye4MtMB+1V4+CzHiwPpBzaygG5hjsmjXaJ8e5OIqUZZDB4bSPKOAcISKaUe6SewL
         KFSGBM11LL1a5QBx/YD7CwLAVwUnWSq6lWw2g+eM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH 4.19 15/39] virtio-blk: modernize sysfs attribute creation
Date:   Wed, 10 Mar 2021 14:24:23 +0100
Message-Id: <20210310132320.206766651@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hannes Reinecke <hare@suse.de>

commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 upstream.

Use new-style DEVICE_ATTR_RO/DEVICE_ATTR_RW to create the sysfs attributes
and register the disk with default sysfs attribute groups.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/virtio_blk.c |   68 +++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

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
@@ -443,7 +443,7 @@ static ssize_t virtblk_serial_show(struc
 	return err;
 }
 
-static DEVICE_ATTR(serial, 0444, virtblk_serial_show, NULL);
+static DEVICE_ATTR_RO(serial);
 
 /* The queue's logical block size must be set before calling this */
 static void virtblk_update_capacity(struct virtio_blk *vblk, bool resize)
@@ -619,8 +619,8 @@ static const char *const virtblk_cache_t
 };
 
 static ssize_t
-virtblk_cache_type_store(struct device *dev, struct device_attribute *attr,
-			 const char *buf, size_t count)
+cache_type_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct virtio_blk *vblk = disk->private_data;
@@ -638,8 +638,7 @@ virtblk_cache_type_store(struct device *
 }
 
 static ssize_t
-virtblk_cache_type_show(struct device *dev, struct device_attribute *attr,
-			 char *buf)
+cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct virtio_blk *vblk = disk->private_data;
@@ -649,12 +648,38 @@ virtblk_cache_type_show(struct device *d
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
@@ -858,24 +883,9 @@ static int virtblk_probe(struct virtio_d
 	virtblk_update_capacity(vblk, false);
 	virtio_device_ready(vdev);
 
-	device_add_disk(&vdev->dev, vblk->disk, NULL);
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
+	device_add_disk(&vdev->dev, vblk->disk, virtblk_attr_groups);
 	return 0;
 
-out_del_disk:
-	del_gendisk(vblk->disk);
-	blk_cleanup_queue(vblk->disk->queue);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
 out_put_disk:


