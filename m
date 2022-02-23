Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08C4C09F1
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 04:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiBWDIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 22:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiBWDIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 22:08:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2131.outbound.protection.outlook.com [40.107.237.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B9E4249F;
        Tue, 22 Feb 2022 19:08:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThiM12B+/gZQAFy04+iPY5ZbSLFGbmJKhLZuC/7cFR2W/2jp/SZuzo+HqDElmmoiIowrBy/JEf1/lK2KeyLlTigTThUs7CK/WoJM+AdmX2chJgzYqvs7r2flcQDZG/YPDb/xhS2Nf4WoV84DooVKqBCn+BO91I6IBEGaU/6mlWcBAlCleheLijZt2gck/3CV8K8etQ8fYoNyZQewJ1Kug+2G7yz7nEhE8jUKZ0svgh40a+MHyvjRBmq8VJkt/16Q6bahXaI2XDZXetQziBSOfW22Fo9hPHUr8s5vYBET4r8mtQiTn9xxiEn9952Ojn9R16q/E9U2QN5j6WrqwnNlJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v153eZGUQio+588MaBwmmwfNMcW1To8KnmQffeVCKk0=;
 b=NdmlESs6Z8x24rblxqunsEEk+B0N+ayR4F/pzdBDaaBUdvjtTjkvPqxQQ2K1wUqbTd5QFdmY2PmMni9zJlPsgv0TuDnOGXZtRhfrXMF7DX98WpNYYv53BPkXAp1M6UBvbrdrY1PyFIhGWFBV0e6z7l1gn2ut3eYW5H2xouXuCMpdwLixpbMiusQF9bJGzQcr0FXhw6Xme5Yc02fZkvQG/M4h1EwP35Ep4enWYBh9F6dgqgx0qkv1YNS/wieUf94xxi8eR54FsuHZcMODIA5OIBjM+eS46i/VUYHh82UcOtzJo9+kGG16h4QkD2RYz8j5ACQ6qcOUteDqWNVof4Ev7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v153eZGUQio+588MaBwmmwfNMcW1To8KnmQffeVCKk0=;
 b=sog9ugC2XH+Ewtz094d/0t0yQWCzaP3UViau6/NTbFzh83NC1tgIgPaRV5MIrJO25KhL1XbsTJVZJSgCF8eAbAPqQ1XK2mqkxLjNU+ZzgI+wozqx4V7ndOsqTrZxl64MiDtr3LIwj5OhGQr328uGf1SAgYgJssSPGbidKquwiVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SA1PR01MB6621.prod.exchangelabs.com (2603:10b6:806:1a7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Wed, 23 Feb 2022 03:08:00 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 03:08:00 +0000
Date:   Tue, 22 Feb 2022 19:07:57 -0800
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
Message-ID: <YhWlDUzFeG0d7z6C@fedora>
References: <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <YgwHhxy/uGafQsak@fedora>
 <CAKfTPtAR2+bY8QpyaCCJfezsVkB62n8XZjL9c5_mPO3iyDnp4w@mail.gmail.com>
 <Yg0lULy5TmHKIHFv@fedora>
 <CAKfTPtB1Vt75ciX_V=8T3e5fgW-X7ybRk6VZvy4uXzjazjx9ZA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtB1Vt75ciX_V=8T3e5fgW-X7ybRk6VZvy4uXzjazjx9ZA@mail.gmail.com>
X-ClientProxiedBy: CH0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:610:cc::19) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1a58e16-5295-4dbb-a1e0-08d9f679b2d9
X-MS-TrafficTypeDiagnostic: SA1PR01MB6621:EE_
X-Microsoft-Antispam-PRVS: <SA1PR01MB6621DA60D429AC63800C01A6F73C9@SA1PR01MB6621.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5lXgYxJsEpBo24o6A1u2Do7kCDCQrEVUzNaS4vO3iMLSHlLN+yFbTEjZWk+cqeUDxwqOjq+0cOeVRs3VCfx2/x+Dywv1sx2FFITolWWajsXTHv+YB2+VWyogcbDZjOkG1cDguvLI7cNYdXA5CIJ1/PbjGh3yzZLx0NCvSlGNwXca9Qr5mCk/Eyxif1tQ/EmCOfm+EQVhsCEOEXNBRE3RRBxdYcvXDc4yxcpCZKmZH15Lxb7utXYcEPMkLIHppWG1Waqz7abdvRh7g+Ez5rd152hiDi0s5KkkBvVJpuhXAEzgr670p3+tZ/jDLMLHMQKgKrsi3fcEqhkWeMHFEy89PDm4NeNq3TOl2ofieHCKPRU47NEO5dml/pbCHG1oemthuYqYLErmcS0MH13fd8bkGxuPG90+bgsR3SocSa1DJZS4s5Lo+ec3ZGobGe0vsVADAca8x6/ZzeV1jw0GUg7RrKgxJEaiYT7c9z67LLHTbzPB3Ue2eiBdjbDh0ZR8u2IcXqyxuMRDswnNwNenKYIiMQLIl3HEo+y0K/1nHOfbF9YSBGP4HeAxAAgB5rM2AVJiNU8+5iH6F0/a1YMsMnr66LzyhZ8kRyrl1l3f4TpcicDamKqwzt2bW0/3Tg8QRM6mGwlkOUdHb+GsRrpb8OHkBqWty9t+pSl5VtiCMdYyjawv6sCju0/sOiV+66pPNHF8JTDzSM4BIrxHTXpJQzYuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(4326008)(30864003)(38100700002)(38350700002)(83380400001)(5660300002)(2906002)(8936002)(6506007)(6486002)(9686003)(66476007)(52116002)(186003)(26005)(66946007)(6512007)(66556008)(508600001)(6666004)(33716001)(86362001)(54906003)(8676002)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GJkI6gLpS7KkPJKFYRAXkrIvIyvZFgEdlHHTT83baQdt8ARngJOHlhEhiDt2?=
 =?us-ascii?Q?pG8AwnZQovfdv5MKP8O1WKcqm7+XIPsL4jadSde78o2azD/0jRhVkBW9F8+q?=
 =?us-ascii?Q?ATb1VAEzBBR7LszEiKNWg4ieObTk8aVKs0eO0AZHgxiXzcmrSARmX+L3iCF7?=
 =?us-ascii?Q?RYbLAk7F2SX4CjGYUOj8qQTAFpG88mFS9RZF5z5ypzQfPpZZeeZM/AdwL5KS?=
 =?us-ascii?Q?M1kzfA4FY90NqyMu4TWS2K1p3B5v32Lo0pWi6bYzwe4/VCFkGcGaK5oJsusi?=
 =?us-ascii?Q?Gw2r8yrxrCs3DtZ1UgbGouOOYMhoJwI28881rCWRvj+wArztCFwHD4CmdYvI?=
 =?us-ascii?Q?F5eRgqF15TWYYE7r3mq8/LD12uU9PNVn2zMH2W2LDWZVqj+snhAB0+bn0oBE?=
 =?us-ascii?Q?dOFlNjSEiIffBGp1tEUTfd6FU77HOL9qckjkmEby2KnkNTrAP23LJ7s7a5Bt?=
 =?us-ascii?Q?K/IdxgZkay+0E4kFi1S28AkShOppF/IDRqZid74ZtTbCfRSgwfLZvSvELAc1?=
 =?us-ascii?Q?C296YdOG22XV9mkxiy5DDQDu8bhwOdBCJZG06K/Y7ILTYLyFSzyqDf3qzTE1?=
 =?us-ascii?Q?p6Q/vW6/MRtCLOcl7JGjSEZ+tKR1OqZs7yMvjgLhBok6B0h0xX+toW01ran8?=
 =?us-ascii?Q?9bjMCVBiuy2BnknfPFOx6Y52FA3pxsEG6E9A20AwrOC422/VGz17gb9ziWDI?=
 =?us-ascii?Q?8iV8Y6ol0iIoIK1ZZAyewR1WPlBp3aoSVO8l6aYBs124wLJyH9D4TtxmfgNb?=
 =?us-ascii?Q?irW/fp7E3h+4/aM0sn5Ycp/+F/xFVGb0tw1NOTBRPCFX8/bex+7MgtlYnrVZ?=
 =?us-ascii?Q?LWkPVtDdP1o0BfuVUirJK34DsxxL4lnNymVsq/td/Ng4jawPgWbHQkYC5CTs?=
 =?us-ascii?Q?j7TfR+HUQcPIYMlJjqW0IGXtYnQjicr6fzxjE7CfHpO9S+dXovBitHRicunW?=
 =?us-ascii?Q?Y2XnFmJqeWSnWDuyKqvQtugrh8zyksYV/XejFBeON/x/h+WAuSshuDwreOlh?=
 =?us-ascii?Q?ly7/R4HOtRJR+tGTqbi95ZwDYVqp3jJ98iRswFe4dJNhek4XO3QdxA8OuYz2?=
 =?us-ascii?Q?BWf/LwNw0Gb1SGva6ZngHWbt0avFZIuqxgAx3g8wgLygUiN8uf1kZlSkjl8S?=
 =?us-ascii?Q?oBG5yTCptgMCorMtTnu6v1NTZev/w5LxJ4iZCvu3jH90KZBBojSnv1yY2Gyd?=
 =?us-ascii?Q?rkx8gtud3tFA45snrHsFQli+GGMl7HYXrY5tvxRSz+ETBaSG650gQki3wAZV?=
 =?us-ascii?Q?LSU0ss1LXhMpvKlMYjoaW/iXB6vdi7037zrAmhUt/6iOWJUsyC5B+XrlCpux?=
 =?us-ascii?Q?buyRd7EDiEMoj7GvDnIgqpjvAwsNy2XPBTz3qNaW7NhG0BEBvYad8/rDqQJ2?=
 =?us-ascii?Q?Fv1LRnXrB+jkr7x/l0UQFe945oMT4ho82o9ia9TqFHX4tPZs/5lSm6qGJlsv?=
 =?us-ascii?Q?+5BmbTXN4XMw/1iNNKv/iTtaefdWC8HQ0Fe4Isaap/qLr4Xoc9FDcaesByGs?=
 =?us-ascii?Q?5IaKg8IYlXV+qwT3zPaicdX3JwS5OCeUmiSuV1KFiHjexGZbhXZgi1+ZibEB?=
 =?us-ascii?Q?xAWq6/xb6oTIxeQP0XfQxwQFwJ+VKARLjGFNQORr6xYk+bAWw54PDm/TQRNO?=
 =?us-ascii?Q?POwDgX6ASs38Psoi5ifWGjLr5FNd4G4KZmSKPPMQ4Ncqkxb4oYltOfxJhn0g?=
 =?us-ascii?Q?8rF2L53Qswv5SmP4Eb5K7vQPs1Wx4KH05Afm0MnSNGh7cTnby8hD3CojpMSS?=
 =?us-ascii?Q?Nn/DiYmCnQ=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a58e16-5295-4dbb-a1e0-08d9f679b2d9
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:08:00.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U55QpwdxF5KzAzCokmuHn27sbDrwav4+n/dLvMcPBgv132MXT3A7Kw5ikRk2V+QWIz4AcAnEeTJCnrnuBr6zrERnDuTB0us+Rl828Mq/4A/gqwqsiPkppII9bDx5ucTh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6621
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 06:52:29PM +0100, Vincent Guittot wrote:
> On Wed, 16 Feb 2022 at 17:24, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > On Wed, Feb 16, 2022 at 09:30:49AM +0100, Vincent Guittot wrote:
> > > On Tue, 15 Feb 2022 at 21:05, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > >
> > > > On Tue, Feb 15, 2022 at 07:19:45PM +0100, Vincent Guittot wrote:
> > > > > On Tue, 15 Feb 2022 at 18:32, Darren Hart <darren@os.amperecomputing.com> wrote:
> > > > > >
> > > > > > On Tue, Feb 15, 2022 at 06:09:08PM +0100, Vincent Guittot wrote:
> > > > > > > On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > > > > > > > > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > > > > > > > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > > -----Original Message-----
> > > > > > > > > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > > > > > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > > > > > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > > > > > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > > > > > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > > > > > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > > > > > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > > > > > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > > > > > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > > > > > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > > > > > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > > > > > > > > >
> > > > > > > > > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > > > > > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > > > > > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > > > > > > > > >
> > > > > > > > > > > > BUG: arch topology borken
> > > > > > > > > > > >      the CLS domain not a subset of the MC domain
> > > > > > > > > > > >
> > > > > > > > > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > > > > > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > > > > > > > > removed entirely as redundant.
> > > > > > > > > > > >
> > > > > > > > > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > > > > > > > > alternative sched_domain_topology equivalent to the default if
> > > > > > > > > > > > CONFIG_SCHED_MC were disabled.
> > > > > > > > > > > >
> > > > > > > > > > > > The final resulting sched domain topology is unchanged with or without
> > > > > > > > > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > > > > > > > > >
> > > > > > > > > > > > For CPU0:
> > > > > > > > > > > >
> > > > > > > > > > > > With CLS:
> > > > > > > > > > > > CLS  [0-1]
> > > > > > > > > > > > DIE  [0-79]
> > > > > > > > > > > > NUMA [0-159]
> > > > > > > > > > > >
> > > > > > > > > > > > Without CLS:
> > > > > > > > > > > > DIE  [0-79]
> > > > > > > > > > > > NUMA [0-159]
> > > > > > > > > > > >
> > > > > > > > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > > > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > > > > > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > > > > > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > > > > > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > > > > > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > > > > > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > > > > > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > > > > > > > > >
> > > > > > > > > > > Hi Darrent,
> > > > > > > > > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > > > > > > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > > > > > > > > for each cpu?
> > > > > > > > > > >
> > > > > > > > > > > > ---
> > > > > > > > > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > > > > > > > > >  1 file changed, 32 insertions(+)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > > > > > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > > > > > > > > --- a/arch/arm64/kernel/smp.c
> > > > > > > > > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > > > > > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > > > > > > > > >         }
> > > > > > > > > > > >  }
> > > > > > > > > > > >
> > > > > > > > > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > > > > > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > > > > > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > > > > > > > > +#endif
> > > > > > > > > > > > +
> > > > > > > > > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > > > > > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > > > > > > > > +#endif
> > > > > > > > > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > > > > > > > > +       { NULL, },
> > > > > > > > > > > > +};
> > > > > > > > > > > > +
> > > > > > > > > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > > > >  {
> > > > > > > > > > > >         const struct cpu_operations *ops;
> > > > > > > > > > > > +       bool use_no_mc_topology = true;
> > > > > > > > > > > >         int err;
> > > > > > > > > > > >         unsigned int cpu;
> > > > > > > > > > > >         unsigned int this_cpu;
> > > > > > > > > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > > > > > > > > >
> > > > > > > > > > > >                 set_cpu_present(cpu, true);
> > > > > > > > > > > >                 numa_store_cpu_info(cpu);
> > > > > > > > > > > > +
> > > > > > > > > > > > +               /*
> > > > > > > > > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > > > > > > > > +                */
> > > > > > > > > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > > > > > > > > +                       use_no_mc_topology = false;
> > > > > > > > > > >
> > > > > > > > > > > This seems to be wrong? If you have 5 cpus,
> > > > > > > > > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > > > > > > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > > > > > > > > need to remove MC, but for cpu1-4, you will need
> > > > > > > > > > > CLS and MC both?
> > > > > > > > > >
> > > > > > > > > > What is the *current* behaviour on such a system?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > As I understand it, any system that uses the default topology which has
> > > > > > > > > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > > > > > > > > will behave as described above by printing the following for each CPU
> > > > > > > > > matching this criteria:
> > > > > > > > >
> > > > > > > > >   BUG: arch topology borken
> > > > > > > > >         the [CLS,SMT,...] domain not a subset of the MC domain
> > > > > > > > >
> > > > > > > > > And then extend the MC domain cpumask to match that of the child and continue
> > > > > > > > > on.
> > > > > > > > >
> > > > > > > > > That would still be the behavior for this type of system after this
> > > > > > > > > patch is applied.
> > > > > > > >
> > > > > > > > That's what I thought, but in that case applying your patch is a net
> > > > > > > > improvement: systems either get current or better behaviour.
> > > > > > >
> > > > > > > CLUSTER level is normally defined as a intermediate group of the MC
> > > > > > > level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
> > > > > > > flag
> > > > > > >
> > > > > > > In the case of Ampere altra, they consider that CPUA have a CLUSTER
> > > > > > > level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
> > > > > > > larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
> > > > > > > with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
> > > > > > > not disappeared Looks like there is a mismatch in topology description
> > > > > >
> > > > > > Hi Vincent,
> > > > > >
> > > > > > Agree. Where do you think this mismatch exists?
> > > > >
> > > > > I think that the problem comes from that the default topology order is
> > > > > assumed to be :
> > > > > SMT
> > > > > CLUSTER shares pkg resources i.e. cache
> > > > > MC
> > > > > DIE
> > > > > NUMA
> > > > >
> > > > > but in your case, you want a topology order like :
> > > > > SMT
> > > > > MC
> > > > > CLUSTER shares SCU
> > > > > DIE
> > > > > NUMA
> > > >
> > > > Given the fairly loose definition of some of these domains and the
> > > > freedom to adjust flags with custom topologies, I think it's difficult
> > > > to say it needs to be this or that. As you point out, this stems from an
> > > > assumption in the default topology, so eliding the MC level within the
> > > > current set of abstractions for a very targeted topology still seems
> > > > reasonable to address the BUG in the very near term in a contained way.
> > >
> > > But if another SoC comes with a valid MC then a CLUSTER, this proposal
> > > will not work.
> > >
> > > Keep in mind that the MC level will be removed/degenerate when
> > > building because it is useless in your case so the scheduler topology
> > > will still be the same at the end but it will support more case. That
> > > why I think you should keep MC level
> >
> > Hi Vincent,
> >
> > Thanks for reiterating, I don't think I quite understood what you were
> > suggesting before. Is the following in line with what you were thinking?
> >
> > I am testing a version of this patch which uses a topology like this instead:
> >
> > MC
> > CLS
> > DIE
> > NUMA
> >
> > (I tested without an SMT domain since the trigger is still MC weight==1, so
> > there is no valid topology that includes an SMT level under these conditions).
> >
> > Which results in no BUG output and a final topology on Altra of:
> >
> > CLS
> > DIE
> > NUMA
> >
> > Which so far seems right (I still need to do some testing and review the sched
> > debug data).
> >
> > If we take this approach, I think to address your concern about other systems
> > with valid MCs, we would need a different trigger that MC weight == 1 to use
> > this alternate topology. Do you have a suggestion on what to trigger this on?
> 
> AFAICT, this CLUSTER level is only supported by ACPI. In
> parse_acpi_topology() you should be able to know if cluster level is
> above or below the level returned by acpi_find_last_cache_level() and
> set the correct topology table accordingly
> 

Thanks Vincent,

This made sense as a place to start to me. The more I dug into the ACPI PPTT
code, I kept running into conflicts with the API which would require extending
it in ways that seems contrary to its intent. e.g. the exposed API uses Kernel
logical CPUs rather than the topology ids (needed for working with processor
containers). The cpu_topology masks haven't been populated yet, and
acpi_find_last_cache_level is decoupled from the CPU topology level. So what
we're really testing for is if the cluster cpumask is a subset of the coregroup
cpumask or not, and it made the most sense to me to keep that in smp.c after the
cpumasks have been updated and stored.

I'll send v2 out for review shortly using this approach.

-- 
Darren Hart
Ampere Computing / OS and Kernel
