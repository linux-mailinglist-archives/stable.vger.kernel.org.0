Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1D383552
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhEQPRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242330AbhEQPPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB92261C59;
        Mon, 17 May 2021 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261947;
        bh=muKveB+nM0Jv/zEhGA7fZ1Xm9UWL9dWX47F01HDyC4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiwdMRw31g9x13YQHzPNbcMsEPHEliamNy2dEj11kvhbIcGAv89TI2XYJQ53YdYsB
         EY1baWCT8o0jk1jFw7T8m6eZCEOSnvoVf1/K6aGL3uB94FjxU0DCa/b2jY+589ZUE6
         bOmG17z4MjibXa+tdzrI1theYTfRUp8Ea3qKvphg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Laurence Oberman <loberman@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/289] watchdog: rename __touch_watchdog() to a better descriptive name
Date:   Mon, 17 May 2021 16:00:14 +0200
Message-Id: <20210517140308.176085581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit 7c0012f522c802d25be102bafe54f333168e6119 ]

Patch series "watchdog/softlockup: Report overall time and some cleanup", v2.

I dug deep into the softlockup watchdog history when time permitted this
year.  And reworked the patchset that fixed timestamps and cleaned up the
code[2].

I split it into very small steps and did even more code clean up.  The
result looks quite strightforward and I am pretty confident with the
changes.

[1] v2: https://lore.kernel.org/r/20201210160038.31441-1-pmladek@suse.com
[2] v1: https://lore.kernel.org/r/20191024114928.15377-1-pmladek@suse.com

This patch (of 6):

There are many touch_*watchdog() functions.  They are called in situations
where the watchdog could report false positives or create unnecessary
noise.  For example, when CPU is entering idle mode, a virtual machine is
stopped, or a lot of messages are printed in the atomic context.

These functions set SOFTLOCKUP_RESET instead of a real timestamp.  It
allows to call them even in a context where jiffies might be outdated.
For example, in an atomic context.

The real timestamp is set by __touch_watchdog() that is called from the
watchdog timer callback.

Rename this callback to update_touch_ts().  It better describes the effect
and clearly distinguish is from the other touch_*watchdog() functions.

Another motivation is that two timestamps are going to be used.  One will
be used for the total softlockup time.  The other will be used to measure
time since the last report.  The new function name will help to
distinguish which timestamp is being updated.

Link: https://lkml.kernel.org/r/20210311122130.6788-1-pmladek@suse.com
Link: https://lkml.kernel.org/r/20210311122130.6788-2-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 71109065bd8e..c58244064de8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -236,7 +236,7 @@ static void set_sample_period(void)
 }
 
 /* Commands for resetting the watchdog */
-static void __touch_watchdog(void)
+static void update_touch_ts(void)
 {
 	__this_cpu_write(watchdog_touch_ts, get_timestamp());
 }
@@ -331,7 +331,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, softlockup_stop_work);
  */
 static int softlockup_fn(void *data)
 {
-	__touch_watchdog();
+	update_touch_ts();
 	complete(this_cpu_ptr(&softlockup_completion));
 
 	return 0;
@@ -374,7 +374,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 
 		/* Clear the guest paused flag on watchdog reset */
 		kvm_check_and_clear_guest_paused();
-		__touch_watchdog();
+		update_touch_ts();
 		return HRTIMER_RESTART;
 	}
 
@@ -460,7 +460,7 @@ static void watchdog_enable(unsigned int cpu)
 		      HRTIMER_MODE_REL_PINNED_HARD);
 
 	/* Initialize timestamp */
-	__touch_watchdog();
+	update_touch_ts();
 	/* Enable the perf event */
 	if (watchdog_enabled & NMI_WATCHDOG_ENABLED)
 		watchdog_nmi_enable(cpu);
-- 
2.30.2



