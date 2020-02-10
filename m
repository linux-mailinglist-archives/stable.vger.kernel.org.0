Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA4157A2C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgBJNUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbgBJMhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22C7420842;
        Mon, 10 Feb 2020 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338257;
        bh=vptbUSVyRzAyodCaiJ6pLNIi9GVtVJnxZkFc1gOMepg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAbngvslt8acHT06Ntqg8fKL50Gl6f/2KRZrEOc38UEwlRJQS4V9kovXd1qLeoJuN
         C+r0Sv2gk+zQUtIJv/hvd91ZLqRz+reP79f1LfpqnMEM82B3XePuZ8bbbgWAIRxvN8
         wBkvaa1CZY3mzxNo5pDnafjqQB65y3/nE5vnegeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.4 124/309] cpufreq: Avoid creating excessively large stack frames
Date:   Mon, 10 Feb 2020 04:31:20 -0800
Message-Id: <20200210122418.356401521@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1e4f63aecb53e48468661e922fc2fa3b83e55722 upstream.

In the process of modifying a cpufreq policy, the cpufreq core makes
a copy of it including all of the internals which is stored on the
CPU stack.  Because struct cpufreq_policy is relatively large, this
may cause the size of the stack frame to exceed the 2 KB limit and
so the GCC complains when -Wframe-larger-than= is used.

In fact, it is not necessary to copy the entire policy structure
in order to modify it, however.

First, because cpufreq_set_policy() obtains the min and max policy
limits from frequency QoS now, it is not necessary to pass the limits
to it from the callers.  The only things that need to be passed to it
from there are the new governor pointer or (if there is a built-in
governor in the driver) the "policy" value representing the governor
choice.  They both can be passed as individual arguments, though, so
make cpufreq_set_policy() take them this way and rework its callers
accordingly.  This avoids making copies of cpufreq policies in the
callers of cpufreq_set_policy().

Second, cpufreq_set_policy() still needs to pass the new policy
data to the ->verify() callback of the cpufreq driver whose task
is to sanitize the min and max policy limits.  It still does not
need to make a full copy of struct cpufreq_policy for this purpose,
but it needs to pass a few items from it to the driver in case they
are needed (different drivers have different needs in that respect
and all of them have to be covered).  For this reason, introduce
struct cpufreq_policy_data to hold copies of the members of
struct cpufreq_policy used by the existing ->verify() driver
callbacks and pass a pointer to a temporary structure of that
type to ->verify() (instead of passing a pointer to full struct
cpufreq_policy to it).

While at it, notice that intel_pstate and longrun don't really need
to verify the "policy" value in struct cpufreq_policy, so drop those
check from them to avoid copying "policy" into struct
cpufreq_policy_data (which allows it to be slightly smaller).

Also while at it fix up white space in a couple of places and make
cpufreq_set_policy() static (as it can be so).

Fixes: 3000ce3c52f8 ("cpufreq: Use per-policy frequency QoS")
Link: https://lore.kernel.org/linux-pm/CAMuHMdX6-jb1W8uC2_237m8ctCpsnGp=JCxqt8pCWVqNXHmkVg@mail.gmail.com
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cppc_cpufreq.c     |    2 
 drivers/cpufreq/cpufreq-nforce2.c  |    2 
 drivers/cpufreq/cpufreq.c          |  147 +++++++++++++++++--------------------
 drivers/cpufreq/freq_table.c       |    4 -
 drivers/cpufreq/gx-suspmod.c       |    2 
 drivers/cpufreq/intel_pstate.c     |   38 ++++-----
 drivers/cpufreq/longrun.c          |    6 -
 drivers/cpufreq/pcc-cpufreq.c      |    2 
 drivers/cpufreq/sh-cpufreq.c       |    2 
 drivers/cpufreq/unicore2-cpufreq.c |    2 
 include/linux/cpufreq.h            |   32 +++++---
 11 files changed, 119 insertions(+), 120 deletions(-)

--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -217,7 +217,7 @@ static int cppc_cpufreq_set_target(struc
 	return ret;
 }
 
-static int cppc_verify_policy(struct cpufreq_policy *policy)
+static int cppc_verify_policy(struct cpufreq_policy_data *policy)
 {
 	cpufreq_verify_within_cpu_limits(policy);
 	return 0;
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -291,7 +291,7 @@ static int nforce2_target(struct cpufreq
  * nforce2_verify - verifies a new CPUFreq policy
  * @policy: new policy
  */
-static int nforce2_verify(struct cpufreq_policy *policy)
+static int nforce2_verify(struct cpufreq_policy_data *policy)
 {
 	unsigned int fsb_pol_max;
 
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -74,6 +74,9 @@ static void cpufreq_exit_governor(struct
 static int cpufreq_start_governor(struct cpufreq_policy *policy);
 static void cpufreq_stop_governor(struct cpufreq_policy *policy);
 static void cpufreq_governor_limits(struct cpufreq_policy *policy);
+static int cpufreq_set_policy(struct cpufreq_policy *policy,
+			      struct cpufreq_governor *new_gov,
+			      unsigned int new_pol);
 
 /**
  * Two notifier lists: the "policy" list is involved in the
@@ -613,25 +616,22 @@ static struct cpufreq_governor *find_gov
 	return NULL;
 }
 
-static int cpufreq_parse_policy(char *str_governor,
-				struct cpufreq_policy *policy)
+static unsigned int cpufreq_parse_policy(char *str_governor)
 {
-	if (!strncasecmp(str_governor, "performance", CPUFREQ_NAME_LEN)) {
-		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
-		return 0;
-	}
-	if (!strncasecmp(str_governor, "powersave", CPUFREQ_NAME_LEN)) {
-		policy->policy = CPUFREQ_POLICY_POWERSAVE;
-		return 0;
-	}
-	return -EINVAL;
+	if (!strncasecmp(str_governor, "performance", CPUFREQ_NAME_LEN))
+		return CPUFREQ_POLICY_PERFORMANCE;
+
+	if (!strncasecmp(str_governor, "powersave", CPUFREQ_NAME_LEN))
+		return CPUFREQ_POLICY_POWERSAVE;
+
+	return CPUFREQ_POLICY_UNKNOWN;
 }
 
 /**
  * cpufreq_parse_governor - parse a governor string only for has_target()
+ * @str_governor: Governor name.
  */
-static int cpufreq_parse_governor(char *str_governor,
-				  struct cpufreq_policy *policy)
+static struct cpufreq_governor *cpufreq_parse_governor(char *str_governor)
 {
 	struct cpufreq_governor *t;
 
@@ -645,7 +645,7 @@ static int cpufreq_parse_governor(char *
 
 		ret = request_module("cpufreq_%s", str_governor);
 		if (ret)
-			return -EINVAL;
+			return NULL;
 
 		mutex_lock(&cpufreq_governor_mutex);
 
@@ -656,12 +656,7 @@ static int cpufreq_parse_governor(char *
 
 	mutex_unlock(&cpufreq_governor_mutex);
 
-	if (t) {
-		policy->governor = t;
-		return 0;
-	}
-
-	return -EINVAL;
+	return t;
 }
 
 /**
@@ -762,28 +757,33 @@ static ssize_t show_scaling_governor(str
 static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
 					const char *buf, size_t count)
 {
+	char str_governor[16];
 	int ret;
-	char	str_governor[16];
-	struct cpufreq_policy new_policy;
-
-	memcpy(&new_policy, policy, sizeof(*policy));
 
 	ret = sscanf(buf, "%15s", str_governor);
 	if (ret != 1)
 		return -EINVAL;
 
 	if (cpufreq_driver->setpolicy) {
-		if (cpufreq_parse_policy(str_governor, &new_policy))
+		unsigned int new_pol;
+
+		new_pol = cpufreq_parse_policy(str_governor);
+		if (!new_pol)
 			return -EINVAL;
+
+		ret = cpufreq_set_policy(policy, NULL, new_pol);
 	} else {
-		if (cpufreq_parse_governor(str_governor, &new_policy))
+		struct cpufreq_governor *new_gov;
+
+		new_gov = cpufreq_parse_governor(str_governor);
+		if (!new_gov)
 			return -EINVAL;
-	}
 
-	ret = cpufreq_set_policy(policy, &new_policy);
+		ret = cpufreq_set_policy(policy, new_gov,
+					 CPUFREQ_POLICY_UNKNOWN);
 
-	if (new_policy.governor)
-		module_put(new_policy.governor->owner);
+		module_put(new_gov->owner);
+	}
 
 	return ret ? ret : count;
 }
@@ -1050,40 +1050,33 @@ __weak struct cpufreq_governor *cpufreq_
 
 static int cpufreq_init_policy(struct cpufreq_policy *policy)
 {
-	struct cpufreq_governor *gov = NULL, *def_gov = NULL;
-	struct cpufreq_policy new_policy;
-
-	memcpy(&new_policy, policy, sizeof(*policy));
-
-	def_gov = cpufreq_default_governor();
+	struct cpufreq_governor *def_gov = cpufreq_default_governor();
+	struct cpufreq_governor *gov = NULL;
+	unsigned int pol = CPUFREQ_POLICY_UNKNOWN;
 
 	if (has_target()) {
-		/*
-		 * Update governor of new_policy to the governor used before
-		 * hotplug
-		 */
+		/* Update policy governor to the one used before hotplug. */
 		gov = find_governor(policy->last_governor);
 		if (gov) {
 			pr_debug("Restoring governor %s for cpu %d\n",
-				policy->governor->name, policy->cpu);
-		} else {
-			if (!def_gov)
-				return -ENODATA;
+				 policy->governor->name, policy->cpu);
+		} else if (def_gov) {
 			gov = def_gov;
+		} else {
+			return -ENODATA;
 		}
-		new_policy.governor = gov;
 	} else {
 		/* Use the default policy if there is no last_policy. */
 		if (policy->last_policy) {
-			new_policy.policy = policy->last_policy;
+			pol = policy->last_policy;
+		} else if (def_gov) {
+			pol = cpufreq_parse_policy(def_gov->name);
 		} else {
-			if (!def_gov)
-				return -ENODATA;
-			cpufreq_parse_policy(def_gov->name, &new_policy);
+			return -ENODATA;
 		}
 	}
 
-	return cpufreq_set_policy(policy, &new_policy);
+	return cpufreq_set_policy(policy, gov, pol);
 }
 
 static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
@@ -1111,13 +1104,10 @@ static int cpufreq_add_policy_cpu(struct
 
 void refresh_frequency_limits(struct cpufreq_policy *policy)
 {
-	struct cpufreq_policy new_policy;
-
 	if (!policy_is_inactive(policy)) {
-		new_policy = *policy;
 		pr_debug("updating policy for CPU %u\n", policy->cpu);
 
-		cpufreq_set_policy(policy, &new_policy);
+		cpufreq_set_policy(policy, policy->governor, policy->policy);
 	}
 }
 EXPORT_SYMBOL(refresh_frequency_limits);
@@ -2361,43 +2351,46 @@ EXPORT_SYMBOL(cpufreq_get_policy);
 /**
  * cpufreq_set_policy - Modify cpufreq policy parameters.
  * @policy: Policy object to modify.
- * @new_policy: New policy data.
+ * @new_gov: Policy governor pointer.
+ * @new_pol: Policy value (for drivers with built-in governors).
  *
- * Pass @new_policy to the cpufreq driver's ->verify() callback. Next, copy the
- * min and max parameters of @new_policy to @policy and either invoke the
- * driver's ->setpolicy() callback (if present) or carry out a governor update
- * for @policy.  That is, run the current governor's ->limits() callback (if the
- * governor field in @new_policy points to the same object as the one in
- * @policy) or replace the governor for @policy with the new one stored in
- * @new_policy.
+ * Invoke the cpufreq driver's ->verify() callback to sanity-check the frequency
+ * limits to be set for the policy, update @policy with the verified limits
+ * values and either invoke the driver's ->setpolicy() callback (if present) or
+ * carry out a governor update for @policy.  That is, run the current governor's
+ * ->limits() callback (if @new_gov points to the same object as the one in
+ * @policy) or replace the governor for @policy with @new_gov.
  *
  * The cpuinfo part of @policy is not updated by this function.
  */
-int cpufreq_set_policy(struct cpufreq_policy *policy,
-		       struct cpufreq_policy *new_policy)
+static int cpufreq_set_policy(struct cpufreq_policy *policy,
+			      struct cpufreq_governor *new_gov,
+			      unsigned int new_pol)
 {
+	struct cpufreq_policy_data new_data;
 	struct cpufreq_governor *old_gov;
 	int ret;
 
-	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
-		 new_policy->cpu, new_policy->min, new_policy->max);
-
-	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
-
+	memcpy(&new_data.cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
+	new_data.freq_table = policy->freq_table;
+	new_data.cpu = policy->cpu;
 	/*
 	 * PM QoS framework collects all the requests from users and provide us
 	 * the final aggregated value here.
 	 */
-	new_policy->min = freq_qos_read_value(&policy->constraints, FREQ_QOS_MIN);
-	new_policy->max = freq_qos_read_value(&policy->constraints, FREQ_QOS_MAX);
+	new_data.min = freq_qos_read_value(&policy->constraints, FREQ_QOS_MIN);
+	new_data.max = freq_qos_read_value(&policy->constraints, FREQ_QOS_MAX);
+
+	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
+		 new_data.cpu, new_data.min, new_data.max);
 
 	/* verify the cpu speed can be set within this limit */
-	ret = cpufreq_driver->verify(new_policy);
+	ret = cpufreq_driver->verify(&new_data);
 	if (ret)
 		return ret;
 
-	policy->min = new_policy->min;
-	policy->max = new_policy->max;
+	policy->min = new_data.min;
+	policy->max = new_data.max;
 	trace_cpu_frequency_limits(policy);
 
 	policy->cached_target_freq = UINT_MAX;
@@ -2406,12 +2399,12 @@ int cpufreq_set_policy(struct cpufreq_po
 		 policy->min, policy->max);
 
 	if (cpufreq_driver->setpolicy) {
-		policy->policy = new_policy->policy;
+		policy->policy = new_pol;
 		pr_debug("setting range\n");
 		return cpufreq_driver->setpolicy(policy);
 	}
 
-	if (new_policy->governor == policy->governor) {
+	if (new_gov == policy->governor) {
 		pr_debug("governor limits update\n");
 		cpufreq_governor_limits(policy);
 		return 0;
@@ -2428,7 +2421,7 @@ int cpufreq_set_policy(struct cpufreq_po
 	}
 
 	/* start new governor */
-	policy->governor = new_policy->governor;
+	policy->governor = new_gov;
 	ret = cpufreq_init_governor(policy);
 	if (!ret) {
 		ret = cpufreq_start_governor(policy);
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -60,7 +60,7 @@ int cpufreq_frequency_table_cpuinfo(stru
 		return 0;
 }
 
-int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
+int cpufreq_frequency_table_verify(struct cpufreq_policy_data *policy,
 				   struct cpufreq_frequency_table *table)
 {
 	struct cpufreq_frequency_table *pos;
@@ -100,7 +100,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_tabl
  * Generic routine to verify policy & frequency table, requires driver to set
  * policy->freq_table prior to it.
  */
-int cpufreq_generic_frequency_table_verify(struct cpufreq_policy *policy)
+int cpufreq_generic_frequency_table_verify(struct cpufreq_policy_data *policy)
 {
 	if (!policy->freq_table)
 		return -ENODEV;
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -328,7 +328,7 @@ static void gx_set_cpuspeed(struct cpufr
  *      for the hardware supported by the driver.
  */
 
-static int cpufreq_gx_verify(struct cpufreq_policy *policy)
+static int cpufreq_gx_verify(struct cpufreq_policy_data *policy)
 {
 	unsigned int tmp_freq = 0;
 	u8 tmp1, tmp2;
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2036,8 +2036,9 @@ static int intel_pstate_get_max_freq(str
 			cpu->pstate.max_freq : cpu->pstate.turbo_freq;
 }
 
-static void intel_pstate_update_perf_limits(struct cpufreq_policy *policy,
-					    struct cpudata *cpu)
+static void intel_pstate_update_perf_limits(struct cpudata *cpu,
+					    unsigned int policy_min,
+					    unsigned int policy_max)
 {
 	int max_freq = intel_pstate_get_max_freq(cpu);
 	int32_t max_policy_perf, min_policy_perf;
@@ -2056,18 +2057,17 @@ static void intel_pstate_update_perf_lim
 		turbo_max = cpu->pstate.turbo_pstate;
 	}
 
-	max_policy_perf = max_state * policy->max / max_freq;
-	if (policy->max == policy->min) {
+	max_policy_perf = max_state * policy_max / max_freq;
+	if (policy_max == policy_min) {
 		min_policy_perf = max_policy_perf;
 	} else {
-		min_policy_perf = max_state * policy->min / max_freq;
+		min_policy_perf = max_state * policy_min / max_freq;
 		min_policy_perf = clamp_t(int32_t, min_policy_perf,
 					  0, max_policy_perf);
 	}
 
 	pr_debug("cpu:%d max_state %d min_policy_perf:%d max_policy_perf:%d\n",
-		 policy->cpu, max_state,
-		 min_policy_perf, max_policy_perf);
+		 cpu->cpu, max_state, min_policy_perf, max_policy_perf);
 
 	/* Normalize user input to [min_perf, max_perf] */
 	if (per_cpu_limits) {
@@ -2081,7 +2081,7 @@ static void intel_pstate_update_perf_lim
 		global_min = DIV_ROUND_UP(turbo_max * global.min_perf_pct, 100);
 		global_min = clamp_t(int32_t, global_min, 0, global_max);
 
-		pr_debug("cpu:%d global_min:%d global_max:%d\n", policy->cpu,
+		pr_debug("cpu:%d global_min:%d global_max:%d\n", cpu->cpu,
 			 global_min, global_max);
 
 		cpu->min_perf_ratio = max(min_policy_perf, global_min);
@@ -2094,7 +2094,7 @@ static void intel_pstate_update_perf_lim
 					  cpu->max_perf_ratio);
 
 	}
-	pr_debug("cpu:%d max_perf_ratio:%d min_perf_ratio:%d\n", policy->cpu,
+	pr_debug("cpu:%d max_perf_ratio:%d min_perf_ratio:%d\n", cpu->cpu,
 		 cpu->max_perf_ratio,
 		 cpu->min_perf_ratio);
 }
@@ -2114,7 +2114,7 @@ static int intel_pstate_set_policy(struc
 
 	mutex_lock(&intel_pstate_limits_lock);
 
-	intel_pstate_update_perf_limits(policy, cpu);
+	intel_pstate_update_perf_limits(cpu, policy->min, policy->max);
 
 	if (cpu->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		/*
@@ -2143,8 +2143,8 @@ static int intel_pstate_set_policy(struc
 	return 0;
 }
 
-static void intel_pstate_adjust_policy_max(struct cpufreq_policy *policy,
-					 struct cpudata *cpu)
+static void intel_pstate_adjust_policy_max(struct cpudata *cpu,
+					   struct cpufreq_policy_data *policy)
 {
 	if (!hwp_active &&
 	    cpu->pstate.max_pstate_physical > cpu->pstate.max_pstate &&
@@ -2155,7 +2155,7 @@ static void intel_pstate_adjust_policy_m
 	}
 }
 
-static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
+static int intel_pstate_verify_policy(struct cpufreq_policy_data *policy)
 {
 	struct cpudata *cpu = all_cpu_data[policy->cpu];
 
@@ -2163,11 +2163,7 @@ static int intel_pstate_verify_policy(st
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
 				     intel_pstate_get_max_freq(cpu));
 
-	if (policy->policy != CPUFREQ_POLICY_POWERSAVE &&
-	    policy->policy != CPUFREQ_POLICY_PERFORMANCE)
-		return -EINVAL;
-
-	intel_pstate_adjust_policy_max(policy, cpu);
+	intel_pstate_adjust_policy_max(cpu, policy);
 
 	return 0;
 }
@@ -2268,7 +2264,7 @@ static struct cpufreq_driver intel_pstat
 	.name		= "intel_pstate",
 };
 
-static int intel_cpufreq_verify_policy(struct cpufreq_policy *policy)
+static int intel_cpufreq_verify_policy(struct cpufreq_policy_data *policy)
 {
 	struct cpudata *cpu = all_cpu_data[policy->cpu];
 
@@ -2276,9 +2272,9 @@ static int intel_cpufreq_verify_policy(s
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
 				     intel_pstate_get_max_freq(cpu));
 
-	intel_pstate_adjust_policy_max(policy, cpu);
+	intel_pstate_adjust_policy_max(cpu, policy);
 
-	intel_pstate_update_perf_limits(policy, cpu);
+	intel_pstate_update_perf_limits(cpu, policy->min, policy->max);
 
 	return 0;
 }
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -122,7 +122,7 @@ static int longrun_set_policy(struct cpu
  * Validates a new CPUFreq policy. This function has to be called with
  * cpufreq_driver locked.
  */
-static int longrun_verify_policy(struct cpufreq_policy *policy)
+static int longrun_verify_policy(struct cpufreq_policy_data *policy)
 {
 	if (!policy)
 		return -EINVAL;
@@ -130,10 +130,6 @@ static int longrun_verify_policy(struct
 	policy->cpu = 0;
 	cpufreq_verify_within_cpu_limits(policy);
 
-	if ((policy->policy != CPUFREQ_POLICY_POWERSAVE) &&
-	    (policy->policy != CPUFREQ_POLICY_PERFORMANCE))
-		return -EINVAL;
-
 	return 0;
 }
 
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -109,7 +109,7 @@ struct pcc_cpu {
 
 static struct pcc_cpu __percpu *pcc_cpu_info;
 
-static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
+static int pcc_cpufreq_verify(struct cpufreq_policy_data *policy)
 {
 	cpufreq_verify_within_cpu_limits(policy);
 	return 0;
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -87,7 +87,7 @@ static int sh_cpufreq_target(struct cpuf
 	return work_on_cpu(policy->cpu, __sh_cpufreq_target, &data);
 }
 
-static int sh_cpufreq_verify(struct cpufreq_policy *policy)
+static int sh_cpufreq_verify(struct cpufreq_policy_data *policy)
 {
 	struct clk *cpuclk = &per_cpu(sh_cpuclk, policy->cpu);
 	struct cpufreq_frequency_table *freq_table;
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -22,7 +22,7 @@ static struct cpufreq_driver ucv2_driver
 /* make sure that only the "userspace" governor is run
  * -- anything else wouldn't make sense on this platform, anyway.
  */
-static int ucv2_verify_speed(struct cpufreq_policy *policy)
+static int ucv2_verify_speed(struct cpufreq_policy_data *policy)
 {
 	if (policy->cpu)
 		return -EINVAL;
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -148,6 +148,20 @@ struct cpufreq_policy {
 	struct notifier_block nb_max;
 };
 
+/*
+ * Used for passing new cpufreq policy data to the cpufreq driver's ->verify()
+ * callback for sanitization.  That callback is only expected to modify the min
+ * and max values, if necessary, and specifically it must not update the
+ * frequency table.
+ */
+struct cpufreq_policy_data {
+	struct cpufreq_cpuinfo		cpuinfo;
+	struct cpufreq_frequency_table	*freq_table;
+	unsigned int			cpu;
+	unsigned int			min;    /* in kHz */
+	unsigned int			max;    /* in kHz */
+};
+
 struct cpufreq_freqs {
 	struct cpufreq_policy *policy;
 	unsigned int old;
@@ -201,8 +215,6 @@ u64 get_cpu_idle_time(unsigned int cpu,
 struct cpufreq_policy *cpufreq_cpu_acquire(unsigned int cpu);
 void cpufreq_cpu_release(struct cpufreq_policy *policy);
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
-int cpufreq_set_policy(struct cpufreq_policy *policy,
-		       struct cpufreq_policy *new_policy);
 void refresh_frequency_limits(struct cpufreq_policy *policy);
 void cpufreq_update_policy(unsigned int cpu);
 void cpufreq_update_limits(unsigned int cpu);
@@ -284,7 +296,7 @@ struct cpufreq_driver {
 
 	/* needed by all drivers */
 	int		(*init)(struct cpufreq_policy *policy);
-	int		(*verify)(struct cpufreq_policy *policy);
+	int		(*verify)(struct cpufreq_policy_data *policy);
 
 	/* define one out of two */
 	int		(*setpolicy)(struct cpufreq_policy *policy);
@@ -415,8 +427,9 @@ static inline int cpufreq_thermal_contro
 		(drv->flags & CPUFREQ_IS_COOLING_DEV);
 }
 
-static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
-		unsigned int min, unsigned int max)
+static inline void cpufreq_verify_within_limits(struct cpufreq_policy_data *policy,
+						unsigned int min,
+						unsigned int max)
 {
 	if (policy->min < min)
 		policy->min = min;
@@ -432,10 +445,10 @@ static inline void cpufreq_verify_within
 }
 
 static inline void
-cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
+cpufreq_verify_within_cpu_limits(struct cpufreq_policy_data *policy)
 {
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
-			policy->cpuinfo.max_freq);
+				     policy->cpuinfo.max_freq);
 }
 
 #ifdef CONFIG_CPU_FREQ
@@ -513,6 +526,7 @@ static inline unsigned long cpufreq_scal
  *                          CPUFREQ GOVERNORS                        *
  *********************************************************************/
 
+#define CPUFREQ_POLICY_UNKNOWN		(0)
 /*
  * If (cpufreq_driver->target) exists, the ->governor decides what frequency
  * within the limits is used. If (cpufreq_driver->setpolicy> exists, these
@@ -684,9 +698,9 @@ static inline void dev_pm_opp_free_cpufr
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table);
 
-int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
+int cpufreq_frequency_table_verify(struct cpufreq_policy_data *policy,
 				   struct cpufreq_frequency_table *table);
-int cpufreq_generic_frequency_table_verify(struct cpufreq_policy *policy);
+int cpufreq_generic_frequency_table_verify(struct cpufreq_policy_data *policy);
 
 int cpufreq_table_index_unsorted(struct cpufreq_policy *policy,
 				 unsigned int target_freq,


