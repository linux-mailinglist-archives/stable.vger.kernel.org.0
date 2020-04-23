Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325001B67D4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgDWXKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50458 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728606AbgDWXGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvf-0004tB-U6; Fri, 24 Apr 2020 00:06:48 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkva-00E70R-CM; Fri, 24 Apr 2020 00:06:42 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Ming Lei" <ming.lei@redhat.com>, "Jan Kara" <jack@suse.cz>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Tristan Madani" <tristmd@gmail.com>,
        "Chaitanya Kulkarni" <chaitanya.kulkarni@wdc.com>
Date:   Fri, 24 Apr 2020 00:07:19 +0100
Message-ID: <lsq.1587683028.702005283@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 212/245] blktrace: Protect q->blk_trace with RCU
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit c780e86dd48ef6467a1146cf7d0fe1e05a635039 upstream.

KASAN is reporting that __blk_add_trace() has a use-after-free issue
when accessing q->blk_trace. Indeed the switching of block tracing (and
thus eventual freeing of q->blk_trace) is completely unsynchronized with
the currently running tracing and thus it can happen that the blk_trace
structure is being freed just while __blk_add_trace() works on it.
Protect accesses to q->blk_trace by RCU during tracing and make sure we
wait for the end of RCU grace period when shutting down tracing. Luckily
that is rare enough event that we can afford that. Note that postponing
the freeing of blk_trace to an RCU callback should better be avoided as
it could have unexpected user visible side-effects as debugfs files
would be still existing for a short while block tracing has been shut
down.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205711
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Tristan Madani <tristmd@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.16:
 - Drop changes in blk_trace_note_message_enabled(), blk_trace_bio_get_cgid()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -447,7 +447,7 @@ struct request_queue {
 	unsigned int		sg_reserved_size;
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
-	struct blk_trace	*blk_trace;
+	struct blk_trace __rcu	*blk_trace;
 	struct mutex		blk_trace_mutex;
 #endif
 	/*
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -51,9 +51,13 @@ void __trace_note_message(struct blk_tra
  **/
 #define blk_add_trace_msg(q, fmt, ...)					\
 	do {								\
-		struct blk_trace *bt = (q)->blk_trace;			\
+		struct blk_trace *bt;					\
+									\
+		rcu_read_lock();					\
+		bt = rcu_dereference((q)->blk_trace);			\
 		if (unlikely(bt))					\
 			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
+		rcu_read_unlock();					\
 	} while (0)
 #define BLK_TN_MAX_MSG		128
 
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -302,6 +302,7 @@ static void blk_trace_free(struct blk_tr
 
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
+	synchronize_rcu();
 	blk_trace_free(bt);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
@@ -616,8 +617,10 @@ static int compat_blk_trace_setup(struct
 static int __blk_trace_startstop(struct request_queue *q, int start)
 {
 	int ret;
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	bt = rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (bt == NULL)
 		return -EINVAL;
 
@@ -726,8 +729,8 @@ int blk_trace_ioctl(struct block_device
 void blk_trace_shutdown(struct request_queue *q)
 {
 	mutex_lock(&q->blk_trace_mutex);
-
-	if (q->blk_trace) {
+	if (rcu_dereference_protected(q->blk_trace,
+				      lockdep_is_held(&q->blk_trace_mutex))) {
 		__blk_trace_startstop(q, 0);
 		__blk_trace_remove(q);
 	}
@@ -753,10 +756,14 @@ void blk_trace_shutdown(struct request_q
 static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 			     unsigned int nr_bytes, u32 what)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
@@ -767,6 +774,7 @@ static void blk_add_trace_rq(struct requ
 		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes,
 				rq->cmd_flags, what, rq->errors, 0, NULL);
 	}
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_rq_abort(void *ignore,
@@ -816,16 +824,21 @@ static void blk_add_trace_rq_complete(vo
 static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 			      u32 what, int error)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	if (!error && !bio_flagged(bio, BIO_UPTODATE))
 		error = EIO;
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio->bi_rw, what, error, 0, NULL);
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_bio_bounce(void *ignore,
@@ -870,10 +883,13 @@ static void blk_add_trace_getrq(void *ig
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);
 	else {
-		struct blk_trace *bt = q->blk_trace;
+		struct blk_trace *bt;
 
+		rcu_read_lock();
+		bt = rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, BLK_TA_GETRQ, 0, 0, NULL);
+		rcu_read_unlock();
 	}
 }
 
@@ -885,27 +901,35 @@ static void blk_add_trace_sleeprq(void *
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
 	else {
-		struct blk_trace *bt = q->blk_trace;
+		struct blk_trace *bt;
 
+		rcu_read_lock();
+		bt = rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, BLK_TA_SLEEPRQ,
 					0, 0, NULL);
+		rcu_read_unlock();
 	}
 }
 
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
 	if (bt)
 		__blk_add_trace(bt, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL);
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 				    unsigned int depth, bool explicit)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
 	if (bt) {
 		__be64 rpdu = cpu_to_be64(depth);
 		u32 what;
@@ -917,14 +941,17 @@ static void blk_add_trace_unplug(void *i
 
 		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
 	}
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_split(void *ignore,
 				struct request_queue *q, struct bio *bio,
 				unsigned int pdu)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
 	if (bt) {
 		__be64 rpdu = cpu_to_be64(pdu);
 
@@ -933,6 +960,7 @@ static void blk_add_trace_split(void *ig
 				!bio_flagged(bio, BIO_UPTODATE),
 				sizeof(rpdu), &rpdu);
 	}
+	rcu_read_unlock();
 }
 
 /**
@@ -952,11 +980,15 @@ static void blk_add_trace_bio_remap(void
 				    struct request_queue *q, struct bio *bio,
 				    dev_t dev, sector_t from)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	r.device_from = cpu_to_be32(dev);
 	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
@@ -965,6 +997,7 @@ static void blk_add_trace_bio_remap(void
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio->bi_rw, BLK_TA_REMAP,
 			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+	rcu_read_unlock();
 }
 
 /**
@@ -985,11 +1018,15 @@ static void blk_add_trace_rq_remap(void
 				   struct request *rq, dev_t dev,
 				   sector_t from)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	r.device_from = cpu_to_be32(dev);
 	r.device_to   = cpu_to_be32(disk_devt(rq->rq_disk));
@@ -998,6 +1035,7 @@ static void blk_add_trace_rq_remap(void
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
 			sizeof(r), &r);
+	rcu_read_unlock();
 }
 
 /**
@@ -1015,10 +1053,14 @@ void blk_add_driver_data(struct request_
 			 struct request *rq,
 			 void *data, size_t len)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
 		__blk_add_trace(bt, 0, blk_rq_bytes(rq), 0,
@@ -1026,6 +1068,7 @@ void blk_add_driver_data(struct request_
 	else
 		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), 0,
 				BLK_TA_DRV_DATA, rq->errors, len, data);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
@@ -1537,6 +1580,7 @@ static int blk_trace_remove_queue(struct
 	spin_lock_irq(&running_trace_lock);
 	list_del(&bt->running_list);
 	spin_unlock_irq(&running_trace_lock);
+	synchronize_rcu();
 	blk_trace_free(bt);
 	return 0;
 }
@@ -1698,6 +1742,7 @@ static ssize_t sysfs_blk_trace_attr_show
 	struct hd_struct *p = dev_to_part(dev);
 	struct request_queue *q;
 	struct block_device *bdev;
+	struct blk_trace *bt;
 	ssize_t ret = -ENXIO;
 
 	bdev = bdget(part_devt(p));
@@ -1710,21 +1755,23 @@ static ssize_t sysfs_blk_trace_attr_show
 
 	mutex_lock(&q->blk_trace_mutex);
 
+	bt = rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (attr == &dev_attr_enable) {
-		ret = sprintf(buf, "%u\n", !!q->blk_trace);
+		ret = sprintf(buf, "%u\n", !!bt);
 		goto out_unlock_bdev;
 	}
 
-	if (q->blk_trace == NULL)
+	if (bt == NULL)
 		ret = sprintf(buf, "disabled\n");
 	else if (attr == &dev_attr_act_mask)
-		ret = blk_trace_mask2str(buf, q->blk_trace->act_mask);
+		ret = blk_trace_mask2str(buf, bt->act_mask);
 	else if (attr == &dev_attr_pid)
-		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
+		ret = sprintf(buf, "%u\n", bt->pid);
 	else if (attr == &dev_attr_start_lba)
-		ret = sprintf(buf, "%llu\n", q->blk_trace->start_lba);
+		ret = sprintf(buf, "%llu\n", bt->start_lba);
 	else if (attr == &dev_attr_end_lba)
-		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
+		ret = sprintf(buf, "%llu\n", bt->end_lba);
 
 out_unlock_bdev:
 	mutex_unlock(&q->blk_trace_mutex);
@@ -1741,6 +1788,7 @@ static ssize_t sysfs_blk_trace_attr_stor
 	struct block_device *bdev;
 	struct request_queue *q;
 	struct hd_struct *p;
+	struct blk_trace *bt;
 	u64 value;
 	ssize_t ret = -EINVAL;
 
@@ -1771,8 +1819,10 @@ static ssize_t sysfs_blk_trace_attr_stor
 
 	mutex_lock(&q->blk_trace_mutex);
 
+	bt = rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (attr == &dev_attr_enable) {
-		if (!!value == !!q->blk_trace) {
+		if (!!value == !!bt) {
 			ret = 0;
 			goto out_unlock_bdev;
 		}
@@ -1784,18 +1834,18 @@ static ssize_t sysfs_blk_trace_attr_stor
 	}
 
 	ret = 0;
-	if (q->blk_trace == NULL)
+	if (bt == NULL)
 		ret = blk_trace_setup_queue(q, bdev);
 
 	if (ret == 0) {
 		if (attr == &dev_attr_act_mask)
-			q->blk_trace->act_mask = value;
+			bt->act_mask = value;
 		else if (attr == &dev_attr_pid)
-			q->blk_trace->pid = value;
+			bt->pid = value;
 		else if (attr == &dev_attr_start_lba)
-			q->blk_trace->start_lba = value;
+			bt->start_lba = value;
 		else if (attr == &dev_attr_end_lba)
-			q->blk_trace->end_lba = value;
+			bt->end_lba = value;
 	}
 
 out_unlock_bdev:

