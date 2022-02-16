Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695834B8DE2
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiBPQZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 11:25:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbiBPQZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 11:25:06 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2106.outbound.protection.outlook.com [40.107.244.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E6123C877;
        Wed, 16 Feb 2022 08:24:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgFyDUEwDvfPa2pcZjKALu1jIX+QA7GMSm+k5GbGuIYj/yUBKk4dkQLkTBfnMT2L9Zo1nt9OVfUM0adG9CRZD/5kKlgxM57UpHG0mx68caEwxs9/xxHog7wfZFqVP1p8CTPYEkqBJWrGgTQLtSL1KK9DAG/g0N3fHd3vxOLE6d34SYLvnyv0hIlJyp81ZOON/kSKnBWyQBwZQ+Rl+MgiI7xR022hFM4B+MDMMbvU+e4d/yEEW/2wmHW8vwRQbEGzbZWVp7XGiD9tyJwLWQN96gPZKk/B+MBb+aAtJArISxxJ3F76g1Lmk4f2KXpNCeOM/+1+yfQyY2H5EbdPWl/TyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Kxmrw9zEok1ZeQU0dxzczh+IBcCHhkDr5+2algHMYE=;
 b=ixCezX2tEeG2Y5aCuIsrkwiZDVAlv6oVDu663p5DFmSzH/U3EJMroCLeKa1FbYWnWrRnMWXfvdndOn0Z0kpS+aJmRaPlCNR8Hi0djA3KV3/sp01h1l8DWR0MkEPsIU4N4ECyKmIFL3HeTNqseE/fDZVaf9qi/yW0FOrmC4tV6IilijFMm8dNkKBNiPY/9S8gifIPnMN/6tYOumbldovTNNJpCokuxeY1puQG+NoGhNzmF7+50zWwAggjOHfUgrDUf6pG9Gwd8tAGVxSB8KcXcHximJmhqlktAuwRKzO/nniPEBSjTzDGkLd1turkouEghUp0unlbN/39/MUcFF3HUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Kxmrw9zEok1ZeQU0dxzczh+IBcCHhkDr5+2algHMYE=;
 b=QNwMI3Nv/1m8AHsU+dSbFVCmTUKRYkeMcYKMTj6rIGRGZP4pJIt2AXfbjr7Ke5IEwNsBTxU85HrGKTYgS9OCwh7zbBgXTtbdmsXsbtGrePa2ZftMv4JHn9b6n1uDOwgLhPKBnFu+rC0HzSMgrJq3sMeRMuBgmYvLHh4IfLyq2do=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 DM5PR0101MB2938.prod.exchangelabs.com (2603:10b6:4:2e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.17; Wed, 16 Feb 2022 16:24:51 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 16:24:51 +0000
Date:   Wed, 16 Feb 2022 08:24:48 -0800
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
Message-ID: <Yg0lULy5TmHKIHFv@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <YgwHhxy/uGafQsak@fedora>
 <CAKfTPtAR2+bY8QpyaCCJfezsVkB62n8XZjL9c5_mPO3iyDnp4w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAR2+bY8QpyaCCJfezsVkB62n8XZjL9c5_mPO3iyDnp4w@mail.gmail.com>
X-ClientProxiedBy: CH0PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:610:b2::19) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 281fb347-b75c-4597-2c78-08d9f168db26
X-MS-TrafficTypeDiagnostic: DM5PR0101MB2938:EE_
X-Microsoft-Antispam-PRVS: <DM5PR0101MB2938BED80762F9256B7BC3C9F7359@DM5PR0101MB2938.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRm4qJgvlrAnTh0PxGkR4PEMAQ50Fhr84chk3LHaQj71oOFfm1HQuzS+aKUeoftIAuX9WWCQip6eQCONfNLndwe3qxhlxcxtZI6hD38lSdNkHf4APmH3tJf6dPAL69ADf5RsRlzRD8HJ8epq+AxUY1Z8lUF2M33CrcSciD/V1WCW5/sDoroyNfPHFST+WBO8L7mNbrk0PWpDDExt+YM3slwABLsIpjejzdu8O/die4UvwFIFcp5G1+EDazYtDnDoCB8B4JjExnvuLPbp7eHWOBlXxpK4YDYLFZXSD3tp/D0x47kwCNI8Sd1+qVSsvvrrvcxJCPrS0Hyslz/AcbmYr/OQvgyCqKZ9/EIS9NCulvrVobQwjWLbCK7UKRYG+doJ4QBSJf6elWI4mJ+rHtXR+6/Gyntd8lZ0M0crR+nTz9px1aHwYbQCbIFPm/PmFUdxpQuwTT235u3JBnWk2b1OLAJXZYrS9Kz45N7EGNEGlhfEzp83W+MzF4u6rWGbuMPC9C0B9oAfIldNQ9FfEQeN/fke7TbSZatKzRUwskdx3NscKqXuq/s6bnpx+yTWuSfpl3LX2I8xsY8Ovc476RN0xrF9Ipwj8be97SfU6eUX0uy+0IxtbjT4zx3HnrjOKW7YtR0zpnP8PkKnIQlWy6cMJNMM+Or4He7TfNHGWU0OMO9YxBMgXmJnstv5jUUq9lS7VzhoUh8T5wBpmBcED3a7vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(38100700002)(6916009)(54906003)(6666004)(86362001)(6506007)(6512007)(38350700002)(8936002)(33716001)(508600001)(9686003)(316002)(2906002)(5660300002)(83380400001)(26005)(52116002)(8676002)(4326008)(66946007)(66476007)(66556008)(6486002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dYPIPcegb99UR7++Bdpasycf6RSB46/U7NvHUHqicalV76eG6AVo/JVwBef2?=
 =?us-ascii?Q?lzBFbvsKCAV8tz386tdLWo4MiTAGwjV5oYEuC1P02HnIz9UVedvdMk07Vyz4?=
 =?us-ascii?Q?3dUXyBYP15omFjuOhQsRQNvC5rlNY/dgdg/ZGPA37cbxq1g/O7WfntnZjrI6?=
 =?us-ascii?Q?QiFHCpPErIdI7TYg9B3eVT9x1dP9K2sFH0fRqr1Q1ywQMHugu7NHqnuvfq30?=
 =?us-ascii?Q?NPwf/EeJgkBBVYrExRbDgdMoC7MopzzzK/+0LyxkrjjQsSG0aZioveGiY5k/?=
 =?us-ascii?Q?kBKa0HaIxx9mq3vSxs6gavjfU0CAxALuuZePTnPdkziE/yOsWjEoOKJB4TWM?=
 =?us-ascii?Q?eddJqcZbl0mxVZb972iWqQEW6Tjvy85fjj4pD8OP7asEyP4tkfDsKr2CkDG9?=
 =?us-ascii?Q?7kfeFLplcabOsgE+y2uo0pby3VL1R6zh0m1Jf4i3KgECGpfUM3Cu9GWUc5wh?=
 =?us-ascii?Q?mY1dsTY2a75s4xcWLlguhiAHD/j0AypvspVY2TLm3BUzxgG+HBvVEZm7lD3g?=
 =?us-ascii?Q?Vvfp9NOszqpSajGubcaUisB7Ym6imhjUw+h9r9UOL53PeRKcGGDqFENWrUxc?=
 =?us-ascii?Q?kY7LgrRWh3UG4SQ5HIT6vMf+BbiIIUGPcpAR7Bm3rqY7r5jMtn4olZs7YP7w?=
 =?us-ascii?Q?QlJtYsewcyVXkeQuD3YIRnIy0ujpxI5+I2ZUbp2uzJ06+iya8B/00wes2wGl?=
 =?us-ascii?Q?Eer/H7TUfwpYj5M9LQuHEIQoBlH5wBxhQLd+Qc8gpojdFzgR3CoZS4PnEwIN?=
 =?us-ascii?Q?meN1MyboER3ORoxdzG8SferF5ifkZdfz1wWTf5wtVIdfnSrIXyFZr3C97Rg9?=
 =?us-ascii?Q?Fipx2sSvNJF2gj39rRj/xfP5BpPvWnditFm8JIiQ2xA6c4VFKijp5dUDVwLU?=
 =?us-ascii?Q?w8wXckTECbzQRUNQ2bsSKi6+8B7nTkZTXoV4Fr0O6rtyC6ROLT/ndO9mjSO+?=
 =?us-ascii?Q?1Zrru/yqvJ/p51smv/UYtX8ZAjjwy8ndZErQ5bnSu2cOZ3uYwAGDvfKVuDl6?=
 =?us-ascii?Q?7kdLhLCEKqtsm4QaENsd4eqEFNByiyloqeirTJ/TvjMwDUPs+h0ZVZ1T/f9q?=
 =?us-ascii?Q?aDW3FIy4zPxA3JfOBjIweKrBxh1la3stIqVgKaeAERLeGNxR0q7dic4AY6OF?=
 =?us-ascii?Q?CSH4VR9dhByNBlsNWzfaeVlOsAdMeQ5QZg8RM0THEfLE+46PLb0uJHfWoMGF?=
 =?us-ascii?Q?CbZiufKsF+TNMDw8K9p4NPaLM2rX82eFJlrf8Ng/j8xF4kBnH8UqTL4pmId7?=
 =?us-ascii?Q?nK89njPRGQbLNO76P7Yl+cWboAqa6XkAolaL/8UtuEiNc+1WDOh5cI+peJHc?=
 =?us-ascii?Q?hmDNvjmvhvY5OqkMkv5KpjovmoKrQHCWjwZCMNFlGmG9iSpOu+mCWlU2gx2Z?=
 =?us-ascii?Q?dqqgNz/rPaKqhIzELe0FMVln9g6J+FxqWFOZH+OAi2U9G3PZzdNj5auTGv/D?=
 =?us-ascii?Q?uuBmvlx/IJ8tnm953K5STUBHDgVjNy82hXxgn4vEHwKO+gMnCRKyshV4XZM5?=
 =?us-ascii?Q?Z6CAes9R/E8bpwpsWoeGjCAWT7I54UjNPYlyQdxSogiWkp9B8Wv57ddltsm7?=
 =?us-ascii?Q?IUPvUuUz/FFWA1lkhzeYH+rgnuFzdn9ehdCgLba/AdjdQPQVjUQ5FrM/N9t1?=
 =?us-ascii?Q?4NgbBeNl2fg0iat9//jGk08SKQ/y133fLg6icmE4uGOJZdW4Hshps9ZDP1M6?=
 =?us-ascii?Q?bOk8l7pqKNbdqGAO4BfsvWRy/kmHhTS9rU7GtwGUqOoYVj+we+Nt/Roew6D6?=
 =?us-ascii?Q?4Rr/D8xSVw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281fb347-b75c-4597-2c78-08d9f168db26
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:24:51.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPKo/9eQ1LGLz2hg0OlDZE05ymVWUWB3Q64mg7a7IR0yZQEA1v/nukYv1J9twMhjcl2CBTs4Jy+LC3ZYPtBqadOnLqr4ZOn1NGfQ+kb7lYtvlHin7i3velRL1De5kBmq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB2938
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 09:30:49AM +0100, Vincent Guittot wrote:
> On Tue, 15 Feb 2022 at 21:05, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > On Tue, Feb 15, 2022 at 07:19:45PM +0100, Vincent Guittot wrote:
> > > On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > >
> > > > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > > > >
> > > > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > > -----Original Message-----
> > > > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > > > >
> > > > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > > > >
> > > > > > > > > > BUG: arch topology borken
> > > > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > > > >
> > > > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > > > removed entirely as redundant.
> > > > > > > > > >
> > > > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > > > >
> > > > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > > > >
> > > > > > > > > > For CPU0:
> > > > > > > > > >
> > > > > > > > > > With CLS:
> > > > > > > > > > CLS  [0-1]
> > > > > > > > > > DIE  [0-79]
> > > > > > > > > > NUMA [0-159]
> > > > > > > > > >
> > > > > > > > > > Without CLS:
> > > > > > > > > > DIE  [0-79]
> > > > > > > > > > NUMA [0-159]
> > > > > > > > > >
> > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > > > >
> > > > > > > > > Hi Darrent,
> > > > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > > > for each cpu?
> > > > > > > > >
> > > > > > > > > > ---
> > > > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > > > >
> > > > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > > > >         }
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > > > +#endif
> > > > > > > > > > +
> > > > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > > > +#endif
> > > > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > > > +       { NULL, },
> > > > > > > > > > +};
> > > > > > > > > > +
> > > > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > >  {
> > > > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > > > >         int err;
> > > > > > > > > >         unsigned int cpu;
> > > > > > > > > >         unsigned int this_cpu;
> > > > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > >
> > > > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > > > +
> > > > > > > > > > +               /*
> > > > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > > > +                */
> > > > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > > > +                       use_no_mc_topology = false;
> > > > > > > > >
> > > > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > > > CLS and MC both?
> > > > > > > >
> > > > > > > > What is the *current* behaviour on such a system?
> > > > > > > >
> > > > > > >
> > > > > > > As I understand it, any system that uses the default topology which has
> > > > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > > > will behave as described above by printing the following for each CPU
> > > > > > > matching this criteria:
> > > > > > >
> > > > > > >   BUG: arch topology borken
> > > > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > > > >
> > > > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > > > on.
> > > > > > >
> > > > > > > That would still be the behavior for this type of system after this
> > > > > > > patch is applied.
> > > > > >
> > > > > > That's what I thought, but in that case applying your patch is a net
> > > > > > improvement: systems either get current or better behaviour.
> > > > >
> > > > > CLUSTER level is normally defined as a intermediate group of the MC
> > > > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > > > flag
> > > > >
> > > > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > > > not disappeared Looks like there is a mismatch in topology description
> > > >
> > > > Hi Vincent,
> > > >
> > > > Agree. Where do you think this mismatch exists?
> > >
> > > I think that the problem comes from that the default topology order is
> > > assumed to be :
> > > SMT
> > > CLUSTER shares pkg resources i.e. cache
> > > MC
> > > DIE
> > > NUMA
> > >
> > > but in your case, you want a topology order like :
> > > SMT
> > > MC
> > > CLUSTER shares SCU
> > > DIE
> > > NUMA
> >
> > Given the fairly loose definition of some of these domains and the
> > freedom to adjust flags with custom topologies, I think it's difficult
> > to say it needs to be this or that. As you point out, this stems from an
> > assumption in the default topology, so eliding the MC level within the
> > current set of abstractions for a very targeted topology still seems
> > reasonable to address the BUG in the very near term in a contained way.
> 
> But if another SoC comes with a valid MC then a CLUSTER, this proposal
> will not work.
> 
> Keep in mind that the MC level will be removed/degenerate when
> building because it is useless in your case so the scheduler topology
> will still be the same at the end but it will support more case. That
> why I think you should keep MC level

Hi Vincent,

Thanks for reiterating, I don't think I quite understood what you were
suggesting before. Is the following in line with what you were thinking?

I am testing a version of this patch which uses a topology like this instead:

MC
CLS
DIE
NUMA

(I tested without an SMT domain since the trigger is still MC weight==1, so
there is no valid topology that includes an SMT level under these conditions).

Which results in no BUG output and a final topology on Altra of:

CLS
DIE
NUMA

Which so far seems right (I still need to do some testing and review the sched
debug data).

If we take this approach, I think to address your concern about other systems
with valid MCs, we would need a different trigger that MC weight == 1 to use
this alternate topology. Do you have a suggestion on what to trigger this on?

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
