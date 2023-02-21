Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8673169E18E
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 14:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjBUNnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 08:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjBUNnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 08:43:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E6B76C
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 05:43:39 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676987017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgpNZ5j34PTZ8/6T97NnmYN4VfqQvCs2xmXHijGDjrI=;
        b=YSz/tbS5OhIsCiwJrFN3dbYOkluazCWH2cyDGBPC2fe3bM6zh+V//4sWeOcvJWWPyqUYXQ
        sx054y5Q57JOO0mBHM1HBCbyyPjz9W+OJEQpZBYzb07UREUhgi/Y0oXk/3c1M3JWZq6B27
        9NUdXQeSYieUTT8szrbM8rImnXyN6yQb0iFEqwYTsnXjYWUePeqA8ikWAk50YJozBa8sAs
        l9hXROx9Z0mby6vco2G/Me5QuqXk5Y/HZrOfxnLOxubTZT4ztFks32ZhYsHpntnOFnhuma
        nri1HQtMP/YKiSG32LdIIqsABGLUw5PeYzTR1eb+qlB+cS57k1UAX+tj4l9Dug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676987017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgpNZ5j34PTZ8/6T97NnmYN4VfqQvCs2xmXHijGDjrI=;
        b=wL4kGwTin1XgRNElKkHJdpbHuATntAlyIfUA9cPujg0YXXj9CLkhvdBWsNyasBkHxlcJKz
        iFdfdmE0JyL+v6BA==
To:     gregkh@linuxfoundation.org, jstultz@google.com
Cc:     stable@vger.kernel.org
Subject: [PATCH Backport 4.14, 4.19, 5.4] alarmtimer: Prevent starvation by
 small intervals and SIG_IGN
In-Reply-To: <16768916935192@kroah.com>
References: <16768916935192@kroah.com>
Date:   Tue, 21 Feb 2023 14:43:36 +0100
Message-ID: <87sfeznng7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d125d1349abeb46945dc5e98f7824bf688266f13 upstream.

syzbot reported a RCU stall which is caused by setting up an alarmtimer
with a very small interval and ignoring the signal. The reproducer arms the
alarm timer with a relative expiry of 8ns and an interval of 9ns. Not a
problem per se, but that's an issue when the signal is ignored because then
the timer is immediately rearmed because there is no way to delay that
rearming to the signal delivery path.  See posix_timer_fn() and commit
58229a189942 ("posix-timers: Prevent softirq starvation by small intervals
and SIG_IGN") for details.

The reproducer does not set SIG_IGN explicitely, but it sets up the timers
signal with SIGCONT. That has the same effect as explicitely setting
SIG_IGN for a signal as SIGCONT is ignored if there is no handler set and
the task is not ptraced.

The log clearly shows that:

   [pid  5102] --- SIGCONT {si_signo=SIGCONT, si_code=SI_TIMER, si_timerid=0, si_overrun=316014, si_int=0, si_ptr=NULL} ---

It works because the tasks are traced and therefore the signal is queued so
the tracer can see it, which delays the restart of the timer to the signal
delivery path. But then the tracer is killed:

   [pid  5087] kill(-5102, SIGKILL <unfinished ...>
   ...
   ./strace-static-x86_64: Process 5107 detached

and after it's gone the stall can be observed:

   syzkaller login: [   79.439102][    C0] hrtimer: interrupt took 68471 ns
   [  184.460538][    C1] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
   ...
   [  184.658237][    C1] rcu: Stack dump where RCU GP kthread last ran:
   [  184.664574][    C1] Sending NMI from CPU 1 to CPUs 0:
   [  184.669821][    C0] NMI backtrace for cpu 0
   [  184.669831][    C0] CPU: 0 PID: 5108 Comm: syz-executor192 Not tainted 6.2.0-rc6-next-20230203-syzkaller #0
   ...
   [  184.670036][    C0] Call Trace:
   [  184.670041][    C0]  <IRQ>
   [  184.670045][    C0]  alarmtimer_fired+0x327/0x670

posix_timer_fn() prevents that by checking whether the interval for
timers which have the signal ignored is smaller than a jiffie and
artifically delay it by shifting the next expiry out by a jiffie. That's
accurate vs. the overrun accounting, but slightly inaccurate
vs. timer_gettimer(2).

The comment in that function says what needs to be done and there was a fix
available for the regular userspace induced SIG_IGN mechanism, but that did
not work due to the implicit ignore for SIGCONT and similar signals. This
needs to be worked on, but for now the only available workaround is to do
exactly what posix_timer_fn() does:

Increase the interval of self-rearming timers, which have their signal
ignored, to at least a jiffie.

Interestingly this has been fixed before via commit ff86bf0c65f1
("alarmtimer: Rate limit periodic intervals") already, but that fix got
lost in a later rework.

Fixes: f2c45807d399 ("alarmtimer: Switch over to generic set/get/rearm routine")
Reported-by: syzbot+b9564ba6e8e00694511b@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87k00q1no2.ffs@tglx
---
Backport for 4.14, 4.19, 5.4
---
 kernel/time/alarmtimer.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -476,11 +476,35 @@ u64 alarm_forward(struct alarm *alarm, k
 }
 EXPORT_SYMBOL_GPL(alarm_forward);
 
-u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+static u64 __alarm_forward_now(struct alarm *alarm, ktime_t interval, bool throttle)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
+	ktime_t now = base->gettime();
+
+	if (IS_ENABLED(CONFIG_HIGH_RES_TIMERS) && throttle) {
+		/*
+		 * Same issue as with posix_timer_fn(). Timers which are
+		 * periodic but the signal is ignored can starve the system
+		 * with a very small interval. The real fix which was
+		 * promised in the context of posix_timer_fn() never
+		 * materialized, but someone should really work on it.
+		 *
+		 * To prevent DOS fake @now to be 1 jiffie out which keeps
+		 * the overrun accounting correct but creates an
+		 * inconsistency vs. timer_gettime(2).
+		 */
+		ktime_t kj = NSEC_PER_SEC / HZ;
+
+		if (interval < kj)
+			now = ktime_add(now, kj);
+	}
+
+	return alarm_forward(alarm, now, interval);
+}
 
-	return alarm_forward(alarm, base->gettime(), interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	return __alarm_forward_now(alarm, interval, false);
 }
 EXPORT_SYMBOL_GPL(alarm_forward_now);
 
@@ -554,9 +578,10 @@ static enum alarmtimer_restart alarm_han
 	if (posix_timer_event(ptr, si_private) && ptr->it_interval) {
 		/*
 		 * Handle ignored signals and rearm the timer. This will go
-		 * away once we handle ignored signals proper.
+		 * away once we handle ignored signals proper. Ensure that
+		 * small intervals cannot starve the system.
 		 */
-		ptr->it_overrun += alarm_forward_now(alarm, ptr->it_interval);
+		ptr->it_overrun += __alarm_forward_now(alarm, ptr->it_interval, true);
 		++ptr->it_requeue_pending;
 		ptr->it_active = 1;
 		result = ALARMTIMER_RESTART;
