Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38963DEAE6
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhHCK2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:28:20 -0400
Received: from foss.arm.com ([217.140.110.172]:46794 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhHCK2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 06:28:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4ABB106F;
        Tue,  3 Aug 2021 03:28:07 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.9.94])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA3D43F40C;
        Tue,  3 Aug 2021 03:28:02 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Chris.Redpath@arm.com, lukasz.luba@arm.com,
        dietmar.eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, vincent.guittot@linaro.org,
        mingo@redhat.com, juri.lelli@redhat.com, rostedt@goodmis.org,
        segall@google.com, mgorman@suse.de, bristot@redhat.com,
        CCj.Yeh@mediatek.com
Subject: [PATCH v3] PM: EM: Increase energy calculation precision
Date:   Tue,  3 Aug 2021 11:27:43 +0100
Message-Id: <20210803102744.23654-1-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Energy Model (EM) provides useful information about device power in
each performance state to other subsystems like: Energy Aware Scheduler
(EAS). The energy calculation in EAS does arithmetic operation based on
the EM em_cpu_energy(). Current implementation of that function uses
em_perf_state::cost as a pre-computed cost coefficient equal to:
cost = power * max_frequency / frequency.
The 'power' is expressed in milli-Watts (or in abstract scale).

There are corner cases when the EAS energy calculation for two Performance
Domains (PDs) return the same value. The EAS compares these values to
choose smaller one. It might happen that this values are equal due to
rounding error. In such scenario, we need better resolution, e.g. 1000
times better. To provide this possibility increase the resolution in the
em_perf_state::cost for 64-bit architectures. The cost of increasing
resolution on 32-bit is pretty high (64-bit division) and is not justified
since there are no new 32bit big.LITTLE EAS systems expected which would
benefit from this higher resolution.

This patch allows to avoid the rounding to milli-Watt errors, which might
occur in EAS energy estimation for each PD. The rounding error is common
for small tasks which have small utilization value.

There are two places in the code where it makes a difference:
1. In the find_energy_efficient_cpu() where we are searching for
best_delta. We might suffer there when two PDs return the same result,
like in the example below.

Scenario:
Low utilized system e.g. ~200 sum_util for PD0 and ~220 for PD1. There
are quite a few small tasks ~10-15 util. These tasks would suffer for
the rounding error. These utilization values are typical when running games
on Android. One of our partners has reported 5..10mA less battery drain
when running with increased resolution.

Some details:
We have two PDs: PD0 (big) and PD1 (little)
Let's compare w/o patch set ('old') and w/ patch set ('new')
We are comparing energy w/ task and w/o task placed in the PDs

a) 'old' w/o patch set, PD0
task_util = 13
cost = 480
sum_util_w/o_task = 215
sum_util_w_task = 228
scale_cpu = 1024
energy_w/o_task = 480 * 215 / 1024 = 100.78 => 100
energy_w_task = 480 * 228 / 1024 = 106.87 => 106
energy_diff = 106 - 100 = 6
(this is equal to 'old' PD1's energy_diff in 'c)')

b) 'new' w/ patch set, PD0
task_util = 13
cost = 480 * 1000 = 480000
sum_util_w/o_task = 215
sum_util_w_task = 228
energy_w/o_task = 480000 * 215 / 1024 = 100781
energy_w_task = 480000 * 228 / 1024  = 106875
energy_diff = 106875 - 100781 = 6094
(this is not equal to 'new' PD1's energy_diff in 'd)')

c) 'old' w/o patch set, PD1
task_util = 13
cost = 160
sum_util_w/o_task = 283
sum_util_w_task = 293
scale_cpu = 355
energy_w/o_task = 160 * 283 / 355 = 127.55 => 127
energy_w_task = 160 * 296 / 355 = 133.41 => 133
energy_diff = 133 - 127 = 6
(this is equal to 'old' PD0's energy_diff in 'a)')

d) 'new' w/ patch set, PD1
task_util = 13
cost = 160 * 1000 = 160000
sum_util_w/o_task = 283
sum_util_w_task = 293
scale_cpu = 355
energy_w/o_task = 160000 * 283 / 355 = 127549
energy_w_task = 160000 * 296 / 355 =   133408
energy_diff = 133408 - 127549 = 5859
(this is not equal to 'new' PD0's energy_diff in 'b)')

2. Difference in the 6% energy margin filter at the end of
find_energy_efficient_cpu(). With this patch the margin comparison also
has better resolution, so it's possible to have better task placement
thanks to that.

Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
---

v3 changes:
- adjusted patch description according to Dietmar's comments
- added Dietmar's review tag
- added one empty line in the code to separate them

 include/linux/energy_model.h | 16 ++++++++++++++++
 kernel/power/energy_model.c  |  4 +++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
index 3f221dbf5f95..1834752c5617 100644
--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -53,6 +53,22 @@ struct em_perf_domain {
 #ifdef CONFIG_ENERGY_MODEL
 #define EM_MAX_POWER 0xFFFF
 
+/*
+ * Increase resolution of energy estimation calculations for 64-bit
+ * architectures. The extra resolution improves decision made by EAS for the
+ * task placement when two Performance Domains might provide similar energy
+ * estimation values (w/o better resolution the values could be equal).
+ *
+ * We increase resolution only if we have enough bits to allow this increased
+ * resolution (i.e. 64-bit). The costs for increasing resolution when 32-bit
+ * are pretty high and the returns do not justify the increased costs.
+ */
+#ifdef CONFIG_64BIT
+#define em_scale_power(p) ((p) * 1000)
+#else
+#define em_scale_power(p) (p)
+#endif
+
 struct em_data_callback {
 	/**
 	 * active_power() - Provide power at the next performance state of
diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 0f4530b3a8cd..a332ccd829e2 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -170,7 +170,9 @@ static int em_create_perf_table(struct device *dev, struct em_perf_domain *pd,
 	/* Compute the cost of each performance state. */
 	fmax = (u64) table[nr_states - 1].frequency;
 	for (i = 0; i < nr_states; i++) {
-		table[i].cost = div64_u64(fmax * table[i].power,
+		unsigned long power_res = em_scale_power(table[i].power);
+
+		table[i].cost = div64_u64(fmax * power_res,
 					  table[i].frequency);
 	}
 
-- 
2.17.1

