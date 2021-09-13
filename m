Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C2F408D0C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbhIMNXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240666AbhIMNVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D43761056;
        Mon, 13 Sep 2021 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539209;
        bh=RkS96QyOjb7OR3omMUwiekzvrNEymcOG1MjN4Vg/QOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQUsl9VY1DLoBR6fGk4TyRb7w8Acu7m+vKy3GY+HZqEsIfjujjUjC0foLB8Cv2D7t
         urbmM9xqcS4QPKH7vk6C6B3i9n3HT1rZO/X44CSyXjSgh23OnhYUL8zmmr95IbpPtJ
         oPCN5cItrTlVfoEeJkjEk90KiT8MKPLnV4eqQXHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CCJ Yeh <CCj.Yeh@mediatek.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/144] PM: EM: Increase energy calculation precision
Date:   Mon, 13 Sep 2021 15:14:23 +0200
Message-Id: <20210913131050.706902840@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 7fcc17d0cb12938d2b3507973a6f93fc9ed2c7a1 ]

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/energy_model.h | 16 ++++++++++++++++
 kernel/power/energy_model.c  |  4 +++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
index 73f8c3cb9588..9ee6ccc18424 100644
--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -42,6 +42,22 @@ struct em_perf_domain {
 
 #define EM_CPU_MAX_POWER 0xFFFF
 
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
 	 * active_power() - Provide power at the next capacity state of a CPU
diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 8dac32bd9089..7ef35eb985ba 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -149,7 +149,9 @@ static struct em_perf_domain *em_create_pd(cpumask_t *span, int nr_states,
 	/* Compute the cost of each capacity_state. */
 	fmax = (u64) table[nr_states - 1].frequency;
 	for (i = 0; i < nr_states; i++) {
-		table[i].cost = div64_u64(fmax * table[i].power,
+		unsigned long power_res = em_scale_power(table[i].power);
+
+		table[i].cost = div64_u64(fmax * power_res,
 					  table[i].frequency);
 	}
 
-- 
2.30.2



