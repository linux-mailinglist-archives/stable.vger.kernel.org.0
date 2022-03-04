Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E07B4CD906
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbiCDQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 11:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238075AbiCDQYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 11:24:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920EA5675D;
        Fri,  4 Mar 2022 08:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DF9B61D7E;
        Fri,  4 Mar 2022 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8485BC340E9;
        Fri,  4 Mar 2022 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646411003;
        bh=A0WZoEr7gra5ckN9ZrUfGZctENNf9o5PHa/VMwr1bE8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=DYoFhsdUWID4fR0kL9HCfwgaMWLdTUppwwygMrPdUFQyxz0wx9LByhTLBkqNP4ol1
         fvV/o+le5SE7hDq2hNjVcVFUlhmHk2y/PSNwlarnXlnJ4iJ48XjTsItQs8L9j9pMgo
         HToJHiKiNlBD3R+/wNfnrtSp0yb9jU+/iijVam0GJl7LUNlzKFdk0w2rx3Fw41qFXd
         jRX5M+lkrTWlU1o87lLc2v0MFnB6M0agFz4O+6OpjFTOHMfRkjCbFI/f0A+tZdgsGK
         wQNk9xDKjofThnAQV3TgDGBGxgthW3AmxU4e3OzXh5HnVHmVLzEcc7jG1zwhjBlAs8
         DP2xeadk2gL4Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2CBEF5C04FD; Fri,  4 Mar 2022 08:23:23 -0800 (PST)
Date:   Fri, 4 Mar 2022 08:23:23 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        tim.c.chen@intel.com
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220304162323.GN4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220228041228.GH4548@shbuild999.sh.intel.com>
 <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com>
 <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
 <20220303052727.GM4548@shbuild999.sh.intel.com>
 <CAJZ5v0h0yqP2qThX6KbQT-6zG=YfxkAbH+uGV8aZCgZX0tSPpw@mail.gmail.com>
 <20220304051344.GA72462@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304051344.GA72462@shbuild999.sh.intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 01:13:44PM +0800, Feng Tang wrote:
> On Thu, Mar 03, 2022 at 01:02:01PM +0100, Rafael J. Wysocki wrote:
> > On Thu, Mar 3, 2022 at 6:27 AM Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > On Tue, Mar 01, 2022 at 08:06:24PM -0800, Doug Smythies wrote:
> > > > On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > >
> > > > > I guess the numbers above could be reduced still by using a P-state
> > > > > below the max non-turbo one as a limit.
> > > >
> > > > Yes, and for a test I did "rjw-3".
> > > >
> > > > > > overruns: 1042.
> > > > > > max overrun time: 9,769 uSec.
> > > > >
> > > > > This would probably get worse then, though.
> > > >
> > > > Yes, that was my expectation, but not what happened.
> > > >
> > > > rjw-3:
> > > > ave: 3.09 watts
> > > > min: 3.01 watts
> > > > max: 31.7 watts
> > > > ave freq: 2.42 GHz.
> > > > overruns: 12. (I did not expect this.)
> > > > Max overruns time: 621 uSec.
> > > >
> > > > Note 1: IRQ's increased by 74%. i.e. it was going in
> > > > and out of idle a lot more.
> > > >
> > > > Note 2: We know that processor package power
> > > > is highly temperature dependent. I forgot to let my
> > > > coolant cool adequately after the kernel compile,
> > > > and so had to throw out the first 4 power samples
> > > > (20 minutes).
> > > >
> > > > I retested both rjw-2 and rjw-3, but shorter tests
> > > > and got 0 overruns in both cases.
> > >
> > > One thought is can we consider trying the previous debug patch of
> > > calling the util_update when entering idle (time limited).
> > >
> > > In current code, the RT/CFS/Deadline class all have places to call
> > > cpufreq_update_util(), the patch will make sure it is called in all
> > > four classes, also it follows the principle of 'schedutil' of not
> > > introducing more system cost. And surely I could be missing some
> > > details here.
> > >
> > > Following is a cleaner version of the patch, and the code could be
> > > moved down to the internal loop of
> > >
> > >         while (!need_resched()) {
> > >
> > >         }
> > >
> > > Which will make it get called more frequently.
> > 
> > It will, but it's not necessary in all cases.  It only is necessary if
> > the tick is going to be stopped (because the tick will update the
> > P-state governor anyway if it runs).  However, at this point you don't
> > know what's going to happen to the tick.
> > 
> > Moreover, updating the P-state governor before going idle doesn't
> > really help,
> 
> >From Doug's previous test, the power consumption and the delay
> both improved with the debug patch.
> 
> > because the P-state programmed by it at this point may
> > very well be stale after getting out of the idle state, so instead of
> > doing a full update at this point, it should force a low P-state on
> > the way from idle.
> 
> Makes sense.
> 
> Paul has asked about the timer interupts, and here is some more info,
> when there is no active load in system, the longest interval of 4
> seconds between 2 timer interrupts comes from the kernel watchdog
> for hardware/software lockup detector, and every CPU will have this
> timer, which limits the maximum cpu idle duration to be 4 seconds.

And thank you for the info!  One way to reduce this overhead is to boot
with the watchdog_thresh kernel-boot parameter set to some value greater
than 10.  The downside is that HW/FW/NMI catastrophes will need to last
for more than 10 seconds before the system complains.  One approach
is to run with a small watchdog_thresh during testing and a larger one
in production.

							Thanx, Paul

> > > ---
> > >
> > > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > > index d17b0a5ce6ac..e12688036725 100644
> > > --- a/kernel/sched/idle.c
> > > +++ b/kernel/sched/idle.c
> > > @@ -258,15 +258,23 @@ static void cpuidle_idle_call(void)
> > >   *
> > >   * Called with polling cleared.
> > >   */
> > > +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
> > >  static void do_idle(void)
> > >  {
> > >         int cpu = smp_processor_id();
> > > +       u64 expire;
> > >
> > >         /*
> > >          * Check if we need to update blocked load
> > >          */
> > >         nohz_run_idle_balance(cpu);
> > >
> > > +       expire = __this_cpu_read(last_util_update_time) + HZ * 3;
> > > +       if (unlikely(time_is_before_jiffies((unsigned long)expire))) {
> > > +               cpufreq_update_util(this_rq(), 0);
> > 
> > And quite frankly I'm not sure if running cpufreq_update_util() from
> > here is safe.
> 
> I had that concern too :). Do you mean this is called when the local
> irq is enabled, and could be interrupted causing some issue?
> 
> Thanks,
> Feng
> 
> > > +               __this_cpu_write(last_util_update_time, get_jiffies_64());
> > > +       }
> > > +
> > >         /*
> > >          * If the arch has a polling bit, we maintain an invariant:
> > >          *
> > >
