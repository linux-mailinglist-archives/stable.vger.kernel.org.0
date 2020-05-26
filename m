Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DC61D3B4D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgENTAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgENSzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E402074A;
        Thu, 14 May 2020 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482538;
        bh=RyauCsxiWR6yHzEGhM4ClHB52t/cCsIR3Yac2foI/cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObAZE+iKiu9Ais/PoDfHNIKHaIWGNuLEm9OeyWa4S7cohY8Z9fyiNa/6rUkLp/dvO
         0VvjXa9PbvLc4nYPcrh92w7DazDCbz9kuLMOFzXvC0Y6mk9pCEm1qoI7z1JuJnyBE0
         AUOHTjBtbWR6bSHVvbMAF4Zon4KjACWsAGtlKw8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Lance Digby <ldigby@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/39] virtio-blk: handle block_device_operations callbacks after hot unplug
Date:   Thu, 14 May 2020 14:54:48 -0400
Message-Id: <20200514185456.21060-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit 90b5feb8c4bebc76c27fcaf3e1a0e5ca2d319e9e ]

A userspace process holding a file descriptor to a virtio_blk device can
still invoke block_device_operations after hot unplug.  This leads to a
use-after-free accessing vblk->vdev in virtblk_getgeo() when
ioctl(HDIO_GETGEO) is invoked:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
  IP: [<ffffffffc00e5450>] virtio_check_driver_offered_feature+0x10/0x90 [virtio]
  PGD 800000003a92f067 PUD 3a930067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 1310 Comm: hdio-getgeo Tainted: G           OE  ------------   3.10.0-1062.el7.x86_64 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  task: ffff9be5fbfb8000 ti: ffff9be5fa890000 task.ti: ffff9be5fa890000
  RIP: 0010:[<ffffffffc00e5450>]  [<ffffffffc00e5450>] virtio_check_driver_offered_feature+0x10/0x90 [virtio]
  RSP: 0018:ffff9be5fa893dc8  EFLAGS: 00010246
  RAX: ffff9be5fc3f3400 RBX: ffff9be5fa893e30 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff9be5fbc10b40
  RBP: ffff9be5fa893dc8 R08: 0000000000000301 R09: 0000000000000301
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff9be5fdc24680
  R13: ffff9be5fbc10b40 R14: ffff9be5fbc10480 R15: 0000000000000000
  FS:  00007f1bfb968740(0000) GS:ffff9be5ffc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000090 CR3: 000000003a894000 CR4: 0000000000360ff0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   [<ffffffffc016ac37>] virtblk_getgeo+0x47/0x110 [virtio_blk]
   [<ffffffff8d3f200d>] ? handle_mm_fault+0x39d/0x9b0
   [<ffffffff8d561265>] blkdev_ioctl+0x1f5/0xa20
   [<ffffffff8d488771>] block_ioctl+0x41/0x50
   [<ffffffff8d45d9e0>] do_vfs_ioctl+0x3a0/0x5a0
   [<ffffffff8d45dc81>] SyS_ioctl+0xa1/0xc0

A related problem is that virtblk_remove() leaks the vd_index_ida index
when something still holds a reference to vblk->disk during hot unplug.
This causes virtio-blk device names to be lost (vda, vdb, etc).

Fix these issues by protecting vblk->vdev with a mutex and reference
counting vblk so the vd_index_ida index can be removed in all cases.

Fixes: 48e4043d4529 ("virtio: add virtio disk geometry feature")
Reported-by: Lance Digby <ldigby@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://lore.kernel.org/r/20200430140442.171016-1-stefanha@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 86 ++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 19d226ff15ef8..0e18eed62c575 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -31,6 +31,15 @@ struct virtio_blk_vq {
 } ____cacheline_aligned_in_smp;
 
 struct virtio_blk {
+	/*
+	 * This mutex must be held by anything that may run after
+	 * virtblk_remove() sets vblk->vdev to NULL.
+	 *
+	 * blk-mq, virtqueue processing, and sysfs attribute code paths are
+	 * shut down before vblk->vdev is set to NULL and therefore do not need
+	 * to hold this mutex.
+	 */
+	struct mutex vdev_mutex;
 	struct virtio_device *vdev;
 
 	/* The disk structure for the kernel. */
@@ -42,6 +51,13 @@ struct virtio_blk {
 	/* Process context for config space updates */
 	struct work_struct config_work;
 
+	/*
+	 * Tracks references from block_device_operations open/release and
+	 * virtio_driver probe/remove so this object can be freed once no
+	 * longer in use.
+	 */
+	refcount_t refs;
+
 	/* What host tells us, plus 2 for header & tailer. */
 	unsigned int sg_elems;
 
@@ -315,10 +331,55 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	return err;
 }
 
+static void virtblk_get(struct virtio_blk *vblk)
+{
+	refcount_inc(&vblk->refs);
+}
+
+static void virtblk_put(struct virtio_blk *vblk)
+{
+	if (refcount_dec_and_test(&vblk->refs)) {
+		ida_simple_remove(&vd_index_ida, vblk->index);
+		mutex_destroy(&vblk->vdev_mutex);
+		kfree(vblk);
+	}
+}
+
+static int virtblk_open(struct block_device *bd, fmode_t mode)
+{
+	struct virtio_blk *vblk = bd->bd_disk->private_data;
+	int ret = 0;
+
+	mutex_lock(&vblk->vdev_mutex);
+
+	if (vblk->vdev)
+		virtblk_get(vblk);
+	else
+		ret = -ENXIO;
+
+	mutex_unlock(&vblk->vdev_mutex);
+	return ret;
+}
+
+static void virtblk_release(struct gendisk *disk, fmode_t mode)
+{
+	struct virtio_blk *vblk = disk->private_data;
+
+	virtblk_put(vblk);
+}
+
 /* We provide getgeo only to please some old bootloader/partitioning tools */
 static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
 	struct virtio_blk *vblk = bd->bd_disk->private_data;
+	int ret = 0;
+
+	mutex_lock(&vblk->vdev_mutex);
+
+	if (!vblk->vdev) {
+		ret = -ENXIO;
+		goto out;
+	}
 
 	/* see if the host passed in geometry config */
 	if (virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_GEOMETRY)) {
@@ -334,12 +395,16 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 		geo->sectors = 1 << 5;
 		geo->cylinders = get_capacity(bd->bd_disk) >> 11;
 	}
-	return 0;
+out:
+	mutex_unlock(&vblk->vdev_mutex);
+	return ret;
 }
 
 static const struct block_device_operations virtblk_fops = {
 	.ioctl  = virtblk_ioctl,
 	.owner  = THIS_MODULE,
+	.open = virtblk_open,
+	.release = virtblk_release,
 	.getgeo = virtblk_getgeo,
 };
 
@@ -659,6 +724,10 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_free_index;
 	}
 
+	/* This reference is dropped in virtblk_remove(). */
+	refcount_set(&vblk->refs, 1);
+	mutex_init(&vblk->vdev_mutex);
+
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 
@@ -821,8 +890,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 static void virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
-	int index = vblk->index;
-	int refc;
 
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vblk->config_work);
@@ -832,18 +899,21 @@ static void virtblk_remove(struct virtio_device *vdev)
 
 	blk_mq_free_tag_set(&vblk->tag_set);
 
+	mutex_lock(&vblk->vdev_mutex);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
-	refc = kref_read(&disk_to_dev(vblk->disk)->kobj.kref);
+	/* Virtqueues are stopped, nothing can use vblk->vdev anymore. */
+	vblk->vdev = NULL;
+
 	put_disk(vblk->disk);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk->vqs);
-	kfree(vblk);
 
-	/* Only free device id if we don't have any users */
-	if (refc == 1)
-		ida_simple_remove(&vd_index_ida, index);
+	mutex_unlock(&vblk->vdev_mutex);
+
+	virtblk_put(vblk);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.20.1

