Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D064C18E5
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 17:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiBWQkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 11:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiBWQkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 11:40:00 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2103.outbound.protection.outlook.com [40.107.93.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92EE5838B;
        Wed, 23 Feb 2022 08:39:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvG/e1sH+ghO/ySP2G2Y0WUnDgq/A+sY4wW++Umt1roOuSIVAHJpg6RuLr2MXC9HXIQXO+tfP8uIDDynJClCYuj3koYwlwJf0QimgusUVsXxeCnRHmX8gAwR10BoqgUFJ/yzfRXos6kvnr3/c4sh06CjywnW9tgzKAVvo6jbzVXztDUr0eUWOypP9ttbq63Ny4bSGO2LjRvt7lhnjTw166DRkBSmgSOY4Kxa96CjIUO5ex4Hdn2Ox+Bku6beGMDOvsPc64ffaJzDg3F/BbJqDK2AQubfIxJ8ocEAyFie+fPn12txIIdQA/baXoUG7L+VYUi6ziGHyuO13S4ckqaZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcwLRlJh44ruI+dzMPy1Se2mqxBSPso6Y+ibx42bMiA=;
 b=l3tH3qDNwCwVtqO7P0Fprd3SwNShu5zUj3iBQ51Ys1T/P25bB8JRCLrsYKW3ulubUEed1xpIMyvFbvKF3PyrTe+alRZYUXQVFSRf4CqO2kzc5zGAwTKHGTWhnN7616T2hoC6WJTdj1w5HVxvh93d105dP6QhRbCq1eow9iqB1a/JI+gonVMQKwbIXuBxY12OXMuoJMsLlgtjMsb7e/j4ZxQAYzt88knBt3mFKtMAJlRwiiZUdm0jIHQehAPgKnhoRGJJkwZ66iWd0LPDYNhMiNFYhkPlH8qyNPoMCLLUaXRmVRLQRuuTNyCfOWqrTnQzDE9qOBSwK1i5MjMHigmgqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcwLRlJh44ruI+dzMPy1Se2mqxBSPso6Y+ibx42bMiA=;
 b=qHO9NQkUSolOf+f8ttgAksvgWBO9qwB2tASl5qzQe9exdje2XS5OCvw0c+3XZIUGHz94IMIKzZPEEVObABwjzmceWAW1fRvU8btJn/Nhjhm7VGpwaF3oARP99UMicxmg8BJyB+guGVTZGo+mDpc//+Poe70RzsUc/tpMCrizxQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 CO2PR01MB2118.prod.exchangelabs.com (2603:10b6:102:a::13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Wed, 23 Feb 2022 16:39:29 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 16:39:29 +0000
Date:   Wed, 23 Feb 2022 08:39:26 -0800
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
Message-ID: <YhZjPviteu4v8Fdf@fedora>
References: <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <YgwHhxy/uGafQsak@fedora>
 <CAKfTPtAR2+bY8QpyaCCJfezsVkB62n8XZjL9c5_mPO3iyDnp4w@mail.gmail.com>
 <Yg0lULy5TmHKIHFv@fedora>
 <CAKfTPtB1Vt75ciX_V=8T3e5fgW-X7ybRk6VZvy4uXzjazjx9ZA@mail.gmail.com>
 <YhWlDUzFeG0d7z6C@fedora>
 <CAKfTPtAjnRGc9c1Ni0ru6Xz9wKLPoBY4wdPkN0uFBzR-_iurPg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAjnRGc9c1Ni0ru6Xz9wKLPoBY4wdPkN0uFBzR-_iurPg@mail.gmail.com>
X-ClientProxiedBy: CH2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:610:52::28) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2335ccc-479c-4ea7-2869-08d9f6eb0f0a
X-MS-TrafficTypeDiagnostic: CO2PR01MB2118:EE_
X-Microsoft-Antispam-PRVS: <CO2PR01MB21188DF65F5FB72F84609DC7F73C9@CO2PR01MB2118.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEyPBs5NuzoqQwR960gr/xfnKiiPhokows5g+tZ5yZs0yYKcCtJ3HKeqJVKkJ5hvO9AzU+Ackm3/adVq40PdQXjjHaq2Bfsoajl7Oh/enQteUsJ9sUgQ/QWssAZoy9SeO7kY+EcA2Yru+MoIwbR/iLpbCUoL7uQ94416S6U/zvToVzLv4+skpLtF9ZUYuhlY9jC2LSn13G6y8cPiunHE7UDqrd0mKjkTvaf+zDvY9Lxvc97SxF97SL6N6f4bE/qefsMaiUHFmga61W9RI1WpLpVbMyxAGcKhYDIyuNq0jhvm4Wf5xDKU2JHBo0i6YRFIkykGA7O//qEB4BI8DqN+GSwuxQ6mL0n5GivQ1CgOciPOvScYlSKe5YHzo9SBaqt8v16kcbkvlEA0rnJLUxV+u1xLuqdvzF2PwNwfr4jJi7zHK/G85tZ5YKOuXfz0zKjttL01t5yJs0DhJHioaossLseUm8fcguBPTYAoPNk/k8y3R4jH1GdlpaOboHxPhMUabIcpW9VccfEdyhxCkxb7mHfXURtHs3XVOtXfPKMvhVaFbSFxaWwORtsr/H3SLb4YYGXPiSHU/jY556FouVKYpj9TCAcTOQEa7Tuo4HrMfN/XIXqs1ao5duRQkPnF/0h4vkGoq0HhB2fEANxkCvPgNpzl4TQ5WTJW4WvXnOglp3i6svjAasEtK/HSdfd2CpZOhLMdmAhiCL+yUuEOBKw4Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(2906002)(33716001)(52116002)(9686003)(6486002)(6506007)(6512007)(6666004)(5660300002)(8936002)(26005)(86362001)(186003)(8676002)(83380400001)(54906003)(316002)(508600001)(66946007)(38350700002)(4326008)(66556008)(66476007)(38100700002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HKlF59XE3twX0pTi3/5X+8/zaitpX25EFmc0R06KwtxXvi/wJ9YqHQES+3nk?=
 =?us-ascii?Q?v+bozIIR1IYlig7vadOG0K03qdDhHomYRUo30r5rsrYs6X69A0hF7ok0jrMQ?=
 =?us-ascii?Q?C/q5ZtXNMhU7H70rn+2NHgGwQEp405SV3e+3xC100yVGBxd9oYQV/XP3YX2C?=
 =?us-ascii?Q?buTBVZLFBNLfPi79LlqTNU7PfBNeeeMEf2rSQtdj6B+e827hRoachlXsHol5?=
 =?us-ascii?Q?SfpeyCLrOsVZsK6GGz4hQnPYYfU81HOnf3QcZn7cSK0jHNX13BXbHfBTR+Hx?=
 =?us-ascii?Q?3jhnvH/WDbRVLPikKNOImakcjlMVzYWOPLFTItHek1vdrnTEoSd5msOmq6+e?=
 =?us-ascii?Q?7NkOH3W5I1tEKm3fA/52KMY8oUltbwYUeZUsJTWtnyt/U4XBJVm/tiIsztYT?=
 =?us-ascii?Q?ahK1lbbFAUT7Yx3xiJX4l0y5vCzscshbB44YEFU3f0D855eK63mWfcqk4AHO?=
 =?us-ascii?Q?FcP/mOXoF9irzSUHwFlOGF3hnUnIs5LiXhlmVANTguPq2MjkoFPGTJZRuywW?=
 =?us-ascii?Q?9CA+sPymQ0CYDC1c+GriXJhpEetw5pH43pmUTaDcUyxg+7bfmo4DB1skMSCi?=
 =?us-ascii?Q?S3rejp6lxOLxPVNNMGK+f84urT5PbjTKUcT5npmlurAlSDOlPxvKjjT3n/nN?=
 =?us-ascii?Q?7AfaJEN0W0DYGgVh2n7ztSqTU6iPLt1RS8tsA1NYhjdEVcoPPPnF+nFYslmJ?=
 =?us-ascii?Q?ZafM/Ic7ozDFVEmbEK1undu8N1zEXj6olWWG0IJYmWtHIzJm5FNXtKTTFJE9?=
 =?us-ascii?Q?6X1Qj3tVZxnO66nQlTA0VVC/XTMpsCXDM9UFb1GRPrqtJGzex+UDohiaPtcI?=
 =?us-ascii?Q?x2tRA3Ga1MTFd1mNb0iD843KeuUCsgpL1i0xSLmXvKH1sFIBZPkcafdtCNv8?=
 =?us-ascii?Q?BbxN/cS3YSlgjNWDp3r8i/6hdZrqwabN+FslF+GsL/E9+O07/Ck3hTLvj7G2?=
 =?us-ascii?Q?1qcgfK9E9ll2gyCwT9sEHN+1J1z2sowp0TCM2qHjlZg5sRLy3biNhH5D3h7W?=
 =?us-ascii?Q?H78F7p9kzFPhcp4s0THwJtkKHHtJDGXpn++glQYCnvMVJ+XUU154KK0UHkwi?=
 =?us-ascii?Q?yf9grp6d5dKFiS5pnE3Hja2BB0q+k0exqFY5kSEz4a8lqwuIgybiAK6TX2oj?=
 =?us-ascii?Q?8k9xxYVu47WPwSvTC3yMKhVETHvcMv3+t44F9sR1b36kGRH8zeJXOTqjOfNU?=
 =?us-ascii?Q?/sC0DjTcGM86uur6pmRFiV3pBGit2HGE8G9dXyRxnQIdrl9eYeWouYYJyr+J?=
 =?us-ascii?Q?P5IZhwPKb5H2TctjzCL7dyZAukENb2hqBxaTlownZt66vCbZAzr+abXUHRRw?=
 =?us-ascii?Q?fQH1dMKI8Qsy1+G60yE6T6tyfSjgzQ/GfrucathlMJzNmiML1VuzVIJCkL50?=
 =?us-ascii?Q?z7rTj4inOFK4b08IoUsLe5Iw+1g7ycs19deUmsugUeMCqUeO74Vjm+49OR6u?=
 =?us-ascii?Q?+pvzIlaHZwEx9I29u9J/HKgHzSlGvjk9grZEe36ocqCz1mwvCmk96EDkpAfN?=
 =?us-ascii?Q?7UVFsWLJiyNE8SMLXaEH8oWukcrgvvR+Z0gcO27CaYV1vC9bW9KQJcPL88wh?=
 =?us-ascii?Q?H5P15KxyiqMY3gD+7GEBbeOlMtH4RfUVASTWWFlE1O7bgWEFluf4KMCMl5PE?=
 =?us-ascii?Q?Wi12SJts/WhiATyXtPdvfCdgOk9YGFGXUwryKPFjQHJ/n/hEHDdEsqQGn5Ih?=
 =?us-ascii?Q?1vOIoruiFeCH8m9Uq8D7A32CJvk55nH7lXch17q1VsTPXZ3+iGWK9R5sxbum?=
 =?us-ascii?Q?zIXePR9Jdw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2335ccc-479c-4ea7-2869-08d9f6eb0f0a
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:39:29.0185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKd8xSvKrvwi1+1ZK5YRy0RXQoLOglZZ3KzG8xoHGjy3QbLMRArVcnaTO11M9Or1Nh6RRM5IH1aOhnx8e8q/QFnG7xKxzl9IRfETPxlm6R7zjNeRljlYOz3IabXYOA5T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR01MB2118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 09:19:17AM +0100, Vincent Guittot wrote:

...

> > > AFAICT, this CLUSTER level is only supported by ACPI. In
> > > parse_acpi_topology() you should be able to know if cluster level is
> > > above or below the level returned by acpi_find_last_cache_level() and
> > > set the correct topology table accordingly
> > >
> >
> > Thanks Vincent,
> >
> > This made sense as a place to start to me. The more I dug into the ACPI PPTT
> > code, I kept running into conflicts with the API which would require extending
> > it in ways that seems contrary to its intent. e.g. the exposed API uses Kernel
> > logical CPUs rather than the topology ids (needed for working with processor
> > containers). The cpu_topology masks haven't been populated yet, and
> > acpi_find_last_cache_level is decoupled from the CPU topology level. So what
> > we're really testing for is if the cluster cpumask is a subset of the coregroup
> > cpumask or not, and it made the most sense to me to keep that in smp.c after the
> > cpumasks have been updated and stored.
> 
> I'm not sure why you want to compare cpumask when you can directly
> compare topology level which is exactly what we are looking for in
> order to correctly order the scheduler topology. I was expecting
> something like the below to be enough. acpi_find_cluster_level() needs
> to be created and should be similar to
> find_acpi_cpu_topology_cluster() but return level instead of id. The
> main advantage is that everything is contained in topology.c which
> makes sense as we are playing with topology

Hi Vincent,

This was my thinking as well before I dug into the acpi pptt interfaces.

The cpu topology levels and the cache levels are independent and assuming I've
not misunderstood the implementation, acpi_find_cache_level() returns the
highest *cache* level described in the PPTT for a given CPU.

For the Ampere Altra, for example:

CPU Topo  1       System
 Level    2         Package
   |      3           Cluster
   |      4             Processor --- L1 I Cache \____ L2 U Cache -x
  \/                              --- L1 D Cache /

          4             Processor --- L1 I Cache \____ L2 U Cache -x
                                  --- L1 D Cache /

                  Cache Level ---->    1                2

acpi_find_cache_level() returns "2" for any logical cpu, but this doesn't tell
us anything about the CPU topology level across which this cache is shared.

This is what drove me out of topology.c and up into smp.c after the various
topologies are populated and comparing masks. I'll spend a bit more time before
sending a cpumask implementation to see if there is a better point to do this
where the cpu topology level with shared cache is more readily available.

> 
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> index 9ab78ad826e2..4dac0491b7e3 100644
> --- a/arch/arm64/kernel/topology.c
> +++ b/arch/arm64/kernel/topology.c
> @@ -84,6 +84,7 @@ static bool __init acpi_cpu_is_threaded(int cpu)
>  int __init parse_acpi_topology(void)
>  {
>         int cpu, topology_id;
> +       bool default_cluster_topology = true;
> 
>         if (acpi_disabled)
>                 return 0;
> @@ -119,8 +120,16 @@ int __init parse_acpi_topology(void)
>                         if (cache_id > 0)
>                                 cpu_topology[cpu].llc_id = cache_id;
>                 }
> +
> +               if (default_cluster_topology &&
> +                   (i < acpi_find_cluster_level(cpu))) {

Per above, from what I understand, this is comparing cpu topology levels with
cache levels, which are independent from each other.

> +                       default_cluster_topology = false;
> +               }
>         }
> 
> +       if (!default_cluster_topology)
> +               set_sched_topology(arm64_no_mc_topology);
> +
>         return 0;
>  }

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
