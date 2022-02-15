Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6264B6939
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiBOKZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:25:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235774AbiBOKZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:25:43 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032A22BC9;
        Tue, 15 Feb 2022 02:25:33 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j2so54705482ybu.0;
        Tue, 15 Feb 2022 02:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvKNjC2n7Pg9Ay5lxi2qRw/3VU9+uDpVZFBQWwKL4zY=;
        b=IiCCSgAyk7HHy1x7VtGkqTT1F5Gw8kj4qcTSZDHKB/G9P9hyXyjT2g2jsAcFWE4qqN
         9kLSAkHvjCp5MPlxm9vUc9gs2YM2PW4ZDQubCQ4xNK4VmnBy/tA1usAQ4clsBFWPljFS
         JBUEVrQ8txKMMqQi8DDJkji5PMRw7oNbtlzuEbn1wLJrRZ4GX5DOrHYvHUVg8Yl3UBCZ
         kLabR6VmXXvgFgW4B0o/DKRwd23NrC+Tln22b5WI3VzZ1AL49+m3MC7PGuLB+5xldsar
         L/TIEQN75srjnkSqJm1NY0n1IODGEzpHAqu45yXGC7y3Vc7/9bqDNc/jGLUcYb/XpQBQ
         PboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvKNjC2n7Pg9Ay5lxi2qRw/3VU9+uDpVZFBQWwKL4zY=;
        b=8AzDrabXUSE+jqJ5JoCfkxg6hNa+SH2h6ttoYpA0WcUIjTvGJMw+8EX2LIRCVZu8dR
         7Aw1bFiCwR/XXbso+TZGIcVEc2yMTyNhmEW6ZgBiphvKyOxmbLj0cz1zUSh3Wx+76Lt4
         I61cslQn3sAtihpLnPw6SxA70krmmUPTE/UnOktJ0Y9Q6RQm9UvjY8S4cjTkWfnmdM9G
         whi11Vl0HcxFMKeA+oXql0K6MoESNRTpHARAzD7MtqxdrctT/6Gf3GAH0ZxLl4ITXbv/
         jn5MuxQAu7NeCqMrLtKhyQuGZYbpVRcbNqa2l+3/7qP/RPDlh/1xs9c1e2E8aPzhJ/SD
         LP1Q==
X-Gm-Message-State: AOAM531BRX6KFrIuYfqzv5runEGhyNXUjKyOvu19XxSsB/aEGLFxbCQx
        btVlLIJSFQiwgN9N3p4dtYIsCUh8PcYXBHk5Ndo=
X-Google-Smtp-Source: ABdhPJyVjSycWuiKVSa2chHexFtxhMXXnYc6v2vI/gCfFEXfUFCIKdSGeV2pRgVzit+GC7xarjGlKHwE3CVkrt+zUsY=
X-Received: by 2002:a81:364f:: with SMTP id d76mr2945539ywa.406.1644920733150;
 Tue, 15 Feb 2022 02:25:33 -0800 (PST)
MIME-Version: 1.0
References: <8c4a69eca4d0591f30c112df59c5098c24923bd3.1644543449.git.darren@os.amperecomputing.com>
 <ec9be4eb7a0548178191edd51ddd309f@hisilicon.com> <Ygai330kyA1yYgj/@fedora>
In-Reply-To: <Ygai330kyA1yYgj/@fedora>
From:   Barry Song <21cnbao@gmail.com>
Date:   Tue, 15 Feb 2022 23:25:22 +1300
Message-ID: <CAGsJ_4yqvXHXxrTe2=yKMMXiSOpc1wCsQT7SVn=9fzg_rWsyhg@mail.gmail.com>
Subject: Re: [PATCH] arm64: smp: Skip MC domain for SoCs without shared cache
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
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

On Tue, Feb 15, 2022 at 12:17 AM Darren Hart
<darren@os.amperecomputing.com> wrote:
>
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
>
> Hi Barry, thanks for the review.
>
> > What kind of resources are clusters sharing on Ampere Altra?
>
> The cluster pairs are DSU pairs (ARM DynamIQ Shared Unit). While there
> is no shared L3 cache, they do share an SCU (snoop control unit) and
> have a cache coherency latency advantage relative to non-DSU pairs.
>
> The Anandtech Altra review illustrates this advantage:
> https://www.anandtech.com/show/16315/the-ampere-altra-review/3
>
> Notably, the SCHED_CLUSTER change did result in marked improvements for
> some interactive workloads.

Thanks. there is a wake_affine patchset, i also wonder if your device can also
benefit from it:
https://lore.kernel.org/lkml/20220126080947.4529-1-yangyicong@hisilicon.com/

>
> > So on Altra, cpus are not sharing LLC? Each LLC is separate
> > for each cpu?
>
> Correct. On the processor side the last level is at each cpu, and then
> there is a memory side SLC (system level cache) that is shared by all
> cpus.

Thanks.

>
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
> > >     }
> > >  }
> > >
> > > +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> > > +#ifdef CONFIG_SCHED_SMT
> > > +   { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > +#endif
> > > +
> > > +#ifdef CONFIG_SCHED_CLUSTER
> > > +   { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> > > +#endif
> > > +   { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > +   { NULL, },
> > > +};
> > > +
> > >  void __init smp_prepare_cpus(unsigned int max_cpus)
> > >  {
> > >     const struct cpu_operations *ops;
> > > +   bool use_no_mc_topology = true;
> > >     int err;
> > >     unsigned int cpu;
> > >     unsigned int this_cpu;
> > > @@ -758,6 +771,25 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > >
> > >             set_cpu_present(cpu, true);
> > >             numa_store_cpu_info(cpu);
> > > +
> > > +           /*
> > > +            * Only use no_mc topology if all cpu_coregroup_mask weights=1
> > > +            */
> > > +           if (cpumask_weight(cpu_coregroup_mask(cpu)) > 1)
> > > +                   use_no_mc_topology = false;
> >
> > This seems to be wrong? If you have 5 cpus,
> > Cpu0 has cpu_coregroup_mask(cpu)== 1, cpu1-4
> > has cpu_coregroup_mask(cpu)== 4, for cpu0, you still
> > need to remove MC, but for cpu1-4, you will need
> > CLS and MC both?
> >
> > This flag shouldn't be global.
>
> Please note that this patch is intended to maintain an identical final
> sched domain construction for a symmetric topology with no shared
> processor-side cache and with cache advantaged clusters and avoid the
> BUG messages since this topology is correct for this architecture.
>
> By using a sched topology without the MC layer, this more accurately
> describes this architecture and does not require changes to
> build_sched_domain(), in particular changes to the assumptions about
> what a valid topology is.
>
> The test above tests every cpu coregroup weight in order to limit the
> impact of this change to this specific kind of topology. It
> intentionally does not address, nor change existing behavior for, the
> assymetrical topology you describe.
>
> I felt this was the less invasive approach and consistent with how other
> architectures handled "non-default" topologies.
>
> If there is interest on working toward a more generic topology builder,
> I'd be interested in working on that too, but I think this change makes
> sense in the near term.

I do agree this patch makes sense for symmetric topology but
asymmetrical topology
is still breaking. it might be better to be more generic. we had a
similar fix over
here for smt before:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.16&id=55409ac5c3

>
> Thanks,
>
> >
> > > +   }
> > > +
> > > +   /*
> > > +    * SoCs with no shared processor-side cache will have cpu_coregroup_mask
> > > +    * weights=1. If they also define clusters with cpu_clustergroup_mask
> > > +    * weights > 1, build_sched_domain() will trigger a BUG as the CLS
> > > +    * cpu_mask will not be a subset of MC. It will extend the MC cpu_mask
> > > +    * to match CLS, and later discard the MC level. Avoid the bug by using
> > > +    * a topology without the MC if the cpu_coregroup_mask weights=1.
> > > +    */
> > > +   if (use_no_mc_topology) {
> > > +           pr_info("cpu_coregroup_mask weights=1, skipping MC topology level");
> > > +           set_sched_topology(arm64_no_mc_topology);
> > >     }
> > >  }
> > >
> > > --
> > > 2.31.1
> >
> >
> > Thanks
> > Barry
> >
>
> --
> Darren Hart
> Ampere Computing / OS and Kernel

Thanks
Barry
