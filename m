Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E837D4B755A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbiBORJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:09:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiBORJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:09:32 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F55911AA1B
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:09:21 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id o2so38207408lfd.1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6Ks1bxyjv4CyjsUd6HI77S/5YTewVrvJUs6SzWTOjs=;
        b=yqQlX4sBb53DUhpeD5yPeajk/6KYmz1xYxhaQjDHT9zrQ9WriJM5QuIT6/gTO7OcHu
         s9RQX6tBFQ858AGmi5lwFg4VMF/Sl3JjqmYEFplzB56n8ZOWOdH0nYXxrIUil+Vx7Ta5
         cBruOk6TqqMLRJ02buSk6hb76XCP+24CzAKSChZvKXPVrfDMIe1wWyTJk/PK4YnEEpFs
         iBX9rp2sdhoGV2ptxxrgPlIKIJTOJRD5/N4erh/L1W2Hlw/aUYtxBZJmUAAyBPat9wh9
         2EZtPfbqfpV8GkWW0Yrg1SdNgK3LUeoMeqjcCvuVvKbCMi748OjcofVdyfQam60PHD0Z
         iDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6Ks1bxyjv4CyjsUd6HI77S/5YTewVrvJUs6SzWTOjs=;
        b=HqfjAy5x283h0gaqX7oAJEqAbP5r3PYgIgvu5Lc2uOsppmWH+pHN8KSoH+6OvpSgUL
         EX2PZLHiSt9X1EGsZ+jlNMeRpIuZQ4MB7Y0u1zPvYG1DCpQaOaURBmt3UedPtRwYp4ox
         XTatlUARVqTxtY5/NhqRW7lojGCuqoEcLZmpTReUQA2EZpApvX5zUQJ/Bi3ntyGPkYaN
         3D2uIDCRWAkJCg8vzwvpL5Ba/FawgDjrED7Dl4xR7brNjOf6vs+p6ttyRMK6ceWxrD7q
         0AqpVK/glI+b00tou1Swj948eGAdW+IU2azwAjkJLgVNQRo3z3Ue1ppiSxp5ZW0aJZOc
         3eUQ==
X-Gm-Message-State: AOAM531emxZ43mqTZ2L1Ttbp7rgU/XiW41G11ULyIvhm0LNVovLBrQPh
        WjG6sePI5WxbkFM191uk5+pYKFkNvbirjgbO5OM73g==
X-Google-Smtp-Source: ABdhPJzUyFGOSo3HgMe/aIzYTZtiyQZdldDyXrRKgvZY6ym40yUafL7FLs22+qoHAc4ISXxWGvv5kN6g6fo8aRcwjes=
X-Received: by 2002:a05:6512:3e14:: with SMTP id i20mr50149lfv.18.1644944959878;
 Tue, 15 Feb 2022 09:09:19 -0800 (PST)
MIME-Version: 1.0
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com> <20220215163858.GA8458@willie-the-truck>
 <YgvYZy5xv1g+u5wp@fedora> <20220215164639.GC8458@willie-the-truck>
In-Reply-To: <20220215164639.GC8458@willie-the-truck>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 15 Feb 2022 18:09:08 +0100
Message-ID: <CAKfTPtAFsL+uqQiGcuh+JJZB=rPrez0=kotq76CVRcBQhcPefg@mail.gmail.com>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
To:     Will Deacon <will@kernel.org>
Cc:     Darren Hart <darren@os.amperecomputing.com>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Feb 2022 at 17:46, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Feb 15, 2022 at 08:44:23AM -0800, Darren Hart wrote:
> > On Tue, Feb 15, 2022 at 04:38:59PM +0000, Will Decon wrote:
> > > On Fri, Feb 11, 2022 at 03:20:51AM +0000, Song Bao Hua (Barry Song) wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Darren Hart [mailto:darren@os.amperecomputing.com]
> > > > > Sent: Friday, February 11, 2022 2:43 PM
> > > > > To: LKML <linux-kernel@vger.kernel.org>; Linux Arm
> > > > > <linux-arm-kernel@lists.infradead.org>
> > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>;
> > > > > Peter Zijlstra <peterz@infradead.org>; Vincent Guittot
> > > > > <vincent.guittot@linaro.org>; Song Bao Hua (Barry Song)
> > > > > <song.bao.hua@hisilicon.com>; Valentin Schneider
> > > > > <valentin.schneider@arm.com>; D . Scott Phillips
> > > > > <scott@os.amperecomputing.com>; Ilkka Koskinen
> > > > > <ilkka@os.amperecomputing.com>; stable@vger.kernel.org
> > > > > Subject: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
> > > > >
> > > > > SoCs such as the Ampere Altra define clusters but have no shared
> > > > > processor-side cache. As of v5.16 with CONFIG_SCHED_CLUSTER and
> > > > > CONFIG_SCHED_MC, build_sched_domain() will BUG() with:
> > > > >
> > > > > BUG: arch topology borken
> > > > >      the CLS domain not a subset of the MC domain
> > > > >
> > > > > for each CPU (160 times for a 2 socket 80 core Altra system). The MC
> > > > > level cpu mask is then extended to that of the CLS child, and is later
> > > > > removed entirely as redundant.
> > > > >
> > > > > This change detects when all cpu_coregroup_mask weights=1 and uses an
> > > > > alternative sched_domain_topology equivalent to the default if
> > > > > CONFIG_SCHED_MC were disabled.
> > > > >
> > > > > The final resulting sched domain topology is unchanged with or without
> > > > > CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > > > >
> > > > > For CPU0:
> > > > >
> > > > > With CLS:
> > > > > CLS  [0-1]
> > > > > DIE  [0-79]
> > > > > NUMA [0-159]
> > > > >
> > > > > Without CLS:
> > > > > DIE  [0-79]
> > > > > NUMA [0-159]
> > > > >
> > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Cc: Will Deacon <will@kernel.org>
> > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > Cc: Vincent Guittot <vincent.guittot@linaro.org>
> > > > > Cc: Barry Song <song.bao.hua@hisilicon.com>
> > > > > Cc: Valentin Schneider <valentin.schneider@arm.com>
> > > > > Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> > > > > Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> > > > > Cc: <stable@vger.kernel.org> # 5.16.x
> > > > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > > >
> > > > Hi Darrent,
> > > > What kind of resources are clusters sharing on Ampere Altra?
> > > > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > > > for each cpu?
> > > >
> > > > > ---
> > > > >  arch/arm64/kernel/smp.c | 32 ++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 32 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > > > index 27df5c1e6baa..0a78ac5c8830 100644
> > > > > --- a/arch/arm64/kernel/smp.c
> > > > > +++ b/arch/arm64/kernel/smp.c
> > > > > @@ -715,9 +715,22 @@ void __init smp_init_cpus(void)
> > > > >         }
> > > > >  }
> > > > >
> > > > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > > > +#ifdef CONFIG_SCHED_SMT
> > > > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > > > +#endif
> > > > > +
> > > > > +#ifdef CONFIG_SCHED_CLUSTER
> > > > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > > > +#endif
> > > > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > > > +       { NULL, },
> > > > > +};
> > > > > +
> > > > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > >  {
> > > > >         const struct cpu_operations *ops;
> > > > > +       bool use_no_mc_topology = true;
> > > > >         int err;
> > > > >         unsigned int cpu;
> > > > >         unsigned int this_cpu;
> > > > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > > > >
> > > > >                 set_cpu_present(cpu, true);
> > > > >                 numa_store_cpu_info(cpu);
> > > > > +
> > > > > +               /*
> > > > > +                * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > > > +                */
> > > > > +               if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > > > +                       use_no_mc_topology = false;
> > > >
> > > > This seems to be wrong? If you have 5 cpus,
> > > > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > > > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > > > need to remove MC, but for cpu1-4, you will need
> > > > CLS and MC both?
> > >
> > > What is the *current* behaviour on such a system?
> > >
> >
> > As I understand it, any system that uses the default topology which has
> > a cpus_coregroup weight of 1 and a child (cluster, smt, ...) weight > 1
> > will behave as described above by printing the following for each CPU
> > matching this criteria:
> >
> >   BUG: arch topology borken
> >         the [CLS,SMT,...] domain not a subset of the MC domain
> >
> > And then extend the MC domain cpumask to match that of the child and continue
> > on.
> >
> > That would still be the behavior for this type of system after this
> > patch is applied.
>
> That's what I thought, but in that case applying your patch is a net
> improvement: systems either get current or better behaviour.

CLUSTER level is normally defined as a intermediate group of the MC
level and both levels have the scheduler flag SD_SHARE_PKG_RESOURCES
flag

In the case of Ampere altra, they consider that CPUA have a CLUSTER
level which SD_SHARE_PKG_RESOURCES with another CPUB but the next and
larger MC level then says that CPUA doesn't SD_SHARE_PKG_RESOURCES
with CPUB which seems to be odd because the SD_SHARE_PKG_RESOURCES has
not disappeared.
Looks like there is a mismatch in topology description


>
> Barry -- why shouldn't we take this as-is?
>
> Will
