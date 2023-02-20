Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869A469CE41
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjBTN55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjBTN54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:57:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065B1EBE3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E04EF60EA9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03BCC433D2;
        Mon, 20 Feb 2023 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901408;
        bh=BlLg2w4ZSu9QbDfQBUUWWmx8D/gAsIKxQpF9ZCz7RMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVmkONg3pfQYxizQIOwfAJgZOlvtuIfyVQI7lAG59vbOSl45opXhxMouV+4P2OdGY
         ZSXzPcc0G34leMHTt4iy5UjPjfLYdgsmZrnOGp9Bqt6CuVoRwwS/CMoQU++NvL0tlA
         4UB2tMA65Tgsk3hZijjdL6eVNr2HOqlkpl30FQ/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+b9564ba6e8e00694511b@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <jstultz@google.com>
Subject: [PATCH 5.10 54/57] alarmtimer: Prevent starvation by small intervals and SIG_IGN
Date:   Mon, 20 Feb 2023 14:37:02 +0100
Message-Id: <20230220133551.253944633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit d125d1349abeb46945dc5e98f7824bf688266f13 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -470,11 +470,35 @@ u64 alarm_forward(struct alarm *alarm, k
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
 
@@ -548,9 +572,10 @@ static enum alarmtimer_restart alarm_han
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


