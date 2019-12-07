Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DDE115A8A
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfLGBKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:10:30 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:47258 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:10:30 -0500
Received: by mail-pg1-f202.google.com with SMTP id c10so4745669pgm.14
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fxNXKwP1G/Y527WH1IfO09a47RRj96LExIooWB62IMk=;
        b=ew+UWwfyM4GKcPEiu01b6WIqW8WiU6D4KWQpajz2eM9SX88yIzcUDGIr+3t4FhD+d8
         jFGGHWmTXCsJgri4rC4EXmgKyRs+odJRmPN32DUXTujTVmIdFmwk3WrHYpDzr56Fe+FB
         7YIoI/PMCIYpJT4gL+/FBKCJfFnI/oM/TaFNWU/O8y4hEeHIs4G3ODQTd4WBjCrn6i1+
         gt0Vro6enDzaPFPR9nRtmIq4AzHsRQoNmFZOp8KJH/XV+/zte5OgTieOh35UPKYxvl+f
         VfDWcA4yhPrYcoP0gUSsdpEiVzABqeVS5Yktzd0MnsACbWzsPtgAaCguHMvFMvoh7RO6
         FyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fxNXKwP1G/Y527WH1IfO09a47RRj96LExIooWB62IMk=;
        b=JqvBvmlqWhxcVVZvIL61/7Q37uc6NlaerBXOfD0kqztsOWwSi8bsEzatm0HGMbyMDT
         hE9aO+49Jgceh4zUQVwKOU5pAiTI0XBi+gFJRhKShxhE8GZInUHK/UiazGbPXighZ3tC
         p8gM6KQN4bzDFR4juNRyIuoKDL2TcGG9LBYZB4wOZi5COrrBTPypDNDUEEkI3DcBNIi/
         8XAwhwJ5UZJJy7JWg24AR9NkgywlUuxAEEX4ukpf0G0h+BmeFNwCwSEEZCfsa6GoKWhR
         4AqwSyfhYfb+taAjn72CBd3/lpvTk0uJawA+WMhRzdpKAe/WeWkdviKeQ6n5g4lMin/m
         GysA==
X-Gm-Message-State: APjAAAWdEX8J43AV5JKrhSUlkZF7QQYVDri4IHZ/M4r5tsLTMUJsNwKE
        foH03EYj6dog/eyjyzI1ocSfjp8ad3YV
X-Google-Smtp-Source: APXvYqwqwltZ4iiOYVvWnnVJlDYUsM+LTQRR9DZbIj3aBPrNnaoR808bkqI9cbrZ83lowV0B+p6ZsBS9OeMl
X-Received: by 2002:a63:cf4f:: with SMTP id b15mr6757602pgj.216.1575681028790;
 Fri, 06 Dec 2019 17:10:28 -0800 (PST)
Date:   Fri,  6 Dec 2019 17:10:25 -0800
Message-Id: <20191207011025.119151-1-xueweiz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v4.9] sched/fair: Scale bandwidth quota and period without
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
index b765a58cf20f..5e65c7eea872 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4391,20 +4391,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
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

