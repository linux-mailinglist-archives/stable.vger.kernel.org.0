Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA44C00E3
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 19:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiBVSFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 13:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiBVSFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 13:05:13 -0500
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7412215B9B4;
        Tue, 22 Feb 2022 10:04:44 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id w63so21644810ybe.10;
        Tue, 22 Feb 2022 10:04:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dxk2Z3eJ8ikBjamjnDTkFx08/6I/9xWJfaPFbKSgbo4=;
        b=NKWDFoXErSwguuXETQjrPAL8jTeLuvfWQu79APuT8BFXgFMtGVSzB7XyLeWLfeRjiF
         VoUv6joMrWXF1bvnySS/f3va1TkiXV3NVOB3FZ/4DxbFnh6jTVzDZH7/Vl2mJ+82r2eO
         vz3IQXks4/H3rWxzF86+dRng22WK/4ND8dc2PzBhIWYlg3mDWlQ5lxWX7vUWT/UobxX/
         a65kDX8SLS+yUWp1t1X3lSv8VLlNimkIUZ11jrTXmpgZ7HUwSr7aLuo1X48F7wivkLxG
         E+zQmGBUf5U8Qoz95BJDolFzw+up/qudwe1nGNuQC+/sSlJjTrfeNHZgLJU9y15se3Xr
         VA6Q==
X-Gm-Message-State: AOAM5322MrkWjDeGdGc+gZbGUtaFncQcXo9PkaxOpnJbRIrmF+KinIkQ
        ONz1QF31GNaUU7uD9KLme+9hAdtoCokT/k2J28I=
X-Google-Smtp-Source: ABdhPJxOeplabvDGT+7bpUol5OBWRUVyLxtaan7HgKqCAUITxhpnSD/vEv+p8eYAycZZjtb3lVNZ3BVOZ3/Li9Wy0MM=
X-Received: by 2002:a25:d90d:0:b0:615:e400:94c1 with SMTP id
 q13-20020a25d90d000000b00615e40094c1mr24473916ybg.81.1645553083663; Tue, 22
 Feb 2022 10:04:43 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com> <20220222073435.GB78951@shbuild999.sh.intel.com>
In-Reply-To: <20220222073435.GB78951@shbuild999.sh.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 22 Feb 2022 19:04:32 +0100
Message-ID: <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
>
> On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada wrote:
> > Hi Doug,
> >
> > I think you use CONFIG_NO_HZ_FULL.
> > Here we are getting callback from scheduler. Can we check that if
> > scheduler woke up on those CPUs?
> > We can run "trace-cmd -e sched" and check in kernel shark if there is
> > similar gaps in activity.
>
> Srinivas analyzed the scheduler trace data from trace-cmd, and thought is
> related with the cpufreq callback is not called timeley from scheduling
> events:
>
> "
> I mean we ignore the callback when the target CPU is not a local CPU as
> we have to do IPI to adjust MSRs.
> This will happen many times when sched_wake will wake up a new CPU for
> the thread (we will get a callack for the target) but once the remote
> thread start executing "sched_switch", we will get a callback on local
> CPU, so we will adjust frequencies (provided 10ms interval from the
> last call).
>
> >From the trace file I see the scenario where it took 72sec between two
> updates:
> CPU 2
> 34412.597161    busy=78         freq=3232653
> 34484.450725    busy=63         freq=2606793
>
> There is periodic activity in between, related to active load balancing
> in scheduler (since last frequency was higher these small work will
> also run at higher frequency). But those threads are not CFS class, so
> scheduler callback will not be called for them.
>
> So removing the patch removed a trigger which would have caused a
> sched_switch to a CFS task and call a cpufreq/intel_pstate callback.

And so this behavior needs to be restored for the time being which
means reverting the problematic commit for 5.17 if possible.

It is unlikely that we'll get a proper fix before -rc7 and we still
need to test it properly.

> But calling for every class, will be too many callbacks and not sure we
> can even call for "stop" class, which these migration threads are
> using.
> "

Calling it for RT/deadline may not be a bad idea.

schedutil takes these classes into account when computing the
utilization now (see effective_cpu_util()), so doing callbacks only
for CFS seems insufficient.

Another way to avoid the issue at hand may be to prevent entering deep
idle via PM QoS if the CPUs are running at high frequencies.

> Following this direction, I made a hacky debug patch which should help
> to restore the previous behavior.
>
> Doug, could you help to try it? thanks
>
> It basically tries to make sure the cpufreq-update-util be called timely
> even for a silent system with very few interrupts (even from tick).
>
> Thanks,
> Feng
>
> From 6be5f5da66a847860b0b9924fbb09f93b2e2d6e6 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Tue, 22 Feb 2022 22:59:00 +0800
> Subject: [PATCH] idle/intel-pstate: hacky debug patch to make sure the
>  cpufreq_update_util callback being called timely in silent system
>
> ---
>  kernel/sched/idle.c  | 10 ++++++++++
>  kernel/sched/sched.h | 13 +++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index d17b0a5ce6ac..cc538acb3f1a 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -258,15 +258,25 @@ static void cpuidle_idle_call(void)
>   *
>   * Called with polling cleared.
>   */
> +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
>  static void do_idle(void)
>  {
>         int cpu = smp_processor_id();
> +       u64 expire;
>
>         /*
>          * Check if we need to update blocked load
>          */
>         nohz_run_idle_balance(cpu);
>
> +#ifdef CONFIG_X86_INTEL_PSTATE

Why?  Doesn't this affect the other ccpufreq governors?

> +       expire = __this_cpu_read(last_util_update_time) + HZ * 3;
> +       if (unlikely(time_is_before_jiffies(expire))) {
> +               idle_update_util();
> +               __this_cpu_write(last_util_update_time, get_jiffies_64());
> +       }
> +#endif
> +
>         /*
>          * If the arch has a polling bit, we maintain an invariant:
>          *
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 0e66749486e7..2a8d87988d1f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -2809,6 +2809,19 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags)
>         if (data)
>                 data->func(data, rq_clock(rq), flags);
>  }
> +
> +static inline void idle_update_util(void)
> +{
> +       struct update_util_data *data;
> +       struct rq *rq = cpu_rq(raw_smp_processor_id());
> +
> +       data = rcu_dereference_sched(*per_cpu_ptr(&cpufreq_update_util_data,
> +                                                 cpu_of(rq)));
> +       if (data)
> +               data->func(data, rq_clock(rq), 0);
> +}
> +
> +
>  #else
>  static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
>  #endif /* CONFIG_CPU_FREQ */
> --
