Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420362EB22E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbhAESLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbhAESLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:11:14 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050B6C061574;
        Tue,  5 Jan 2021 10:10:34 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o17so584677lfg.4;
        Tue, 05 Jan 2021 10:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PVuT4njhMeaRTMbjqaPyRkMWi9XdHjI6gVBrQVbTMz4=;
        b=rcDUAV4lu4M+f3TH0c8rV1aWi/VBMrzLzxc90aChur6L67D8bKfinZ/Vbo7kmihKdR
         k499Zq6WypkjoIiQFnUX7wfrXOQzPZOKoS1Mrfs9BWZ14jaW3K7ZanWBh0yJi74Ey6q8
         r85fShbYb4ZK6zgNKDQYFzPCvs2rDXCQr18X3mPkhEszejzuUIladcXfDYaDCTYxn3To
         Fuhgc5kSFIsvVRsjjSzIT9hnGn/afjrvoMD9j8PnKYlrbjyp8D7qiIzTtsLXkbIYVDSG
         pHpF8shBKS6e2EARr7QOWhMNQGKSoTsBmBpcdEOX6U1BtIrtu/dYynat4nwmgMi4TRCO
         U9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVuT4njhMeaRTMbjqaPyRkMWi9XdHjI6gVBrQVbTMz4=;
        b=GvpNXqr38lX8QXAA4igcJ+cEHrGR96taKN1vjDcxe7uSAXRcCq7zl/OXsUBfFda7hs
         iB1iRqXz/u6pKjbOQCFaonMLbt88UNdUBOlEXdGq5J7OuQohtg2kG1bSH+15ETbHg10O
         yVFLybMVE7Ve6gOD1J0yG9AgJwQrjAWVFhW6yq9Px+msLSa1iQZJ/0MqG9+5FSdagu9U
         97DzqtqNbhkCXjUU2Ay6EzetXZma3H1F+kE/bTktryayDQz/XM/YknKzm2zi4Qfl/rMk
         yJyzfGD36G9e2TEbtnFoSIky/q9DaC6WWLn1CSPezwu2ZyCoEW27nkOu2aj/SDQ8HE/Z
         QCAg==
X-Gm-Message-State: AOAM531WGZHC+b2fw12c2JiIZMXX7gnQ59drDzq+5H7wQiuB4vCcEwcQ
        bC0XYIKSbuXCMeGXV7bIURxpOKPNk+4=
X-Google-Smtp-Source: ABdhPJx8cqdU2WRiMEbpSfhRzpGvYiCjbz/MwDS3LC27F8PoVz2cTyyTnzo18VIEWINCvPLj11dlAg==
X-Received: by 2002:a2e:810c:: with SMTP id d12mr378046ljg.400.1609870232298;
        Tue, 05 Jan 2021 10:10:32 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id y23sm51413ljc.119.2021.01.05.10.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 10:10:31 -0800 (PST)
Subject: Re: [PATCH 2/4] cpuidle: Fix missing need_resched() check after
 rcu_idle_enter()
From:   Dmitry Osipenko <digetx@gmail.com>
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
 <e882be10-548a-8e90-9bc6-acea453a5241@gmail.com>
Message-ID: <8e9f1c38-ca84-6f5b-afdb-e70c07120332@gmail.com>
Date:   Tue, 5 Jan 2021 21:10:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <e882be10-548a-8e90-9bc6-acea453a5241@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

05.01.2021 20:25, Dmitry Osipenko пишет:
> 22.12.2020 04:37, Frederic Weisbecker пишет:
>> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
>> kthread (rcuog) to be serviced.
>>
>> Usually a wake up happening while running the idle task is spotted in
>> one of the need_resched() checks carefully placed within the idle loop
>> that can break to the scheduler.
>>
>> Unfortunately within cpuidle the call to rcu_idle_enter() is already
>> beyond the last generic need_resched() check. Some drivers may perform
>> their own checks like with mwait_idle_with_hints() but many others don't
>> and we may halt the CPU with a resched request unhandled, leaving the
>> task hanging.
>>
>> Fix this with performing a last minute need_resched() check after
>> calling rcu_idle_enter().
>>
>> Reported-by: Paul E. McKenney <paulmck@kernel.org>
>> Fixes: 1098582a0f6c (sched,idle,rcu: Push rcu_idle deeper into the idle path)
>> Cc: stable@vger.kernel.org
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>  drivers/cpuidle/cpuidle.c | 33 +++++++++++++++++++++++++--------
>>  1 file changed, 25 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index ef2ea1b12cd8..4cc1ba49ce05 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -134,8 +134,8 @@ int cpuidle_find_deepest_state(struct cpuidle_driver *drv,
>>  }
>>  
>>  #ifdef CONFIG_SUSPEND
>> -static void enter_s2idle_proper(struct cpuidle_driver *drv,
>> -				struct cpuidle_device *dev, int index)
>> +static int enter_s2idle_proper(struct cpuidle_driver *drv,
>> +			       struct cpuidle_device *dev, int index)
>>  {
>>  	ktime_t time_start, time_end;
>>  	struct cpuidle_state *target_state = &drv->states[index];
>> @@ -151,7 +151,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>>  	stop_critical_timings();
>>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>>  		rcu_idle_enter();
>> -	target_state->enter_s2idle(dev, drv, index);
>> +	/*
>> +	 * Last need_resched() check must come after rcu_idle_enter()
>> +	 * which may wake up RCU internal tasks.
>> +	 */
>> +	if (!need_resched())
>> +		target_state->enter_s2idle(dev, drv, index);
>> +	else
>> +		index = -EBUSY;
>>  	if (WARN_ON_ONCE(!irqs_disabled()))
>>  		local_irq_disable();
>>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>> @@ -159,10 +166,13 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>>  	tick_unfreeze();
>>  	start_critical_timings();
>>  
>> -	time_end = ns_to_ktime(local_clock());
>> +	if (index > 0) {
> 
> index=0 is valid too
> 
>> +		time_end = ns_to_ktime(local_clock());
>> +		dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
>> +		dev->states_usage[index].s2idle_usage++;
>> +	}
>>  
>> -	dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
>> -	dev->states_usage[index].s2idle_usage++;
>> +	return index;
>>  }
>>  
>>  /**
>> @@ -184,7 +194,7 @@ int cpuidle_enter_s2idle(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>>  	 */
>>  	index = find_deepest_state(drv, dev, U64_MAX, 0, true);
>>  	if (index > 0) {
>> -		enter_s2idle_proper(drv, dev, index);
>> +		index = enter_s2idle_proper(drv, dev, index);
>>  		local_irq_enable();
>>  	}
>>  	return index;
>> @@ -234,7 +244,14 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>>  	stop_critical_timings();
>>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>>  		rcu_idle_enter();
>> -	entered_state = target_state->enter(dev, drv, index);
>> +	/*
>> +	 * Last need_resched() check must come after rcu_idle_enter()
>> +	 * which may wake up RCU internal tasks.
>> +	 */
>> +	if (!need_resched())
>> +		entered_state = target_state->enter(dev, drv, index);
>> +	else
>> +		entered_state = -EBUSY;
>>  	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE))
>>  		rcu_idle_exit();
>>  	start_critical_timings();
>>
> 
> This patch causes a hardlock on NVIDIA Tegra using today's linux-next.
> Disabling coupled idling state helps. Please fix thanks in advance.
> 

This isn't a proper fix, but it works:

diff --git a/drivers/cpuidle/cpuidle-tegra.c
b/drivers/cpuidle/cpuidle-tegra.c
index 191966dc8d02..ecc5d9b31553 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -148,7 +148,7 @@ static int tegra_cpuidle_c7_enter(void)

 static int tegra_cpuidle_coupled_barrier(struct cpuidle_device *dev)
 {
-	if (tegra_pending_sgi()) {
+	if (tegra_pending_sgi() || need_resched()) {
 		/*
 		 * CPU got local interrupt that will be lost after GIC's
 		 * shutdown because GIC driver doesn't save/restore the
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 4cc1ba49ce05..2bc52ccc339b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -248,7 +248,7 @@ int cpuidle_enter_state(struct cpuidle_device *dev,
struct cpuidle_driver *drv,
 	 * Last need_resched() check must come after rcu_idle_enter()
 	 * which may wake up RCU internal tasks.
 	 */
-	if (!need_resched())
+	if ((target_state->flags & CPUIDLE_FLAG_COUPLED) || !need_resched())
 		entered_state = target_state->enter(dev, drv, index);
 	else
 		entered_state = -EBUSY;

