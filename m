Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B434CB2AB
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 02:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbfJDAMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 20:12:49 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45059 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732327AbfJDAMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 20:12:49 -0400
Received: by mail-pg1-f201.google.com with SMTP id x31so3082468pgl.12
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 17:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ICbLP1MuSAXizuW0BgmIirtLum0JXKK9vWjz+u8oZdo=;
        b=qHzGwag5o9+V8imsCxLgTM+yncKYR7E5E0Q2yDvm4QruHteu1CLMS14NHJEUbwp3NB
         7nXk34dPQiH7LirbOzy3sxC8CIRr6SZjKmDjqfBiA1D1HR4D7wMbin9PQsdLSQoP8wDp
         Zswy3leTvQv7qj74/NaYED5B5yqO5kE60hz1wdehXUJUHSTEmoIUuL+qnd7/Tu0LX8OK
         75jXavIAbQSROfC7n/Y1EVjwPWSgCQRwIfBPGrAhkg/zkr7hAzfPTPsxm0OMkHreU6qA
         kliuz4jpsth1+gCh7Zt9Q2IkU/ROOANzumit5ge6nlRERr4XXJ4xj/BbB4twS65VX13c
         GIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ICbLP1MuSAXizuW0BgmIirtLum0JXKK9vWjz+u8oZdo=;
        b=LxbiiUC8TYqupFBh/j9R4H/jw0wMxq/FPsNVd0mm83NF458rgcmKk8MKzQSGPi4fO+
         V4Bs5ePsgEosyUK1XpR20OCNTfU62qSNrMnLtqUt4psNFcLYHAJrjQOZXpVcimMza6HU
         D4WMQhC3fGJgi9fHH1CZmAESVJ4GGZSasTe+/XLxm1NxkxN4EZC9QCeRiQK3lYHPPLlt
         CNIfZF4nWO7Ox8RN+5O96CwbvA0t5fdnJC4AEPbD0yrFcdooVCHIrk0peDrM9bT65Dzp
         ZNghmVf35MNvYkS56sHm7T4JDZ9djhiIY3TFe/82MbKpO35bdTmh+rmmNTvjVjTPn9fU
         aKew==
X-Gm-Message-State: APjAAAWTPFEYnTYyEH4ropZ2e+VbXkd2vgxlnqoNeG+SbOPJOSEJjMdC
        FeJgoa6JNa2SK7AaSUH9Ytw8nqGs8934
X-Google-Smtp-Source: APXvYqxkbSI4OdH0HCiZGSHO70WvfkHJQsScIdXdfQYVec6YvlFgoRPmXOupJhaUo4uWiyhQe6Yd381CTDBd
X-Received: by 2002:a65:528a:: with SMTP id y10mr12572307pgp.70.1570147968231;
 Thu, 03 Oct 2019 17:12:48 -0700 (PDT)
Date:   Thu,  3 Oct 2019 17:12:43 -0700
Message-Id: <20191004001243.140897-1-xueweiz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH] sched/fair: scale quota and period without losing
 quota/period ratio precision
From:   Xuewei Zhang <xueweiz@google.com>
To:     Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>
Cc:     Anton Blanchard <anton@ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org, Xuewei Zhang <xueweiz@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

quota/period ratio is used to ensure a child task group won't get more
bandwidth than the parent task group, and is calculated as:
normalized_cfs_quota() = [(quota_us << 20) / period_us]

If the quota/period ratio was changed during this scaling due to
precision loss, it will cause inconsistency between parent and child
task groups. See below example:
A userspace container manager (kubelet) does three operations:
1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
2) Create a few children cgroups.
3) Set quota to 1,000us and period to 10,000us on a child cgroup.

These operations are expected to succeed. However, if the scaling of
147/128 happens before step 3), quota and period of the parent cgroup
will be changed:
new_quota: 1148437ns, 1148us
new_period: 11484375ns, 11484us

And when step 3) comes in, the ratio of the child cgroup will be 104857,
which will be larger than the parent cgroup ratio (104821), and will
fail.

Scaling them by a factor of 2 will fix the problem.

Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
Signed-off-by: Xuewei Zhang <xueweiz@google.com>
---
 kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 83ab35e2374f..b3d3d0a231cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4926,20 +4926,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 		if (++count > 3) {
 			u64 new, old = ktime_to_ns(cfs_b->period);
 
-			new = (old * 147) / 128; /* ~115% */
-			new = min(new, max_cfs_quota_period);
-
-			cfs_b->period = ns_to_ktime(new);
-
-			/* since max is 1s, this is limited to 1e9^2, which fits in u64 */
-			cfs_b->quota *= new;
-			cfs_b->quota = div64_u64(cfs_b->quota, old);
-
-			pr_warn_ratelimited(
-	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
-				smp_processor_id(),
-				div_u64(new, NSEC_PER_USEC),
-				div_u64(cfs_b->quota, NSEC_PER_USEC));
+			/*
+			 * Grow period by a factor of 2 to avoid lossing precision.
+			 * Precision loss in the quota/period ratio can cause __cfs_schedulable
+			 * to fail.
+			 */
+			new = old * 2;
+			if (new < max_cfs_quota_period) {
+				cfs_b->period = ns_to_ktime(new);
+				cfs_b->quota *= 2;
+
+				pr_warn_ratelimited(
+	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
+					smp_processor_id(),
+					div_u64(new, NSEC_PER_USEC),
+					div_u64(cfs_b->quota, NSEC_PER_USEC));
+			} else {
+				pr_warn_ratelimited(
+	"cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
+					smp_processor_id(),
+					div_u64(old, NSEC_PER_USEC),
+					div_u64(cfs_b->quota, NSEC_PER_USEC));
+			}
 
 			/* reset count so we don't come right back in here */
 			count = 0;
-- 
2.23.0.581.g78d2f28ef7-goog

