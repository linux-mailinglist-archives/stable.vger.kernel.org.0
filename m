Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29A5501020
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbiDNNrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245592AbiDNNio (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5509A5EA2;
        Thu, 14 Apr 2022 06:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52ADC6122A;
        Thu, 14 Apr 2022 13:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68588C385A1;
        Thu, 14 Apr 2022 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943186;
        bh=44lVM/amND90feArpe5TIR64rOXZwEf0h4oD2/g9f/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldZTS/hvh1ZpkdYfwcDB2mSm0i9K16jJcX/mJsHXyegtrUDBArpSaJIEFEL0Sovxl
         jzG8oJaT39Dz9AQJGFTZy4y/8gVljGlshBiy+BF4iS3OaWN4w7TDLWImKi1Nz5VM68
         aKN/8F+cIUsFPB1bw1GRcaai91OVNwVZm/fcAwnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <jbacik@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 065/475] block: dont merge across cgroup boundaries if blkcg is enabled
Date:   Thu, 14 Apr 2022 15:07:30 +0200
Message-Id: <20220414110856.972671765@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
+#include <linux/blk-cgroup.h>
 
 #include <trace/events/block.h>
 
@@ -571,6 +572,9 @@ static inline unsigned int blk_rq_get_ma
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
+	if (!blk_cgroup_mergeable(req, bio))
+		goto no_merge;
+
 	if (blk_integrity_merge_bio(req->q, req, bio) == false)
 		goto no_merge;
 
@@ -662,6 +666,9 @@ static int ll_merge_requests_fn(struct r
 	if (total_phys_segments > blk_rq_get_max_segments(req))
 		return 0;
 
+	if (!blk_cgroup_mergeable(req, next->bio))
+		return 0;
+
 	if (blk_integrity_merge_rq(q, req, next) == false)
 		return 0;
 
@@ -885,6 +892,10 @@ bool blk_rq_merge_ok(struct request *rq,
 	if (rq->rq_disk != bio->bi_disk)
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
@@ -22,6 +22,7 @@
 #include <linux/atomic.h>
 #include <linux/kthread.h>
 #include <linux/fs.h>
+#include <linux/blkdev.h>
 
 /* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
 #define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
@@ -768,6 +769,21 @@ static inline void blkcg_use_delay(struc
 		atomic_inc(&blkg->blkcg->css.cgroup->congestion_count);
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
 static inline int blkcg_unuse_delay(struct blkcg_gq *blkg)
 {
 	int old = atomic_read(&blkg->use_delay);
@@ -868,6 +884,7 @@ static inline bool blkcg_punt_bio_submit
 static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio) { return true; }
+static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
 
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)


