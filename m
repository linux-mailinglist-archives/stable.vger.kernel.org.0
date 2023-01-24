Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6767A630
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 23:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjAXW4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 17:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjAXW4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 17:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4D446719;
        Tue, 24 Jan 2023 14:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E111C6137B;
        Tue, 24 Jan 2023 22:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A66C433D2;
        Tue, 24 Jan 2023 22:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674600989;
        bh=QV13JY8PQ02u2BMhjhQlrKhEEqji7+JXyt4jC9lmAi4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=amCuBSxHqvdOp5yoiB3GBkjxiiNCu5ecC6u35xwIisrjcDw8ExXFj7vwxC3MfDQXR
         Z55BS15arBgzGS4g0TZpIkkHHVwmsf5l5BbWee/q0hEHqVxTRMrThW09KOC/ykc9vY
         a8ZMmfPlvDUyEMiBUmOZ8eNdt51rVbNW9zdY/y+1GIQOrIrUkkbakASed+nuvRExOd
         K9BnfiIti9mtziphP990an/Ku2mOw36Eyw4W3taMUzZ92Nzpy5JrnVXcopW3Dc8TXN
         k8zcb7YQ9lJ9cN2Pp1uDnyb9CQ6OqPBm+EWYBfmeWivcekzkeENxXBLS3/Jo4ikLB7
         Dw0qbqVtQ6fmQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id E1D1C5C1183; Tue, 24 Jan 2023 14:56:28 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:56:28 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 RESEND] tick/nohz: Fix cpu_is_hotpluggable() by
 checking with nohz subsystem
Message-ID: <20230124225628.GZ2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230124173126.3492345-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124173126.3492345-1-joel@joelfernandes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 05:31:26PM +0000, Joel Fernandes (Google) wrote:
> For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> torture tests that do offlining to end up trying to offline this CPU causing
> test failures. Such failure happens on all architectures.
> 
> Fix it by asking the opinion of the nohz subsystem on whether the CPU can
> be hotplugged.
> 
> [ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]
> 
> For drivers/base/ portion:
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: rcu <rcu@vger.kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Queued for further review and testing, thank you both!

It might be a few hours until it becomes publicly visible, but it will
get there.

							Thanx, Paul

> ---
> Sorry, resending with CC to stable.
> 
>  drivers/base/cpu.c       |  3 ++-
>  include/linux/tick.h     |  2 ++
>  kernel/time/tick-sched.c | 11 ++++++++---
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 55405ebf23ab..450dca235a2f 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -487,7 +487,8 @@ static const struct attribute_group *cpu_root_attr_groups[] = {
>  bool cpu_is_hotpluggable(unsigned int cpu)
>  {
>  	struct device *dev = get_cpu_device(cpu);
> -	return dev && container_of(dev, struct cpu, dev)->hotpluggable;
> +	return dev && container_of(dev, struct cpu, dev)->hotpluggable
> +		&& tick_nohz_cpu_hotpluggable(cpu);
>  }
>  EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
>  
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index bfd571f18cfd..9459fef5b857 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -216,6 +216,7 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
>  				     enum tick_dep_bits bit);
>  extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
>  				       enum tick_dep_bits bit);
> +extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
>  
>  /*
>   * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
> @@ -280,6 +281,7 @@ static inline void tick_nohz_full_add_cpus_to(struct cpumask *mask) { }
>  
>  static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
>  static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
> +static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
>  
>  static inline void tick_dep_set(enum tick_dep_bits bit) { }
>  static inline void tick_dep_clear(enum tick_dep_bits bit) { }
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 9c6f661fb436..63e3e8ebcd64 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -510,7 +510,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
>  	tick_nohz_full_running = true;
>  }
>  
> -static int tick_nohz_cpu_down(unsigned int cpu)
> +bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
>  {
>  	/*
>  	 * The tick_do_timer_cpu CPU handles housekeeping duty (unbound
> @@ -518,8 +518,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
>  	 * CPUs. It must remain online when nohz full is enabled.
>  	 */
>  	if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
> -		return -EBUSY;
> -	return 0;
> +		return false;
> +	return true;
> +}
> +
> +static int tick_nohz_cpu_down(unsigned int cpu)
> +{
> +	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
>  }
>  
>  void __init tick_nohz_init(void)
> -- 
> 2.39.1.405.gd4c25cc71f-goog
> 
