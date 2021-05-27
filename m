Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC973932D5
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhE0Pt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhE0Pt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:49:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33E35613C3;
        Thu, 27 May 2021 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622130504;
        bh=hQW1kh/BKjJFBNVUEjSKpbQOA8E3uC65goMUf6mc/ds=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=XHwNu/5mk1lELTcz2H+ibcCE7S/waMBOLYLsETanWXDunGmovFZp9iRu94Sr1J7d9
         oix2ydjwWDmWgT9kr7hYXzBmo4mWKrJ82OMMlxjgG0/yzJ8hBlQuLkuaq82b/+oftE
         VNE3wuyV1ceCKgy7ZjMsv2QGYOr1Zsx1HXwTWlKtygAMddafgNz3JHLeXEmhcPeZZz
         z8RkWHf51NXxsClTWoKBPb+SY6Fp5tzYGoV7w/w1PM8IXfKloRupMgp2Az0FulZiqe
         Mx8eJtTpUMTMI2gQpKqkKPA05nLCPhewpo0HUGPlx8B1B9vXjA826Cs/5Iob/lHqK2
         af07Pdu7NLghQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E86925C0176; Thu, 27 May 2021 08:48:23 -0700 (PDT)
Date:   Thu, 27 May 2021 08:48:23 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel test robot <oliver.sang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tick/nohz: Only check for RCU deferred wakeup on
 user/guest entry when needed
Message-ID: <20210527154823.GC4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210527113441.465489-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527113441.465489-1-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 01:34:41PM +0200, Frederic Weisbecker wrote:
> Checking for and processing RCU-nocb deferred wakeup upon user/guest
> entry is only relevant when nohz_full runs on the local CPU, otherwise
> the periodic tick should take care of it.

The above initially confused me into thinking that we were dealing
with non-local CPUs, and the patch itself straightened me out.
How about something like this?

	Because the periodic tick is active during user/guest execution
	on non-nohz_full CPUs, only nohz_full CPUs need to check for
	RCU-nocb deferred wakeup on user/guest transitions.

> Make sure we don't needlessly pollute these fast-paths as a -3%
> performance regression on a will-it-scale.per_process_ops has been
> reported so far.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: 47b8ff194c1f (entry: Explicitly flush pending rcuog wakeup before last rescheduling point)
> Fixes: 4ae7dc97f726 (entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point)
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/entry-kvm.h | 3 ++-
>  include/linux/tick.h      | 7 +++++++
>  kernel/entry/common.c     | 5 +++--
>  kernel/time/tick-sched.c  | 1 +
>  4 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
> index 8b2b1d68b954..136b8d97d8c0 100644
> --- a/include/linux/entry-kvm.h
> +++ b/include/linux/entry-kvm.h
> @@ -3,6 +3,7 @@
>  #define __LINUX_ENTRYKVM_H
>  
>  #include <linux/entry-common.h>
> +#include <linux/tick.h>
>  
>  /* Transfer to guest mode work */
>  #ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
> @@ -57,7 +58,7 @@ int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu);
>  static inline void xfer_to_guest_mode_prepare(void)
>  {
>  	lockdep_assert_irqs_disabled();
> -	rcu_nocb_flush_deferred_wakeup();
> +	tick_nohz_user_enter_prepare();
>  }
>  
>  /**
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index 7340613c7eff..1a0ff88fa107 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -11,6 +11,7 @@
>  #include <linux/context_tracking_state.h>
>  #include <linux/cpumask.h>
>  #include <linux/sched.h>
> +#include <linux/rcupdate.h>
>  
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS
>  extern void __init tick_init(void);
> @@ -300,4 +301,10 @@ static inline void tick_nohz_task_switch(void)
>  		__tick_nohz_task_switch();
>  }
>  
> +static inline void tick_nohz_user_enter_prepare(void)
> +{
> +	if (tick_nohz_full_cpu(smp_processor_id()))
> +		rcu_nocb_flush_deferred_wakeup();
> +}
> +
>  #endif
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index a0b3b04fb596..bf16395b9e13 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -5,6 +5,7 @@
>  #include <linux/highmem.h>
>  #include <linux/livepatch.h>
>  #include <linux/audit.h>
> +#include <linux/tick.h>
>  
>  #include "common.h"
>  
> @@ -186,7 +187,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  		local_irq_disable_exit_to_user();
>  
>  		/* Check if any of the above work has queued a deferred wakeup */
> -		rcu_nocb_flush_deferred_wakeup();
> +		tick_nohz_user_enter_prepare();
>  
>  		ti_work = READ_ONCE(current_thread_info()->flags);
>  	}
> @@ -202,7 +203,7 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
>  	lockdep_assert_irqs_disabled();
>  
>  	/* Flush pending rcuog wakeup before the last need_resched() check */
> -	rcu_nocb_flush_deferred_wakeup();
> +	tick_nohz_user_enter_prepare();
>  
>  	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
>  		ti_work = exit_to_user_mode_loop(regs, ti_work);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 828b091501ca..6784f27a3099 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -230,6 +230,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
>  
>  #ifdef CONFIG_NO_HZ_FULL
>  cpumask_var_t tick_nohz_full_mask;
> +EXPORT_SYMBOL_GPL(tick_nohz_full_mask);
>  bool tick_nohz_full_running;
>  EXPORT_SYMBOL_GPL(tick_nohz_full_running);
>  static atomic_t tick_dep_mask;
> -- 
> 2.25.1
> 
