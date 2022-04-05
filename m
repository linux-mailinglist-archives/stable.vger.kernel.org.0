Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D464F210E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiDECtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiDECsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:48:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2107.outbound.protection.outlook.com [40.107.92.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EFC399712;
        Mon,  4 Apr 2022 19:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MomQ6+5p4922jEWxygp4xFnIEJjmJ6q5WkXkVFU5e0J3MfjVrSGiegZSbzjGf6irV/b7XZ1fod9LnUi1LKikvWAD0/BQGj874I6w+suc+sgbdQtF3y6APwEDFWP/X6r/CPpWWucq2Y1gktCCIQ6lJQuEzxik6oj1ZD0NEA8vTZdRdu6c0+VqlLvi4VIsB/dOvI4QcSjvt5eQXemSXLAmTfobCQ8h/kvRPYMsl092+AeF3wutJGDsTtQNwxvXvHQUxcewum4SxTAogwHl1597vNFapo7nHgjaR2SEi0MBzhgvttlxmSmZnVGhkCaxAQiHIzUIQvhhZF6NKclBempW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVbEwSDn4pb7jVnQcLcXheAYewBRsQGXu4xv7e1KlYI=;
 b=X3atdfIVlLet2f9QMKuwDOOedLmiqKF0kkUj9PhyV2+TAwBeD3zF1dNl4cgzcM8lhUeqS+xnRtWIp7LiWzViUsqex+wK84BlmphT2MxvYO6Atvu7FLvQ+AHuUOfpCeQQvtuP551l1jv+nMTSCtcGXXNB2uhWOyC1ffJjKUGEiC26qY64vonm1db4l7Oi1AfGoXBZ7++kWfvxJRaKBxObZwy1olAwZBAxou4gRkKkROrFk13JBKNeXf1m//SRaRU8kYPlOOH3okIAno/IdYsXPbLtbFAhJ+j7uLkkhGKRhsY9K9TCMbC95s4dPnR7FpudgN6nmjgJ/ru+HVDFq0rF3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVbEwSDn4pb7jVnQcLcXheAYewBRsQGXu4xv7e1KlYI=;
 b=R6YxsGUmw/+iwRysJeOaJzBYyZvnnF0x2n5jRxuMZpx2tD0sMglVETBUcd6fxvPnZdGUYIzb3K0iVpelsYVObD3iN9nY6BxHZ01N+hAKoV9TjwABdMKcwnZthREV3jrfH/coOuINi2IizxEWxHlcmnGDeuqtKAvsnzBA0480uv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BN6PR01MB2754.prod.exchangelabs.com (2603:10b6:404:cd::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.16; Tue, 5 Apr 2022 02:29:22 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 02:29:22 +0000
Date:   Mon, 4 Apr 2022 19:29:20 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YkupgBs1ybDmofrY@fedora>
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
X-ClientProxiedBy: MW4PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:303:dc::14) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64aa98d9-c804-47f8-99a1-08da16ac1842
X-MS-TrafficTypeDiagnostic: BN6PR01MB2754:EE_
X-Microsoft-Antispam-PRVS: <BN6PR01MB2754418EB6375F40D5C12ECFF7E49@BN6PR01MB2754.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSfUqivJ/PHvyqkNtA7zeGj7OC6L2C2QrV8v8qw6fiEx1+wqGB8CyicRnRWJ1zwpvQh4juStuutuUnjFW6RhagxsL8L+SCj3+/S1ugry29gRMWKe3euYKI6oqSqZsjI0kQ1fH/kbwxsvPg1VrALvCC+OFniTl3AfK3HIxz0lnRPPQErR6l2kwQA0OWMVfIFtduOvf3Kh5Dyr6PMOsewKFEhRB2LHbvV2thE5r50q0mjewpSpAxB/uGtPY+tFbE9olzgzGtU/RcLi4kDpkrbFkbFZp6W62Mnbqf1AC7QJzbYoLokIYE4Sy+8nZ39vzuhUfQ8/rKv428fiNWhkLfRSVwaxi4tMFICxgtrhuR7Bn1KpE32p7vdC3y0yP0dAsh1ykYUMHSC9LF/FfaxDL6wktoKVr5JkFg3ylIrljr1P/VltHcQeAIfiFnQ1L+6UnZWOm8iYgFhraQ5KsAOG/ag7EvtNivoR2YUwzngkRb9lRpr1Gw7RzwFpJOa6c1M9NmnskHNd8S2Bg4UkTF7IUdUPcbWh9LKeJhCp3bwZW5IevMD6JANbOGH9Gtqu3ekzTqUrguCytntCdCImEHiEW+yqgr0EvCk5CRs2YRL5JRy+YNE/VSXyHBU7YvZ3ZhbYzpiPQvjFrSsAftBUD6WUNx7PhOs/HjCFXOqsSmfY9wQ18WZTuMEtOZEbNGUF+0//KJkSdeIx15uBPc4U6+SHNolb40oClGz5eZLYgmLu9PNFZCjRhFtWYH1zHsZmrVzQnti1v1o3TLq5syrkuNEsYtjKS3MJXDQI4HRsrKU53VryXBs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(52116002)(9686003)(33716001)(6506007)(5660300002)(8676002)(4326008)(66476007)(66556008)(66946007)(6512007)(7416002)(86362001)(186003)(26005)(38100700002)(508600001)(38350700002)(83380400001)(316002)(8936002)(2906002)(54906003)(110136005)(966005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cqhQQELp7MptStRw/iTTSk7+t6Nhs5aK9syLR8nGIeT+UGsJYvOHp4FNY7vU?=
 =?us-ascii?Q?E0MZD2hjW40CMGHkuvSTCJgw9gYLsgtAjXpn/EX7nhKxa6ZTRUwqqDHlXFDH?=
 =?us-ascii?Q?hPfKLydZlDVZYWCyfCaZx745EjPvHh5NKO08ZHusYUtkHbpEATLM0pAV/2io?=
 =?us-ascii?Q?L/bVtEfFb6Tvg5gjjyZtyyXD8lWLND6XO4SU9ihVajsCH8BtkBs7UtU/i5bz?=
 =?us-ascii?Q?FiaGJicY+qQz4r4sbQn5wmgyFkqhk/wERdq92xevI2mtSF007GD7QZGp5X49?=
 =?us-ascii?Q?zqq4aNivAUME5FlS7WuzxLHWTPmAzYKmTzWdU8A0T7gL+SooenDLKW+OeSvf?=
 =?us-ascii?Q?C/kchA8ORB2ZT72KQbntb5bsAI8qBwHWjShqasiJiSrMS8aZoYOxy5pyKpLo?=
 =?us-ascii?Q?NiiLMkh+IHNomZj6Xv2l0ZNOZGasrKIq97UQAhebNR3VNcjuWipki3mNa95r?=
 =?us-ascii?Q?0o8/4WH3yDMzRHOegLJDo1nR3eNn6pkuovFL2iu/W7GTTCigFKtOSknvCLHj?=
 =?us-ascii?Q?+LVQP44owrPpoRxBEX5N05JdA3jSj/GhgfAyl+tKkAioVhmMfJ+bUmeEcgnH?=
 =?us-ascii?Q?lHRDGrKuXY4r28NC31Ct3b0FAr2kFwELuqujMzRrPgLtMRzSunu8aJylIFh+?=
 =?us-ascii?Q?20wfPVrbtVdqcRigxLBiiHcYIOm1k7DA67ez9e/BbhfEKaBJ9SVNz+kk8nj2?=
 =?us-ascii?Q?f2AnTUOUdDXYIzMCP8McXwjvX20ofqPvijwp6zZKBcC1hupFoI7basiPW8HX?=
 =?us-ascii?Q?B6kG0c15LwzVJSnfexaN22lodXmKhz26Pt1Pu2dhuQjrfJFVajEgeMAx3Z/4?=
 =?us-ascii?Q?X4tK0xzWXHJ7QiQkG7SgJ/Ielq/wQU6mv3arxsxG+KDy/yZAinB6K2EplRAy?=
 =?us-ascii?Q?aK2rbaHLFuv7Ge8iaY8mMv+ZmaSZa72AfZg/+LdPxrjMf9AeUpTjgJr1/th/?=
 =?us-ascii?Q?NAb2FomW/Akjkl9A/kvb+0kOLa9khaXY5aIGRUyjuXGuVBovLIYFc3R8vt9D?=
 =?us-ascii?Q?tLHYFY4lBc7DBIuuUc4v3CwXdTYwpIwSi3hYEtx0L31C6neZgZbGlD6Txi+F?=
 =?us-ascii?Q?ZBP5OhHOtrOhvl32us4NiwV/0Dzekgt21JDDnpSoUAlrK5bTKFoszcoawq1H?=
 =?us-ascii?Q?E/rJNXGTiY24Q+MkBakHcCCCy9KLKq0uDYMFb6T+VA6I8VD5DK0pomHwdFqZ?=
 =?us-ascii?Q?mMf/uMIyNcKB1oHc3bqQ9ZKx/z9a4lfHxze9OfmxpmfSlLWqhcx57WATgl66?=
 =?us-ascii?Q?QoEysTb/tPjDTFwABj+j6qZtryxx1HSgLkJKDoXVymp7DHi10Y98IOJ3m+Ii?=
 =?us-ascii?Q?fWvRnDLky+/v91eHmcMhpek5jucl8khQ6/KfNv94N8g6C7eufaFtbcUEDWlr?=
 =?us-ascii?Q?rUnfqNzHSX/47e6sORFhAIn/CV7kKlj/8u4SLKXGbAIL9XqkYB3vOk6+a8gO?=
 =?us-ascii?Q?B+JB2DFeMrbhZbz5SY4/Kj1uvK2a0eGDShnhqMFqXv4HqpCPexGVsjLiHduS?=
 =?us-ascii?Q?C8ZHyFkOJ4Avagf9JGopRPD5OjWHNOtBrVGzaA9B76fgwd7RhASDrdBvCYX2?=
 =?us-ascii?Q?CCA6GLAz71EBNwI22bhvMNlKqbo8/zMZQeaZcepTj89LwcxUr237K/XRkZV4?=
 =?us-ascii?Q?94EWALK22JuFW1KACR8qJDjcxYUek83e7nm8Hvrwwt7q0m7QIrRn8coESa49?=
 =?us-ascii?Q?1Eiy1yr+ho324nwITQoWH5FqBw0SZAEmmhapU6WBSSadmOduCsaq+lIypUnr?=
 =?us-ascii?Q?us8yYsiyL27VqGY00ge4Cg8SX8WCHwVproQ0yenOY5c3cKGX4k8z?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64aa98d9-c804-47f8-99a1-08da16ac1842
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 02:29:22.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kelRSB+r1EjueDFH6/RWvj/vR+n2XEwkTkubfrhrs6OBt1G6iYQOlmhTJ2otlIhtqeviy3UaVnpNZ4hTvuMqG0kAMgemrsXpuCJxy2eKBq+/WZD3nv8k0dikq/Kc7dUa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2754
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 04:40:37PM -0700, Darren Hart wrote:
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
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Barry Song <song.bao.hua@hisilicon.com>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> Cc: Carl Worth <carl@os.amperecomputing.com>
> Cc: <stable@vger.kernel.org> # 5.16.x
> Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> ---
> v1: Drop MC level if coregroup weight == 1
> v2: New sd topo in arch/arm64/kernel/smp.c
> v3: No new topo, extend core_mask to cluster_siblings
> v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).

A bit more context on the state of review:

Several folks reviewed, but I didn't add their Reviewed-by since I added the
IS_ENABLED(CONFIG_SCHED_CLUSTER) test since they reviewed it last. This change
preserves the stated intent of the change when CONFIG_SCHED_CLUSTER is disabled.

Barry Song - Suggested this approach
Vincent Guittot - informal review with reservations
Sudeep Holla - Acked-by
Dietmar Eggemann - informal review (added to Cc, apologies for the omission Dietmar)

All but Barry's recommendation captured in the v3 thread:
https://lore.kernel.org/linux-arm-kernel/f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com/

Thanks,

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
-- 
Darren Hart
Ampere Computing / OS and Kernel
