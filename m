Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34555B9A45
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 14:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIOMB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOMBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 08:01:25 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AD152FD7;
        Thu, 15 Sep 2022 05:01:21 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSwg41bvgz14QPM;
        Thu, 15 Sep 2022 19:57:20 +0800 (CST)
Received: from [10.67.102.169] (10.67.102.169) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 20:01:18 +0800
CC:     <yangyicong@hisilicon.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Barry Song <21cnbao@gmail.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v5] topology: make core_mask include at least
 cluster_siblings
To:     Darren Hart <darren@os.amperecomputing.com>
References: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
From:   Yicong Yang <yangyicong@huawei.com>
Message-ID: <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com>
Date:   Thu, 15 Sep 2022 20:01:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Darren,

On 2022/4/12 4:53, Darren Hart wrote:
> Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> Control Unit, but have no shared CPU-side last level cache.
> 
> cpu_coregroup_mask() will return a cpumask with weight 1, while
> cpu_clustergroup_mask() will return a cpumask with weight 2.
> 
> As a result, build_sched_domain() will BUG() once per CPU with:
> 
> BUG: arch topology borken
> the CLS domain not a subset of the MC domain
> 
> The MC level cpumask is then extended to that of the CLS child, and is
> later removed entirely as redundant. This sched domain topology is an
> improvement over previous topologies, or those built without
> SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> With the current scheduler model and heuristics, this is a desirable
> default topology for Ampere Altra and Altra Max system.
> 
> Rather than create a custom sched domains topology structure and
> introduce new logic in arch/arm64 to detect these systems, update the
> core_mask so coregroup is never a subset of clustergroup, extending it
> to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUSTER
> is enabled to avoid also changing the topology (MC) when
> CONFIG_SCHED_CLUSTER is disabled.
> 
> This has the added benefit over a custom topology of working for both
> symmetric and asymmetric topologies. It does not address systems where
> the CLUSTER topology is above a populated MC topology, but these are not
> considered today and can be addressed separately if and when they
> appear.
> 
> The final sched domain topology for a 2 socket Ampere Altra system is
> unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> 
> For CPU0:
> 
> CONFIG_SCHED_CLUSTER=y
> CLS  [0-1]
> DIE  [0-79]
> NUMA [0-159]
> 
> CONFIG_SCHED_CLUSTER is not set
> DIE  [0-79]
> NUMA [0-159]
> 
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> Cc: <stable@vger.kernel.org> # 5.16.x
> ---
> v1: Drop MC level if coregroup weight == 1
> v2: New sd topo in arch/arm64/kernel/smp.c
> v3: No new topo, extend core_mask to cluster_siblings
> v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).
> v5: Rebase on 5.18-rc2 for GregKH to pull. Add collected tags. No other changes.
> 
>  drivers/base/arch_topology.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> index 1d6636ebaac5..5497c5ab7318 100644
> --- a/drivers/base/arch_topology.c
> +++ b/drivers/base/arch_topology.c
> @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>  			core_mask = &cpu_topology[cpu].llc_sibling;
>  	}
>  
> +	/*
> +	 * For systems with no shared cpu-side LLC but with clusters defined,
> +	 * extend core_mask to cluster_siblings. The sched domain builder will
> +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> +	 */
> +	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> +	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> +		core_mask = &cpu_topology[cpu].cluster_sibling;
> +
>  	return core_mask;
>  }
>  

Is this patch still necessary for Ampere after Ionela's patch [1], which
will limit the cluster's span within coregroup's span.

I found an issue that the NUMA domains are not built on qemu with:

qemu-system-aarch64 \
        -kernel ${Image} \
        -smp 8 \
        -cpu cortex-a72 \
        -m 32G \
        -object memory-backend-ram,id=node0,size=8G \
        -object memory-backend-ram,id=node1,size=8G \
        -object memory-backend-ram,id=node2,size=8G \
        -object memory-backend-ram,id=node3,size=8G \
        -numa node,memdev=node0,cpus=0-1,nodeid=0 \
        -numa node,memdev=node1,cpus=2-3,nodeid=1 \
        -numa node,memdev=node2,cpus=4-5,nodeid=2 \
        -numa node,memdev=node3,cpus=6-7,nodeid=3 \
        -numa dist,src=0,dst=1,val=12 \
        -numa dist,src=0,dst=2,val=20 \
        -numa dist,src=0,dst=3,val=22 \
        -numa dist,src=1,dst=2,val=22 \
        -numa dist,src=1,dst=3,val=24 \
        -numa dist,src=2,dst=3,val=12 \
        -machine virt,iommu=smmuv3 \
        -net none \
        -initrd ${Rootfs} \
        -nographic \
        -bios QEMU_EFI.fd \
        -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"

I can see the schedule domain build stops at MC level since we reach all the
cpus in the system:

[    2.141316] CPU0 attaching sched-domain(s):
[    2.142558]  domain-0: span=0-7 level=MC
[    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
[    2.158357] CPU1 attaching sched-domain(s):
[    2.158964]  domain-0: span=0-7 level=MC
[...]

Without this the NUMA domains are built correctly:

[    2.008885] CPU0 attaching sched-domain(s):
[    2.009764]  domain-0: span=0-1 level=MC
[    2.012654]   groups: 0:{ span=0 cap=962 }, 1:{ span=1 cap=925 }
[    2.016532]   domain-1: span=0-3 level=NUMA
[    2.017444]    groups: 0:{ span=0-1 cap=1887 }, 2:{ span=2-3 cap=1871 }
[    2.019354]    domain-2: span=0-5 level=NUMA
[    2.019983]     groups: 0:{ span=0-3 cap=3758 }, 4:{ span=4-5 cap=1935 }
[    2.021527]     domain-3: span=0-7 level=NUMA
[    2.022516]      groups: 0:{ span=0-5 mask=0-1 cap=5693 }, 6:{ span=4-7 mask=6-7 cap=3978 }
[...]

Hope to see your comments since I have no Ampere machine and I don't know
how to emulate its topology on qemu.

[1] bfcc4397435d ("arch_topology: Limit span of cpu_clustergroup_mask()")

Thanks,
Yicong
