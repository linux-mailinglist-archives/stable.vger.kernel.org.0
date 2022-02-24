Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0064C2EA0
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 15:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiBXOo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 09:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBXOo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 09:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DE117C431;
        Thu, 24 Feb 2022 06:44:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A9AB82334;
        Thu, 24 Feb 2022 14:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CA2C340EC;
        Thu, 24 Feb 2022 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645713864;
        bh=w38XcZW4h/uXQcEPmQ0w+Knq1QM1qKJReRNuugwJW/E=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dpI2lz8kRA6FpOZ1BXfO0Ar8Bmhu3vIpQwOiZJftAdbjKvobBzzA4XzhdbZrYQ3hw
         CyvCjSiqiJQdoSLLl/rcs3h6siNoBKiqVnT04GsTGiOLWCyZU6NEhXU1fH470sDVFM
         uWWbJF7iy5q1IwlAT8mUrKp3uLzOuEDlAPDfKHpgrxWbVxunVrzPrQ03txxD7qSl4n
         HozsmceHA1gZXdrdHCyUpcQnhlxUEb2rgYITH+Uc+KfauUzp74UQEs3TmHA/o5JFzO
         U+EjzuWkt9L2w1CWBVF22ynrJG9r1JALA7Wbu5FrMLoQp3sleHLQrMDQ84hVSRX3vf
         nQuavD4hhfTrw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id F26D05C00F7; Thu, 24 Feb 2022 06:44:23 -0800 (PST)
Date:   Thu, 24 Feb 2022 06:44:23 -0800
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
Message-ID: <20220224144423.GV4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <e185b89fb97f47758a5e10239fc3eed0@intel.com>
 <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com>
 <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
 <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com>
 <20220223004041.GA4548@shbuild999.sh.intel.com>
 <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
 <20220224080830.GD4548@shbuild999.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224080830.GD4548@shbuild999.sh.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 04:08:30PM +0800, Feng Tang wrote:
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

Every four seconds?  Could you please post your .config?

							Thanx, Paul

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
> 
> Thanks,
> Feng
> 
