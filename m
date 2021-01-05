Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819DA2EB364
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 20:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbhAETSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 14:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbhAETSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 14:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3781222C7B;
        Tue,  5 Jan 2021 19:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609874276;
        bh=jize7m4/DZjYwfA/32qqlJW5+QRlsOgSyPCucBxn0NY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=KWO6wPdq/k+euIe0Ss07T6qoGZSsFIh9J4QMR5fIirJvlUzPY7xlYQCVL3pCPrQF1
         dfEfrDBbV8ujXrrIeMWu8/AOHghzIFDKwX7goWrGJVd7jLyUx8kY+JD1QKZx9Axigd
         R6Cj4z1Z0F/EKRkA0zwHyvXyj0rLF7PozwesylTdiXPCp08qSqu0r2xcFY6scocZPP
         6VbAoqGbmvO6NeAVb9A28xQhb0Oq8kRleh+XznazIauk4V+hweRGOfv7HNgavXz6Pc
         lzr/CPs8WWkUqa6k5xa8A5FwxpYI9KzlVqxVNgyTf8qEiVhph4+AYmDlktmTj17Arp
         Wl42R80gxZhdg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id DF1583522A62; Tue,  5 Jan 2021 11:17:55 -0800 (PST)
Date:   Tue, 5 Jan 2021 11:17:55 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/4] cpuidle: Fix missing need_resched() check after
 rcu_idle_enter()
Message-ID: <20210105191755.GH17086@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201222013712.15056-1-frederic@kernel.org>
 <20201222013712.15056-3-frederic@kernel.org>
 <e882be10-548a-8e90-9bc6-acea453a5241@gmail.com>
 <8e9f1c38-ca84-6f5b-afdb-e70c07120332@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e9f1c38-ca84-6f5b-afdb-e70c07120332@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 09:10:30PM +0300, Dmitry Osipenko wrote:
> 05.01.2021 20:25, Dmitry Osipenko пишет:
> > 22.12.2020 04:37, Frederic Weisbecker пишет:
> >> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> >> kthread (rcuog) to be serviced.
> >>
> >> Usually a wake up happening while running the idle task is spotted in
> >> one of the need_resched() checks carefully placed within the idle loop
> >> that can break to the scheduler.
> >>
> >> Unfortunately within cpuidle the call to rcu_idle_enter() is already
> >> beyond the last generic need_resched() check. Some drivers may perform
> >> their own checks like with mwait_idle_with_hints() but many others don't
> >> and we may halt the CPU with a resched request unhandled, leaving the
> >> task hanging.
> >>
> >> Fix this with performing a last minute need_resched() check after
> >> calling rcu_idle_enter().
> >>
> >> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> >> Fixes: 1098582a0f6c (sched,idle,rcu: Push rcu_idle deeper into the idle path)
> >> Cc: stable@vger.kernel.org
> >> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> >> ---
> >>  drivers/cpuidle/cpuidle.c | 33 +++++++++++++++++++++++++--------
> >>  1 file changed, 25 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> >> index ef2ea1b12cd8..4cc1ba49ce05 100644
> >> --- a/drivers/cpuidle/cpuidle.c
> >> +++ b/drivers/cpuidle/cpuidle.c
> >> @@ -134,8 +134,8 @@ int cpuidle_find_deepest_state(struct cpuidle_driver *drv,
> >>  }
> >>  
> >>  #ifdef CONFIG_SUSPEND
> >> -static void enter_s2idle_proper(struct cpuidle_driver *drv,
> >> -				struct cpuidle_device *dev, int index)
> >> +static int enter_s2idle_proper(struct cpuidle_driver *drv,
> >> +			       struct cpuidle_device *dev, int index)
> >>  {
> >>  	ktime_t time_start, time_end;
> >>  	struct cpuidle_state *target_state = &drv->states[index];
> >> @@ -151,7 +151,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
> >>  	stop_critical_timings();
> >>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
> >>  		rcu_idle_enter();
> >> -	target_state->enter_s2idle(dev, drv, index);
> >> +	/*
> >> +	 * Last need_resched() check must come after rcu_idle_enter()
> >> +	 * which may wake up RCU internal tasks.
> >> +	 */
> >> +	if (!need_resched())
> >> +		target_state->enter_s2idle(dev, drv, index);
> >> +	else
> >> +		index = -EBUSY;
> >>  	if (WARN_ON_ONCE(!irqs_disabled()))
> >>  		local_irq_disable();
> >>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
> >> @@ -159,10 +166,13 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
> >>  	tick_unfreeze();
> >>  	start_critical_timings();
> >>  
> >> -	time_end = ns_to_ktime(local_clock());
> >> +	if (index > 0) {
> > 
> > index=0 is valid too
> > 
> >> +		time_end = ns_to_ktime(local_clock());
> >> +		dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
> >> +		dev->states_usage[index].s2idle_usage++;
> >> +	}
> >>  
> >> -	dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
> >> -	dev->states_usage[index].s2idle_usage++;
> >> +	return index;
> >>  }
> >>  
> >>  /**
> >> @@ -184,7 +194,7 @@ int cpuidle_enter_s2idle(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> >>  	 */
> >>  	index = find_deepest_state(drv, dev, U64_MAX, 0, true);
> >>  	if (index > 0) {
> >> -		enter_s2idle_proper(drv, dev, index);
> >> +		index = enter_s2idle_proper(drv, dev, index);
> >>  		local_irq_enable();
> >>  	}
> >>  	return index;
> >> @@ -234,7 +244,14 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
> >>  	stop_critical_timings();
> >>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
> >>  		rcu_idle_enter();
> >> -	entered_state = target_state->enter(dev, drv, index);
> >> +	/*
> >> +	 * Last need_resched() check must come after rcu_idle_enter()
> >> +	 * which may wake up RCU internal tasks.
> >> +	 */
> >> +	if (!need_resched())
> >> +		entered_state = target_state->enter(dev, drv, index);
> >> +	else
> >> +		entered_state = -EBUSY;
> >>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
> >>  		rcu_idle_exit();
> >>  	start_critical_timings();
> >>
> > 
> > This patch causes a hardlock on NVIDIA Tegra using today's linux-next.
> > Disabling coupled idling state helps. Please fix thanks in advance.
> 
> This isn't a proper fix, but it works:

There is some ongoing discussion about what an overall proper fix might
look like, so in the meantime I am folding you changes below into
Frederic's original.  ;-)

							Thanx, Paul

> diff --git a/drivers/cpuidle/cpuidle-tegra.c
> b/drivers/cpuidle/cpuidle-tegra.c
> index 191966dc8d02..ecc5d9b31553 100644
> --- a/drivers/cpuidle/cpuidle-tegra.c
> +++ b/drivers/cpuidle/cpuidle-tegra.c
> @@ -148,7 +148,7 @@ static int tegra_cpuidle_c7_enter(void)
> 
>  static int tegra_cpuidle_coupled_barrier(struct cpuidle_device *dev)
>  {
> -	if (tegra_pending_sgi()) {
> +	if (tegra_pending_sgi() || need_resched()) {
>  		/*
>  		 * CPU got local interrupt that will be lost after GIC's
>  		 * shutdown because GIC driver doesn't save/restore the
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 4cc1ba49ce05..2bc52ccc339b 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -248,7 +248,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev,
> struct cpuidle_driver *drv,
>  	 * Last need_resched() check must come after rcu_idle_enter()
>  	 * which may wake up RCU internal tasks.
>  	 */
> -	if (!need_resched())
> +	if ((target_state->flags & CPUIDLE_FLAG_COUPLED) || !need_resched())
>  		entered_state = target_state->enter(dev, drv, index);
>  	else
>  		entered_state = -EBUSY;
> 
