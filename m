Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1578548F69
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378116AbiFMNkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378830AbiFMNjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152A578EE2;
        Mon, 13 Jun 2022 04:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3A66101F;
        Mon, 13 Jun 2022 11:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AC1C34114;
        Mon, 13 Jun 2022 11:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119672;
        bh=+8STXQD/1hbDRvQNyc46YGPUPQtV5B/nXQPJFWW7nGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRWTFhVjXGhRYd6PUOH16m3b9dqRWN0lk9522JIzJ8kFBZ2/fxRA6W5tARNgSewDk
         onoBFlVtoj3FwkzlXzSiqzU5E2ei5jZtCbmOJCFs2OiMPOfrT4VZb4jsXOH8+p7yGc
         0b5ZlriRDH9BIPAG+5judXv2CbeDff2aHU+ISEmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 098/339] block, loop: support partitions without scanning
Date:   Mon, 13 Jun 2022 12:08:43 +0200
Message-Id: <20220613094929.483722087@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b9684a71fca793213378dd410cd11675d973eaa1 ]

Historically we did distinguish between a flag that surpressed partition
scanning, and a combinations of the minors variable and another flag if
any partitions were supported.  This was generally confusing and doesn't
make much sense, but some corner case uses of the loop driver actually
do want to support manually added partitions on a device that does not
actively scan for partitions.  To make things worsee the loop driver
also wants to dynamically toggle the scanning for partitions on a live
gendisk, which makes the disk->flags updates non-atomic.

Introduce a new GD_SUPPRESS_PART_SCAN bit in disk->state that disables
just scanning for partitions, and toggle that instead of GENHD_FL_NO_PART
in the loop driver.

Fixes: 1ebe2e5f9d68 ("block: remove GENHD_FL_EXT_DEVT")
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220527055806.1972352-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c          | 2 ++
 drivers/block/loop.c   | 8 ++++----
 include/linux/blkdev.h | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b8b6759d670f..3008ec213654 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -385,6 +385,8 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
+	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ed7bec11948c..4e1dce3beab0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1066,7 +1066,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
 	if (partscan)
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
@@ -1185,7 +1185,7 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	 */
 	lo->lo_flags = 0;
 	if (!part_shift)
-		lo->lo_disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
@@ -1295,7 +1295,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (!err && (lo->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(prev_lo_flags & LO_FLAGS_PARTSCAN)) {
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 		partscan = true;
 	}
 out_unlock:
@@ -2054,7 +2054,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d016138997..108e3d114bfc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -147,6 +147,7 @@ struct gendisk {
 #define GD_DEAD				2
 #define GD_NATIVE_CAPACITY		3
 #define GD_ADDED			4
+#define GD_SUPPRESS_PART_SCAN		5
 
 	struct mutex open_mutex;	/* open/close mutex */
 	unsigned open_partitions;	/* number of open partitions */
-- 
2.35.1



