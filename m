Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068142EB158
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 18:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbhAER00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 12:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728897AbhAER00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 12:26:26 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595B4C061574;
        Tue,  5 Jan 2021 09:25:45 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id m12so203184lfo.7;
        Tue, 05 Jan 2021 09:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JBAoqa/YYzs12J+EpEorHCfSUVTlayy6/Zn5pCrlnlU=;
        b=Wb/I1FIvHaCKVnSm3BDf3HcY5UB5226ifzpFXz9Bc/IWoi9dhucPYq5+BXuRiOdqc4
         asGGICYjXvJYO4V3MLhHUoau6UMT7bV0EfiRgndua/77F0JeDNc3VY9rIYshHAJ7unz4
         C31/lUz7IPge2XmbIuFR27FIQwTb2mfvtIU0S6wr5D+g4lH9V0WDtIY40lLpzsSNfWyO
         8DaMWjBO9hDOuIVfVQfkp48Wa1L11aYKS63Ac9++6XTVpaTOIUKF3nrlgqbEQfIya3p0
         xTVpJMz6DpA7XeKG0O9bXutyh7wngd7Vj6MMO9SbM4JkjOKl6hh3Zwqlyvxq0YxYrjOs
         /tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBAoqa/YYzs12J+EpEorHCfSUVTlayy6/Zn5pCrlnlU=;
        b=IyFvoyrIlUyY5lB5lY84TCf/3g8vfAeWW/jDr3jo1T80+zEUvYnzdLYtl7tOJOsx2l
         +PjKs+kmPT+CfN2t3kJxrOhpNoiXGXcSXvCIjf1KiiJHExDIoVAJGvx09G71srI0Plys
         j8WCB9xQUReTFMFxnG50UO/9RgpfTJtDbeVKUa6hNZKvlG3hdHKeBjtsHnjn329vf6/p
         IvgzqZrMoWEWyy1SJakNXACu1+BJtrSC0msmpHAnK7dfDeAJ9BG3RpSPcibnj6IIQrce
         NBsqszeHIk45bQ9nc8c02NK6Isir0A8DqJ77HvHKyaXfOuNBt4qOi2/z1TA8A4cAS6Gb
         L7mw==
X-Gm-Message-State: AOAM533jmzeAlBDQ+OggBHDAQH8u7271V3iBajLCzFPGEuo7qkF3VpHE
        YWkS7sk4m68HtdkMKqy9qOdxhrCcnHU=
X-Google-Smtp-Source: ABdhPJzCgGWL4WFl8jteD+gVSVMTu69LYnDY3u3fLr6D6g+bEwKLZ6cN/6UnPfwcAVUmV5xzuTS9Iw==
X-Received: by 2002:ac2:4f88:: with SMTP id z8mr130061lfs.141.1609867543680;
        Tue, 05 Jan 2021 09:25:43 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id 127sm29049lfk.102.2021.01.05.09.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 09:25:43 -0800 (PST)
Subject: Re: [PATCH 2/4] cpuidle: Fix missing need_resched() check after
 rcu_idle_enter()
To:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20201222013712.15056-1-frederic@kernel.org>
 <20201222013712.15056-3-frederic@kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <e882be10-548a-8e90-9bc6-acea453a5241@gmail.com>
Date:   Tue, 5 Jan 2021 20:25:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201222013712.15056-3-frederic@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

22.12.2020 04:37, Frederic Weisbecker пишет:
> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> kthread (rcuog) to be serviced.
> 
> Usually a wake up happening while running the idle task is spotted in
> one of the need_resched() checks carefully placed within the idle loop
> that can break to the scheduler.
> 
> Unfortunately within cpuidle the call to rcu_idle_enter() is already
> beyond the last generic need_resched() check. Some drivers may perform
> their own checks like with mwait_idle_with_hints() but many others don't
> and we may halt the CPU with a resched request unhandled, leaving the
> task hanging.
> 
> Fix this with performing a last minute need_resched() check after
> calling rcu_idle_enter().
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Fixes: 1098582a0f6c (sched,idle,rcu: Push rcu_idle deeper into the idle path)
> Cc: stable@vger.kernel.org
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  drivers/cpuidle/cpuidle.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index ef2ea1b12cd8..4cc1ba49ce05 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -134,8 +134,8 @@ int cpuidle_find_deepest_state(struct cpuidle_driver *drv,
>  }
>  
>  #ifdef CONFIG_SUSPEND
> -static void enter_s2idle_proper(struct cpuidle_driver *drv,
> -				struct cpuidle_device *dev, int index)
> +static int enter_s2idle_proper(struct cpuidle_driver *drv,
> +			       struct cpuidle_device *dev, int index)
>  {
>  	ktime_t time_start, time_end;
>  	struct cpuidle_state *target_state = &drv->states[index];
> @@ -151,7 +151,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>  	stop_critical_timings();
>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>  		rcu_idle_enter();
> -	target_state->enter_s2idle(dev, drv, index);
> +	/*
> +	 * Last need_resched() check must come after rcu_idle_enter()
> +	 * which may wake up RCU internal tasks.
> +	 */
> +	if (!need_resched())
> +		target_state->enter_s2idle(dev, drv, index);
> +	else
> +		index = -EBUSY;
>  	if (WARN_ON_ONCE(!irqs_disabled()))
>  		local_irq_disable();
>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
> @@ -159,10 +166,13 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>  	tick_unfreeze();
>  	start_critical_timings();
>  
> -	time_end = ns_to_ktime(local_clock());
> +	if (index > 0) {

index=0 is valid too

> +		time_end = ns_to_ktime(local_clock());
> +		dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
> +		dev->states_usage[index].s2idle_usage++;
> +	}
>  
> -	dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
> -	dev->states_usage[index].s2idle_usage++;
> +	return index;
>  }
>  
>  /**
> @@ -184,7 +194,7 @@ int cpuidle_enter_s2idle(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  	 */
>  	index = find_deepest_state(drv, dev, U64_MAX, 0, true);
>  	if (index > 0) {
> -		enter_s2idle_proper(drv, dev, index);
> +		index = enter_s2idle_proper(drv, dev, index);
>  		local_irq_enable();
>  	}
>  	return index;
> @@ -234,7 +244,14 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>  	stop_critical_timings();
>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>  		rcu_idle_enter();
> -	entered_state = target_state->enter(dev, drv, index);
> +	/*
> +	 * Last need_resched() check must come after rcu_idle_enter()
> +	 * which may wake up RCU internal tasks.
> +	 */
> +	if (!need_resched())
> +		entered_state = target_state->enter(dev, drv, index);
> +	else
> +		entered_state = -EBUSY;
>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>  		rcu_idle_exit();
>  	start_critical_timings();
> 

This patch causes a hardlock on NVIDIA Tegra using today's linux-next.
Disabling coupled idling state helps. Please fix thanks in advance.
