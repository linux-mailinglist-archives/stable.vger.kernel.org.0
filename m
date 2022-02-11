Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F7C4B2C23
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbiBKRyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 12:54:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiBKRys (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 12:54:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AF838F;
        Fri, 11 Feb 2022 09:54:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/ndxMY3334lL6oIjjwmV1rWiZTira/W+mqqa+ukIBuLhg3DtYQCrBU9yIEo9uhL2Hh3hl3qYjCj66mYfzYV+ZjAOiJoR02wPz37uXdl2iJxV4jsONkaTGx7Ukcr/3AGT2E2bz7/OPUaW340lV8O1gY9niYXCEp4oN/S1dqnFBVbzCLBiP3vPASFyCIzPBEAu/GxsU7i+AVz48/id9OQPH4v0ItTtPv+/BX7SapHnYuppxQLuKRx8nCe/PhyuuG80+paY3UdC16mGXIh74HMOZ08UHrO8/i4yqoc9xkaI96UHWe1b6LMsl0028vhyu/ErZ0nKnAwpFlxro9n6wJc5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2ctyanffsdDPgAM78l/Ol88HRiFKVXVEQ+rDMsnpaY=;
 b=oWyNfU65m95vpm5WC7dZbZpEURkMaT3uYgZnbeqcaEVfb+n4i3sJ867av18IkvPjoNQ71mxp2ShQ3GrmIFYsLnQYYV8puJPJTEYQnNYmsSlPGXb1+DmDX7VDHCZY3uU1rX67nnEsDUl2SXTPrST3yccr3AcqQ/imatqJCZN7lbnhl10MeznE0Mgkz1VyJespbKOL3UHbTqrDwCU4Ano01jXykwk5ORiAUDxXqyt1f3Djt4ztTj37R/8Iy+/flilPOW2YnFX9H7I5UF0TS38cBB7oUbJ5XzHoSSml+/gP5sfK1maFCWEVB9HFWTY8vceFYx18KcD0hMaSoGG68ZPwOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2ctyanffsdDPgAM78l/Ol88HRiFKVXVEQ+rDMsnpaY=;
 b=OzqdxOyEzyap1F2W+XJmOcUNvtQmSwjfQAsxQ9MnsUENH5NDV+hexeyznTyvetue7WmZ/CZxLR+qMrtMxVEGDiLNgsotlB2aVgzYaR9ZOZxl+ELq5HWLPq5aR68wy/Vngi5WBEh7RsEy5UMXWwIezWXqAjGIZb3yY6zfzj2UNOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BL0PR01MB4836.prod.exchangelabs.com (2603:10b6:208:30::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.12; Fri, 11 Feb 2022 17:54:41 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 17:54:41 +0000
Date:   Fri, 11 Feb 2022 09:54:39 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Message-ID: <Ygai330kyA1yYgj/@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
X-ClientProxiedBy: MWHPR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:300:16::34) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b9ee30b-c38b-42bd-ad3e-08d9ed8793fc
X-MS-TrafficTypeDiagnostic: BL0PR01MB4836:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB4836ECB5E31535518A1573C2F7309@BL0PR01MB4836.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+qv8rZmbALwbYXwR/T3LxTN4mHyq36pgicSHwiP3kXKzgk+w/qSZYvAyw4YKjC/4WnPt8+M/SWYpZVuNAae3msdCUFUlKvX/TixB3cpInJe3CDEcpG882HlhdkKvxSOzVBcRs+JlI2JQoP/LW480KdiOBNL1EguMnzMRPuU5CL7YXfG2xw6Ssf2J1fi+Ddo5jFiISTmzsTTXMlqFl3vET87wt2Ox70VdO40h+nj/uCdoMoJekrp0fVIVPls7wmA9FAQS1uCE0k+sCFdGmdNhNRRjw1iIpTW97xLCvtDd+GpD75czji91MhfxpDfMfeZmOPDPXPkTjL/butkzZP6x71H9AhmQwrjFYwot63yUMPUK/6QYqQILENGgik+6t5CUUktuL0peZs/t30xDbH2hT4x39TEhPp4ENigeVBsMODP0KAvcbN+94FvvZTcyiXqoVNTGTmOuq/qdcRV/xUZ7/u/A9FkaJqLFo2Jn0RjjHOzdtIG1orZ17psSJQs67jDsrDqQObo/D7J5xVBtePDzLBE4zueK+jhyVeLN4KA0lKxtSgSQtaboc1mJVKiH3fNeJZhtma0HTzDMBtY5X2bNtGCNhuFsgrdx4Py9bGPI6blXRPH4g/OIxSHF3LbBlIc8OmI6r3N9uPklIysU0DkJ5+IiSzDQIzXx/8qqolEu6OtnP49/XmGGtLehjfUrO8fHHOtNSjRWVNl+a4PgQWbaCSY3MHSPuffh+eBkDLwS+YAbwab07kISkizNK5ys4ZfqbHUf2/KF6+6YzuX/MjhDGtvMVmXgMYpuAXHcfoWDsE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(38100700002)(38350700002)(316002)(5660300002)(2906002)(26005)(66946007)(8936002)(6916009)(54906003)(86362001)(66476007)(66556008)(508600001)(4326008)(6486002)(33716001)(966005)(52116002)(53546011)(186003)(6506007)(83380400001)(9686003)(6512007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lAdFbnJlPqWs16sVvDt8nz+0FnmCJFnqCJftzNJ3agMWSvkZVkkugS748yJB?=
 =?us-ascii?Q?HpIUz5huanNYTUSawrh72cYBwtGQQor3KuLX31UV8OFRN5hUscg6n7os8v2z?=
 =?us-ascii?Q?jFTC7R6I70Xqn9E2lZeDTscPjmwQZvuFVNNpcu8OV6fw2LeeejFPn5/W2FuB?=
 =?us-ascii?Q?ytcW5nZWGcg82MvuzECzR75cugYw4Ss9EVDsD/jl7f7huvJNEkx3M6xzTnoF?=
 =?us-ascii?Q?L6xsnt0pHTBALg4LOA9IB5ddGoeIAByMVN2fc6X+VypgcczIcsPye4TrFDzG?=
 =?us-ascii?Q?y4iDU/9zsgpMcPbrLeSk/YG6WbbAQ41VrvV8bmxWOOnV64w4Cy0ZAwXA1qlq?=
 =?us-ascii?Q?REogbcejJH/33mtEgCwyrqk1Iil1MDEF0hZXAfu3JaVXK7OveURdNR0kk7IS?=
 =?us-ascii?Q?faufabMOB2Hb6naJEdLs1lBUCbAPgKiberzzu4BoloR0pcKNvmgTcJwKIEXx?=
 =?us-ascii?Q?Cp6kNl13CTbLN1eRPUBNw5feiidFg3VSsL/ZVqMN6vgaLrYixY63MK1hK5Sz?=
 =?us-ascii?Q?BUsq/rVnbGNKfcNZ0Pq4COC4hi22/PXog5vSZ3trp/X2C6gWEcoKfILbPIvD?=
 =?us-ascii?Q?mJ+cY3ZuTnU1X4q8IW7ASmAvOqJ5uZA/z+K9KnL+V5D6PvHVdPNszOIRhdnq?=
 =?us-ascii?Q?tD8AIbiEBHiwjV8lnBJskpqpHQac+vrUEfDGtdRq6ckuHhIwpxWPJZgBDuLH?=
 =?us-ascii?Q?gFRdZocJngwt0LPFKaKJbUL8KrKbFk09P13ae9wNBRZKifqIthB2FFTyb7Sp?=
 =?us-ascii?Q?kkgOciaGjooGQKbcr0bmTLBslJ52fbX3FRsvLiohnbrjstUIThkbK11z2/UF?=
 =?us-ascii?Q?JkIh8IBUdUDMkOHOq28hL2/JhZ4bsphmy/8tcKclIgkEGmc4VZecR1UdoQcR?=
 =?us-ascii?Q?5LWM69+35qoB3MFww2EhENkg3b/WOJJLvuKTJQgIaP5wFCfvllpyf2o84b1x?=
 =?us-ascii?Q?dPogSKSyq0yl4BfFkyiKJN5VMwmEoFyBcGdNLmAOnKCKWyOux3HU3sM0sHtY?=
 =?us-ascii?Q?KmL6swg/20TvHbhKGCsqeSKQyd7zIwf4a6rDoQgmgh0UGpI0DoK+iCkqT+Qc?=
 =?us-ascii?Q?Ns8kvlM43wASZx/UXluruGgGEiSsuBrx5gyOi3iXurf7RNZNA8kQeSed5nOB?=
 =?us-ascii?Q?8M3TIUZ7F9p1M9rM7ywFjeMV5/FiIHaG/U2S0cWatpbbhJd+3ONLR4RJOULp?=
 =?us-ascii?Q?/+61pWa+z6X5jDjL/14ANW4+YVZreLXrEj0kONGx5Ruur5ZlfgzryONL4gWm?=
 =?us-ascii?Q?+o4J2TYV9SLscktDHaqcJ2V84rUCB15FOUL227u5Sk58FkB3T3gwTK6+J8Ta?=
 =?us-ascii?Q?jgHS0qrci39nHCrx3awuomw6XBXQDn8WCNJcVLkFMbK7AUbXUem4sqHTlpW7?=
 =?us-ascii?Q?T8VbzrcM82im8W+8x9Cy9QeRC++X4eUpd2LFM2tw2Y2Opk1dO3G2YGObTht5?=
 =?us-ascii?Q?tRUFhgk3V5KYh1MHZHF4OBo2/gXs4MwtgLdzSQ/aPM2T2cifRHnQqRLHIml/?=
 =?us-ascii?Q?1o7fWGCVZfJSjJr4tgFDuCqKpW3u+/7Qp7GTr4q0I6IMwt5luIjRg/Q3oP9s?=
 =?us-ascii?Q?ezcoog2xkU+xFXpajiuawat/7mKHGbIJrPoeDkosvizg0usN+r9hGPmBI+pv?=
 =?us-ascii?Q?wO0V3/ARySXR30d7jENFkOK/8RFftZlikSVtKc3RaUoR7fqcuIG72YIbndVl?=
 =?us-ascii?Q?nOPtwEBuYBHaheWeq5oJ90WJuBtEDg52akhL7d2tUytZYkNp67LGtg3r4bv0?=
 =?us-ascii?Q?xwgooOQdJg=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9ee30b-c38b-42bd-ad3e-08d9ed8793fc
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 17:54:41.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9YTjhPkk6Q2H1dtTMt9O/vKD7RP5RooCK3G4xMo8MUN14uo4rETfDhLV42WZvDlIHAjRL8KEsvhEM8U+hhPWDMt1yv7N47Kw0kDWDyJmz1+l/4bm1b4qSFPrGNMirTW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4836
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> 
> 
> > -----Original Message-----
> > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > Sent: Friday, February 11, 2022 2:43 PM
> > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > <linux-arm-kernel@lists.infradead.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > <valentin.schneider@arm.com>; D . Scott Phillips
> > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > 
> > SoCs such as the Ampere Altra define clusters but have no shared
> > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > 
> > BUG: arch topology borken
> >      the CLS domain not a subset of the MC domain
> > 
> > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > level cpu mask is then extended to that of the CLS child, and is later
> > removed entirely as redundant.
> > 
> > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > alternative sched_domain_topology equivalent to the default if
> > CONFIG_SCHED_MC were disabled.
> > 
> > The final resulting sched domain topology is unchanged with or without
> > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > 
> > For CPU0:
> > 
> > With CLS:
> > CLS  [0-1]
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > Without CLS:
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> 
> Hi Darrent,

Hi Barry, thanks for the review.

> What kind of resources are clusters sharing on Ampere Altra?

The cluster pairs are DSU pairs (ARM DynamIQ Shared Unit). While there
is no shared L3 cache, they do share an SCU (snoop control unit) and
have a cache coherency latency advantage relative to non-DSU pairs.

The Anandtech Altra review illustrates this advantage:
https://www.anandtech.com/show/16315/the-ampere-altra-review/3

Notably, the SCHED_CLUSTER change did result in marked improvements for
some interactive workloads.

> So on Altra, cpus are not sharing LLC? Each LLC is separate
> for each cpu?

Correct. On the processor side the last level is at each cpu, and then
there is a memory side SLC (system level cache) that is shared by all
cpus.

> 
> > ---
> >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > index 27df5c1e6baa..0a78ac5c8830 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> >  	}
> >  }
> > 
> > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > +#ifdef CONFIG_SCHED_SMT
> > +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > +#endif
> > +
> > +#ifdef CONFIG_SCHED_CLUSTER
> > +	{ cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > +#endif
> > +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > +	{ NULL, },
> > +};
> > +
> >  void __init smp_prepare_cpus(unsigned int max_cpus)
> >  {
> >  	const struct cpu_operations *ops;
> > +	bool use_no_mc_topology = true;
> >  	int err;
> >  	unsigned int cpu;
> >  	unsigned int this_cpu;
> > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > 
> >  		set_cpu_present(cpu, true);
> >  		numa_store_cpu_info(cpu);
> > +
> > +		/*
> > +		 * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > +		 */
> > +		if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > +			use_no_mc_topology = false;
> 
> This seems to be wrong? If you have 5 cpus,
> Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> need to remove MC, but for cpu1-4, you will need
> CLS and MC both?
> 
> This flag shouldn't be global.

Please note that this patch is intended to maintain an identical final
sched domain construction for a symmetric topology with no shared
processor-side cache and with cache advantaged clusters and avoid the
BUG messages since this topology is correct for this architecture.

By using a sched topology without the MC layer, this more accurately
describes this architecture and does not require changes to
build_sched_domain(), in particular changes to the assumptions about
what a valid topology is.

The test above tests every cpu coregroup weight in order to limit the
impact of this change to this specific kind of topology. It
intentionally does not address, nor change existing behavior for, the
assymetrical topology you describe.

I felt this was the less invasive approach and consistent with how other
architectures handled "non-default" topologies.

If there is interest on working toward a more generic topology builder,
I'd be interested in working on that too, but I think this change makes
sense in the near term.

Thanks,

> 
> > +	}
> > +
> > +	/*
> > +	 * SoCs with no shared processor-side cache will have cpu_coregroup_mask
> > +	 * weights=1. If they also define clusters with cpu_clustergroup_mask
> > +	 * weights > 1, build_sched_domain() will trigger a BUG as the CLS
> > +	 * cpu_mask will not be a subset of MC. It will extend the MC cpu_mask
> > +	 * to match CLS, and later discard the MC level. Avoid the bug by using
> > +	 * a topology without the MC if the cpu_coregroup_mask weights=1.
> > +	 */
> > +	if (use_no_mc_topology) {
> > +		pr_info("cpu_coregroup_mask weights=1, skipping MC topology level");
> > +		set_sched_topology(arm64_no_mc_topology);
> >  	}
> >  }
> > 
> > --
> > 2.31.1
> 
> 
> Thanks
> Barry
> 

-- 
Darren Hart
Ampere Computing / OS and Kernel
