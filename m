Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039D94C09A9
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiBWCuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiBWCuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:50:00 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37D4D609;
        Tue, 22 Feb 2022 18:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645584574; x=1677120574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s1LhSL2+7VUveWoh0gFmtcNBuadJBY12V7KQSjh5XEk=;
  b=jjwfv1QNxQpTxtejDo2NkdHP010vawKAqv2LmjWxjwKbRWxo0Nqu8LLJ
   jrFb6zimiu/GV71YwQQ/yzvAPA3gpvmldCtxRkFwXdWz38xZ36LoNmkF6
   p3llIU650q4yIhWUQ+w5MjBkpmgdZft5eX0kjepl6WORBgHUYVxa/W0Tr
   SiUAmJgDjznMc3848KqPIzFiZfdUGzO0FspmROE9NFB6xFSDf/C+0QdA2
   Gprt7e/MQyz5CC9NJMJrgCDwpzEdNwj/1kbTrl/0YZyqy0PcvoEHkdsoL
   E05t5aK+a7ZTHojzTugsUCdj+WGxIE/bhkYAnCUNJYBd3yS4BMEUOiCFE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="315097343"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="315097343"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 18:49:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="637251645"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by fmsmga002.fm.intel.com with ESMTP; 22 Feb 2022 18:49:30 -0800
Date:   Wed, 23 Feb 2022 10:49:30 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220223024930.GB4548@shbuild999.sh.intel.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rafael,

On Tue, Feb 22, 2022 at 07:04:32PM +0100, Rafael J. Wysocki wrote:
> On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
> >
> > On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada wrote:
> > > Hi Doug,
> > >
> > > I think you use CONFIG_NO_HZ_FULL.
> > > Here we are getting callback from scheduler. Can we check that if
> > > scheduler woke up on those CPUs?
> > > We can run "trace-cmd -e sched" and check in kernel shark if there is
> > > similar gaps in activity.
> >
> > Srinivas analyzed the scheduler trace data from trace-cmd, and thought is
> > related with the cpufreq callback is not called timeley from scheduling
> > events:
> >
> > "
> > I mean we ignore the callback when the target CPU is not a local CPU as
> > we have to do IPI to adjust MSRs.
> > This will happen many times when sched_wake will wake up a new CPU for
> > the thread (we will get a callack for the target) but once the remote
> > thread start executing "sched_switch", we will get a callback on local
> > CPU, so we will adjust frequencies (provided 10ms interval from the
> > last call).
> >
> > >From the trace file I see the scenario where it took 72sec between two
> > updates:
> > CPU 2
> > 34412.597161    busy=78         freq=3232653
> > 34484.450725    busy=63         freq=2606793
> >
> > There is periodic activity in between, related to active load balancing
> > in scheduler (since last frequency was higher these small work will
> > also run at higher frequency). But those threads are not CFS class, so
> > scheduler callback will not be called for them.
> >
> > So removing the patch removed a trigger which would have caused a
> > sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
> 
> And so this behavior needs to be restored for the time being which
> means reverting the problematic commit for 5.17 if possible.
> 
> It is unlikely that we'll get a proper fix before -rc7 and we still
> need to test it properly.

Thanks for checking this! 

I understand the time limit as we are approaching the close of 5.17,
but still I don't think reverting commit b50db7095fe0 is the best
solution as:

* b50db7095fe0 is not just an optimization, but solves some real
  problems found in servers from big CSP (Cloud Service Provider)
  and data center's server room.

* IMHO, b50db7095fe0 itself hasn't done anything wrong.

* This problem found by Doug is a rarely happened case, though
  it is an expected thing as shown in existing comments of
  cfs_rq_util_change():

	/*
	 * There are a few boundary cases this might miss but it should
	 * get called often enough that that should (hopefully) not be
	 * a real problem.
	 *
	 * It will not get called when we go idle, because the idle
	 * thread is a different class (!fair), nor will the utilization
	 * number include things like RT tasks.
	 *
	 * As is, the util number is not freq-invariant (we'd have to
	 * implement arch_scale_freq_capacity() for that).
	 *
	 * See cpu_util_cfs().
	 */
	cpufreq_update_util(rq, flags);

As this happens with HWP-disabled case and a very calm system, can we
find a proper solution in 5.17/5.18 or later, and cc stable?

> > But calling for every class, will be too many callbacks and not sure we
> > can even call for "stop" class, which these migration threads are
> > using.
> > "
> 
> Calling it for RT/deadline may not be a bad idea.
> 
> schedutil takes these classes into account when computing the
> utilization now (see effective_cpu_util()), so doing callbacks only
> for CFS seems insufficient.
> 
> Another way to avoid the issue at hand may be to prevent entering deep
> idle via PM QoS if the CPUs are running at high frequencies.
> 
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -258,15 +258,25 @@ static void cpuidle_idle_call(void)
> >   *
> >   * Called with polling cleared.
> >   */
> > +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
> >  static void do_idle(void)
> >  {
> >         int cpu = smp_processor_id();
> > +       u64 expire;
> >
> >         /*
> >          * Check if we need to update blocked load
> >          */
> >         nohz_run_idle_balance(cpu);
> >
> > +#ifdef CONFIG_X86_INTEL_PSTATE
> 
> Why?  Doesn't this affect the other ccpufreq governors?

You are right, this should be a generic thing.

I tried to limit its affect to other cases, though it's not necessary
for a debug patch.

Thanks,
Feng
