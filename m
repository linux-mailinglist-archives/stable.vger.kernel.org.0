Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F44013EF
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbhIFBcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239992AbhIFB1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BB77610FC;
        Mon,  6 Sep 2021 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891376;
        bh=jQiRXN44AfJquO6nOtwoAW/DXByy/2Au6QH4RooqEpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOkjM+YiVhbMCqGojk0UQ1lxUtI5tqnxsVJ9MRpqZWNu3Zoj+pnmDNU4FC9hjai3l
         HkqeH6LsEU6LJ21vCj7cWMLwJFinnFU4xRyrPDw9UnUQOgCwEmwVFLRY2LNsEsWGcD
         XpI1ZZpdQKqqiyNpCUN7hU1MXfwbnZXl0p1DaBcvdCakOYf5EmJZMDG7PYU6aE11Md
         D5FrYSXoga2tfP0EDvejO499F9wRdsIRiFel2q+3Vm3nPbUC6EeBSLIsfkhg+MMFXb
         9oOIvnE0ra6tc4h/jeh78mh8AQYayIyQv4eZ2iPvOCyaOFVjnFZEB4oFO6kHZVYD3G
         nVtM/E41fgimQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 10/30] hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()
Date:   Sun,  5 Sep 2021 21:22:23 -0400
Message-Id: <20210906012244.930338-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 627ef5ae2df8eeccb20d5af0e4cfa4df9e61ed28 ]

If __hrtimer_start_range_ns() is invoked with an already armed hrtimer then
the timer has to be canceled first and then added back. If the timer is the
first expiring timer then on removal the clockevent device is reprogrammed
to the next expiring timer to avoid that the pending expiry fires needlessly.

If the new expiry time ends up to be the first expiry again then the clock
event device has to reprogrammed again.

Avoid this by checking whether the timer is the first to expire and in that
case, keep the timer on the current CPU and delay the reprogramming up to
the point where the timer has been enqueued again.

Reported-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210713135157.873137732@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 60 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 1f3e3a17f67e..39beb9aaa24b 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1031,12 +1031,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
  * remove hrtimer, called with base lock held
  */
 static inline int
-remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, bool restart)
+remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base,
+	       bool restart, bool keep_local)
 {
 	u8 state = timer->state;
 
 	if (state & HRTIMER_STATE_ENQUEUED) {
-		int reprogram;
+		bool reprogram;
 
 		/*
 		 * Remove the timer and force reprogramming when high
@@ -1049,8 +1050,16 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base, bool rest
 		debug_deactivate(timer);
 		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 
+		/*
+		 * If the timer is not restarted then reprogramming is
+		 * required if the timer is local. If it is local and about
+		 * to be restarted, avoid programming it twice (on removal
+		 * and a moment later when it's requeued).
+		 */
 		if (!restart)
 			state = HRTIMER_STATE_INACTIVE;
+		else
+			reprogram &= !keep_local;
 
 		__remove_hrtimer(timer, base, state, reprogram);
 		return 1;
@@ -1104,9 +1113,31 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				    struct hrtimer_clock_base *base)
 {
 	struct hrtimer_clock_base *new_base;
+	bool force_local, first;
 
-	/* Remove an active timer from the queue: */
-	remove_hrtimer(timer, base, true);
+	/*
+	 * If the timer is on the local cpu base and is the first expiring
+	 * timer then this might end up reprogramming the hardware twice
+	 * (on removal and on enqueue). To avoid that by prevent the
+	 * reprogram on removal, keep the timer local to the current CPU
+	 * and enforce reprogramming after it is queued no matter whether
+	 * it is the new first expiring timer again or not.
+	 */
+	force_local = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
+	force_local &= base->cpu_base->next_timer == timer;
+
+	/*
+	 * Remove an active timer from the queue. In case it is not queued
+	 * on the current CPU, make sure that remove_hrtimer() updates the
+	 * remote data correctly.
+	 *
+	 * If it's on the current CPU and the first expiring timer, then
+	 * skip reprogramming, keep the timer local and enforce
+	 * reprogramming later if it was the first expiring timer.  This
+	 * avoids programming the underlying clock event twice (once at
+	 * removal and once after enqueue).
+	 */
+	remove_hrtimer(timer, base, true, force_local);
 
 	if (mode & HRTIMER_MODE_REL)
 		tim = ktime_add_safe(tim, base->get_time());
@@ -1116,9 +1147,24 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
 
 	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+	if (!force_local) {
+		new_base = switch_hrtimer_base(timer, base,
+					       mode & HRTIMER_MODE_PINNED);
+	} else {
+		new_base = base;
+	}
+
+	first = enqueue_hrtimer(timer, new_base, mode);
+	if (!force_local)
+		return first;
 
-	return enqueue_hrtimer(timer, new_base, mode);
+	/*
+	 * Timer was forced to stay on the current CPU to avoid
+	 * reprogramming on removal and enqueue. Force reprogram the
+	 * hardware by evaluating the new first expiring timer.
+	 */
+	hrtimer_force_reprogram(new_base->cpu_base, 1);
+	return 0;
 }
 
 /**
@@ -1184,7 +1230,7 @@ int hrtimer_try_to_cancel(struct hrtimer *timer)
 	base = lock_hrtimer_base(timer, &flags);
 
 	if (!hrtimer_callback_running(timer))
-		ret = remove_hrtimer(timer, base, false);
+		ret = remove_hrtimer(timer, base, false, false);
 
 	unlock_hrtimer_base(timer, &flags);
 
-- 
2.30.2

