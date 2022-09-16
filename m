Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2ED05BB1B4
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIPRlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIPRlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:41:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C287E7F0B7;
        Fri, 16 Sep 2022 10:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYE8txJWtfvXkmkZ3k9pAysu6FDQh4JBD4IpbwiSCbCh21Ru5uVOYertBE8ErlaKbyDGbTLRrfRdKfPvYDjVnBNi1cf4vJqTcT81Hx2HjB2Yc0mEzYfoHSBFxnpsUpCCYJesmXrdz0zqbwZvVC2hHYk1C30AUkUEM8zEfqwJw9sglxFulRmblQpAnv3FHFdOKSi/m3XWVxB6KtaLVYs8W9+/i0nK6R/gmCs3OZ0l9MBgtGtTQWIjvtYOYflUYZQ8WPgzIQZGXi6OP7zAO9Y+ku67gat5wwqeW44kgyU2BhmjAIxahGLdARFucfpqJ6Mmyy3fSsRe0TzAo9oAZyBOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87tBmhdKSE0G4b2MakoDQZbeZ1OybDVBpV7ReuvA0Ig=;
 b=P+WbBPBXIdwuHPyMuyazRfEcVIme7VfAGDWpN6NItlCY9vpMhNJV1ADmknbFsz+7mYwxPXh9ZRzcMc7AEreF3t/O3UXHjvn+b1ynzu5ib+QiWealLFRtu0jcGpTtEuwYPAI5YxH6CY/XFfxmSJ3tvUpweyyIfTrS7sz+7nTtaPj09vgZPXq89nR5kV9DiE81XTLR77DHf92+J7NFa2Xh5OFllLCE/RqKmtKvkyoAa1BGFhvQdp6xqcogDJUdj6p+eiGO8ER1frPWEyiTISYryjpeKntBlpxjVdS0GEnH+cPZ5bB/H9Cog6mLVKX62QMZvblogXg16tX2/EOqlPYUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87tBmhdKSE0G4b2MakoDQZbeZ1OybDVBpV7ReuvA0Ig=;
 b=G5FQYKxyAedwaiu6X0oMFOT3nXAtleb6rT8D87KA6wt8iKSqM3y5hiaHy7YvogMEgrdv+twcLKOkt+0skD7zc8uMJ8scBY892P6EkCdEXDwZorGgHHCSIZtNCc+WidV0y709ZNK7W7byydCWpeHvKJAHbYaUdRpVFOIGNw2RRS0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CO1PR01MB6742.prod.exchangelabs.com (2603:10b6:303:f7::15) by
 MWHPR0101MB2880.prod.exchangelabs.com (2603:10b6:301:30::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.23; Fri, 16 Sep 2022 17:41:09 +0000
Received: from CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8]) by CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8%9]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 17:41:09 +0000
Date:   Fri, 16 Sep 2022 10:41:07 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Yicong Yang <yangyicong@huawei.com>
Cc:     yangyicong@hisilicon.com, Sudeep Holla <sudeep.holla@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Barry Song <21cnbao@gmail.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v5] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YyS1M79jddn4jZ2Z@fedora>
References: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
 <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com>
 <YyNnMmtoOrdexLoy@fedora>
 <bcd61ebd-d751-57a3-690b-b76c7bd230c5@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcd61ebd-d751-57a3-690b-b76c7bd230c5@huawei.com>
X-ClientProxiedBy: MW4PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:303:8c::6) To CO1PR01MB6742.prod.exchangelabs.com
 (2603:10b6:303:f7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR01MB6742:EE_|MWHPR0101MB2880:EE_
X-MS-Office365-Filtering-Correlation-Id: de2b53c5-ecf2-4000-11a0-08da980aa37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9Yf6eMpftftwE6uNy2XXxOD36FjeyILKWM/mQdvjGuIqIGrX0otj0h8u66qF5e1+zlUbvwngygjOd5PPgKGVhMF12HfjWzkeurZSIP4cfkllsFpBoLipHLsjr+GLJ07PhvcgcUMxeJkC//S20hstwiUaCXkTHRAxx/xIoMkiMZ/r8g6YrhQVlJpVJ6+dJkIQUsrC9lka+4YSNjZB2NztLFq7gNmWbSW6FLTakTg76+qJ4glqUi0qkFfVU92EejXZ9QHfR+0eeAI/EAKL+h5ibYuEdqtZpQgmDwHCQSWPPIYg3HXN7ZrMnsolgoK69k+zPc7Ichq+WEPFgSlya/xDJ67d8mKxEnAex0WZX3qbvNk2Fiu8GL5jdjz/rNph3HwMH5jkeE/xBmFQpMKLdNxqnYHg4AEWQAD6shDwF9qcwVPwjtzJ0vTWu81Pcz8p7czMkG7e96CKVVk1nCQXmVdaN8i0rMA9JT63A0v/MZQzMSRWXWerZ6pVM9NRXt6uDoMTFNCPpmNt4wShEaJM2H0H/jMUDeB1F2xWEzpq1cDaaxVtA08I1h/2ImZ1jp7W64TlhrmdK3jcIrF68kdziaHF6XB3SUTzZicBoZcj46sYH1eSklMfr9YQCo6FcSJqcuHSt1fOYUOZ6AhMnKTCq6Ksdkx5GqB5PVmz7B7OwyqeKIGHD3Fn3wSLdqWNjHKcJSZWhDc349NEjG/x+83hR54aYI0g07FLtamwFZRqmzI2BbsJtG22foXj7nSkSoPyGjVzCCDAle/hOvxttwa5tchq2dhAnNyya+127R8ElnxdhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR01MB6742.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(376002)(136003)(366004)(39850400004)(451199015)(8676002)(4326008)(38100700002)(6506007)(66476007)(38350700002)(66946007)(26005)(66556008)(478600001)(53546011)(41300700001)(52116002)(9686003)(54906003)(6486002)(6916009)(316002)(6512007)(83380400001)(186003)(8936002)(7416002)(966005)(86362001)(2906002)(5660300002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bxe5ZBejAduCP3EySev1zbf0SNEP1EMnpg7fYR7HB3KNOqZh+I4oAp25d8ht?=
 =?us-ascii?Q?/8m0324VO8Fliyq3ozpt6xGLQUefHwVxCYRDOc9GCbwqvvzLmTRgeShZK758?=
 =?us-ascii?Q?SjhppaIOEWvUL7OGid7gdp0C8R+8c9+K4kAKs+HLtdMFHIAF0/WFvq0oNJ0w?=
 =?us-ascii?Q?gHmdcLI2xGycsQyWbZ4a0pcOcj2AY/cZJbtmeEFcuYUcfC4rOwtI0u9oNEe3?=
 =?us-ascii?Q?QgXk7+l0waCU+pwhariQ3i+3Sm+bSUAq3jlki3JRxZ9SuEGYOzcBgtBEVq35?=
 =?us-ascii?Q?nxn0H0sRhY9MLrRON7do49nXnY4CR7jiBfLHshxlxPRPHtBEw8oTZN2X3vY2?=
 =?us-ascii?Q?hypVvUezhjaWiB+1nWliaCYAU/Tx/fFQNN6ukJo+16/fex98H/auxviJ430A?=
 =?us-ascii?Q?6y9yVQT9IjJhWwr+IO1e7yYef3UHdLtZqk7McSOQdcNRYYcyp0tjgQAD+bEr?=
 =?us-ascii?Q?ToSsvXEdKyxNEGABcP0hvHM3Qtmy6bNjnBS0bU7rv+DdKysg3OjY/YfXq/93?=
 =?us-ascii?Q?XR/rzn2EbqlvF11Kq1u8gIekVep+mJ74N0va+u/sJqqEFweCacT1IH+A0RW+?=
 =?us-ascii?Q?dajgekOuGHuVE0hn+vXXlLFpkCFA/wO2w+DeLMd6OLZb+N8wOW+zDgKBJjxB?=
 =?us-ascii?Q?iJ9FRFR2GWE77jR429AKvOWe+wicoi4ZwBY0mkKkoNTPDSXWdRPyLaXy96qu?=
 =?us-ascii?Q?V8dAAzepOWJTqVmdJRrH7riZt2+PStdm/Thy11Gy7NqDUfMMW3kl0/kRb1o4?=
 =?us-ascii?Q?fzaWuBRLqA0FZzrVUwW4M+Di9OoPJu2zFDsBNAch3eEZSZApsS8ojEN/NeUf?=
 =?us-ascii?Q?tt5BnfgY+8T6z65cOoa7H93QRQN1+yOKwpU3+11SUCvvLEor7RyEYBC1+vav?=
 =?us-ascii?Q?C3+S4bJA3IUe74IzMqoQHRTlTm/hJmthI+pnB3rkmHUmz2Tl05zRt6HVNVQt?=
 =?us-ascii?Q?/x4rjJofzHs5dTWGVbNb2fBR/BbjijH1zJ+Dp6ZsArw2ARkrsety9at5IUPV?=
 =?us-ascii?Q?QVb95sLNUqBphcXmcqTlIHXe1jC6nctKLLvlDhew4MfqJWxK+TPgttk8S6cc?=
 =?us-ascii?Q?gucA+XH0qPpGsZBInsHeQrMjdygLRHo/kJyvvOo7li6h1UJGwqKA5T4q7oGo?=
 =?us-ascii?Q?P7t7pske+WzzC1t8SH0NzC7S1IHPIijrOSn3Q/ph81d6oT+JlKpzRYpk005O?=
 =?us-ascii?Q?4D2O/uzEj9lnFnzgk1V3n6uH0mU1NCLq2j0Q5nYufuzC3FPumpezk/d+Jk/b?=
 =?us-ascii?Q?D05DdBRNzaRrQcySuX3dDclIPuKUtV96gJ7IenxFo60ZK44qFlCuXZsmGon/?=
 =?us-ascii?Q?ZjuOax9MF5qh+PHYdT3LPrDYCouUnRZAyZPincAdyjBLj0XT+ctP5jNNitcY?=
 =?us-ascii?Q?9KEBnJtGfaDz4YFKeVtr1iFS4w+mPGrqGVzS4vG8vM3ZsbwZNpAN/DPMco3A?=
 =?us-ascii?Q?OfmQi64hWJ0HMWNSoph4L45WHJaN0vEnlSri9kSm+8tB4u1NSaxKxrmQZCKX?=
 =?us-ascii?Q?Ihg4vEpUMojGVILtOL7KPIVKCD/C+QrxeEOANsG+BiH8Ayt/st9JGxNB7STR?=
 =?us-ascii?Q?iIIVga8UFUBmAOGs4YC5F1wPxHQXxeDxWh7C2D+dMjajY+LpcwWZ3sGeXDDd?=
 =?us-ascii?Q?fgP5KfCAW96vsWxuYMO3GW8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de2b53c5-ecf2-4000-11a0-08da980aa37f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR01MB6742.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 17:41:09.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoOuA3M2DdMOtTlMS9WD75/3Zl/3ExRizc146VsCY4R4vkYBS3MVhykrQdFLPL7VwGbnOQqzvF033gIFd9zSbYfR/RnznYKmHZXS7PdO6tolldqoszrITo5KWKqM6guK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0101MB2880
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 03:59:34PM +0800, Yicong Yang wrote:
> On 2022/9/16 1:56, Darren Hart wrote:
> > On Thu, Sep 15, 2022 at 08:01:18PM +0800, Yicong Yang wrote:
> >> Hi Darren,
> >>
> > 
> > Hi Yicong,
> > 
> > ...
> > 
> >>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> >>> index 1d6636ebaac5..5497c5ab7318 100644
> >>> --- a/drivers/base/arch_topology.c
> >>> +++ b/drivers/base/arch_topology.c
> >>> @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >>>  			core_mask = &cpu_topology[cpu].llc_sibling;
> >>>  	}
> >>>  
> >>> +	/*
> >>> +	 * For systems with no shared cpu-side LLC but with clusters defined,
> >>> +	 * extend core_mask to cluster_siblings. The sched domain builder will
> >>> +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> >>> +	 */
> >>> +	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> >>> +	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> >>> +		core_mask = &cpu_topology[cpu].cluster_sibling;
> >>> +
> >>>  	return core_mask;
> >>>  }
> >>>  
> >>
> >> Is this patch still necessary for Ampere after Ionela's patch [1], which
> >> will limit the cluster's span within coregroup's span.
> > 
> > Yes, see:
> > https://lore.kernel.org/lkml/YshYAyEWhE4z%2FKpB@fedora/
> > 
> > Both patches work together to accomplish the desired sched domains for the
> > Ampere Altra family.
> > 
> 
> Thanks for the link. From my understanding, on the Altra machine we'll get
> the following results:
> 
> with your patch alone:
> Scheduler will get a weight of 2 for both CLS and MC level and finally the
> MC domain will be squashed. The lowest domain will be CLS.
> 
> with both your patch and Ionela's:
> CLS will have a weight of 1 and MC will have a weight of 2. CLS won't be
> built and the lowest domain will be MC.
> 
> with Ionela's patch alone:
> Both CLS and MC will have a weight of 1, which is incorrect.
> 
> So your patch is still necessary for Amphere Altra. Then we need to limit
> MC span to DIE/NODE span, according to the scheduler's definition for
> topology level, for the issue below. Maybe something like this:

That seems reasonable.

What isn't clear to me is why qemu is creating a cluster layer with the
description you provide. Why is cluster_siblings being populated?

> 
> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> index 46cbe4471e78..8ebaba576836 100644
> --- a/drivers/base/arch_topology.c
> +++ b/drivers/base/arch_topology.c
> @@ -713,6 +713,9 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>             cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
>                 core_mask = &cpu_topology[cpu].cluster_sibling;
> 
> +       if (cpumask_subset(cpu_cpu_mask(cpu), core_mask))
> +               core_mask = cpu_cpu_mask(cpu);
> +
>         return core_mask;
>  }
> 
> >>
> >> I found an issue that the NUMA domains are not built on qemu with:
> >>
> >> qemu-system-aarch64 \
> >>         -kernel ${Image} \
> >>         -smp 8 \
> >>         -cpu cortex-a72 \
> >>         -m 32G \
> >>         -object memory-backend-ram,id=node0,size=8G \
> >>         -object memory-backend-ram,id=node1,size=8G \
> >>         -object memory-backend-ram,id=node2,size=8G \
> >>         -object memory-backend-ram,id=node3,size=8G \
> >>         -numa node,memdev=node0,cpus=0-1,nodeid=0 \
> >>         -numa node,memdev=node1,cpus=2-3,nodeid=1 \
> >>         -numa node,memdev=node2,cpus=4-5,nodeid=2 \
> >>         -numa node,memdev=node3,cpus=6-7,nodeid=3 \
> >>         -numa dist,src=0,dst=1,val=12 \
> >>         -numa dist,src=0,dst=2,val=20 \
> >>         -numa dist,src=0,dst=3,val=22 \
> >>         -numa dist,src=1,dst=2,val=22 \
> >>         -numa dist,src=1,dst=3,val=24 \
> >>         -numa dist,src=2,dst=3,val=12 \
> >>         -machine virt,iommu=smmuv3 \
> >>         -net none \
> >>         -initrd ${Rootfs} \
> >>         -nographic \
> >>         -bios QEMU_EFI.fd \
> >>         -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"
> >>
> >> I can see the schedule domain build stops at MC level since we reach all the
> >> cpus in the system:
> >>
> >> [    2.141316] CPU0 attaching sched-domain(s):
> >> [    2.142558]  domain-0: span=0-7 level=MC
> >> [    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
> >> [    2.158357] CPU1 attaching sched-domain(s):
> >> [    2.158964]  domain-0: span=0-7 level=MC
> >> [...]
> >>
> >> Without this the NUMA domains are built correctly:
> >>
> > > Without which? My patch, Ionela's patch, or both?
> > 
> 
> Revert your patch only will have below result, sorry for the ambiguous. Before reverting,
> for CPU 0, MC should span 0-1 but with your patch it's extended to 0-7 and the scheduler
> domain build will stop at MC level because it has reached all the CPUs.
> 
> >> [    2.008885] CPU0 attaching sched-domain(s):
> >> [    2.009764]  domain-0: span=0-1 level=MC
> >> [    2.012654]   groups: 0:{ span=0 cap=962 }, 1:{ span=1 cap=925 }
> >> [    2.016532]   domain-1: span=0-3 level=NUMA
> >> [    2.017444]    groups: 0:{ span=0-1 cap=1887 }, 2:{ span=2-3 cap=1871 }
> >> [    2.019354]    domain-2: span=0-5 level=NUMA
> > 
> > I'm not following this topology - what in the description above should result in
> > a domain with span=0-5?
> > 
> 
> It emulates a 3-hop NUMA machine and the NUMA domains will be built according to the
> NUMA distances:
> 
> node   0   1   2   3
>   0:  10  12  20  22
>   1:  12  10  22  24
>   2:  20  22  10  12
>   3:  22  24  12  10
> 
> So for CPU 0 the NUMA domains will look like:
> NUMA domain 0 for local nodes (squashed to MC domain), CPU 0-1
> NUMA domain 1 for nodes within distance 12, CPU 0-3
> NUMA domain 2 for nodes within distance 20, CPU 0-5
> NUMA domain 3 for all the nodes, CPU 0-7
> 

Right, thanks for the explanation.

So the bit that remains unclear to me, is why is cluster_siblings being
populated? Which part of your qemu topology description becomes the CLS layer
during sched domain cosntruction?

-- 
Darren Hart
Ampere Computing / OS and Kernel
