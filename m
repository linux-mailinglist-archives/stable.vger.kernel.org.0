Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85E24D1506
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbiCHKqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345929AbiCHKqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:46:33 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5213941330;
        Tue,  8 Mar 2022 02:45:37 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 161C01FB;
        Tue,  8 Mar 2022 02:45:37 -0800 (PST)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBB5C3FA45;
        Tue,  8 Mar 2022 02:45:34 -0800 (PST)
Date:   Tue, 8 Mar 2022 10:45:32 +0000
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>, Dietmar.Eggemann@arm.com,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YiczzB92EcShyvLh@bogus>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308103012.GA31267@willie-the-truck>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 10:30:12AM +0000, Will Deacon wrote:
> On Fri, Mar 04, 2022 at 09:01:36AM -0800, Darren Hart wrote:
> > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > Control Unit, but have no shared CPU-side last level cache.
> > 
> > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > 
> > As a result, build_sched_domain() will BUG() once per CPU with:
> > 
> > BUG: arch topology borken
> > the CLS domain not a subset of the MC domain
> > 
> > The MC level cpumask is then extended to that of the CLS child, and is
> > later removed entirely as redundant. This sched domain topology is an
> > improvement over previous topologies, or those built without
> > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > With the current scheduler model and heuristics, this is a desirable
> > default topology for Ampere Altra and Altra Max system.
> > 
> > Rather than create a custom sched domains topology structure and
> > introduce new logic in arch/arm64 to detect these systems, update the
> > core_mask so coregroup is never a subset of clustergroup, extending it
> > to cluster_siblings if necessary.
> > 
> > This has the added benefit over a custom topology of working for both
> > symmetric and asymmetric topologies. It does not address systems where
> > the cluster topology is above a populated mc topology, but these are not
> > considered today and can be addressed separately if and when they
> > appear.
> > 
> > The final sched domain topology for a 2 socket Ampere Altra system is
> > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > 
> > For CPU0:
> > 
> > CONFIG_SCHED_CLUSTER=y
> > CLS  [0-1]
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > CONFIG_SCHED_CLUSTER is not set
> > DIE  [0-79]
> > NUMA [0-159]
> > 
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > ---
> > v1: Drop MC level if coregroup weight == 1
> > v2: New sd topo in arch/arm64/kernel/smp.c
> > v3: No new topo, extend core_mask to cluster_siblings
> > 
> >  drivers/base/arch_topology.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> > index 976154140f0b..a96f45db928b 100644
> > --- a/drivers/base/arch_topology.c
> > +++ b/drivers/base/arch_topology.c
> > @@ -628,6 +628,14 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >  			core_mask = &cpu_topology[cpu].llc_sibling;
> >  	}
> >  
> > +	/*
> > +	 * For systems with no shared cpu-side LLC but with clusters defined,
> > +	 * extend core_mask to cluster_siblings. The sched domain builder will
> > +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> > +	 */
> > +	if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > +		core_mask = &cpu_topology[cpu].cluster_sibling;
> > +
> 
> Sudeep, Vincent, are you happy with this now?
> 

It looks good to me. Since I don't have much knowledge on scheduler, I asked
Dietmar to have a look as well just in case if I am missing any other impact.
For now,

Acked-by: Sudeep Holla <sudeep.holla@arm.com>

--
Regards,
Sudeep
