Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9869D4C799B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 21:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiB1UD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 15:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiB1UD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 15:03:28 -0500
Received: from cloudserver094114.home.pl (cloudserver094114.home.pl [79.96.170.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07F53BFA5;
        Mon, 28 Feb 2022 12:02:47 -0800 (PST)
Received: from localhost (127.0.0.1) (HELO v370.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 4.0.0)
 id eeaadf3ab70aef69; Mon, 28 Feb 2022 20:36:05 +0100
Received: from kreacher.localnet (unknown [213.134.175.252])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by v370.home.net.pl (Postfix) with ESMTPSA id 2032A660304;
        Mon, 28 Feb 2022 20:36:04 +0100 (CET)
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Doug Smythies <dsmythies@telus.net>,
        Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver calls - bisected
Date:   Mon, 28 Feb 2022 20:36:03 +0100
Message-ID: <11956019.O9o76ZdvQC@kreacher>
In-Reply-To: <20220228041228.GH4548@shbuild999.sh.intel.com>
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com> <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com> <20220228041228.GH4548@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-CLIENT-IP: 213.134.175.252
X-CLIENT-HOSTNAME: 213.134.175.252
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddruddttddguddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfjqffogffrnfdpggftiffpkfenuceurghilhhouhhtmecuudehtdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkfgjfhgggfgtsehtufertddttdejnecuhfhrohhmpedftfgrfhgrvghlucflrdcuhgihshhotghkihdfuceorhhjfiesrhhjfiihshhotghkihdrnhgvtheqnecuggftrfgrthhtvghrnhepvdejlefghfeiudektdelkeekvddugfeghffggeejgfeukeejleevgffgvdeluddtnecukfhppedvudefrddufeegrddujeehrddvhedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddufedrudefgedrudejhedrvdehvddphhgvlhhopehkrhgvrggthhgvrhdrlhhotggrlhhnvghtpdhmrghilhhfrhhomhepfdftrghfrggvlhculfdrucghhihsohgtkhhifdcuoehrjhifsehrjhifhihsohgtkhhirdhnvghtqedpnhgspghrtghpthhtohepuddtpdhrtghpthhtohepughsmhihthhhihgvshesthgvlhhushdrnhgvthdprhgtphhtthhopehfvghnghdrthgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtoheprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrhhinhhivhgrshdrphgrnhgurhhuvhgruggrsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtoheprhhuihdr
 iihhrghnghesihhnthgvlhdrtghomhdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehprghulhhmtghksehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhpmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-DCC--Metrics: v370.home.net.pl 1024; Body=10 Fuz1=10 Fuz2=10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, February 28, 2022 5:12:28 AM CET Feng Tang wrote:
> On Fri, Feb 25, 2022 at 04:36:53PM -0800, Doug Smythies wrote:
> > On Fri, Feb 25, 2022 at 9:46 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >
> > > On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
> > ...
> > > > > So it looks like a new mechanism is needed for that.
> > > >
> > > > If you think idle class is not the right place to solve it, I can
> > > > also help testing new patches.
> > >
> > > So I have the appended experimental patch to address this issue that's not
> > > been tested at all.  Caveat emptor.
> > 
> > Hi Rafael,
> > 
> > O.K., you gave fair warning.
> > 
> > The patch applied fine.
> > It does not compile for me.
> > The function cpuidle_update_retain_tick does not exist.
> > Shouldn't it be somewhere in cpuidle.c?
> > I used the function cpuidle_disable_device as a template
> > for searching and comparing.
> > 
> > Because all of my baseline results are with kernel 5.17-rc3,
> > that is what I am still using.
> > 
> > Error:
> > ld: drivers/cpufreq/intel_pstate.o: in function `intel_pstate_update_perf_ctl':
> > intel_pstate.c:(.text+0x2520): undefined reference to
> > `cpuidle_update_retain_tick'
>  
> Same here, seems the cpuidle_update_retain_tick()'s implementation
> is missing.

That's a patch generation issue on my part, sorry.

However, it was a bit racy, so maybe it's good that it was not complete.

Below is a new version.

---
 drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
 drivers/cpuidle/governor.c         |   23 +++++++++++++++++++++
 drivers/cpuidle/governors/ladder.c |    6 +++--
 drivers/cpuidle/governors/menu.c   |    2 +
 drivers/cpuidle/governors/teo.c    |    3 ++
 include/linux/cpuidle.h            |    4 +++
 6 files changed, 67 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/governors/menu.c
+++ linux-pm/drivers/cpuidle/governors/menu.c
@@ -284,6 +284,8 @@ static int menu_select(struct cpuidle_dr
 	if (unlikely(delta < 0)) {
 		delta = 0;
 		delta_tick = 0;
+	} else if (cpuidle_retain_local_tick()) {
+		delta = delta_tick;
 	}
 	data->next_timer_ns = delta;
 
Index: linux-pm/drivers/cpuidle/governors/teo.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/governors/teo.c
+++ linux-pm/drivers/cpuidle/governors/teo.c
@@ -308,6 +308,9 @@ static int teo_select(struct cpuidle_dri
 	cpu_data->time_span_ns = local_clock();
 
 	duration_ns = tick_nohz_get_sleep_length(&delta_tick);
+	if (cpuidle_retain_local_tick())
+		duration_ns = delta_tick;
+
 	cpu_data->sleep_length_ns = duration_ns;
 
 	/* Check if there is any choice in the first place. */
Index: linux-pm/include/linux/cpuidle.h
===================================================================
--- linux-pm.orig/include/linux/cpuidle.h
+++ linux-pm/include/linux/cpuidle.h
@@ -172,6 +172,9 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 static inline struct cpuidle_device *cpuidle_get_device(void)
 {return __this_cpu_read(cpuidle_devices); }
+
+extern void cpuidle_update_retain_tick(bool val);
+extern bool cpuidle_retain_local_tick(void);
 #else
 static inline void disable_cpuidle(void) { }
 static inline bool cpuidle_not_available(struct cpuidle_driver *drv,
@@ -211,6 +214,7 @@ static inline int cpuidle_play_dead(void
 static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
 	struct cpuidle_device *dev) {return NULL; }
 static inline struct cpuidle_device *cpuidle_get_device(void) {return NULL; }
+static inline void cpuidle_update_retain_tick(bool val) { }
 #endif
 
 #ifdef CONFIG_CPU_IDLE
Index: linux-pm/drivers/cpufreq/intel_pstate.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
+++ linux-pm/drivers/cpufreq/intel_pstate.c
@@ -19,6 +19,7 @@
 #include <linux/list.h>
 #include <linux/cpu.h>
 #include <linux/cpufreq.h>
+#include <linux/cpuidle.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/fs.h>
@@ -1970,6 +1971,30 @@ static inline void intel_pstate_cppc_set
 }
 #endif /* CONFIG_ACPI_CPPC_LIB */
 
+static void intel_pstate_update_perf_ctl(struct cpudata *cpu)
+{
+	int pstate = cpu->pstate.current_pstate;
+
+	/*
+	 * Avoid stopping the scheduler tick from cpuidle on CPUs in turbo
+	 * P-states to prevent them from getting back to the high frequency
+	 * right away after getting out of deep idle.
+	 */
+	cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
+	wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
+}
+
+static void intel_pstate_update_perf_ctl_wrapper(void *cpu_data)
+{
+	intel_pstate_update_perf_ctl(cpu_data);
+}
+
+static void intel_pstate_update_perf_ctl_on_cpu(struct cpudata *cpu)
+{
+	smp_call_function_single(cpu->cpu, intel_pstate_update_perf_ctl_wrapper,
+				 cpu, 1);
+}
+
 static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 {
 	trace_cpu_frequency(pstate * cpu->pstate.scaling, cpu->cpu);
@@ -1979,8 +2004,7 @@ static void intel_pstate_set_pstate(stru
 	 * the CPU being updated, so force the register update to run on the
 	 * right CPU.
 	 */
-	wrmsrl_on_cpu(cpu->cpu, MSR_IA32_PERF_CTL,
-		      pstate_funcs.get_val(cpu, pstate));
+	intel_pstate_update_perf_ctl_on_cpu(cpu);
 }
 
 static void intel_pstate_set_min_pstate(struct cpudata *cpu)
@@ -2256,7 +2280,7 @@ static void intel_pstate_update_pstate(s
 		return;
 
 	cpu->pstate.current_pstate = pstate;
-	wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
+	intel_pstate_update_perf_ctl(cpu);
 }
 
 static void intel_pstate_adjust_pstate(struct cpudata *cpu)
@@ -2843,11 +2867,9 @@ static void intel_cpufreq_perf_ctl_updat
 					  u32 target_pstate, bool fast_switch)
 {
 	if (fast_switch)
-		wrmsrl(MSR_IA32_PERF_CTL,
-		       pstate_funcs.get_val(cpu, target_pstate));
+		intel_pstate_update_perf_ctl(cpu);
 	else
-		wrmsrl_on_cpu(cpu->cpu, MSR_IA32_PERF_CTL,
-			      pstate_funcs.get_val(cpu, target_pstate));
+		intel_pstate_update_perf_ctl_on_cpu(cpu);
 }
 
 static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
@@ -2857,6 +2879,8 @@ static int intel_cpufreq_update_pstate(s
 	int old_pstate = cpu->pstate.current_pstate;
 
 	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
+	cpu->pstate.current_pstate = target_pstate;
+
 	if (hwp_active) {
 		int max_pstate = policy->strict_target ?
 					target_pstate : cpu->max_perf_ratio;
@@ -2867,8 +2891,6 @@ static int intel_cpufreq_update_pstate(s
 		intel_cpufreq_perf_ctl_update(cpu, target_pstate, fast_switch);
 	}
 
-	cpu->pstate.current_pstate = target_pstate;
-
 	intel_cpufreq_trace(cpu, fast_switch ? INTEL_PSTATE_TRACE_FAST_SWITCH :
 			    INTEL_PSTATE_TRACE_TARGET, old_pstate);
 
Index: linux-pm/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/governors/ladder.c
+++ linux-pm/drivers/cpuidle/governors/ladder.c
@@ -61,10 +61,10 @@ static inline void ladder_do_selection(s
  * ladder_select_state - selects the next state to enter
  * @drv: cpuidle driver
  * @dev: the CPU
- * @dummy: not used
+ * @stop_tick: Whether or not to stop the scheduler tick
  */
 static int ladder_select_state(struct cpuidle_driver *drv,
-			       struct cpuidle_device *dev, bool *dummy)
+			       struct cpuidle_device *dev, bool *stop_tick)
 {
 	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	struct ladder_device_state *last_state;
@@ -73,6 +73,8 @@ static int ladder_select_state(struct cp
 	s64 latency_req = cpuidle_governor_latency_req(dev->cpu);
 	s64 last_residency;
 
+	*stop_tick = !cpuidle_retain_local_tick();
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		ladder_do_selection(dev, ldev, last_idx, 0);
Index: linux-pm/drivers/cpuidle/governor.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/governor.c
+++ linux-pm/drivers/cpuidle/governor.c
@@ -118,3 +118,26 @@ s64 cpuidle_governor_latency_req(unsigne
 
 	return (s64)device_req * NSEC_PER_USEC;
 }
+
+static DEFINE_PER_CPU(bool, cpuidle_retain_tick);
+
+/**
+ * cpuidle_update_retain_tick - Update the local CPU's retain_tick flag.
+ * @val: New value of the flag.
+ *
+ * The retain_tick flag controls whether or not to cpuidle is allowed to stop
+ * the scheduler tick on the local CPU and it can be updated with the help of
+ * this function.
+ */
+void cpuidle_update_retain_tick(bool val)
+{
+	this_cpu_write(cpuidle_retain_tick, val);
+}
+
+/**
+ * couidle_retain_local_tick - Return the local CPU's retain_tick flag value.
+ */
+bool cpuidle_retain_local_tick(void)
+{
+	return this_cpu_read(cpuidle_retain_tick);
+}




