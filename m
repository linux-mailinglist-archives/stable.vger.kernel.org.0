Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9BC4C0631
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 01:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiBWAc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 19:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbiBWAc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 19:32:57 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC11B5C640;
        Tue, 22 Feb 2022 16:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645576350; x=1677112350;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcgSn4iDOIIaikFT2TycJ2VTdkSon7gpfG8/FONrQfA=;
  b=NqucfTwcqEisk46rNhHTcSN7qlnz3xz8Dbt2v2c2zJZKk5VUiYyfxWHb
   DeHJ2Keml1WKiKD8t1EAjdkzbv/POpfjdtycB868bY1hmZkEXPw2ulVJ2
   bsPfDohricx2ZzBOF2i6qRYSX3xMGid2aWCg2i9nHPb2tcDhX9zpbzuc2
   1zoLu878vd9FxVtYTmdbsdrckU7aNK744iO9OJ8uU+fiI8AEOMWHAZp/V
   6vMv+pm2ZD5KrWz+Ev0EjURHtKnMkP3VWee+iTCSFE+1qCd0zUGg0ZInN
   wgbxumIraMvXXi4GXqsk7dyORNQCEouYa+5GqZLGItdMgbg4FBurW13JI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="239237172"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="239237172"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:32:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="627890048"
Received: from chinhtn-mobl1.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.209.26.159])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:32:29 -0800
Message-ID: <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Feng Tang <feng.tang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date:   Tue, 22 Feb 2022 16:32:29 -0800
In-Reply-To: <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
         <20220208023940.GA5558@shbuild999.sh.intel.com>
         <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
         <20220208091525.GA7898@shbuild999.sh.intel.com>
         <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
         <e185b89fb97f47758a5e10239fc3eed0@intel.com>
         <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
         <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
         <20220222073435.GB78951@shbuild999.sh.intel.com>
         <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
         <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Doug,

On Tue, 2022-02-22 at 16:07 -0800, Doug Smythies wrote:
> Hi All,
> 
> I am about 1/2 way through testing Feng's "hacky debug patch",
> let me know if I am wasting my time, and I'll abort. So far, it
> works fine.
This just proves that if you add some callback during long idle,  you
will reach a less aggressive p-state. I think you already proved that
with your results below showing 1W less average power ("Kernel 5.17-rc3
+ Feng patch (6 samples at 300 sec per").

Rafael replied with one possible option. Alternatively when planing to
enter deep idle, set P-state to min with a callback like we do in
offline callback.

So we need to think about a proper solution for this.

Thanks,
Srinivas

> 
> The compiler complains:
> 
> kernel/sched/idle.c: In function ‘do_idle’:
> ./include/linux/typecheck.h:12:18: warning: comparison of distinct
> pointer types lacks a cast
>    12 |  (void)(&__dummy == &__dummy2); \
>       |                  ^~
> ./include/linux/compiler.h:78:42: note: in definition of macro
> ‘unlikely’
>    78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>       |                                          ^
> ./include/linux/jiffies.h:106:3: note: in expansion of macro
> ‘typecheck’
>   106 |   typecheck(unsigned long, b) && \
>       |   ^~~~~~~~~
> ./include/linux/jiffies.h:154:35: note: in expansion of macro
> ‘time_after’
>   154 | #define time_is_before_jiffies(a) time_after(jiffies, a)
>       |                                   ^~~~~~~~~~
> kernel/sched/idle.c:274:15: note: in expansion of macro
> ‘time_is_before_jiffies’
>   274 |  if (unlikely(time_is_before_jiffies(expire))) {
> 
> Test 1: 347 Hertz work/sleep frequency on one CPU while others do
> virtually no load, but at around 0.02 hertz aggregate.
> Processor package power (Watts):
> 
> Kernel 5.17-rc3 + Feng patch (6 samples at 300 sec per):
> Average: 3.2
> Min: 3.1
> Max: 3.3
> 
> Kernel 5.17-rc3 (Stock) re-stated:
> > Stock: 5 samples @ 300 seconds per sample:
> > average: 4.2 watts +31%
> > minimum: 3.5 watts
> > maximum: 4.9 watts
> 
> Kernel 5.17-rc3 with with b50db7095fe0 reverted. (Revert) re-stated:
> > Revert: 5 samples @ 300 seconds per sample:
> > average: 3.2 watts
> > minimum: 3.1 watts
> > maximum: 3.2 watts
> 
> I also ran intel_pstate_tracer.py for 5 hours 33 minutes
> (20,000 seconds) on an idle system looking for long durations.
> (just being thorough.) There were 12 occurrences of durations
> longer than 6.1 seconds.
> Max: 6.8 seconds. (O.K.)
> I had expected about 3 seconds max, based on my
> understanding of the patch code.
> 
> Old results restated, but corrected for a stupid mistake:
> 
> Stock:
> 1712 occurrences of durations longer than 6.1 seconds
> Max: 303.6 seconds. (Bad)
> 
> Revert:
> 3 occurrences of durations longer than 6.1 seconds
> Max: 6.5 seconds (O.K.)
> 
> On Tue, Feb 22, 2022 at 10:04 AM Rafael J. Wysocki
> <rafael@kernel.org> wrote:
> > 
> > On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com>
> > wrote:
> > > 
> > > On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada
> > > wrote:
> > > > Hi Doug,
> > > > 
> > > > I think you use CONFIG_NO_HZ_FULL.
> > > > Here we are getting callback from scheduler. Can we check that
> > > > if
> > > > scheduler woke up on those CPUs?
> > > > We can run "trace-cmd -e sched" and check in kernel shark if
> > > > there is
> > > > similar gaps in activity.
> > > 
> > > Srinivas analyzed the scheduler trace data from trace-cmd, and
> > > thought is
> > > related with the cpufreq callback is not called timeley from
> > > scheduling
> > > events:
> > > 
> > > "
> > > I mean we ignore the callback when the target CPU is not a local
> > > CPU as
> > > we have to do IPI to adjust MSRs.
> > > This will happen many times when sched_wake will wake up a new
> > > CPU for
> > > the thread (we will get a callack for the target) but once the
> > > remote
> > > thread start executing "sched_switch", we will get a callback on
> > > local
> > > CPU, so we will adjust frequencies (provided 10ms interval from
> > > the
> > > last call).
> > > 
> > > > From the trace file I see the scenario where it took 72sec
> > > > between two
> > > updates:
> > > CPU 2
> > > 34412.597161    busy=78         freq=3232653
> > > 34484.450725    busy=63         freq=2606793
> > > 
> > > There is periodic activity in between, related to active load
> > > balancing
> > > in scheduler (since last frequency was higher these small work
> > > will
> > > also run at higher frequency). But those threads are not CFS
> > > class, so
> > > scheduler callback will not be called for them.
> > > 
> > > So removing the patch removed a trigger which would have caused a
> > > sched_switch to a CFS task and call a cpufreq/intel_pstate
> > > callback.
> > 
> > And so this behavior needs to be restored for the time being which
> > means reverting the problematic commit for 5.17 if possible.
> > 
> > It is unlikely that we'll get a proper fix before -rc7 and we still
> > need to test it properly.
> > 
> > > But calling for every class, will be too many callbacks and not
> > > sure we
> > > can even call for "stop" class, which these migration threads are
> > > using.
> > > "
> > 
> > Calling it for RT/deadline may not be a bad idea.
> > 
> > schedutil takes these classes into account when computing the
> > utilization now (see effective_cpu_util()), so doing callbacks only
> > for CFS seems insufficient.
> > 
> > Another way to avoid the issue at hand may be to prevent entering
> > deep
> > idle via PM QoS if the CPUs are running at high frequencies.
> > 
> > > Following this direction, I made a hacky debug patch which should
> > > help
> > > to restore the previous behavior.
> > > 
> > > Doug, could you help to try it? thanks
> > > 
> > > It basically tries to make sure the cpufreq-update-util be called
> > > timely
> > > even for a silent system with very few interrupts (even from
> > > tick).
> > > 
> > > Thanks,
> > > Feng
> > > 
> > > From 6be5f5da66a847860b0b9924fbb09f93b2e2d6e6 Mon Sep 17 00:00:00
> > > 2001
> > > From: Feng Tang <feng.tang@intel.com>
> > > Date: Tue, 22 Feb 2022 22:59:00 +0800
> > > Subject: [PATCH] idle/intel-pstate: hacky debug patch to make
> > > sure the
> > >  cpufreq_update_util callback being called timely in silent
> > > system
> > > 
> > > ---
> > >  kernel/sched/idle.c  | 10 ++++++++++
> > >  kernel/sched/sched.h | 13 +++++++++++++
> > >  2 files changed, 23 insertions(+)
> > > 
> > > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > > index d17b0a5ce6ac..cc538acb3f1a 100644
> > > --- a/kernel/sched/idle.c
> > > +++ b/kernel/sched/idle.c
> > > @@ -258,15 +258,25 @@ static void cpuidle_idle_call(void)
> > >   *
> > >   * Called with polling cleared.
> > >   */
> > > +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
> > >  static void do_idle(void)
> > >  {
> > >         int cpu = smp_processor_id();
> > > +       u64 expire;
> > > 
> > >         /*
> > >          * Check if we need to update blocked load
> > >          */
> > >         nohz_run_idle_balance(cpu);
> > > 
> > > +#ifdef CONFIG_X86_INTEL_PSTATE
> > 
> > Why?  Doesn't this affect the other ccpufreq governors?
> 
> Yes, I have the same question.
> 
> > 
> > > +       expire = __this_cpu_read(last_util_update_time) + HZ * 3;
> > > +       if (unlikely(time_is_before_jiffies(expire))) {
> > > +               idle_update_util();
> > > +               __this_cpu_write(last_util_update_time,
> > > get_jiffies_64());
> > > +       }
> > > +#endif
> > > +
> > >         /*
> > >          * If the arch has a polling bit, we maintain an
> > > invariant:
> > >          *
> > > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > > index 0e66749486e7..2a8d87988d1f 100644
> > > --- a/kernel/sched/sched.h
> > > +++ b/kernel/sched/sched.h
> > > @@ -2809,6 +2809,19 @@ static inline void
> > > cpufreq_update_util(struct rq *rq, unsigned int flags)
> > >         if (data)
> > >                 data->func(data, rq_clock(rq), flags);
> > >  }
> > > +
> > > +static inline void idle_update_util(void)
> > > +{
> > > +       struct update_util_data *data;
> > > +       struct rq *rq = cpu_rq(raw_smp_processor_id());
> > > +
> > > +       data =
> > > rcu_dereference_sched(*per_cpu_ptr(&cpufreq_update_util_data,
> > > +                                                 cpu_of(rq)));
> > > +       if (data)
> > > +               data->func(data, rq_clock(rq), 0);
> > > +}
> > > +
> > > +
> > >  #else
> > >  static inline void cpufreq_update_util(struct rq *rq, unsigned
> > > int flags) {}
> > >  #endif /* CONFIG_CPU_FREQ */
> > > --

