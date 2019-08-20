Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126A195CAB
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 12:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfHTKyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 06:54:54 -0400
Received: from foss.arm.com ([217.140.110.172]:38598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbfHTKyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 06:54:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C08F344;
        Tue, 20 Aug 2019 03:54:53 -0700 (PDT)
Received: from e113632-lin.cambridge.arm.com (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E647E3F706;
        Tue, 20 Aug 2019 03:54:51 -0700 (PDT)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     mingo@kernel.org, peterz@infradead.org,
        liangyan.peng@linux.alibaba.com, shanpeic@linux.alibaba.com,
        xlpang@linux.alibaba.com, pjt@google.com, stable@vger.kernel.org
Subject: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
Date:   Tue, 20 Aug 2019 11:54:20 +0100
Message-Id: <20190820105420.7547-1-valentin.schneider@arm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Turns out a cfs_rq->runtime_remaining can become positive in
assign_cfs_rq_runtime(), but this codepath has no call to
unthrottle_cfs_rq().

This can leave us in a situation where we have a throttled cfs_rq with
positive ->runtime_remaining, which breaks the math in
distribute_cfs_runtime(): this function expects a negative value so that
it may safely negate it into a positive value.

Add the missing unthrottle_cfs_rq(). While at it, add a WARN_ON where
we expect negative values, and pull in a comment from the mailing list
that didn't make it in [1].

[1]: https://lkml.kernel.org/r/BANLkTi=NmCxKX6EbDQcJYDJ5kKyG2N1ssw@mail.gmail.com

Cc: <stable@vger.kernel.org>
Fixes: ec12cb7f31e2 ("sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth")
Reported-by: Liangyan <liangyan.peng@linux.alibaba.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
 kernel/sched/fair.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1054d2cf6aaa..219ff3f328e5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4385,6 +4385,11 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_bandwidth_used() && cfs_rq->throttled;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -4411,6 +4416,9 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 	cfs_rq->runtime_remaining += amount;
 
+	if (cfs_rq->runtime_remaining > 0 && cfs_rq_throttled(cfs_rq))
+		unthrottle_cfs_rq(cfs_rq);
+
 	return cfs_rq->runtime_remaining > 0;
 }
 
@@ -4439,11 +4447,6 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
-static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
-{
-	return cfs_bandwidth_used() && cfs_rq->throttled;
-}
-
 /* check whether cfs_rq, or any parent, is throttled */
 static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 {
@@ -4628,6 +4631,10 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b, u64 remaining)
 		if (!cfs_rq_throttled(cfs_rq))
 			goto next;
 
+		/* By the above check, this should never be true */
+		WARN_ON(cfs_rq->runtime_remaining > 0);
+
+		/* Pick the minimum amount to return to a positive quota state */
 		runtime = -cfs_rq->runtime_remaining + 1;
 		if (runtime > remaining)
 			runtime = remaining;
-- 
2.22.0

