Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486DE4C4CE2
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiBYRxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 12:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiBYRxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 12:53:16 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Feb 2022 09:52:43 PST
Received: from cloudserver094114.home.pl (cloudserver094114.home.pl [79.96.170.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0114173076
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 09:52:41 -0800 (PST)
Received: from localhost (127.0.0.1) (HELO v370.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 4.0.0)
 id cca335e773f992d4; Fri, 25 Feb 2022 18:46:00 +0100
Received: from kreacher.localnet (unknown [213.134.175.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by v370.home.net.pl (Postfix) with ESMTPSA id 5DF3B66B838;
        Fri, 25 Feb 2022 18:45:59 +0100 (CET)
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Feng Tang <feng.tang@intel.com>,
        Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver calls - bisected
Date:   Fri, 25 Feb 2022 18:45:58 +0100
Message-ID: <5562542.DvuYhMxLoT@kreacher>
In-Reply-To: <20220224080830.GD4548@shbuild999.sh.intel.com>
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com> <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com> <20220224080830.GD4548@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-CLIENT-IP: 213.134.175.246
X-CLIENT-HOSTNAME: 213.134.175.246
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrleeggddutdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecujffqoffgrffnpdggtffipffknecuuegrihhlohhuthemucduhedtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkjghfggfgtgesthfuredttddtjeenucfhrhhomhepfdftrghfrggvlhculfdrucghhihsohgtkhhifdcuoehrjhifsehrjhifhihsohgtkhhirdhnvghtqeenucggtffrrghtthgvrhhnpedvjeelgffhiedukedtleekkedvudfggefhgfegjefgueekjeelvefggfdvledutdenucfkphepvddufedrudefgedrudejhedrvdegieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvudefrddufeegrddujeehrddvgeeipdhhvghlohepkhhrvggrtghhvghrrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpedftfgrfhgrvghlucflrdcuhgihshhotghkihdfuceorhhjfiesrhhjfiihshhotghkihdrnhgvtheqpdhnsggprhgtphhtthhopedutddprhgtphhtthhopehfvghnghdrthgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtohepughsmhihthhhihgvshesthgvlhhushdrnhgvthdprhgtphhtthhopehrrghfrggvlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhrihhnihhvrghsrdhprghnughruhhvrggurgeslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehruhhirdii
 hhgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepphgruhhlmhgtkheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqphhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-DCC--Metrics: v370.home.net.pl 1024; Body=10 Fuz1=10 Fuz2=10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
> On Wed, Feb 23, 2022 at 03:23:20PM +0100, Rafael J. Wysocki wrote:
> > On Wed, Feb 23, 2022 at 1:40 AM Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 04:32:29PM -0800, srinivas pandruvada wrote:
> > > > Hi Doug,
> > > >
> > > > On Tue, 2022-02-22 at 16:07 -0800, Doug Smythies wrote:
> > > > > Hi All,
> > > > >
> > > > > I am about 1/2 way through testing Feng's "hacky debug patch",
> > > > > let me know if I am wasting my time, and I'll abort. So far, it
> > > > > works fine.
> > > > This just proves that if you add some callback during long idle,  you
> > > > will reach a less aggressive p-state. I think you already proved that
> > > > with your results below showing 1W less average power ("Kernel 5.17-rc3
> > > > + Feng patch (6 samples at 300 sec per").
> > > >
> > > > Rafael replied with one possible option. Alternatively when planing to
> > > > enter deep idle, set P-state to min with a callback like we do in
> > > > offline callback.
> > >
> > > Yes, if the system is going to idle, it makes sense to goto a lower
> > > cpufreq first (also what my debug patch will essentially lead to).
> > >
> > > Given cprfreq-util's normal running frequency is every 10ms, doing
> > > this before entering idle is not a big extra burden.
> > 
> > But this is not related to idle as such, but to the fact that idle
> > sometimes stops the scheduler tick which otherwise would run the
> > cpufreq governor callback on a regular basis.
> > 
> > It is stopping the tick that gets us into trouble, so I would avoid
> > doing it if the current performance state is too aggressive.
> 
> I've tried to simulate Doug's environment by using his kconfig, and
> offline my 36 CPUs Desktop to leave 12 CPUs online, and on it I can
> still see Local timer interrupts when there is no active load, with
> the longest interval between 2 timer interrupts is 4 seconds, while
> idle class's task_tick_idle() will do nothing, and CFS'
> task_tick_fair() will in turn call cfs_rq_util_change()
> 
> I searched the cfs/deadline/rt code, these three classes  all have
> places to call cpufreq_update_util(), either in enqueue/dequeue or
> changing running bandwidth. So I think entering idle also means the
> system load is under a big change, and worth calling the cpufreq
> callback.
> 
> > In principle, PM QoS can be used for that from intel_pstate, but there
> > is a problem with that approach, because it is not obvious what value
> > to give to it and it is not always guaranteed to work (say when all of
> > the C-states except for C1 are disabled).
> > 
> > So it looks like a new mechanism is needed for that.
> 
> If you think idle class is not the right place to solve it, I can
> also help testing new patches.

So I have the appended experimental patch to address this issue that's not
been tested at all.  Caveat emptor.

I've been looking for something relatively low-overhead and taking all of the
dependencies into account.

---
 drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
 drivers/cpuidle/governors/ladder.c |    6 +++--
 drivers/cpuidle/governors/menu.c   |    2 +
 drivers/cpuidle/governors/teo.c    |    3 ++
 include/linux/cpuidle.h            |    4 +++
 5 files changed, 44 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-pm.orig/drivers/cpuidle/governors/menu.c
+++ linux-pm/drivers/cpuidle/governors/menu.c
@@ -284,6 +284,8 @@ static int menu_select(struct cpuidle_dr
 	if (unlikely(delta < 0)) {
 		delta = 0;
 		delta_tick = 0;
+	} else if (dev->retain_tick) {
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
+	if (dev->retain_tick)
+		duration_ns = delta_tick;
+
 	cpu_data->sleep_length_ns = duration_ns;
 
 	/* Check if there is any choice in the first place. */
Index: linux-pm/include/linux/cpuidle.h
===================================================================
--- linux-pm.orig/include/linux/cpuidle.h
+++ linux-pm/include/linux/cpuidle.h
@@ -93,6 +93,7 @@ struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
 	unsigned int		poll_time_limit:1;
+	unsigned int		retain_tick:1;
 	unsigned int		cpu;
 	ktime_t			next_hrtimer;
 
@@ -172,6 +173,8 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 static inline struct cpuidle_device *cpuidle_get_device(void)
 {return __this_cpu_read(cpuidle_devices); }
+
+extern void cpuidle_update_retain_tick(bool val);
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
 
+	*stop_tick = !dev->retain_tick;
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		ladder_do_selection(dev, ldev, last_idx, 0);



