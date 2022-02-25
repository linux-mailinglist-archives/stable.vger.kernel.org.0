Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4E4C3AB9
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 02:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiBYBHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 20:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiBYBHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 20:07:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4A12A738;
        Thu, 24 Feb 2022 17:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25BA8CE1FBF;
        Fri, 25 Feb 2022 01:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BCFC340E9;
        Fri, 25 Feb 2022 01:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645751217;
        bh=GOh4v1us5hGPHjwFIKfSUpKAr4SsRrg4RnNK+eIyPds=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=kWTO7fPCqr8WbvHPd8I8T/AQaJygovFVc3tPasa3ixbHdd/xad/3z4xiznl5p+Lk/
         SKO7VARF/3IpkTx4528H/hag7vD/jHz6IWFGlD4vDWcaOKjXxidik9YfTaYEbAA/4M
         U6MlbwisQ7F0gxOUR4teX9k99nrnfIHbepI3/ziYcefPpamxU9VWiTIkamqtQkFBOr
         PtWXwL9Br5j4/o9MrxJok5a5LXaE+pelsgOPnbBkFHJ1G8bFpYjNzZdPoTjnzKRL6R
         t87Nq+AfMlQln2T67yQu1aMbX2kY/g6dI6s81yBMJlKLIk3LoY3GS2lBr3yjTQGnwS
         Kyo/nzyYm0lpg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 133245C017D; Thu, 24 Feb 2022 17:06:57 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:06:57 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220225010657.GB4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com>
 <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
 <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
 <20220223004041.GA4548@shbuild999.sh.intel.com>
 <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
 <20220224080830.GD4548@shbuild999.sh.intel.com>
 <20220224144423.GV4285@paulmck-ThinkPad-P17-Gen-1>
 <20220225002951.GE4548@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225002951.GE4548@shbuild999.sh.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 08:29:51AM +0800, Feng Tang wrote:
> Hi Paul,
> 
> On Thu, Feb 24, 2022 at 06:44:23AM -0800, Paul E. McKenney wrote:
> [...]
> > > > > > Rafael replied with one possible option. Alternatively when planing to
> > > > > > enter deep idle, set P-state to min with a callback like we do in
> > > > > > offline callback.
> > > > >
> > > > > Yes, if the system is going to idle, it makes sense to goto a lower
> > > > > cpufreq first (also what my debug patch will essentially lead to).
> > > > >
> > > > > Given cprfreq-util's normal running frequency is every 10ms, doing
> > > > > this before entering idle is not a big extra burden.
> > > > 
> > > > But this is not related to idle as such, but to the fact that idle
> > > > sometimes stops the scheduler tick which otherwise would run the
> > > > cpufreq governor callback on a regular basis.
> > > > 
> > > > It is stopping the tick that gets us into trouble, so I would avoid
> > > > doing it if the current performance state is too aggressive.
> > > 
> > > I've tried to simulate Doug's environment by using his kconfig, and
> > > offline my 36 CPUs Desktop to leave 12 CPUs online, and on it I can
> > > still see Local timer interrupts when there is no active load, with
> > > the longest interval between 2 timer interrupts is 4 seconds, while
> > > idle class's task_tick_idle() will do nothing, and CFS'
> > > task_tick_fair() will in turn call cfs_rq_util_change()
> > 
> > Every four seconds?  Could you please post your .config?
>  
> Aha, I didn't make it clear, that the timer interrupt was not always
> coming every 4 seconds, but when system is silent, the maxim interval
> between 2 timer interrupts was 4 seconds.
> 
> When initially I checked this, I doubted if the timer interrupt are
> too few on the system, so I used Doug's config and tried to make my
> desktop silent (like disabling GUI), following is some trace_printk
> log, though I figured out later when idle thread is running, the
> idle class' scheduler tick will not help as it doesn't call cpufreq
> callback.
> 
>           <idle>-0       [009] d.h1.   235.980053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.981054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.982053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.983053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.984053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.985053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.986054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.987054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.988054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.989054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.990054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.991053: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.992054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.993054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   235.994054: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   236.331126: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   236.460130: hrtimer_interrupt: enter
>           <idle>-0       [009] d.s5.   236.460147: intel_pstate_update_util: old_state=48 new=27
>           <idle>-0       [009] d.h1.   238.380130: hrtimer_interrupt: enter
>           <idle>-0       [009] d.s5.   238.380147: intel_pstate_update_util: old_state=27 new=12
>           <idle>-0       [009] d.h1.   240.331133: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   240.364133: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   244.331135: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   248.331139: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   252.331138: hrtimer_interrupt: enter
>            <...>-1167    [009] d.h..   254.860056: hrtimer_interrupt: enter
>            snapd-1128    [009] d.h..   254.861054: hrtimer_interrupt: enter
>            snapd-1128    [009] d.h..   254.862055: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   254.863056: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   254.864056: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   254.865055: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   256.331133: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   260.331127: hrtimer_interrupt: enter
>           <idle>-0       [009] d.h1.   264.331135: hrtimer_interrupt: enter

Thank you for the clarification!

							Thanx, Paul
