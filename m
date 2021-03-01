Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61FD3290F5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhCAURz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242951AbhCAUIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:08:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF43653B2;
        Mon,  1 Mar 2021 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621600;
        bh=GCJs19DoeLErSfoi8zCGSTzUdP4/oT5e5ZMIaXgKmWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixM/5tH4r+Q1zhMa/pNy+cRkoHwg2UZAnrvSSdZf6HH6Oy/czGSa7TvkphFog5RnD
         PjZ07EGUpRx1YFvGjfwaSYd9jkEwX40rUhoMOceqzdc9EKmPodWmPsyKF5ro6fDdi9
         VqQLPs6AI7u72rMs2gZ2Z2HPAivb9xeDzlHJ/KJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt McDonald <gardotd426@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Michael Larabel <Michael@phoronix.com>
Subject: [PATCH 5.11 576/775] cpufreq: ACPI: Set cpuinfo.max_freq directly if max boost is known
Date:   Mon,  1 Mar 2021 17:12:24 +0100
Message-Id: <20210301161229.921005429@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 538b0188da4653b9f4511a114f014354fb6fb7a5 upstream.

Commit 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover
boost frequencies") attempted to address a performance issue involving
acpi-cpufreq, the schedutil governor and scale-invariance on x86 by
extending the frequency tables created by acpi-cpufreq to cover the
entire range of "turbo" (or "boost") frequencies, but that caused
frequencies reported via /proc/cpuinfo and the scaling_cur_freq
attribute in sysfs to change which may confuse users and monitoring
tools.

For this reason, revert the part of commit 3c55e94c0ade adding the
extra entry to the frequency table and use the observation that
in principle cpuinfo.max_freq need not be equal to the maximum
frequency listed in the frequency table for the given policy.

Namely, modify cpufreq_frequency_table_cpuinfo() to allow cpufreq
drivers to set their own cpuinfo.max_freq above that frequency and
change  acpi-cpufreq to set cpuinfo.max_freq to the maximum boost
frequency found via CPPC.

This should be sufficient to let all of the cpufreq subsystem know
the real maximum frequency of the CPU without changing frequency
reporting.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=211305
Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
Reported-by: Matt McDonald <gardotd426@gmail.com>
Tested-by: Matt McDonald <gardotd426@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Tested-by: Michael Larabel <Michael@phoronix.com>
Cc: 5.11+ <stable@vger.kernel.org> # 5.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c |   62 ++++++++++-------------------------------
 drivers/cpufreq/freq_table.c   |    8 ++++-
 2 files changed, 23 insertions(+), 47 deletions(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -54,7 +54,6 @@ struct acpi_cpufreq_data {
 	unsigned int resume;
 	unsigned int cpu_feature;
 	unsigned int acpi_perf_cpu;
-	unsigned int first_perf_state;
 	cpumask_var_t freqdomain_cpus;
 	void (*cpu_freq_write)(struct acpi_pct_register *reg, u32 val);
 	u32 (*cpu_freq_read)(struct acpi_pct_register *reg);
@@ -223,10 +222,10 @@ static unsigned extract_msr(struct cpufr
 
 	perf = to_perf_data(data);
 
-	cpufreq_for_each_entry(pos, policy->freq_table + data->first_perf_state)
+	cpufreq_for_each_entry(pos, policy->freq_table)
 		if (msr == perf->states[pos->driver_data].status)
 			return pos->frequency;
-	return policy->freq_table[data->first_perf_state].frequency;
+	return policy->freq_table[0].frequency;
 }
 
 static unsigned extract_freq(struct cpufreq_policy *policy, u32 val)
@@ -365,7 +364,6 @@ static unsigned int get_cur_freq_on_cpu(
 	struct cpufreq_policy *policy;
 	unsigned int freq;
 	unsigned int cached_freq;
-	unsigned int state;
 
 	pr_debug("%s (%d)\n", __func__, cpu);
 
@@ -377,11 +375,7 @@ static unsigned int get_cur_freq_on_cpu(
 	if (unlikely(!data || !policy->freq_table))
 		return 0;
 
-	state = to_perf_data(data)->state;
-	if (state < data->first_perf_state)
-		state = data->first_perf_state;
-
-	cached_freq = policy->freq_table[state].frequency;
+	cached_freq = policy->freq_table[to_perf_data(data)->state].frequency;
 	freq = extract_freq(policy, get_cur_val(cpumask_of(cpu), data));
 	if (freq != cached_freq) {
 		/*
@@ -680,7 +674,6 @@ static int acpi_cpufreq_cpu_init(struct
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	unsigned int valid_states = 0;
 	unsigned int result = 0;
-	unsigned int state_count;
 	u64 max_boost_ratio;
 	unsigned int i;
 #ifdef CONFIG_SMP
@@ -795,28 +788,8 @@ static int acpi_cpufreq_cpu_init(struct
 		goto err_unreg;
 	}
 
-	state_count = perf->state_count + 1;
-
-	max_boost_ratio = get_max_boost_ratio(cpu);
-	if (max_boost_ratio) {
-		/*
-		 * Make a room for one more entry to represent the highest
-		 * available "boost" frequency.
-		 */
-		state_count++;
-		valid_states++;
-		data->first_perf_state = valid_states;
-	} else {
-		/*
-		 * If the maximum "boost" frequency is unknown, ask the arch
-		 * scale-invariance code to use the "nominal" performance for
-		 * CPU utilization scaling so as to prevent the schedutil
-		 * governor from selecting inadequate CPU frequencies.
-		 */
-		arch_set_max_freq_ratio(true);
-	}
-
-	freq_table = kcalloc(state_count, sizeof(*freq_table), GFP_KERNEL);
+	freq_table = kcalloc(perf->state_count + 1, sizeof(*freq_table),
+			     GFP_KERNEL);
 	if (!freq_table) {
 		result = -ENOMEM;
 		goto err_unreg;
@@ -851,27 +824,25 @@ static int acpi_cpufreq_cpu_init(struct
 	}
 	freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
 
+	max_boost_ratio = get_max_boost_ratio(cpu);
 	if (max_boost_ratio) {
-		unsigned int state = data->first_perf_state;
-		unsigned int freq = freq_table[state].frequency;
+		unsigned int freq = freq_table[0].frequency;
 
 		/*
 		 * Because the loop above sorts the freq_table entries in the
 		 * descending order, freq is the maximum frequency in the table.
 		 * Assume that it corresponds to the CPPC nominal frequency and
-		 * use it to populate the frequency field of the extra "boost"
-		 * frequency entry.
+		 * use it to set cpuinfo.max_freq.
 		 */
-		freq_table[0].frequency = freq * max_boost_ratio >> SCHED_CAPACITY_SHIFT;
+		policy->cpuinfo.max_freq = freq * max_boost_ratio >> SCHED_CAPACITY_SHIFT;
+	} else {
 		/*
-		 * The purpose of the extra "boost" frequency entry is to make
-		 * the rest of cpufreq aware of the real maximum frequency, but
-		 * the way to request it is the same as for the first_perf_state
-		 * entry that is expected to cover the entire range of "boost"
-		 * frequencies of the CPU, so copy the driver_data value from
-		 * that entry.
+		 * If the maximum "boost" frequency is unknown, ask the arch
+		 * scale-invariance code to use the "nominal" performance for
+		 * CPU utilization scaling so as to prevent the schedutil
+		 * governor from selecting inadequate CPU frequencies.
 		 */
-		freq_table[0].driver_data = freq_table[state].driver_data;
+		arch_set_max_freq_ratio(true);
 	}
 
 	policy->freq_table = freq_table;
@@ -947,8 +918,7 @@ static void acpi_cpufreq_cpu_ready(struc
 {
 	struct acpi_processor_performance *perf = per_cpu_ptr(acpi_perf_data,
 							      policy->cpu);
-	struct acpi_cpufreq_data *data = policy->driver_data;
-	unsigned int freq = policy->freq_table[data->first_perf_state].frequency;
+	unsigned int freq = policy->freq_table[0].frequency;
 
 	if (perf->states[0].core_frequency * 1000 != freq)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -52,7 +52,13 @@ int cpufreq_frequency_table_cpuinfo(stru
 	}
 
 	policy->min = policy->cpuinfo.min_freq = min_freq;
-	policy->max = policy->cpuinfo.max_freq = max_freq;
+	policy->max = max_freq;
+	/*
+	 * If the driver has set its own cpuinfo.max_freq above max_freq, leave
+	 * it as is.
+	 */
+	if (policy->cpuinfo.max_freq < max_freq)
+		policy->max = policy->cpuinfo.max_freq = max_freq;
 
 	if (policy->min == ~0)
 		return -EINVAL;


