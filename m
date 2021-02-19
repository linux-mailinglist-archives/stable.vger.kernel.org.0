Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0632004B
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 22:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBSV1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 16:27:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhBSV1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 16:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C1D7614A7;
        Fri, 19 Feb 2021 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613769982;
        bh=/XIejYRoWLE0pbpoMbqcN35Yf4Xh0carzVPABkXJXl0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RR1twQ73MOFdSvN2GxFQavm8mGJMl3Jn6yDSdgfcG0nFTUuz7DUFHASbW++wf2UbW
         1UoZ6Cb5EPvZ1Gtgp7cZkcB5zBQSXj578CkIguCLLqmuuw8KbNb8xS7pF8cJhKWVWs
         lYZz8akZefjVIqorf97Q29C7aVJzpesqzwNQJ8X5dO7fVjZGqwHhfyrHSoL7GID4lT
         DJTutjs6fBlhGBYD3Y30VgeNkph5+fcxJkBUjS+kzjRkHTIxy6dZvUrisLDrIYmxGG
         1wUpfLouGWdHht1F51Psyyh4bIuWPb6+aGrVhdtpkmUcIAn6CGZgTefCfGlnpk2s7e
         ORpvtrbYYyi5g==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 3CC283520E6A; Fri, 19 Feb 2021 13:26:22 -0800 (PST)
Date:   Fri, 19 Feb 2021 13:26:22 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 020/104] ARM: OMAP2+: Fix suspcious RCU usage splats
 for omap_enter_idle_coupled
Message-ID: <20210219212622.GD2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.133238537@linuxfoundation.org>
 <20210219211427.GA27750@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219211427.GA27750@amd>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 10:14:27PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 06862d789ddde8a99c1e579e934ca17c15a84755 ]
> > 
> > We get suspcious RCU usage splats with cpuidle in several places in
> > omap_enter_idle_coupled() with the kernel debug options enabled:
> > 
> > RCU used illegally from extended quiescent state!
> > ...
> > (_raw_spin_lock_irqsave)
> > (omap_enter_idle_coupled+0x17c/0x2d8)
> > (omap_enter_idle_coupled)
> > (cpuidle_enter_state)
> > (cpuidle_enter_state_coupled)
> > (cpuidle_enter)
> > 
> > Let's use RCU_NONIDLE to suppress these splats. Things got changed around
> > with commit 1098582a0f6c ("sched,idle,rcu: Push rcu_idle deeper into the
> > idle path") that started triggering these warnings.
> 
> I just wanted to check... AFAICT RCU_NONIDLE puts some quite heavy
> instrumentation around each statement; does it makes sense to group
> the statements into one in cases like this?

The RCU_NONIDLE() does a pair of value-returning atomic adds, but
to per-CPU variables.  My guess is that that overhead is not large
compared to the functions being called.

Nevertheless, you are right that it would be more efficient to do
something like this:

		RCU_NONIDLE(clkdm_deny_idle(cpu_clkdm[1]);
			    omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
			    clkdm_allow_idle(cpu_clkdm[1]));

And it is the same number of lines, so why not?  ;-)

							Thanx, Paul

> Best regards,
> 								Pavel
> 
> > @@ -194,9 +194,9 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
> >  		    mpuss_can_lose_context)
> >  			gic_dist_disable();
> >  
> > -		clkdm_deny_idle(cpu_clkdm[1]);
> > -		omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
> > -		clkdm_allow_idle(cpu_clkdm[1]);
> > +		RCU_NONIDLE(clkdm_deny_idle(cpu_clkdm[1]));
> > +		RCU_NONIDLE(omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON));
> > +		RCU_NONIDLE(clkdm_allow_idle(cpu_clkdm[1]));
> >  
> >  		if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
> >  		    mpuss_can_lose_context) {
> 
> -- 
> http://www.livejournal.com/~pavelmachek


