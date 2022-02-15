Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503DA4B73C6
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbiBOQjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:39:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiBOQjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:39:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB6DC336D;
        Tue, 15 Feb 2022 08:39:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0555F60ACF;
        Tue, 15 Feb 2022 16:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45011C340EB;
        Tue, 15 Feb 2022 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644943145;
        bh=V9kovIYtQQZPjm+yjWJXoF36Q5nY9s/7izEgPXb6ED0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H20AF5GpAoL0xHR3aw5y9HrMfQPcCLnqPRpm5ZgsnuWQnHD0/e/3t4HykhgISSXdI
         XBPmf4Kc6YbG2y45fo6XP/43XSOAo2IaNBPCr+PDW3QFrk3UCQGPzKW4r1u8xtm6gm
         pJmNxc28w0Ulw3yjO0GpfQweuD5Gj/tlk8QGMj0CpMAPB0gbmSds3rdU7M/3Ceh27W
         qVDXyt7GQPbqpcS09WIiNAtZ3CcfV9jz3WijMroOKdl4Z0HA0j0kqX5o5p7IB03HoY
         fm/q3Pzzit71kyrQgKTJXnWGQMyFB31qpgDJnJUNSEMYgBKqdxrzLy/bl+zBJt46xx
         BZwAqoN836hLQ==
Date:   Tue, 15 Feb 2022 16:38:59 +0000
From:   Will Deacon <will@kernel.org>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
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
Message-ID: <20220215163858.GA8458@willie-the-truck>
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> 
> 
> > -----Original Message-----
> > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > Sent: Friday, February 11, 2022 2:43 PM
> > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > <linux-arm-kernel@lists.infradead.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > <valentin.schneider@arm.com>; D . Scott Phillips
> > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > 
> > SoCs such as the Ampere Altra define clusters but have no shared
> > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > 
> > BUG: arch topology borken
> >      the CLS domain not a subset of the MC domain
> > 
> > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > level cpu mask is then extended to that of the CLS child, and is later
> > removed entirely as redundant.
> > 
> > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > alternative sched_domain_topology equivalent to the default if
> > CONFIG_SCHED_MC were disabled.
> > 
> > The final resulting sched domain topology is unchanged with or without
> > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > 
> > For CPU0:
> > 
> > With CLS:
> > CLS  [0-1]
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > Without CLS:
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> 
> Hi Darrent,
> What kind of resources are clusters sharing on Ampere Altra?
> So on Altra, cpus are not sharing LLC? Each LLC is separate
> for each cpu?
> 
> > ---
> >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > index 27df5c1e6baa..0a78ac5c8830 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> >  	}
> >  }
> > 
> > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > +#ifdef CONFIG_SCHED_SMT
> > +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > +#endif
> > +
> > +#ifdef CONFIG_SCHED_CLUSTER
> > +	{ cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > +#endif
> > +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > +	{ NULL, },
> > +};
> > +
> >  void __init smp_prepare_cpus(unsigned int max_cpus)
> >  {
> >  	const struct cpu_operations *ops;
> > +	bool use_no_mc_topology = true;
> >  	int err;
> >  	unsigned int cpu;
> >  	unsigned int this_cpu;
> > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > 
> >  		set_cpu_present(cpu, true);
> >  		numa_store_cpu_info(cpu);
> > +
> > +		/*
> > +		 * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > +		 */
> > +		if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > +			use_no_mc_topology = false;
> 
> This seems to be wrong? If you have 5 cpus,
> Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> need to remove MC, but for cpu1-4, you will need
> CLS and MC both?

What is the *current* behaviour on such a system?

Will
