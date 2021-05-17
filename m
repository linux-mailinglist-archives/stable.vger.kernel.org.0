Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE39382F65
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhEQOQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238857AbhEQOOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C79611ED;
        Mon, 17 May 2021 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260531;
        bh=UsjxBsvXXEJqygexlnJloIBP1VVz4OTDGHbsvRi/5i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdSBMZTTBeR8Zup3Zw2Fh55xbqpzxYHmRFf7RsFjFYv1G7HtBUnlC0Mr7WsXExyUA
         eRHIG14zJq+c7QZXLx3a96sDygrQJckwTzureX3r/2QC0TrglnklUo9getq+1OyTBr
         gfafmvepAj0E44WPsYOGXVsnyWsUD4gMafDkF3UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 123/363] watchdog: cleanup handling of false positives
Date:   Mon, 17 May 2021 15:59:49 +0200
Message-Id: <20210517140306.783130885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit 9bf3bc949f8aeefeacea4b1198db833b722a8e27 ]

Commit d6ad3e286d2c ("softlockup: Add sched_clock_tick() to avoid kernel
warning on kgdb resume") introduced touch_softlockup_watchdog_sync().

It solved a problem when the watchdog was touched in an atomic context,
the timer callback was proceed right after releasing interrupts, and the
local clock has not been updated yet.  In this case, sched_clock_tick()
was called in watchdog_timer_fn() before updating the timer.

So far so good.

Later commit 5d1c0f4a80a6 ("watchdog: add check for suspended vm in
softlockup detector") added two kvm_check_and_clear_guest_paused()
calls.  They touch the watchdog when the guest has been sleeping.

The code makes my head spin around.

Scenario 1:

    + guest did sleep:
	+ PVCLOCK_GUEST_STOPPED is set

    + 1st watchdog_timer_fn() invocation:
	+ the watchdog is not touched yet
	+ is_softlockup() returns too big delay
	+ kvm_check_and_clear_guest_paused():
	   + clear PVCLOCK_GUEST_STOPPED
	   + call touch_softlockup_watchdog_sync()
		+ set SOFTLOCKUP_DELAY_REPORT
		+ set softlockup_touch_sync
	+ return from the timer callback

      + 2nd watchdog_timer_fn() invocation:

	+ call sched_clock_tick() even though it is not needed.
	  The timer callback was invoked again only because the clock
	  has already been updated in the meantime.

	+ call kvm_check_and_clear_guest_paused() that does nothing
	  because PVCLOCK_GUEST_STOPPED has been cleared already.

	+ call update_report_ts() and return. This is fine. Except
	  that sched_clock_tick() might allow to set it already
	  during the 1st invocation.

Scenario 2:

	+ guest did sleep

	+ 1st watchdog_timer_fn() invocation
	    + same as in 1st scenario

	+ guest did sleep again:
	    + set PVCLOCK_GUEST_STOPPED again

	+ 2nd watchdog_timer_fn() invocation
	    + SOFTLOCKUP_DELAY_REPORT is set from 1st invocation
	    + call sched_clock_tick()
	    + call kvm_check_and_clear_guest_paused()
		+ clear PVCLOCK_GUEST_STOPPED
		+ call touch_softlockup_watchdog_sync()
		    + set SOFTLOCKUP_DELAY_REPORT
		    + set softlockup_touch_sync
	    + call update_report_ts() (set real timestamp immediately)
	    + return from the timer callback

	+ 3rd watchdog_timer_fn() invocation
	    + timestamp is set from 2nd invocation
	    + softlockup_touch_sync is set but not checked because
	      the real timestamp is already set

Make the code more straightforward:

1. Always call kvm_check_and_clear_guest_paused() at the very
   beginning to handle PVCLOCK_GUEST_STOPPED. It touches the watchdog
   when the quest did sleep.

2. Handle the situation when the watchdog has been touched
   (SOFTLOCKUP_DELAY_REPORT is set).

   Call sched_clock_tick() when touch_*sync() variant was used. It makes
   sure that the timestamp will be up to date even when it has been
   touched in atomic context or quest did sleep.

As a result, kvm_check_and_clear_guest_paused() is called on a single
location.  And the right timestamp is always set when returning from the
timer callback.

Link: https://lkml.kernel.org/r/20210311122130.6788-7-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 8cf0678378d2..7c397907d0e9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -376,7 +376,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	/* Reset the interval when touched externally by a known slow code. */
+	/*
+	 * If a virtual machine is stopped by the host it can look to
+	 * the watchdog like a soft lockup. Check to see if the host
+	 * stopped the vm before we process the timestamps.
+	 */
+	kvm_check_and_clear_guest_paused();
+
+	/* Reset the interval when touched by known problematic code. */
 	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
@@ -387,10 +394,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			sched_clock_tick();
 		}
 
-		/* Clear the guest paused flag on watchdog reset */
-		kvm_check_and_clear_guest_paused();
 		update_report_ts();
-
 		return HRTIMER_RESTART;
 	}
 
@@ -402,14 +406,6 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts, period_ts);
 	if (unlikely(duration)) {
-		/*
-		 * If a virtual machine is stopped by the host it can look to
-		 * the watchdog like a soft lockup, check to see if the host
-		 * stopped the vm before we issue the warning
-		 */
-		if (kvm_check_and_clear_guest_paused())
-			return HRTIMER_RESTART;
-
 		/*
 		 * Prevent multiple soft-lockup reports if one cpu is already
 		 * engaged in dumping all cpu back traces.
-- 
2.30.2



