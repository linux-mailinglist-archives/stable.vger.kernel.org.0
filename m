Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248D46960B3
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 11:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjBNK1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 05:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjBNK1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 05:27:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1AF23DAC;
        Tue, 14 Feb 2023 02:27:06 -0800 (PST)
Date:   Tue, 14 Feb 2023 10:27:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676370424;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3Pv+eRf++iaTDOszjT+O0VYSBDnRAumGsDDNwt2v10=;
        b=U/bUGHfjlHjl9//D6SfXm4o3GxLHWjTNS57QhcmdvIiCaAe+58vsY0/0wHA5Dmv8eRCiZa
        FkCwcpyIpu/50GQ8cvyets84insOiAQ5gfV/C3cnvPbXIJlVg3G+mB9IewUJYY6wqwpBtz
        flVdR7JUL0rydXTulM8sA3CvbTLcSuI7jOGk60EuCK8A6J7VYedi/l5gUUxS+r7eDWKdQV
        aC/g8aSF9kl1ra9ZkiEwNryPSsExKIbmJbucW4pS71V9LQLRl5842dgERQJFQsvkZMbqyH
        K00tkqwfzD27yEPL4Az+8VH9EgKoqXvF7nHFTuM7QxqKFErndz+hTrnSe4q8dA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676370424;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3Pv+eRf++iaTDOszjT+O0VYSBDnRAumGsDDNwt2v10=;
        b=v6vtvABn/is5PgHlh8jDC73xDGDqRfveuSpVE1s90Xl0IyLt135iCbi9St6/eucekj4lUi
        EiSe66am/qJYFRBg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/urgent] alarmtimer: Prevent starvation by small
 intervals and SIG_IGN
Cc:     syzbot+b9564ba6e8e00694511b@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <jstultz@google.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87k00q1no2.ffs@tglx>
References: <87k00q1no2.ffs@tglx>
MIME-Version: 1.0
Message-ID: <167637042384.4906.10102051738988384234.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/urgent branch of tip:

Commit-ID:     d125d1349abeb46945dc5e98f7824bf688266f13
Gitweb:        https://git.kernel.org/tip/d125d1349abeb46945dc5e98f7824bf688266f13
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 09 Feb 2023 23:25:49 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 14 Feb 2023 11:18:35 +01:00

alarmtimer: Prevent starvation by small intervals and SIG_IGN

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

Reported-by: syzbot+b9564ba6e8e00694511b@syzkaller.appspotmail.com
Fixes: f2c45807d399 ("alarmtimer: Switch over to generic set/get/rearm routine")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87k00q1no2.ffs@tglx
---
 kernel/time/alarmtimer.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 5897828..7e5dff6 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -470,11 +470,35 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 }
 EXPORT_SYMBOL_GPL(alarm_forward);
 
-u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+static u64 __alarm_forward_now(struct alarm *alarm, ktime_t interval, bool throttle)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
+	ktime_t now = base->get_ktime();
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
 
-	return alarm_forward(alarm, base->get_ktime(), interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	return __alarm_forward_now(alarm, interval, false);
 }
 EXPORT_SYMBOL_GPL(alarm_forward_now);
 
@@ -551,9 +575,10 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
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
