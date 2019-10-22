Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78463E033D
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfJVLnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 07:43:53 -0400
Received: from [217.140.110.172] ([217.140.110.172]:50202 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2387729AbfJVLnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 07:43:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07DE31045;
        Tue, 22 Oct 2019 04:43:26 -0700 (PDT)
Received: from [192.168.0.9] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33B613F718;
        Tue, 22 Oct 2019 04:43:24 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] sched/topology: Don't try to build empty sched
 domains
To:     Valentin Schneider <valentin.schneider@arm.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, qperret@google.com,
        stable@vger.kernel.org
References: <20191015154250.12951-1-valentin.schneider@arm.com>
 <20191015154250.12951-2-valentin.schneider@arm.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <20dc939f-4102-334e-5fde-a442ee7eaa5e@arm.com>
Date:   Tue, 22 Oct 2019 13:43:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015154250.12951-2-valentin.schneider@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 17:42, Valentin Schneider wrote:
> Turns out hotplugging CPUs that are in exclusive cpusets can lead to the
> cpuset code feeding empty cpumasks to the sched domain rebuild machinery.
> This leads to the following splat:
> 
> [   30.618174] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [   30.623697] Modules linked in:
> [   30.626731] CPU: 0 PID: 235 Comm: kworker/5:2 Not tainted 5.4.0-rc1-00005-g8d495477d62e #23
> [   30.635003] Hardware name: ARM Juno development board (r0) (DT)
> [   30.640877] Workqueue: events cpuset_hotplug_workfn
> [   30.645713] pstate: 60000005 (nZCv daif -PAN -UAO)
> [   30.650464] pc : build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
> [   30.655126] lr : build_sched_domains (kernel/sched/topology.c:1966)
> [...]
> [   30.742047] Call trace:
> [   30.744474] build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
> [   30.748793] partition_sched_domains_locked (kernel/sched/topology.c:2250)
> [   30.753971] rebuild_sched_domains_locked (./include/linux/bitmap.h:370 ./include/linux/cpumask.h:538 kernel/cgroup/cpuset.c:955 kernel/cgroup/cpuset.c:978 kernel/cgroup/cpuset.c:1019)
> [   30.758977] rebuild_sched_domains (kernel/cgroup/cpuset.c:1032)
> [   30.763209] cpuset_hotplug_workfn (kernel/cgroup/cpuset.c:3205 (discriminator 2))
> [   30.767613] process_one_work (./arch/arm64/include/asm/jump_label.h:21 ./include/linux/jump_label.h:200 ./include/trace/events/workqueue.h:114 kernel/workqueue.c:2274)
> [   30.771586] worker_thread (./include/linux/compiler.h:199 ./include/linux/list.h:268 kernel/workqueue.c:2416)
> [   30.775217] kthread (kernel/kthread.c:255)
> [   30.778418] ret_from_fork (arch/arm64/kernel/entry.S:1167)
> [ 30.781965] Code: f860dae2 912802d6 aa1603e1 12800000 (f8616853)
> 
> The faulty line in question is
> 
>   cap = arch_scale_cpu_capacity(cpumask_first(cpu_map));
> 
> and we're not checking the return value against nr_cpu_ids (we shouldn't
> have to!), which leads to the above.
> 
> Prevent generate_sched_domains() from returning empty cpumasks, and add
> some assertion in build_sched_domains() to scream bloody murder if it
> happens again.

First I thought we can do with a little less drama by only preventing
arch_scale_cpu_capacity() from consuming >= nr_cpu_ids.

@@ -1894,6 +1894,9 @@ static struct sched_domain_topology_level
        struct sched_domain_topology_level *tl, *asym_tl = NULL;
        unsigned long cap;

+       if (cpumask_empty(cpu_map))
+               return NULL;
+

Until I tried to hp'ed in CPU4 after CPU4/5 had been hp'ed out (your
example further below) and I got another:

[   68.014564] Unable to handle kernel paging request at virtual address
fffe8009903d8ee0
...
[   68.191293] Call trace:
[   68.193712]  partition_sched_domains_locked+0x1a4/0x4a0
[   68.198882]  rebuild_sched_domains_locked+0x4d0/0x7b0
[   68.203880]  rebuild_sched_domains+0x24/0x40
[   68.208104]  cpuset_hotplug_workfn+0xe0/0x5f8
...

@@ -2213,6 +2216,11 @@ void partition_sched_domains_locked(int
ndoms_new, cpumask_var_t doms_new[],
                               * will be recomputed in function
                               * update_tasks_root_domain().
                               */
+                             if (cpumask_empty(doms_cur[i]))
+                                    printk("doms_cur[%d] empty\n", i);
+
                              rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;

doms_cur[i] is empty when hp'ing in CPU4 again.

Your patch fixes this as well.

Might be worth noting that this is not only about asym CPU capacity
handling but missing checks after cpumask operations in case the cpuset
is empty.

> The above splat was obtained on my Juno r0 with:>
>   cgcreate -g cpuset:asym
>   cgset -r cpuset.cpus=0-3 asym
>   cgset -r cpuset.mems=0 asym
>   cgset -r cpuset.cpu_exclusive=1 asym
> 
>   cgcreate -g cpuset:smp
>   cgset -r cpuset.cpus=4-5 smp
>   cgset -r cpuset.mems=0 smp
>   cgset -r cpuset.cpu_exclusive=1 smp
> 
>   cgset -r cpuset.sched_load_balance=0 .
> 
>   echo 0 > /sys/devices/system/cpu/cpu4/online
>   echo 0 > /sys/devices/system/cpu/cpu5/online
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 05484e098448 ("sched/topology: Add SD_ASYM_CPUCAPACITY flag detection")
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> ---
>  kernel/cgroup/cpuset.c  | 8 ++++++++
>  kernel/sched/topology.c | 5 ++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c52bc91f882b..a859e5539440 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -817,6 +817,11 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  		struct cpuset *a = csa[i];
>  		int apn = a->pn;
>  
> +		if (cpumask_empty(a->effective_cpus)) {
> +			ndoms--;
> +			continue;
> +		}
> +
>  		for (j = 0; j < csn; j++) {
>  			struct cpuset *b = csa[j];
>  			int bpn = b->pn;
> @@ -859,6 +864,9 @@ static int generate_sched_domains(cpumask_var_t **domains,
>  			continue;
>  		}
>  
> +		if (cpumask_empty(a->effective_cpus))
> +			continue;
> +
>  		dp = doms[nslot];
>  
>  		if (nslot == ndoms) {
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index b5667a273bf6..9318acf1d1fe 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1948,7 +1948,7 @@ static struct sched_domain_topology_level
>  static int
>  build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *attr)
>  {
> -	enum s_alloc alloc_state;
> +	enum s_alloc alloc_state = sa_none;
>  	struct sched_domain *sd;
>  	struct s_data d;
>  	struct rq *rq = NULL;
> @@ -1956,6 +1956,9 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
>  	struct sched_domain_topology_level *tl_asym;
>  	bool has_asym = false;
>  
> +	if (WARN_ON(cpumask_empty(cpu_map)))
> +		goto error;
> +
>  	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
>  	if (alloc_state != sa_rootdomain)
>  		goto error;
> 
