Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8D815C6D0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgBMQD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgBMPYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:11 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D990246B5;
        Thu, 13 Feb 2020 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607450;
        bh=R4qi8/bgh7+4Guu0GaXMWgMf20w69Ml8MImhr3b/5J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=met0XlFuVhMxzSns2JLsAqeILAVdkcuFt7ImV+pyRqvce4YR6xM2Ez93g/8qRjTck
         yQwaUNHhBU0ERAmwizUZZNROKQ3CykzA9G5NF+6wKUYGKpfAJcRPhCiPailonpr7h2
         sJL6nnKOgHWxypLAeZvcwlJ5RatZVjked8sWAmR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 094/116] clocksource: Prevent double add_timer_on() for watchdog_timer
Date:   Thu, 13 Feb 2020 07:20:38 -0800
Message-Id: <20200213151919.422887327@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit febac332a819f0e764aa4da62757ba21d18c182b upstream.

Kernel crashes inside QEMU/KVM are observed:

  kernel BUG at kernel/time/timer.c:1154!
  BUG_ON(timer_pending(timer) || !timer->function) in add_timer_on().

At the same time another cpu got:

  general protection fault: 0000 [#1] SMP PTI of poinson pointer 0xdead000000000200 in:

  __hlist_del at include/linux/list.h:681
  (inlined by) detach_timer at kernel/time/timer.c:818
  (inlined by) expire_timers at kernel/time/timer.c:1355
  (inlined by) __run_timers at kernel/time/timer.c:1686
  (inlined by) run_timer_softirq at kernel/time/timer.c:1699

Unfortunately kernel logs are badly scrambled, stacktraces are lost.

Printing the timer->function before the BUG_ON() pointed to
clocksource_watchdog().

The execution of clocksource_watchdog() can race with a sequence of
clocksource_stop_watchdog() .. clocksource_start_watchdog():

expire_timers()
 detach_timer(timer, true);
  timer->entry.pprev = NULL;
 raw_spin_unlock_irq(&base->lock);
 call_timer_fn
  clocksource_watchdog()

					clocksource_watchdog_kthread() or
					clocksource_unbind()

					spin_lock_irqsave(&watchdog_lock, flags);
					clocksource_stop_watchdog();
					 del_timer(&watchdog_timer);
					 watchdog_running = 0;
					spin_unlock_irqrestore(&watchdog_lock, flags);

					spin_lock_irqsave(&watchdog_lock, flags);
					clocksource_start_watchdog();
					 add_timer_on(&watchdog_timer, ...);
					 watchdog_running = 1;
					spin_unlock_irqrestore(&watchdog_lock, flags);

  spin_lock(&watchdog_lock);
  add_timer_on(&watchdog_timer, ...);
   BUG_ON(timer_pending(timer) || !timer->function);
    timer_pending() -> true
    BUG()

I.e. inside clocksource_watchdog() watchdog_timer could be already armed.

Check timer_pending() before calling add_timer_on(). This is sufficient as
all operations are synchronized by watchdog_lock.

Fixes: 75c5158f70c0 ("timekeeping: Update clocksource with stop_machine")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/158048693917.4378.13823603769948933793.stgit@buzz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/clocksource.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -272,8 +272,15 @@ static void clocksource_watchdog(unsigne
 	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
 	if (next_cpu >= nr_cpu_ids)
 		next_cpu = cpumask_first(cpu_online_mask);
-	watchdog_timer.expires += WATCHDOG_INTERVAL;
-	add_timer_on(&watchdog_timer, next_cpu);
+
+	/*
+	 * Arm timer if not already pending: could race with concurrent
+	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
+	 */
+	if (!timer_pending(&watchdog_timer)) {
+		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		add_timer_on(&watchdog_timer, next_cpu);
+	}
 out:
 	spin_unlock(&watchdog_lock);
 }


