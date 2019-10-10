Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C0D2408
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388640AbfJJIsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389630AbfJJIsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C77218AC;
        Thu, 10 Oct 2019 08:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697299;
        bh=y5fnbsvVCOvoy93773ToMsRGUwmpgIB6iwav6W526N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLfm0tornSKzzTbEyi6b9RkWoPJawKOixm7E7v8a7DYfDjWU7jqVfq6UA+Lm/jIGv
         A+usWbbsXil6qKaqYhqurBb21kJMtlYUGnAo1FOaCTKvh3NiHt4844Weo7uxHIhboR
         GoS3AyKWE+v5f1ljzBb0X/Umcz+1RlB4mt2t3iWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Balasubramani Vivekanandan 
        <balasubramani_vivekanandan@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/114] tick: broadcast-hrtimer: Fix a race in bc_set_next
Date:   Thu, 10 Oct 2019 10:36:31 +0200
Message-Id: <20191010083612.467090643@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>

[ Upstream commit b9023b91dd020ad7e093baa5122b6968c48cc9e0 ]

When a cpu requests broadcasting, before starting the tick broadcast
hrtimer, bc_set_next() checks if the timer callback (bc_handler) is active
using hrtimer_try_to_cancel(). But hrtimer_try_to_cancel() does not provide
the required synchronization when the callback is active on other core.

The callback could have already executed tick_handle_oneshot_broadcast()
and could have also returned. But still there is a small time window where
the hrtimer_try_to_cancel() returns -1. In that case bc_set_next() returns
without doing anything, but the next_event of the tick broadcast clock
device is already set to a timeout value.

In the race condition diagram below, CPU #1 is running the timer callback
and CPU #2 is entering idle state and so calls bc_set_next().

In the worst case, the next_event will contain an expiry time, but the
hrtimer will not be started which happens when the racing callback returns
HRTIMER_NORESTART. The hrtimer might never recover if all further requests
from the CPUs to subscribe to tick broadcast have timeout greater than the
next_event of tick broadcast clock device. This leads to cascading of
failures and finally noticed as rcu stall warnings

Here is a depiction of the race condition

CPU #1 (Running timer callback)                   CPU #2 (Enter idle
                                                  and subscribe to
                                                  tick broadcast)
---------------------                             ---------------------

__run_hrtimer()                                   tick_broadcast_enter()

  bc_handler()                                      __tick_broadcast_oneshot_control()

    tick_handle_oneshot_broadcast()

      raw_spin_lock(&tick_broadcast_lock);

      dev->next_event = KTIME_MAX;                  //wait for tick_broadcast_lock
      //next_event for tick broadcast clock
      set to KTIME_MAX since no other cores
      subscribed to tick broadcasting

      raw_spin_unlock(&tick_broadcast_lock);

    if (dev->next_event == KTIME_MAX)
      return HRTIMER_NORESTART
    // callback function exits without
       restarting the hrtimer                      //tick_broadcast_lock acquired
                                                   raw_spin_lock(&tick_broadcast_lock);

                                                   tick_broadcast_set_event()

                                                     clockevents_program_event()

                                                       dev->next_event = expires;

                                                       bc_set_next()

                                                         hrtimer_try_to_cancel()
                                                         //returns -1 since the timer
                                                         callback is active. Exits without
                                                         restarting the timer
  cpu_base->running = NULL;

The comment that hrtimer cannot be armed from within the callback is
wrong. It is fine to start the hrtimer from within the callback. Also it is
safe to start the hrtimer from the enter/exit idle code while the broadcast
handler is active. The enter/exit idle code and the broadcast handler are
synchronized using tick_broadcast_lock. So there is no need for the
existing try to cancel logic. All this can be removed which will eliminate
the race condition as well.

Fixes: 5d1638acb9f6 ("tick: Introduce hrtimer based broadcast")
Originally-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190926135101.12102-2-balasubramani_vivekanandan@mentor.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-broadcast-hrtimer.c | 57 ++++++++++++++--------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index a59641fb88b69..a836efd345895 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -44,34 +44,39 @@ static int bc_shutdown(struct clock_event_device *evt)
  */
 static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
 {
-	int bc_moved;
 	/*
-	 * We try to cancel the timer first. If the callback is on
-	 * flight on some other cpu then we let it handle it. If we
-	 * were able to cancel the timer nothing can rearm it as we
-	 * own broadcast_lock.
+	 * This is called either from enter/exit idle code or from the
+	 * broadcast handler. In all cases tick_broadcast_lock is held.
 	 *
-	 * However we can also be called from the event handler of
-	 * ce_broadcast_hrtimer itself when it expires. We cannot
-	 * restart the timer because we are in the callback, but we
-	 * can set the expiry time and let the callback return
-	 * HRTIMER_RESTART.
+	 * hrtimer_cancel() cannot be called here neither from the
+	 * broadcast handler nor from the enter/exit idle code. The idle
+	 * code can run into the problem described in bc_shutdown() and the
+	 * broadcast handler cannot wait for itself to complete for obvious
+	 * reasons.
 	 *
-	 * Since we are in the idle loop at this point and because
-	 * hrtimer_{start/cancel} functions call into tracing,
-	 * calls to these functions must be bound within RCU_NONIDLE.
+	 * Each caller tries to arm the hrtimer on its own CPU, but if the
+	 * hrtimer callbback function is currently running, then
+	 * hrtimer_start() cannot move it and the timer stays on the CPU on
+	 * which it is assigned at the moment.
+	 *
+	 * As this can be called from idle code, the hrtimer_start()
+	 * invocation has to be wrapped with RCU_NONIDLE() as
+	 * hrtimer_start() can call into tracing.
 	 */
-	RCU_NONIDLE({
-			bc_moved = hrtimer_try_to_cancel(&bctimer) >= 0;
-			if (bc_moved)
-				hrtimer_start(&bctimer, expires,
-					      HRTIMER_MODE_ABS_PINNED);});
-	if (bc_moved) {
-		/* Bind the "device" to the cpu */
-		bc->bound_on = smp_processor_id();
-	} else if (bc->bound_on == smp_processor_id()) {
-		hrtimer_set_expires(&bctimer, expires);
-	}
+	RCU_NONIDLE( {
+		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
+		/*
+		 * The core tick broadcast mode expects bc->bound_on to be set
+		 * correctly to prevent a CPU which has the broadcast hrtimer
+		 * armed from going deep idle.
+		 *
+		 * As tick_broadcast_lock is held, nothing can change the cpu
+		 * base which was just established in hrtimer_start() above. So
+		 * the below access is safe even without holding the hrtimer
+		 * base lock.
+		 */
+		bc->bound_on = bctimer.base->cpu_base->cpu;
+	} );
 	return 0;
 }
 
@@ -97,10 +102,6 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
 {
 	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
 
-	if (clockevent_state_oneshot(&ce_broadcast_hrtimer))
-		if (ce_broadcast_hrtimer.next_event != KTIME_MAX)
-			return HRTIMER_RESTART;
-
 	return HRTIMER_NORESTART;
 }
 
-- 
2.20.1



