Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86504D8A2C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiCNQ4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiCNQz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:55:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2115.outbound.protection.outlook.com [40.107.244.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B0039BB6;
        Mon, 14 Mar 2022 09:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSRlTpkyPghqAorBPFGpZqFe8QGHwSpqEgnb6J8IIW7gt+ruvM0XOtetWL0x14s6+i/kn5vg0dYAxTd0Ouke73fJJOal7D8YN/pTid3QtCHdV+GGHTTrTMuXagvqH18pjlYn//Pbh71HGb6wYoE5XZk/TxYJxj0SeCj/sQTv+GJrB1GvBFICv8w22vKlPh/xpuCKr6cGY13h4BQk36KxHHy9ogralAGOm+u9y/kkqka2qJ5OX1N4h86HRHzLExYWXg4BihONfZ3ustHeFmC70BKVZWLnUl6VPTtd5ieaFUBVIuvrn8hQ2SRjdD/oR6EOXI89y3Pb38SslZqttdHW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+4DCNsbRr2l4aD6ESQNFY8UhlzPBu/4e8bB/iVmgWA=;
 b=FIlRs5ev2/ypuZLHbUPHrtBZijse2vkozKCuqFUlTI9m0/rj6Q7y0jWItBfmutEs0Xb5tJB4Qopc/p3f64caqUh9NQDA8HpbnSxkseQANRolBk62ylssGlUSvp3qcbjT88nFF/uyQgRF0KrCDkrQig+NySLaoPZUqXoag69/yLEvQ/+rHfg/tcMt7yDdYMyd5psqX+/OqKfviRjoDg7KcqB0u0iuDzznLhdTe5O4h+qm7sJOlGa6d7qAxY2aNaBiFZtUOeWEI+OCbJ8fZHdC0ZDHc2obt9xHQ6pEomlix3wJwTvtHYTTgVOnEXPkAW6s9rGL3OK9Om5EaloTuXLg+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+4DCNsbRr2l4aD6ESQNFY8UhlzPBu/4e8bB/iVmgWA=;
 b=Q/NoaxuuXeT1uZAJDcTXatAw7bj2ZDCqF1fJONfp4CjvRivrb9abPNVKeJIzwEvCSXgJqtrietou7BPgax61c7+KHa8Dvod4PyUVWpCb8CF80pJAVDOhCufMtu8MOC57jucqO/8SPkcHUuSmt+d4AVsj/yB963I37YSFUEsaWB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BYAPR01MB4710.prod.exchangelabs.com (2603:10b6:a03:83::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Mon, 14 Mar 2022 16:54:46 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 16:54:45 +0000
Date:   Mon, 14 Mar 2022 09:54:42 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
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
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <Yi9zUuroS1vHWexY@fedora>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
 <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
 <YijxUAuufpBKLtwy@fedora>
 <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
X-ClientProxiedBy: CH2PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:610:38::20) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 525aedb0-8001-40eb-f5e1-08da05db57d4
X-MS-TrafficTypeDiagnostic: BYAPR01MB4710:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB47102FA7DB5D8461FC35D5AFF70F9@BYAPR01MB4710.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6SWHtYx4Wu+SS/aIW16JSeunovYI70+QyScKUMul7W3YcFdCt2J547TA5KXvFhuIB2G4JnhCWrntQacGE98yxjBefuRHShqynz79aHKGOVXXwePbnF2wnXG2CZvNtlDENo7lR4RQQ1TGsS6V7oCgI8FNS6YdXVKaXqzmzuOmBQe1V5FRJ1uVsR91LZ6izd+Q/RxEHxF7aHjxJFOcuAtEfIXyH4NRiFGCql233AHqMH7/5YqV3Aut+u4sDWnV2RMGzCCO652nbdEhp0lSS69OY+TmMUj425Jj8PmFdU9utVnfgTMt/t/DObGEe9XF1PfezUtiGo9uHvA8I5fsEO6Sv8aqNNOsi0xos1P6z9hmz2n/XfYfstzW/b3UeJm5d5BxbpEFVfkPgBZcf46D8ZqbMbEHgROTgHQQkpXBTXVSTgssVei/tAFAgkpRk/Ifi41XgMFojzK+07OM9Womm2qAZgr3lsnRDDrPJWSesp2bcF/df0D7QPUS0lzxmr0AGqRc0nRC1y1ArcmRxHa6nAW0oKL3QTgZRClmb3eOSX6pseJ00Htx8Q0NgssSTJ6XVqqqgXfdOE6gfq8UZRKgxAMj1iB4soG5DgDynCXKInRX1Bjbs7eZUCeem4Jt15MOcSBG3xigygWBLcG7AzcVtniQ+cgR6SYAPIocmJOBInDcryjIITHWxgpgJSgWCuZzmQfznlPwnBunHknNoZJMST+3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(5660300002)(7416002)(66946007)(66556008)(66476007)(4326008)(8676002)(54906003)(6916009)(83380400001)(316002)(8936002)(33716001)(6512007)(86362001)(6666004)(26005)(186003)(508600001)(53546011)(52116002)(9686003)(38350700002)(6486002)(6506007)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UV8l0cV2BPXhEAqiokoE3DXgaT6Aj4OHycIIOhIhu58HHfff7YgY59BtLeR7?=
 =?us-ascii?Q?dEMGBQAERGqYQIdEpVcgLm8vTpGDA8kyzdKx3+iLHwoShFFaVylTXwjAvptd?=
 =?us-ascii?Q?ugu5MIqGn2S66VNm2fV4Mz99+1M+h4Ei8UauxJKm/jCfC+k7l4oaW6kjKQe1?=
 =?us-ascii?Q?e0jm09XKhb9NCM19xEFDCH4lcEBGhLr9OUp82xFDtKk6FUdFLy0Xm6jyccz3?=
 =?us-ascii?Q?LugXg8Y/sKMQIkzDm+AHaP4nb5B8anmTqEaGjQ43+5MWYLMNamV2/E9GIdQW?=
 =?us-ascii?Q?Kuni49NFMfR1bXanBP9uap1TnuzqNk6jfkHcpxBsS9ogUaIQFXP78kqg7t05?=
 =?us-ascii?Q?A0mic6wS+p8r0MkpUS1Zhujntd/AmIp2LJh6bVhFwbuECJKSQVut27M/4VV8?=
 =?us-ascii?Q?0kcwX4te5z9ERsHNvqHthMvzF0Qc8reoC3rRD4PUs6PeX3/VDVCw67+IEXux?=
 =?us-ascii?Q?ZJgTcwUNd7TfR4n3or/mlU3UFnHdBt/t0kYax8N24k3z4dh4xUBNhZIh+AaR?=
 =?us-ascii?Q?/tH1YSeB1ytwoWvrJoFqDv7nOo/akLlCfTnsBvfgxIW1p3jvhutq/+zVWqlC?=
 =?us-ascii?Q?szPRC1aEbDGCEyAZHgzt4uj0YMylftYZmw9i5VYDvyyZ/DR/0Bad5so6xQ1O?=
 =?us-ascii?Q?Xi1Zs+g2tHN5j2HEY313nmiyAH+VwmoXkeshNcz6YBiMh83nxEv6NAJr9vLQ?=
 =?us-ascii?Q?YGu83eNEx4Tu7sjT+VyEXh7x7WMnNIr0P+oYyJwdWShx5Fq7l+CB+3cDILV8?=
 =?us-ascii?Q?MCO3YhDvg9eyAhEAO3L0pyQKLi6eYjhuia7JP4GSg5UiRgXV6ErpoKbZeXsP?=
 =?us-ascii?Q?AxTzc1VrWjjfFgJjVAZMplZiL5SrTTGn4nSGxqf8pgNZifPF1mrpS9E4VdWz?=
 =?us-ascii?Q?cJ7HzZkJ2k07sV5LXpUfs//0hMyvFJFi/cOzwzL4A78s0YJnqcuj5e78pdsU?=
 =?us-ascii?Q?eUBxZiYvUweylFenjhJeq653fQnrMEVjNppKFq+bRU48osWo80LozxuLejBH?=
 =?us-ascii?Q?/UWYCYwuqh7vkcwgsoWl00vppOdA0ZdhP/rFRoNMIeB6+OqcpLY8zZsvr6dL?=
 =?us-ascii?Q?lynlIcq1y6TogBfxz14r3rpFdatsTnkPzQFqaOYmttZVsGNJxx264Kxb4gtA?=
 =?us-ascii?Q?98sBaemB50BlryQXYcvVi7PUIFy4ZLvYDFpbGSAHBv+OMrQ/FNcLydfNgkk8?=
 =?us-ascii?Q?3j8cxD1Dsk+dlECz9yh0X0aZs3yGONtJ6EXUJdZAIwQJHc26CV8FQm5QFCPz?=
 =?us-ascii?Q?SAlx/YlIC+vZjGV6nvKlGk5GYCKda95OFGYJ7ZUbEfRC8TWfO22R9x/X8I8V?=
 =?us-ascii?Q?DMCO1ROZBSaaOD0jt8bt1f8Lx84TBHyikYOhj+Npyzr0208R06BQ4hxQuSkn?=
 =?us-ascii?Q?JHj69UzuZTNDxsvFZh2AFVIcm1kc9XIftcS4xqTMI0zVumik3YDiWezyhrhO?=
 =?us-ascii?Q?d1lcKhuorrBNGLTzeEpP+xk91Iw07lxfWqwkkJoovWzbQESqOxLcOFwT+zE5?=
 =?us-ascii?Q?8rs2vOlnOzCofPI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525aedb0-8001-40eb-f5e1-08da05db57d4
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 16:54:45.8709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+wZNKKrZ5Vw01Ax5TnoK3hjiaVSyNV1KqlwL+2MRA3DBiXM0giiidpkpPPjUZ5nZHdvUlnMewJDm7MbH0tygPjnh3cxAZUWG+wVQHRrqoGeqa9SVI3SM+UUq5hxqe8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4710
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 05:35:05PM +0100, Dietmar Eggemann wrote:
> On 09/03/2022 19:26, Darren Hart wrote:
> > On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
> >> On 08/03/2022 18:49, Darren Hart wrote:
> >>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
> >>>> On 08/03/2022 12:04, Vincent Guittot wrote:
> >>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
> 
> [...]
> 
> >>>> I do not have any better idea than this tweak here either in case the
> >>>> platform can't provide a cleaner setup.
> >>>
> >>> I'd argue The platform is describing itself accurately in ACPI PPTT
> >>> terms. The topology doesn't fit nicely within the kernel abstractions
> >>> today. This is an area where I hope to continue to improve things going
> >>> forward.
> >>
> >> I see. And I assume lying about SCU/LLC boundaries in ACPI is not an
> >> option since it messes up /sys/devices/system/cpu/cpu0/cache/index*/.
> >>
> >> [...]
> > 
> > I'm not aware of a way to accurately describe the SCU topology in the PPTT, and
> > the risk we run with lying about LLC topology is that lie has to be comprehended
> > by all OSes and not conflict with other lies people may ask for. In general, I
> > think it is preferable and more maintainable to describe the topology as
> > accurately and honestly as we can within the existing platform mechanisms (PPTT,
> > HMAT, etc) and work on the higher level abstractions to accommodate a broader
> > set of topologies as they emerge (as well as working to more fully describe the
> > topology with new platform level mechanisms as needed).
> > 
> > As I mentioned, I intend to continue looking in to how to improve the current
> > abstractions. For now, it sounds like we have agreement that this patch can be
> > merged to address the BUG?
> 
> What about swapping the CLS and MC cpumasks for such a machine? This
> would avoid that the task scheduler has to deal with a system which has
> CLS but no MC. We essentially promote the CLS cpumask up to MC in this
> case.
> 
> cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
> MC
> ^^
> DIE
> NUMA
> 
> cat /sys/kernel/debug/sched/domains/cpu0# cat domain*/flags
> SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_SHARE_PKG_RESOURCES SD_PREFER_SIBLING
>                                                                   ^^^^^^^^^^^^^^^^^^^^^^ 
> SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_PREFER_SIBLING 
> SD_BALANCE_NEWIDLE SD_BALANCE_EXEC SD_BALANCE_FORK SD_WAKE_AFFINE SD_SERIALIZE SD_OVERLAP SD_NUMA
> 
> Only very lightly tested on Altra and Juno-r0 (DT).
> 
> --->8---
> 
> From 54bef59e7f50fa41b7ae39190fd71af57209c27d Mon Sep 17 00:00:00 2001
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Date: Mon, 14 Mar 2022 15:08:23 +0000
> Subject: [PATCH] arch_topology: Swap MC & CLS SD mask if MC weight==1 &
>  subset(MC,CLS)
> 
> This avoids the issue of having a system with a CLS SD but no MC SD.
> CLS should be sub-SD of MC.

Hi Dietmar,

Ultimately, this delivers the same result. I do think it imposes more complexity
for everyone to address what as far as I'm aware only affect the one system.

I don't think the term "Cluster" has a clear and universally understood
definition, so I don't think it's a given that "CLS should be sub-SD of MC". I
think this has been assumed, and that assumption has mostly held up, but this is
an abstraction, and the abstraction should follow the physical topologies rather
than the other way around in my opinion. If that's the primary motivation for
this approach, I don't think it justifies the additional complexity.

All told, I prefer the 2 line change contained within cpu_coregroup_mask() which
handles the one known exception with minimal impact. It's easy enough to come
back to this to address more cases with a more complex solution if needed in the
future - but I prefer to introduce the least amount of complexity as possible to
address the known issues, especially if the end result is the same and the cost
is paid by the affected systems.

Thanks,

> 
> The cpumask under /sys/devices/system/cpu/cpu*/cache/index* and
> /sys/devices/system/cpu/cpu*/topology are not changed by this.
> 
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> ---
>  drivers/base/arch_topology.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> index 976154140f0b..9af90a5625c7 100644
> --- a/drivers/base/arch_topology.c
> +++ b/drivers/base/arch_topology.c
> @@ -614,7 +614,7 @@ static int __init parse_dt_topology(void)
>  struct cpu_topology cpu_topology[NR_CPUS];
>  EXPORT_SYMBOL_GPL(cpu_topology);
>  
> -const struct cpumask *cpu_coregroup_mask(int cpu)
> +const struct cpumask *_cpu_coregroup_mask(int cpu)
>  {
>  	const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));
>  
> @@ -631,11 +631,37 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>  	return core_mask;
>  }
>  
> -const struct cpumask *cpu_clustergroup_mask(int cpu)
> +const struct cpumask *_cpu_clustergroup_mask(int cpu)
>  {
>  	return &cpu_topology[cpu].cluster_sibling;
>  }
>  
> +static int
> +swap_masks(const cpumask_t *core_mask, const cpumask_t *cluster_mask)
> +{
> +	if (cpumask_weight(core_mask) == 1 &&
> +	    cpumask_subset(core_mask, cluster_mask))
> +		return 1;
> +
> +	return 0;
> +}	
> +
> +const struct cpumask *cpu_coregroup_mask(int cpu)
> +{
> +	const cpumask_t *cluster_mask = _cpu_clustergroup_mask(cpu);
> +	const cpumask_t *core_mask = _cpu_coregroup_mask(cpu);
> +	
> +	return swap_masks(core_mask, cluster_mask) ? cluster_mask : core_mask;
> +}
> +
> +const struct cpumask *cpu_clustergroup_mask(int cpu)
> +{
> +	const cpumask_t *cluster_mask = _cpu_clustergroup_mask(cpu);
> +	const cpumask_t *core_mask = _cpu_coregroup_mask(cpu);
> +
> +	return swap_masks(core_mask, cluster_mask) ? core_mask : cluster_mask;
> +}
> +
>  void update_siblings_masks(unsigned int cpuid)
>  {
>  	struct cpu_topology *cpu_topo, *cpuid_topo = &cpu_topology[cpuid];
> -- 
> 2.25.1

-- 
Darren Hart
Ampere Computing / OS and Kernel
