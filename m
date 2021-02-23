Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCFD3227E1
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhBWJcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 04:32:06 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:37404 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231751AbhBWJ3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 04:29:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPLS4jE_1614072541;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPLS4jE_1614072541)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:29:02 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, joseph.qi@linux.alibaba.com,
        jefflexu@linux.alibaba.com, hare@suse.com
Subject: [PATCH v2 4.19 2/6] block: genhd: add 'groups' argument to device_add_disk
Date:   Tue, 23 Feb 2021 17:28:55 +0800
Message-Id: <20210223092859.17033-3-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
References: <20210223092859.17033-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.

Update device_add_disk() to take an 'groups' argument so that
individual drivers can register a device with additional sysfs
attributes.
This avoids race condition the driver would otherwise have if these
groups were to be created with sysfs_add_groups().

Signed-off-by: Martin Wilck <martin.wilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 arch/um/drivers/ubd_kern.c          |  2 +-
 block/genhd.c                       | 19 ++++++++++++++-----
 drivers/block/floppy.c              |  2 +-
 drivers/block/mtip32xx/mtip32xx.c   |  2 +-
 drivers/block/ps3disk.c             |  2 +-
 drivers/block/ps3vram.c             |  2 +-
 drivers/block/rsxx/dev.c            |  2 +-
 drivers/block/skd_main.c            |  2 +-
 drivers/block/sunvdc.c              |  2 +-
 drivers/block/virtio_blk.c          |  2 +-
 drivers/block/xen-blkfront.c        |  2 +-
 drivers/ide/ide-cd.c                |  2 +-
 drivers/ide/ide-gd.c                |  2 +-
 drivers/memstick/core/ms_block.c    |  2 +-
 drivers/memstick/core/mspro_block.c |  2 +-
 drivers/mmc/core/block.c            |  2 +-
 drivers/mtd/mtd_blkdevs.c           |  2 +-
 drivers/nvdimm/blk.c                |  2 +-
 drivers/nvdimm/btt.c                |  2 +-
 drivers/nvdimm/pmem.c               |  2 +-
 drivers/nvme/host/core.c            |  2 +-
 drivers/nvme/host/multipath.c       |  2 +-
 drivers/s390/block/dasd_genhd.c     |  2 +-
 drivers/s390/block/dcssblk.c        |  2 +-
 drivers/s390/block/scm_blk.c        |  2 +-
 drivers/scsi/sd.c                   |  2 +-
 drivers/scsi/sr.c                   |  2 +-
 include/linux/genhd.h               |  5 +++--
 28 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 748bd0921dff..788c80abff5d 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -891,7 +891,7 @@ static int ubd_disk_register(int major, u64 size, int unit,
 
 	disk->private_data = &ubd_devs[unit];
 	disk->queue = ubd_devs[unit].queue;
-	device_add_disk(parent, disk);
+	device_add_disk(parent, disk, NULL);
 
 	*disk_out = disk;
 	return 0;
diff --git a/block/genhd.c b/block/genhd.c
index 6965dde96373..aee2fa9de1a7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -582,7 +582,8 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
-static void register_disk(struct device *parent, struct gendisk *disk)
+static void register_disk(struct device *parent, struct gendisk *disk,
+			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
@@ -597,6 +598,10 @@ static void register_disk(struct device *parent, struct gendisk *disk)
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
+	if (groups) {
+		WARN_ON(ddev->groups);
+		ddev->groups = groups;
+	}
 	if (device_add(ddev))
 		return;
 	if (!sysfs_deprecated) {
@@ -664,6 +669,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
  * __device_add_disk - add disk information to kernel list
  * @parent: parent device for the disk
  * @disk: per-device partitioning information
+ * @groups: Additional per-device sysfs groups
  * @register_queue: register the queue if set to true
  *
  * This function registers the partitioning information in @disk
@@ -672,6 +678,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
  * FIXME: error handling
  */
 static void __device_add_disk(struct device *parent, struct gendisk *disk,
+			      const struct attribute_group **groups,
 			      bool register_queue)
 {
 	dev_t devt;
@@ -715,7 +722,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 		blk_register_region(disk_devt(disk), disk->minors, NULL,
 				    exact_match, exact_lock, disk);
 	}
-	register_disk(parent, disk);
+	register_disk(parent, disk, groups);
 	if (register_queue)
 		blk_register_queue(disk);
 
@@ -729,15 +736,17 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	blk_integrity_add(disk);
 }
 
-void device_add_disk(struct device *parent, struct gendisk *disk)
+void device_add_disk(struct device *parent, struct gendisk *disk,
+		     const struct attribute_group **groups)
+
 {
-	__device_add_disk(parent, disk, true);
+	__device_add_disk(parent, disk, groups, true);
 }
 EXPORT_SYMBOL(device_add_disk);
 
 void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
 {
-	__device_add_disk(parent, disk, false);
+	__device_add_disk(parent, disk, NULL, false);
 }
 EXPORT_SYMBOL(device_add_disk_no_queue_reg);
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index bf222c4b2f82..8f444b375761 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4713,7 +4713,7 @@ static int __init do_floppy_init(void)
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
-		device_add_disk(&floppy_device[drive].dev, disks[drive]);
+		device_add_disk(&floppy_device[drive].dev, disks[drive], NULL);
 	}
 
 	return 0;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index d0666f5ce003..1d7d48d8a205 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3861,7 +3861,7 @@ static int mtip_block_initialize(struct driver_data *dd)
 	set_capacity(dd->disk, capacity);
 
 	/* Enable the block device and add it to /dev */
-	device_add_disk(&dd->pdev->dev, dd->disk);
+	device_add_disk(&dd->pdev->dev, dd->disk, NULL);
 
 	dd->bdev = bdget_disk(dd->disk, 0);
 	/*
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index bd1c66f5631a..42bff6b1d6a8 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -499,7 +499,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 		 gendisk->disk_name, priv->model, priv->raw_capacity >> 11,
 		 get_capacity(gendisk) >> 11);
 
-	device_add_disk(&dev->sbd.core, gendisk);
+	device_add_disk(&dev->sbd.core, gendisk, NULL);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1e3d5de9d838..c0c50816a10b 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -769,7 +769,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	dev_info(&dev->core, "%s: Using %lu MiB of GPU memory\n",
 		 gendisk->disk_name, get_capacity(gendisk) >> 11);
 
-	device_add_disk(&dev->core, gendisk);
+	device_add_disk(&dev->core, gendisk, NULL);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 1a92f9e65937..3894aa0f350b 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -226,7 +226,7 @@ int rsxx_attach_dev(struct rsxx_cardinfo *card)
 			set_capacity(card->gendisk, card->size8 >> 9);
 		else
 			set_capacity(card->gendisk, 0);
-		device_add_disk(CARD_TO_DEV(card), card->gendisk);
+		device_add_disk(CARD_TO_DEV(card), card->gendisk, NULL);
 		card->bdev_attached = 1;
 	}
 
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 27323fa23997..80a5806ede03 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3104,7 +3104,7 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int skd_bdev_attach(struct device *parent, struct skd_device *skdev)
 {
 	dev_dbg(&skdev->pdev->dev, "add_disk\n");
-	device_add_disk(parent, skdev->disk);
+	device_add_disk(parent, skdev->disk, NULL);
 	return 0;
 }
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 5d7024057540..6b7b0d8a2acb 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -862,7 +862,7 @@ static int probe_disk(struct vdc_port *port)
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	device_add_disk(&port->vio.vdev->dev, g);
+	device_add_disk(&port->vio.vdev->dev, g, NULL);
 
 	return 0;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 075523777a4a..e03e13a3f32c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -858,7 +858,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	virtblk_update_capacity(vblk, false);
 	virtio_device_ready(vdev);
 
-	device_add_disk(&vdev->dev, vblk->disk);
+	device_add_disk(&vdev->dev, vblk->disk, NULL);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
 		goto out_del_disk;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d4ceee3825f8..1b06c8e46ffa 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2422,7 +2422,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	for (i = 0; i < info->nr_rings; i++)
 		kick_pending_request_queues(&info->rinfo[i]);
 
-	device_add_disk(&info->xbdev->dev, info->gd);
+	device_add_disk(&info->xbdev->dev, info->gd, NULL);
 
 	info->is_ready = 1;
 	return;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 44a7a255ef74..f9b59d41813f 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1784,7 +1784,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	device_add_disk(&drive->gendev, g);
+	device_add_disk(&drive->gendev, g, NULL);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index e823394ed543..04e008e8f6f9 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -416,7 +416,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	device_add_disk(&drive->gendev, g);
+	device_add_disk(&drive->gendev, g, NULL);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 716fc8ed31d3..8a02f11076f9 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2146,7 +2146,7 @@ static int msb_init_disk(struct memstick_dev *card)
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	device_add_disk(&card->dev, msb->disk);
+	device_add_disk(&card->dev, msb->disk, NULL);
 	dbg("Disk added");
 	return 0;
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 5ee932631fae..0cd30dcb6801 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1236,7 +1236,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
-	device_add_disk(&card->dev, msb->disk);
+	device_add_disk(&card->dev, msb->disk, NULL);
 	msb->active = 1;
 	return 0;
 
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 90656b625b9a..77324ea4eb93 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2671,7 +2671,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	device_add_disk(md->parent, md->disk);
+	device_add_disk(md->parent, md->disk, NULL);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 29c0bfd74e8a..6a41dfa3c36b 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -447,7 +447,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	device_add_disk(&new->mtd->dev, gd);
+	device_add_disk(&new->mtd->dev, gd, NULL);
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 62e9cb167aad..db45c6bbb7bb 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -290,7 +290,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
-	device_add_disk(dev, disk);
+	device_add_disk(dev, disk, NULL);
 	revalidate_disk(disk);
 	return 0;
 }
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 853edc649ed4..b6823e66af13 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1565,7 +1565,7 @@ static int btt_blk_init(struct btt *btt)
 		}
 	}
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
-	device_add_disk(&btt->nd_btt->dev, btt->btt_disk);
+	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	revalidate_disk(btt->btt_disk);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index a7ce2f1761a2..d6f981f6ef59 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -479,7 +479,7 @@ static int pmem_attach_disk(struct device *dev,
 	gendev = disk_to_dev(disk);
 	gendev->groups = pmem_attribute_groups;
 
-	device_add_disk(dev, disk);
+	device_add_disk(dev, disk, NULL);
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b633ea40430e..244a693c35de 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3211,7 +3211,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 
 	nvme_get_ctrl(ctrl);
 
-	device_add_disk(ctrl->device, ns->disk);
+	device_add_disk(ctrl->device, ns->disk, NULL);
 	if (sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
 					&nvme_ns_id_attr_group))
 		pr_warn("%s: failed to create sysfs group for identification\n",
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e71075338ff5..ee9e092ace4a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -314,7 +314,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		return;
 
 	if (!(head->disk->flags & GENHD_FL_UP)) {
-		device_add_disk(&head->subsys->dev, head->disk);
+		device_add_disk(&head->subsys->dev, head->disk, NULL);
 		if (sysfs_create_group(&disk_to_dev(head->disk)->kobj,
 				&nvme_ns_id_attr_group))
 			dev_warn(&head->subsys->dev,
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 7036a6c6f86f..5542d9eadfe0 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -76,7 +76,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	gdp->queue = block->request_queue;
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
-	device_add_disk(&base->cdev->dev, block->gdp);
+	device_add_disk(&base->cdev->dev, block->gdp, NULL);
 	return 0;
 }
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 23e526cda5c1..4e8aedd50cb0 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -685,7 +685,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	}
 
 	get_device(&dev_info->dev);
-	device_add_disk(&dev_info->dev, dev_info->gd);
+	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 98f66b7b6794..e01889394c84 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -500,7 +500,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 
 	/* 512 byte sectors */
 	set_capacity(bdev->gendisk, scmdev->size >> 9);
-	device_add_disk(&scmdev->dev, bdev->gendisk);
+	device_add_disk(&scmdev->dev, bdev->gendisk, NULL);
 	return 0;
 
 out_queue:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f2f14d8d5943..342352d8e7bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3348,7 +3348,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	}
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
-	device_add_disk(dev, gd);
+	device_add_disk(dev, gd, NULL);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5be3d6b7991b..45c8bf39ad23 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -758,7 +758,7 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
-	device_add_disk(&sdev->sdev_gendev, disk);
+	device_add_disk(&sdev->sdev_gendev, disk, NULL);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index f993bc86f3ba..a488098f8638 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -402,10 +402,11 @@ static inline void free_part_info(struct hd_struct *part)
 extern void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void device_add_disk(struct device *parent, struct gendisk *disk);
+extern void device_add_disk(struct device *parent, struct gendisk *disk,
+			    const struct attribute_group **groups);
 static inline void add_disk(struct gendisk *disk)
 {
-	device_add_disk(NULL, disk);
+	device_add_disk(NULL, disk, NULL);
 }
 extern void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk);
 static inline void add_disk_no_queue_reg(struct gendisk *disk)
-- 
2.27.0

