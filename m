Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB64CB67A
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 06:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiCCFh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 00:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCCFh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 00:37:28 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B1511172;
        Wed,  2 Mar 2022 21:36:43 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2d6d0cb5da4so43083607b3.10;
        Wed, 02 Mar 2022 21:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsROehGb15uzujM2PzCgG8UTS0qjBbELM0juWwghZpM=;
        b=Bg5bzVvURusIBuct+CrgHOxuJWcR3QCRLKV6JNCaOJjtbPbuue+gkPUt6QGW6W9+MP
         PKc6TExN6RZGQvUpBGC6JKia8+fDgvk4rDNZRK0tEaJf6jvlpqbqACRQRiOggq0KEgjR
         sgyWqaP2+duhZYpQqk+EDLaMfkZn71/TL9AGUJr2U6gg53H3AX9xIKK6GICgx5GQkqkX
         3CR5l1czEgSV21i1H1ZtKZ2kWvy7MWUDc3qzn3QTNlqekHFdFv0I3VO0CiaCvCVe/afP
         0XQz1NzCGskt2p6In26lIdoGu4yRWJON7WVX/+epXkAE4Zfu6oNdDqU5xOmJ9EWgFMsR
         IRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsROehGb15uzujM2PzCgG8UTS0qjBbELM0juWwghZpM=;
        b=qFDhfVjAWzL2NVp9oFJVf13IcrexUIfoylxvOCpj0FX7/9J0yAxHarjNm4mk8SXlNR
         DSI5y8CeE9Unu7KIa01Z4qGT7WWWGuvLxxvjQ3hz+Y2fb4Xu++UChOa7hKT3DP1TJ5+b
         MFT/EXYXm52z7TUXpoiYEx/NLjFs77heQkfUcGfTOhr3khOjYnk06dqO1ANEQsd8R91v
         5Vm+hFznX6A3ngueE/SSvhUF7JNcI/1tRm209LAPJ1jJaWV4jbmy/KLsGR4JojjBSNFx
         xpgJlBxOujfaeQwrlO2kaLtSpGHaPCvlVmv/ZhEqI3dhuH0qgoFFgqyOYgNkNfBhMaRY
         TV+g==
X-Gm-Message-State: AOAM530V1tFEjgqubP3ahTpYyGWAlv/7va4mrILgOErtkcu7cBd32rQa
        2FsqNErZHsI6LCN5C1fim1iFWzYUYspxj2+aP6A=
X-Google-Smtp-Source: ABdhPJwPdb708TqKzYhamCU/7+sIf74W8l5XZOqj/GfJ2bYzk6b7M5KBrFpQy4lxmp8WyMIjAOzIsGLVYVQ11oXOBQU=
X-Received: by 2002:a0d:dcc3:0:b0:2d1:44a4:14be with SMTP id
 f186-20020a0ddcc3000000b002d144a414bemr33150980ywe.76.1646285802442; Wed, 02
 Mar 2022 21:36:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1646094455.git.darren@os.amperecomputing.com>
 <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
 <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com> <YiAlfGuRXWVnOmyF@fedora>
In-Reply-To: <YiAlfGuRXWVnOmyF@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Thu, 3 Mar 2022 18:36:30 +1300
Message-ID: <CAGsJ_4y8MkQhAZ9c9yz_UHee7MCZrtv3aui=Luq-ZOBeAsGbGQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: smp: Skip MC sched domain on SoCs with no LLC
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 3, 2022 at 3:22 PM Darren Hart
<darren@os.amperecomputing.com> wrote:
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
>
> Quickly tested on Altra successfully. Would appreciate anyone with non-acpi
> arm64 systems who can test and verify this behaves as intended. I will ask
> around tomorrow as well to see what I may have access to.

I wonder if we can fix it by this

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 976154140f0b..551655ccd0eb 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -627,6 +627,13 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
                if (cpumask_subset(&cpu_topology[cpu].llc_sibling, core_mask))
                        core_mask = &cpu_topology[cpu].llc_sibling;
        }
+       /*
+        * Some machines have no LLC but have clusters, we let MC = CLUSTER
+        * as MC should always be after CLUSTER. But anyway, the MC domain
+        * will be removed
+        */
+       if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
+               core_mask = &cpu_topology[cpu].cluster_sibling;

        return core_mask;
 }

as it can make all kinds of topologies happy -  symmetric and asymmetric.

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

Thanks
Barry
