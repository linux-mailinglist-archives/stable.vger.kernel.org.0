Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CECB3D61DB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhGZPdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232717AbhGZPbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746FE60240;
        Mon, 26 Jul 2021 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315905;
        bh=7PXD8fBUclA4p+zGO08cTAxD7vgJA32+CxxBJBGq1WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCwwgYYOifLBdkSVvDegqIj+jofMET+rcTEsm3F6wM4NVq2ExRty+S3Ue7TJvBzQ1
         mVeznK490DcgVAVhAnx2EywirDr0EF2RlF96AcbPd1g6v2spzO7hEbdS/tLrZ2EMpX
         8I6Eu7qRUQZr2BocpM/oAdSlepcl9EAOlfn2IsoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/223] timers: Fix get_next_timer_interrupt() with no timers pending
Date:   Mon, 26 Jul 2021 17:37:49 +0200
Message-Id: <20210726153848.771706338@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzju@redhat.com>

[ Upstream commit aebacb7f6ca1926918734faae14d1f0b6fae5cb7 ]

31cd0e119d50 ("timers: Recalculate next timer interrupt only when
necessary") subtly altered get_next_timer_interrupt()'s behaviour. The
function no longer consistently returns KTIME_MAX with no timers
pending.

In order to decide if there are any timers pending we check whether the
next expiry will happen NEXT_TIMER_MAX_DELTA jiffies from now.
Unfortunately, the next expiry time and the timer base clock are no
longer updated in unison. The former changes upon certain timer
operations (enqueue, expire, detach), whereas the latter keeps track of
jiffies as they move forward. Ultimately breaking the logic above.

A simplified example:

- Upon entering get_next_timer_interrupt() with:

	jiffies = 1
	base->clk = 0;
	base->next_expiry = NEXT_TIMER_MAX_DELTA;

  'base->next_expiry == base->clk + NEXT_TIMER_MAX_DELTA', the function
  returns KTIME_MAX.

- 'base->clk' is updated to the jiffies value.

- The next time we enter get_next_timer_interrupt(), taking into account
  no timer operations happened:

	base->clk = 1;
	base->next_expiry = NEXT_TIMER_MAX_DELTA;

  'base->next_expiry != base->clk + NEXT_TIMER_MAX_DELTA', the function
  returns a valid expire time, which is incorrect.

This ultimately might unnecessarily rearm sched's timer on nohz_full
setups, and add latency to the system[1].

So, introduce 'base->timers_pending'[2], update it every time
'base->next_expiry' changes, and use it in get_next_timer_interrupt().

[1] See tick_nohz_stop_tick().
[2] A quick pahole check on x86_64 and arm64 shows it doesn't make
    'struct timer_base' any bigger.

Fixes: 31cd0e119d50 ("timers: Recalculate next timer interrupt only when necessary")
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index d111adf4a0cb..99b97ccefdbd 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -207,6 +207,7 @@ struct timer_base {
 	unsigned int		cpu;
 	bool			next_expiry_recalc;
 	bool			is_idle;
+	bool			timers_pending;
 	DECLARE_BITMAP(pending_map, WHEEL_SIZE);
 	struct hlist_head	vectors[WHEEL_SIZE];
 } ____cacheline_aligned;
@@ -595,6 +596,7 @@ static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
 		 * can reevaluate the wheel:
 		 */
 		base->next_expiry = bucket_expiry;
+		base->timers_pending = true;
 		base->next_expiry_recalc = false;
 		trigger_dyntick_cpu(base, timer);
 	}
@@ -1596,6 +1598,7 @@ static unsigned long __next_timer_interrupt(struct timer_base *base)
 	}
 
 	base->next_expiry_recalc = false;
+	base->timers_pending = !(next == base->clk + NEXT_TIMER_MAX_DELTA);
 
 	return next;
 }
@@ -1647,7 +1650,6 @@ u64 get_next_timer_interrupt(unsigned long basej, u64 basem)
 	struct timer_base *base = this_cpu_ptr(&timer_bases[BASE_STD]);
 	u64 expires = KTIME_MAX;
 	unsigned long nextevt;
-	bool is_max_delta;
 
 	/*
 	 * Pretend that there is no timer pending if the cpu is offline.
@@ -1660,7 +1662,6 @@ u64 get_next_timer_interrupt(unsigned long basej, u64 basem)
 	if (base->next_expiry_recalc)
 		base->next_expiry = __next_timer_interrupt(base);
 	nextevt = base->next_expiry;
-	is_max_delta = (nextevt == base->clk + NEXT_TIMER_MAX_DELTA);
 
 	/*
 	 * We have a fresh next event. Check whether we can forward the
@@ -1678,7 +1679,7 @@ u64 get_next_timer_interrupt(unsigned long basej, u64 basem)
 		expires = basem;
 		base->is_idle = false;
 	} else {
-		if (!is_max_delta)
+		if (base->timers_pending)
 			expires = basem + (u64)(nextevt - basej) * TICK_NSEC;
 		/*
 		 * If we expect to sleep more than a tick, mark the base idle.
@@ -1961,6 +1962,7 @@ int timers_prepare_cpu(unsigned int cpu)
 		base = per_cpu_ptr(&timer_bases[b], cpu);
 		base->clk = jiffies;
 		base->next_expiry = base->clk + NEXT_TIMER_MAX_DELTA;
+		base->timers_pending = false;
 		base->is_idle = false;
 	}
 	return 0;
-- 
2.30.2



