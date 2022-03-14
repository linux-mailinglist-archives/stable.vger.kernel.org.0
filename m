Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32DA4D8979
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbiCNQgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243202AbiCNQgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:36:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1B6013E23;
        Mon, 14 Mar 2022 09:35:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D1D9D6E;
        Mon, 14 Mar 2022 09:35:15 -0700 (PDT)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 322D63F766;
        Mon, 14 Mar 2022 09:35:13 -0700 (PDT)
Message-ID: <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
Date:   Mon, 14 Mar 2022 17:35:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Content-Language: en-US
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
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
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com> <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com> <YijxUAuufpBKLtwy@fedora>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <YijxUAuufpBKLtwy@fedora>
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

On 09/03/2022 19:26, Darren Hart wrote:
> On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
>> On 08/03/2022 18:49, Darren Hart wrote:
>>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
>>>> On 08/03/2022 12:04, Vincent Guittot wrote:
>>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:

[...]

>>>> I do not have any better idea than this tweak here either in case the
>>>> platform can't provide a cleaner setup.
>>>
>>> I'd argue The platform is describing itself accurately in ACPI PPTT
>>> terms. The topology doesn't fit nicely within the kernel abstractions
>>> today. This is an area where I hope to continue to improve things going
>>> forward.
>>
>> I see. And I assume lying about SCU/LLC boundaries in ACPI is not an
>> option since it messes up /sys/devices/system/cpu/cpu0/cache/index*/.
>>
>> [...]
> 
> I'm not aware of a way to accurately describe the SCU topology in the PPTT, and
> the risk we run with lying about LLC topology is that lie has to be comprehended
> by all OSes and not conflict with other lies people may ask for. In general, I
> think it is preferable and more maintainable to describe the topology as
> accurately and honestly as we can within the existing platform mechanisms (PPTT,
> HMAT, etc) and work on the higher level abstractions to accommodate a broader
> set of topologies as they emerge (as well as working to more fully describe the
> topology with new platform level mechanisms as needed).
> 
> As I mentioned, I intend to continue looking in to how to improve the current
> abstractions. For now, it sounds like we have agreement that this patch can be
> merged to address the BUG?

What about swapping the CLS and MC cpumasks for such a machine? This
would avoid that the task scheduler has to deal with a system which has
CLS but no MC. We essentially promote the CLS cpumask up to MC in this
case.

cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
MC
^^
DIE
NUMA

cat /sys/kernel/debug/sched/domains/cpu0# cat domain*/flags
SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_SHARE_PKG_RESOURCES SD_PREFER_SIBLING
                                                                  ^^^^^^^^^^^^^^^^^^^^^^ 
SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_PREFER_SIBLING 
SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_SERIALIZE SD_OVERLAP SD_NUMA

Only very lightly tested on Altra and Juno-r0 (DT).

--->8---

From 54bef59e7f50fa41b7ae39190fd71af57209c27d Mon Sep 17 00:00:00 2001
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
Date: Mon, 14 Mar 2022 15:08:23 +0000
Subject: [PATCH] arch_topology: Swap MC & CLS SD mask if MC weight==1 &
 subset(MC,CLS)

This avoids the issue of having a system with a CLS SD but no MC SD.
CLS should be sub-SD of MC.

The cpumask under /sys/devices/system/cpu/cpu*/cache/index* and
/sys/devices/system/cpu/cpu*/topology are not changed by this.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 drivers/base/arch_topology.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 976154140f0b..9af90a5625c7 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -614,7 +614,7 @@ static int __init parse_dt_topology(void)
 struct cpu_topology cpu_topology[NR_CPUS];
 EXPORT_SYMBOL_GPL(cpu_topology);
 
-const struct cpumask *cpu_coregroup_mask(int cpu)
+const struct cpumask *_cpu_coregroup_mask(int cpu)
 {
 	const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));
 
@@ -631,11 +631,37 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	return core_mask;
 }
 
-const struct cpumask *cpu_clustergroup_mask(int cpu)
+const struct cpumask *_cpu_clustergroup_mask(int cpu)
 {
 	return &cpu_topology[cpu].cluster_sibling;
 }
 
+static int
+swap_masks(const cpumask_t *core_mask, const cpumask_t *cluster_mask)
+{
+	if (cpumask_weight(core_mask) == 1 &&
+	    cpumask_subset(core_mask, cluster_mask))
+		return 1;
+
+	return 0;
+}	
+
+const struct cpumask *cpu_coregroup_mask(int cpu)
+{
+	const cpumask_t *cluster_mask = _cpu_clustergroup_mask(cpu);
+	const cpumask_t *core_mask = _cpu_coregroup_mask(cpu);
+	
+	return swap_masks(core_mask, cluster_mask) ? cluster_mask : core_mask;
+}
+
+const struct cpumask *cpu_clustergroup_mask(int cpu)
+{
+	const cpumask_t *cluster_mask = _cpu_clustergroup_mask(cpu);
+	const cpumask_t *core_mask = _cpu_coregroup_mask(cpu);
+
+	return swap_masks(core_mask, cluster_mask) ? core_mask : cluster_mask;
+}
+
 void update_siblings_masks(unsigned int cpuid)
 {
 	struct cpu_topology *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
-- 
2.25.1
