Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4204B5BA7AD
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 09:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiIPH7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 03:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIPH7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 03:59:41 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D3DDF5B;
        Fri, 16 Sep 2022 00:59:37 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTRHt4qm0zBsPM;
        Fri, 16 Sep 2022 15:57:30 +0800 (CST)
Received: from [10.67.102.169] (10.67.102.169) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 15:59:34 +0800
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
 <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com> <YyNnMmtoOrdexLoy@fedora>
From:   Yicong Yang <yangyicong@huawei.com>
Message-ID: <bcd61ebd-d751-57a3-690b-b76c7bd230c5@huawei.com>
Date:   Fri, 16 Sep 2022 15:59:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <YyNnMmtoOrdexLoy@fedora>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.169]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2022/9/16 1:56, Darren Hart wrote:
> On Thu, Sep 15, 2022 at 08:01:18PM +0800, Yicong Yang wrote:
>> Hi Darren,
>>
> 
> Hi Yicong,
> 
> ...
> 
>>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
>>> index 1d6636ebaac5..5497c5ab7318 100644
>>> --- a/drivers/base/arch_topology.c
>>> +++ b/drivers/base/arch_topology.c
>>> @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>>>  			core_mask = &cpu_topology[cpu].llc_sibling;
>>>  	}
>>>  
>>> +	/*
>>> +	 * For systems with no shared cpu-side LLC but with clusters defined,
>>> +	 * extend core_mask to cluster_siblings. The sched domain builder will
>>> +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
>>> +	 */
>>> +	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
>>> +	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
>>> +		core_mask = &cpu_topology[cpu].cluster_sibling;
>>> +
>>>  	return core_mask;
>>>  }
>>>  
>>
>> Is this patch still necessary for Ampere after Ionela's patch [1], which
>> will limit the cluster's span within coregroup's span.
> 
> Yes, see:
> https://lore.kernel.org/lkml/YshYAyEWhE4z%2FKpB@fedora/
> 
> Both patches work together to accomplish the desired sched domains for the
> Ampere Altra family.
> 

Thanks for the link. From my understanding, on the Altra machine we'll get
the following results:

with your patch alone:
Scheduler will get a weight of 2 for both CLS and MC level and finally the
MC domain will be squashed. The lowest domain will be CLS.

with both your patch and Ionela's:
CLS will have a weight of 1 and MC will have a weight of 2. CLS won't be
built and the lowest domain will be MC.

with Ionela's patch alone:
Both CLS and MC will have a weight of 1, which is incorrect.

So your patch is still necessary for Amphere Altra. Then we need to limit
MC span to DIE/NODE span, according to the scheduler's definition for
topology level, for the issue below. Maybe something like this:

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 46cbe4471e78..8ebaba576836 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -713,6 +713,9 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
            cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
                core_mask = &cpu_topology[cpu].cluster_sibling;

+       if (cpumask_subset(cpu_cpu_mask(cpu), core_mask))
+               core_mask = cpu_cpu_mask(cpu);
+
        return core_mask;
 }

>>
>> I found an issue that the NUMA domains are not built on qemu with:
>>
>> qemu-system-aarch64 \
>>         -kernel ${Image} \
>>         -smp 8 \
>>         -cpu cortex-a72 \
>>         -m 32G \
>>         -object memory-backend-ram,id=node0,size=8G \
>>         -object memory-backend-ram,id=node1,size=8G \
>>         -object memory-backend-ram,id=node2,size=8G \
>>         -object memory-backend-ram,id=node3,size=8G \
>>         -numa node,memdev=node0,cpus=0-1,nodeid=0 \
>>         -numa node,memdev=node1,cpus=2-3,nodeid=1 \
>>         -numa node,memdev=node2,cpus=4-5,nodeid=2 \
>>         -numa node,memdev=node3,cpus=6-7,nodeid=3 \
>>         -numa dist,src=0,dst=1,val=12 \
>>         -numa dist,src=0,dst=2,val=20 \
>>         -numa dist,src=0,dst=3,val=22 \
>>         -numa dist,src=1,dst=2,val=22 \
>>         -numa dist,src=1,dst=3,val=24 \
>>         -numa dist,src=2,dst=3,val=12 \
>>         -machine virt,iommu=smmuv3 \
>>         -net none \
>>         -initrd ${Rootfs} \
>>         -nographic \
>>         -bios QEMU_EFI.fd \
>>         -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"
>>
>> I can see the schedule domain build stops at MC level since we reach all the
>> cpus in the system:
>>
>> [    2.141316] CPU0 attaching sched-domain(s):
>> [    2.142558]  domain-0: span=0-7 level=MC
>> [    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
>> [    2.158357] CPU1 attaching sched-domain(s):
>> [    2.158964]  domain-0: span=0-7 level=MC
>> [...]
>>
>> Without this the NUMA domains are built correctly:
>>
> > Without which? My patch, Ionela's patch, or both?
> 

Revert your patch only will have below result, sorry for the ambiguous. Before reverting,
for CPU 0, MC should span 0-1 but with your patch it's extended to 0-7 and the scheduler
domain build will stop at MC level because it has reached all the CPUs.

>> [    2.008885] CPU0 attaching sched-domain(s):
>> [    2.009764]  domain-0: span=0-1 level=MC
>> [    2.012654]   groups: 0:{ span=0 cap=962 }, 1:{ span=1 cap=925 }
>> [    2.016532]   domain-1: span=0-3 level=NUMA
>> [    2.017444]    groups: 0:{ span=0-1 cap=1887 }, 2:{ span=2-3 cap=1871 }
>> [    2.019354]    domain-2: span=0-5 level=NUMA
> 
> I'm not following this topology - what in the description above should result in
> a domain with span=0-5?
> 

It emulates a 3-hop NUMA machine and the NUMA domains will be built according to the
NUMA distances:

node   0   1   2   3
  0:  10  12  20  22
  1:  12  10  22  24
  2:  20  22  10  12
  3:  22  24  12  10

So for CPU 0 the NUMA domains will look like:
NUMA domain 0 for local nodes (squashed to MC domain), CPU 0-1
NUMA domain 1 for nodes within distance 12, CPU 0-3
NUMA domain 2 for nodes within distance 20, CPU 0-5
NUMA domain 3 for all the nodes, CPU 0-7

Thanks.

> 
>> [    2.019983]     groups: 0:{ span=0-3 cap=3758 }, 4:{ span=4-5 cap=1935 }
>> [    2.021527]     domain-3: span=0-7 level=NUMA
>> [    2.022516]      groups: 0:{ span=0-5 mask=0-1 cap=5693 }, 6:{ span=4-7 mask=6-7 cap=3978 }
>> [...]
>>
>> Hope to see your comments since I have no Ampere machine and I don't know
>> how to emulate its topology on qemu.
>>
>> [1] bfcc4397435d ("arch_topology: Limit span of cpu_clustergroup_mask()")
>>
>> Thanks,
>> Yicong
> 
> Thanks,
> 
