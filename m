Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F0E6697D3
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbjAMM6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241721AbjAMM5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:57:08 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3BFA16584;
        Fri, 13 Jan 2023 04:45:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B491CFEC;
        Fri, 13 Jan 2023 04:45:55 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.46.126])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C4BE3F587;
        Fri, 13 Jan 2023 04:45:12 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:45:04 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Thomas Gleixner <tglx@linotronix.de>, stable@vger.kernel.org,
        Yogesh Lal <quic_ylal@quicinc.com>
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
Message-ID: <Y8FSUOC7k3ChMazG@FVFF77S0Q05N>
References: <20230113111648.1977473-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113111648.1977473-1-maz@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On Fri, Jan 13, 2023 at 11:16:48AM +0000, Marc Zyngier wrote:
> When booting on a CPU that has a countertum on the counter read,
> we use the arch_counter_get_cnt{v,p}ct_stable() backend which
> applies the workaround.
> 
> However, we don't do the same thing when an affected CPU is
> a secondary CPU, and we're stuck with the standard sched_clock()
> backend that knows nothing about the workaround.
> 
> Fix it by always indirecting sched_clock(), making arch_timer_read_counter
> a function instead of a function pointer. In turn, we update the
> pointer (now private to the driver code) when detecting a new
> workaround.

Unfortunately, I don't think this is sufficient.

I'm pretty sure secondary CPUs might call sched_clock() before getting to
arch_counter_register(), so there'll be a window where this could go wrong.

If we consider late onlining on a preemptible kernel we'll also have a race at
runtime:

| sched_clock() {
| 	arch_timer_read_counter() {
| 		// reads __arch_timer_read_counter == arch_counter_get_cntvct;
| 		
| 		arch_counter_get_cntvct() {
| 			
| 			< PREEMPTED >
| 			< CPU requiring workaround onlined >
| 			< RESCHEDULED on affected CPU >
| 
| 			MRS xN, CNTVCT_EL0	// reads junk here
| 		}
| 	}
| }

I think we need to reconsider the approach.

Since the accessor is out-of-line anyway, we could use a static key *within*
the accessor to handle that, e.g.

| u64 arch_timer_get_cntvct(void)
| {
| 	u64 val = read_sysreg(cntvct_el0);
| 	if (!static_branch_unlikely(use_timer_workaround))
| 		return val;
| 
| 	// do stablisation workaround here
| 	
| 	return val;
| }

... and we'd need to transiently enable the workaround when beinging a CPU
online in case it needs the workaround. We could use the static key inc / dec
helpers from the CPU invoking the hotplug to manage that.

With that, we should never perform the first read on an affected core without
also deciding to perform the workaround.

Does that make sound plausible?

Thanks,
Mark.

> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@kernel.org>
> Cc: Thomas Gleixner <tglx@linotronix.de>
> Cc: stable@vger.kernel.org
> Reported-by: Yogesh Lal <quic_ylal@quicinc.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter to access stable counters")
> Link: https://lore.kernel.org/r/ca4679a0-7f29-65f4-54b9-c575248192f1@quicinc.com
> ---
>  drivers/clocksource/arm_arch_timer.c | 56 +++++++++++++++++-----------
>  include/clocksource/arm_arch_timer.h |  2 +-
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index e09d4427f604..5272db86bef5 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -217,7 +217,12 @@ static notrace u64 arch_counter_get_cntvct(void)
>   * to exist on arm64. arm doesn't use this before DT is probed so even
>   * if we don't have the cp15 accessors we won't have a problem.
>   */
> -u64 (*arch_timer_read_counter)(void) __ro_after_init = arch_counter_get_cntvct;
> +static u64 (*__arch_timer_read_counter)(void) __ro_after_init = arch_counter_get_cntvct;
> +
> +u64 arch_timer_read_counter(void)
> +{
> +	return __arch_timer_read_counter();

Since the function pointer can be modified concurrently, we'll need to use 
	return READ_ONCE(__arch_timer_read_counter)();

SInce this could change dynamically, we
> +}
>  EXPORT_SYMBOL_GPL(arch_timer_read_counter);
>  
>  static u64 arch_counter_read(struct clocksource *cs)
> @@ -230,6 +235,28 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
>  	return arch_timer_read_counter();
>  }
>  
> +static bool arch_timer_counter_has_wa(void);
> +
> +static u64 (*arch_counter_get_read_fn(void))(void)
> +{
> +	u64 (*rd)(void);
> +
> +	if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
> +	    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
> +		if (arch_timer_counter_has_wa())
> +			rd = arch_counter_get_cntvct_stable;
> +		else
> +			rd = arch_counter_get_cntvct;
> +	} else {
> +		if (arch_timer_counter_has_wa())
> +			rd = arch_counter_get_cntpct_stable;
> +		else
> +			rd = arch_counter_get_cntpct;
> +	}
> +
> +	return rd;
> +}
> +
>  static struct clocksource clocksource_counter = {
>  	.name	= "arch_sys_counter",
>  	.id	= CSID_ARM_ARCH_COUNTER,
> @@ -571,8 +598,10 @@ void arch_timer_enable_workaround(const struct arch_timer_erratum_workaround *wa
>  			per_cpu(timer_unstable_counter_workaround, i) = wa;
>  	}
>  
> -	if (wa->read_cntvct_el0 || wa->read_cntpct_el0)
> -		atomic_set(&timer_unstable_counter_workaround_in_use, 1);
> +	if (wa->read_cntvct_el0 || wa->read_cntpct_el0) {
> +		__arch_timer_read_counter = arch_counter_get_read_fn();
> +		atomic_set_release(&timer_unstable_counter_workaround_in_use, 1);
> +	}
>  
>  	/*
>  	 * Don't use the vdso fastpath if errata require using the
> @@ -641,7 +670,7 @@ static bool arch_timer_counter_has_wa(void)
>  #else
>  #define arch_timer_check_ool_workaround(t,a)		do { } while(0)
>  #define arch_timer_this_cpu_has_cntvct_wa()		({false;})
> -#define arch_timer_counter_has_wa()			({false;})
> +static bool arch_timer_counter_has_wa(void)		{ return false; }
>  #endif /* CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND */
>  
>  static __always_inline irqreturn_t timer_handler(const int access,
> @@ -1079,25 +1108,10 @@ static void __init arch_counter_register(unsigned type)
>  
>  	/* Register the CP15 based counter if we have one */
>  	if (type & ARCH_TIMER_TYPE_CP15) {
> -		u64 (*rd)(void);
> -
> -		if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
> -		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
> -			if (arch_timer_counter_has_wa())
> -				rd = arch_counter_get_cntvct_stable;
> -			else
> -				rd = arch_counter_get_cntvct;
> -		} else {
> -			if (arch_timer_counter_has_wa())
> -				rd = arch_counter_get_cntpct_stable;
> -			else
> -				rd = arch_counter_get_cntpct;
> -		}
> -
> -		arch_timer_read_counter = rd;
> +		__arch_timer_read_counter = arch_counter_get_read_fn();
>  		clocksource_counter.vdso_clock_mode = vdso_default;
>  	} else {
> -		arch_timer_read_counter = arch_counter_get_cntvct_mem;
> +		__arch_timer_read_counter = arch_counter_get_cntvct_mem;
>  	}
>  
>  	width = arch_counter_get_width();
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 057c8964aefb..ec331b65ba23 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -85,7 +85,7 @@ struct arch_timer_mem {
>  #ifdef CONFIG_ARM_ARCH_TIMER
>  
>  extern u32 arch_timer_get_rate(void);
> -extern u64 (*arch_timer_read_counter)(void);
> +extern u64 arch_timer_read_counter(void);
>  extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
>  extern bool arch_timer_evtstrm_available(void);
>  
> -- 
> 2.34.1
> 
