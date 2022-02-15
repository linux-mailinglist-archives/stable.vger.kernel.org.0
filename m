Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124084B78AA
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbiBORcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:32:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240576AbiBORcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:32:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873D27FDF;
        Tue, 15 Feb 2022 09:32:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLyWQylT2sVD7cz9FfcXUchb0+NJeBXBFDVeALAXSx4yUbyhLaa82duR+c5N4uxfYBXxN/Xm0f/vRdZFW+35XQnX+2/iJTEVg+sQm0xJV7BxH88NyAU4aHAP3or1K7u+NEgAJGOh1v2mE4InG0Y3L5U/if9cm6iZEfR6PK7fSOP1CmFp10JydPRfSsrGj5t88uJosOeMr1YsHLbYYzqD2qnPJrwVoI40VuWmZzsfLtmB9vVS31KKaCmWqi91vgs1BXviI8mbUSGwFUdEWO8qhnfYoxgB6lhZ9BYlSy7DYe8TMEYY+L2FAXYJRLRzWUmw28rBBCHcIbKbJzyiIipzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjxGXd7wJEhP2sOFbu5qwWs5hyg3MlZXqbjL+3dWRRY=;
 b=DJL5wY+/mLD3n8dbozYaNhRbra3PQ7OJQdP3VYkDEWOUR8jr8IteCGFVoupnmBtOFn0CfJmvO84HKSJoniMEDBZjthpvwwoejT1G/p481LrxcnECxqXJbTlVzcUcTrRgJkQDbzD9DCGIIv5awS5S2m5MXknG1ld14IoAXcgmokDipCXObj5AbnhmAfOzU8Ny7bY7J0eO/kKBQnO+MYJGeTeoChy8coMCGKGAbHFX/cmxMrfY84desdhWBszgLv2RWtFntsT7P8TW8AbIKIelPqugBLsAgH5+KMQDd7WYyZJyqgoxihHtF+iPFGmhNzAyow5yCtSy2AmpXkChyqfNsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjxGXd7wJEhP2sOFbu5qwWs5hyg3MlZXqbjL+3dWRRY=;
 b=h1dBD0tuWqFkM+dwfNFjp8tqFxemhmR4kLUcyu0RMh1Q/W0kxuuQ5k4V7ePtnLJYtulDycfOD6YlzwofGQX4XrEtSavuYb6JWmsthOBmCnCkWi5EQZfCUyMJbs882cgH8/WPMhnBq1M38WboX5lbnJG68Ys3XnfWzDiTIhkJk0w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SA0PR01MB6201.prod.exchangelabs.com (2603:10b6:806:e1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Tue, 15 Feb 2022 17:32:41 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 17:32:41 +0000
Date:   Tue, 15 Feb 2022 09:32:38 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Will Deacon <will@kernel.org>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Message-ID: <YgvjtsOZuxzbgBBl@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
X-ClientProxiedBy: CH2PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:610:58::28) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dadb795-6c8b-4c68-05f7-08d9f0a92ac6
X-MS-TrafficTypeDiagnostic: SA0PR01MB6201:EE_
X-Microsoft-Antispam-PRVS: <SA0PR01MB6201B399A34BF05CDEC3F1F1F7349@SA0PR01MB6201.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMGyEBPCRrB13lvNvk/wCDruo3v8Bj9tx3w1n05Xr1QIDA1sPCngHAXI3xim7Y1ituxsRTM+34X8f43lqkJ8Xnr8hBkn8Xp4+l0FlvtdDrv3/No9xil8fVmI3l1fGm2zEIE0L7c0Szv4uUX50mJ0Zp+wssFK2PAZWsXAFLJXg6SFIfYF6DGW9RTOoj4lLvPJG5JrI9ygNt4XF26UBGWUFnkNL+7igw6JEnzPHL+MebUmcopqc3Bqh+fJviMJNCYRjMzEumNtIiiVwJfZO16fFCCXokUwef0XlBlU2Q+CmjmgF4etqxil1KTVNhg6SugLGbLuB6N7gGRSonj0P9hNMhMbdIxei+Xay/g4+QL2YAQ9FjZ9DmaxmQGlD8FFeRF5XQcEkB9J/oaJB0En2cBynm5ooZygMBt7cHQjsZ3itqtlMqeU2ke2KjbLcGYvLZvWhc3448Ly3Ev5ho4aKtc+f4C5ZK3G2FXXMCLghwb31IyMdJ9R4U7JZbjLHhfsYkIbZRQntx/45AWm8NpACOUvgy9R7NRosk/hqw11aG0gVFVk7Tqf+oOe4Rz8m/TXdjImVxxvovLBBJii6SN6PXs1U1h9E8uxbMuNCzsyhIXi2qianZvet89AUEDLm9Q/Vrn4HPu0D8LfASiV9HoVk0gr4QfbmC9HpPO2Tfv90t1VC2P9ZBNTGYeGAEaqC9n5dbYVnSdx36bipyp+mju6RH0d8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(26005)(66476007)(66556008)(4326008)(66946007)(8676002)(316002)(8936002)(186003)(83380400001)(38100700002)(86362001)(54906003)(5660300002)(2906002)(6666004)(6512007)(6916009)(6506007)(53546011)(33716001)(6486002)(52116002)(38350700002)(508600001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OP9KWhk+vgYl7cKl7VOFOPdyLvTgv8URQum0pml7dQeoNox188ckDcfkYzoO?=
 =?us-ascii?Q?s9O7LXnsXo/4ajeUY5rrjRlkeqSdwurBG6S4uzJq5PerVnLo1205OoTfh30z?=
 =?us-ascii?Q?JjmRlDBt1T1lTrBs5qmG/3kwqjtN9lAX3blbiAD/viT3QxSP+d0GkJucSzQa?=
 =?us-ascii?Q?xIlP4pEnVIHrbiKuRmZoKaS4Uvf3qC4briXYdhCY4+vAP9Tl3WSLLguqpC8z?=
 =?us-ascii?Q?koT16cFl5+dMqZffPvRkcl74yv0c0zsdhWQd1FnpkLJjpBArBUwYfQyi/Z/k?=
 =?us-ascii?Q?pf+Ndul5ix9St9a/Wv+sMgxzk4yMxfF0EcaHX6gNtQU/UVjIrhpe4R7VRSAV?=
 =?us-ascii?Q?2l5KI3Vs+V3Lgn+OHX+oZDLTvZWJjWYZbWYrkEumc3UFFzrS+I9kMwcCN5wC?=
 =?us-ascii?Q?78u06OzUsT+BB2KH7gOJGsiHcR8mpNzU1c2+JON27GHHE5RPCDL/EriK1ZdG?=
 =?us-ascii?Q?q44Df418FV73AhMnLpcmMXOAx7CgzdesYHrAD3gBEe0kZoMOEuxFpsMabuCO?=
 =?us-ascii?Q?cjCvlJOYubZNvFZgb1BaDUtQJF2RTYEcwost2CUrq/EE8EX64bpqU+e2WaDj?=
 =?us-ascii?Q?sfC1yRwEYVkHOhS+X2sbhrfBrMIIo0nc85QovTbMLvnAIfM5yBa6m7SaluPU?=
 =?us-ascii?Q?x77EWrDpkVNT4v49FLVEh8Mb9odvQpcpgt9BlSFQqgyL1L54R/G9NgGk+mlc?=
 =?us-ascii?Q?+DjvJgm7DL+F24PonNTJ2r/AfsYq4icLUiy4E52cx4uRNxNZjrercQfO04Pu?=
 =?us-ascii?Q?IWJspr16+OM0gUKRLgEzEH3qsuWNncffVEOoNRa9dJc+h/UaWebjgPq+oGkJ?=
 =?us-ascii?Q?i5G9SXh61LVKDn/4KPPzNT5DkDJkTbE+btIKOgVolnCp3Q0lN7NAp5opqP3I?=
 =?us-ascii?Q?/LiHiQ32ydxQrGo0Bhl2GMwlmTyRWP8Gqg1Lpg6Izfip9ZmzAoQZuOzxkU/Y?=
 =?us-ascii?Q?cZ/pcqjlKMxblJS4PHls9KE03pUmXaiuoMbm7QV6oiXoPTyFDUd9lNgwVhDD?=
 =?us-ascii?Q?K/y5Z08E0GTIC3UZhgpfCzUjso9KC1w1OIK4yblDYMHr+BRo3kQqAxPagqwM?=
 =?us-ascii?Q?5uA+2duvuPCDzmW+Un1amiYYL/GrPMFokgG7JDKWz6v0N0EZav3miThcoz9p?=
 =?us-ascii?Q?Eb0tvsZSvR+9OatWtDbbV+G4h2P6lXpUysmlGsE0P2ebD1yyaPEemMDIMFSq?=
 =?us-ascii?Q?zyFPHYhz0bBIfV2u5xOpX4J+d8Q00rQaUfBu1YJugr4Z9yVHiyNt96uMVjvC?=
 =?us-ascii?Q?UM+6JGBVhNA3eD0iGGmzqtFQwt8Lwc+ueqJw9Th2I9QOLEJyZTWlPvIreZil?=
 =?us-ascii?Q?xcLoFh1/dV4USHj/mTXIWZhZJNhKstDfIVweeu1DehQYeWtyeTVRMRsGoi5H?=
 =?us-ascii?Q?mTHGkcnmeN1fgf2xoE57VsXqhxuaaGM/Vlq8HHVAWWHVNyYcAGz/W8phmxwY?=
 =?us-ascii?Q?yZYO5wj1PuyjHYV0782uaDLJvoFFY/HNvR1/JZQt6CH1OrrX/SrLhoC1X96b?=
 =?us-ascii?Q?vRAtgbBDmKVv2nURH/zsx9XJoPypLyUkqeA+kZZD29uR8CMuSY+OV7mVMimj?=
 =?us-ascii?Q?qKjIZVRJSSRbO1u5ZAu6jyq4qSxyjzAsAFR/Mff0WxbM5TugoLM9OQx4RDja?=
 =?us-ascii?Q?Oczduz8wiliMwokwOAnUL9NIfh00Lq3xGvcxN3+tyh92RJE5RlxkG8MM6FO9?=
 =?us-ascii?Q?wxyzzGnxulHqCLXrkIlib/BobHmQHCoigbSehBqF5Ia34rD8mi5NkK61mx7D?=
 =?us-ascii?Q?2M1t2CEfcw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dadb795-6c8b-4c68-05f7-08d9f0a92ac6
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:32:41.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Me24KzcBhWp38VeMynllswHcZ8tCsvZaDjQplznCWjHY+yY8aByrH8WqmcK4MXZo0ihklt7EuS3vDVsnDL+njdFfhuj9sd1KeWWH0VDFo2Tz5npkuPkrIlOOgctrxv8o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6201
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> >
> > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > >
> > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > >
> > > > > > BUG: arch topology borken
> > > > > >      the CLS domain not a subset of the MC domain
> > > > > >
> > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > removed entirely as redundant.
> > > > > >
> > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > CONFIG_SCHED_MC were disabled.
> > > > > >
> > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > >
> > > > > > For CPU0:
> > > > > >
> > > > > > With CLS:
> > > > > > CLS  [0-1]
> > > > > > DIE  [0-79]
> > > > > > NUMA [0-159]
> > > > > >
> > > > > > Without CLS:
> > > > > > DIE  [0-79]
> > > > > > NUMA [0-159]
> > > > > >
> > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > >
> > > > > Hi Darrent,
> > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > for each cpu?
> > > > >
> > > > > > ---
> > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > >  1 file changed, 32 insertions(+)
> > > > > >
> > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > >         }
> > > > > >  }
> > > > > >
> > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > +#endif
> > > > > > +
> > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > +#endif
> > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > +       { NULL, },
> > > > > > +};
> > > > > > +
> > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > >  {
> > > > > >         const struct cpu_operations *ops;
> > > > > > +       bool use_no_mc_topology = true;
> > > > > >         int err;
> > > > > >         unsigned int cpu;
> > > > > >         unsigned int this_cpu;
> > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > >
> > > > > >                 set_cpu_present(cpu, true);
> > > > > >                 numa_store_cpu_info(cpu);
> > > > > > +
> > > > > > +               /*
> > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > +                */
> > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > +                       use_no_mc_topology = false;
> > > > >
> > > > > This seems to be wrong? If you have 5 cpus,
> > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > need to remove MC, but for cpu1-4, you will need
> > > > > CLS and MC both?
> > > >
> > > > What is the *current* behaviour on such a system?
> > > >
> > >
> > > As I understand it, any system that uses the default topology which has
> > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > will behave as described above by printing the following for each CPU
> > > matching this criteria:
> > >
> > >   BUG: arch topology borken
> > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > >
> > > And then extend the MC domain cpumask to match that of the child and continue
> > > on.
> > >
> > > That would still be the behavior for this type of system after this
> > > patch is applied.
> >
> > That's what I thought, but in that case applying your patch is a net
> > improvement: systems either get current or better behaviour.
> 
> CLUSTER level is normally defined as a intermediate group of the MC
> level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> flag
> 
> In the case of Ampere altra, they consider that CPUA have a CLUSTER
> level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> not disappeared Looks like there is a mismatch in topology description

Hi Vincent,

Agree. Where do you think this mismatch exists?

I'd describe this as a mismatch between the default assumptions of
the sched domains construction code (that SD_SHARE_PKG_RESOURCES implies
a shared cpu-side cache) and SoCs without a shared cpu-side cache. This
is encoded in properties of the MC level and the requirement that child
domains be a subset of the parent domain cpumask.

The MC-less topology addresses this in a consistent way with other
architectures using the provided API for non-default topologies without
changing these fundamental assumptions and without changing the final
resulting topology which is correct and matches the topology supplied in
the ACPI PPTT.

-- 
Darren Hart
Ampere Computing / OS and Kernel
