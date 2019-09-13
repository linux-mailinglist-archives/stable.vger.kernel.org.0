Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58487B1EA9
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbfIMNLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388096AbfIMNLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:45 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D9E9206A5;
        Fri, 13 Sep 2019 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380304;
        bh=qNegLU6VAxAHvB9mhnXYnBDijda1BoSAMoijVjC2JYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRKdhIs25uFSjd6AgzCQwq4pRp2fcEXrAdMcrOj3nPpO8MuxfVnymgpOiuk7JF5jG
         m8IYKkHk3vzumClIKKjB8mWiBHXYnkQy5BN9/Ye1OGXvxOm23MbgOwXvSuV9oRWfst
         bxqPoxfvHRVmEYdadyHhiH+eTLSLoJx3pMrtKbeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liangyan <liangyan.peng@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ben Segall <bsegall@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        shanpeic@linux.alibaba.com, xlpang@linux.alibaba.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 006/190] sched/fair: Dont assign runtime for throttled cfs_rq
Date:   Fri, 13 Sep 2019 14:04:21 +0100
Message-Id: <20190913130600.156724704@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liangyan <liangyan.peng@linux.alibaba.com>

commit 5e2d2cc2588bd3307ce3937acbc2ed03c830a861 upstream.

do_sched_cfs_period_timer() will refill cfs_b runtime and call
distribute_cfs_runtime to unthrottle cfs_rq, sometimes cfs_b->runtime
will allocate all quota to one cfs_rq incorrectly, then other cfs_rqs
attached to this cfs_b can't get runtime and will be throttled.

We find that one throttled cfs_rq has non-negative
cfs_rq->runtime_remaining and cause an unexpetced cast from s64 to u64
in snippet:

  distribute_cfs_runtime() {
    runtime = -cfs_rq->runtime_remaining + 1;
  }

The runtime here will change to a large number and consume all
cfs_b->runtime in this cfs_b period.

According to Ben Segall, the throttled cfs_rq can have
account_cfs_rq_runtime called on it because it is throttled before
idle_balance, and the idle_balance calls update_rq_clock to add time
that is accounted to the task.

This commit prevents cfs_rq to be assgined new runtime if it has been
throttled until that distribute_cfs_runtime is called.

Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: shanpeic@linux.alibaba.com
Cc: stable@vger.kernel.org
Cc: xlpang@linux.alibaba.com
Fixes: d3d9dc330236 ("sched: Throttle entities exceeding their allowed bandwidth")
Link: https://lkml.kernel.org/r/20190826121633.6538-1-liangyan.peng@linux.alibaba.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4420,6 +4420,8 @@ static void __account_cfs_rq_runtime(str
 	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
 
+	if (cfs_rq->throttled)
+		return;
 	/*
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
@@ -4615,6 +4617,9 @@ static u64 distribute_cfs_runtime(struct
 		if (!cfs_rq_throttled(cfs_rq))
 			goto next;
 
+		/* By the above check, this should never be true */
+		SCHED_WARN_ON(cfs_rq->runtime_remaining > 0);
+
 		runtime = -cfs_rq->runtime_remaining + 1;
 		if (runtime > remaining)
 			runtime = remaining;


