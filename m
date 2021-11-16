Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D351F45265F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359382AbhKPCFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240006AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338F76336E;
        Mon, 15 Nov 2021 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998066;
        bh=tejS0Z8gXZ+WdF6UV6BqIP2/fsb2+SQtF+AidA/R4Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTuMQDMxJUcXbtzKAZYDQILalKb3NG8MpDoE6CfBnwIrjKzBwSYPvxS7pKGL5wNHO
         JUTm6IFkOqqwpn0ZWCVJqkBvLLDasWMz3NVarWHnqs5wbaAg3GATZTl+5jsU/epYut
         c3t+XOiw+0NP1Lrh8aHkD+Vc4PTE0gwgRApH27pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/575] ataflop: use a separate gendisk for each media format
Date:   Mon, 15 Nov 2021 18:01:23 +0100
Message-Id: <20211115165356.189065720@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit bf9c0538e485b591a2ee02d9adb8a99db4be5a2a ]

The Atari floppy driver usually autodetects the media when used with the
ormal /dev/fd? devices, which also are the only nodes created by udev.
But it also supports various aliases that force a given media format.
That is currently supported using the blk_register_region framework
which finds the floppy gendisk even for a 'mismatched' dev_t.  The
problem with this (besides the code complexity) is that it creates
multiple struct block_device instances for the whole device of a
single gendisk, which can lead to interesting issues in code not
aware of that fact.

To fix this just create a separate gendisk for each of the aliases
if they are accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 135 +++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 49 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index cd612cd04767a..e6264db11e415 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -297,7 +297,7 @@ static struct atari_floppy_struct {
 	unsigned int wpstat;	/* current state of WP signal (for
 				   disk change detection) */
 	int flags;		/* flags */
-	struct gendisk *disk;
+	struct gendisk *disk[NUM_DISK_MINORS];
 	int ref;
 	int type;
 	struct blk_mq_tag_set tag_set;
@@ -720,12 +720,16 @@ static void fd_error( void )
 
 static int do_format(int drive, int type, struct atari_format_descr *desc)
 {
-	struct request_queue *q = unit[drive].disk->queue;
+	struct request_queue *q;
 	unsigned char	*p;
 	int sect, nsect;
 	unsigned long	flags;
 	int ret;
 
+	if (type)
+		type--;
+
+	q = unit[drive].disk[type]->queue;
 	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
@@ -735,7 +739,7 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	local_irq_restore(flags);
 
 	if (type) {
-		if (--type >= NUM_DISK_MINORS ||
+		if (type >= NUM_DISK_MINORS ||
 		    minor2disktype[type].drive_types > DriveType) {
 			ret = -EINVAL;
 			goto out;
@@ -1151,7 +1155,7 @@ static void fd_rwsec_done1(int status)
 			    if (SUDT[-1].blocks > ReqBlock) {
 				/* try another disk type */
 				SUDT--;
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 			    } else
 				Probing = 0;
@@ -1166,7 +1170,7 @@ static void fd_rwsec_done1(int status)
 /* record not found, but not probing. Maybe stretch wrong ? Restart probing */
 			if (SUD.autoprobe) {
 				SUDT = atari_disk_type + StartDiskType[DriveType];
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 				Probing = 1;
 			}
@@ -1506,7 +1510,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (!UDT) {
 			Probing = 1;
 			UDT = atari_disk_type + StartDiskType[DriveType];
-			set_capacity(floppy->disk, UDT->blocks);
+			set_capacity(bd->rq->rq_disk, UDT->blocks);
 			UD.autoprobe = 1;
 		}
 	} 
@@ -1524,7 +1528,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		}
 		type = minor2disktype[type].index;
 		UDT = &atari_disk_type[type];
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(bd->rq->rq_disk, UDT->blocks);
 		UD.autoprobe = 0;
 	}
 
@@ -1647,7 +1651,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 				    printk (KERN_INFO "floppy%d: setting %s %p!\n",
 				        drive, dtp->name, dtp);
 				UDT = dtp;
-				set_capacity(floppy->disk, UDT->blocks);
+				set_capacity(disk, UDT->blocks);
 
 				if (cmd == FDDEFPRM) {
 				  /* save settings as permanent default type */
@@ -1691,7 +1695,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EINVAL;
 
 		UDT = dtp;
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(disk, UDT->blocks);
 
 		return 0;
 	case FDMSGON:
@@ -1714,7 +1718,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		UDT = NULL;
 		/* MSch: invalidate default_params */
 		default_params[drive].blocks  = 0;
-		set_capacity(floppy->disk, MAX_DISK_SIZE * 2);
+		set_capacity(disk, MAX_DISK_SIZE * 2);
 		fallthrough;
 	case FDFMTEND:
 	case FDFLUSH:
@@ -1950,14 +1954,50 @@ static const struct blk_mq_ops ataflop_mq_ops = {
 	.queue_rq = ataflop_queue_rq,
 };
 
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
+static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 {
-	int drive = *part & 3;
-	int type  = *part >> 2;
+	struct gendisk *disk;
+	int ret;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
+	if (IS_ERR(disk->queue)) {
+		ret = PTR_ERR(disk->queue);
+		disk->queue = NULL;
+		put_disk(disk);
+		return ret;
+	}
+
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = drive + (type << 2);
+	sprintf(disk->disk_name, "fd%d", drive);
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	disk->private_data = &unit[drive];
+	set_capacity(disk, MAX_DISK_SIZE * 2);
+
+	unit[drive].disk[type] = disk;
+	return 0;
+}
+
+static DEFINE_MUTEX(ataflop_probe_lock);
+
+static void ataflop_probe(dev_t dev)
+{
+	int drive = MINOR(dev) & 3;
+	int type  = MINOR(dev) >> 2;
+
 	if (drive >= FD_MAX_UNITS || type > NUM_DISK_MINORS)
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(unit[drive].disk);
+		return;
+	mutex_lock(&ataflop_probe_lock);
+	if (!unit[drive].disk[type]) {
+		if (ataflop_alloc_disk(drive, type) == 0)
+			add_disk(unit[drive].disk[type]);
+	}
+	mutex_unlock(&ataflop_probe_lock);
 }
 
 static int __init atari_floppy_init (void)
@@ -1969,23 +2009,26 @@ static int __init atari_floppy_init (void)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
 		return -ENODEV;
 
-	if (register_blkdev(FLOPPY_MAJOR,"fd"))
-		return -EBUSY;
+	mutex_lock(&ataflop_probe_lock);
+	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
+	if (ret)
+		goto out_unlock;
 
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		unit[i].disk = alloc_disk(1);
-		if (!unit[i].disk) {
-			ret = -ENOMEM;
+		memset(&unit[i].tag_set, 0, sizeof(unit[i].tag_set));
+		unit[i].tag_set.ops = &ataflop_mq_ops;
+		unit[i].tag_set.nr_hw_queues = 1;
+		unit[i].tag_set.nr_maps = 1;
+		unit[i].tag_set.queue_depth = 2;
+		unit[i].tag_set.numa_node = NUMA_NO_NODE;
+		unit[i].tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		ret = blk_mq_alloc_tag_set(&unit[i].tag_set);
+		if (ret)
 			goto err;
-		}
 
-		unit[i].disk->queue = blk_mq_init_sq_queue(&unit[i].tag_set,
-							   &ataflop_mq_ops, 2,
-							   BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(unit[i].disk->queue)) {
-			put_disk(unit[i].disk);
-			ret = PTR_ERR(unit[i].disk->queue);
-			unit[i].disk->queue = NULL;
+		ret = ataflop_alloc_disk(i, 0);
+		if (ret) {
+			blk_mq_free_tag_set(&unit[i].tag_set);
 			goto err;
 		}
 	}
@@ -2015,19 +2058,9 @@ static int __init atari_floppy_init (void)
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		unit[i].track = -1;
 		unit[i].flags = 0;
-		unit[i].disk->major = FLOPPY_MAJOR;
-		unit[i].disk->first_minor = i;
-		sprintf(unit[i].disk->disk_name, "fd%d", i);
-		unit[i].disk->fops = &floppy_fops;
-		unit[i].disk->events = DISK_EVENT_MEDIA_CHANGE;
-		unit[i].disk->private_data = &unit[i];
-		set_capacity(unit[i].disk, MAX_DISK_SIZE * 2);
-		add_disk(unit[i].disk);
+		add_disk(unit[i].disk[0]);
 	}
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-				floppy_find, NULL, NULL);
-
 	printk(KERN_INFO "Atari floppy driver: max. %cD, %strack buffering\n",
 	       DriveType == 0 ? 'D' : DriveType == 1 ? 'H' : 'E',
 	       UseTrackbuffer ? "" : "no ");
@@ -2037,14 +2070,14 @@ static int __init atari_floppy_init (void)
 
 err:
 	while (--i >= 0) {
-		struct gendisk *disk = unit[i].disk;
-
-		blk_cleanup_queue(disk->queue);
+		blk_cleanup_queue(unit[i].disk[0]->queue);
+		put_disk(unit[i].disk[0]);
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+out_unlock:
+	mutex_unlock(&ataflop_probe_lock);
 	return ret;
 }
 
@@ -2089,13 +2122,17 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i;
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
+	int i, type;
+
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		del_gendisk(unit[i].disk);
-		blk_cleanup_queue(unit[i].disk->queue);
+		for (type = 0; type < NUM_DISK_MINORS; type++) {
+			if (!unit[i].disk[type])
+				continue;
+			del_gendisk(unit[i].disk[type]);
+			blk_cleanup_queue(unit[i].disk[type]->queue);
+			put_disk(unit[i].disk[type]);
+		}
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
-- 
2.33.0



