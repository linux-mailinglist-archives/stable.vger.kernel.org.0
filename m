Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB24CB4C6
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 03:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiCCCTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 21:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiCCCTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 21:19:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2093.outbound.protection.outlook.com [40.107.244.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EB824F24;
        Wed,  2 Mar 2022 18:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+F1N5LMsqvkNo+HMv9iDIZEb+U6U3gRU9b7/wsOIKaixu1gofnKf6zoaxFPLtZSDJmGu0o/dIpyeDwIPPlbnficvYhyxUqehOTNPUMGblUPFx1tItnFtWn6Br4T2zppwQAmofOSznecqCu2Bu7E/+SASF+3kkU3ZUy1n7NNhggFme5AUsxWbZRNcbCQLFmIQOJJ3+rU+GYdq3bO86U8h+1RAp8iIxF/Tpa6R9l4oVaPf21JOVFZ1NhUkoecl10SfTfKF6zf9k5w0WcGG7DshKsWiE/FR+XwC7WLx4+sWX54hqSqBVDYtGJDP2KuvzNjIlFIqSfhGwA/ArTan8WFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwOMs48+WRZjc9i2N1olgQiTe52XZxybh4uFuXarQRM=;
 b=aDnest2V5R60wXLko2DWM/C9RdVOzjjvHz2g916cUBEhWymNAMIK5+El+8CvQYsUAoVXgsKkL21sqlDcXqO+40R24GxblUSUBFHiAWrupnhVi6LcCg22h9xn0xF11Czs6EbImwqnVX8F4gequiUG2xU/Y2AMulwlZgv/KQFo6gUmWBIskBb9U4aI2FN5Z9ujQWcQuXbRFdD1mQrflhFafFqt15b7Az/vu5WgEk5H9CBszk4C4bsvJQjf8JoBj57tikh4iaPjUXzHyU0Pkf6hzDIHiXeiKqYCBwb6b8PTPIv/rhTJvXiXs9fw6PxEH3yMRUDQfIdkG6hrg+YWoed3bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwOMs48+WRZjc9i2N1olgQiTe52XZxybh4uFuXarQRM=;
 b=PB+4NLcz3kTVfcNtaKVwmegSO2qJpeVrOnWiVvfjnV4YGdWlmQQDj0sfZXF2HztZwvR8mnoUG9GsgUKljHefISoZ8z5EgvVpAlF8twwfttLZVcTqODOb80A2awv598JNIF3nhMfto9my5tqnFlp5Q6dwZG3fNbXivLn8dTesUkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 PH0PR01MB7400.prod.exchangelabs.com (2603:10b6:510:10b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Thu, 3 Mar 2022 02:18:40 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 02:18:40 +0000
Date:   Wed, 2 Mar 2022 18:18:36 -0800
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
Message-ID: <YiAlfGuRXWVnOmyF@fedora>
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
X-ClientProxiedBy: CH0PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:610:75::18) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f080d145-63f0-4466-5642-08d9fcbc2183
X-MS-TrafficTypeDiagnostic: PH0PR01MB7400:EE_
X-Microsoft-Antispam-PRVS: <PH0PR01MB7400DE6FB2E34D60EB9DD67DF7049@PH0PR01MB7400.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHkhN0TbjuzBAzWXk3+CwbTVmaj0fi6+Q+su2GbOBtXOuAweJMmMkpheI4mtwP8ivKkZkYhPE8g6JQ2EKW6L+ZKcMqKCFte2aJJ8xYmJpDus8IzKck433eJ6aNCYzkLkItP2j2/rJqiOovHeeqcf26ugyg+z2LzF4gpkvsUCpxc/A4Eslw18N+wlpcrMU4+PwRe5B5WBxRrsfzmY2JhA7pNTN5S7BYjtjfb7YqwranYCFki5qD9oidtoGqUhHBAEyDVmr72EkvCXzvH9Q5ES6V44SAursYKo9rRIA3374XKeAX6/pDDeNgNQXERhT/6E30W3BJsphL7Akaxk8lH5BZpT9fJ3UeC4cTGjh+ov698x+kvj+gj8x/8E7gl5XXSPCK9eUCo0tNNohDk5FYIX9zcR0xvhpmhJWn5CnokJkAru7ZP/HHqnoLqDceRBQXJD+gPVnHcP+nDw03DNtDYOzk5c2Wuz2YmSPy1LEIBF3FCb0ttL5OU0jfAjrIqrMm9GFAWPXPcv1GY0FvQ/ek7xAyjHTCjX4Z13gNiYXWZcCy/kbKpvS0mLGuz2r22jetC7mtVd9G8JfNQtb6t/iKBLIfBAL2EBWv3jljHtFi1qMVgU6u33XxzUM2NZC0fR72EY84WEEFHxaRPUcIrgTQH7dcy4wF+Sppyl/ppIQHoHaqtYpzbaDnIYLSBv7KGp6lBx+HgBsxOtm/Qynm9HHs2YDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(33716001)(508600001)(6506007)(8936002)(52116002)(5660300002)(86362001)(9686003)(6486002)(6512007)(8676002)(4326008)(38350700002)(38100700002)(66946007)(66476007)(66556008)(186003)(26005)(316002)(6916009)(83380400001)(6666004)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MeUcsivSrpbu7cy0OLvIjIOf9VYsjYbJGJ4+2HMHoTv9/3kQ6z1czD2jzyGm?=
 =?us-ascii?Q?rU6BWs0Ss7SxjOtbkNvOUlFzGVhuOztNh5YGFHkEVuP5qwYiE5aW3CzJp1X9?=
 =?us-ascii?Q?QMcPQx5tVYq2+H0Rh78M0WWeN5fw4KTIbadRUReaxhkjwaC68nbWeoJUEsf5?=
 =?us-ascii?Q?o1ULeGHVk7BFe5uwRpLWAkFr7W1N+piBR5P7PHVi0ROJ4V/yj/PaBaaeJWp7?=
 =?us-ascii?Q?Bmeq6AdMkH4+ZVzK0vYLkuu+2iQggJd7auZXNcwY2DlS60UIFTTKHTMKPSgJ?=
 =?us-ascii?Q?GQoZZUHX8T7eG+D4IRG8q9+3fzWyu4eXhYQpIC30orzeNTsTudN5DtT8v42Y?=
 =?us-ascii?Q?5EOLvgthTkV/9sRw6G1V7ImRkhP6Qmt7kSRTF9l3gJShYpdvtUh75Xc6/zzY?=
 =?us-ascii?Q?HS2sH+seQVJMTC2Ko3dvkeMGl6CRhRDC39q+izvkDANGujT7DhsNeidrYAOi?=
 =?us-ascii?Q?bp34mHMv50/YMEF/9PHpoiyQwYI8cqaNu9QWwLY4CZ2f5z+DhYnFAfvs5FNc?=
 =?us-ascii?Q?Cr1I5Ac/PaiQGZV4tzGKxwDM9WnziM+0l25L2a0zoM3E9fkejAmmVFUAX9wq?=
 =?us-ascii?Q?W5xeDIdkN4ivd89ynq8pX1dIQxiesUyvGZxeiU2xhy+dEAJz76YcKSu3+gqE?=
 =?us-ascii?Q?DZsHk5duFA/HY8Oj+tpRlSBxZZxsirW165VSRdlOJ/pZ5Vq4Yq4Igb9zmN6a?=
 =?us-ascii?Q?WX61Ac2slAZjeJfzQFNJVm39gKQ1YSgLiiwNPUz6hGsvLmdl2KAMIsBWGIJb?=
 =?us-ascii?Q?wdYGT9wkFC76eZoG5IjzivA4PrUNie1WF933J3zplH6twf5rkc3Q1hs1Z4Gm?=
 =?us-ascii?Q?FqKWHLeXVV+nhlBTlY/x90wN50MaoL4Z7pGW/hSSTYnp3GSJctbWyw3AoCq4?=
 =?us-ascii?Q?3uSME5YJkN7AZFs/XzDTtaXEDknGbbUqPQFlpOsCf5tXq+LeEOjl6Th1GpOS?=
 =?us-ascii?Q?N4F/X8LBFXrVM7H3RfyIgYGjnlH2EuHmadelR10FIHWIzc0QsMGUxkOvGemx?=
 =?us-ascii?Q?CJtMfL4z+JvRhoEiZOymDKnqUuXn+sNxwdQkPDpMAEPdL3m0OX8qKsafxYvb?=
 =?us-ascii?Q?WhuDHuHbv/alvUrYgupXPuTKbyWWtxTbyPHI5GarSmZ/59De2gzhz6w1OEby?=
 =?us-ascii?Q?fLTT7U7Tbyl04AdLy1QG2CW9LXsRx9b4hAfXXQO6Rn4S6+LXZgVEl7G6ClyL?=
 =?us-ascii?Q?nOrb0E4wxFyFw8dsPE6J71ZdCwZ6PgMuPozNYBa71Xim9cSuY8FEQiDUYPGf?=
 =?us-ascii?Q?M7osIkWfauAzQA9481tqAbDzBqLmkDa/rtVA2LrYnJHgfLaHzhfdCvsHlWh+?=
 =?us-ascii?Q?a59LxOzH1EwUPdND5BtKPKPj2iLqj6mojkYO85vfbRcZZtJjKHIrNAfDTf/A?=
 =?us-ascii?Q?0lOjjUEOnNGOtZPpMa1KzC97uN3izOyzDfZ0dQJNm5O+NNpd9TtKnb3gwimk?=
 =?us-ascii?Q?0ylXEvrLQblTA6TvAWb/J6tyo5zuifbh+MBJ57EMrCqBDgfi5lGYJfJ5A45R?=
 =?us-ascii?Q?M25ylQA51JOzEH1NawnCWrt0zxq9VLi+WkSGi0M2nP+wR/BsKpm95ausvdaP?=
 =?us-ascii?Q?DpJtXFhMGCz5103eTqKejhN3ECzdOVJIBhoz9pMnd7GEoftE0NKQeaNO24/M?=
 =?us-ascii?Q?lAjQxvVmSV5bLxsoX5clG/l4pHe6Hg170Vj2K5XjLiAKVZUJc5fR9EcrLwTP?=
 =?us-ascii?Q?mtSL3bdkNvcgqFgFizkNw1xBZCwCK+L/2kDNXY/pi+vJLb3VJAQQlNfjqQlL?=
 =?us-ascii?Q?FI++0/HEfA=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f080d145-63f0-4466-5642-08d9fcbc2183
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 02:18:40.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZErI/d/x++zCwFlrV6R6GyJc+q5yiKh8kCWpsWG9ojNFMCe+Mw44XLYumklsb048oaFPrgvVnwixwu2WKIEL8DIcmCb5fHbnyA9QbBkm3sWG4TMdASLQw81cdDemFJu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7400
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 02, 2022 at 10:32:06AM +0100, Vincent Guittot wrote:
> On Tue, 1 Mar 2022 at 01:35, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > Control Unit, but have no shared CPU-side last level cache.
> >
> > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > cpu_clustergroup_mask() will return a cpumask with weight 2.
> >
> > As a result, build_sched_domain() will BUG() once per CPU with:
> >
> > BUG: arch topology borken
> >      the CLS domain not a subset of the MC domain
> >
> > The MC level cpumask is then extended to that of the CLS child, and is
> > later removed entirely as redundant. This sched domain topology is an
> > improvement over previous topologies, or those built without
> > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > With the current scheduler model and heuristics, this is a desirable
> > default topology for Ampere Altra and Altra Max system.
> >
> > Introduce an alternate sched domain topology for arm64 without the MC
> > level and test for llc_sibling weight 1 across all CPUs to enable it.
> >
> > Do this in arch/arm64/kernel/smp.c (as opposed to
> > arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
> > populated and we avoid needing to extend the drivers/acpi/pptt.c API to
> > detect the cluster level being above the cpu llc level. This is
> > consistent with other architectures and provides a readily extensible
> > mechanism for other alternate topologies.
> >
> > The final sched domain topology for a 2 socket Ampere Altra system is
> > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> >
> > For CPU0:
> >
> > CONFIG_SCHED_CLUSTER=y
> > CLS  [0-1]
> > DIE  [0-79]
> > NUMA [0-159]
> >
> > CONFIG_SCHED_CLUSTER is not set
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
> > ---
> >  arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > index 27df5c1e6baa..3597e75645e1 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
> >         }
> >  }
> >
> > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > +#ifdef CONFIG_SCHED_SMT
> > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > +#endif
> > +
> > +#ifdef CONFIG_SCHED_CLUSTER
> > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > +#endif
> > +
> > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > +       { NULL, },
> > +};
> > +
> > +static void __init update_sched_domain_topology(void)
> > +{
> > +       int cpu;
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               if (cpu_topology[cpu].llc_id != -1 &&
> 
> Have you tested it with a non-acpi system ? AFAICT, llc_id is only set
> by ACPI system and  llc_id == -1 for others like DT based system
> 
> > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > +                       return;
> > +       }

Hi Vincent,

I did not have a non-acpi system to test, no. You're right of course,
llc_id is only set by ACPI systems on arm64. We could wrap this in a
CONFIG_ACPI ifdef (or IS_ENABLED), but I think this would be preferable:

+       for_each_possible_cpu(cpu) {
+               if (cpu_topology[cpu].llc_id == -1 ||
+                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
+                       return;
+       }

Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
arm64 systems who can test and verify this behaves as intended. I will ask
around tomorrow as well to see what I may have access to.

Thanks,

> > +
> > +       pr_info("No LLC siblings, using No MC sched domains topology\n");
> > +       set_sched_topology(arm64_no_mc_topology);
> > +}
> > +
> >  void __init smp_cpus_done(unsigned int max_cpus)
> >  {
> >         pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
> > @@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
> >         hyp_mode_check();
> >         apply_alternatives_all();
> >         mark_linear_text_alias_ro();
> > +       update_sched_domain_topology();
> >  }
> >
> >  void __init smp_prepare_boot_cpu(void)
> > --
> > 2.31.1
> >

-- 
Darren Hart
Ampere Computing / OS and Kernel
