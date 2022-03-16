Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E3A4DB4C1
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348524AbiCPPVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351322AbiCPPVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:21:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2110.outbound.protection.outlook.com [40.107.94.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D696C913;
        Wed, 16 Mar 2022 08:20:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL+HuH5w5QUNxz5YJZJcNwvI5VXO2iVW1+nogO3e/W0ovjtgeQMyqdapmZ2jnsUn6i455x1M2Q/cKVM/FXhzJu23DyKJCiXwMu8QDdaYhFFplxGiBlBkYioqAZAcWCFCmGC0+Ut356VwYC0dp2lb4KbHpz2b4Wv+gDyVXi4rHLJE/4N4rVBFbTzr/xqh8ilXwc6fDf7lez+16E4OujV4JEYpHZzPTLnfIeeZ+IjS5p8Rh+vGJITi8m150r+zMsiej1GZXMq6K6uKoutdVoQV4CEldGgsoLNtQl4FqSJCcy8mnRBDzAq9242JGoendhEweKvQ7h7VFlDMy7ZGtVRWtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZu0rN7XbI47qOfBKCpUifksFqATGovAix5yShSNmv8=;
 b=F3U8w9CO48G4yeouw4122fslhG203FLA0D14jAxDKKuR/15Yi+ElFS6o0d57ZNJphRrl6fMIbkV9AI9GbnlwNC93+sac3eGGJz0FE+cVTTZyADePxsBDPpkGVKqySGTpKzdzIl2j8kCpB3EDeXeRaDdD0eGa94qY1CALGfZx+ZRIU/uCWV+uPzAMXw+H0opPA4dd4s0samUSsq47TiQxoOabNX4rpIrZ6lmUoZ2q8sHW9Zx9f075Tx812gUYhWXcazENS4GvOASN61ZDM6n6XJ5XEa9qexZ7pat+1l/6H7QITGbHpH5/1QUuGVRc1smXuu6dZrepdKff4lmWXmerQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZu0rN7XbI47qOfBKCpUifksFqATGovAix5yShSNmv8=;
 b=gX/lLrW0J9DbKKfrtdH/LAgNhA/yQud6WrUBuyyD0nl3uEXvltHM5pRlYIrtCFzE/pe5gLLzuxVzuS2He/2UUfBPyi38lekCj5dS0+xMwASY8HGZrvUNpgDJVRsJaH0oqonOwz42HPK3KcR9EDqe9Fbylu+a7jfm3WEQQ38gnvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BN0PR01MB7103.prod.exchangelabs.com (2603:10b6:408:152::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.14; Wed, 16 Mar 2022 15:20:35 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 15:20:34 +0000
Date:   Wed, 16 Mar 2022 08:20:32 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org, Barry Song <21cnbao@gmail.com>
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YjIAQKwfa3/vr/kU@fedora>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
 <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
 <YijxUAuufpBKLtwy@fedora>
 <9398d7ad-30e7-890a-3e18-c3011c383585@arm.com>
 <Yi9zUuroS1vHWexY@fedora>
 <eb33745a-9d63-89b1-1245-9d1e0e04a169@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb33745a-9d63-89b1-1245-9d1e0e04a169@arm.com>
X-ClientProxiedBy: MW4PR04CA0049.namprd04.prod.outlook.com
 (2603:10b6:303:6a::24) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 682b50ed-8efd-40ec-b2ba-08da07608475
X-MS-TrafficTypeDiagnostic: BN0PR01MB7103:EE_
X-Microsoft-Antispam-PRVS: <BN0PR01MB7103C7F8874D16944296F05FF7119@BN0PR01MB7103.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+95JofcmdX/3/ZJ/8fQeB3t7c5qDUiClc6gXzJZwLEUrgIaJ4jEEmsD5UAroKRbhKygJdfSMavrg0555SjngKJEVH5lyoe/fOHk1GMrhTLycnuAwwbWreG5MvH07HZ9JgaX84vLcsKPfqiQcZD2HtOHZq7l6P8FDZGA68+XDWQbdhCOUDDqjkv2eutmGw4TAI8ZrlwtjxeAqY9o/JlG54zLOOXoNS511+rBhIETmz3B8JNOXM78tFae3KXXgkEIU4sC/aBsX7/LIKpUZKD+IM6nK6mU8rEGHvOO4oVhD0ZEIsAB5jE8rGX+kbtAiLvbwjjUtcek7MxUNjZmk0YoZH0HBzNknAaMfwrAp3671Lj1BvwxwurvNXVNOoDbvbmcvzxSr6ReydBKDmpbSzrvG9a/QOy10VTjqPNJMB4sLxR6KK57eky17x50A9DeRvJWho0eofM9M6erX3o/3zLvEmtA0gVvOm2xYWt4mb4uKbeiETRAHzT69ZglkcFVWSGKBZxPA1CWg9Mhtskw82u5vuit49tIKdO4rkLH1bpafOj/qlX0srnYljF6fT5s/ysbdChOH6/C8XbDczIHICxOHDcu+XT+qNMvJXhnYldvatKxNEm5JY4JyYrGLHQHe/xLFaTSpCEUjE598Gc5JiGXnkFBF+X2M9UsanVal/Xnk7OmO2HNocZ0fVhAjU9v1JqYZxnM3CoFZOB6PzJPvrol+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(33716001)(316002)(6512007)(6916009)(9686003)(54906003)(38350700002)(186003)(38100700002)(86362001)(5660300002)(508600001)(7416002)(4326008)(8676002)(66946007)(66556008)(66476007)(26005)(8936002)(53546011)(52116002)(6506007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gL+ArBpvxYjZHCsaUYY/3KaTknXNz5h74LlC2Ak6qr67On6edefkGP5Y1Ad6?=
 =?us-ascii?Q?URANqJm0O6Zy4lVKfoYTEgxjiKkCejgEg3xsTvvBnCW3QmwP0ify9jmZ/r9t?=
 =?us-ascii?Q?MIR9jlDsNrbnD+5iNcKs8PKE+M4suYKMtl0p7An+OEnlZyaFNNnv9y3Xj/By?=
 =?us-ascii?Q?0OELpPet7wPc9xo1EvFCuGl7EZciyKSp1B/1DjwCwjgrFDdQcerxK/d3EaHG?=
 =?us-ascii?Q?z9ROFqGgW1LAo8tVImz9z2OpMEHkVK4X4BD0AmqwiHeIpyPdOnJH1MYO5r7E?=
 =?us-ascii?Q?cn2/mqQXLwoUaGFqnx7sfAWx3JX8ppDYM69thRYVr6SqajQPhXd0NxbvsigT?=
 =?us-ascii?Q?EcVutuSKP5y6LNQZZaGWlSIqZ+wMgHs0olu5hNm0HtPEMYAhadwy8BrmeFQt?=
 =?us-ascii?Q?9RvsOE0dVMphqKO+3WpJ6JyWAsyPqpeokqt6rLcPfCmKoaGJD2b/B1gYuTX6?=
 =?us-ascii?Q?i9LcSaQAP891ML0C8bF5ic16YsBC56a6nAsumAijceDAiVJ/L0U6Dse+RCNT?=
 =?us-ascii?Q?Jh72m9Lb52KeAwymyO/8VFTK3crSG6GiQZfS1wqRcB8uwJdILCmPXmiJR+9/?=
 =?us-ascii?Q?lwNeO3kh5JayNJGSIRBYla/obJUjgACfVhut3CXDO0/dQ0bRBpL8NmfqFvgD?=
 =?us-ascii?Q?EH/ycvsVDmOI1AUeYsu/ChLQWnZhg3ZRAxYpdUO4k/PCuBPJKucc/ME7ixjl?=
 =?us-ascii?Q?irZr1aMFtz9lJoEuctTWW4dx+ZQ9kXJWhwflzaoT2QIZBWQ85jLORXrjsY1d?=
 =?us-ascii?Q?Sloqw/x5kR74AVdJEgsy31VvrakmT0oDsdLoAY9I43QvvBUoIiuCwb45TCoz?=
 =?us-ascii?Q?OtN2Rk0XK7VEYfphaeLDU6NESfImBbUK6fP31CwtZ879UKXS41XMvr75UKGD?=
 =?us-ascii?Q?cMtzJkpAfgRz49KGN4rGkFRaAmHwbs3xUqqVLawmaFDJ7CmTv9DmVVr9Q4ug?=
 =?us-ascii?Q?GNQ4qECHH1aAhFHpcsYheZtCxPy/SVKDC8WO75nkXwViqM8efiOdImqRcZH4?=
 =?us-ascii?Q?1Z4RfHDy4aEjZqMVIqAqDhOyTnw8kzDZxzKHyvlli0ywReTkap7+8+cnN5ra?=
 =?us-ascii?Q?uXtPlheyptkpe5NvarxxvReQD9XgAQzapIrMzTF9NyrSyA2AikWyhEOyuoeK?=
 =?us-ascii?Q?wjUV2q9t2JaC1iDvjKJWTDB5rjGLBGvD2en+VvHmJIuUMiZPZnS3kcW98h9Y?=
 =?us-ascii?Q?Sb9qObIIR+z72UpFEEJtR4J2RiFb0KEiHW9bz98jZRDoJpHyrhgHVZx1Q1CH?=
 =?us-ascii?Q?Y5uLmlYv6ChMUvpwnCTzl+HHwyUWUHm4wRjqcT2dkp4Fms7kyyNocct9pql/?=
 =?us-ascii?Q?ds8j69J5JWT3n1nh7+vSDAiGvf5OC++BcnrbuSOmBYm+ZUe0QPBOFlJimsn6?=
 =?us-ascii?Q?HkLJPddPNcet5x/jRuocIncIyZ3JkRsChPSJfS0Ymmjvf1R9elaz+bJk8mPV?=
 =?us-ascii?Q?f4gvok2OL4/tm8vMq96fxqk/etPJYlt312YHKxxMB1OgAqKIcIRIRCri0rxD?=
 =?us-ascii?Q?KiMuRpbAECKETPg=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 682b50ed-8efd-40ec-b2ba-08da07608475
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 15:20:34.8157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c44q/7dosQ1ggQaJU7g0RNSMPkmUvGclPep9LLpDCXaDatYFBzhsDkBInvP420FkKDRrsj5cEw+yPJcErO4qTAOjS9ZwYhdJpYhpWTG40Aa/07Y7Cw4gbdJDDjGtfUM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB7103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 03:48:50PM +0100, Dietmar Eggemann wrote:
> - Barry Song <song.bao.hua@hisilicon.com> (always get undelivered mail
>   returned to sender)
> + Barry Song <21cnbao@gmail.com>
> 
> On 14/03/2022 17:54, Darren Hart wrote:
> > On Mon, Mar 14, 2022 at 05:35:05PM +0100, Dietmar Eggemann wrote:
> >> On 09/03/2022 19:26, Darren Hart wrote:
> >>> On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
> >>>> On 08/03/2022 18:49, Darren Hart wrote:
> >>>>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
> >>>>>> On 08/03/2022 12:04, Vincent Guittot wrote:
> >>>>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
> 
> [...]
> 
> > Ultimately, this delivers the same result. I do think it imposes more complexity
> > for everyone to address what as far as I'm aware only affect the one system.
> > 
> > I don't think the term "Cluster" has a clear and universally understood
> > definition, so I don't think it's a given that "CLS should be sub-SD of MC". I
> 
> I agree, the term 'cluster' is overloaded but default_topology[] clearly
> says (with direction up means smaller SD spans).
> 
>   #ifdef CONFIG_SCHED_CLUSTER
>         { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
>   #endif
> 
>   #ifdef CONFIG_SCHED_MC
>         { cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
>   #endif
> 

Right, understood. It is a clear expectation of the current Sched Domain
topology abstraction.

> In ACPI code we have `cluster_node = fetch_pptt_node(... ,
> cpu_node->parent) but then the cache information (via
> llc_id/llc_sibling) can change things which make this less easy to grasp.
> 
> > think this has been assumed, and that assumption has mostly held up, but this is
> > an abstraction, and the abstraction should follow the physical topologies rather
> > than the other way around in my opinion. If that's the primary motivation for
> > this approach, I don't think it justifies the additional complexity.
> > 
> > All told, I prefer the 2 line change contained within cpu_coregroup_mask() which
> > handles the one known exception with minimal impact. It's easy enough to come
> > back to this to address more cases with a more complex solution if needed in the
> > future - but I prefer to introduce the least amount of complexity as possible to
> > address the known issues, especially if the end result is the same and the cost
> > is paid by the affected systems.
> > 
> > Thanks,
> 
> Yeah, I can see your point. It's the smaller hack. My solution just
> prevents us to manipulate the coregroup mask only to get the MC layer
> degenerated by the core topology code. But people might say that's a
> clever thing to do here. So I'm fine with your original solution as well.
> 
> [...]

Thanks Dietmar,

Sudeep, do we have sufficient consensus to pull in this patch?

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
