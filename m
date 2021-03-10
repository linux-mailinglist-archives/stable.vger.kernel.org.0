Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F353E333E49
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhCJNZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhCJNZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7083D64FFC;
        Wed, 10 Mar 2021 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382711;
        bh=7pfWkkUz5j891z67E46CBiSQzxZowggck4KNdcvMdM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZw3RTUNtXNCrp3KGS6VBNmwT6LMJ+fHDNzsonYoErlV74ndFrukKSCBAhJBbMDKZ
         iwbAy/A1ihKsC3YHI0+dR9Vg8ooSZ3nKMCNNZ+9lZRhXkQLWwfnmrmI75O0WMFW6Qh
         DiYdA7X4JVxpZwDTnnV6g2e1/gmqoS0Sg8UQkJlo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH 4.19 11/39] block: genhd: add groups argument to device_add_disk
Date:   Wed, 10 Mar 2021 14:24:19 +0100
Message-Id: <20210310132320.083546154@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/ubd_kern.c          |    2 +-
 block/genhd.c                       |   19 ++++++++++++++-----
 drivers/block/floppy.c              |    2 +-
 drivers/block/mtip32xx/mtip32xx.c   |    2 +-
 drivers/block/ps3disk.c             |    2 +-
 drivers/block/ps3vram.c             |    2 +-
 drivers/block/rsxx/dev.c            |    2 +-
 drivers/block/skd_main.c            |    2 +-
 drivers/block/sunvdc.c              |    2 +-
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xen-blkfront.c        |    2 +-
 drivers/ide/ide-cd.c                |    2 +-
 drivers/ide/ide-gd.c                |    2 +-
 drivers/memstick/core/ms_block.c    |    2 +-
 drivers/memstick/core/mspro_block.c |    2 +-
 drivers/mmc/core/block.c            |    2 +-
 drivers/mtd/mtd_blkdevs.c           |    2 +-
 drivers/nvdimm/blk.c                |    2 +-
 drivers/nvdimm/btt.c                |    2 +-
 drivers/nvdimm/pmem.c               |    2 +-
 drivers/nvme/host/core.c            |    2 +-
 drivers/nvme/host/multipath.c       |    2 +-
 drivers/s390/block/dasd_genhd.c     |    2 +-
 drivers/s390/block/dcssblk.c        |    2 +-
 drivers/s390/block/scm_blk.c        |    2 +-
 drivers/scsi/sd.c                   |    2 +-
 drivers/scsi/sr.c                   |    2 +-
 include/linux/genhd.h               |    5 +++--
 28 files changed, 43 insertions(+), 33 deletions(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -891,7 +891,7 @@ static int ubd_disk_register(int major,
 
 	disk->private_data = &ubd_devs[unit];
 	disk->queue = ubd_devs[unit].queue;
-	device_add_disk(parent, disk);
+	device_add_disk(parent, disk, NULL);
 
 	*disk_out = disk;
 	return 0;
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -582,7 +582,8 @@ static int exact_lock(dev_t devt, void *
 	return 0;
 }
 
-static void register_disk(struct device *parent, struct gendisk *disk)
+static void register_disk(struct device *parent, struct gendisk *disk,
+			  const struct attribute_group **groups)
 {
 	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
@@ -597,6 +598,10 @@ static void register_disk(struct device
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
+	if (groups) {
+		WARN_ON(ddev->groups);
+		ddev->groups = groups;
+	}
 	if (device_add(ddev))
 		return;
 	if (!sysfs_deprecated) {
@@ -664,6 +669,7 @@ exit:
  * __device_add_disk - add disk information to kernel list
  * @parent: parent device for the disk
  * @disk: per-device partitioning information
+ * @groups: Additional per-device sysfs groups
  * @register_queue: register the queue if set to true
  *
  * This function registers the partitioning information in @disk
@@ -672,6 +678,7 @@ exit:
  * FIXME: error handling
  */
 static void __device_add_disk(struct device *parent, struct gendisk *disk,
+			      const struct attribute_group **groups,
 			      bool register_queue)
 {
 	dev_t devt;
@@ -715,7 +722,7 @@ static void __device_add_disk(struct dev
 		blk_register_region(disk_devt(disk), disk->minors, NULL,
 				    exact_match, exact_lock, disk);
 	}
-	register_disk(parent, disk);
+	register_disk(parent, disk, groups);
 	if (register_queue)
 		blk_register_queue(disk);
 
@@ -729,15 +736,17 @@ static void __device_add_disk(struct dev
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
 
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4714,7 +4714,7 @@ static int __init do_floppy_init(void)
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
-		device_add_disk(&floppy_device[drive].dev, disks[drive]);
+		device_add_disk(&floppy_device[drive].dev, disks[drive], NULL);
 	}
 
 	return 0;
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3861,7 +3861,7 @@ skip_create_disk:
 	set_capacity(dd->disk, capacity);
 
 	/* Enable the block device and add it to /dev */
-	device_add_disk(&dd->pdev->dev, dd->disk);
+	device_add_disk(&dd->pdev->dev, dd->disk, NULL);
 
 	dd->bdev = bdget_disk(dd->disk, 0);
 	/*
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -499,7 +499,7 @@ static int ps3disk_probe(struct ps3_syst
 		 gendisk->disk_name, priv->model, priv->raw_capacity >> 11,
 		 get_capacity(gendisk) >> 11);
 
-	device_add_disk(&dev->sbd.core, gendisk);
+	device_add_disk(&dev->sbd.core, gendisk, NULL);
 	return 0;
 
 fail_cleanup_queue:
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -769,7 +769,7 @@ static int ps3vram_probe(struct ps3_syst
 	dev_info(&dev->core, "%s: Using %lu MiB of GPU memory\n",
 		 gendisk->disk_name, get_capacity(gendisk) >> 11);
 
-	device_add_disk(&dev->core, gendisk);
+	device_add_disk(&dev->core, gendisk, NULL);
 	return 0;
 
 fail_cleanup_queue:
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -226,7 +226,7 @@ int rsxx_attach_dev(struct rsxx_cardinfo
 			set_capacity(card->gendisk, card->size8 >> 9);
 		else
 			set_capacity(card->gendisk, 0);
-		device_add_disk(CARD_TO_DEV(card), card->gendisk);
+		device_add_disk(CARD_TO_DEV(card), card->gendisk, NULL);
 		card->bdev_attached = 1;
 	}
 
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3104,7 +3104,7 @@ static int skd_bdev_getgeo(struct block_
 static int skd_bdev_attach(struct device *parent, struct skd_device *skdev)
 {
 	dev_dbg(&skdev->pdev->dev, "add_disk\n");
-	device_add_disk(parent, skdev->disk);
+	device_add_disk(parent, skdev->disk, NULL);
 	return 0;
 }
 
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -862,7 +862,7 @@ static int probe_disk(struct vdc_port *p
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	device_add_disk(&port->vio.vdev->dev, g);
+	device_add_disk(&port->vio.vdev->dev, g, NULL);
 
 	return 0;
 }
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -858,7 +858,7 @@ static int virtblk_probe(struct virtio_d
 	virtblk_update_capacity(vblk, false);
 	virtio_device_ready(vdev);
 
-	device_add_disk(&vdev->dev, vblk->disk);
+	device_add_disk(&vdev->dev, vblk->disk, NULL);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
 		goto out_del_disk;
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2422,7 +2422,7 @@ static void blkfront_connect(struct blkf
 	for (i = 0; i < info->nr_rings; i++)
 		kick_pending_request_queues(&info->rinfo[i]);
 
-	device_add_disk(&info->xbdev->dev, info->gd);
+	device_add_disk(&info->xbdev->dev, info->gd, NULL);
 
 	info->is_ready = 1;
 	return;
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1784,7 +1784,7 @@ static int ide_cd_probe(ide_drive_t *dri
 	ide_cd_read_toc(drive);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	device_add_disk(&drive->gendev, g);
+	device_add_disk(&drive->gendev, g, NULL);
 	return 0;
 
 out_free_disk:
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -416,7 +416,7 @@ static int ide_gd_probe(ide_drive_t *dri
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	device_add_disk(&drive->gendev, g);
+	device_add_disk(&drive->gendev, g, NULL);
 	return 0;
 
 out_free_disk:
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2146,7 +2146,7 @@ static int msb_init_disk(struct memstick
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	device_add_disk(&card->dev, msb->disk);
+	device_add_disk(&card->dev, msb->disk, NULL);
 	dbg("Disk added");
 	return 0;
 
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1236,7 +1236,7 @@ static int mspro_block_init_disk(struct
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
-	device_add_disk(&card->dev, msb->disk);
+	device_add_disk(&card->dev, msb->disk, NULL);
 	msb->active = 1;
 	return 0;
 
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2671,7 +2671,7 @@ static int mmc_add_disk(struct mmc_blk_d
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	device_add_disk(md->parent, md->disk);
+	device_add_disk(md->parent, md->disk, NULL);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -447,7 +447,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	device_add_disk(&new->mtd->dev, gd);
+	device_add_disk(&new->mtd->dev, gd, NULL);
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -290,7 +290,7 @@ static int nsblk_attach_disk(struct nd_n
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
-	device_add_disk(dev, disk);
+	device_add_disk(dev, disk, NULL);
 	revalidate_disk(disk);
 	return 0;
 }
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
 
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -479,7 +479,7 @@ static int pmem_attach_disk(struct devic
 	gendev = disk_to_dev(disk);
 	gendev->groups = pmem_attribute_groups;
 
-	device_add_disk(dev, disk);
+	device_add_disk(dev, disk, NULL);
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3211,7 +3211,7 @@ static void nvme_alloc_ns(struct nvme_ct
 
 	nvme_get_ctrl(ctrl);
 
-	device_add_disk(ctrl->device, ns->disk);
+	device_add_disk(ctrl->device, ns->disk, NULL);
 	if (sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
 					&nvme_ns_id_attr_group))
 		pr_warn("%s: failed to create sysfs group for identification\n",
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -314,7 +314,7 @@ static void nvme_mpath_set_live(struct n
 		return;
 
 	if (!(head->disk->flags & GENHD_FL_UP)) {
-		device_add_disk(&head->subsys->dev, head->disk);
+		device_add_disk(&head->subsys->dev, head->disk, NULL);
 		if (sysfs_create_group(&disk_to_dev(head->disk)->kobj,
 				&nvme_ns_id_attr_group))
 			dev_warn(&head->subsys->dev,
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -76,7 +76,7 @@ int dasd_gendisk_alloc(struct dasd_block
 	gdp->queue = block->request_queue;
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
-	device_add_disk(&base->cdev->dev, block->gdp);
+	device_add_disk(&base->cdev->dev, block->gdp, NULL);
 	return 0;
 }
 
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -685,7 +685,7 @@ dcssblk_add_store(struct device *dev, st
 	}
 
 	get_device(&dev_info->dev);
-	device_add_disk(&dev_info->dev, dev_info->gd);
+	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -500,7 +500,7 @@ int scm_blk_dev_setup(struct scm_blk_dev
 
 	/* 512 byte sectors */
 	set_capacity(bdev->gendisk, scmdev->size >> 9);
-	device_add_disk(&scmdev->dev, bdev->gendisk);
+	device_add_disk(&scmdev->dev, bdev->gendisk, NULL);
 	return 0;
 
 out_queue:
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3348,7 +3348,7 @@ static void sd_probe_async(void *data, a
 	}
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
-	device_add_disk(dev, gd);
+	device_add_disk(dev, gd, NULL);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -758,7 +758,7 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
-	device_add_disk(&sdev->sdev_gendev, disk);
+	device_add_disk(&sdev->sdev_gendev, disk, NULL);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -402,10 +402,11 @@ static inline void free_part_info(struct
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


