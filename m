Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72394D1598
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 12:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiCHLGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 06:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345976AbiCHLGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 06:06:03 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2821A43AD5
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 03:05:06 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id r4so5834411lfr.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 03:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HiFFHplwuG4zm1Rr+rVXkq22q8xtVPCcUR+EBSBuBs=;
        b=BGr5gudFns+UxCKjsQxhMavcMBe9ynwXAs/M919w79Ifw9WRIjpwGj4F5pQ2vd6aly
         /HhoIl7QqL2wCGyA9eRHQPlE9TogbzHwCrDLGc9T1w6gbmlPFxUM4f77j9qRk7pRb7ej
         qZfMJOVeyZPPbv2JLJ3nb2A/sOiWrjJVYtS80J0uHt5rJT99Bs9CC76H8JsnVBlrEZAp
         /g0K94ZDw5uakcvk+dZjWXFxIks/C2qJf9QVWf7+mhB+dtGkiDEPIZpXfytDq0OR8q61
         DkXsC7v7eT2HofrRp2KgHHEb0uPWROHHLr7UQ/dipzdBxNYn0R6JQZpqk4VfUeXkLuRL
         At3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HiFFHplwuG4zm1Rr+rVXkq22q8xtVPCcUR+EBSBuBs=;
        b=3CJNEVvKdXGFHZbCCF7RznRlDISnvQN+jBRyeUwI0rdJCGRyQw1cmWz9tTqGQ+RNmW
         +en035XOOGXuDqW7bC0VlAlzF0W8dg/l/NGrTxSuloetVzkXg86mQcfAWsz7hx5pqz9g
         rNZCClLaIFBPVZ6TGJu0h6M54zvFAU9GPVizuE2g32FpJHAOS5kMwNU1+9BWGTzAILxz
         omyI2q4M6SgKSmIediVK839Zb8og5hY2z7RSaJl7ff4CrFJRphKmJoArQ1MeTcXQQfaz
         TrPyrMHIBUgaoklYELl9cQqiChjVbMFSB7dz20CegPY9npoWQeFDZ+U2xM4k4JfdX3qy
         +TOQ==
X-Gm-Message-State: AOAM532sF9SwoSfodP7CuMv2puEoXgXpBhUnQKXX2vXJnorCBjnu/DAX
        wPySOSM3ta/Fc1uXXJpRsXOSXMrK9q5CqCPvRu43/A==
X-Google-Smtp-Source: ABdhPJzMSPfYAe3/8DHXx462DQKzkgcDKQrfjbA/wFGR/EONugZQ+vumURU7BkE6gCAGNvWN0MrFXJZkJinJj40S2gg=
X-Received: by 2002:a05:6512:6ce:b0:448:46c6:b93e with SMTP id
 u14-20020a05651206ce00b0044846c6b93emr996065lff.46.1646737504364; Tue, 08 Mar
 2022 03:05:04 -0800 (PST)
MIME-Version: 1.0
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
In-Reply-To: <20220308103012.GA31267@willie-the-truck>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 8 Mar 2022 12:04:53 +0100
Message-ID: <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
Subject: Re: [PATCH v3] topology: make core_mask include at least cluster_siblings
To:     Will Deacon <will@kernel.org>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
>
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
> >                       core_mask = &cpu_topology[cpu].llc_sibling;
> >       }
> >
> > +     /*
> > +      * For systems with no shared cpu-side LLC but with clusters defined,
> > +      * extend core_mask to cluster_siblings. The sched domain builder will
> > +      * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> > +      */
> > +     if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > +             core_mask = &cpu_topology[cpu].cluster_sibling;
> > +
>
> Sudeep, Vincent, are you happy with this now?

I would not say that I'm happy because this solution skews the core
cpu mask in order to abuse the scheduler so that it will remove a
wrong but useless level when it will build its domains.
But this works so as long as the maintainer are happy, I'm fine

>
> Will
