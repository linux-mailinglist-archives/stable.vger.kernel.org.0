Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901554B756D
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbiBOUGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 15:06:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243958AbiBOUF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 15:05:59 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879209F6D1;
        Tue, 15 Feb 2022 12:05:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYLYwyhrrPNWIf4phRB7RNxPfmXDlFyaCQFl20UVZO9YbzGVYmspqX8WmTG1q8QO2EjNgm+17dViGyYpNcEHwqH5QkkWhcBct5nIFFMDcyESdKoB6/Txcnj7f3p/SO4lU0OhLAf3w1nctTBmrct5wHMdSFyilG5okiVjvs/leexrBvk89SLNMv+iB8YoavlxKJqiZJJIdyJ6vUkEwp9YL8QgGpxYmJyyAZzqPLwYF5uU+NJBu6XbFgP/2Wuejd8UkmBvwYEOHwU5ciX384vcNLoiyfjWJro0BTbMZFD8GaDXQp/mT/zXNf0B24DGnmxf9Rg63IyT7Nbd+DrUimtoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcpNxPdd09uhXQtlJn1cZlZeWJRQA/vBEYxsoe57aV0=;
 b=A5wfn5llSGfEQwN5L3RTqt1d7bLPp6F7YDmzQgQkzsBjV33Jer0F13XWVrFgkCTT0p93RZqkt0QsIVCcddsRhqfFCfxj1fmeJPBCiE9iJrwqu6cEJmOUCU4e3s+yKI1fZ3YjOO9WENxZ8b6o6/zYr8e7eNh/NBECcGbBFOg8YK9Ir3P686ql0x1z6uPXI5s6RqqP8cHz49hMiA5SL8ogrocyKXmF/GvL6t8d6m/XB2LkHvGZpSi7RAPT5G3bLITNWimrcVV1wHqIa7hZ/JzhY/6Qf99CkvBJ6xtWWHD3qcZXsuwGsvc7skF6MTK91fkCGe0atldB2Kg+wJwSYEQJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcpNxPdd09uhXQtlJn1cZlZeWJRQA/vBEYxsoe57aV0=;
 b=NHGaef60yddpkgJb0K7uem4k20EV+C//3IwXjLv/29SVVLGEX52lTOuaLwixEaWK0ZwTC6fUL2gF5yzz/qxLmByy2PfQLT6IrTiaja4BEXt0KMDGdIumVMvSAt0ND7asG/24LfMrSUZ5sqknQwCUmggNEUQBS1NhgjAH4s+6Zio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BL0PR01MB4628.prod.exchangelabs.com (2603:10b6:208:74::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.18; Tue, 15 Feb 2022 20:05:30 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 20:05:29 +0000
Date:   Tue, 15 Feb 2022 12:05:27 -0800
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
Message-ID: <YgwHhxy/uGafQsak@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
X-ClientProxiedBy: CH0PR03CA0393.namprd03.prod.outlook.com
 (2603:10b6:610:11b::21) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e1077e7-9103-4841-d942-08d9f0be8370
X-MS-TrafficTypeDiagnostic: BL0PR01MB4628:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB46281BCAFD70EFE463AC8911F7349@BL0PR01MB4628.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utAp7N+F0fQbxHE01JGkkvtqPE/v7iUe+J+x6V2nfeA4aIs/7A70EL8j2Cyiqdk+OdBxtMC8H41RbIZzQ6cFuoQ9gMaSt7VxGUN/MGVwippH8tZS6rB65LvR2RudT7AVjp21J4LmQauZLaxejw90q0AyZKhuKI+4LbCVX5IazmIgWw9KoK3y4m6FF8UdW91KM1WTZiV62few4a5cmF+yI3FPWMw8aqycpZmF2ec73lmqfF4222xf2LnE7MTyJQ1q1fWB3I+mnYOPEnoCpjYTJi05FWWDHqkZ3tmjZvHr+vz/raQbU/php4X5eIrHsDf5WgPCpt1pxbfLWDYdPQQbfsVK5NgznPNS67+zPR98VTzlxWw/nx4b7QJiVxgzIDPT8fYpx4qHp64ldENmy8v3OtwGiYV7XgqSIlFs02Eu8BgR8v+KVQJIA+H4jSpLlcStXH2/uYRK28IekJvBm3V/w+ax0TfN1/C07fYgJnF4Qhh22pWl/FrYkvDjXXPzdMp3Bsq2Z3klHuS7cocXFb4WnBHLcbIso3dSX47xavpKgS9SHFAoFNzwwpyjtrhe48EcX6VggKNsX4vZgP36g+MPGiHmM/dCP6AaILtCRYis6VN/FZdqoKzWfKnJfsinMfDfCShI4NvyfOkYxjbBFFV0OeZXO8/MHBefLCZ0AS+XF+JzpeE1y1USlDeItOEaIxZtHURm9BCGJodXOKbnWCgcIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(5660300002)(66556008)(66946007)(86362001)(8676002)(38350700002)(38100700002)(8936002)(2906002)(66476007)(186003)(26005)(4326008)(6916009)(6506007)(33716001)(52116002)(316002)(508600001)(9686003)(6512007)(83380400001)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QJ62G3ZTzgslSCF/WXi6MjIgU7BRBqlxY5ft5KA5IZ0RvFIsFsU7hdhD8sUI?=
 =?us-ascii?Q?kpvd1sXlViC82zZVbk/ZDeyyZ8s1n6P03tAts1TPOw2c3D3y+5rEjQrccuzc?=
 =?us-ascii?Q?T6tQtZ0drAMQ9OOIBkJpWGAEiFex0/Yth+ZygtdL37GvPFsmx2n0XxVybZxT?=
 =?us-ascii?Q?Vvk1W4AEQ6itOriNXcas6z1CMROM+w6TJjUfzlNRXWGInz/AF+sfxoeveJhI?=
 =?us-ascii?Q?cUQ7yNTSi1woV38inkgbYjx0A9q8xAsLcKqs+zqJ17fB0XTlIXdv4JVJjV8y?=
 =?us-ascii?Q?hLxSBniSmESqM7ON1F1wuDE4hmlNrIrOhcHDgrzxLV9FmqkPvXPNme4CDInF?=
 =?us-ascii?Q?yogDJUJ+0LGJhWfkoNh3uUyiT9jsRpuh/H5YEFmKGKxc8HeXUw9tMjGkhuwj?=
 =?us-ascii?Q?El5Bl6uxcwlf4UvQV/8Lf2BKPtO5R+k3JjsotS9rCPhUOixvJ8gf8nyfWRpP?=
 =?us-ascii?Q?Eh+2mQ0ZNM11o7WNisVg6vffn1id7KLVCcfho7UtKzhU/B8+6t6+HQYBKdeC?=
 =?us-ascii?Q?Nv9Z98GmITmTYTt4pZbgrIZeoDV1XInMpGYOL3vceKE+P9SYJUREFD/m8KOz?=
 =?us-ascii?Q?7UxnCdREhp6nj3a9RW+rxICG8yD7nVa+e8lMvfKnH52pubCDQXHMR6Q8z2A6?=
 =?us-ascii?Q?Eiz+9NfmrIvLCd2WTfJgSP8aGl91LB89huDPN2xdM7YfTT7mSZn5jDTGSH0V?=
 =?us-ascii?Q?GKbc6dq2Y36tb3kxoNQbt93WKQb6+E3/g2rDu1q5IXlwjTR5It7Izk3ZBft8?=
 =?us-ascii?Q?gicerUjaGxL7n170txQcNciyIDGbq4zNAw5+IP5Z1GP5MqlNmV6YutE/EZe3?=
 =?us-ascii?Q?kTzD5W3w7UDxtiNOa6suMOaxDPE/gKzZ+EnXUV8BL0UHY+B07STA9W/GuZPF?=
 =?us-ascii?Q?kxSlN5MwQkyQy3qNkC1CDQpeRRwBcoUd4OAjoPctbHcQ9zSVaEPx2iAOaK6l?=
 =?us-ascii?Q?cPDu44l4VsnFiH3ojxyRENxvyKVl7FCz6fRdimxrGvxGmp1cOSoYHykl/p5C?=
 =?us-ascii?Q?wbX0JZyWza2YVIUXOxWylatYXtT3kDnOObwx4YTsNX2nVSsODddYqtLUO9sA?=
 =?us-ascii?Q?DJCHrT8xr24N8gkMEcze+1FuxUzEW6krW+kLZDCyDHgVvrGbf/0RFeHbEY54?=
 =?us-ascii?Q?6SCUZoZrzg6LpEIq4c7G+IeW2yLvcleX9nxCTA79BgISwS56UtPj5Hvu3tQe?=
 =?us-ascii?Q?1YHTq2kEvSwbnGJkUgvsRtuhgQbEX7A5fiBZoduV/uSS1aCyt4MalwLGoTOm?=
 =?us-ascii?Q?w6+TRBqLo4GikV2GlaXugp4IU1MEeBT/6dbLe9CBGGV61Ow6qo0S7CwOz78O?=
 =?us-ascii?Q?6cPr8frKpDGYZcSohonWYXXUf4fuhD205fk2Su4VB7wvXjDMUy8cm4ykbJYy?=
 =?us-ascii?Q?Lrtx0BjjuhltYB8tCzQApaeoiZXH9yIDM+l2iSG/Wv0zr1/XP1gi5lc7vVqm?=
 =?us-ascii?Q?OgsYxoxHWrjfWzJJcVOGPFfAOkkpvo1NkAUKuh/HMmT7hh2jobiBESUhgcqe?=
 =?us-ascii?Q?vbgZTB4jiR1BPPN598KlR0p0P1fvLKR3bjnHJERJ7U3y/aWYR5b/0CGwOSBl?=
 =?us-ascii?Q?OwDarAHC9hBRGTJvSG6KI9DtGGmMcOO/s8+H62HM3xsl0/pW/YPO4HswQJV9?=
 =?us-ascii?Q?LOz1nXqtsEz8HYdjCTeKazUYDfR3/sCuoII3mYYPViAIlR6pWB1NXyD2xYPi?=
 =?us-ascii?Q?VHFaozCK7iyDfFDM0LjRDfdUmb4hr+9d2Rz/C8j54/r4paZsAwXQH+zMSgPR?=
 =?us-ascii?Q?gENHCeV+OQ=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1077e7-9103-4841-d942-08d9f0be8370
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 20:05:29.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncfYUu0P+AwlqlUHK4Jn7xEVPiRVkl+L03MjCyRICsxv0bTOwaiVU7I+NGbdkIWj2AQE9FSid4BQ27CcV6vTTjLpDAKAvy1MxxFcIWrDqcTosLNsNK7Qz/EF0Zvx7SRa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4628
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 07:19:45PM +0100, Vincent Guittot wrote:
> On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > >
> > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > >
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > >
> > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > >
> > > > > > > > BUG: arch topology borken
> > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > >
> > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > removed entirely as redundant.
> > > > > > > >
> > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > >
> > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > >
> > > > > > > > For CPU0:
> > > > > > > >
> > > > > > > > With CLS:
> > > > > > > > CLS  [0-1]
> > > > > > > > DIE  [0-79]
> > > > > > > > NUMA [0-159]
> > > > > > > >
> > > > > > > > Without CLS:
> > > > > > > > DIE  [0-79]
> > > > > > > > NUMA [0-159]
> > > > > > > >
> > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > >
> > > > > > > Hi Darrent,
> > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > for each cpu?
> > > > > > >
> > > > > > > > ---
> > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > >         }
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > +#endif
> > > > > > > > +
> > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > +#endif
> > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > +       { NULL, },
> > > > > > > > +};
> > > > > > > > +
> > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > >  {
> > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > >         int err;
> > > > > > > >         unsigned int cpu;
> > > > > > > >         unsigned int this_cpu;
> > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > >
> > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > +
> > > > > > > > +               /*
> > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > +                */
> > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > +                       use_no_mc_topology = false;
> > > > > > >
> > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > CLS and MC both?
> > > > > >
> > > > > > What is the *current* behaviour on such a system?
> > > > > >
> > > > >
> > > > > As I understand it, any system that uses the default topology which has
> > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > will behave as described above by printing the following for each CPU
> > > > > matching this criteria:
> > > > >
> > > > >   BUG: arch topology borken
> > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > >
> > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > on.
> > > > >
> > > > > That would still be the behavior for this type of system after this
> > > > > patch is applied.
> > > >
> > > > That's what I thought, but in that case applying your patch is a net
> > > > improvement: systems either get current or better behaviour.
> > >
> > > CLUSTER level is normally defined as a intermediate group of the MC
> > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > flag
> > >
> > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > not disappeared Looks like there is a mismatch in topology description
> >
> > Hi Vincent,
> >
> > Agree. Where do you think this mismatch exists?
> 
> I think that the problem comes from that the default topology order is
> assumed to be :
> SMT
> CLUSTER shares pkg resources i.e. cache
> MC
> DIE
> NUMA
> 
> but in your case, you want a topology order like :
> SMT
> MC
> CLUSTER shares SCU
> DIE
> NUMA

Given the fairly loose definition of some of these domains and the
freedom to adjust flags with custom topologies, I think it's difficult
to say it needs to be this or that. As you point out, this stems from an
assumption in the default topology, so eliding the MC level within the
current set of abstractions for a very targeted topology still seems
reasonable to address the BUG in the very near term in a contained way.

> 
> IIUC, the cluster is defined as the 2nd (no SMT) or 3rd (SMT) level in
> the PPTT table whereas the MC level is defined as the number of cache
> levels. So i would say that you should compare the level to know the
> ordering
> 
> Then, there is another point:
> In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
> which is used to define some scheduler internal variable like
> sd_llc(sched domain last level of cache) which allows fast task
> migration between this cpus in this level at wakeup. In your case the
> sd_llc should not be the cluster but the MC with only one CPU. But I
> would not be surprised that most of perf improvement comes from this
> sd_llc wrongly set to cluster instead of the single CPU

Agree that we currently have an imperfect representation of SoCs without
a shared CPU-side cache. Within this imperfect abstraction, it seems
valid to consider the SCU as a valid shared resource to be described by
SD_SHARE_PKG_RESOURCES, and as you say, that does result in an overall
performance improvement.

Also agree that it is worth working toward a better abstraction. On the
way to that, I think it makes sense to avoid BUG'ing on the current
topology which is a reasonable one given the current abstraction.

Thanks,

> 
> 
> >
> > I'd describe this as a mismatch between the default assumptions of
> > the sched domains construction code (that SD_SHARE_PKG_RESOURCES implies
> > a shared cpu-side cache) and SoCs without a shared cpu-side cache. This
> > is encoded in properties of the MC level and the requirement that child
> > domains be a subset of the parent domain cpumask.
> >
> > The MC-less topology addresses this in a consistent way with other
> > architectures using the provided API for non-default topologies without
> > changing these fundamental assumptions and without changing the final
> > resulting topology which is correct and matches the topology supplied in
> > the ACPI PPTT.
> 
> 
> >
> > --
> > Darren Hart
> > Ampere Computing / OS and Kernel

-- 
Darren Hart
Ampere Computing / OS and Kernel
