Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92354426F
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 06:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiFIEYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 00:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiFIEYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 00:24:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A9765A1;
        Wed,  8 Jun 2022 21:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=9akt0WRbm8VhbkHPMG7ib27G3A8dyPTDT3oedzm9Nvs=; b=30yEhEYgT/oSmXfYX2lGmCZ8A6
        z4AAz+k4xjmDWF9nfovG9ragV+VMSCgDv9VqJaqZbyVItCOQU0NQ1R3yu2/UcBlyxrXepSDqk9Cna
        PyTtQE3TirsvisuaqxWYTi4m2hdqJHSuXDeNdUNQCgKQAfNIlIBUBxFuSyBu2BL7+MO7lk1DC9S3U
        ILkUUc0jxbHa/oX7rDmhX5D6MiHEW/1JA1coUJsepZB9Sk9XgyLBs91zbPZ+EUUK+unm9XVUNXii3
        xU0FR9XMXWyikxtJ1NgGQOy7XxTMmsr0Hdk11dQwwFmMMVOheNtjinsG0iNxiTDgJB51whENmuHUf
        sJVSb4ag==;
Received: from [2001:4bb8:190:726c:6663:143:2578:b59a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz9iG-00GfBG-Eg; Thu, 09 Jun 2022 04:24:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18-stable] block, loop: support partitions without scanning
Date:   Thu,  9 Jun 2022 06:24:02 +0200
Message-Id: <20220609042402.1656851-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b9684a71fca793213378dd410cd11675d973eaa1 upstream.

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
---
 block/genhd.c          | 2 ++
 drivers/block/loop.c   | 8 ++++----
 include/linux/blkdev.h | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b8b6759d670f01..3008ec2136543e 100644
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
index a58595f5ee2c8f..ba3627f982f241 100644
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
@@ -2045,7 +2045,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 60d01613899711..108e3d114bfc1f 100644
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
2.30.2

