Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3933731BD37
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhBOPmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhBOPiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9D464EAF;
        Mon, 15 Feb 2021 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403263;
        bh=mMPrxCT1XWxivrN7xGi7Vx7fXhgOY4Su49X4pRyt2Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyC3dk7lWf/bzv2fPP5eYSvzERlUn9RAMe4MG9dURSISkrT5XVxF0mq4xqavZtqgd
         bIDt8d0xI3wpSRhNnM4vs6Nb09Huzl5YEqj1Jx5HmhW6vCH5F8K4xv1CGMDpcyykrO
         kd5wJhtwrqHuhdOXt8X5bH9l44eSFUuZWdE6ayIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Larabel <Michael@phoronix.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>
Subject: [PATCH 5.10 090/104] cpufreq: ACPI: Extend frequency tables to cover boost frequencies
Date:   Mon, 15 Feb 2021 16:27:43 +0100
Message-Id: <20210215152722.366320311@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 3c55e94c0adea4a5389c4b80f6ae9927dd6a4501 upstream.

A severe performance regression on AMD EPYC processors when using
the schedutil scaling governor was discovered by Phoronix.com and
attributed to the following commits:

  41ea667227ba ("x86, sched: Calculate frequency invariance for AMD
  systems")

  976df7e5730e ("x86, sched: Use midpoint of max_boost and max_P for
  frequency invariance on AMD EPYC")

The source of the problem is that the maximum performance level taken
for computing the arch_max_freq_ratio value used in the x86 scale-
invariance code is higher than the one corresponding to the
cpuinfo.max_freq value coming from the acpi_cpufreq driver.

This effectively causes the scale-invariant utilization to fall below
100% even if the CPU runs at cpuinfo.max_freq or slightly faster, so
the schedutil governor selects a frequency below cpuinfo.max_freq
then.  That frequency corresponds to a frequency table entry below
the maximum performance level necessary to get to the "boost" range
of CPU frequencies.

However, if the cpuinfo.max_freq value coming from acpi_cpufreq was
higher, the schedutil governor would select higher frequencies which
in turn would allow acpi_cpufreq to set more adequate performance
levels and to get to the "boost" range of CPU frequencies more often.

This issue affects any systems where acpi_cpufreq is used and the
"boost" (or "turbo") frequencies are enabled, not just AMD EPYC.
Moreover, commit db865272d9c4 ("cpufreq: Avoid configuring old
governors as default with intel_pstate") from the 5.10 development
cycle made it extremely easy to default to schedutil even if the
preferred driver is acpi_cpufreq as long as intel_pstate is built
too, because the mere presence of the latter effectively removes the
ondemand governor from the defaults.  Distro kernels are likely to
include both intel_pstate and acpi_cpufreq on x86, so their users
who cannot use intel_pstate or choose to use acpi_cpufreq may
easily be affectecd by this issue.

To address this issue, extend the frequency table constructed by
acpi_cpufreq for each CPU to cover the entire range of available
frequencies (including the "boost" ones) if CPPC is available and
indicates that "boost" (or "turbo") frequencies are enabled.  That
causes cpuinfo.max_freq to become the maximum "boost" frequency of
the given CPU (instead of the maximum frequency returned by the ACPI
_PSS object that corresponds to the "nominal" performance level).

Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
Fixes: 976df7e5730e ("x86, sched: Use midpoint of max_boost and max_P for frequency invariance on AMD EPYC")
Fixes: db865272d9c4 ("cpufreq: Avoid configuring old governors as default with intel_pstate")
Link: https://www.phoronix.com/scan.php?page=article&item=linux511-amd-schedutil&num=1
Link: https://lore.kernel.org/linux-pm/20210203135321.12253-2-ggherdovich@suse.cz/
Reported-by: Michael Larabel <Michael@phoronix.com>
Diagnosed-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Reviewed-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Tested-by: Michael Larabel <Michael@phoronix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 107 +++++++++++++++++++++++++++++----
 1 file changed, 95 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 1e4fbb002a31..4614f1c6f50a 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -26,6 +26,7 @@
 #include <linux/uaccess.h>
 
 #include <acpi/processor.h>
+#include <acpi/cppc_acpi.h>
 
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -53,6 +54,7 @@ struct acpi_cpufreq_data {
 	unsigned int resume;
 	unsigned int cpu_feature;
 	unsigned int acpi_perf_cpu;
+	unsigned int first_perf_state;
 	cpumask_var_t freqdomain_cpus;
 	void (*cpu_freq_write)(struct acpi_pct_register *reg, u32 val);
 	u32 (*cpu_freq_read)(struct acpi_pct_register *reg);
@@ -221,10 +223,10 @@ static unsigned extract_msr(struct cpufreq_policy *policy, u32 msr)
 
 	perf = to_perf_data(data);
 
-	cpufreq_for_each_entry(pos, policy->freq_table)
+	cpufreq_for_each_entry(pos, policy->freq_table + data->first_perf_state)
 		if (msr == perf->states[pos->driver_data].status)
 			return pos->frequency;
-	return policy->freq_table[0].frequency;
+	return policy->freq_table[data->first_perf_state].frequency;
 }
 
 static unsigned extract_freq(struct cpufreq_policy *policy, u32 val)
@@ -363,6 +365,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	struct cpufreq_policy *policy;
 	unsigned int freq;
 	unsigned int cached_freq;
+	unsigned int state;
 
 	pr_debug("%s (%d)\n", __func__, cpu);
 
@@ -374,7 +377,11 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	if (unlikely(!data || !policy->freq_table))
 		return 0;
 
-	cached_freq = policy->freq_table[to_perf_data(data)->state].frequency;
+	state = to_perf_data(data)->state;
+	if (state < data->first_perf_state)
+		state = data->first_perf_state;
+
+	cached_freq = policy->freq_table[state].frequency;
 	freq = extract_freq(policy, get_cur_val(cpumask_of(cpu), data));
 	if (freq != cached_freq) {
 		/*
@@ -628,16 +635,54 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
 }
 #endif
 
+#ifdef CONFIG_ACPI_CPPC_LIB
+static u64 get_max_boost_ratio(unsigned int cpu)
+{
+	struct cppc_perf_caps perf_caps;
+	u64 highest_perf, nominal_perf;
+	int ret;
+
+	if (acpi_pstate_strict)
+		return 0;
+
+	ret = cppc_get_perf_caps(cpu, &perf_caps);
+	if (ret) {
+		pr_debug("CPU%d: Unable to get performance capabilities (%d)\n",
+			 cpu, ret);
+		return 0;
+	}
+
+	highest_perf = perf_caps.highest_perf;
+	nominal_perf = perf_caps.nominal_perf;
+
+	if (!highest_perf || !nominal_perf) {
+		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);
+		return 0;
+	}
+
+	if (highest_perf < nominal_perf) {
+		pr_debug("CPU%d: nominal performance above highest\n", cpu);
+		return 0;
+	}
+
+	return div_u64(highest_perf << SCHED_CAPACITY_SHIFT, nominal_perf);
+}
+#else
+static inline u64 get_max_boost_ratio(unsigned int cpu) { return 0; }
+#endif
+
 static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	unsigned int i;
-	unsigned int valid_states = 0;
-	unsigned int cpu = policy->cpu;
+	struct cpufreq_frequency_table *freq_table;
+	struct acpi_processor_performance *perf;
 	struct acpi_cpufreq_data *data;
+	unsigned int cpu = policy->cpu;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	unsigned int valid_states = 0;
 	unsigned int result = 0;
-	struct cpuinfo_x86 *c = &cpu_data(policy->cpu);
-	struct acpi_processor_performance *perf;
-	struct cpufreq_frequency_table *freq_table;
+	unsigned int state_count;
+	u64 max_boost_ratio;
+	unsigned int i;
 #ifdef CONFIG_SMP
 	static int blacklisted;
 #endif
@@ -750,8 +795,20 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		goto err_unreg;
 	}
 
-	freq_table = kcalloc(perf->state_count + 1, sizeof(*freq_table),
-			     GFP_KERNEL);
+	state_count = perf->state_count + 1;
+
+	max_boost_ratio = get_max_boost_ratio(cpu);
+	if (max_boost_ratio) {
+		/*
+		 * Make a room for one more entry to represent the highest
+		 * available "boost" frequency.
+		 */
+		state_count++;
+		valid_states++;
+		data->first_perf_state = valid_states;
+	}
+
+	freq_table = kcalloc(state_count, sizeof(*freq_table), GFP_KERNEL);
 	if (!freq_table) {
 		result = -ENOMEM;
 		goto err_unreg;
@@ -785,6 +842,30 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		valid_states++;
 	}
 	freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
+
+	if (max_boost_ratio) {
+		unsigned int state = data->first_perf_state;
+		unsigned int freq = freq_table[state].frequency;
+
+		/*
+		 * Because the loop above sorts the freq_table entries in the
+		 * descending order, freq is the maximum frequency in the table.
+		 * Assume that it corresponds to the CPPC nominal frequency and
+		 * use it to populate the frequency field of the extra "boost"
+		 * frequency entry.
+		 */
+		freq_table[0].frequency = freq * max_boost_ratio >> SCHED_CAPACITY_SHIFT;
+		/*
+		 * The purpose of the extra "boost" frequency entry is to make
+		 * the rest of cpufreq aware of the real maximum frequency, but
+		 * the way to request it is the same as for the first_perf_state
+		 * entry that is expected to cover the entire range of "boost"
+		 * frequencies of the CPU, so copy the driver_data value from
+		 * that entry.
+		 */
+		freq_table[0].driver_data = freq_table[state].driver_data;
+	}
+
 	policy->freq_table = freq_table;
 	perf->state = 0;
 
@@ -858,8 +939,10 @@ static void acpi_cpufreq_cpu_ready(struct cpufreq_policy *policy)
 {
 	struct acpi_processor_performance *perf = per_cpu_ptr(acpi_perf_data,
 							      policy->cpu);
+	struct acpi_cpufreq_data *data = policy->driver_data;
+	unsigned int freq = policy->freq_table[data->first_perf_state].frequency;
 
-	if (perf->states[0].core_frequency * 1000 != policy->cpuinfo.max_freq)
+	if (perf->states[0].core_frequency * 1000 != freq)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
 }
 
-- 
2.30.1



