Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C664BE146
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350249AbiBUJdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:33:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350299AbiBUJcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:32:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B0828981;
        Mon, 21 Feb 2022 01:13:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F81ACE0E76;
        Mon, 21 Feb 2022 09:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D3C339C0;
        Mon, 21 Feb 2022 09:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434800;
        bh=k746DZxAA+/aDYMWOEpZoYiOInvN5LqHlegOtLXaSH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJCaRwhMShkSNKMJynp6qHUry2f0h7UgBsoZf+wAA5jMeIl19D6ViNe9bV3tXi+Ia
         vJ6dD7BqwW1j/gisQGDjLNF9+tnmX/pUbJ4uo2MZ8lijgryJFdXLHufyGG//sWY0uR
         NlumCnLUG+BHx+ozxhKsixGwJtd1FmQ+xgYA6w2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus.bloechl@ipetronik.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 135/196] block: fix surprise removal for drivers calling blk_set_queue_dying
Date:   Mon, 21 Feb 2022 09:49:27 +0100
Message-Id: <20220221084935.438133819@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7a5428dcb7902700b830e912feee4e845df7c019 upstream.

Various block drivers call blk_set_queue_dying to mark a disk as dead due
to surprise removal events, but since commit 8e141f9eb803 that doesn't
work given that the GD_DEAD flag needs to be set to stop I/O.

Replace the driver calls to blk_set_queue_dying with a new (and properly
documented) blk_mark_disk_dead API, and fold blk_set_queue_dying into the
only remaining caller.

Fixes: 8e141f9eb803 ("block: drain file system I/O on del_gendisk")
Reported-by: Markus Blöchl <markus.bloechl@ipetronik.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://lore.kernel.org/r/20220217075231.1140-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c                  |   10 ++--------
 block/genhd.c                     |   14 ++++++++++++++
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 drivers/block/rbd.c               |    2 +-
 drivers/block/xen-blkfront.c      |    2 +-
 drivers/md/dm.c                   |    2 +-
 drivers/nvme/host/core.c          |    2 +-
 drivers/nvme/host/multipath.c     |    2 +-
 include/linux/blkdev.h            |    3 ++-
 9 files changed, 24 insertions(+), 15 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -350,13 +350,6 @@ void blk_queue_start_drain(struct reques
 	wake_up_all(&q->mq_freeze_wq);
 }
 
-void blk_set_queue_dying(struct request_queue *q)
-{
-	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
-	blk_queue_start_drain(q);
-}
-EXPORT_SYMBOL_GPL(blk_set_queue_dying);
-
 /**
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
@@ -374,7 +367,8 @@ void blk_cleanup_queue(struct request_qu
 	WARN_ON_ONCE(blk_queue_registered(q));
 
 	/* mark @q DYING, no new request or merges will be allowed afterwards */
-	blk_set_queue_dying(q);
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+	blk_queue_start_drain(q);
 
 	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	blk_queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -545,6 +545,20 @@ out_free_ext_minor:
 EXPORT_SYMBOL(device_add_disk);
 
 /**
+ * blk_mark_disk_dead - mark a disk as dead
+ * @disk: disk to mark as dead
+ *
+ * Mark as disk as dead (e.g. surprise removed) and don't accept any new I/O
+ * to this disk.
+ */
+void blk_mark_disk_dead(struct gendisk *disk)
+{
+	set_bit(GD_DEAD, &disk->state);
+	blk_queue_start_drain(disk->queue);
+}
+EXPORT_SYMBOL_GPL(blk_mark_disk_dead);
+
+/**
  * del_gendisk - remove the gendisk
  * @disk: the struct gendisk to remove
  *
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4112,7 +4112,7 @@ static void mtip_pci_remove(struct pci_d
 			"Completion workers still active!\n");
 	}
 
-	blk_set_queue_dying(dd->queue);
+	blk_mark_disk_dead(dd->disk);
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
 
 	/* Clean up the block layer. */
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7182,7 +7182,7 @@ static ssize_t do_rbd_remove(struct bus_
 		 * IO to complete/fail.
 		 */
 		blk_mq_freeze_queue(rbd_dev->disk->queue);
-		blk_set_queue_dying(rbd_dev->disk->queue);
+		blk_mark_disk_dead(rbd_dev->disk);
 	}
 
 	del_gendisk(rbd_dev->disk);
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2128,7 +2128,7 @@ static void blkfront_closing(struct blkf
 
 	/* No more blkif_request(). */
 	blk_mq_stop_hw_queues(info->rq);
-	blk_set_queue_dying(info->rq);
+	blk_mark_disk_dead(info->gd);
 	set_capacity(info->gd, 0);
 
 	for_each_rinfo(info, rinfo, i) {
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2156,7 +2156,7 @@ static void __dm_destroy(struct mapped_d
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	blk_set_queue_dying(md->queue);
+	blk_mark_disk_dead(md->disk);
 
 	/*
 	 * Take suspend_lock so that presuspend and postsuspend methods
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -131,7 +131,7 @@ static void nvme_set_queue_dying(struct
 	if (test_and_set_bit(NVME_NS_DEAD, &ns->flags))
 		return;
 
-	blk_set_queue_dying(ns->queue);
+	blk_mark_disk_dead(ns->disk);
 	blk_mq_unquiesce_queue(ns->queue);
 
 	set_capacity_and_notify(ns->disk, 0);
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -792,7 +792,7 @@ void nvme_mpath_remove_disk(struct nvme_
 {
 	if (!head->disk)
 		return;
-	blk_set_queue_dying(head->disk->queue);
+	blk_mark_disk_dead(head->disk);
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1184,7 +1184,8 @@ extern void blk_dump_rq_flags(struct req
 
 bool __must_check blk_get_queue(struct request_queue *);
 extern void blk_put_queue(struct request_queue *);
-extern void blk_set_queue_dying(struct request_queue *);
+
+void blk_mark_disk_dead(struct gendisk *disk);
 
 #ifdef CONFIG_BLOCK
 /*


