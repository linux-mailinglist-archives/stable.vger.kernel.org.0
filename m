Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFABD4CCCDA
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 06:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbiCDFOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 00:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 00:14:36 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C5793A2;
        Thu,  3 Mar 2022 21:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646370828; x=1677906828;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6ZVjE6SovxgNkOjn7jsHaBW4h9ojN0Ii0pno+U3uCMk=;
  b=DVDvbhtgaEBMYQyJq7kMsqrMZc6zeYwBpHdmaJ1l1asAKrEG3VyHOAg7
   WSwGCqDuJ/ne7ZcE3U/PfqkVhrcr/2FKTwJHT8lk/4p8uajPZmDQAJ3F+
   x1oUmwZTCeyla2/oZ+NjEJpk5c3Uttd6fIC/TQdci2qEF5gCtYtBG6Rb6
   dIwXHD5ro7WVZR7bkoOexVltaJPkP9ra0S6i1CXABlrjJRm99G6u6d9ZZ
   KTVA5iINWeFCGOmMixSkGPKoyAIL+a5otTZEIAFg3u2BH1uSesMP/FOeV
   rvaxTFozBRo4u/XcXUkh694pHZU6yDsjVVD24Zgl1oGjs+Q8OJljh3tjQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="278585661"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="278585661"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 21:13:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="494217712"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2022 21:13:45 -0800
Date:   Fri, 4 Mar 2022 13:13:44 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        tim.c.chen@intel.com
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220304051344.GA72462@shbuild999.sh.intel.com>
References: <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com>
 <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com>
 <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
 <20220303052727.GM4548@shbuild999.sh.intel.com>
 <CAJZ5v0h0yqP2qThX6KbQT-6zG=YfxkAbH+uGV8aZCgZX0tSPpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h0yqP2qThX6KbQT-6zG=YfxkAbH+uGV8aZCgZX0tSPpw@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 03, 2022 at 01:02:01PM +0100, Rafael J. Wysocki wrote:
> On Thu, Mar 3, 2022 at 6:27 AM Feng Tang <feng.tang@intel.com> wrote:
> >
> > On Tue, Mar 01, 2022 at 08:06:24PM -0800, Doug Smythies wrote:
> > > On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > >
> > > > I guess the numbers above could be reduced still by using a P-state
> > > > below the max non-turbo one as a limit.
> > >
> > > Yes, and for a test I did "rjw-3".
> > >
> > > > > overruns: 1042.
> > > > > max overrun time: 9,769 uSec.
> > > >
> > > > This would probably get worse then, though.
> > >
> > > Yes, that was my expectation, but not what happened.
> > >
> > > rjw-3:
> > > ave: 3.09 watts
> > > min: 3.01 watts
> > > max: 31.7 watts
> > > ave freq: 2.42 GHz.
> > > overruns: 12. (I did not expect this.)
> > > Max overruns time: 621 uSec.
> > >
> > > Note 1: IRQ's increased by 74%. i.e. it was going in
> > > and out of idle a lot more.
> > >
> > > Note 2: We know that processor package power
> > > is highly temperature dependent. I forgot to let my
> > > coolant cool adequately after the kernel compile,
> > > and so had to throw out the first 4 power samples
> > > (20 minutes).
> > >
> > > I retested both rjw-2 and rjw-3, but shorter tests
> > > and got 0 overruns in both cases.
> >
> > One thought is can we consider trying the previous debug patch of
> > calling the util_update when entering idle (time limited).
> >
> > In current code, the RT/CFS/Deadline class all have places to call
> > cpufreq_update_util(), the patch will make sure it is called in all
> > four classes, also it follows the principle of 'schedutil' of not
> > introducing more system cost. And surely I could be missing some
> > details here.
> >
> > Following is a cleaner version of the patch, and the code could be
> > moved down to the internal loop of
> >
> >         while (!need_resched()) {
> >
> >         }
> >
> > Which will make it get called more frequently.
> 
> It will, but it's not necessary in all cases.  It only is necessary if
> the tick is going to be stopped (because the tick will update the
> P-state governor anyway if it runs).  However, at this point you don't
> know what's going to happen to the tick.
> 
> Moreover, updating the P-state governor before going idle doesn't
> really help,

From Doug's previous test, the power consumption and the delay
both improved with the debug patch.

> because the P-state programmed by it at this point may
> very well be stale after getting out of the idle state, so instead of
> doing a full update at this point, it should force a low P-state on
> the way from idle.

Makes sense.

Paul has asked about the timer interupts, and here is some more info,
when there is no active load in system, the longest interval of 4
seconds between 2 timer interrupts comes from the kernel watchdog
for hardware/software lockup detector, and every CPU will have this
timer, which limits the maximum cpu idle duration to be 4 seconds.

> > ---
> >
> > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > index d17b0a5ce6ac..e12688036725 100644
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -258,15 +258,23 @@ static void cpuidle_idle_call(void)
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
> > +       expire = __this_cpu_read(last_util_update_time) + HZ * 3;
> > +       if (unlikely(time_is_before_jiffies((unsigned long)expire))) {
> > +               cpufreq_update_util(this_rq(), 0);
> 
> And quite frankly I'm not sure if running cpufreq_update_util() from
> here is safe.

I had that concern too :). Do you mean this is called when the local
irq is enabled, and could be interrupted causing some issue?

Thanks,
Feng

> > +               __this_cpu_write(last_util_update_time, get_jiffies_64());
> > +       }
> > +
> >         /*
> >          * If the arch has a polling bit, we maintain an invariant:
> >          *
> >
