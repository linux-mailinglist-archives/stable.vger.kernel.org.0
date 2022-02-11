Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91FE4B1CDE
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 04:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiBKDUz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Feb 2022 22:20:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiBKDUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 22:20:55 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCDA1105;
        Thu, 10 Feb 2022 19:20:54 -0800 (PST)
Received: from kwepemi100018.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JvzKw6k2sz1FCWt;
        Fri, 11 Feb 2022 11:16:36 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100018.china.huawei.com (7.221.188.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 11:20:51 +0800
Received: from kwepemm600014.china.huawei.com (7.193.23.54) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 11:20:51 +0800
Received: from kwepemm600014.china.huawei.com ([7.193.23.54]) by
 kwepemm600014.china.huawei.com ([7.193.23.54]) with mapi id 15.01.2308.021;
 Fri, 11 Feb 2022 11:20:51 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Thread-Topic: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
Thread-Index: AQHYHujOa/yZ8dQpvUyNjGL3bOgZ+KyNrJkA
Date:   Fri, 11 Feb 2022 03:20:51 +0000
Message-ID: <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
In-Reply-To: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
Accept-Language: en-GB, zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Darren Hart [mailto:darren@os.amperecomputing.com]
> Sent: Friday, February 11, 2022 2:43 PM
> To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> <linux-arm-kernel@lists.infradead.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> <song.bao.hua@hisilicon.com>; Valentin Schneider
> <valentin.schneider@arm.com>; D . Scott Phillips
> <scott@os.amperecomputing.com>; Ilkka Koskinen
> <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> 
> SoCs such as the Ampere Altra define clusters but have no shared
> processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> 
> BUG: arch topology borken
>      the CLS domain not a subset of the MC domain
> 
> for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> level cpu mask is then extended to that of the CLS child, and is later
> removed entirely as redundant.
> 
> This change detects when all cpu_coregroup_mask weights=1 and uses an
> alternative sched_domain_topology equivalent to the default if
> CONFIG_SCHED_MC were disabled.
> 
> The final resulting sched domain topology is unchanged with or without
> CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> 
> For CPU0:
> 
> With CLS:
> CLS  [0-1]
> DIE  [0-79]
> NUMA [0-159]
> 
> Without CLS:
> DIE  [0-79]
> NUMA [0-159]
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Barry Song <song.bao.hua@hisilicon.com>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> Cc: <stable@vger.kernel.org> # 5.16.x
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>

Hi Darrent,
What kind of resources are clusters sharing on Ampere Altra?
So on Altra, cpus are not sharing LLC? Each LLC is separate
for each cpu?

> ---
>  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 27df5c1e6baa..0a78ac5c8830 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
>  	}
>  }
> 
> +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> +#endif
> +
> +#ifdef CONFIG_SCHED_CLUSTER
> +	{ cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> +#endif
> +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +	{ NULL, },
> +};
> +
>  void __init smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	const struct cpu_operations *ops;
> +	bool use_no_mc_topology = true;
>  	int err;
>  	unsigned int cpu;
>  	unsigned int this_cpu;
> @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> 
>  		set_cpu_present(cpu, true);
>  		numa_store_cpu_info(cpu);
> +
> +		/*
> +		 * Only use no_mc topology if all cpu_coregroup_mask weights=1
> +		 */
> +		if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> +			use_no_mc_topology = false;

This seems to be wrong? If you have 5 cpus,
Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
need to remove MC, but for cpu1-4, you will need
CLS and MC both?

This flag shouldn't be global.

> +	}
> +
> +	/*
> +	 * SoCs with no shared processor-side cache will have cpu_coregroup_mask
> +	 * weights=1. If they also define clusters with cpu_clustergroup_mask
> +	 * weights > 1, build_sched_domain() will trigger a BUG as the CLS
> +	 * cpu_mask will not be a subset of MC. It will extend the MC cpu_mask
> +	 * to match CLS, and later discard the MC level. Avoid the bug by using
> +	 * a topology without the MC if the cpu_coregroup_mask weights=1.
> +	 */
> +	if (use_no_mc_topology) {
> +		pr_info("cpu_coregroup_mask weights=1, skipping MC topology level");
> +		set_sched_topology(arm64_no_mc_topology);
>  	}
>  }
> 
> --
> 2.31.1


Thanks
Barry

