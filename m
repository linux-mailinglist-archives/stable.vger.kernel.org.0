Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA7B2F16B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfE3DQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfE3DQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A008E24600;
        Thu, 30 May 2019 03:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186197;
        bh=g9GXAV1aYrM2IeSdlcdt9+gSGt7PsEwDcONjUrPnz7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeyTiYzEhQCf8ix4DSuuCp77bFKbewD5NJjxSJfba8guWREgZqfA9KCgwHMxv0Qk6
         3YsUAvm01D3Xf7ODRr2NTpuiO5hDtAHPcwXZO4Par31Kpc4LeWj2DXSF8magdO4JzZ
         FumWI67cALEuXTfDKZDBGwaprfAz5v8jgszEBwLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Ravikumar Bangoria <ravi.bangoria@in.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/276] powerpc/watchdog: Use hrtimers for per-CPU heartbeat
Date:   Wed, 29 May 2019 20:03:51 -0700
Message-Id: <20190530030530.952077629@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ae3f6e130e8dc6188b59e3b4ebc2f16e9c8d053 ]

Using a jiffies timer creates a dependency on the tick_do_timer_cpu
incrementing jiffies. If that CPU has locked up and jiffies is not
incrementing, the watchdog heartbeat timer for all CPUs stops and
creates false positives and confusing warnings on local CPUs, and
also causes the SMP detector to stop, so the root cause is never
detected.

Fix this by using hrtimer based timers for the watchdog heartbeat,
like the generic kernel hardlockup detector.

Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Reported-by: Ravikumar Bangoria <ravi.bangoria@in.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reported-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/watchdog.c | 81 +++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/kernel/watchdog.c b/arch/powerpc/kernel/watchdog.c
index 3c6ab22a0c4e3..af3c15a1d41eb 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -77,7 +77,7 @@ static u64 wd_smp_panic_timeout_tb __read_mostly; /* panic other CPUs */
 
 static u64 wd_timer_period_ms __read_mostly;  /* interval between heartbeat */
 
-static DEFINE_PER_CPU(struct timer_list, wd_timer);
+static DEFINE_PER_CPU(struct hrtimer, wd_hrtimer);
 static DEFINE_PER_CPU(u64, wd_timer_tb);
 
 /* SMP checker bits */
@@ -293,21 +293,21 @@ void soft_nmi_interrupt(struct pt_regs *regs)
 	nmi_exit();
 }
 
-static void wd_timer_reset(unsigned int cpu, struct timer_list *t)
-{
-	t->expires = jiffies + msecs_to_jiffies(wd_timer_period_ms);
-	if (wd_timer_period_ms > 1000)
-		t->expires = __round_jiffies_up(t->expires, cpu);
-	add_timer_on(t, cpu);
-}
-
-static void wd_timer_fn(struct timer_list *t)
+static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 {
 	int cpu = smp_processor_id();
 
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		return HRTIMER_NORESTART;
+
+	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
+		return HRTIMER_NORESTART;
+
 	watchdog_timer_interrupt(cpu);
 
-	wd_timer_reset(cpu, t);
+	hrtimer_forward_now(hrtimer, ms_to_ktime(wd_timer_period_ms));
+
+	return HRTIMER_RESTART;
 }
 
 void arch_touch_nmi_watchdog(void)
@@ -323,37 +323,22 @@ void arch_touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(arch_touch_nmi_watchdog);
 
-static void start_watchdog_timer_on(unsigned int cpu)
-{
-	struct timer_list *t = per_cpu_ptr(&wd_timer, cpu);
-
-	per_cpu(wd_timer_tb, cpu) = get_tb();
-
-	timer_setup(t, wd_timer_fn, TIMER_PINNED);
-	wd_timer_reset(cpu, t);
-}
-
-static void stop_watchdog_timer_on(unsigned int cpu)
-{
-	struct timer_list *t = per_cpu_ptr(&wd_timer, cpu);
-
-	del_timer_sync(t);
-}
-
-static int start_wd_on_cpu(unsigned int cpu)
+static void start_watchdog(void *arg)
 {
+	struct hrtimer *hrtimer = this_cpu_ptr(&wd_hrtimer);
+	int cpu = smp_processor_id();
 	unsigned long flags;
 
 	if (cpumask_test_cpu(cpu, &wd_cpus_enabled)) {
 		WARN_ON(1);
-		return 0;
+		return;
 	}
 
 	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
-		return 0;
+		return;
 
 	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
-		return 0;
+		return;
 
 	wd_smp_lock(&flags);
 	cpumask_set_cpu(cpu, &wd_cpus_enabled);
@@ -363,27 +348,40 @@ static int start_wd_on_cpu(unsigned int cpu)
 	}
 	wd_smp_unlock(&flags);
 
-	start_watchdog_timer_on(cpu);
+	*this_cpu_ptr(&wd_timer_tb) = get_tb();
 
-	return 0;
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+	hrtimer_start(hrtimer, ms_to_ktime(wd_timer_period_ms),
+		      HRTIMER_MODE_REL_PINNED);
 }
 
-static int stop_wd_on_cpu(unsigned int cpu)
+static int start_watchdog_on_cpu(unsigned int cpu)
 {
+	return smp_call_function_single(cpu, start_watchdog, NULL, true);
+}
+
+static void stop_watchdog(void *arg)
+{
+	struct hrtimer *hrtimer = this_cpu_ptr(&wd_hrtimer);
+	int cpu = smp_processor_id();
 	unsigned long flags;
 
 	if (!cpumask_test_cpu(cpu, &wd_cpus_enabled))
-		return 0; /* Can happen in CPU unplug case */
+		return; /* Can happen in CPU unplug case */
 
-	stop_watchdog_timer_on(cpu);
+	hrtimer_cancel(hrtimer);
 
 	wd_smp_lock(&flags);
 	cpumask_clear_cpu(cpu, &wd_cpus_enabled);
 	wd_smp_unlock(&flags);
 
 	wd_smp_clear_cpu_pending(cpu, get_tb());
+}
 
-	return 0;
+static int stop_watchdog_on_cpu(unsigned int cpu)
+{
+	return smp_call_function_single(cpu, stop_watchdog, NULL, true);
 }
 
 static void watchdog_calc_timeouts(void)
@@ -402,7 +400,7 @@ void watchdog_nmi_stop(void)
 	int cpu;
 
 	for_each_cpu(cpu, &wd_cpus_enabled)
-		stop_wd_on_cpu(cpu);
+		stop_watchdog_on_cpu(cpu);
 }
 
 void watchdog_nmi_start(void)
@@ -411,7 +409,7 @@ void watchdog_nmi_start(void)
 
 	watchdog_calc_timeouts();
 	for_each_cpu_and(cpu, cpu_online_mask, &watchdog_cpumask)
-		start_wd_on_cpu(cpu);
+		start_watchdog_on_cpu(cpu);
 }
 
 /*
@@ -423,7 +421,8 @@ int __init watchdog_nmi_probe(void)
 
 	err = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
 					"powerpc/watchdog:online",
-					start_wd_on_cpu, stop_wd_on_cpu);
+					start_watchdog_on_cpu,
+					stop_watchdog_on_cpu);
 	if (err < 0) {
 		pr_warn("could not be initialized");
 		return err;
-- 
2.20.1



