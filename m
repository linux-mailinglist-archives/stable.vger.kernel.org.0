Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A774C115A88
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfLGBJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:09:47 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37298 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:09:46 -0500
Received: by mail-pg1-f201.google.com with SMTP id r2so4760597pgl.4
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YnG3tpxp2cwYyQixLFYpqtlmCzxHLmy7ievqe2KXWQ8=;
        b=XYXEztdonK4YvL5z8lUcuR1/1NTYZJ9OXbZM76kTtdTK6/DMEhsM4EwPoVgKJDtqLi
         tPtN64Rie0Ag/HwjhCL4BGZrqzJR6nvyNEmwvQTDWxsh/kuyWqNMW1TT2u7ncKRjxrku
         /fXvqihsJxYJyc0EmexS7wImhyOp0vEBo5KyqE8mte5wQAIVfYduOuLm0kKXcul6eoZy
         wnvIcGqFbnKmv8jkEQ42TUsKDF8qS4VvvoiAuxIs1IE+mXvXYBQ9emRrNGg73dP+4lLa
         Nte7t1g1hyeRxPtAbIfyc2hFH+wOCLV28MXQMgaoUyff2uhEjFuLGNOHriRw8UbaWkSu
         JEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YnG3tpxp2cwYyQixLFYpqtlmCzxHLmy7ievqe2KXWQ8=;
        b=b6H4n5/HVKF4gP7QUP0fc6rr0LxPDfZkmKYJ6bVlOltbqSoONPh8a4NTsS3GdKz4Lp
         Cgq1LS2HX827u5UYrnZ0AM7cbj8S1DABWp1U2dsy4CmFCDBoxtVVju301iib6SGHQ1RC
         CCLIS6qhX0EVjjv70yD6R8H8Nwq6dovQPDxAj4VH1s9Pg/hoQsaSlymQ9DjOn61uWJ5o
         PS+JgsB29ZSp3FhDrFRxwHEg5J19OEeBALGNs+bQ56u3gfqmIuG+mCMiWrur4q+Qk74y
         huUgTV4Jy2sBgVJQQEocydVZwdY1j1UMJuG5iETGlNZkGv8Qs8FvoPU6AV83k3Mqbyqg
         U/lw==
X-Gm-Message-State: APjAAAVZqvgS84ccswI3ArZgi+dM4OQqqkrgCudSU8+MOxYF1aSqCtw0
        tCxvI3L1/IG+/J5hw7ZublsGJO30waiu
X-Google-Smtp-Source: APXvYqyH2hvaUapv9+dmadFWPJrJjNU8F9zXhn0OIxSDw4sErJi9lnzSV/sywKn2xCXigvyib/fkq22htqzT
X-Received: by 2002:a63:1a1c:: with SMTP id a28mr3259097pga.374.1575680986142;
 Fri, 06 Dec 2019 17:09:46 -0800 (PST)
Date:   Fri,  6 Dec 2019 17:09:43 -0800
Message-Id: <20191207010943.117404-1-xueweiz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v4.14] sched/fair: Scale bandwidth quota and period without
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

commit 4929a4e6faa0f13289a67cae98139e727f0d4a97 upstream.

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
index 67433fbdcb5a..0b4e997fea1a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4655,20 +4655,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
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

