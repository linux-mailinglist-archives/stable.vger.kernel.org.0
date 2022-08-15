Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75A594C59
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349348AbiHPAdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354207AbiHPAbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5493631EEB;
        Mon, 15 Aug 2022 13:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8DBEB80EAD;
        Mon, 15 Aug 2022 20:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3168EC433D6;
        Mon, 15 Aug 2022 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595798;
        bh=/T+XDA4LDasktkcCBVQcCnN9fJT1FrmOMNby1QVc4Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si2Mk2eO0d+bUxnnKM8fD9+dXh+E4K8LFnZCiWCsPWzEkcqvQd28pr3+Crk2OItYa
         TjZDS0NRaw+rsJqvyAmX7kdl3rlDOS3TOmXOCFve7bGCWDeqIDOmPNUpNhdCTx7Ma8
         ElZlHx14XXUUxlxpWDx7iyupVgK2t55KAAXhEUIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0879/1157] mtip32xx: fix device removal
Date:   Mon, 15 Aug 2022 20:03:55 +0200
Message-Id: <20220815180514.591796354@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit e8b58ef09e84c15cf782b01cfc73cc5b1180d519 ]

Use the proper helper to mark a surpise removal, remove the gendisk as
soon as possible when removing the device and implement the ->free_disk
callback to ensure the private data is alive as long as the gendisk has
references.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20220619060552.1850436-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/mtip32xx/mtip32xx.c | 157 +++++++++---------------------
 drivers/block/mtip32xx/mtip32xx.h |   1 -
 2 files changed, 44 insertions(+), 114 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 27386a572ba4..6699e4b2f7f4 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -146,11 +146,8 @@ static bool mtip_check_surprise_removal(struct driver_data *dd)
 	pci_read_config_word(dd->pdev, 0x00, &vendor_id);
 	if (vendor_id == 0xFFFF) {
 		dd->sr = true;
-		if (dd->queue)
-			blk_queue_flag_set(QUEUE_FLAG_DEAD, dd->queue);
-		else
-			dev_warn(&dd->pdev->dev,
-				"%s: dd->queue is NULL\n", __func__);
+		if (dd->disk)
+			blk_mark_disk_dead(dd->disk);
 		return true; /* device removed */
 	}
 
@@ -3297,26 +3294,12 @@ static int mtip_block_getgeo(struct block_device *dev,
 	return 0;
 }
 
-static int mtip_block_open(struct block_device *dev, fmode_t mode)
+static void mtip_block_free_disk(struct gendisk *disk)
 {
-	struct driver_data *dd;
-
-	if (dev && dev->bd_disk) {
-		dd = (struct driver_data *) dev->bd_disk->private_data;
-
-		if (dd) {
-			if (test_bit(MTIP_DDF_REMOVAL_BIT,
-							&dd->dd_flag)) {
-				return -ENODEV;
-			}
-			return 0;
-		}
-	}
-	return -ENODEV;
-}
+	struct driver_data *dd = disk->private_data;
 
-static void mtip_block_release(struct gendisk *disk, fmode_t mode)
-{
+	ida_free(&rssd_index_ida, dd->index);
+	kfree(dd);
 }
 
 /*
@@ -3326,13 +3309,12 @@ static void mtip_block_release(struct gendisk *disk, fmode_t mode)
  * layer.
  */
 static const struct block_device_operations mtip_block_ops = {
-	.open		= mtip_block_open,
-	.release	= mtip_block_release,
 	.ioctl		= mtip_block_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= mtip_block_compat_ioctl,
 #endif
 	.getgeo		= mtip_block_getgeo,
+	.free_disk	= mtip_block_free_disk,
 	.owner		= THIS_MODULE
 };
 
@@ -3673,72 +3655,6 @@ static int mtip_block_initialize(struct driver_data *dd)
 	return rv;
 }
 
-static bool mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
-{
-	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(rq);
-
-	cmd->status = BLK_STS_IOERR;
-	blk_mq_complete_request(rq);
-	return true;
-}
-
-/*
- * Block layer deinitialization function.
- *
- * Called by the PCI layer as each P320 device is removed.
- *
- * @dd Pointer to the driver data structure.
- *
- * return value
- *	0
- */
-static int mtip_block_remove(struct driver_data *dd)
-{
-	mtip_hw_debugfs_exit(dd);
-
-	if (dd->mtip_svc_handler) {
-		set_bit(MTIP_PF_SVC_THD_STOP_BIT, &dd->port->flags);
-		wake_up_interruptible(&dd->port->svc_wait);
-		kthread_stop(dd->mtip_svc_handler);
-	}
-
-	if (!dd->sr) {
-		/*
-		 * Explicitly wait here for IOs to quiesce,
-		 * as mtip_standby_drive usually won't wait for IOs.
-		 */
-		if (!mtip_quiesce_io(dd->port, MTIP_QUIESCE_IO_TIMEOUT_MS))
-			mtip_standby_drive(dd);
-	}
-	else
-		dev_info(&dd->pdev->dev, "device %s surprise removal\n",
-						dd->disk->disk_name);
-
-	blk_freeze_queue_start(dd->queue);
-	blk_mq_quiesce_queue(dd->queue);
-	blk_mq_tagset_busy_iter(&dd->tags, mtip_no_dev_cleanup, dd);
-	blk_mq_unquiesce_queue(dd->queue);
-
-	if (dd->disk) {
-		if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
-			del_gendisk(dd->disk);
-		if (dd->disk->queue) {
-			blk_cleanup_queue(dd->queue);
-			blk_mq_free_tag_set(&dd->tags);
-			dd->queue = NULL;
-		}
-		put_disk(dd->disk);
-	}
-	dd->disk  = NULL;
-
-	ida_free(&rssd_index_ida, dd->index);
-
-	/* De-initialize the protocol layer. */
-	mtip_hw_exit(dd);
-
-	return 0;
-}
-
 /*
  * Function called by the PCI layer when just before the
  * machine shuts down.
@@ -3755,23 +3671,15 @@ static int mtip_block_shutdown(struct driver_data *dd)
 {
 	mtip_hw_shutdown(dd);
 
-	/* Delete our gendisk structure, and cleanup the blk queue. */
-	if (dd->disk) {
-		dev_info(&dd->pdev->dev,
-			"Shutting down %s ...\n", dd->disk->disk_name);
+	dev_info(&dd->pdev->dev,
+		"Shutting down %s ...\n", dd->disk->disk_name);
 
-		if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
-			del_gendisk(dd->disk);
-		if (dd->disk->queue) {
-			blk_cleanup_queue(dd->queue);
-			blk_mq_free_tag_set(&dd->tags);
-		}
-		put_disk(dd->disk);
-		dd->disk  = NULL;
-		dd->queue = NULL;
-	}
+	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
+		del_gendisk(dd->disk);
 
-	ida_free(&rssd_index_ida, dd->index);
+	blk_cleanup_queue(dd->queue);
+	blk_mq_free_tag_set(&dd->tags);
+	put_disk(dd->disk);
 	return 0;
 }
 
@@ -4087,8 +3995,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	struct driver_data *dd = pci_get_drvdata(pdev);
 	unsigned long flags, to;
 
-	set_bit(MTIP_DDF_REMOVAL_BIT, &dd->dd_flag);
-
 	spin_lock_irqsave(&dev_lock, flags);
 	list_del_init(&dd->online_list);
 	list_add(&dd->remove_list, &removing_list);
@@ -4109,11 +4015,36 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 			"Completion workers still active!\n");
 	}
 
-	blk_mark_disk_dead(dd->disk);
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
 
-	/* Clean up the block layer. */
-	mtip_block_remove(dd);
+	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
+		del_gendisk(dd->disk);
+
+	mtip_hw_debugfs_exit(dd);
+
+	if (dd->mtip_svc_handler) {
+		set_bit(MTIP_PF_SVC_THD_STOP_BIT, &dd->port->flags);
+		wake_up_interruptible(&dd->port->svc_wait);
+		kthread_stop(dd->mtip_svc_handler);
+	}
+
+	if (!dd->sr) {
+		/*
+		 * Explicitly wait here for IOs to quiesce,
+		 * as mtip_standby_drive usually won't wait for IOs.
+		 */
+		if (!mtip_quiesce_io(dd->port, MTIP_QUIESCE_IO_TIMEOUT_MS))
+			mtip_standby_drive(dd);
+	}
+	else
+		dev_info(&dd->pdev->dev, "device %s surprise removal\n",
+						dd->disk->disk_name);
+
+	blk_cleanup_queue(dd->queue);
+	blk_mq_free_tag_set(&dd->tags);
+
+	/* De-initialize the protocol layer. */
+	mtip_hw_exit(dd);
 
 	if (dd->isr_workq) {
 		destroy_workqueue(dd->isr_workq);
@@ -4128,10 +4059,10 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	list_del_init(&dd->remove_list);
 	spin_unlock_irqrestore(&dev_lock, flags);
 
-	kfree(dd);
-
 	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
 	pci_set_drvdata(pdev, NULL);
+
+	put_disk(dd->disk);
 }
 
 /*
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 6816beb45352..9c1e45b745dc 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -149,7 +149,6 @@ enum {
 	MTIP_DDF_RESUME_BIT         = 6,
 	MTIP_DDF_INIT_DONE_BIT      = 7,
 	MTIP_DDF_REBUILD_FAILED_BIT = 8,
-	MTIP_DDF_REMOVAL_BIT	    = 9,
 
 	MTIP_DDF_STOP_IO      = ((1 << MTIP_DDF_REMOVE_PENDING_BIT) |
 				(1 << MTIP_DDF_SEC_LOCK_BIT) |
-- 
2.35.1



