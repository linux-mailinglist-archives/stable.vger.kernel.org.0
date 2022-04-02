Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6CE4F0151
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiDBMEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiDBMEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:04:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F83141FDA
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF00C613F9
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE148C340EC;
        Sat,  2 Apr 2022 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648900965;
        bh=tTcxnYIL2I7PQddDE60tenoXC9+smP66EWbyUhV+v5w=;
        h=Subject:To:Cc:From:Date:From;
        b=S5F4LvVrLThBOyN3WOrg2L3Z/I3XGJG2fW/H0WfDPt0kSZowh/cKpJ4w6DCOATk+K
         jMZ3Ii+MXKlJMu7hvSNTQmCIvAYMd6hkEDKP/Wp8NzA0GaaigSAFdPoDp8rZrchPSc
         Q+wcQerH7uhMfC7TX0MckB8hkwfZmvNpx3t/YQOE=
Subject: FAILED: patch "[PATCH] block: fix rq-qos breakage from skipping rq_qos_done_bio()" failed to apply to 5.15-stable tree
To:     tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com,
        yukuai3@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:02:24 +0200
Message-ID: <164890094491121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa1b46dcdc7baaf5fec0be25782ef24b26aa209e Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 13 Mar 2022 21:15:02 -1000
Subject: [PATCH] block: fix rq-qos breakage from skipping rq_qos_done_bio()

a647a524a467 ("block: don't call rq_qos_ops->done_bio if the bio isn't
tracked") made bio_endio() skip rq_qos_done_bio() if BIO_TRACKED is not set.
While this fixed a potential oops, it also broke blk-iocost by skipping the
done_bio callback for merged bios.

Before, whether a bio goes through rq_qos_throttle() or rq_qos_merge(),
rq_qos_done_bio() would be called on the bio on completion with BIO_TRACKED
distinguishing the former from the latter. rq_qos_done_bio() is not called
for bios which wenth through rq_qos_merge(). This royally confuses
blk-iocost as the merged bios never finish and are considered perpetually
in-flight.

One reliably reproducible failure mode is an intermediate cgroup geting
stuck active preventing its children from being activated due to the
leaf-only rule, leading to loss of control. The following is from
resctl-bench protection scenario which emulates isolating a web server like
workload from a memory bomb run on an iocost configuration which should
yield a reasonable level of protection.

  # cat /sys/block/nvme2n1/device/model
  Samsung SSD 970 PRO 512GB
  # cat /sys/fs/cgroup/io.cost.model
  259:0 ctrl=user model=linear rbps=834913556 rseqiops=93622 rrandiops=102913 wbps=618985353 wseqiops=72325 wrandiops=71025
  # cat /sys/fs/cgroup/io.cost.qos
  259:0 enable=1 ctrl=user rpct=95.00 rlat=18776 wpct=95.00 wlat=8897 min=60.00 max=100.00
  # resctl-bench -m 29.6G -r out.json run protection::scenario=mem-hog,loops=1
  ...
  Memory Hog Summary
  ==================

  IO Latency: R p50=242u:336u/2.5m p90=794u:1.4m/7.5m p99=2.7m:8.0m/62.5m max=8.0m:36.4m/350m
              W p50=221u:323u/1.5m p90=709u:1.2m/5.5m p99=1.5m:2.5m/9.5m max=6.9m:35.9m/350m

  Isolation and Request Latency Impact Distributions:

                min   p01   p05   p10   p25   p50   p75   p90   p95   p99   max  mean stdev
  isol%       15.90 15.90 15.90 40.05 57.24 59.07 60.01 74.63 74.63 90.35 90.35 58.12 15.82
  lat-imp%        0     0     0     0     0  4.55 14.68 15.54 233.5 548.1 548.1 53.88 143.6

  Result: isol=58.12:15.82% lat_imp=53.88%:143.6 work_csv=100.0% missing=3.96%

The isolation result of 58.12% is close to what this device would show
without any IO control.

Fix it by introducing a new flag BIO_QOS_MERGED to mark merged bios and
calling rq_qos_done_bio() on them too. For consistency and clarity, rename
BIO_TRACKED to BIO_QOS_THROTTLED. The flag checks are moved into
rq_qos_done_bio() so that it's next to the code paths that set the flags.

With the patch applied, the above same benchmark shows:

  # resctl-bench -m 29.6G -r out.json run protection::scenario=mem-hog,loops=1
  ...
  Memory Hog Summary
  ==================

  IO Latency: R p50=123u:84.4u/985u p90=322u:256u/2.5m p99=1.6m:1.4m/9.5m max=11.1m:36.0m/350m
              W p50=429u:274u/995u p90=1.7m:1.3m/4.5m p99=3.4m:2.7m/11.5m max=7.9m:5.9m/26.5m

  Isolation and Request Latency Impact Distributions:

                min   p01   p05   p10   p25   p50   p75   p90   p95   p99   max  mean stdev
  isol%       84.91 84.91 89.51 90.73 92.31 94.49 96.36 98.04 98.71 100.0 100.0 94.42  2.81
  lat-imp%        0     0     0     0     0  2.81  5.73 11.11 13.92 17.53 22.61  4.10  4.68

  Result: isol=94.42:2.81% lat_imp=4.10%:4.68 work_csv=58.34% missing=0%

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: a647a524a467 ("block: don't call rq_qos_ops->done_bio if the bio isn't tracked")
Cc: stable@vger.kernel.org # v5.15+
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/Yi7rdrzQEHjJLGKB@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/bio.c b/block/bio.c
index 151cace2dbe1..33979f306e9e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1516,8 +1516,7 @@ void bio_endio(struct bio *bio)
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACKED))
-		rq_qos_done_bio(bdev_get_queue(bio->bi_bdev), bio);
+	rq_qos_done_bio(bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
 		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 010e658d44a8..2f33932e72e3 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -598,7 +598,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	int inflight = 0;
 
 	blkg = bio->bi_blkg;
-	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
+	if (!blkg || !bio_flagged(bio, BIO_QOS_THROTTLED))
 		return;
 
 	iolat = blkg_to_lat(bio->bi_blkg);
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 3cfbc8668cba..68267007da1c 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -177,20 +177,20 @@ static inline void rq_qos_requeue(struct request_queue *q, struct request *rq)
 		__rq_qos_requeue(q->rq_qos, rq);
 }
 
-static inline void rq_qos_done_bio(struct request_queue *q, struct bio *bio)
+static inline void rq_qos_done_bio(struct bio *bio)
 {
-	if (q->rq_qos)
-		__rq_qos_done_bio(q->rq_qos, bio);
+	if (bio->bi_bdev && (bio_flagged(bio, BIO_QOS_THROTTLED) ||
+			     bio_flagged(bio, BIO_QOS_MERGED))) {
+		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+		if (q->rq_qos)
+			__rq_qos_done_bio(q->rq_qos, bio);
+	}
 }
 
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
 {
-	/*
-	 * BIO_TRACKED lets controllers know that a bio went through the
-	 * normal rq_qos path.
-	 */
 	if (q->rq_qos) {
-		bio_set_flag(bio, BIO_TRACKED);
+		bio_set_flag(bio, BIO_QOS_THROTTLED);
 		__rq_qos_throttle(q->rq_qos, bio);
 	}
 }
@@ -205,8 +205,10 @@ static inline void rq_qos_track(struct request_queue *q, struct request *rq,
 static inline void rq_qos_merge(struct request_queue *q, struct request *rq,
 				struct bio *bio)
 {
-	if (q->rq_qos)
+	if (q->rq_qos) {
+		bio_set_flag(bio, BIO_QOS_MERGED);
 		__rq_qos_merge(q->rq_qos, rq, bio);
+	}
 }
 
 static inline void rq_qos_queue_depth_changed(struct request_queue *q)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5561e58d158a..0c3563b45fe9 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -324,7 +324,8 @@ enum {
 	BIO_TRACE_COMPLETION,	/* bio_endio() should trace the final completion
 				 * of this bio. */
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
-	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
+	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
+	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_PERCPU_CACHE,	/* can participate in per-cpu alloc cache */

