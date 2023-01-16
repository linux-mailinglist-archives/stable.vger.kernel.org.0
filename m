Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8D066C59C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjAPQH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjAPQHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5C326850
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96D3BB8107B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE89C43396;
        Mon, 16 Jan 2023 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885126;
        bh=Bh4TaeR9DYSWakrVlYQxNOrj3vABI3BLqe4aSI08Kds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaHXuB0Dq3chHxOQ8s7PE1G8yFvXxpOsjotR8btRQGXaRXzPiGhHPQis/AlNsveth
         U4apwKzQE5UTmIImDB4SrkbYVWoZF2DRdtVVpoC9hoN5E2NsE53ADbN6SZ4+uTI7aC
         09m/i6Y/cf2PdQemLfm5CiSPOHpAFpVevudvxBVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 84/86] block: handle bio_split_to_limits() NULL return
Date:   Mon, 16 Jan 2023 16:51:58 +0100
Message-Id: <20230116154750.511578322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 613b14884b8595e20b9fac4126bf627313827fbe upstream.

This can't happen right now, but in preparation for allowing
bio_split_to_limits() returning NULL if it ended the bio, check for it
in all the callers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c             |    4 +++-
 block/blk-mq.c                |    2 ++
 drivers/block/drbd/drbd_req.c |    2 ++
 drivers/block/pktcdvd.c       |    2 ++
 drivers/block/ps3vram.c       |    2 ++
 drivers/block/rsxx/dev.c      |    2 ++
 drivers/md/md.c               |    2 ++
 drivers/nvme/host/multipath.c |    2 ++
 drivers/s390/block/dcssblk.c  |    2 ++
 9 files changed, 19 insertions(+), 1 deletion(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -348,11 +348,13 @@ void __blk_queue_split(struct bio **bio,
 			break;
 		}
 		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
+		if (IS_ERR(split))
+			*bio = split = NULL;
 		break;
 	}
 
 	if (split) {
-		/* there isn't chance to merge the splitted bio */
+		/* there isn't chance to merge the split bio */
 		split->bi_opf |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2193,6 +2193,8 @@ blk_qc_t blk_mq_submit_bio(struct bio *b
 
 	blk_queue_bounce(q, &bio);
 	__blk_queue_split(&bio, &nr_segs);
+	if (!bio)
+		goto queue_exit;
 
 	if (!bio_integrity_prep(bio))
 		goto queue_exit;
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1602,6 +1602,8 @@ blk_qc_t drbd_submit_bio(struct bio *bio
 	struct drbd_device *device = bio->bi_bdev->bd_disk->private_data;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	/*
 	 * what we "blindly" assume:
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2407,6 +2407,8 @@ static blk_qc_t pkt_submit_bio(struct bi
 	struct bio *split;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	pd = bio->bi_bdev->bd_disk->queue->queuedata;
 	if (!pd) {
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -587,6 +587,8 @@ static blk_qc_t ps3vram_submit_bio(struc
 	dev_dbg(&dev->core, "%s\n", __func__);
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -127,6 +127,8 @@ static blk_qc_t rsxx_submit_bio(struct b
 	blk_status_t st = BLK_STS_IOERR;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	might_sleep();
 
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -458,6 +458,8 @@ static blk_qc_t md_submit_bio(struct bio
 	}
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -329,6 +329,8 @@ static blk_qc_t nvme_ns_head_submit_bio(
 	 * pool from the original queue to allocate the bvecs from.
 	 */
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -866,6 +866,8 @@ dcssblk_submit_bio(struct bio *bio)
 	unsigned long bytes_done;
 
 	blk_queue_split(&bio);
+	if (!bio)
+		return BLK_QC_T_NONE;
 
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;


