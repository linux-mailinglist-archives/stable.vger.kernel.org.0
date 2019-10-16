Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12994D9EFF
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438418AbfJPV7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438411AbfJPV7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:10 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A557D21A4C;
        Wed, 16 Oct 2019 21:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263149;
        bh=U5szriT2EOgaFeUPKZQdL0lipD5B8CBqq2qiB1askLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRPFKlUrMwawLfPTpI1FC/Z+ppx5PpbhZXSe3yks4AYOwKKEmA/9muUJbr6vAvGmM
         TikHJhqOn9xvqnhX59kStdxKAwnr5KL+QpJAzZSm+1ohZZ+maASsC0N2SUa5chzuKc
         jXvvZV+FpFLsosQT8dOcVvJFgsAPWNduacQUaI7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 069/112] blk-wbt: fix performance regression in wbt scale_up/scale_down
Date:   Wed, 16 Oct 2019 14:51:01 -0700
Message-Id: <20191016214903.060443070@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

commit b84477d3ebb96294f87dc3161e53fa8fe22d9bfd upstream.

scale_up wakes up waiters after scaling up. But after scaling max, it
should not wake up more waiters as waiters will not have anything to
do. This patch fixes this by making scale_up (and also scale_down)
return when threshold is reached.

This bug causes increased fdatasync latency when fdatasync and dd
conv=sync are performed in parallel on 4.19 compared to 4.14. This
bug was introduced during refactoring of blk-wbt code.

Fixes: a79050434b45 ("blk-rq-qos: refactor out common elements of blk-wbt")
Cc: stable@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-rq-qos.c |   14 +++++++++-----
 block/blk-rq-qos.h |    4 ++--
 block/blk-wbt.c    |    6 ++++--
 3 files changed, 15 insertions(+), 9 deletions(-)

--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -142,24 +142,27 @@ bool rq_depth_calc_max_depth(struct rq_d
 	return ret;
 }
 
-void rq_depth_scale_up(struct rq_depth *rqd)
+/* Returns true on success and false if scaling up wasn't possible */
+bool rq_depth_scale_up(struct rq_depth *rqd)
 {
 	/*
 	 * Hit max in previous round, stop here
 	 */
 	if (rqd->scaled_max)
-		return;
+		return false;
 
 	rqd->scale_step--;
 
 	rqd->scaled_max = rq_depth_calc_max_depth(rqd);
+	return true;
 }
 
 /*
  * Scale rwb down. If 'hard_throttle' is set, do it quicker, since we
- * had a latency violation.
+ * had a latency violation. Returns true on success and returns false if
+ * scaling down wasn't possible.
  */
-void rq_depth_scale_down(struct rq_depth *rqd, bool hard_throttle)
+bool rq_depth_scale_down(struct rq_depth *rqd, bool hard_throttle)
 {
 	/*
 	 * Stop scaling down when we've hit the limit. This also prevents
@@ -167,7 +170,7 @@ void rq_depth_scale_down(struct rq_depth
 	 * keep up.
 	 */
 	if (rqd->max_depth == 1)
-		return;
+		return false;
 
 	if (rqd->scale_step < 0 && hard_throttle)
 		rqd->scale_step = 0;
@@ -176,6 +179,7 @@ void rq_depth_scale_down(struct rq_depth
 
 	rqd->scaled_max = false;
 	rq_depth_calc_max_depth(rqd);
+	return true;
 }
 
 struct rq_qos_wait_data {
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -125,8 +125,8 @@ void rq_qos_wait(struct rq_wait *rqw, vo
 		 acquire_inflight_cb_t *acquire_inflight_cb,
 		 cleanup_cb_t *cleanup_cb);
 bool rq_wait_inc_below(struct rq_wait *rq_wait, unsigned int limit);
-void rq_depth_scale_up(struct rq_depth *rqd);
-void rq_depth_scale_down(struct rq_depth *rqd, bool hard_throttle);
+bool rq_depth_scale_up(struct rq_depth *rqd);
+bool rq_depth_scale_down(struct rq_depth *rqd, bool hard_throttle);
 bool rq_depth_calc_max_depth(struct rq_depth *rqd);
 
 void __rq_qos_cleanup(struct rq_qos *rqos, struct bio *bio);
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -308,7 +308,8 @@ static void calc_wb_limits(struct rq_wb
 
 static void scale_up(struct rq_wb *rwb)
 {
-	rq_depth_scale_up(&rwb->rq_depth);
+	if (!rq_depth_scale_up(&rwb->rq_depth))
+		return;
 	calc_wb_limits(rwb);
 	rwb->unknown_cnt = 0;
 	rwb_wake_all(rwb);
@@ -317,7 +318,8 @@ static void scale_up(struct rq_wb *rwb)
 
 static void scale_down(struct rq_wb *rwb, bool hard_throttle)
 {
-	rq_depth_scale_down(&rwb->rq_depth, hard_throttle);
+	if (!rq_depth_scale_down(&rwb->rq_depth, hard_throttle))
+		return;
 	calc_wb_limits(rwb);
 	rwb->unknown_cnt = 0;
 	rwb_trace_step(rwb, "scale down");


