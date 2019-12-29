Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDCA12C8D9
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfL2R57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732946AbfL2R56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9406D206DB;
        Sun, 29 Dec 2019 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642278;
        bh=EjjsqRq6XbMrEY0Znl/H+gw/v814XcT3VjQoYyQJzvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rStlHVHmpQg0VNXM3EKfHZe8jMrISU81HxLRCEGg6vMGY8M7qcf73FfSDB63Wfuvq
         Mz3TeMVPr7A3fqu9lc0RC26kz/DhtdJsAtCuQ5fmDLNRtGgz4k9VmmxtP0wuJt/iK2
         OnxapwLqEqhy6WtA6opqC8NfGvUhk9Z0lD44PRVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 414/434] iocost: over-budget forced IOs should schedule async delay
Date:   Sun, 29 Dec 2019 18:27:47 +0100
Message-Id: <20191229172730.302581073@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit d7bd15a138aef3be227818aad9c501e43c89c8c5 upstream.

When over-budget IOs are force-issued through root cgroup,
iocg_kick_delay() adjusts the async delay accordingly but doesn't
actually schedule async throttle for the issuing task.  This bug is
pretty well masked because sooner or later the offending threads are
gonna get directly throttled on regular IOs or have async delay
scheduled by mem_cgroup_throttle_swaprate().

However, it can affect control quality on filesystem metadata heavy
operations.  Let's fix it by invoking blkcg_schedule_throttle() when
iocg_kick_delay() says async delay is needed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iocost.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1212,7 +1212,7 @@ static enum hrtimer_restart iocg_waitq_t
 	return HRTIMER_NORESTART;
 }
 
-static void iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
+static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
 {
 	struct ioc *ioc = iocg->ioc;
 	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
@@ -1229,11 +1229,11 @@ static void iocg_kick_delay(struct ioc_g
 	/* clear or maintain depending on the overage */
 	if (time_before_eq64(vtime, now->vnow)) {
 		blkcg_clear_delay(blkg);
-		return;
+		return false;
 	}
 	if (!atomic_read(&blkg->use_delay) &&
 	    time_before_eq64(vtime, now->vnow + vmargin))
-		return;
+		return false;
 
 	/* use delay */
 	if (cost) {
@@ -1250,10 +1250,11 @@ static void iocg_kick_delay(struct ioc_g
 	oexpires = ktime_to_ns(hrtimer_get_softexpires(&iocg->delay_timer));
 	if (hrtimer_is_queued(&iocg->delay_timer) &&
 	    abs(oexpires - expires) <= margin_ns / 4)
-		return;
+		return true;
 
 	hrtimer_start_range_ns(&iocg->delay_timer, ns_to_ktime(expires),
 			       margin_ns / 4, HRTIMER_MODE_ABS);
+	return true;
 }
 
 static enum hrtimer_restart iocg_delay_timer_fn(struct hrtimer *timer)
@@ -1739,7 +1740,9 @@ static void ioc_rqos_throttle(struct rq_
 	 */
 	if (bio_issue_as_root_blkg(bio) || fatal_signal_pending(current)) {
 		atomic64_add(abs_cost, &iocg->abs_vdebt);
-		iocg_kick_delay(iocg, &now, cost);
+		if (iocg_kick_delay(iocg, &now, cost))
+			blkcg_schedule_throttle(rqos->q,
+					(bio->bi_opf & REQ_SWAP) == REQ_SWAP);
 		return;
 	}
 


