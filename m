Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728E373D36
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404237AbfGXTxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404235AbfGXTxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34FC21873;
        Wed, 24 Jul 2019 19:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998027;
        bh=PIUMvb4ax90PFEGEcAmN40RkIwRRJlVUfB6jjsfZoHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxZFLFaEmlTEKmPNCSceLDH7MrwGfvpyY6K71xIVIcYv8Iff2AR/8boeCc3JYgvQZ
         +xpC9gYc7q6EJNtKSXogLKv88BAVh1xkQQufza9AQRsPDUcIvKjxacaxDUTTSO2hZA
         nwbG+dxbmLUZ3hJuT+H9ZIvdCmRuDG74wJbhrGLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.1 222/371] blk-iolatency: fix STS_AGAIN handling
Date:   Wed, 24 Jul 2019 21:19:34 +0200
Message-Id: <20190724191741.242726215@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 58bac44ba78a..072e1edcf83d 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -599,10 +599,6 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
 		return;
 
-	/* We didn't actually submit this bio, don't account it. */
-	if (bio->bi_status == BLK_STS_AGAIN)
-		return;
-
 	iolat = blkg_to_lat(bio->bi_blkg);
 	if (!iolat)
 		return;
@@ -621,40 +617,22 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 
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
@@ -670,7 +648,6 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 
 static struct rq_qos_ops blkcg_iolatency_ops = {
 	.throttle = blkcg_iolatency_throttle,
-	.cleanup = blkcg_iolatency_cleanup,
 	.done_bio = blkcg_iolatency_done_bio,
 	.exit = blkcg_iolatency_exit,
 };
-- 
2.20.1



