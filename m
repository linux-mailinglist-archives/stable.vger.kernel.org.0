Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F0F4B8CC1
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiBPPoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:44:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiBPPoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:44:19 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2122.outbound.protection.outlook.com [40.107.243.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D6D2944EF;
        Wed, 16 Feb 2022 07:44:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1H92KFOomPliXREVtIG5GWWsaLQe3FaumMKyuJyQa74PaB9y2tSM693ZPdDSJvNgszBCHH/lQr3t+8Vh0esanq48vPx7WJKwVOlAkJTLRHtbvbwjIEyDg6Y4YeH2VR1aEv6QDf8/U8vunOsyJtpCay6df/9Ul9Q/cvtE0V6Cqt+DHepnQyujMwbbOZ5tBaWQtdNjGvwJNld7zjC/+ZmVIUs1Jtz+N7pHqx7v+lwKXQJyP7PEvWA5K94ZxuWaWkpjyadLe2YkNwAug4G1Fy3n/iuQ+LbBhx4zZuWWnBxYCo2J7hOqshLNhtYXovP21R7x2BFS9ajj3VkMYddedpYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFe11h5JvxMaucbRyvhzGYRlf7PMaEXE90sXLClUxpA=;
 b=HJ2K0aO59Ns5b05q94Gqfu1MdztVeJPQsqsmhrJwOjBnP3hB4gZGhbZ0dJS4HYxg+buErL8g7sm3BopkaIr4AHXODvPrXmHD3MJ41BktGNk+2D7piRo74GGJNtcXQqHK0tg3sL5KJJHUuVsON0kfvmVEmbEkPgknnHzdFnCU3CM65z0V6TTbpztPOmJg4L/L+KSmrqVqGkEQxD4qpHIFM/f3mn1Lzx1ogghBV0sYXsulIcxBObMAVbffahB1qmDfXlzcxWygNfzxo+riPmpjXQZsQ1DQPtowZHKKtuSnFM+LL/xwpy78Vxx9LYgfcx2g1C+KECXEKhK1rnUKLn9Uyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFe11h5JvxMaucbRyvhzGYRlf7PMaEXE90sXLClUxpA=;
 b=M+EJivUE0FJiHLEusohQOLxyzFmJ/8v23Bh8qg32DC5M58YzYOjhMGvHVVGvJqlPXctVDYDNniiiyWNNgsF/o4VV4cVUzowD0ZR03aGFtZPn2FjjxdzyH8dGQAT2uvecHLThONLRI8/Wm+ufBvHKMRXBbD+NBlq9LD+PrCDFTiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SN6PR0102MB3438.prod.exchangelabs.com (2603:10b6:805:10::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.18; Wed, 16 Feb 2022 15:43:58 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 15:43:58 +0000
Date:   Wed, 16 Feb 2022 07:43:55 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Barry Song <21cnbao@gmail.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
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
Message-ID: <Yg0bu53iACDscIC6@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <CAGsJ_4yB-FOPoPjCn+T4m76tvzA6ATaz24KYM9NjBeB54nWxLA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yB-FOPoPjCn+T4m76tvzA6ATaz24KYM9NjBeB54nWxLA@mail.gmail.com>
X-ClientProxiedBy: MWHPR20CA0047.namprd20.prod.outlook.com
 (2603:10b6:300:ed::33) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fad90e0d-c5b5-403e-98a2-08d9f16324a1
X-MS-TrafficTypeDiagnostic: SN6PR0102MB3438:EE_
X-Microsoft-Antispam-PRVS: <SN6PR0102MB3438480EF632610A919960CCF7359@SN6PR0102MB3438.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fojcI6T3uqP/mbpfFszPk3CLX8ROrSJzknEyzukmYNJUkyCh2bZW/AuDyoGiDxcsNzQuiMUVQm+l4nBWvQnDigOmqVdTSS3sHlBoqr5h0m++RThINv1VpTx0W3vrv9eLETjVVP5tNT96TUgwemKmBbCj5x+hyotjSi+0k2AojPft2WUdqD0ZwXzLcvvId4t30Cu5gZtVOgWkCdVCsp0xOqGU0B6I+7i0tbolCx5W2NH5eb3GfrziL9V++TufEWLgo19zIyzsQw5esrkbaWx2NZ1lJb+hpGdgFB02geBjnsKKf4rqJ45eTbhctsRA9RKA+EbtDQ9vBaDaW0yoVRDSXfyKyL3ma5Un7qAh/mlUgtMpKDNHDd7FCT1O+Ly/mRxSFozQ3wFaLyR8/HBQTdKqBKy0sQH9cgVdKnaOYf/2o6RBkvPF9uQc6yHY7gbfKinWH6647Xw5N1AClSnIqE9OxLX+dmG/7/DJtmK7siYifgjkNY6eBtr1K7s1lu0g7e72K1jqsYFkN9WygU5cGLaabOGi6hCxxMpv7Fn91/nCxyIyrIdZlMMi1/VUR5h9qlEfbidJsLqySDF1XO5GQVAG3lRlzVIxeyyVUMH4yQbcuYidWX9Qtr5ky44yDqcPBWW8axO0BzZMPvvr/SfxU5JpLFGKnfVz8WXc/IYTp45skxtwgDmlnOANW8Y78uZz4yRiIQOdjjRfgYbqhLZBsOR5AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(6916009)(4326008)(7416002)(186003)(54906003)(6486002)(5660300002)(66946007)(86362001)(66476007)(2906002)(66556008)(8936002)(33716001)(8676002)(38100700002)(38350700002)(6512007)(6506007)(9686003)(26005)(508600001)(6666004)(316002)(52116002)(53546011)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f3WG0kk5HKQbjsA4/YVY+BxFpg8SR4Kx2A+LgKXg5Nq0vfv9hmAx0XKusTIL?=
 =?us-ascii?Q?llT8w4NpQvMqV0DIchL6FwlZ2AD5w7Q9aZrJJpuIthhLjjx0OYMKEIO7wSEL?=
 =?us-ascii?Q?VlFjuJphoqQUv/YcKZrJqNfQITkjU7WoSc7HB1EFUVHJtGHNCksw4d+vxgUX?=
 =?us-ascii?Q?3pnJcvzvoGYAk7/8VWMNzMsETVTWum4U8n138JzsacfA6r3AJnVJQg9iAIlf?=
 =?us-ascii?Q?ioQiboNWA7FectbHbBgD/hN17pXpabTAf/jtDlIYrhZ0EWmOKtc9geJh7QW/?=
 =?us-ascii?Q?EPG/8Td4GKQpX1iPv9CT6bNbpJDBK0Qc/DCT5uYZbvxoXIGO0jRIpN6DAesG?=
 =?us-ascii?Q?RVSRnl42DzAJb/Fn9kv3+ipzs9MkmZoskZLjtkGdQf2DNSWK6+qnb4h4Rp/D?=
 =?us-ascii?Q?/2+lTJ/LhOLZnAmg3aAb6f6VLML2NfnUFUurPxj3/iFDwo5yOgTyYBm5d/h/?=
 =?us-ascii?Q?C1vzs+BpRFplVjJF7oIUp3b+2yqUGha8njOiyH+0Sd1oJY6r5NFy0uN9PKlS?=
 =?us-ascii?Q?W9brx/6mabGp1mhynpA1yeTIQuratWy9vAE1sbvVYF4nTtzZiysuTMq6cpVJ?=
 =?us-ascii?Q?tLR2djONM5uXCXYh8ckzgTxgJbYwqcfrvOCEaPtGzeBNlfXOrlyeJpy2Zia/?=
 =?us-ascii?Q?K8UBnR5Pq+HFUj0HfV1NVsAI+Gv0R+cCXlJ9+m4/CzNN7doUdwhEIR04wxcK?=
 =?us-ascii?Q?xVyjJnZVXfF4cr5ZcqdZcHnl8rPekK4WaerEHdzt+9LGKTzVCP948s4yhMnj?=
 =?us-ascii?Q?KJjUryXwczzcWouDHo/+C2TU4JRMvqMBtmcyevaz85pJ+zdiH+p7mvRy3x9x?=
 =?us-ascii?Q?8xyZQEMdg8Ar+jVVfIFzem8Fi7FmzMZmA8hiXtc97CIINjC3W60qtBmoHSAc?=
 =?us-ascii?Q?3ptehV8p1gKcIDyZpWJop6aK7kCR7jATVyoFGDOp0E7SFNhD9vTEeDeS4BnL?=
 =?us-ascii?Q?06BEOLbVpAz1yznu5VVzhED7SCn7atVMexZuqXQCiYzLobodI71euHIYFvnt?=
 =?us-ascii?Q?WIMrDnj67QfRTjmCEgRvRxUOUKrLMf4/os/JHE1tOOnQbjdMJB1mAyIw4z1g?=
 =?us-ascii?Q?8i+Tm6FYlL/j9YpsxLd+jxyiEbo57HtgQWwUGFrlFRHdNGyYS43XzrBU9Afg?=
 =?us-ascii?Q?PPDSZsZQ7FaT+JBMV/luCzNbp3fcGRtBCjjbn76juf3VgywXlBWv8fi1CYWp?=
 =?us-ascii?Q?62PC2iNXfNsTaB7nB4Gqxagi8NYjCorQaTiCVHWHKEgJ3OydwH1A1hSxMyEw?=
 =?us-ascii?Q?JgDOTeIZMxDTl+hqpMFN5p3+7GaEviAG+mundvfdMhjAfyHJQIIetGXi/4Pu?=
 =?us-ascii?Q?iVf3nI0zX442K7PyDwzRanLiUBNyXGFldpd2R3a5E9V3XJFZ/HJs0hyusDln?=
 =?us-ascii?Q?8x34PJkPRjZ41PvNXfLCaaaZjVc4Ori1wfH+ryrmSQR+TiDz4aYW6Ef5wrnG?=
 =?us-ascii?Q?0XCiKV2JhRWQWQuZPUSbkjZ/VAGH1Db0pVa8Ol/qayHfkfzTpLmyjWIL0olX?=
 =?us-ascii?Q?dDDPe10Mj5/BjQ5RF92wMcdHUGm1Pj+LNXFJPaF6WNGYT24KJ7gf1xA9TO3u?=
 =?us-ascii?Q?dBgnasvzKUF3JLiha0EcP91scuNHP2YipOcuO64kSTReoaduM/Kp/CYQk5+w?=
 =?us-ascii?Q?C6T3ZSnJGBeUHA7A/lBaHMuDfF+bEB8kWu6C3mwYKk1ltGc4lOQIhGfUNgtZ?=
 =?us-ascii?Q?CcGVrfFB0jXpypt1SS6W5fbMHPGDbIEApoRTKSmDoAoS5sjz+9hCu7+rWl+6?=
 =?us-ascii?Q?XpuQgmZJMg=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad90e0d-c5b5-403e-98a2-08d9f16324a1
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 15:43:57.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5MiBhTmYCaItNe+12Q2BLPvIJ8hfWWI+rKZiH6sQHHY8u4BT7AwsHuHy+H0zu+qBNLjm733ZC5An5ZyrOLXnTkCTIsx+JGg1/92xizrXGGPQzk3T+FlEUJ4blRaQeaU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3438
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 08:03:40PM +1300, Barry Song wrote:
> On Wed, Feb 16, 2022 at 7:30 PM Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
> >
> > On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> > >
> > > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > > >
> > > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > > >
> > > > > > > >
> > > > > > > > > -----Original Message-----
> > > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > > >
> > > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > > >
> > > > > > > > > BUG: arch topology borken
> > > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > > >
> > > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > > removed entirely as redundant.
> > > > > > > > >
> > > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > > >
> > > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > > >
> > > > > > > > > For CPU0:
> > > > > > > > >
> > > > > > > > > With CLS:
> > > > > > > > > CLS  [0-1]
> > > > > > > > > DIE  [0-79]
> > > > > > > > > NUMA [0-159]
> > > > > > > > >
> > > > > > > > > Without CLS:
> > > > > > > > > DIE  [0-79]
> > > > > > > > > NUMA [0-159]
> > > > > > > > >
> > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > > >
> > > > > > > > Hi Darrent,
> > > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > > for each cpu?
> > > > > > > >
> > > > > > > > > ---
> > > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > > >         }
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > > +#endif
> > > > > > > > > +
> > > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > > +#endif
> > > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > > +       { NULL, },
> > > > > > > > > +};
> > > > > > > > > +
> > > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > >  {
> > > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > > >         int err;
> > > > > > > > >         unsigned int cpu;
> > > > > > > > >         unsigned int this_cpu;
> > > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > >
> > > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > > +
> > > > > > > > > +               /*
> > > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > > +                */
> > > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > > +                       use_no_mc_topology = false;
> > > > > > > >
> > > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > > CLS and MC both?
> > > > > > >
> > > > > > > What is the *current* behaviour on such a system?
> > > > > > >
> > > > > >
> > > > > > As I understand it, any system that uses the default topology which has
> > > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > > will behave as described above by printing the following for each CPU
> > > > > > matching this criteria:
> > > > > >
> > > > > >   BUG: arch topology borken
> > > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > > >
> > > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > > on.
> > > > > >
> > > > > > That would still be the behavior for this type of system after this
> > > > > > patch is applied.
> > > > >
> > > > > That's what I thought, but in that case applying your patch is a net
> > > > > improvement: systems either get current or better behaviour.
> > > >
> > > > CLUSTER level is normally defined as a intermediate group of the MC
> > > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > > flag
> > > >
> > > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > > not disappeared Looks like there is a mismatch in topology description
> > >
> > > Hi Vincent,
> > >
> > > Agree. Where do you think this mismatch exists?
> >
> > I think that the problem comes from that the default topology order is
> > assumed to be :
> > SMT
> > CLUSTER shares pkg resources i.e. cache
> > MC
> > DIE
> > NUMA
> >
> > but in your case, you want a topology order like :
> > SMT
> > MC
> > CLUSTER shares SCU
> > DIE
> > NUMA
> >
> > IIUC, the cluster is defined as the 2nd (no SMT) or 3rd (SMT) level in
> > the PPTT table whereas the MC level is defined as the number of cache
> > levels. So i would say that you should compare the level to know the
> > ordering
> >
> > Then, there is another point:
> > In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
> > which is used to define some scheduler internal variable like
> > sd_llc(sched domain last level of cache) which allows fast task
> > migration between this cpus in this level at wakeup. In your case the
> > sd_llc should not be the cluster but the MC with only one CPU. But I
> > would not be surprised that most of perf improvement comes from this
> > sd_llc wrongly set to cluster instead of the single CPU
> 
> I assume this "mistake" is actually what Ampere altra needs while it
> is wrong but getting
> right result? Ampere altra has already got both:

Hi Barry,

Generally yes - although I do think we're placing too much emphasis on
the "right" or "wrong" of a heuristic which are more fluid in
definition over time. (e.g. I expect this will look different in a year
based on what we learn from this and other non current default topologies).

> 1. Load Balance between clusters
> 2. wake_affine by select sibling cpu which is sharing SCU
> 
> I am not sure how much 1 and 2 are helping Darren's workloads respectively.

We definitely see improvements with load balancing between clusters.
We're running some tests with the wake_affine patchset you pointed me to
(thanks for that). My initial tbench runs resulted in higher average and
max latencies reported. I need to collect more results and see the
impact to other benchmarks of interest before I have more to share on
that.

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
