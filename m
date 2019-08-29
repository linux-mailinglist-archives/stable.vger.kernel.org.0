Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908CEA16A5
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfH2KuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfH2KuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E292341C;
        Thu, 29 Aug 2019 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075817;
        bh=Yadv00o9CZAXZqMGbo+z3JawRiSXYtJaQUmJg+FypKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEdv1O7KUXz1U+1y2SKyP/zm4qCYqxBznD2M8CZDJ1cYl6pgGB7KjAZlcyBpDMe2q
         vFljd1W/yJ8RuGMBV5X7sQpoJ7y2RQ/J07wuVzm3uNREKlVnHLq/sr6Yw+Y2W7HfI4
         8+Wz7jBBs0ZDX4bF9d7+M9fcO9d5Fr3Dd36c87P8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/29] blk-iolatency: fix STS_AGAIN handling
Date:   Thu, 29 Aug 2019 06:49:46 -0400
Message-Id: <20190829105009.2265-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Zhou <dennis@kernel.org>

[ Upstream commit c9b3007feca018d3f7061f5d5a14cb00766ffe9b ]

The iolatency controller is based on rq_qos. It increments on
rq_qos_throttle() and decrements on either rq_qos_cleanup() or
rq_qos_done_bio(). a3fb01ba5af0 fixes the double accounting issue where
blk_mq_make_request() may call both rq_qos_cleanup() and
rq_qos_done_bio() on REQ_NO_WAIT. So checking STS_AGAIN prevents the
double decrement.

The above works upstream as the only way we can get STS_AGAIN is from
blk_mq_get_request() failing. The STS_AGAIN handling isn't a real
problem as bio_endio() skipping only happens on reserved tag allocation
failures which can only be caused by driver bugs and already triggers
WARN.

However, the fix creates a not so great dependency on how STS_AGAIN can
be propagated. Internally, we (Facebook) carry a patch that kills read
ahead if a cgroup is io congested or a fatal signal is pending. This
combined with chained bios progagate their bi_status to the parent is
not already set can can cause the parent bio to not clean up properly
even though it was successful. This consequently leaks the inflight
counter and can hang all IOs under that blkg.

To nip the adverse interaction early, this removes the rq_qos_cleanup()
callback in iolatency in favor of cleaning up always on the
rq_qos_done_bio() path.

Fixes: a3fb01ba5af0 ("blk-iolatency: only account submitted bios")
Debugged-by: Tejun Heo <tj@kernel.org>
Debugged-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 51 ++++++++++++-------------------------------
 1 file changed, 14 insertions(+), 37 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 84ecdab41b691..0529e94a20f7f 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -566,10 +566,6 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	if (!blkg)
 		return;
 
-	/* We didn't actually submit this bio, don't account it. */
-	if (bio->bi_status == BLK_STS_AGAIN)
-		return;
-
 	iolat = blkg_to_lat(bio->bi_blkg);
 	if (!iolat)
 		return;
@@ -588,40 +584,22 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 
 		inflight = atomic_dec_return(&rqw->inflight);
 		WARN_ON_ONCE(inflight < 0);
-		if (iolat->min_lat_nsec == 0)
-			goto next;
-		iolatency_record_time(iolat, &bio->bi_issue, now,
-				      issue_as_root);
-		window_start = atomic64_read(&iolat->window_start);
-		if (now > window_start &&
-		    (now - window_start) >= iolat->cur_win_nsec) {
-			if (atomic64_cmpxchg(&iolat->window_start,
-					window_start, now) == window_start)
-				iolatency_check_latencies(iolat, now);
+		/*
+		 * If bi_status is BLK_STS_AGAIN, the bio wasn't actually
+		 * submitted, so do not account for it.
+		 */
+		if (iolat->min_lat_nsec && bio->bi_status != BLK_STS_AGAIN) {
+			iolatency_record_time(iolat, &bio->bi_issue, now,
+					      issue_as_root);
+			window_start = atomic64_read(&iolat->window_start);
+			if (now > window_start &&
+			    (now - window_start) >= iolat->cur_win_nsec) {
+				if (atomic64_cmpxchg(&iolat->window_start,
+					     window_start, now) == window_start)
+					iolatency_check_latencies(iolat, now);
+			}
 		}
-next:
-		wake_up(&rqw->wait);
-		blkg = blkg->parent;
-	}
-}
-
-static void blkcg_iolatency_cleanup(struct rq_qos *rqos, struct bio *bio)
-{
-	struct blkcg_gq *blkg;
-
-	blkg = bio->bi_blkg;
-	while (blkg && blkg->parent) {
-		struct rq_wait *rqw;
-		struct iolatency_grp *iolat;
-
-		iolat = blkg_to_lat(blkg);
-		if (!iolat)
-			goto next;
-
-		rqw = &iolat->rq_wait;
-		atomic_dec(&rqw->inflight);
 		wake_up(&rqw->wait);
-next:
 		blkg = blkg->parent;
 	}
 }
@@ -637,7 +615,6 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 
 static struct rq_qos_ops blkcg_iolatency_ops = {
 	.throttle = blkcg_iolatency_throttle,
-	.cleanup = blkcg_iolatency_cleanup,
 	.done_bio = blkcg_iolatency_done_bio,
 	.exit = blkcg_iolatency_exit,
 };
-- 
2.20.1

