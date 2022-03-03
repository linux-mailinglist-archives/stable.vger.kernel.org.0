Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF684CB86D
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 09:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiCCIJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 03:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiCCIJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 03:09:47 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE50170D5D
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 00:08:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bu29so7149323lfb.0
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 00:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=39vNSfl9IWg0yQTlFDMmjjhS46qgKyYB03/z5TZfFH0=;
        b=bup0EM/iTQipcqIMdDSA0O0Pr+5iariGvomc7sT97T2WPPFFQX/eW5n3CKy4f3uMTL
         F0VBXdkIsEDnubkOIz5DWXkqIUC0RPU6M035tF4XXCzOL8GFdapIXUnyRZAdxPLcWibb
         Qs8THxVRSNHgIwe3zQPCpFHWnr0xtFX4TnXXG4StNAUegOacF4k7VU8pHiM8WcDrw06K
         bcnKtE9N/x7FWUuFH5IO+0K6TWfXEIIhKZCyLKlLjlZmkewuMZmBO6ag0jPXwcFpu0SG
         aY2/AhCyD9cDdsK+aO50LokVDbYSKlqCYgNRAwk18UP4PIL+EvO+y1sLCAmAt0dxj4ic
         zlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39vNSfl9IWg0yQTlFDMmjjhS46qgKyYB03/z5TZfFH0=;
        b=osvRdtq86yfxGmkS9Koi+ipX7IrUyxtW6qC9ObS9HhGu6YnNE+cbIoxndOmC+laCD4
         2KlloeGbnR1r/D6vq8gu07Udt56DuXFC7HqT3Ad4zfmfpt44MQOpqgPXptAbI73TCHQq
         CyYp/OqDETpPaI9VEHBEwD/k11vKp5AdgwT4jNsDP5oAtc/hQcoBVjMgSRbXN0ju7Zij
         w+5F0bjYZAT3H1z1Wo/dnRxJflRq68LVF5fz3W8yjTqhvQgIAbBk3BT+svacddURZgDA
         eR9CQSpt7VrYYSX1XjcrHYxcTnhChVvzNUtGcAYcAGRP3epbS3ISv60KZvU0wbNYNCvS
         Vrgg==
X-Gm-Message-State: AOAM530b6t+ZZwc8C8g0pUQgX2mTxTeuPWqk/hsKSfRxfrPYC5OITbBP
        apUx6QRuNUIK0hiG0t0SGhf4c9HFUL8WKHCjJGQs+QQ9WVw=
X-Google-Smtp-Source: ABdhPJw1b8yDoqH+lNkBzCaPuSWFXmeztJczAYhbE8789NaSv6LBhNZmdaB5O8cGQ0KrNiRxrLU0sEcSZvmx2HCyUpc=
X-Received: by 2002:a19:3801:0:b0:444:150b:9ef5 with SMTP id
 f1-20020a193801000000b00444150b9ef5mr19939004lfa.523.1646294929984; Thu, 03
 Mar 2022 00:08:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com> <YiAlfGuRXWVnOmyF@fedora>
In-Reply-To: <YiAlfGuRXWVnOmyF@fedora>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Thu, 3 Mar 2022 09:08:38 +0100
Message-ID: <CAKfTPtBbu3fUMBkXLszWGtaHkf4DRU+J+9z_2MZ42iCTAtLGkw@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: smp: Skip MC sched domain on SoCs with no LLC
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
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

On Thu, 3 Mar 2022 at 03:18, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> On Wed, Mar 02, 2022 at 10:32:06AM +0100, Vincent Guittot wrote:
> > On Tue, 1 Mar 2022 at 01:35, Darren Hart <darren@os.amperecomputing.com> wrote:
> > >
> > > Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> > > Control Unit, but have no shared CPU-side last level cache.
> > >
> > > cpu_coregroup_mask() will return a cpumask with weight 1, while
> > > cpu_clustergroup_mask() will return a cpumask with weight 2.
> > >
> > > As a result, build_sched_domain() will BUG() once per CPU with:
> > >
> > > BUG: arch topology borken
> > >      the CLS domain not a subset of the MC domain
> > >
> > > The MC level cpumask is then extended to that of the CLS child, and is
> > > later removed entirely as redundant. This sched domain topology is an
> > > improvement over previous topologies, or those built without
> > > SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> > > With the current scheduler model and heuristics, this is a desirable
> > > default topology for Ampere Altra and Altra Max system.
> > >
> > > Introduce an alternate sched domain topology for arm64 without the MC
> > > level and test for llc_sibling weight 1 across all CPUs to enable it.
> > >
> > > Do this in arch/arm64/kernel/smp.c (as opposed to
> > > arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
> > > populated and we avoid needing to extend the drivers/acpi/pptt.c API to
> > > detect the cluster level being above the cpu llc level. This is
> > > consistent with other architectures and provides a readily extensible
> > > mechanism for other alternate topologies.
> > >
> > > The final sched domain topology for a 2 socket Ampere Altra system is
> > > unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
> > >
> > > For CPU0:
> > >
> > > CONFIG_SCHED_CLUSTER=y
> > > CLS  [0-1]
> > > DIE  [0-79]
> > > NUMA [0-159]
> > >
> > > CONFIG_SCHED_CLUSTER is not set
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
> > > ---
> > >  arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
> > >  1 file changed, 28 insertions(+)
> > >
> > > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > > index 27df5c1e6baa..3597e75645e1 100644
> > > --- a/arch/arm64/kernel/smp.c
> > > +++ b/arch/arm64/kernel/smp.c
> > > @@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
> > >         }
> > >  }
> > >
> > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > +#ifdef CONFIG_SCHED_SMT
> > > +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > +#endif
> > > +
> > > +#ifdef CONFIG_SCHED_CLUSTER
> > > +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > +#endif
> > > +
> > > +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > +       { NULL, },
> > > +};
> > > +
> > > +static void __init update_sched_domain_topology(void)
> > > +{
> > > +       int cpu;
> > > +
> > > +       for_each_possible_cpu(cpu) {
> > > +               if (cpu_topology[cpu].llc_id != -1 &&
> >
> > Have you tested it with a non-acpi system ? AFAICT, llc_id is only set
> > by ACPI system and  llc_id == -1 for others like DT based system
> >
> > > +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> > > +                       return;
> > > +       }
>
> Hi Vincent,
>
> I did not have a non-acpi system to test, no. You're right of course,
> llc_id is only set by ACPI systems on arm64. We could wrap this in a
> CONFIG_ACPI ifdef (or IS_ENABLED), but I think this would be preferable:
>
> +       for_each_possible_cpu(cpu) {
> +               if (cpu_topology[cpu].llc_id == -1 ||
> +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> +                       return;
> +       }

This works.
Also , do you really need to loop on all possible cpus ? Would it be
enough to check only the 1st cpu ?
You won't be able to support a mixed topology so all cpus have the
same kind of topology i.e either cluster before or cluster before the
MC level


>
> Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
> arm64 systems who can test and verify this behaves as intended. I will ask
> around tomorrow as well to see what I may have access to.
>
> Thanks,
>
> > > +
> > > +       pr_info("No LLC siblings, using No MC sched domains topology\n");
> > > +       set_sched_topology(arm64_no_mc_topology);
> > > +}
> > > +
> > >  void __init smp_cpus_done(unsigned int max_cpus)
> > >  {
> > >         pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
> > > @@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
> > >         hyp_mode_check();
> > >         apply_alternatives_all();
> > >         mark_linear_text_alias_ro();
> > > +       update_sched_domain_topology();
> > >  }
> > >
> > >  void __init smp_prepare_boot_cpu(void)
> > > --
> > > 2.31.1
> > >
>
> --
> Darren Hart
> Ampere Computing / OS and Kernel
