Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD8374310
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhEEQvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbhEEQrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54CEB61425;
        Wed,  5 May 2021 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232605;
        bh=xtG7WbmAe5GyHpRvMmugAktrglxWiM55d6rGpGh9mqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i16oEW1yQhSUlpVeoNsDEC+y+7l6JCKqqDBTpZVwEWxc00E5UadIXt5F17eNiLlfu
         GNyBgc2aALJMNCAdZxUsm+5agVrEzaxg5Wbsl39pumXMzOCHYIVtlHAID1asP6HaT7
         A3tZQN5Camb5zjQZH3mi/E/qo4dX1hwfPr98HqdAu2SVyI++gWXfYsGvZEvN0y973T
         y4TSy5cysO0BYsklofpIn4GQJnV30V27zrOGdWgzdh8xJoRzUHZ9aMKiqhjQZ+8mXE
         HS61dDndVRVNz18xLqLgl5UrLjbMOTtn0hHllZBE7ddL2U2uIdfXXLx2ftTpC5Sp3m
         2Cwlx4fKjp2sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 103/104] watchdog/softlockup: remove logic that tried to prevent repeated reports
Date:   Wed,  5 May 2021 12:34:12 -0400
Message-Id: <20210505163413.3461611-103-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit 1bc503cb4a2638fb1c57801a7796aca57845ce63 ]

The softlockup detector does some gymnastic with the variable
soft_watchdog_warn.  It was added by the commit 58687acba59266735ad
("lockup_detector: Combine nmi_watchdog and softlockup detector").

The purpose is not completely clear.  There are the following clues.  They
describe the situation how it looked after the above mentioned commit:

  1. The variable was checked with a comment "only warn once".

  2. The variable was set when softlockup was reported. It was cleared
     only when the CPU was not longer in the softlockup state.

  3. watchdog_touch_ts was not explicitly updated when the softlockup
     was reported. Without this variable, the report would normally
     be printed again during every following watchdog_timer_fn()
     invocation.

The logic has got even more tangled up by the commit ed235875e2ca98
("kernel/watchdog.c: print traces for all cpus on lockup detection").
After this commit, soft_watchdog_warn is set only when
softlockup_all_cpu_backtrace is enabled.  But multiple reports from all
CPUs are prevented by a new variable soft_lockup_nmi_warn.

Conclusion:

The variable probably never worked as intended.  In each case, it has not
worked last many years because the softlockup was reported repeatedly
after the full period defined by watchdog_thresh.

The reason is that watchdog gets touched in many known slow paths, for
example, in printk_stack_address().  This code is called also when
printing the softlockup report.  It means that the watchdog timestamp gets
updated after each report.

Solution:

Simply remove the logic. People want the periodic report anyway.

Link: https://lkml.kernel.org/r/20210311122130.6788-5-pmladek@suse.com
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
 kernel/watchdog.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7776d53a015c..122e272ad7f2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -172,7 +172,6 @@ static u64 __read_mostly sample_period;
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
@@ -394,19 +393,12 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
-		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
-			return HRTIMER_RESTART;
-
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
 			 * engaged in dumping cpu back traces
 			 */
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
-				/* Someone else will report us. Let's give up */
-				__this_cpu_write(soft_watchdog_warn, true);
+			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
-			}
 		}
 
 		/* Start period for the next softlockup warning. */
@@ -436,9 +428,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
-		__this_cpu_write(soft_watchdog_warn, true);
-	} else
-		__this_cpu_write(soft_watchdog_warn, false);
+	}
 
 	return HRTIMER_RESTART;
 }
-- 
2.30.2

