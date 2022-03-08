Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1DF4D1CAF
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbiCHQED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 11:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiCHQEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 11:04:02 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50925496A2;
        Tue,  8 Mar 2022 08:03:06 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0CAC139F;
        Tue,  8 Mar 2022 08:03:05 -0800 (PST)
Received: from [192.168.1.10] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7BB13FA45;
        Tue,  8 Mar 2022 08:03:02 -0800 (PST)
Message-ID: <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
Date:   Tue, 8 Mar 2022 17:03:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/03/2022 12:04, Vincent Guittot wrote:
> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:

[...]

>>> ---
>>> v1: Drop MC level if coregroup weight == 1
>>> v2: New sd topo in arch/arm64/kernel/smp.c
>>> v3: No new topo, extend core_mask to cluster_siblings
>>>
>>>  drivers/base/arch_topology.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
>>> index 976154140f0b..a96f45db928b 100644
>>> --- a/drivers/base/arch_topology.c
>>> +++ b/drivers/base/arch_topology.c
>>> @@ -628,6 +628,14 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>>>                       core_mask = &cpu_topology[cpu].llc_sibling;
>>>       }
>>>
>>> +     /*
>>> +      * For systems with no shared cpu-side LLC but with clusters defined,
>>> +      * extend core_mask to cluster_siblings. The sched domain builder will
>>> +      * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.

IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.

This is what I get on my Ampere Altra (I guess I don't have the ACPI
changes which would let to a CLS sched domain):

# cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
DIE
NUMA
root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
CONFIG_SCHED_CLUSTER=y

>>> +      */
>>> +     if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
>>> +             core_mask = &cpu_topology[cpu].cluster_sibling;
>>> +
>>
>> Sudeep, Vincent, are you happy with this now?
> 
> I would not say that I'm happy because this solution skews the core
> cpu mask in order to abuse the scheduler so that it will remove a
> wrong but useless level when it will build its domains.
> But this works so as long as the maintainer are happy, I'm fine

I do not have any better idea than this tweak here either in case the
platform can't provide a cleaner setup.

Maybe the following is easier to read but then we use
'&cpu_topology[cpu].llc_sibling' in cpu_coregroup_mask() already ...

@@ -617,6 +617,7 @@ EXPORT_SYMBOL_GPL(cpu_topology);
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
        const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));
+       const cpumask_t *cluster_mask = cpu_clustergroup_mask(cpu);

        /* Find the smaller of NUMA, core or LLC siblings */
        if (cpumask_subset(&cpu_topology[cpu].core_sibling, core_mask)) {
@@ -628,6 +629,9 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
                        core_mask = &cpu_topology[cpu].llc_sibling;
        }

+       if (cpumask_subset(core_mask, cluster_mask))
+               core_mask = cluster_mask;
+
        return core_mask;
 }

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>




