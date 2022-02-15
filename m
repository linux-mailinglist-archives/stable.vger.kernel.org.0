Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0144B7550
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbiBOQon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:44:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbiBOQok (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:44:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2091.outbound.protection.outlook.com [40.107.92.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87B01019ED;
        Tue, 15 Feb 2022 08:44:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsvZGodxIY8xsf2SRUN+O3d7k/fUxC9kiwMWbJt0cPMawMp58xTFXN/Sw/AnFEsFCJVkqRRZPp20MOPNyG0t2gtphcyUK3xQn0FuWO5OgwuWYT3XT8VUfZKlBERLbqwbyEBKmlslT0oUnx+pPc6pfDRLXLuwyGW1inbzX8jjf0HxCYzP70731m9WPGvO+HhYZziP/gZMsBoclzl6MIyHt/cl/SWBGXJp9uRUYIHmNZ1K6rHI4yyN+cINaJOvhEbRr1xPmo+aKZ8NE+4hIt1C4g0RvGhJZXwqP+V935KhgMkGy4qcRWrjRmQgbPHHSf2MMvKlvmjUOSV+RLK3fwnGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5yq8lyK1N8WoThF+vo+GmWnEcjEiUyhr67vkJORm7w=;
 b=JKEoX7OpSl81BwgHaqrNLRqvTkEWVhIGe5jHYSzPo20vCGUUo4/u/O68muqornI+EqDBkQAEaMBMfEo77NkjtQ6v/EiVYXW3XF3xqV7ZwWYreZaLVJkiyNJ1US1stHHkZICjgC8o4eBgsnaLe89pLpyHUD5+EaFHNekAIwxslL5thPsup8buYW1t3zHJyZIvLN4jix+edja9ADmNRX6OGh8r6BTT0Rfy/6QBFSeR6PtHseKZ/V5RY57u7JeoW2zQ+qcpta6fDQSOl96GY4ThhJtxvcLa9WnQzSXVWCB/izgXaIfY1bUPqMFXFw3k1WAw8lQ5PlfR+L+1au+hQNI25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5yq8lyK1N8WoThF+vo+GmWnEcjEiUyhr67vkJORm7w=;
 b=Go4UUK3oZY1ytJK6R9aXmgVNtzrCwNwV6Kssct2CE66MaMVAWHrpFMvqtSFcD+EN24MvP8fJo9DCPOdLza/KiBifgrHvi1NDBLIo/91MjF5PI8w4n0ztFw942gUTZd9LwfN77UKhxp7hFrsks4N+izBhi60SejVuxuoibB8vSwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 SJ0PR01MB6335.prod.exchangelabs.com (2603:10b6:a03:29f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.14; Tue, 15 Feb 2022 16:44:26 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::7cd6:6594:ce3c:6941%9]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 16:44:26 +0000
Date:   Tue, 15 Feb 2022 08:44:23 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Will Deacon <will@kernel.org>
Cc:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Message-ID: <YgvYZy5xv1g+u5wp@fedora>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
 <20220215163858.GA8458@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215163858.GA8458@willie-the-truck>
X-ClientProxiedBy: CH2PR15CA0024.namprd15.prod.outlook.com
 (2603:10b6:610:51::34) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12d36ac0-b338-477f-76bd-08d9f0a26d4e
X-MS-TrafficTypeDiagnostic: SJ0PR01MB6335:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR01MB633535FA81D98EC4DD0BA21DF7349@SJ0PR01MB6335.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiwaE+WolsnJivced84XEpwFgmuxQ1+UYiCj/6LlJAqlo10LZ6OsTG+FLr0PoQpzKZbj4Nm4m/CFA8qDaSA1BDLeWu7M+4Ah6SF4PSl3OGh+5/TtOwPk2p0kJ632rCCpK0xpkRlFiGqVGK0X+HcEXOXs28XNb1X0mMyApVuKZ3YdeldwrtPeBt11ojcZqK9puFOrQmp038x5etdnbyMKOe9218p2xYoaU/BafVPwYlgiB2tNppm+b6tlUTHWzT/m7OOMmRmGhhqMrrQHcg63R+7EyAuk9+qPWQOsUu9+rQX7IzR42Sd6MPeFfiAxHqYqNZVrktq/eZDskcYzKlGvExllVB7tG48d26fLZ8jjZT0wy3pCB4OGuo25AeJTTcxByKHSYuFn5XSYejeyhlRAcupb9MGDELfg05eAILoBxGwoeV/arDVKKr9d6vEPhyvhEOOvH+zRD6oITLEyRoi7n8CNI8jHtWFvmMGD4Qh67c5VGg8G0KmGOR3RMM2xPkarkCfIgRgo6/LE/5j1l24YgiuYXOtImBb82BbqnZq12IYbCZGLKZHudbMBNeuVuPdHEFdSCnwCSCEsLAdbpY7M6Dq9bXgMw2nF3wP7V6W97w8eKvHFmWdFPapvZ+ZsRG0jpDBTD6z5Ow4LMGkm7GyG9SzeyigQDFk3JbZZIJ5xRk8//geuj1ufeuvx4y2XTUJlZdXz0GWHFJz0af2FKAaPf/p9iffPsNocGgcq3OPgcSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(7916004)(366004)(66476007)(5660300002)(8936002)(4326008)(8676002)(86362001)(66946007)(66556008)(38350700002)(38100700002)(6916009)(54906003)(316002)(6486002)(26005)(186003)(6666004)(508600001)(83380400001)(33716001)(6506007)(6512007)(53546011)(52116002)(9686003)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/X9tEdhgobsD11OspKpxCAnY7T1K2O/5XxDJyuMBMhlMJ10AlE1CMXouoeh?=
 =?us-ascii?Q?zlY5fZX7bFO2zqkiKVdwjqfrhBNkTSiMRslhJDc58F6HnMhrZjZ5Ns9a6XH6?=
 =?us-ascii?Q?g3S3uteO1TrCHDHN2cFyahLwPXlZ8cgaPc44wtRAxeaYfYBuy8l1uCEk352a?=
 =?us-ascii?Q?0+n7ONqIeEKQL+vy94nupXQYVqhFn5wj/leSnRUJtRmnrQH23QR4hmGEtv1k?=
 =?us-ascii?Q?URZGRkEItye9dwCYbCwieyZ9AgZtH2cYFjOlXpS+mtrRthDjUI4IDnx6SVqj?=
 =?us-ascii?Q?t8/MMGDzijUO56nDBVW38lFVrnB2BpCetNNfbktBOhV1dG3TJoqkv+Jqd0dp?=
 =?us-ascii?Q?Gv5upozCLKLjeus1EXFvwZiW++n4hdMy7fztxPm2450wQ4blrusPmjuHZPeK?=
 =?us-ascii?Q?ZdSDCNyVR+bMkXvMtkgA+wduOI0Jls7pYF9Ko+QTDZ6RJia/Qz4GOw/GbYFf?=
 =?us-ascii?Q?f0r09+m1hbR+4wuhVxN/ICxnTyqkeQFCBBEytTHlpCMQT7Cl//CSJtts1M7Z?=
 =?us-ascii?Q?Smv7HU4EIF4QhY4811DT5tAYzA4QUK5TStS0hZKc7Xld+43eZo9CBDWilh5C?=
 =?us-ascii?Q?HKrKocZog5MqMHmOT6OBKMqSJEGHGf/PCxaIUjb/W5m4g1zjk5Ow1uGMvFxt?=
 =?us-ascii?Q?0NtpIswoKTDRaH+g8fygdjYpmWDoTTOILrD9WM6GbmVVrsE+n4FJtavN5Q2o?=
 =?us-ascii?Q?VAlDo5dW5yv7b2QgI/tdSYIiqAerxOt3l4Ao3yljNMjeIADCDaau9qzU47aq?=
 =?us-ascii?Q?kOZSkMiuV1dJjl7ay3u1vaB62ZgFjoySocHrEr+G0zc/HnfKnLjNS8k6q/iD?=
 =?us-ascii?Q?Zy4QOSW+DakA76/Y5kJ9lDq0M91QqYFK7CeUFAOYkeubsWRei1h/npzMQczz?=
 =?us-ascii?Q?tGDKfGxg0id403FW2rXDjoM7SDNMp+VOWwIWsd4DTvuR0JYXYrOG2MJuiad/?=
 =?us-ascii?Q?zPs+/c3zDE0F4dfOGrZqblOJjGCkX8a7c/Gx3Ep/C8niml8YzB4pDxVZ6CQb?=
 =?us-ascii?Q?5kYnQOAgWRjMwtvodg7FYR3pQxOllFuQMzYIt0B8F0r9MXhO7eMQCV8zsK6I?=
 =?us-ascii?Q?ladZJlM9OU/uhKRcFOGVEb0F4ZQVPX6DBMmT/OvapI1sg1021i19wOh0NKA+?=
 =?us-ascii?Q?/aI+SSqwuQkmNeT2MytMTusmggB0Mh7tRHUcpyH3Fb8Ss/qhual79GGAchDe?=
 =?us-ascii?Q?nlLc5EwV8ETAvikvVk9L9b5Qki9bWS/U4t5xzbGitf9NSyqqzuaUw7bIwAW8?=
 =?us-ascii?Q?oqCF89joRqwONxUoLf8gz61inKl0lB93zhtflsfF1lYA334GPZCji0ZDpQxE?=
 =?us-ascii?Q?mB/i5iWgs/FAPyJx3wYJhSztunvHGeWy1/dfi42orkyAuRx4lZj6AAcxWEje?=
 =?us-ascii?Q?t341LlKOO7b4c8/pp8a+Qg+4k5ymB1vZr3eIEh7H+gZXj1bReKi8peujKQPv?=
 =?us-ascii?Q?T4mp2eeoZP4WvVojsRZ1ZTRUISx0VZTT0dgVtbYoFWBon+zwhYoF9UzJ0nr8?=
 =?us-ascii?Q?FHsgJAVEjWBLyUqYbEI+i6N1T0N9EQxkn/XtLoNN0wV4yqpwL/hzKA0MSTlE?=
 =?us-ascii?Q?Cjq4kNl+/LT+Qepothk+E4ukiFAylctKtYCrBJ0FBo+EEJNimhBgqhG12pO/?=
 =?us-ascii?Q?xHqC2ntOFatwry4Px0fNKo9uMSborSA796DMmQ8ldcr0cDBhmXCD6z3oTjdF?=
 =?us-ascii?Q?1lCeTKVLoB2gkXWhtVwZJzfeINa+nRe0CHUvI+bJMiBvAjkuM7lIW32i6TyO?=
 =?us-ascii?Q?4XDbxxp/gw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d36ac0-b338-477f-76bd-08d9f0a26d4e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:44:26.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1Try+TXtFsMJzC7V7N8XQS54IR7kE+qjHygQGHte29xa2ppSHiQPUyJLpvgPyHVfmV1NOtDCmBkqpzRjnSJtWFH+ReHJlDi7IBaMGZ6h95hgxO9fiHrbgrpmMpoUHFy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6335
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > Sent: Friday, February 11, 2022 2:43 PM
> > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > <linux-arm-kernel@lists.infradead.org>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > 
> > > SoCs such as the Ampere Altra define clusters but have no shared
> > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > 
> > > BUG: arch topology borken
> > >      the CLS domain not a subset of the MC domain
> > > 
> > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > level cpu mask is then extended to that of the CLS child, and is later
> > > removed entirely as redundant.
> > > 
> > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > alternative sched_domain_topology equivalent to the default if
> > > CONFIG_SCHED_MC were disabled.
> > > 
> > > The final resulting sched domain topology is unchanged with or without
> > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > 
> > > For CPU0:
> > > 
> > > With CLS:
> > > CLS  [0-1]
> > > DIE  [0-79]
> > > NUMA [0-159]
> > > 
> > > Without CLS:
> > > DIE  [0-79]
> > > NUMA [0-159]
> > > 
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > 
> > Hi Darrent,
> > What kind of resources are clusters sharing on Ampere Altra?
> > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > for each cpu?
> > 
> > > ---
> > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 32 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > --- a/arch/arm64/kernel/smp.c
> > > +++ b/arch/arm64/kernel/smp.c
> > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > >  	}
> > >  }
> > > 
> > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > +#ifdef CONFIG_SCHED_SMT
> > > +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > +#endif
> > > +
> > > +#ifdef CONFIG_SCHED_CLUSTER
> > > +	{ cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > +#endif
> > > +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > +	{ NULL, },
> > > +};
> > > +
> > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > >  {
> > >  	const struct cpu_operations *ops;
> > > +	bool use_no_mc_topology = true;
> > >  	int err;
> > >  	unsigned int cpu;
> > >  	unsigned int this_cpu;
> > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > 
> > >  		set_cpu_present(cpu, true);
> > >  		numa_store_cpu_info(cpu);
> > > +
> > > +		/*
> > > +		 * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > +		 */
> > > +		if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > +			use_no_mc_topology = false;
> > 
> > This seems to be wrong? If you have 5 cpus,
> > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > need to remove MC, but for cpu1-4, you will need
> > CLS and MC both?
> 
> What is the *current* behaviour on such a system?
> 

As I understand it, any system that uses the default topology which has
a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
will behave as described above by printing the following for each CPU
matching this criteria:

  BUG: arch topology borken
        the [CLS,SMT,...] domain not a subset of the MC domain

And then extend the MC domain cpumask to match that of the child and continue
on.

That would still be the behavior for this type of system after this
patch is applied.

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
