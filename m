Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297D533BA6C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhCOOJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhCOODj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEBD64EF8;
        Mon, 15 Mar 2021 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817018;
        bh=/EkFjXcKlU3lAf5jI8Rkrao0Bd5asIrI3wRF9WEF4s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8/wBzC05cDYyqv3KOAznfE1TF+pTTNwCt9Ofb29nuxe3Ls/GRAwKReHXwQwpEV+x
         hzyG/B55zxAH/dprs/5q38FXPpH7gcqZQat++bTmMzlZ9CfHUBVDmokbGc409bPDve
         Cfj4aHjR0rcr+nOnMRBJ8LgU+GJ76WhEF6XSb05k=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikael Beckius <mikael.beckius@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 262/306] hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()
Date:   Mon, 15 Mar 2021 14:55:25 +0100
Message-Id: <20210315135516.500608951@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Anna-Maria Behnsen <anna-maria@linutronix.de>

[ Upstream commit 46eb1701c046cc18c032fa68f3c8ccbf24483ee4 ]

hrtimer_force_reprogram() and hrtimer_interrupt() invokes
__hrtimer_get_next_event() to find the earliest expiry time of hrtimer
bases. __hrtimer_get_next_event() does not update
cpu_base::[softirq_]_expires_next to preserve reprogramming logic. That
needs to be done at the callsites.

hrtimer_force_reprogram() updates cpu_base::softirq_expires_next only when
the first expiring timer is a softirq timer and the soft interrupt is not
activated. That's wrong because cpu_base::softirq_expires_next is left
stale when the first expiring timer of all bases is a timer which expires
in hard interrupt context. hrtimer_interrupt() does never update
cpu_base::softirq_expires_next which is wrong too.

That becomes a problem when clock_settime() sets CLOCK_REALTIME forward and
the first soft expiring timer is in the CLOCK_REALTIME_SOFT base. Setting
CLOCK_REALTIME forward moves the clock MONOTONIC based expiry time of that
timer before the stale cpu_base::softirq_expires_next.

cpu_base::softirq_expires_next is cached to make the check for raising the
soft interrupt fast. In the above case the soft interrupt won't be raised
until clock monotonic reaches the stale cpu_base::softirq_expires_next
value. That's incorrect, but what's worse it that if the softirq timer
becomes the first expiring timer of all clock bases after the hard expiry
timer has been handled the reprogramming of the clockevent from
hrtimer_interrupt() will result in an interrupt storm. That happens because
the reprogramming does not use cpu_base::softirq_expires_next, it uses
__hrtimer_get_next_event() which returns the actual expiry time. Once clock
MONOTONIC reaches cpu_base::softirq_expires_next the soft interrupt is
raised and the storm subsides.

Change the logic in hrtimer_force_reprogram() to evaluate the soft and hard
bases seperately, update softirq_expires_next and handle the case when a
soft expiring timer is the first of all bases by comparing the expiry times
and updating the required cpu base fields. Split this functionality into a
separate function to be able to use it in hrtimer_interrupt() as well
without copy paste.

Fixes: 5da70160462e ("hrtimer: Implement support for softirq based hrtimers")
Reported-by: Mikael Beckius <mikael.beckius@windriver.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mikael Beckius <mikael.beckius@windriver.com>
Signed-off-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210223160240.27518-1-anna-maria@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 60 ++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 743c852e10f2..788b9d137de4 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -546,8 +546,11 @@ static ktime_t __hrtimer_next_event_base(struct hrtimer_cpu_base *cpu_base,
 }
 
 /*
- * Recomputes cpu_base::*next_timer and returns the earliest expires_next but
- * does not set cpu_base::*expires_next, that is done by hrtimer_reprogram.
+ * Recomputes cpu_base::*next_timer and returns the earliest expires_next
+ * but does not set cpu_base::*expires_next, that is done by
+ * hrtimer[_force]_reprogram and hrtimer_interrupt only. When updating
+ * cpu_base::*expires_next right away, reprogramming logic would no longer
+ * work.
  *
  * When a softirq is pending, we can ignore the HRTIMER_ACTIVE_SOFT bases,
  * those timers will get run whenever the softirq gets handled, at the end of
@@ -588,6 +591,37 @@ __hrtimer_get_next_event(struct hrtimer_cpu_base *cpu_base, unsigned int active_
 	return expires_next;
 }
 
+static ktime_t hrtimer_update_next_event(struct hrtimer_cpu_base *cpu_base)
+{
+	ktime_t expires_next, soft = KTIME_MAX;
+
+	/*
+	 * If the soft interrupt has already been activated, ignore the
+	 * soft bases. They will be handled in the already raised soft
+	 * interrupt.
+	 */
+	if (!cpu_base->softirq_activated) {
+		soft = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_SOFT);
+		/*
+		 * Update the soft expiry time. clock_settime() might have
+		 * affected it.
+		 */
+		cpu_base->softirq_expires_next = soft;
+	}
+
+	expires_next = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_HARD);
+	/*
+	 * If a softirq timer is expiring first, update cpu_base->next_timer
+	 * and program the hardware with the soft expiry time.
+	 */
+	if (expires_next > soft) {
+		cpu_base->next_timer = cpu_base->softirq_next_timer;
+		expires_next = soft;
+	}
+
+	return expires_next;
+}
+
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 {
 	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
@@ -628,23 +662,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
 	ktime_t expires_next;
 
-	/*
-	 * Find the current next expiration time.
-	 */
-	expires_next = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_ALL);
-
-	if (cpu_base->next_timer && cpu_base->next_timer->is_soft) {
-		/*
-		 * When the softirq is activated, hrtimer has to be
-		 * programmed with the first hard hrtimer because soft
-		 * timer interrupt could occur too late.
-		 */
-		if (cpu_base->softirq_activated)
-			expires_next = __hrtimer_get_next_event(cpu_base,
-								HRTIMER_ACTIVE_HARD);
-		else
-			cpu_base->softirq_expires_next = expires_next;
-	}
+	expires_next = hrtimer_update_next_event(cpu_base);
 
 	if (skip_equal && expires_next == cpu_base->expires_next)
 		return;
@@ -1644,8 +1662,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 
 	__hrtimer_run_queues(cpu_base, now, flags, HRTIMER_ACTIVE_HARD);
 
-	/* Reevaluate the clock bases for the next expiry */
-	expires_next = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_ALL);
+	/* Reevaluate the clock bases for the [soft] next expiry */
+	expires_next = hrtimer_update_next_event(cpu_base);
 	/*
 	 * Store the new expiry value so the migration code can verify
 	 * against it.
-- 
2.30.1



