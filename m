Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88665E1495
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 10:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbfJWIqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 04:46:17 -0400
Received: from [217.140.110.172] ([217.140.110.172]:44834 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2390034AbfJWIqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 04:46:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A4AB332;
        Wed, 23 Oct 2019 01:45:58 -0700 (PDT)
Received: from [192.168.0.9] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB1E53F71A;
        Wed, 23 Oct 2019 01:45:55 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] sched/topology: Allow sched_asym_cpucapacity to be
 disabled
To:     Valentin Schneider <valentin.schneider@arm.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, qperret@google.com,
        stable@vger.kernel.org
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-3-valentin.schneider@arm.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <fb378e1c-4b13-5ac4-8c86-8422b5362c7b@arm.com>
Date:   Wed, 23 Oct 2019 10:45:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015154250.12951-3-valentin.schneider@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 17:42, Valentin Schneider wrote:
> While the static key is correctly initialized as being disabled, it will
> remain forever enabled once turned on. This means that if we start with an
> asymmetric system and hotplug out enough CPUs to end up with an SMP system,
> the static key will remain set - which is obviously wrong. We should detect
> this and turn off things like misfit migration and capacity aware wakeups.
> 
> As Quentin pointed out, having separate root domains makes this slightly
> trickier. We could have exclusive cpusets that create an SMP island - IOW,
> the domains within this root domain will not see any asymmetry. This means
> we need to count how many asymmetric root domains we have.

Could you make the example a little bit more obvious so we'll remember
later the exact testcase?

We start with 2 asym (hmp) (CPU capacity) exclusive cpusets and we turn
one into a sym (smp) exclusive cpuset via CPU hp.

This patch w/ extra debug on Juno [CPU0 - CPU5] = [L b b L L L]:

root@juno:~# ./scripts/create_excl_cpusets3
[   32.898483] detach_destroy_domains(): sched_asym_cpucapacity is
disabled cpu_map=0-5
[   32.906255] build_sched_domains(): sched_asym_cpucapacity is enabled
cpu_map=0-1,3
[   32.913813] build_sched_domains(): sched_asym_cpucapacity is enabled
cpu_map=2,4-5
root@juno:~# echo 0 > /sys/devices/system/cpu/cpu1/online
[   62.709591] IRQ 2: no longer affine to CPU1
[   62.713840] CPU1: shutdown
[   62.716525] psci: CPU1 killed.
root@juno:~# [   62.728779] detach_destroy_domains():
sched_asym_cpucapacity still enabled cpu_map=0-1,3 <-- Your v1 would
just have disabled sched_asym_cpucapacity here.

A hint that systems with a mix of asym and sym CPU capacity rd's have to
live with the fact that specific asym code is also enabled for the CPUs
of the smp rd's wouldn't harm here.

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

> Change the simple key enablement to an increment, and decrement the key
> counter when destroying domains that cover asymmetric CPUs.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> ---
>  kernel/sched/topology.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 9318acf1d1fe..f0e730143380 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2029,7 +2029,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
>  	rcu_read_unlock();
>  
>  	if (has_asym)
> -		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
> +		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
>  
>  	if (rq && sched_debug_enabled) {
>  		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
> @@ -2125,7 +2125,10 @@ int sched_init_domains(const struct cpumask *cpu_map)
>  static void detach_destroy_domains(const struct cpumask *cpu_map)
>  {
>  	int i;
> +	unsigned int cpu = cpumask_any(cpu_map);
> +
> +	if (rcu_access_pointer(per_cpu(sd_asym_cpucapacity, cpu)))
> +		static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
>  
>  	rcu_read_lock();
>  	for_each_cpu(i, cpu_map)
> --
> 2.22.0
