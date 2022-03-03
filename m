Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2B4CC2E9
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 17:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiCCQg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 11:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiCCQg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 11:36:26 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2096.outbound.protection.outlook.com [40.107.244.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC21319D628;
        Thu,  3 Mar 2022 08:35:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCfR9u1q4+h68uvBIhxlPpV2mqh/rrkNG2848GzMxzHmW4GWJ2FRsRM9Bc1TJ6ZKbkFSPBW+ZdBLddbaWKMpUKs5H3WNWEk/MGYhbmyXZ8wM2hqfbIkO+XT2iNHBptSowniRHKVNayVqxEZf8PB34HeZFdcYzkuLTefg/FpffEYROnAqQgDfaqSeYd56rOEfW/wSLcVrVQCn+X+2N2jb72DtSHuvou5GGda6HII0LIaruzJuXcqw0WagUtVtvVCSC59nbtGHR4TMTB5/+40+a9ax3Ol5O8YX0E/Q/T/LveZAAQuGJ4gPEZgliNIPXXhQcVgJUb9DBsSB4N0w82Dp1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNSY71Hsdy+MO72gTRNT11ur3A+CaDvRuyuyxD9jass=;
 b=fJBFxKGObJWxxexdv2vt2oiF4U32iIZeaBCeyON2ee2tP7JyPhY6xb5sF0PqmIa97QgFTnLY2549soMm3chQvuAmOgVoiL8DlwdHy+5xnpBPQWZnqoa1PKEotjLWJYOZNpckxOGvjA6HLalZemduK+ljklPU0BAKd/bN0KwYtYb34b7oqCsi1w/BJSmvZJpd3cgatmmHkh8J+7dEYhD6lxz36SQESsjJE8oKB4tSq6wMv7dMZmB9rt0RUE1YTeDIm03a80w7rBj1J6v3vv1RsEUEf1JgzKVRfHQyt+PvnPmqgdG0AgozFhpolhK1+42Wx5dN6OueCeEIjQF576T22g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNSY71Hsdy+MO72gTRNT11ur3A+CaDvRuyuyxD9jass=;
 b=Q+VJII+eCdtKaLEQRJ/9Tw0ZsH5d7CnRyB6NfzU3gr0U7lfbn8t1r5tRnnoPWcE0smGhSJ34EqDryoyOPXPza+zzv6ZjeayZJVpzXsaZgVccQnRuj6YjYgwxNkTR4HxDrzWLUx8orgK2w7wD2tREMFKXY8/vIGdtddzSanTV1o0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SN2PR01MB1984.prod.exchangelabs.com (2603:10b6:804:7::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Thu, 3 Mar 2022 16:35:37 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.5017.029; Thu, 3 Mar 2022
 16:35:37 +0000
Date:   Thu, 3 Mar 2022 08:35:35 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Barry Song <21cnbao@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <YiDuV8YkaWGNgky7@fedora>
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
 <YiAlfGuRXWVnOmyF@fedora>
 <CAGsJ_4y8MkQhAZ9c9yz_UHee7MCZrtv3aui=Luq-ZOBeAsGbGQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4y8MkQhAZ9c9yz_UHee7MCZrtv3aui=Luq-ZOBeAsGbGQ@mail.gmail.com>
X-ClientProxiedBy: CY4PR1101CA0018.namprd11.prod.outlook.com
 (2603:10b6:910:15::28) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03996b40-e3e2-4ca4-5755-08d9fd33d906
X-MS-TrafficTypeDiagnostic: SN2PR01MB1984:EE_
X-Microsoft-Antispam-PRVS: <SN2PR01MB1984B40ABCB20745ECF57F4FF7049@SN2PR01MB1984.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGnRMg4e5sAsikn+ky2GvkF6Sl+bWaOEl9/dezaDJPOthrsL1RXNuc2+O+lD7LE3LXuHk/PMgg0rvSUU4ErWOLiUBl3Glz6Vp6F5fh54OeRTjg+nHXTitvOGP4jipshkfwYuJZhxgFIqLjyki2+s8oCy7HGLT93c66eKQR2BgmzQ4nz/3hXSpl0MqcREEH1KAI69s/NT7ZfR61z7t4UYcPuJafffvy2IePguzu2akA4q7BzplqXlJd7BC2eGBYu0FKLWGH4cqo0E938XsX+FaijrAdbiiWS9v1lwzRbNhU8HalYElzuy21Bz7iGr12XEP/81MiOGFNO+QXReXCAzUu4dec8qOyYwc6YSTVlcAQKZB05IleKBY8dIk1E3KmMGbnpfUbY4YJFAkaivaczxmmWpBwKWbSy90ZZq3KIcwy0TCxU9c7tdNWBjLbUmzadMlsnQyvEuEmJKNz9mfD6yArN7lTr8WAuJb7IpGzPpEe0W6SCMpcgHs4jdu33hheTS4MoZCK7A7pARbPEiIAqbwX+pN0Xl7U0+DNDyYJEgi9mJ7GTWlT3bQ/dV6CHWgbWIRD/G33t9QYfOyAS+c85qovO8QMO43Lh09JW5FoZ51iYGEjjPJzADvLtLP7WAhLE6KaKAckAW5K0t+62eLTm0r8DcIInBt+eDdw9waPapDyiLODsL7PYoyKQ8jp8UhpnQKMDy9+1nEKwGZeXL/KkmIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(186003)(6486002)(53546011)(52116002)(6506007)(86362001)(26005)(6512007)(9686003)(508600001)(38350700002)(38100700002)(83380400001)(66946007)(7416002)(66556008)(8936002)(66476007)(2906002)(316002)(8676002)(4326008)(54906003)(110136005)(33716001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PUxdgYqOCecondAOk8CdopdH8CzRLpo3q8f+Eu8Ja0/caO5VrzbmTY6rO2F?=
 =?us-ascii?Q?2AfV0q6qcm90bmulVZ6n8YSPoTNv3WiScx40EUKhvM8m98d4RiLD6UyFiSyq?=
 =?us-ascii?Q?fPfgjeC8tiVwQSS4qSjV+l+3lETwIykJuWwdPisaI6j065hTB7PCCexSKyfT?=
 =?us-ascii?Q?2YbWgf10j4lBAIq7uDOGheJb2XWaQEJYX2GJSJXnf18wZj+GKz47PBqpCBDA?=
 =?us-ascii?Q?FrfXmRv5Ii0QOEHokTh4zN9oteWlQuzNCMKCnPwhzM+nQ6n7/G3bmI38wakE?=
 =?us-ascii?Q?VEGGV7TFJ3i0m2lUIzlfjBtCHL5ISxXheaufLFtnqQhWPAxX82vtSo3XVSHs?=
 =?us-ascii?Q?xxw6KiYKJHzqy4G+52m+ZudEZicdtDTY4uIVEt9aEvYW6d9tuqIeA+KNvq9/?=
 =?us-ascii?Q?5GaigNR8oiG4TMncX/uVl4WmGoeG1tjTTYfi6xkX8b5fDuOTuLOz8RvsMw5g?=
 =?us-ascii?Q?+KGsYRhOVAAitaRgqtPvDP2C8lMu1NW7wtM0Z7Sjo9I7pxaDUxSgLU3TFlTq?=
 =?us-ascii?Q?ZTu4SF0My+H/V5Uxpq/1X72yMihc6IMk7RlABhpdhVunhc7RArkPcoOCIHuu?=
 =?us-ascii?Q?9FCJClBeKhueVH3X1/n65odpIVTaA8kfIPJ6wukCvK9+K33xbdfciWpNODwM?=
 =?us-ascii?Q?QIpGaBGv2affnjHBKyMIVCYSzS6p7sIWqFe8anfswl4TQHnd3eewX4H6KFJw?=
 =?us-ascii?Q?uXKce85yXtHWtRWtrAYszUz0QfcZkW1tzpSei0AQ6xmBDNcdNOcVTcMKhLk4?=
 =?us-ascii?Q?NwUi53nahUFs4sm7JKkP6JmXjO5067NlveKCo0iyEXnOC6Zajddh3VupD71r?=
 =?us-ascii?Q?pTH+iFVW8DoZtNi6xOuzAIlYxuDZ4zPprvAHfsgNmfCGBEKFYtkKyGMBAdg2?=
 =?us-ascii?Q?QP9iria/HqHEsrKeGB3Z1ouJn7+6UHIXcuqjpTwS/BEwHHTMFGLJLrwLYJk1?=
 =?us-ascii?Q?xNnqrL1cvqh9zg7uAQ5QyaSV5x6we5lKofDMbpdgZbt0/fW39wRrdYAKQ73O?=
 =?us-ascii?Q?QxmcKd1vQ4u5ykaLNBHLBIuAE4KTv4g+4m5GfLGnexvBnkAyy0HUh/sKW08m?=
 =?us-ascii?Q?91yfG9gC7MUGUwyeIY8CGjaHtNkZRY8CWX7skIzSps6fM9B4Y4CPHke4bxnR?=
 =?us-ascii?Q?YcQTnGo5JAIqGP7uMBPGrOpG//ivtmwuYdUSilZGaCgj840JjCOy8+UspSBI?=
 =?us-ascii?Q?iR+YIzqzUrsPdvoYjwwOCnBHXNf7ONS4Qe1vvKdzUnhYzL7oHwVU4PRPOAqz?=
 =?us-ascii?Q?VgSPhNXy/yuhSKSvZHsXPty8zESoO8DxF2Gt6CeFSlWOaPm+dPuu0o9i17/M?=
 =?us-ascii?Q?lUG2A5fYgURERS9srDPNerQ5FFNu4sAT91h/KDDbknH9m9ADhH03DVAtPkya?=
 =?us-ascii?Q?J09u+XTLxvD3vGEzIkbXv8I2BaExTrpYB/6RBlfa52O6zGzHRwXGLuk75Vs+?=
 =?us-ascii?Q?Dxk81QZf++f5YMPE9aP1HbqzzQsrb/czF9lB8+t32sdllsx5O+um7FUIaIah?=
 =?us-ascii?Q?5BO91ZIPO9Gj/snkcgiMBiQQ7/zCJfOiRxadR4Bm0aoQqP/mNkQR0+HXB0OW?=
 =?us-ascii?Q?1qUJ5ibCPi9OpVfsXsQob1o0urZRyO8OuOvipR4+44NlJEDjqpTk6eSN5MM7?=
 =?us-ascii?Q?ONfvshNiH0pHgx9guKz7radhtkoJlAoxeOo8xtAdaKHa3Vmct1M4WyjzGCE0?=
 =?us-ascii?Q?cE7ELLOEuVjqiLSD2o4ggCEtKbnbzLIAWVD3gflftS5x7aSdbnolytJRk+8e?=
 =?us-ascii?Q?Asv4uk13Zw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03996b40-e3e2-4ca4-5755-08d9fd33d906
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 16:35:37.7273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYU37ef0G7dvn+1DUZsGGT5+c9F+oPjPbJ/BT45lFHGB72zGpDSS42VZHcWbqx+Qhd3Mbyg/GnsUrgkeN7BsUlTqVJkB89ynv7zmEe1e+Sm6j6KbjnRidHtf5YECoXxw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR01MB1984
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 03, 2022 at 06:36:30PM +1300, Barry Song wrote:
> On Thu, Mar 3, 2022 at 3:22 PM Darren Hart
> <darren@os.amperecomputing.com> wrote:
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
> >
> > Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
> > arm64 systems who can test and verify this behaves as intended. I will ask
> > around tomorrow as well to see what I may have access to.
> 
> I wonder if we can fix it by this
> 
> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> index 976154140f0b..551655ccd0eb 100644
> --- a/drivers/base/arch_topology.c
> +++ b/drivers/base/arch_topology.c
> @@ -627,6 +627,13 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>                 if (cpumask_subset(&cpu_topology[cpu].llc_sibling, core_mask))
>                         core_mask = &cpu_topology[cpu].llc_sibling;
>         }
> +       /*
> +        * Some machines have no LLC but have clusters, we let MC = CLUSTER
> +        * as MC should always be after CLUSTER. But anyway, the MC domain
> +        * will be removed
> +        */
> +       if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> +               core_mask = &cpu_topology[cpu].cluster_sibling;
> 
>         return core_mask;
>  }
> 
> as it can make all kinds of topologies happy -  symmetric and asymmetric.
> 

Hah. Full circle. Yes, this works, and it's basically what we'd started
with internally. I ended up exploring various paths here to avoid a
"band aid" and to target the fix and minimize impact. That said, after
digging through the acpi, topology, smp, and sched domains code... I
don't think this approach is a band aid and it's a very minimal
solution. The only downside I can think of is masking a potential
topology bug and not catching it in the scheduler - that seems very
unlikely. I'm perfectly happy with this solution as well.

Will D, would you prefer this approach?

+Sudeep, Greg, and Rafael,

Are you OK with this approach?

If so, we can drop my arm64 specific new topology patch and I can send a
version of this one out (suggested-by Barry of course), unless you'd
prefer to send it Barry?

Thanks,

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
> 
> Thanks
> Barry

-- 
Darren Hart
Ampere Computing / OS and Kernel
