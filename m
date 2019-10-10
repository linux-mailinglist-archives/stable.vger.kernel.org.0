Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A845D230C
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387770AbfJJIjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfJJIjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78EF920B7C;
        Thu, 10 Oct 2019 08:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696743;
        bh=DOfdTEUieOxwC6wXSXgnYXmOtvz6mDGLITASQakpklQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTLgfNbvUQXAwc0xq8fAK4dpI+/I2pNSpXrk1vIGaSsU/xLOkCbKzWwETlmMbAi5q
         TdNucpHj/f2D0DehQH3Z+nR1cgYgMRKlZvpCPd8gkKOkXrC+y/Nmeia3/ZHx8oWEax
         lqh7A1gYYlPv8psWx+PiG4QMfobAOBmpGiKbvtpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 008/148] Revert "s390/dasd: Add discard support for ESE volumes"
Date:   Thu, 10 Oct 2019 10:34:29 +0200
Message-Id: <20191010083611.466799920@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 964ce509e2ded52c1a61ad86044cc4d70abd9eb8 upstream.

This reverts commit 7e64db1597fe114b83fe17d0ba96c6aa5fca419a.

The thin provisioning feature introduces an IOCTL and the discard support
to allow userspace tools and filesystems to release unused and previously
allocated space respectively.

During some internal performance improvements and further tests, the
release of allocated space revealed some issues that may lead to data
corruption in some configurations when filesystems are mounted with
discard support enabled.

While we're working on a fix and trying to clarify the situation,
this commit reverts the discard support for ESE volumes to prevent
potential data corruption.

Cc: <stable@vger.kernel.org> # 5.3
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_eckd.c |   57 ++---------------------------------------
 1 file changed, 3 insertions(+), 54 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2055,9 +2055,6 @@ dasd_eckd_check_characteristics(struct d
 	if (readonly)
 		set_bit(DASD_FLAG_DEVICE_RO, &device->flags);
 
-	if (dasd_eckd_is_ese(device))
-		dasd_set_feature(device->cdev, DASD_FEATURE_DISCARD, 1);
-
 	dev_info(&device->cdev->dev, "New DASD %04X/%02X (CU %04X/%02X) "
 		 "with %d cylinders, %d heads, %d sectors%s\n",
 		 private->rdc_data.dev_type,
@@ -3691,14 +3688,6 @@ static int dasd_eckd_release_space(struc
 		return -EINVAL;
 }
 
-static struct dasd_ccw_req *
-dasd_eckd_build_cp_discard(struct dasd_device *device, struct dasd_block *block,
-			   struct request *req, sector_t first_trk,
-			   sector_t last_trk)
-{
-	return dasd_eckd_dso_ras(device, block, req, first_trk, last_trk, 1);
-}
-
 static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 					       struct dasd_device *startdev,
 					       struct dasd_block *block,
@@ -4443,10 +4432,6 @@ static struct dasd_ccw_req *dasd_eckd_bu
 	cmdwtd = private->features.feature[12] & 0x40;
 	use_prefix = private->features.feature[8] & 0x01;
 
-	if (req_op(req) == REQ_OP_DISCARD)
-		return dasd_eckd_build_cp_discard(startdev, block, req,
-						  first_trk, last_trk);
-
 	cqr = NULL;
 	if (cdlspecial || dasd_page_cache) {
 		/* do nothing, just fall through to the cmd mode single case */
@@ -4725,14 +4710,12 @@ static struct dasd_ccw_req *dasd_eckd_bu
 						     struct dasd_block *block,
 						     struct request *req)
 {
-	struct dasd_device *startdev = NULL;
 	struct dasd_eckd_private *private;
-	struct dasd_ccw_req *cqr;
+	struct dasd_device *startdev;
 	unsigned long flags;
+	struct dasd_ccw_req *cqr;
 
-	/* Discard requests can only be processed on base devices */
-	if (req_op(req) != REQ_OP_DISCARD)
-		startdev = dasd_alias_get_start_dev(base);
+	startdev = dasd_alias_get_start_dev(base);
 	if (!startdev)
 		startdev = base;
 	private = startdev->private;
@@ -6513,20 +6496,8 @@ static void dasd_eckd_setup_blk_queue(st
 	unsigned int logical_block_size = block->bp_block;
 	struct request_queue *q = block->request_queue;
 	struct dasd_device *device = block->base;
-	struct dasd_eckd_private *private;
-	unsigned int max_discard_sectors;
-	unsigned int max_bytes;
-	unsigned int ext_bytes; /* Extent Size in Bytes */
-	int recs_per_trk;
-	int trks_per_cyl;
-	int ext_limit;
-	int ext_size; /* Extent Size in Cylinders */
 	int max;
 
-	private = device->private;
-	trks_per_cyl = private->rdc_data.trk_per_cyl;
-	recs_per_trk = recs_per_track(&private->rdc_data, 0, logical_block_size);
-
 	if (device->features & DASD_FEATURE_USERAW) {
 		/*
 		 * the max_blocks value for raw_track access is 256
@@ -6547,28 +6518,6 @@ static void dasd_eckd_setup_blk_queue(st
 	/* With page sized segments each segment can be translated into one idaw/tidaw */
 	blk_queue_max_segment_size(q, PAGE_SIZE);
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
-
-	if (dasd_eckd_is_ese(device)) {
-		/*
-		 * Depending on the extent size, up to UINT_MAX bytes can be
-		 * accepted. However, neither DASD_ECKD_RAS_EXTS_MAX nor the
-		 * device limits should be exceeded.
-		 */
-		ext_size = dasd_eckd_ext_size(device);
-		ext_limit = min(private->real_cyl / ext_size, DASD_ECKD_RAS_EXTS_MAX);
-		ext_bytes = ext_size * trks_per_cyl * recs_per_trk *
-			logical_block_size;
-		max_bytes = UINT_MAX - (UINT_MAX % ext_bytes);
-		if (max_bytes / ext_bytes > ext_limit)
-			max_bytes = ext_bytes * ext_limit;
-
-		max_discard_sectors = max_bytes / 512;
-
-		blk_queue_max_discard_sectors(q, max_discard_sectors);
-		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
-		q->limits.discard_granularity = ext_bytes;
-		q->limits.discard_alignment = ext_bytes;
-	}
 }
 
 static struct ccw_driver dasd_eckd_driver = {


