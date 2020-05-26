Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39D01D8178
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgERRsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgERRsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB5020657;
        Mon, 18 May 2020 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824092;
        bh=l3oMwkLZlXtUwxRPL7uKuCXhYCkavnZtLQZS38cwrMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrDG6nts5dB+oTAcZ0Fv/t6YG9aL8/VjggHRpaVwqwXEKuOpTRkobIa2b03XuzUCC
         Bd8D8vso/ClRnu2CSoNNP6/0g3Vf6tpCN3OrKy7/uyIYnzlLBNwZWlbgACJgVJMfTe
         y9WJtUhes0o+mEc++Zx63PqXa+Ixx5x3Jjim22sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tristan Madani <tristmd@gmail.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 041/114] blktrace: Protect q->blk_trace with RCU
Date:   Mon, 18 May 2020 19:36:13 +0200
Message-Id: <20200518173510.901489508@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Tristan Madani <tristmd@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 4.14: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h       |    2 
 include/linux/blktrace_api.h |   18 ++++--
 kernel/trace/blktrace.c      |  114 +++++++++++++++++++++++++++++++------------
 3 files changed, 97 insertions(+), 37 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -568,7 +568,7 @@ struct request_queue {
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
 #define blk_add_cgroup_trace_msg(q, cg, fmt, ...)			\
 	do {								\
-		struct blk_trace *bt = (q)->blk_trace;			\
+		struct blk_trace *bt;					\
+									\
+		rcu_read_lock();					\
+		bt = rcu_dereference((q)->blk_trace);			\
 		if (unlikely(bt))					\
 			__trace_note_message(bt, cg, fmt, ##__VA_ARGS__);\
+		rcu_read_unlock();					\
 	} while (0)
 #define blk_add_trace_msg(q, fmt, ...)					\
 	blk_add_cgroup_trace_msg(q, NULL, fmt, ##__VA_ARGS__)
@@ -61,10 +65,14 @@ void __trace_note_message(struct blk_tra
 
 static inline bool blk_trace_note_message_enabled(struct request_queue *q)
 {
-	struct blk_trace *bt = q->blk_trace;
-	if (likely(!bt))
-		return false;
-	return bt->act_mask & BLK_TC_NOTIFY;
+	struct blk_trace *bt;
+	bool ret;
+
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	ret = bt && (bt->act_mask & BLK_TC_NOTIFY);
+	rcu_read_unlock();
+	return ret;
 }
 
 extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -348,6 +348,7 @@ static void put_probe_ref(void)
 
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
+	synchronize_rcu();
 	blk_trace_free(bt);
 	put_probe_ref();
 }
@@ -648,8 +649,10 @@ static int compat_blk_trace_setup(struct
 static int __blk_trace_startstop(struct request_queue *q, int start)
 {
 	int ret;
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	bt = rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (bt == NULL)
 		return -EINVAL;
 
@@ -758,8 +761,8 @@ int blk_trace_ioctl(struct block_device
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
@@ -771,8 +774,10 @@ void blk_trace_shutdown(struct request_q
 static union kernfs_node_id *
 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 {
-	struct blk_trace *bt = q->blk_trace;
+	struct blk_trace *bt;
 
+	/* We don't use the 'bt' value here except as an optimization... */
+	bt = rcu_dereference_protected(q->blk_trace, 1);
 	if (!bt || !(blk_tracer_flags.val & TRACE_BLK_OPT_CGROUP))
 		return NULL;
 
@@ -817,10 +822,14 @@ static void blk_add_trace_rq(struct requ
 			     unsigned int nr_bytes, u32 what,
 			     union kernfs_node_id *cgid)
 {
-	struct blk_trace *bt = rq->q->blk_trace;
+	struct blk_trace *bt;
 
-	if (likely(!bt))
+	rcu_read_lock();
+	bt = rcu_dereference(rq->q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	if (blk_rq_is_passthrough(rq))
 		what |= BLK_TC_ACT(BLK_TC_PC);
@@ -829,6 +838,7 @@ static void blk_add_trace_rq(struct requ
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), nr_bytes, req_op(rq),
 			rq->cmd_flags, what, error, 0, NULL, cgid);
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_rq_insert(void *ignore,
@@ -874,13 +884,18 @@ static void blk_add_trace_rq_complete(vo
 static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 			      u32 what, int error, union kernfs_node_id *cgid)
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
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio_op(bio), bio->bi_opf, what, error, 0, NULL, cgid);
+	rcu_read_unlock();
 }
 
 static void blk_add_trace_bio_bounce(void *ignore,
@@ -931,11 +946,14 @@ static void blk_add_trace_getrq(void *ig
 		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0,
 				  blk_trace_bio_get_cgid(q, bio));
 	else {
-		struct blk_trace *bt = q->blk_trace;
+		struct blk_trace *bt;
 
+		rcu_read_lock();
+		bt = rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
 					NULL, NULL);
+		rcu_read_unlock();
 	}
 }
 
@@ -948,27 +966,35 @@ static void blk_add_trace_sleeprq(void *
 		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0,
 				  blk_trace_bio_get_cgid(q, bio));
 	else {
-		struct blk_trace *bt = q->blk_trace;
+		struct blk_trace *bt;
 
+		rcu_read_lock();
+		bt = rcu_dereference(q->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
 					0, 0, NULL, NULL);
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
 		__blk_add_trace(bt, 0, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL, NULL);
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
@@ -980,14 +1006,17 @@ static void blk_add_trace_unplug(void *i
 
 		__blk_add_trace(bt, 0, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu, NULL);
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
 
@@ -996,6 +1025,7 @@ static void blk_add_trace_split(void *ig
 				BLK_TA_SPLIT, bio->bi_status, sizeof(rpdu),
 				&rpdu, blk_trace_bio_get_cgid(q, bio));
 	}
+	rcu_read_unlock();
 }
 
 /**
@@ -1015,11 +1045,15 @@ static void blk_add_trace_bio_remap(void
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
 	r.device_to   = cpu_to_be32(bio_dev(bio));
@@ -1028,6 +1062,7 @@ static void blk_add_trace_bio_remap(void
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio_op(bio), bio->bi_opf, BLK_TA_REMAP, bio->bi_status,
 			sizeof(r), &r, blk_trace_bio_get_cgid(q, bio));
+	rcu_read_unlock();
 }
 
 /**
@@ -1048,11 +1083,15 @@ static void blk_add_trace_rq_remap(void
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
@@ -1061,6 +1100,7 @@ static void blk_add_trace_rq_remap(void
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
 			sizeof(r), &r, blk_trace_request_get_cgid(q, rq));
+	rcu_read_unlock();
 }
 
 /**
@@ -1078,14 +1118,19 @@ void blk_add_driver_data(struct request_
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
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,
 				BLK_TA_DRV_DATA, 0, len, data,
 				blk_trace_request_get_cgid(q, rq));
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
@@ -1612,6 +1657,7 @@ static int blk_trace_remove_queue(struct
 		return -EINVAL;
 
 	put_probe_ref();
+	synchronize_rcu();
 	blk_trace_free(bt);
 	return 0;
 }
@@ -1773,6 +1819,7 @@ static ssize_t sysfs_blk_trace_attr_show
 	struct hd_struct *p = dev_to_part(dev);
 	struct request_queue *q;
 	struct block_device *bdev;
+	struct blk_trace *bt;
 	ssize_t ret = -ENXIO;
 
 	bdev = bdget(part_devt(p));
@@ -1785,21 +1832,23 @@ static ssize_t sysfs_blk_trace_attr_show
 
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
@@ -1816,6 +1865,7 @@ static ssize_t sysfs_blk_trace_attr_stor
 	struct block_device *bdev;
 	struct request_queue *q;
 	struct hd_struct *p;
+	struct blk_trace *bt;
 	u64 value;
 	ssize_t ret = -EINVAL;
 
@@ -1846,8 +1896,10 @@ static ssize_t sysfs_blk_trace_attr_stor
 
 	mutex_lock(&q->blk_trace_mutex);
 
+	bt = rcu_dereference_protected(q->blk_trace,
+				       lockdep_is_held(&q->blk_trace_mutex));
 	if (attr == &dev_attr_enable) {
-		if (!!value == !!q->blk_trace) {
+		if (!!value == !!bt) {
 			ret = 0;
 			goto out_unlock_bdev;
 		}
@@ -1859,18 +1911,18 @@ static ssize_t sysfs_blk_trace_attr_stor
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


