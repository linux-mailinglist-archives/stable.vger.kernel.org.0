Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E192E135B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgLWC24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgLWCZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF1722248;
        Wed, 23 Dec 2020 02:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690340;
        bh=b4Vwej8oKzGNdW7eXreFtwfinfiYVZeKitr7I5VqZi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRPYLpf/qQysPmrUM+5LcM9CAUkeLW8IyXvaX57U4pN7V/gjqz8T6+A5dmIJPgbhr
         x0mEPaVrcj2pWh/grHGY3krEivVPkLEHocny/LAmQ8Pbu3FuvPG4vgIPrN5qqu8Ny1
         a08hNU0XlwamX8ciFUt/eNATyrVfkaNw9jmf4jnu/YZU84qJXEiYyJ+Os6toG3MF0/
         fS6z1riVYlmb5vlUU2vdxmBrwmpGBEJRVdTl1Rdd3F3Hkrn2BxbQEJf1bNaYuGHw9o
         tvzLF+Gb6pmA3podxAALCzZl4OOQoekR/0Dymsk3GoxXS7IeOh8/yc7rfntG534gKl
         5Bxe85LwPYmPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 19/38] tick/broadcast: Serialize access to tick_next_period
Date:   Tue, 22 Dec 2020 21:24:57 -0500
Message-Id: <20201223022516.2794471-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit f73f64d5687192bc8eb7f3d9521ca6256b79f224 ]

tick_broadcast_setup_oneshot() accesses tick_next_period twice without any
serialization. This is wrong in two aspects:

  - Reading it twice might make the broadcast data inconsistent if the
    variable is updated concurrently.

  - On 32bit systems the access might see an partial update

Protect it with jiffies_lock. That's safe as none of the callchains leading
up to this function can create a lock ordering violation:

timer interrupt
  run_local_timers()
    hrtimer_run_queues()
      hrtimer_switch_to_hres()
        tick_init_highres()
	  tick_switch_to_oneshot()
	    tick_broadcast_switch_to_oneshot()
or
     tick_check_oneshot_change()
       tick_nohz_switch_to_nohz()
         tick_switch_to_oneshot()
           tick_broadcast_switch_to_oneshot()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201117132006.061341507@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-broadcast.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 22d7454b387bc..edb937bfc63c6 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -872,6 +872,22 @@ static void tick_broadcast_init_next_event(struct cpumask *mask,
 	}
 }
 
+static inline ktime_t tick_get_next_period(void)
+{
+	ktime_t next;
+
+	/*
+	 * Protect against concurrent updates (store /load tearing on
+	 * 32bit). It does not matter if the time is already in the
+	 * past. The broadcast device which is about to be programmed will
+	 * fire in any case.
+	 */
+	raw_spin_lock(&jiffies_lock);
+	next = tick_next_period;
+	raw_spin_unlock(&jiffies_lock);
+	return next;
+}
+
 /**
  * tick_broadcast_setup_oneshot - setup the broadcast device
  */
@@ -900,10 +916,11 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   tick_broadcast_oneshot_mask, tmpmask);
 
 		if (was_periodic && !cpumask_empty(tmpmask)) {
+			ktime_t nextevt = tick_get_next_period();
+
 			clockevents_switch_state(bc, CLOCK_EVT_STATE_ONESHOT);
-			tick_broadcast_init_next_event(tmpmask,
-						       tick_next_period);
-			tick_broadcast_set_event(bc, cpu, tick_next_period);
+			tick_broadcast_init_next_event(tmpmask, nextevt);
+			tick_broadcast_set_event(bc, cpu, nextevt);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
 	} else {
-- 
2.27.0

