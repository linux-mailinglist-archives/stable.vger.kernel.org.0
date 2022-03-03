Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5084CC21C
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 17:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiCCQDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 11:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiCCQDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 11:03:23 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2096.outbound.protection.outlook.com [40.107.220.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460DF403FA;
        Thu,  3 Mar 2022 08:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYudaET2XtwBwbAEIKUn+hdhKVTStI0jtrX4DJ8bs+YgSSHqBtuu1/pWjtc+qL3y/Fv6VNkd358lTj69t08ZaZGyBYH+q6tNz/mUt1qvJSX0/tin0B1wr0xgdO1xXO7a0rnWvcT7Yfv2JB9YQc1hKt1dwP6emfNe37z7DPIGnVSKJiloKAe7xhHJQ9xwFfXExVM0z7qDEWEj3Q6i1gVrIlQb8zTWqDa80yh9je3pMM7gK+v201h9kHzideaLOwNfK49BjJpAnZesc/YmXNhhRmT6fFxV5VBk2s9bdgR7VcIStipqWe4nXodphKxrkjTA3WgNSXigE/98p6kWWHMMPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzKh1Nb8nYKY0Q1KH38LXSfwGiiTdo6xNP6GzGYZjC0=;
 b=boJz4S4UPuqPSkDsRUuoro39yLMao6dRUy4+Gw9TsXv16/0ixdKShuA7jf/z3cZSiGyYjplRG455MeG32Egk6RKZRGLv2aAruggr6Rjzj2dHREHQQ4MI4Tg0n+y2AiUI9yZlqkHDDYsSL4u/DIXCptnwGYixxC3h02/HmP2i+ILcYAxtSyNH2ZfZjUHcQGQGDa1N7eYjSwQ0J9Ec5bAXnD/X8gEAu82y+khHuVlNCz18GG9xOU/Wym7+bvsWyhZ31lmKTLXnFl/WvnYBr6zHk9AH6tUQPpRRodR0g+VHpIVjqQ6um2L9fRMaGJd7rwnaCt5QAngWg5iva73vTu4xRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzKh1Nb8nYKY0Q1KH38LXSfwGiiTdo6xNP6GzGYZjC0=;
 b=M/lGEcpqzWz1IZhAxXJjdE5LV9Y9J6QYC6R2/U92J6qOc6oNID2mQh/f8ylSZXno1AKweFGZN5mnHazCVK+uMAmeVJVsXSqiVIj+jII5Bv5R17VIeahwTUPhjbd+rDEkxg/q0wAX+2CtkGxCWFEEZNnZCGOe00fNIi7YMWfuGW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 MW4PR01MB6450.prod.exchangelabs.com (2603:10b6:303:7b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Thu, 3 Mar 2022 16:02:34 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.5017.029; Thu, 3 Mar 2022
 16:02:34 +0000
Date:   Thu, 3 Mar 2022 08:02:31 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] arm64: smp: Skip MC sched domain on SoCs with no LLC
Message-ID: <YiDmlzoKr4VZplZo@fedora>
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
 <YiAlfGuRXWVnOmyF@fedora>
 <CAKfTPtBbu3fUMBkXLszWGtaHkf4DRU+J+9z_2MZ42iCTAtLGkw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBbu3fUMBkXLszWGtaHkf4DRU+J+9z_2MZ42iCTAtLGkw@mail.gmail.com>
X-ClientProxiedBy: MWHPR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:300:ed::21) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b09630f-9f95-4d8e-b170-08d9fd2f3a16
X-MS-TrafficTypeDiagnostic: MW4PR01MB6450:EE_
X-Microsoft-Antispam-PRVS: <MW4PR01MB6450807F426C2E6002DCFE05F7049@MW4PR01MB6450.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKr7YUTwACWy/FbpZH9VkrkzEBwU1DmLTRifavYw3EldiFMSzeqsH5AYKuKQnoHYkjGp67wRqwxALrZSXpMAx44b+it8zQPUWipQViNL0RCXZnGWomkLu/4fBgS39I7/ap+fQXKfqFdL19VH7AlzglMAGCvWTcpEAggfENd+BOVQw4PO8brHgKsJFe7so9J0MwR8rpi7lTTaRq29rQq6F6EeB4fwFfyaK33letYR0fudyGhwDx2hwHza5liQ4LgsWe3jut9WSybserOND/O1f+Chkk2BlqSj2ytHkgudIrzX2b40J1KSW8cqeF2bfUm654REsq1TpzHVZP4+oCKgVyDqh6OTpV4nQn0yUO5HartMyCK3yLi5PWAT77MEvuY32WETn3eidyRcuAnBPVT/Hb3uy3ZUXXqMds9I4kEXS1PtTFCsHQws7mjqDCaDKRmK+7i37jxjLiMGQGgT3Biiq4xBWG14GHJGI+VMlXy2MIuKgGgi9zMQ6sukX7qDAC57AwIzlXKlFqlGENf2h6KsaK12SR430LXVPjXJMyxzet2KdR+VhU4ukISyjsiK1K8SosksCwS7Gftta8hSEm1ydz7LqTfVXZa0kt8Zt33H5A1RSFHDRPR0fAS0o1FOM9DTAC5LcgR/Jv1o0PSkSWYo0GTWindJADY5bVV/UgPQWEBRULOrfx3T3lwLCvDakM9i7JubKUS4qWRKLs+jj2M/FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(4326008)(6486002)(6666004)(52116002)(186003)(83380400001)(26005)(8676002)(6512007)(86362001)(9686003)(2906002)(6506007)(8936002)(316002)(54906003)(6916009)(33716001)(5660300002)(508600001)(66556008)(66476007)(66946007)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T+KeAl2dOcErGxyrCaQFHmU0I0y1fXiFYjOkhhy1iW24c2Jz7wwKDuVltCDW?=
 =?us-ascii?Q?4iXJVms+3ZUXJL/rR4p7eYfEHELDZSlFAUt3ROS6xD1/sxig6w1gqBEQqW2Z?=
 =?us-ascii?Q?EUVFOcxWv4SN2VLDFMFx2COOska31xdZrauCEaA71QFPn6keO17DevpXT4iS?=
 =?us-ascii?Q?MUJQqfNJDHyEs19jYLCHDNN1B76o+8HLglEwIiq5VTm+HLqwpT67pw3hTyDO?=
 =?us-ascii?Q?ucnxLx6BZJN2j8wbqMQy7WWCAIQUh8Y1zo/G8QereLs2swT27TH6gvJ9dSYL?=
 =?us-ascii?Q?u4Jr6wbOm6WcWgJjhqMJXqr0/JejHTVmE5MJpIkDz0ujvNkFWOiPO6/7t+pS?=
 =?us-ascii?Q?m5q/rtfhn3D2sb81B2BSTJVhJxP/0dCrg6GB4M6XCK9lnJLh4zmK/equziQc?=
 =?us-ascii?Q?4VFsbNanBNuWlH9bmlUMyOEL+TcTS8N3ssl69lxgIp07AQ0e3MUl7O8JNMK4?=
 =?us-ascii?Q?ao1oJGUIY5HbRIlY1JwDm/Bzkmb14sp4oLZc23nl1BC2JB+0PVTYOsT3KC9o?=
 =?us-ascii?Q?dUBOAZjbMAH0KXSG4IrSBpIbxsplosrVndDHTFNVW+AKYyfzndXAHadsu6CF?=
 =?us-ascii?Q?I9sjTk2UEk0qMmNWTtHujwYA2n+g00O2/2SDyakI8LaGOl0B7oSWd6KtRy+W?=
 =?us-ascii?Q?RSR7gSn0llLI/jiG7mCKo1k7AyGbRoO4TxwFOs47sdtVbrwWXHXNbE61N7tv?=
 =?us-ascii?Q?M1sQ1Oa3KJEtd+C6FY2rtp7O11l6J01jwK8/agWNPOX9c2Fm/9H3niGnwa8q?=
 =?us-ascii?Q?biDCwxp+BfKeuhMeyz3SeCjqhRwasPXvx/UHXxxW0Rgu2juRimS1QQ5zFEjL?=
 =?us-ascii?Q?3YJQWTOb91o5GcJ+aFf2v06YKZToCAlsvgkm2DD83YtQj8ygpbv3cogijlep?=
 =?us-ascii?Q?lmLTfhW0okGt/6MO38HbP/U/WLwRkekHVsJAI8DwNtVtbcbKubnKc+nwPa2B?=
 =?us-ascii?Q?uakrsVjTedpTvMs4DsDlvH1m5JcPPLRzk+6MaGLWMP/5DfTLJcdfs4G7dGx6?=
 =?us-ascii?Q?LK25iEH5ZOGO5NdGw2q+vZZVXoAsDDHh5i+GSCnvSEXhbw2J7oq2Ma+cezJI?=
 =?us-ascii?Q?WxwVNjjMi5tyJZziUTMmZQgE2xKksKefMNbz7Co/hwaU9H6ATxy6kbDCb//E?=
 =?us-ascii?Q?vOe/W4I6Aj+/rHuAy2g3OmD0GcnH2My4EkscC/0vT7CztyS3HWVqch8C01mc?=
 =?us-ascii?Q?sPjbLcvScduKqq3Jlu/eQg5dFqvCktn4/ve01bCAuxsapY3ZVjcJb9WL1WnL?=
 =?us-ascii?Q?baPzTKtxgVwRgmm7oD8dniN3tmzGZz47U0BLcPqIyT5VbflV+jHEin3m6X5N?=
 =?us-ascii?Q?qD8RbOhKvClKORSqcgEgURlsVHzoQKiqkMfVv+Aa/2lBJl1/UIsXwf7JWiJQ?=
 =?us-ascii?Q?1kBUl/9wNEb/3XTJoN76uFbpbWJ+ma7XJUtdiiRDY09bk/8NR2jShNDXzADG?=
 =?us-ascii?Q?b32bF6Von3iclVULjkdZKbB9mXnpC8epqzGwBwiw8lrYKM8E8JG+1AsPYq6y?=
 =?us-ascii?Q?k6Rca7M8S50q/pmiuRteGLFvqt7O7si/pw79Zh5AYu3i3BTghAwm3LOfIiLK?=
 =?us-ascii?Q?CM4G0SPZKXBWwfo780F2DQIzlTwlWJQnJeS7wYMbTUSb5vKyGEOwU2Ru2HpB?=
 =?us-ascii?Q?dmfhN1uEFGXlOAjmeue5cmdsfUPDc2sosb2WfPCOAwhgpuF51OnYQSNToujD?=
 =?us-ascii?Q?+rf++fg618C73QZLg37Rn+ak5xzSnsd2+i8LKPVcZmSQ5El3cdbTABi95wN5?=
 =?us-ascii?Q?EAZa94kkjQ=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b09630f-9f95-4d8e-b170-08d9fd2f3a16
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 16:02:33.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wA62Qrt8pqcNQlIxKIs/iqZQrLDNWKIM6XI8DKvSGjQJdkBghUBnQwbQWrfdRMSUP7djyn/cy9RzY0RKo3sV9GOxFeloiwzxLZHwcugfREjMWf8V9tkMSGx510cRdUu1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6450
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 03, 2022 at 09:08:38AM +0100, Vincent Guittot wrote:
> On Thu, 3 Mar 2022 at 03:18, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > On Wed, Mar 02, 2022 at 10:32:06AM +0100, Vincent Guittot wrote:
> > > On Tue, 1 Mar 2022 at 01:35, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > >
> > > > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > > > Control Unit, but have no shared CPU-side last level cache.
> > > >
> > > > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > > > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > > >
> > > > As a result, build_sched_domain() will BUG() once per CPU with:
> > > >
> > > > BUG: arch topology borken
> > > >      the CLS domain not a subset of the MC domain
> > > >
> > > > The MC level cpumask is then extended to that of the CLS child, and is
> > > > later removed entirely as redundant. This sched domain topology is an
> > > > improvement over previous topologies, or those built without
> > > > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > > > With the current scheduler model and heuristics, this is a desirable
> > > > default topology for Ampere Altra and Altra Max system.
> > > >
> > > > Introduce an alternate sched domain topology for arm64 without the MC
> > > > level and test for llc_sibling weight 1 across all CPUs to enable it.
> > > >
> > > > Do this in arch/arm64/kernel/smp.c (as opposed to
> > > > arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
> > > > populated and we avoid needing to extend the drivers/acpi/pptt.c API to
> > > > detect the cluster level being above the cpu llc level. This is
> > > > consistent with other architectures and provides a readily extensible
> > > > mechanism for other alternate topologies.
> > > >
> > > > The final sched domain topology for a 2 socket Ampere Altra system is
> > > > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > >
> > > > For CPU0:
> > > >
> > > > CONFIG_SCHED_CLUSTER=y
> > > > CLS  [0-1]
> > > > DIE  [0-79]
> > > > NUMA [0-159]
> > > >
> > > > CONFIG_SCHED_CLUSTER is not set
> > > > DIE  [0-79]
> > > > NUMA [0-159]
> > > >
> > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > ---
> > > >  arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
> > > >  1 file changed, 28 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > index 27df5c1e6baa..3597e75645e1 100644
> > > > --- a/arch/arm64/kernel/smp.c
> > > > +++ b/arch/arm64/kernel/smp.c
> > > > @@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
> > > >         }
> > > >  }
> > > >
> > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > +#ifdef CONFIG_SCHED_SMT
> > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > +#endif
> > > > +
> > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > +#endif
> > > > +
> > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > +       { NULL, },
> > > > +};
> > > > +
> > > > +static void __init update_sched_domain_topology(void)
> > > > +{
> > > > +       int cpu;
> > > > +
> > > > +       for_each_possible_cpu(cpu) {
> > > > +               if (cpu_topology[cpu].llc_id != -1 &&
> > >
> > > Have you tested it with a non-acpi system ? AFAICT, llc_id is only set
> > > by ACPI system and  llc_id == -1 for others like DT based system
> > >
> > > > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > > > +                       return;
> > > > +       }
> >
> > Hi Vincent,
> >
> > I did not have a non-acpi system to test, no. You're right of course,
> > llc_id is only set by ACPI systems on arm64. We could wrap this in a
> > CONFIG_ACPI ifdef (or IS_ENABLED), but I think this would be preferable:
> >
> > +       for_each_possible_cpu(cpu) {
> > +               if (cpu_topology[cpu].llc_id == -1 ||
> > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > +                       return;
> > +       }
> 
> This works.
> Also , do you really need to loop on all possible cpus ? Would it be
> enough to check only the 1st cpu ?
> You won't be able to support a mixed topology so all cpus have the
> same kind of topology i.e either cluster before or cluster before the
> MC level

My intention here is to restrict the use of of the new topology to a very
specific architecture where the problem is known to manifest, and avoid
introducing any unexpected change to other systems.

For other systems, they will break on the first loop, so the loop is also
minimal impact.

As for supporting a mixed topology, my intention was again to not make any
statement about the existance or viability of such systems. If they would break
before, they would still break. If a new topology is needed for them, this
provides a easily modifiable location to do that.

If the consensus is we don't need the loop, this simplifies my specific use case
at the cost of applying to a broader set (but only hypothetically I believe) of
topologies. So no objection to dropping the loop.

Will, do you have a preference? Lean toward targeted change and minimal impact,
or lean toward simpler implementation with slightly broader impact?

Thanks,

> 
> 
> >
> > Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
> > arm64 systems who can test and verify this behaves as intended. I will ask
> > around tomorrow as well to see what I may have access to.
> >
> > Thanks,
> >
> > > > +
> > > > +       pr_info("No LLC siblings, using No MC sched domains topology\n");
> > > > +       set_sched_topology(arm64_no_mc_topology);
> > > > +}
> > > > +
> > > >  void __init smp_cpus_done(unsigned int max_cpus)
> > > >  {
> > > >         pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
> > > > @@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
> > > >         hyp_mode_check();
> > > >         apply_alternatives_all();
> > > >         mark_linear_text_alias_ro();
> > > > +       update_sched_domain_topology();
> > > >  }
> > > >
> > > >  void __init smp_prepare_boot_cpu(void)
> > > > --
> > > > 2.31.1
> > > >
> >
> > --
> > Darren Hart
> > Ampere Computing / OS and Kernel

-- 
Darren Hart
Ampere Computing / OS and Kernel
