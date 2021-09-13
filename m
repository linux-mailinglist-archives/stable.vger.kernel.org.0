Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E4B408DD6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhIMNaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242308AbhIMN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80F561279;
        Mon, 13 Sep 2021 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539419;
        bh=X9mtfPwTHx3GKW8Qe36hDz/wS7IaH+qFEmSVaV00GcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uspq+qB3NA0dYNAlW63WvECq50BekzRKmPzDiPBzIZ4K1TgK4nHaAiib3O987tMep
         VmN8aZa6d1ooXDVo0XneKd5EF4uLnDfURAiImGAk0wI0gF48Sb0mcy68+iDrFifkOA
         3PEDr0lnYX/SbEFNwM/PlUKfrjqTlu78Ct/XaT5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunguang Xu <brookxu@tencent.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/236] blk-throtl: optimize IOPS throttle for large IO scenarios
Date:   Mon, 13 Sep 2021 15:12:03 +0200
Message-Id: <20210913131100.949141386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

[ Upstream commit 4f1e9630afe6332de7286820fedd019f19eac057 ]

After patch 54efd50 (block: make generic_make_request handle
arbitrarily sized bios), the IO through io-throttle may be larger,
and these IOs may be further split into more small IOs. However,
IOPS throttle does not seem to be aware of this change, which
makes the calculation of IOPS of large IOs incomplete, resulting
in disk-side IOPS that does not meet expectations. Maybe we should
fix this problem.

We can reproduce it by set max_sectors_kb of disk to 128, set
blkio.write_iops_throttle to 100, run a dd instance inside blkio
and use iostat to watch IOPS:

dd if=/dev/zero of=/dev/sdb bs=1M count=1000 oflag=direct

As a result, without this change the average IOPS is 1995, with
this change the IOPS is 98.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c    |  2 ++
 block/blk-throttle.c | 32 ++++++++++++++++++++++++++++++++
 block/blk.h          |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 349cd7d3af81..110db636d230 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -341,6 +341,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
+
+		blk_throtl_charge_bio_split(*bio);
 	}
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b771c4299982..63e9d00a0832 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -178,6 +178,9 @@ struct throtl_grp {
 	unsigned int bad_bio_cnt; /* bios exceeding latency threshold */
 	unsigned long bio_cnt_reset_time;
 
+	atomic_t io_split_cnt[2];
+	atomic_t last_io_split_cnt[2];
+
 	struct blkg_rwstat stat_bytes;
 	struct blkg_rwstat stat_ios;
 };
@@ -771,6 +774,8 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
 
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	/*
 	 * Previous slice has expired. We must have trimmed it after last
 	 * bio dispatch. That means since start of last slice, we never used
@@ -793,6 +798,9 @@ static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
 	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
+
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	throtl_log(&tg->service_queue,
 		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
 		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
@@ -1025,6 +1033,9 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 				jiffies + tg->td->throtl_slice);
 	}
 
+	if (iops_limit != UINT_MAX)
+		tg->io_disp[rw] += atomic_xchg(&tg->io_split_cnt[rw], 0);
+
 	if (tg_with_in_bps_limit(tg, bio, bps_limit, &bps_wait) &&
 	    tg_with_in_iops_limit(tg, bio, iops_limit, &iops_wait)) {
 		if (wait)
@@ -2046,12 +2057,14 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 	}
 
 	if (tg->iops[READ][LIMIT_LOW]) {
+		tg->last_io_disp[READ] += atomic_xchg(&tg->last_io_split_cnt[READ], 0);
 		iops = tg->last_io_disp[READ] * HZ / elapsed_time;
 		if (iops >= tg->iops[READ][LIMIT_LOW])
 			tg->last_low_overflow_time[READ] = now;
 	}
 
 	if (tg->iops[WRITE][LIMIT_LOW]) {
+		tg->last_io_disp[WRITE] += atomic_xchg(&tg->last_io_split_cnt[WRITE], 0);
 		iops = tg->last_io_disp[WRITE] * HZ / elapsed_time;
 		if (iops >= tg->iops[WRITE][LIMIT_LOW])
 			tg->last_low_overflow_time[WRITE] = now;
@@ -2170,6 +2183,25 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
+void blk_throtl_charge_bio_split(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct throtl_grp *parent = blkg_to_tg(blkg);
+	struct throtl_service_queue *parent_sq;
+	bool rw = bio_data_dir(bio);
+
+	do {
+		if (!parent->has_rules[rw])
+			break;
+
+		atomic_inc(&parent->io_split_cnt[rw]);
+		atomic_inc(&parent->last_io_split_cnt[rw]);
+
+		parent_sq = parent->service_queue.parent_sq;
+		parent = sq_to_tg(parent_sq);
+	} while (parent);
+}
+
 bool blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bio->bi_disk->queue;
diff --git a/block/blk.h b/block/blk.h
index ecfd523c68d0..f84c83300f6f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -299,11 +299,13 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_mask, int node);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern void blk_throtl_register_queue(struct request_queue *q);
+extern void blk_throtl_charge_bio_split(struct bio *bio);
 bool blk_throtl_bio(struct bio *bio);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
+static inline void blk_throtl_charge_bio_split(struct bio *bio) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-- 
2.30.2



