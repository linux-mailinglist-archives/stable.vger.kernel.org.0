Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFBC88DA6
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfHJUr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55014 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726835AbfHJUoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053h-Ec; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003fZ-Br; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ben Segall" <bsegall@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Phil Auld" <pauld@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Anton Blanchard" <anton@ozlabs.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.586954811@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 093/157] sched/fair: Limit sched_cfs_period_timer()
 loop to avoid hard lockup
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Auld <pauld@redhat.com>

commit 2e8e19226398db8265a8e675fcc0118b9e80c9e8 upstream.

With extremely short cfs_period_us setting on a parent task group with a large
number of children the for loop in sched_cfs_period_timer() can run until the
watchdog fires. There is no guarantee that the call to hrtimer_forward_now()
will ever return 0.  The large number of children can make
do_sched_cfs_period_timer() take longer than the period.

 NMI watchdog: Watchdog detected hard LOCKUP on cpu 24
 RIP: 0010:tg_nop+0x0/0x10
  <IRQ>
  walk_tg_tree_from+0x29/0xb0
  unthrottle_cfs_rq+0xe0/0x1a0
  distribute_cfs_runtime+0xd3/0xf0
  sched_cfs_period_timer+0xcb/0x160
  ? sched_cfs_slack_timer+0xd0/0xd0
  __hrtimer_run_queues+0xfb/0x270
  hrtimer_interrupt+0x122/0x270
  smp_apic_timer_interrupt+0x6a/0x140
  apic_timer_interrupt+0xf/0x20
  </IRQ>

To prevent this we add protection to the loop that detects when the loop has run
too many times and scales the period and quota up, proportionally, so that the timer
can complete before then next period expires.  This preserves the relative runtime
quota while preventing the hard lockup.

A warning is issued reporting this state and the new values.

Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190319130005.25492-1-pauld@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched/fair.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3704,6 +3704,8 @@ static enum hrtimer_restart sched_cfs_sl
 	return HRTIMER_NORESTART;
 }
 
+extern const u64 max_cfs_quota_period;
+
 static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 {
 	struct cfs_bandwidth *cfs_b =
@@ -3711,6 +3713,7 @@ static enum hrtimer_restart sched_cfs_pe
 	ktime_t now;
 	int overrun;
 	int idle = 0;
+	int count = 0;
 
 	raw_spin_lock(&cfs_b->lock);
 	for (;;) {
@@ -3720,6 +3723,28 @@ static enum hrtimer_restart sched_cfs_pe
 		if (!overrun)
 			break;
 
+		if (++count > 3) {
+			u64 new, old = ktime_to_ns(cfs_b->period);
+
+			new = (old * 147) / 128; /* ~115% */
+			new = min(new, max_cfs_quota_period);
+
+			cfs_b->period = ns_to_ktime(new);
+
+			/* since max is 1s, this is limited to 1e9^2, which fits in u64 */
+			cfs_b->quota *= new;
+			cfs_b->quota = div64_u64(cfs_b->quota, old);
+
+			pr_warn_ratelimited(
+	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
+				smp_processor_id(),
+				div_u64(new, NSEC_PER_USEC),
+				div_u64(cfs_b->quota, NSEC_PER_USEC));
+
+			/* reset count so we don't come right back in here */
+			count = 0;
+		}
+
 		idle = do_sched_cfs_period_timer(cfs_b, overrun);
 	}
 	raw_spin_unlock(&cfs_b->lock);

