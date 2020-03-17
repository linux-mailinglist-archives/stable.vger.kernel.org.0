Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5BA188186
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgCQLEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbgCQLEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B42320738;
        Tue, 17 Mar 2020 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443054;
        bh=73R2WfdOSrpkkl8XItorwlFIwrdDs2+7W7aczg4+Xfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0g4DrjmPrOJgNzlEjnIszuYJpRfvkSaxG17OVqMp15Vmut5HkVdjoj1jAcuIC2d7h
         cgRA9W2htLZTAXaTIuqszU0Mb05ZPzYlqN2/Oahcz22tpoAgh4f2mbrSk9QbS4w6ap
         PQ91a6Q0Crbr6KEE9jSoTY95xMscwWAFw4peARHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 081/123] s390/dasd: fix data corruption for thin provisioned devices
Date:   Tue, 17 Mar 2020 11:55:08 +0100
Message-Id: <20200317103315.768671646@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 5e6bdd37c5526ef01326df5dabb93011ee89237e upstream.

Devices are formatted in multiple of tracks.
For an Extent Space Efficient (ESE) volume we get errors when accessing
unformatted tracks. In this case the driver either formats the track on
the flight for write requests or returns zero data for read requests.

In case a request spans multiple tracks, the indication of an unformatted
track presented for the first track is incorrectly applied to all tracks
covered by the request. As a result, tracks containing data will be handled
as empty, resulting in zero data being returned on read, or overwriting
existing data with zero on write.

Fix by determining the track that gets the NRF error.
For write requests only format the track that is surely not formatted.
For Read requests all tracks before have returned valid data and should not
be touched.
All tracks after the unformatted track might be formatted or not. Those are
returned to the blocklayer to build a new request.

When using alias devices there is a chance that multiple write requests
trigger a format of the same track which might lead to data loss. Ensure
that a track is formatted only once by maintaining a list of currently
processed tracks.

Fixes: 5e2b17e712cf ("s390/dasd: Add dynamic formatting support for ESE volumes")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd.c      |   27 ++++++
 drivers/s390/block/dasd_eckd.c |  163 +++++++++++++++++++++++++++++++++++++++--
 drivers/s390/block/dasd_int.h  |   15 +++
 3 files changed, 193 insertions(+), 12 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -178,6 +178,8 @@ struct dasd_block *dasd_alloc_block(void
 		     (unsigned long) block);
 	INIT_LIST_HEAD(&block->ccw_queue);
 	spin_lock_init(&block->queue_lock);
+	INIT_LIST_HEAD(&block->format_list);
+	spin_lock_init(&block->format_lock);
 	timer_setup(&block->timer, dasd_block_timeout, 0);
 	spin_lock_init(&block->profile.lock);
 
@@ -1779,20 +1781,26 @@ void dasd_int_handler(struct ccw_device
 
 	if (dasd_ese_needs_format(cqr->block, irb)) {
 		if (rq_data_dir((struct request *)cqr->callback_data) == READ) {
-			device->discipline->ese_read(cqr);
+			device->discipline->ese_read(cqr, irb);
 			cqr->status = DASD_CQR_SUCCESS;
 			cqr->stopclk = now;
 			dasd_device_clear_timer(device);
 			dasd_schedule_device_bh(device);
 			return;
 		}
-		fcqr = device->discipline->ese_format(device, cqr);
+		fcqr = device->discipline->ese_format(device, cqr, irb);
 		if (IS_ERR(fcqr)) {
+			if (PTR_ERR(fcqr) == -EINVAL) {
+				cqr->status = DASD_CQR_ERROR;
+				return;
+			}
 			/*
 			 * If we can't format now, let the request go
 			 * one extra round. Maybe we can format later.
 			 */
 			cqr->status = DASD_CQR_QUEUED;
+			dasd_schedule_device_bh(device);
+			return;
 		} else {
 			fcqr->status = DASD_CQR_QUEUED;
 			cqr->status = DASD_CQR_QUEUED;
@@ -2748,11 +2756,13 @@ static void __dasd_cleanup_cqr(struct da
 {
 	struct request *req;
 	blk_status_t error = BLK_STS_OK;
+	unsigned int proc_bytes;
 	int status;
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
 
+	proc_bytes = cqr->proc_bytes;
 	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status < 0)
 		error = errno_to_blk_status(status);
@@ -2783,7 +2793,18 @@ static void __dasd_cleanup_cqr(struct da
 		blk_mq_end_request(req, error);
 		blk_mq_run_hw_queues(req->q, true);
 	} else {
-		blk_mq_complete_request(req);
+		/*
+		 * Partial completed requests can happen with ESE devices.
+		 * During read we might have gotten a NRF error and have to
+		 * complete a request partially.
+		 */
+		if (proc_bytes) {
+			blk_update_request(req, BLK_STS_OK,
+					   blk_rq_bytes(req) - proc_bytes);
+			blk_mq_requeue_request(req, true);
+		} else {
+			blk_mq_complete_request(req);
+		}
 	}
 }
 
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -207,6 +207,45 @@ static void set_ch_t(struct ch_t *geo, _
 	geo->head |= head;
 }
 
+/*
+ * calculate failing track from sense data depending if
+ * it is an EAV device or not
+ */
+static int dasd_eckd_track_from_irb(struct irb *irb, struct dasd_device *device,
+				    sector_t *track)
+{
+	struct dasd_eckd_private *private = device->private;
+	u8 *sense = NULL;
+	u32 cyl;
+	u8 head;
+
+	sense = dasd_get_sense(irb);
+	if (!sense) {
+		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
+			      "ESE error no sense data\n");
+		return -EINVAL;
+	}
+	if (!(sense[27] & DASD_SENSE_BIT_2)) {
+		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
+			      "ESE error no valid track data\n");
+		return -EINVAL;
+	}
+
+	if (sense[27] & DASD_SENSE_BIT_3) {
+		/* enhanced addressing */
+		cyl = sense[30] << 20;
+		cyl |= (sense[31] & 0xF0) << 12;
+		cyl |= sense[28] << 8;
+		cyl |= sense[29];
+	} else {
+		cyl = sense[29] << 8;
+		cyl |= sense[30];
+	}
+	head = sense[31] & 0x0F;
+	*track = cyl * private->rdc_data.trk_per_cyl + head;
+	return 0;
+}
+
 static int set_timestamp(struct ccw1 *ccw, struct DE_eckd_data *data,
 		     struct dasd_device *device)
 {
@@ -2986,6 +3025,37 @@ static int dasd_eckd_format_device(struc
 					     0, NULL);
 }
 
+static bool test_and_set_format_track(struct dasd_format_entry *to_format,
+				      struct dasd_block *block)
+{
+	struct dasd_format_entry *format;
+	unsigned long flags;
+	bool rc = false;
+
+	spin_lock_irqsave(&block->format_lock, flags);
+	list_for_each_entry(format, &block->format_list, list) {
+		if (format->track == to_format->track) {
+			rc = true;
+			goto out;
+		}
+	}
+	list_add_tail(&to_format->list, &block->format_list);
+
+out:
+	spin_unlock_irqrestore(&block->format_lock, flags);
+	return rc;
+}
+
+static void clear_format_track(struct dasd_format_entry *format,
+			      struct dasd_block *block)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&block->format_lock, flags);
+	list_del_init(&format->list);
+	spin_unlock_irqrestore(&block->format_lock, flags);
+}
+
 /*
  * Callback function to free ESE format requests.
  */
@@ -2993,15 +3063,19 @@ static void dasd_eckd_ese_format_cb(stru
 {
 	struct dasd_device *device = cqr->startdev;
 	struct dasd_eckd_private *private = device->private;
+	struct dasd_format_entry *format = data;
 
+	clear_format_track(format, cqr->basedev->block);
 	private->count--;
 	dasd_ffree_request(cqr, device);
 }
 
 static struct dasd_ccw_req *
-dasd_eckd_ese_format(struct dasd_device *startdev, struct dasd_ccw_req *cqr)
+dasd_eckd_ese_format(struct dasd_device *startdev, struct dasd_ccw_req *cqr,
+		     struct irb *irb)
 {
 	struct dasd_eckd_private *private;
+	struct dasd_format_entry *format;
 	struct format_data_t fdata;
 	unsigned int recs_per_trk;
 	struct dasd_ccw_req *fcqr;
@@ -3011,23 +3085,39 @@ dasd_eckd_ese_format(struct dasd_device
 	struct request *req;
 	sector_t first_trk;
 	sector_t last_trk;
+	sector_t curr_trk;
 	int rc;
 
 	req = cqr->callback_data;
-	base = cqr->block->base;
+	block = cqr->block;
+	base = block->base;
 	private = base->private;
-	block = base->block;
 	blksize = block->bp_block;
 	recs_per_trk = recs_per_track(&private->rdc_data, 0, blksize);
+	format = &startdev->format_entry;
 
 	first_trk = blk_rq_pos(req) >> block->s2b_shift;
 	sector_div(first_trk, recs_per_trk);
 	last_trk =
 		(blk_rq_pos(req) + blk_rq_sectors(req) - 1) >> block->s2b_shift;
 	sector_div(last_trk, recs_per_trk);
+	rc = dasd_eckd_track_from_irb(irb, base, &curr_trk);
+	if (rc)
+		return ERR_PTR(rc);
+
+	if (curr_trk < first_trk || curr_trk > last_trk) {
+		DBF_DEV_EVENT(DBF_WARNING, startdev,
+			      "ESE error track %llu not within range %llu - %llu\n",
+			      curr_trk, first_trk, last_trk);
+		return ERR_PTR(-EINVAL);
+	}
+	format->track = curr_trk;
+	/* test if track is already in formatting by another thread */
+	if (test_and_set_format_track(format, block))
+		return ERR_PTR(-EEXIST);
 
-	fdata.start_unit = first_trk;
-	fdata.stop_unit = last_trk;
+	fdata.start_unit = curr_trk;
+	fdata.stop_unit = curr_trk;
 	fdata.blksize = blksize;
 	fdata.intensity = private->uses_cdl ? DASD_FMT_INT_COMPAT : 0;
 
@@ -3044,6 +3134,7 @@ dasd_eckd_ese_format(struct dasd_device
 		return fcqr;
 
 	fcqr->callback = dasd_eckd_ese_format_cb;
+	fcqr->callback_data = (void *) format;
 
 	return fcqr;
 }
@@ -3051,29 +3142,87 @@ dasd_eckd_ese_format(struct dasd_device
 /*
  * When data is read from an unformatted area of an ESE volume, this function
  * returns zeroed data and thereby mimics a read of zero data.
+ *
+ * The first unformatted track is the one that got the NRF error, the address is
+ * encoded in the sense data.
+ *
+ * All tracks before have returned valid data and should not be touched.
+ * All tracks after the unformatted track might be formatted or not. This is
+ * currently not known, remember the processed data and return the remainder of
+ * the request to the blocklayer in __dasd_cleanup_cqr().
  */
-static void dasd_eckd_ese_read(struct dasd_ccw_req *cqr)
+static int dasd_eckd_ese_read(struct dasd_ccw_req *cqr, struct irb *irb)
 {
+	struct dasd_eckd_private *private;
+	sector_t first_trk, last_trk;
+	sector_t first_blk, last_blk;
 	unsigned int blksize, off;
+	unsigned int recs_per_trk;
 	struct dasd_device *base;
 	struct req_iterator iter;
+	struct dasd_block *block;
+	unsigned int skip_block;
+	unsigned int blk_count;
 	struct request *req;
 	struct bio_vec bv;
+	sector_t curr_trk;
+	sector_t end_blk;
 	char *dst;
+	int rc;
 
 	req = (struct request *) cqr->callback_data;
 	base = cqr->block->base;
 	blksize = base->block->bp_block;
+	block =  cqr->block;
+	private = base->private;
+	skip_block = 0;
+	blk_count = 0;
+
+	recs_per_trk = recs_per_track(&private->rdc_data, 0, blksize);
+	first_trk = first_blk = blk_rq_pos(req) >> block->s2b_shift;
+	sector_div(first_trk, recs_per_trk);
+	last_trk = last_blk =
+		(blk_rq_pos(req) + blk_rq_sectors(req) - 1) >> block->s2b_shift;
+	sector_div(last_trk, recs_per_trk);
+	rc = dasd_eckd_track_from_irb(irb, base, &curr_trk);
+	if (rc)
+		return rc;
+
+	/* sanity check if the current track from sense data is valid */
+	if (curr_trk < first_trk || curr_trk > last_trk) {
+		DBF_DEV_EVENT(DBF_WARNING, base,
+			      "ESE error track %llu not within range %llu - %llu\n",
+			      curr_trk, first_trk, last_trk);
+		return -EINVAL;
+	}
+
+	/*
+	 * if not the first track got the NRF error we have to skip over valid
+	 * blocks
+	 */
+	if (curr_trk != first_trk)
+		skip_block = curr_trk * recs_per_trk - first_blk;
+
+	/* we have no information beyond the current track */
+	end_blk = (curr_trk + 1) * recs_per_trk;
 
 	rq_for_each_segment(bv, req, iter) {
 		dst = page_address(bv.bv_page) + bv.bv_offset;
 		for (off = 0; off < bv.bv_len; off += blksize) {
-			if (dst && rq_data_dir(req) == READ) {
+			if (first_blk + blk_count >= end_blk) {
+				cqr->proc_bytes = blk_count * blksize;
+				return 0;
+			}
+			if (dst && !skip_block) {
 				dst += off;
 				memset(dst, 0, blksize);
+			} else {
+				skip_block--;
 			}
+			blk_count++;
 		}
 	}
+	return 0;
 }
 
 /*
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -187,6 +187,7 @@ struct dasd_ccw_req {
 
 	void (*callback)(struct dasd_ccw_req *, void *data);
 	void *callback_data;
+	unsigned int proc_bytes;	/* bytes for partial completion */
 };
 
 /*
@@ -387,8 +388,9 @@ struct dasd_discipline {
 	int (*ext_pool_warn_thrshld)(struct dasd_device *);
 	int (*ext_pool_oos)(struct dasd_device *);
 	int (*ext_pool_exhaust)(struct dasd_device *, struct dasd_ccw_req *);
-	struct dasd_ccw_req *(*ese_format)(struct dasd_device *, struct dasd_ccw_req *);
-	void (*ese_read)(struct dasd_ccw_req *);
+	struct dasd_ccw_req *(*ese_format)(struct dasd_device *,
+					   struct dasd_ccw_req *, struct irb *);
+	int (*ese_read)(struct dasd_ccw_req *, struct irb *);
 };
 
 extern struct dasd_discipline *dasd_diag_discipline_pointer;
@@ -474,6 +476,11 @@ struct dasd_profile {
 	spinlock_t lock;
 };
 
+struct dasd_format_entry {
+	struct list_head list;
+	sector_t track;
+};
+
 struct dasd_device {
 	/* Block device stuff. */
 	struct dasd_block *block;
@@ -539,6 +546,7 @@ struct dasd_device {
 	struct dentry *debugfs_dentry;
 	struct dentry *hosts_dentry;
 	struct dasd_profile profile;
+	struct dasd_format_entry format_entry;
 };
 
 struct dasd_block {
@@ -564,6 +572,9 @@ struct dasd_block {
 
 	struct dentry *debugfs_dentry;
 	struct dasd_profile profile;
+
+	struct list_head format_list;
+	spinlock_t format_lock;
 };
 
 struct dasd_attention_data {


