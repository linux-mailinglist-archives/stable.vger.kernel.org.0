Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F38115A7B
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfLGBEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:04:48 -0500
Received: from mail-qt1-f202.google.com ([209.85.160.202]:37769 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLGBEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:04:48 -0500
Received: by mail-qt1-f202.google.com with SMTP id r9so6344273qtc.4
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=skfmScCMK2kF6E3qFnVo7/Ro3KPrY6qZvU+0RkpwTJg=;
        b=ZCZNvAXnMZZGjP+XJUOGoE7NaB76dhw13djbz6CjzqO+wjkLYcIid2KObJNceOf9xu
         BBC5jYmGC/UNfrWrFCOTOYVX1m8iNl8EtufHdBv2+Dh2l298d9PR/GSyDKVtvuxC3485
         bteLZAgg2G4Ao9QaVQmsD4Mktsxg428ULI1ULzfdIk8q2xOTgj/hTZSZvyVljMSKG1/z
         5akcQw/Nfwbo+ZPWmTGHkl1/c/zqbAOrzzT2l+lJwsEtnyg1PlrbFhIkaeiNhP27ZgAX
         6KeXr5g0gkTJFpLrjbPf7mvcUU4x+oeU89Ocfj6LSiOmkqCvj3YZxVktb3ZOFjP8Wljb
         QuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=skfmScCMK2kF6E3qFnVo7/Ro3KPrY6qZvU+0RkpwTJg=;
        b=J0PzxSFPr6YU4+7AGhfIHr3SCTM5wB9aiqDhTTAjTdkaLPGcgmNMYtnvA9bdkNNIa8
         BHSD1FBzX7/qCCbPY6Tm6XoXzaaiC2ogKZfI+eabFoonsN9zfYDYVM2vcb3MOCByEZWx
         huyGP4ymD3/WUKSXHVWTCdGEoEqCwBSjcGOj70VDHaLeaVCqhgckaLez3NkkCmS2DAVq
         Xw/Na1YESy4ER1RBAmJGx3iIbex/k0MccC2Gh+MNgkjEyIwGIYzWzdcmHnQc/mJtEy5M
         3JlbUyfkl2oLENFEQ6NBV82sVAYQIWXGZGZbn3ca4CgY8U5DbFKqZ40gMXYRrifJKHcf
         CA1g==
X-Gm-Message-State: APjAAAWhfsZFkkdwg2l9P+4rRfTV8/036KKL9N1an3fP/XT0hERCPhTk
        frHzciC+TW8N0nFRtZMQpWRsllEaxBA9
X-Google-Smtp-Source: APXvYqwBDs7YAJUutvwFGmce0IhDHY352QJ6FMrI+MjkJ8vQYNfHha3cVnPBc+R0e76wN8P7VP5z58eRsaVG
X-Received: by 2002:a37:5d0:: with SMTP id 199mr16493992qkf.131.1575680687354;
 Fri, 06 Dec 2019 17:04:47 -0800 (PST)
Date:   Fri,  6 Dec 2019 17:04:43 -0800
Message-Id: <20191207010443.111374-1-xueweiz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v4.19] sched/fair: Scale bandwidth quota and period without
 losing quota/period ratio precision
From:   Xuewei Zhang <xueweiz@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Xuewei Zhang <xueweiz@google.com>,
        Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The quota/period ratio is used to ensure a child task group won't get
more bandwidth than the parent task group, and is calculated as:

  normalized_cfs_quota() = [(quota_us << 20) / period_us]

If the quota/period ratio was changed during this scaling due to
precision loss, it will cause inconsistency between parent and child
task groups.

See below example:

A userspace container manager (kubelet) does three operations:

 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
 2) Create a few children cgroups.
 3) Set quota to 1,000us and period to 10,000us on a child cgroup.

These operations are expected to succeed. However, if the scaling of
147/128 happens before step 3, quota and period of the parent cgroup
will be changed:

  new_quota: 1148437ns,   1148us
 new_period: 11484375ns, 11484us

And when step 3 comes in, the ratio of the child cgroup will be
104857, which will be larger than the parent cgroup ratio (104821),
and will fail.

Scaling them by a factor of 2 will fix the problem.

Tested-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Xuewei Zhang <xueweiz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Phil Auld <pauld@redhat.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
Link: https://lkml.kernel.org/r/20191004001243.140897-1-xueweiz@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f77fcd37b226..f0abb8fe0ae9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4868,20 +4868,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
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
-        "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
-	                        smp_processor_id(),
-	                        div_u64(new, NSEC_PER_USEC),
-                                div_u64(cfs_b->quota, NSEC_PER_USEC));
+			/*
+			 * Grow period by a factor of 2 to avoid losing precision.
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
2.24.0.393.g34dc348eaf-goog

