Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC34C0A22
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiBWDUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 22:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiBWDUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 22:20:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2090.outbound.protection.outlook.com [40.107.223.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B73B45053;
        Tue, 22 Feb 2022 19:20:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be5dyutFTiErN8FRThiVvcZkGZcckpAbIeXPU0SaWSwDLbWN19ANFB6ZYFXBUCRuXTn2h+CNMsmewn4Xi4BojX0oB0N4hyjMiu2BNugnEH//UUNBD88HzV/7OXqP4L/hUTpznemu81qmNrDloEAgG4W8aoHbNC7ezdPloU5LFBj34QcRlxXkUtnVJWR/6Ue8Ctdytbk+mVYP+3fO4q3p0tpqO4TdXAAo2QMYqwqozE7bmtYRbcFPL7fGUtDgKbM4w/NgTaYcWBav9NAhVBLIC5NT2KRa4Qu95XHzrtB4rkJdVK0QjiJq0JiFJBk1damb67oS+jBxr4n9ZlAL7qSISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryIqAHNdJNeaKOsl+PmRCRKds7DFYUSZ2STlgXEt7VU=;
 b=CI8b09wtpCjo/B36LvW43EXnaHN5j1Ex+ONL5RcO385N+Lo0aIUJgSoqWXfUQiQ8SCZo5nA2PtC72uB4N06dzmLGrzsEeRfz3DIzYUvcRvay0+6HOrbsns2nURICIPXxd1npF1CI4e31MCE4rAwwd7DniNSIgwrrdhQgrl97cCOPCJ4DHmbeAJ8FXRdCnVO4jdj99RThjK3kLO1FeeP3VykXuERAs2YQav0dWY9IFNlCLlDpTJQzn+9C/Bwbx9zkZWgpfh8+RYx9D7asK7k+dmqt2UFfZ3OdJIop/P7T8YCBQlTk7vvVnaySt6kRl8NnuJDEKGw01Pb1A9AJnFVfSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryIqAHNdJNeaKOsl+PmRCRKds7DFYUSZ2STlgXEt7VU=;
 b=eb0m1ZbqAmyG3PLtXT+diuJWGRo7xoXUXbRb/MWJplqmjP1dXLYu5NIOtKgI8Uv1UJmbp8/LvAS2RKJHNCuk04QNec2c7R/ZPOIuY0UYmZFZlaYku4gOwGszfZrQ5aNdIep82zMyJ8Ln/TU0MhtpLh6dORuAG9nJ9HCFVzxejIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 PH0PR01MB6294.prod.exchangelabs.com (2603:10b6:510:18::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Wed, 23 Feb 2022 03:20:15 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 03:20:15 +0000
Date:   Tue, 22 Feb 2022 19:20:12 -0800
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
Message-ID: <YhWn7MmBvgZzP7CA@fedora>
References: <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora>
 <20220215164639.GC8458@willie-the-truck>
 <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
 <YgvjtsOZuxzbgBBl@fedora>
 <CAKfTPtCHrZCp1Uth4odyT721wE8zoNVY3Mh+DSyuTkqPafm0Hg@mail.gmail.com>
 <CAGsJ_4yB-FOPoPjCn+T4m76tvzA6ATaz24KYM9NjBeB54nWxLA@mail.gmail.com>
 <Yg0bu53iACDscIC6@fedora>
 <CAGsJ_4w2r8Hp3BNOrcQYDT6JgsFWWAgVruAOXpeXrhjskJMV7w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4w2r8Hp3BNOrcQYDT6JgsFWWAgVruAOXpeXrhjskJMV7w@mail.gmail.com>
X-ClientProxiedBy: CH2PR18CA0039.namprd18.prod.outlook.com
 (2603:10b6:610:55::19) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5090c48a-954f-4363-9cc1-08d9f67b68e3
X-MS-TrafficTypeDiagnostic: PH0PR01MB6294:EE_
X-Microsoft-Antispam-PRVS: <PH0PR01MB62943EC5E7836A59EBCB4E39F73C9@PH0PR01MB6294.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qM9OLrnTMg75vENIgfFOSnfRaX/cvB71hGvMUG0CA1O7EwkbECJbxxAJyky5hzCzXLSMKT44hhO2XWcH7xyzS9l+938bS/haL3LYCoM8tttJKVFKoiAm93DozNx07gpBuCdZDhY8lb/UDn84CFp9MaqwYFgFzVNiWNgwof9b5djZobrj5gaT5RXOQalsZE+4jpiaZgrPyuyKKu/g5R1X4dlb+vEe7/9K9cwgnL0o/jGKbYRuYO27mckU4tzqrfntRoBzUoIKu4N0xOAz8Ki0nvw+x6kbjvCy1zOWYXs/AFl6c+3SxMX72vFaNTHW5mN8C5OuaXPXFxvPPQI18ihkFPMry+M2OXdBeu0s3Q8W5KETw3Ogc7dmPLlnZN4P1V/93j58LwTBtWPCMSa5XC8YC3QxLKglSd0+SRA7OnMQwza/5AMjZ6FGTbF0faQ2XSoXMOi9dYTqQ3Y7ieLCOYGvaLKoSP6lalH3Jn/9pKnj2M0HDv0zk/VkATleHpoBN+1qCeEESiSLBHUEM7Gt3zPLh42SSTCbCsL2A589yo8cw8u6fFF1qP8NtyFOXZ2VavyXDKcXVI+EG8+Pks782LEQJjw+0RKve2c8g0ZRswCmUvrlJkW9DeIk1CAdBVotku5oPA+Y6C+py9ewMgr+/Se2Z+jkPPI7nSUvmWLu4hF7JPLH/8X1HODE6M1ExPUO9miOD94htggzbkC+GTSIq7ErhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(7916004)(4636009)(366004)(52116002)(186003)(26005)(66476007)(66946007)(9686003)(66556008)(6512007)(6506007)(6486002)(33716001)(6916009)(316002)(86362001)(6666004)(54906003)(508600001)(8676002)(83380400001)(4326008)(38350700002)(38100700002)(5660300002)(8936002)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nNgrt6xJl4gFc4tDPKJ56JSnhJweeP5YlJSU1EfkjqUL2bvAmSUp8E3UoHIs?=
 =?us-ascii?Q?7Ah5HSpdeZsCWF+mdvQC6/PpJTZpwuHngOREiC89d7zWq2FVStbp/Ll7lwOl?=
 =?us-ascii?Q?oqcWefNHuUmPloiKc2dD1DTNzB80+hxPK+udn8f1Y1JIpHgqWo1YJT8yu2e5?=
 =?us-ascii?Q?S62Q+NNISuJ4v6OOUPJ3t8auqsNpGmyzAF5NN+v7VHmFkDCrc3aVR0Hy49xV?=
 =?us-ascii?Q?9DHnAYhpvKdfAfcqLgd1AOtMUOVzRhs1QkP36jTQEbPCS/bpz7iWrPDMU91K?=
 =?us-ascii?Q?vfOl62A7VbGYkISgP65zJeET3yfBHcO+7FdzFXJmkKtq99LHvt53SGHz4Dc2?=
 =?us-ascii?Q?ms+e8paLqdr/uksu2XKXO6D4AZgcEdNRN5MMd0zC4m38I5GK/cjkuSKmyZF+?=
 =?us-ascii?Q?bMVSJxTQddC2phG5OE2SPbiNN2YyD+IYDALGX0dADyPsyBncqxLkKWK602Rt?=
 =?us-ascii?Q?+lfdf+e/5GVr+mBo6zEpqdB63qPXQklUvfnvpdKtX6vyvT0+X9SsyXf4fQlx?=
 =?us-ascii?Q?WdAluu4bq/gVqi6AERrcMPs8krmebbqVFAqaCzT/jH161kKEm0IEw+dTugrA?=
 =?us-ascii?Q?hCMF7a9PhOCQ7q2KY/yN5JHwJaQzeVTF9FL9cWuLJHrDlFdzApUezCEAT1Ds?=
 =?us-ascii?Q?Km+g8Pk9V0t2C4BFVl5IJn+4RQX1togh/i6pSxntZ1aOvmjhY/f0iqbiM0D7?=
 =?us-ascii?Q?9M4SyyJQvobm7rYGVtLFM3bBdBym4enYr4zNPXK7YgxSetym01K31YVDjxyT?=
 =?us-ascii?Q?vsCXmz8lJ+YrFmg2vqtOSw8LnRye/SStWTJt4kB+kfYP2Q5eJG4rFfBPsV/1?=
 =?us-ascii?Q?zX5htBmJtUK4TX6d1sHJECOsXX1BErWHpYqvKNAK/FOyetfuHoF+lpyjJZtO?=
 =?us-ascii?Q?nPBKNTLt2VaCtRMNWhXjpUjd9/xF4Ibiv0XuqwrJBJqxh6fxMtiU+OO57x+b?=
 =?us-ascii?Q?nYG2sXFN1hzuyzYQxuXfqy+JrU5PDgMWy2eVlHUd2YbnMHRn3M83AY/n35qO?=
 =?us-ascii?Q?6j2nY4irTS64IqSE9bpOtDRCmq96V5z0R2YLyvxd4eWe8KUKXfwdeuV43nhU?=
 =?us-ascii?Q?rHlx+Qdw8vafy8Au95YGRme3hwfkm8/E+46tAzIi757hoCyTyYIYB+dL7yeB?=
 =?us-ascii?Q?y7svrGY6EZbvwCzxvwxSIMJqkgRk82UqfhI1MTGEoIsTVwEsbW5UvEBAPBZy?=
 =?us-ascii?Q?ApsveD8O7sCslmZsgKi/2wuVw6AWlhDIcDvxPylrcHDUi3qCyk+QT5ZcGho/?=
 =?us-ascii?Q?1e7pQeKbxJLM1IswAjbdzZyHXh7YKHDREZO6iLlqlnvTEQWUowY+CTFThkzN?=
 =?us-ascii?Q?5TkOdQ4Fz49Y3+QgS38uwys1O92k3erzxDrXa76vREV9vAs2y03iPypesXZp?=
 =?us-ascii?Q?7eMIcAXqRxoxoNVr23MhKZlXPaLD7tAnISUul9CH+1O41kmYpjGHo88K4b/Z?=
 =?us-ascii?Q?FGeMts9vH49tpA8VehOKP8ndvqU5+5RXrUXw0T1J51bIK7Ct+6emp9pT2FVD?=
 =?us-ascii?Q?pR4hPvT9xTOIls6dzXYLrx4sr94y5tiZsK60pCa5/QN0LzDf5qqb07FrZBjL?=
 =?us-ascii?Q?bWnxcNHGGToukevCN/JBSlkjYtz6g7yHlIq8ix4Md3Mcvnp3/EVga3c7BN2a?=
 =?us-ascii?Q?2yq9Mfu+WJx6YxsgeddlVuPR6/QkCAt/a/79I4uQaoCrkTKbrgD8zFAtHDzI?=
 =?us-ascii?Q?XiAIRAIuSujQXQWt2r8FKNnf2p1ks8rbyi3K7XgHC0tTvac/M0Cf3DCF6V7c?=
 =?us-ascii?Q?kxXAY3jPZw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5090c48a-954f-4363-9cc1-08d9f67b68e3
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:20:15.2199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MrIy3WnyI3z8QU5z0VsPQlFJp3CDMtiuEQRZRxje/N7IWdm8+dm4VXgcB7kX25BJnSuzGuIB6qP3nNS73oTy76cD7jn12x01wEA95QMxSu1rDslv8G+mFejgZWkC0Aht
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6294
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 07:56:00AM +1300, Barry Song wrote:
...
> > > > Then, there is another point:
> > > > In your case, CLUSTER level still has the flag SD_SHARE_PKG_RESOURCES
> > > > which is used to define some scheduler internal variable like
> > > > sd_llc(sched domain last level of cache) which allows fast task
> > > > migration between this cpus in this level at wakeup. In your case the
> > > > sd_llc should not be the cluster but the MC with only one CPU. But I
> > > > would not be surprised that most of perf improvement comes from this
> > > > sd_llc wrongly set to cluster instead of the single CPU
> > >
> > > I assume this "mistake" is actually what Ampere altra needs while it
> > > is wrong but getting
> > > right result? Ampere altra has already got both:
> >
> > Hi Barry,
> >
> > Generally yes - although I do think we're placing too much emphasis on
> > the "right" or "wrong" of a heuristic which are more fluid in
> > definition over time. (e.g. I expect this will look different in a year
> > based on what we learn from this and other non current default topologies).
> >
> > > 1. Load Balance between clusters
> > > 2. wake_affine by select sibling cpu which is sharing SCU
> > >
> > > I am not sure how much 1 and 2 are helping Darren's workloads respectively.
> >
> > We definitely see improvements with load balancing between clusters.
> > We're running some tests with the wake_affine patchset you pointed me to
> > (thanks for that). My initial tbench runs resulted in higher average and
> > max latencies reported. I need to collect more results and see the
> > impact to other benchmarks of interest before I have more to share on
> > that.
> 
> Hi Darren,
> if you read Vincent's comments carefully, you will find it is
> pointless for you to
> test the wake_affine patchset as you have already got it. in your
> case, sd_llc_id
> is set to sd_cluster level due to PKG_RESOURCES sharing. So with my new
> patchset for wake_affine, it is completely redundant for your machine
> as it works
> with the assumption cluster-> llc. but for your case, llc=cluster, so
> it works in
> cluster->cluster.

Thanks Barry,

Makes sense as described. I did see degradation in the tests we ran with this
patch applied to 5.17-rc3. I'll have to follow up with you on that when I can
dig into it more. I'd be interested in the specifics of your testing to run
something similar. I think you said you were reporting on tbench?

-- 
Darren Hart
Ampere Computing / OS and Kernel
