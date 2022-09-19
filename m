Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9405BCD03
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiISNXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 09:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiISNXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 09:23:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3252CC97;
        Mon, 19 Sep 2022 06:23:02 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWQHM40h2zlVyn;
        Mon, 19 Sep 2022 21:18:55 +0800 (CST)
Received: from [10.67.102.169] (10.67.102.169) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 21:22:59 +0800
CC:     <yangyicong@hisilicon.com>,
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
        Barry Song <21cnbao@gmail.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        <wangyanan55@huawei.com>, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v5] topology: make core_mask include at least
 cluster_siblings
To:     Darren Hart <darren@os.amperecomputing.com>,
        Ionela Voinescu <ionela.voinescu@arm.com>
References: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
 <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com> <YyNnMmtoOrdexLoy@fedora>
 <bcd61ebd-d751-57a3-690b-b76c7bd230c5@huawei.com> <YyS1M79jddn4jZ2Z@fedora>
From:   Yicong Yang <yangyicong@huawei.com>
Message-ID: <2c079860-ee82-7719-d3d2-756192f41704@huawei.com>
Date:   Mon, 19 Sep 2022 21:22:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <YyS1M79jddn4jZ2Z@fedora>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.169]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/9/17 1:41, Darren Hart wrote:
> On Fri, Sep 16, 2022 at 03:59:34PM +0800, Yicong Yang wrote:
>> On 2022/9/16 1:56, Darren Hart wrote:
>>> On Thu, Sep 15, 2022 at 08:01:18PM +0800, Yicong Yang wrote:
>>>> Hi Darren,
>>>>
>>>
>>> Hi Yicong,
>>>
>>> ...
>>>
>>>>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
>>>>> index 1d6636ebaac5..5497c5ab7318 100644
>>>>> --- a/drivers/base/arch_topology.c
>>>>> +++ b/drivers/base/arch_topology.c
>>>>> @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>>>>>  			core_mask = &cpu_topology[cpu].llc_sibling;
>>>>>  	}
>>>>>  
>>>>> +	/*
>>>>> +	 * For systems with no shared cpu-side LLC but with clusters defined,
>>>>> +	 * extend core_mask to cluster_siblings. The sched domain builder will
>>>>> +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
>>>>> +	 */
>>>>> +	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
>>>>> +	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
>>>>> +		core_mask = &cpu_topology[cpu].cluster_sibling;
>>>>> +
>>>>>  	return core_mask;
>>>>>  }
>>>>>  
>>>>
>>>> Is this patch still necessary for Ampere after Ionela's patch [1], which
>>>> will limit the cluster's span within coregroup's span.
>>>
>>> Yes, see:
>>> https://lore.kernel.org/lkml/YshYAyEWhE4z%2FKpB@fedora/
>>>
>>> Both patches work together to accomplish the desired sched domains for the
>>> Ampere Altra family.
>>>
>>
>> Thanks for the link. From my understanding, on the Altra machine we'll get
>> the following results:
>>
>> with your patch alone:
>> Scheduler will get a weight of 2 for both CLS and MC level and finally the
>> MC domain will be squashed. The lowest domain will be CLS.
>>
>> with both your patch and Ionela's:
>> CLS will have a weight of 1 and MC will have a weight of 2. CLS won't be
>> built and the lowest domain will be MC.
>>
>> with Ionela's patch alone:
>> Both CLS and MC will have a weight of 1, which is incorrect.
>>
>> So your patch is still necessary for Amphere Altra. Then we need to limit
>> MC span to DIE/NODE span, according to the scheduler's definition for
>> topology level, for the issue below. Maybe something like this:
> 
> That seems reasonable.
> 
> What isn't clear to me is why qemu is creating a cluster layer with the
> description you provide. Why is cluster_siblings being populated?
> 
>>
>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
>> index 46cbe4471e78..8ebaba576836 100644
>> --- a/drivers/base/arch_topology.c
>> +++ b/drivers/base/arch_topology.c
>> @@ -713,6 +713,9 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>>             cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
>>                 core_mask = &cpu_topology[cpu].cluster_sibling;
>>
>> +       if (cpumask_subset(cpu_cpu_mask(cpu), core_mask))
>> +               core_mask = cpu_cpu_mask(cpu);
>> +
>>         return core_mask;
>>  }
>>
>>>>
>>>> I found an issue that the NUMA domains are not built on qemu with:
>>>>
>>>> qemu-system-aarch64 \
>>>>         -kernel ${Image} \
>>>>         -smp 8 \
>>>>         -cpu cortex-a72 \
>>>>         -m 32G \
>>>>         -object memory-backend-ram,id=node0,size=8G \
>>>>         -object memory-backend-ram,id=node1,size=8G \
>>>>         -object memory-backend-ram,id=node2,size=8G \
>>>>         -object memory-backend-ram,id=node3,size=8G \
>>>>         -numa node,memdev=node0,cpus=0-1,nodeid=0 \
>>>>         -numa node,memdev=node1,cpus=2-3,nodeid=1 \
>>>>         -numa node,memdev=node2,cpus=4-5,nodeid=2 \
>>>>         -numa node,memdev=node3,cpus=6-7,nodeid=3 \
>>>>         -numa dist,src=0,dst=1,val=12 \
>>>>         -numa dist,src=0,dst=2,val=20 \
>>>>         -numa dist,src=0,dst=3,val=22 \
>>>>         -numa dist,src=1,dst=2,val=22 \
>>>>         -numa dist,src=1,dst=3,val=24 \
>>>>         -numa dist,src=2,dst=3,val=12 \
>>>>         -machine virt,iommu=smmuv3 \
>>>>         -net none \
>>>>         -initrd ${Rootfs} \
>>>>         -nographic \
>>>>         -bios QEMU_EFI.fd \
>>>>         -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"
>>>>
>>>> I can see the schedule domain build stops at MC level since we reach all the
>>>> cpus in the system:
>>>>
>>>> [    2.141316] CPU0 attaching sched-domain(s):
>>>> [    2.142558]  domain-0: span=0-7 level=MC
>>>> [    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
>>>> [    2.158357] CPU1 attaching sched-domain(s):
>>>> [    2.158964]  domain-0: span=0-7 level=MC
>>>> [...]
>>>>
>>>> Without this the NUMA domains are built correctly:
>>>>
>>>> Without which? My patch, Ionela's patch, or both?
>>>
>>
>> Revert your patch only will have below result, sorry for the ambiguous. Before reverting,
>> for CPU 0, MC should span 0-1 but with your patch it's extended to 0-7 and the scheduler
>> domain build will stop at MC level because it has reached all the CPUs.
>>
>>>> [    2.008885] CPU0 attaching sched-domain(s):
>>>> [    2.009764]  domain-0: span=0-1 level=MC
>>>> [    2.012654]   groups: 0:{ span=0 cap=962 }, 1:{ span=1 cap=925 }
>>>> [    2.016532]   domain-1: span=0-3 level=NUMA
>>>> [    2.017444]    groups: 0:{ span=0-1 cap=1887 }, 2:{ span=2-3 cap=1871 }
>>>> [    2.019354]    domain-2: span=0-5 level=NUMA
>>>
>>> I'm not following this topology - what in the description above should result in
>>> a domain with span=0-5?
>>>
>>
>> It emulates a 3-hop NUMA machine and the NUMA domains will be built according to the
>> NUMA distances:
>>
>> node   0   1   2   3
>>   0:  10  12  20  22
>>   1:  12  10  22  24
>>   2:  20  22  10  12
>>   3:  22  24  12  10
>>
>> So for CPU 0 the NUMA domains will look like:
>> NUMA domain 0 for local nodes (squashed to MC domain), CPU 0-1
>> NUMA domain 1 for nodes within distance 12, CPU 0-3
>> NUMA domain 2 for nodes within distance 20, CPU 0-5
>> NUMA domain 3 for all the nodes, CPU 0-7
>>
> 
> Right, thanks for the explanation.
> 
> So the bit that remains unclear to me, is why is cluster_siblings being
> populated? Which part of your qemu topology description becomes the CLS layer
> during sched domain cosntruction?

I think your concern's right, qemu indeed populate a cluster in the system. I checked
and cluster_id looks like:

estuary:/$ cat /sys/devices/system/cpu/cpu*/topology/cluster_id
56
56
56
56
56
56
56
56

I check the qemu codes that it'll always populate a cluster for aarch64's virt machine
even if user doesn't specify it through '-smp cluster=N', the range of the cluster
will be equal to package.

I tried the attached code of qemu (based on v7.1.0-rc4) and kernel (based on 6.0.0-rc1).
Then the cluster won't be built and the NUMA domains built correctly:

estuary:/$ cat /sys/devices/system/cpu/cpu*/topology/cluster_id
-2
-2
-2
-2
-2
-2
-2
-2

Ionela replied to check the PPTT code. Maybe we should both restrict this in Qemu and kernel
side.

Thanks,
Yicong

Kernel changes below. Make sure the package node is not recognized as a cluster node.

diff --git a/drivers/acpi/pptt.c b/drivers/acpi/pptt.c
index c91342dcbcd6..6cec3cf52921 100644
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -750,7 +750,7 @@ int find_acpi_cpu_topology_cluster(unsigned int cpu)

        is_thread = cpu_node->flags & ACPI_PPTT_ACPI_PROCESSOR_IS_THREAD;
        cluster_node = fetch_pptt_node(table, cpu_node->parent);
-       if (!cluster_node)
+       if (!cluster_node || cluster_node->flags & ACPI_PPTT_PHYSICAL_PACKAGE)
                return -ENOENT;

        if (is_thread) {



Qemu changes below. Don't build cluster node in PPTT if user doesn't specified
"-smp clusters=N".

yangyicong@ubuntu:~/Community/qemu/build$ git diff | cat
diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index e6bfac95c7..1a0f708250 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -2030,7 +2030,7 @@ void build_pptt(GArray *table_data, BIOSLinker *linker, MachineState *ms,
                 0, socket_id, NULL, 0);
         }

-        if (mc->smp_props.clusters_supported) {
+        if (mc->smp_props.clusters_supported && ms->smp.has_cluster) {
             if (cpus->cpus[n].props.cluster_id != cluster_id) {
                 assert(cpus->cpus[n].props.cluster_id > cluster_id);
                 cluster_id = cpus->cpus[n].props.cluster_id;
diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index b39ed21e65..97c830660b 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -158,6 +158,9 @@ void machine_parse_smp_config(MachineState *ms,
     ms->smp.threads = threads;
     ms->smp.max_cpus = maxcpus;

+    if (config->has_clusters)
+        ms->smp.has_cluster = true;
+
     /* sanity-check of the computed topology */
     if (sockets * dies * clusters * cores * threads != maxcpus) {
         g_autofree char *topo_msg = cpu_hierarchy_to_string(ms);
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 7b416c9787..6f4473e80a 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -314,6 +314,7 @@ typedef struct CpuTopology {
     unsigned int cores;
     unsigned int threads;
     unsigned int max_cpus;
+    bool has_cluster;
 } CpuTopology;

 /**
