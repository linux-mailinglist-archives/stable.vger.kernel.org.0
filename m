Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D263E115A8C
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLGBLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:11:09 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:35992 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:11:08 -0500
Received: by mail-ua1-f73.google.com with SMTP id w25so2786179uaa.3
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jPYB13Mo0gREDnBISRJFYRPUDs1XnOmlDuxNXnjXIHk=;
        b=MWimuHK0UG21uUgkh1BOfhoOmqmtH/14WrZjgxgjm7vq1tUeZ1zLBIol4B0r9Zkvh2
         OrN7YteDP0yk3gWEwvlhcp89MvAdxmI7h1QReuXSz+nvw8Tf8J2gcXNxhdJwIKPbGWZs
         WNlFdaqk/yWiyGZXbIuJbyx/fNrPauEPaJ9ElIwn3gN5IXlWZa34CsIfOezdZR44vY18
         bI6ON/1sH7Mwpom7KXGeSrqhIM7apGusR+sMpcueS2eQHF1vabRDlUy9miLeMPMWT/qZ
         24gt8ff3xpzfReEh3xzWv2SNn7OuDlBIl4P9e5RDkQgK8FvTGlVUZmb++vYJNQ7Z6P7s
         V62w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jPYB13Mo0gREDnBISRJFYRPUDs1XnOmlDuxNXnjXIHk=;
        b=dtnGcEYadkfGm0QH1bjJewVR4wfY4qG0WME7mVX91nVjDltQUD1sExen07qwBtYJJ6
         stRg9eNX3ICho3M9urWZ07wIYVivxpOwISrkUtZF6za0qFSYEw8D92rEJ9e3m3XfTT7y
         xqRLG5S2mX9Eas+4/5ifa0l0DMFbdSGVUIyiIqQl4GuLXGxydfR/XhyYKWjW3apCYdRw
         EqDNWTJ0eELx4WNObfB5t5lVlsRosds1bm3yMMP/y9P7gxEdlHg3UUQfsb26JSRXgbCR
         GPHtGhXqw35kFeAatJA7E0iWsIfJP514eRvVEeHp3G9NQbTpbOKj5bQOw175zCZbt+po
         Pw+g==
X-Gm-Message-State: APjAAAWs9QTTA9HPKmXIsy4JW2dlS1UiMPzEWCc9tLhVqiAJ9jbJq8m/
        qVZN+M///M3auJyyvIlggYI+MxlcAIKX
X-Google-Smtp-Source: APXvYqzpiZ+4uxnTPC7Q/RqfzM9Pcf6iguuC/M+loo34pZdIjfcsLPMEhEZuIIlGE2dhPoRjaxGpe46nOxoY
X-Received: by 2002:a67:f318:: with SMTP id p24mr12003371vsf.240.1575681067590;
 Fri, 06 Dec 2019 17:11:07 -0800 (PST)
Date:   Fri,  6 Dec 2019 17:11:02 -0800
Message-Id: <20191207011102.120954-1-xueweiz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v4.4] sched/fair: Scale bandwidth quota and period without
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
index d012681fb1ab..b42d2b8b283e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4055,20 +4055,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
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

