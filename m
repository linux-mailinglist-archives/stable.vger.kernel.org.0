Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6D4F3190
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbiDEJEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242941AbiDEItn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531D7793A4;
        Tue,  5 Apr 2022 01:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20F55B81C82;
        Tue,  5 Apr 2022 08:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC8FC385A1;
        Tue,  5 Apr 2022 08:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147863;
        bh=B/RiR4B/SIpEqAuuuwCZ/BSWIAePiwRb5+A2vsL9lPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpw1R1VvlL70HHMLPpbaEk4ZvwizQy6iAp1Y6HDP5lh3JMO2AVVUOulW65T5RKBZN
         NpM/Qe7/xWb/13TdKdxsjLIUy52fM+g86jcla8kb5CsU3+1BouPm4pA3U3r4Elemhr
         UJs/l3tIa0ihNl+Q/41RTnoyw/hwFfcIMToeZMag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <jbacik@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 0148/1017] block: dont merge across cgroup boundaries if blkcg is enabled
Date:   Tue,  5 Apr 2022 09:17:41 +0200
Message-Id: <20220405070358.599717605@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tejun Heo <tj@kernel.org>

commit 6b2b04590b51aa4cf395fcd185ce439cab5961dc upstream.

blk-iocost and iolatency are cgroup aware rq-qos policies but they didn't
disable merges across different cgroups. This obviously can lead to
accounting and control errors but more importantly to priority inversions -
e.g. an IO which belongs to a higher priority cgroup or IO class may end up
getting throttled incorrectly because it gets merged to an IO issued from a
low priority cgroup.

Fix it by adding blk_cgroup_mergeable() which is called from merge paths and
rejects cross-cgroup and cross-issue_as_root merges.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
Cc: Josef Bacik <jbacik@fb.com>
Link: https://lore.kernel.org/r/Yi/eE/6zFNyWJ+qd@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c          |   11 +++++++++++
 include/linux/blk-cgroup.h |   17 +++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
 #include <linux/scatterlist.h>
+#include <linux/blk-cgroup.h>
 
 #include <trace/events/block.h>
 
@@ -598,6 +599,9 @@ static inline unsigned int blk_rq_get_ma
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
+	if (!blk_cgroup_mergeable(req, bio))
+		goto no_merge;
+
 	if (blk_integrity_merge_bio(req->q, req, bio) == false)
 		goto no_merge;
 
@@ -694,6 +698,9 @@ static int ll_merge_requests_fn(struct r
 	if (total_phys_segments > blk_rq_get_max_segments(req))
 		return 0;
 
+	if (!blk_cgroup_mergeable(req, next->bio))
+		return 0;
+
 	if (blk_integrity_merge_rq(q, req, next) == false)
 		return 0;
 
@@ -907,6 +914,10 @@ bool blk_rq_merge_ok(struct request *rq,
 	if (rq->rq_disk != bio->bi_bdev->bd_disk)
 		return false;
 
+	/* don't merge across cgroup boundaries */
+	if (!blk_cgroup_mergeable(rq, bio))
+		return false;
+
 	/* only merge integrity protected bio into ditto rq */
 	if (blk_integrity_merge_bio(rq->q, rq, bio) == false)
 		return false;
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -24,6 +24,7 @@
 #include <linux/atomic.h>
 #include <linux/kthread.h>
 #include <linux/fs.h>
+#include <linux/blk-mq.h>
 
 /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
 #define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
@@ -604,6 +605,21 @@ static inline void blkcg_clear_delay(str
 		atomic_dec(&blkg->blkcg->css.cgroup->congestion_count);
 }
 
+/**
+ * blk_cgroup_mergeable - Determine whether to allow or disallow merges
+ * @rq: request to merge into
+ * @bio: bio to merge
+ *
+ * @bio and @rq should belong to the same cgroup and their issue_as_root should
+ * match. The latter is necessary as we don't want to throttle e.g. a metadata
+ * update because it happens to be next to a regular IO.
+ */
+static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio)
+{
+	return rq->bio->bi_blkg == bio->bi_blkg &&
+		bio_issue_as_root_blkg(rq->bio) == bio_issue_as_root_blkg(bio);
+}
+
 void blk_cgroup_bio_start(struct bio *bio);
 void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta);
 void blkcg_schedule_throttle(struct request_queue *q, bool use_memdelay);
@@ -659,6 +675,7 @@ static inline void blkg_put(struct blkcg
 static inline bool blkcg_punt_bio_submit(struct bio *bio) { return false; }
 static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
+static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)


