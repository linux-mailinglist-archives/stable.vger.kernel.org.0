Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270D34F2376
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiDEGkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 02:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiDEGkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 02:40:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C162A262;
        Mon,  4 Apr 2022 23:38:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qh7so14520616ejb.11;
        Mon, 04 Apr 2022 23:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTVwwGfd5gW6dvOyGN6tILqjhocBpp2BuslCi0M2GwY=;
        b=atgAr+NvO47dcsXz5odpuvNPIxhtUuBhGr9Dk/HgOQqiT4HkVoeDyghKPEiamYbNKf
         VPQmEvbRNFflwRDbi0jROxf7ZyxWDG61lVbZvP4o++SlVCmTkCkU3X2NavRE2tCwCgcn
         QKNLUgrEa3t7Zb0GNEYxuhmA6LnkY98tycchLYO/gvc8PbPuB5djiVj0XBruf1m/IbH4
         +EEDZ+7K2s95IsJBVQFizE6kvgoX2vtvZOKUR6MjF/t1r1P3XNmTe6rN68IAjXwpo99Z
         5V79OkiHxvxXX+Z8eSi9pCBv/XK2kgxg2HJ23w9t51anj4uV3cXcmS1wSBzQ9Rs79/ul
         6Skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTVwwGfd5gW6dvOyGN6tILqjhocBpp2BuslCi0M2GwY=;
        b=5sj1fruTF1wdV32Lz8IdqlUETgjVMwe2n0H0BKC6F7Z2d42K/qVizpW/ZRfwXNWRVV
         Ifw+dEyvDaKfA0MBmAipkGyM5JP45GTHuIrzJzbQA/A6IvqNq95kZd/AShr8aFLvdWW5
         ffFDL4aZE8YteRaQIC6QFPaNdv0onDFlC8f5s6jzgjT4eOTCKZNDbgFB63S3JlMb9D8c
         5ToEmUnsPoEQ4vHSMaHXwIDpvcfQMdzmrC1dGdD3Y0BODNlDnzvUhZS428fG9GkhURk9
         S8PS/5EYQk4EoNP0sB/bzgqCaYUYTzJNYYc1Tn6RL5mqPyxFZLffXZz3eR3W1BdtYtgz
         GoPA==
X-Gm-Message-State: AOAM530hZ7AnWC7+MPMZHOQO0G0RBslkOT3mpFM7bQ+EuDgWUyLWlR+D
        WYpVCMW7miobnXDp4yJdO2sNhRNeTO6SPKcGC+g=
X-Google-Smtp-Source: ABdhPJxpfSTRKzu7NS9yqYMy9Jji8iIlFpHGclzXqSyGn24O8Uzag1gcBDdJZQ7Y9tBynMIPkRA6BPpAWEhrkZJVz1Y=
X-Received: by 2002:a17:906:2991:b0:6cd:ac19:ce34 with SMTP id
 x17-20020a170906299100b006cdac19ce34mr1986937eje.746.1649140693847; Mon, 04
 Apr 2022 23:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
 <YkupgBs1ybDmofrY@fedora>
In-Reply-To: <YkupgBs1ybDmofrY@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Tue, 5 Apr 2022 18:38:01 +1200
Message-ID: <CAGsJ_4yUJXvLsGAmZ6fpHmccMLanFVVSiod_Agr+Uqzcu83h1g@mail.gmail.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least cluster_siblings
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 5, 2022 at 3:46 PM Darren Hart
<darren@os.amperecomputing.com> wrote:
>
> On Mon, Apr 04, 2022 at 04:40:37PM -0700, Darren Hart wrote:
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
> > to cluster_siblings if necessary. Only do this if CONFIG_SCHED_CLUSTER
> > is enabled to avoid also changing the topology (MC) when
> > CONFIG_SCHED_CLUSTER is disabled.
> >
> > This has the added benefit over a custom topology of working for both
> > symmetric and asymmetric topologies. It does not address systems where
> > the CLUSTER topology is above a populated MC topology, but these are not
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
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > Cc: Carl Worth <carl@os.amperecomputing.com>
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > ---
> > v1: Drop MC level if coregroup weight == 1
> > v2: New sd topo in arch/arm64/kernel/smp.c
> > v3: No new topo, extend core_mask to cluster_siblings
> > v4: Rebase on 5.18-rc1 for GregKH to pull. Add IS_ENABLED(CONFIG_SCHED_CLUSTER).
>
> A bit more context on the state of review:
>
> Several folks reviewed, but I didn't add their Reviewed-by since I added the
> IS_ENABLED(CONFIG_SCHED_CLUSTER) test since they reviewed it last. This change
> preserves the stated intent of the change when CONFIG_SCHED_CLUSTER is disabled.

Everything still works even without IS_ENABLED(CONFIG_SCHED_CLUSTER), right?
Anyway, putting IS_ENABLED(CONFIG_SCHED_CLUSTER) seems to be right as
well.
But it seems it is still a good choice to put all these reviewed-by
and acked-by you got in
v3? I don't  think the added IS_ENABLED will change their decisions.

>
> Barry Song - Suggested this approach
> Vincent Guittot - informal review with reservations
> Sudeep Holla - Acked-by
> Dietmar Eggemann - informal review (added to Cc, apologies for the omission Dietmar)
>
> All but Barry's recommendation captured in the v3 thread:
> https://lore.kernel.org/linux-arm-kernel/f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com/
>
> Thanks,
>
> >
> >  drivers/base/arch_topology.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> > index 1d6636ebaac5..5497c5ab7318 100644
> > --- a/drivers/base/arch_topology.c
> > +++ b/drivers/base/arch_topology.c
> > @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >                       core_mask = &cpu_topology[cpu].llc_sibling;
> >       }
> >
> > +     /*
> > +      * For systems with no shared cpu-side LLC but with clusters defined,
> > +      * extend core_mask to cluster_siblings. The sched domain builder will
> > +      * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> > +      */
> > +     if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> > +         cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > +             core_mask = &cpu_topology[cpu].cluster_sibling;
> > +
> >       return core_mask;
> >  }
> >
> --
> Darren Hart
> Ampere Computing / OS and Kernel

Thanks
Barry
