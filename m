Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84D54C52B8
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbiBZAhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 19:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBZAhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 19:37:38 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276F2186225
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:37:05 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bu29so12153929lfb.0
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 16:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61Og9Yekp5IRFCsiJKakDtTPAFN3mj4BaM4Rb6o1lXk=;
        b=KzJabQUxmwVb5LeknTRMEx6TiZIhMXWUKtTVAaqZ8tEkQy8gPi72GgKo6KJyubSHnO
         KPSaWLSOhZlGbh1PQkSHBobZS23/56j/yLXbyaIH41EK3uPm1zWBterVhKnxxSKHmg1I
         QLH27J64qyNWWwSLhvxJsEHRxRQhelzkU/d2BcmA5hwJq3/Bjfo0UXeBAYXmJkiBpKSQ
         Wesz6TGXin45FijgqQpEkwOVAs82lAq8SIoLshM6VqgoBeGqpbBAhu3StfDsswkicY6s
         GIl0KthgMmdevTfLmc7qZlzEItFmMxIjjFnOXrv2k7XG01ijq05YvqzFa7fpDc1lz1cH
         M5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61Og9Yekp5IRFCsiJKakDtTPAFN3mj4BaM4Rb6o1lXk=;
        b=FTQqCg59HrQyCUtpJbHg2F9vUv3ykBShaOPGouwvN1ta9UQIaWmqEQQcL4UKdypV6Q
         rcvJQ5s9XdOk1pfx+9O+QvafEEWgTmO0VZ1yU73KHM3uTbJRaLZqQ2uG2wL98XwbQ5As
         DPckvI8WCcjZE7bdD9MWMPl0ypcGCAm3sBazN8HneLrXMpP8iP8yiroFQyDhjPN6+tyL
         A22f9KjtQFfsYo0BAKMw8HFTMt8xnQLkCWgtSE1aUOh7fynQ1ejR75vPQTvzPcrvIUof
         CHaRLFQhCGdyxuO3vEm4dSt5o3l2tNqJZPcQYtt0BtyAwxMcoQXdV00Oi+B+Wi0VnjN8
         BbhQ==
X-Gm-Message-State: AOAM530PvlVODs8wzBkHxIxYVK8sjkVSelHAGb06zeCP9AnEAcn4BTSa
        babfP7dah9XmwqBijS4i81aU5gdnjPDSh31Zctvplg==
X-Google-Smtp-Source: ABdhPJyiU1PsNLMMlY/NOeiguOiai+BrMnQm5Mjpn43memHEapvTbzCUey8NIEKIi2eY+y+cjJ7npkoet/4nQZPgX+k=
X-Received: by 2002:a05:6512:3408:b0:443:c898:520b with SMTP id
 i8-20020a056512340800b00443c898520bmr6123315lfr.465.1645835823405; Fri, 25
 Feb 2022 16:37:03 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
 <20220224080830.GD4548@shbuild999.sh.intel.com> <5562542.DvuYhMxLoT@kreacher>
In-Reply-To: <5562542.DvuYhMxLoT@kreacher>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Fri, 25 Feb 2022 16:36:53 -0800
Message-ID: <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 9:46 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
...
> > > So it looks like a new mechanism is needed for that.
> >
> > If you think idle class is not the right place to solve it, I can
> > also help testing new patches.
>
> So I have the appended experimental patch to address this issue that's not
> been tested at all.  Caveat emptor.

Hi Rafael,

O.K., you gave fair warning.

The patch applied fine.
It does not compile for me.
The function cpuidle_update_retain_tick does not exist.
Shouldn't it be somewhere in cpuidle.c?
I used the function cpuidle_disable_device as a template
for searching and comparing.

Because all of my baseline results are with kernel 5.17-rc3,
that is what I am still using.

Error:
ld: drivers/cpufreq/intel_pstate.o: in function `intel_pstate_update_perf_ctl':
intel_pstate.c:(.text+0x2520): undefined reference to
`cpuidle_update_retain_tick'

... Doug

>
> I've been looking for something relatively low-overhead and taking all of the
> dependencies into account.
>
> ---
>  drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
>  drivers/cpuidle/governors/ladder.c |    6 +++--
>  drivers/cpuidle/governors/menu.c   |    2 +
>  drivers/cpuidle/governors/teo.c    |    3 ++
>  include/linux/cpuidle.h            |    4 +++
>  5 files changed, 44 insertions(+), 11 deletions(-)
>
> Index: linux-pm/drivers/cpuidle/governors/menu.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/governors/menu.c
> +++ linux-pm/drivers/cpuidle/governors/menu.c
> @@ -284,6 +284,8 @@ static int menu_select(struct cpuidle_dr
>         if (unlikely(delta < 0)) {
>                 delta = 0;
>                 delta_tick = 0;
> +       } else if (dev->retain_tick) {
> +               delta = delta_tick;
>         }
>         data->next_timer_ns = delta;
>
> Index: linux-pm/drivers/cpuidle/governors/teo.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/governors/teo.c
> +++ linux-pm/drivers/cpuidle/governors/teo.c
> @@ -308,6 +308,9 @@ static int teo_select(struct cpuidle_dri
>         cpu_data->time_span_ns = local_clock();
>
>         duration_ns = tick_nohz_get_sleep_length(&delta_tick);
> +       if (dev->retain_tick)
> +               duration_ns = delta_tick;
> +
>         cpu_data->sleep_length_ns = duration_ns;
>
>         /* Check if there is any choice in the first place. */
> Index: linux-pm/include/linux/cpuidle.h
> ===================================================================
> --- linux-pm.orig/include/linux/cpuidle.h
> +++ linux-pm/include/linux/cpuidle.h
> @@ -93,6 +93,7 @@ struct cpuidle_device {
>         unsigned int            registered:1;
>         unsigned int            enabled:1;
>         unsigned int            poll_time_limit:1;
> +       unsigned int            retain_tick:1;
>         unsigned int            cpu;
>         ktime_t                 next_hrtimer;
>
> @@ -172,6 +173,8 @@ extern int cpuidle_play_dead(void);
>  extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
>  static inline struct cpuidle_device *cpuidle_get_device(void)
>  {return __this_cpu_read(cpuidle_devices); }
> +
> +extern void cpuidle_update_retain_tick(bool val);
>  #else
>  static inline void disable_cpuidle(void) { }
>  static inline bool cpuidle_not_available(struct cpuidle_driver *drv,
> @@ -211,6 +214,7 @@ static inline int cpuidle_play_dead(void
>  static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
>         struct cpuidle_device *dev) {return NULL; }
>  static inline struct cpuidle_device *cpuidle_get_device(void) {return NULL; }
> +static inline void cpuidle_update_retain_tick(bool val) { }
>  #endif
>
>  #ifdef CONFIG_CPU_IDLE
> Index: linux-pm/drivers/cpufreq/intel_pstate.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> +++ linux-pm/drivers/cpufreq/intel_pstate.c
> @@ -19,6 +19,7 @@
>  #include <linux/list.h>
>  #include <linux/cpu.h>
>  #include <linux/cpufreq.h>
> +#include <linux/cpuidle.h>
>  #include <linux/sysfs.h>
>  #include <linux/types.h>
>  #include <linux/fs.h>
> @@ -1970,6 +1971,30 @@ static inline void intel_pstate_cppc_set
>  }
>  #endif /* CONFIG_ACPI_CPPC_LIB */
>
> +static void intel_pstate_update_perf_ctl(struct cpudata *cpu)
> +{
> +       int pstate = cpu->pstate.current_pstate;
> +
> +       /*
> +        * Avoid stopping the scheduler tick from cpuidle on CPUs in turbo
> +        * P-states to prevent them from getting back to the high frequency
> +        * right away after getting out of deep idle.
> +        */
> +       cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
> +       wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
> +}
> +
> +static void intel_pstate_update_perf_ctl_wrapper(void *cpu_data)
> +{
> +       intel_pstate_update_perf_ctl(cpu_data);
> +}
> +
> +static void intel_pstate_update_perf_ctl_on_cpu(struct cpudata *cpu)
> +{
> +       smp_call_function_single(cpu->cpu, intel_pstate_update_perf_ctl_wrapper,
> +                                cpu, 1);
> +}
> +
>  static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>  {
>         trace_cpu_frequency(pstate * cpu->pstate.scaling, cpu->cpu);
> @@ -1979,8 +2004,7 @@ static void intel_pstate_set_pstate(stru
>          * the CPU being updated, so force the register update to run on the
>          * right CPU.
>          */
> -       wrmsrl_on_cpu(cpu->cpu, MSR_IA32_PERF_CTL,
> -                     pstate_funcs.get_val(cpu, pstate));
> +       intel_pstate_update_perf_ctl_on_cpu(cpu);
>  }
>
>  static void intel_pstate_set_min_pstate(struct cpudata *cpu)
> @@ -2256,7 +2280,7 @@ static void intel_pstate_update_pstate(s
>                 return;
>
>         cpu->pstate.current_pstate = pstate;
> -       wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
> +       intel_pstate_update_perf_ctl(cpu);
>  }
>
>  static void intel_pstate_adjust_pstate(struct cpudata *cpu)
> @@ -2843,11 +2867,9 @@ static void intel_cpufreq_perf_ctl_updat
>                                           u32 target_pstate, bool fast_switch)
>  {
>         if (fast_switch)
> -               wrmsrl(MSR_IA32_PERF_CTL,
> -                      pstate_funcs.get_val(cpu, target_pstate));
> +               intel_pstate_update_perf_ctl(cpu);
>         else
> -               wrmsrl_on_cpu(cpu->cpu, MSR_IA32_PERF_CTL,
> -                             pstate_funcs.get_val(cpu, target_pstate));
> +               intel_pstate_update_perf_ctl_on_cpu(cpu);
>  }
>
>  static int intel_cpufreq_update_pstate(struct cpufreq_policy *policy,
> @@ -2857,6 +2879,8 @@ static int intel_cpufreq_update_pstate(s
>         int old_pstate = cpu->pstate.current_pstate;
>
>         target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
> +       cpu->pstate.current_pstate = target_pstate;
> +
>         if (hwp_active) {
>                 int max_pstate = policy->strict_target ?
>                                         target_pstate : cpu->max_perf_ratio;
> @@ -2867,8 +2891,6 @@ static int intel_cpufreq_update_pstate(s
>                 intel_cpufreq_perf_ctl_update(cpu, target_pstate, fast_switch);
>         }
>
> -       cpu->pstate.current_pstate = target_pstate;
> -
>         intel_cpufreq_trace(cpu, fast_switch ? INTEL_PSTATE_TRACE_FAST_SWITCH :
>                             INTEL_PSTATE_TRACE_TARGET, old_pstate);
>
> Index: linux-pm/drivers/cpuidle/governors/ladder.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/governors/ladder.c
> +++ linux-pm/drivers/cpuidle/governors/ladder.c
> @@ -61,10 +61,10 @@ static inline void ladder_do_selection(s
>   * ladder_select_state - selects the next state to enter
>   * @drv: cpuidle driver
>   * @dev: the CPU
> - * @dummy: not used
> + * @stop_tick: Whether or not to stop the scheduler tick
>   */
>  static int ladder_select_state(struct cpuidle_driver *drv,
> -                              struct cpuidle_device *dev, bool *dummy)
> +                              struct cpuidle_device *dev, bool *stop_tick)
>  {
>         struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
>         struct ladder_device_state *last_state;
> @@ -73,6 +73,8 @@ static int ladder_select_state(struct cp
>         s64 latency_req = cpuidle_governor_latency_req(dev->cpu);
>         s64 last_residency;
>
> +       *stop_tick = !dev->retain_tick;
> +
>         /* Special case when user has set very strict latency requirement */
>         if (unlikely(latency_req == 0)) {
>                 ladder_do_selection(dev, ldev, last_idx, 0);
>
>
>
