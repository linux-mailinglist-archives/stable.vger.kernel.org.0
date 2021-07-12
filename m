Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38083C51EB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349558AbhGLHoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349044AbhGLHlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8276601FE;
        Mon, 12 Jul 2021 07:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075527;
        bh=5xyOYADtTfSz2kJDL/08i4MTsLxZD0DoDJbNO38WLC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo1KyMzeWYnlw6ggdk5wfdgKlXVVcw/H512hnKs6+713AUdJVQbdPn4mpSy03Qa7l
         jqojp0AC2wXmjyt8q3Yti7J/JVzHsV8/ALMg/3Nh2S0f9sD6b5EWACpkSRYD+K+XS5
         lQrV9rSoHADZ2fdXs55bZofdz2oHQ00uKjUlVVFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 253/800] clocksource: Check per-CPU clock synchronization when marked unstable
Date:   Mon, 12 Jul 2021 08:04:36 +0200
Message-Id: <20210712060949.605514440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 7560c02bdffb7c52d1457fa551b9e745d4b9e754 ]

Some sorts of per-CPU clock sources have a history of going out of
synchronization with each other.  However, this problem has purportedy been
solved in the past ten years.  Except that it is all too possible that the
problem has instead simply been made less likely, which might mean that
some of the occasional "Marking clocksource 'tsc' as unstable" messages
might be due to desynchronization.  How would anyone know?

Therefore apply CPU-to-CPU synchronization checking to newly unstable
clocksource that are marked with the new CLOCK_SOURCE_VERIFY_PERCPU flag.
Lists of desynchronized CPUs are printed, with the caveat that if it
is the reporting CPU that is itself desynchronized, it will appear that
all the other clocks are wrong.  Just like in real life.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20210527190124.440372-2-paulmck@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/tsc.c       |  3 +-
 include/linux/clocksource.h |  2 +-
 kernel/time/clocksource.c   | 60 +++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57ec01192180..6eb1b097e97e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1152,7 +1152,8 @@ static struct clocksource clocksource_tsc = {
 	.mask			= CLOCKSOURCE_MASK(64),
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_VALID_FOR_HRES |
-				  CLOCK_SOURCE_MUST_VERIFY,
+				  CLOCK_SOURCE_MUST_VERIFY |
+				  CLOCK_SOURCE_VERIFY_PERCPU,
 	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
 	.enable			= tsc_cs_enable,
 	.resume			= tsc_resume,
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index d6ab416ee2d2..7f83d51c0fd7 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -137,7 +137,7 @@ struct clocksource {
 #define CLOCK_SOURCE_UNSTABLE			0x40
 #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
 #define CLOCK_SOURCE_RESELECT			0x100
-
+#define CLOCK_SOURCE_VERIFY_PERCPU		0x200
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) GENMASK_ULL((bits) - 1, 0)
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 43243f2be98e..cb12225bf050 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -224,6 +224,60 @@ static bool cs_watchdog_read(struct clocksource *cs, u64 *csnow, u64 *wdnow)
 	return false;
 }
 
+static u64 csnow_mid;
+static cpumask_t cpus_ahead;
+static cpumask_t cpus_behind;
+
+static void clocksource_verify_one_cpu(void *csin)
+{
+	struct clocksource *cs = (struct clocksource *)csin;
+
+	csnow_mid = cs->read(cs);
+}
+
+static void clocksource_verify_percpu(struct clocksource *cs)
+{
+	int64_t cs_nsec, cs_nsec_max = 0, cs_nsec_min = LLONG_MAX;
+	u64 csnow_begin, csnow_end;
+	int cpu, testcpu;
+	s64 delta;
+
+	cpumask_clear(&cpus_ahead);
+	cpumask_clear(&cpus_behind);
+	preempt_disable();
+	testcpu = smp_processor_id();
+	pr_warn("Checking clocksource %s synchronization from CPU %d.\n", cs->name, testcpu);
+	for_each_online_cpu(cpu) {
+		if (cpu == testcpu)
+			continue;
+		csnow_begin = cs->read(cs);
+		smp_call_function_single(cpu, clocksource_verify_one_cpu, cs, 1);
+		csnow_end = cs->read(cs);
+		delta = (s64)((csnow_mid - csnow_begin) & cs->mask);
+		if (delta < 0)
+			cpumask_set_cpu(cpu, &cpus_behind);
+		delta = (csnow_end - csnow_mid) & cs->mask;
+		if (delta < 0)
+			cpumask_set_cpu(cpu, &cpus_ahead);
+		delta = clocksource_delta(csnow_end, csnow_begin, cs->mask);
+		cs_nsec = clocksource_cyc2ns(delta, cs->mult, cs->shift);
+		if (cs_nsec > cs_nsec_max)
+			cs_nsec_max = cs_nsec;
+		if (cs_nsec < cs_nsec_min)
+			cs_nsec_min = cs_nsec;
+	}
+	preempt_enable();
+	if (!cpumask_empty(&cpus_ahead))
+		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
+			cpumask_pr_args(&cpus_ahead), testcpu, cs->name);
+	if (!cpumask_empty(&cpus_behind))
+		pr_warn("        CPUs %*pbl behind CPU %d for clocksource %s.\n",
+			cpumask_pr_args(&cpus_behind), testcpu, cs->name);
+	if (!cpumask_empty(&cpus_ahead) || !cpumask_empty(&cpus_behind))
+		pr_warn("        CPU %d check durations %lldns - %lldns for clocksource %s.\n",
+			testcpu, cs_nsec_min, cs_nsec_max, cs->name);
+}
+
 static void clocksource_watchdog(struct timer_list *unused)
 {
 	u64 csnow, wdnow, cslast, wdlast, delta;
@@ -448,6 +502,12 @@ static int __clocksource_watchdog_kthread(void)
 	unsigned long flags;
 	int select = 0;
 
+	/* Do any required per-CPU skew verification. */
+	if (curr_clocksource &&
+	    curr_clocksource->flags & CLOCK_SOURCE_UNSTABLE &&
+	    curr_clocksource->flags & CLOCK_SOURCE_VERIFY_PERCPU)
+		clocksource_verify_percpu(curr_clocksource);
+
 	spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
-- 
2.30.2



