Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1F4CA0E8
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 10:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiCBJdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 04:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240602AbiCBJdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 04:33:03 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A34ABBE23
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 01:32:19 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e8so1412605ljj.2
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 01:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIpukTDM3EyGXViKLz48CUp8pNF84gmEDMr49elfJeA=;
        b=mnhvVdTXmdueW9b1eG6ELQB60LkR9m6eO0dKubKvX3Z9e8gAyXxoJHqy3s2NkXZzcx
         OQyUxd9rhKhZo5jyx8O7uZd8w1kAUzGANSqHruEJhm8EtQs5UC+HxR2vQRYej/kETgfj
         m27nYuNIvT++0KRQ/I5Ya12qGo4Pdyi2bgAVbFHXhBaouDoF/Jrfp3gc2ftTa+MdIBVD
         o8+F/sZNLNFsov3m32ropp1kxf5loVmApklud7aEEyIEEWemS0JfWE0yqw1aCGwqsPDV
         JAIY9RgOQZsx6bfvYo8XeUZN738sSC6dpwmxvQ5riHAzXBD8OjnjGRnPVNt8ACUG1qQI
         iVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIpukTDM3EyGXViKLz48CUp8pNF84gmEDMr49elfJeA=;
        b=joehxYb80FXcWUDecqspCzse+uDRWS3VWQgpfqsrpWfe/ZOYS18CqqWOkZ9HAlQyKC
         odmw8se0GZXPiANd2R0MEyg4ocThByb6EUU7sLLT0Tt+XguK5oWyCr+gvQryuCW+axnC
         R/NyMT1/rjCXvJW2UfM4p3rsq15TJBxt7GtS5o/foV/UntBGjP8vJ+eBbyh9dEp9IQH9
         0QNqC0pcd8qtkYVilmh1B6smLQ148VSA2Dk3IziqdTs3I7qoYKkHQ5IgVDbfloy6/iFZ
         1xgxKLziCzmQVKH+W0bT41fRyfBoQFgcjJ7KrjFr2Bvk9Q8lHZ/ZP0CGwJHZQQcTmdM4
         O5TQ==
X-Gm-Message-State: AOAM530mZIo2TJFX3dO1GfwR7GC/+4Wa/dVUbQoH+X6XoSLt+CxNypHN
        sKGG9A4ku2PRtCgFsxjNk/XnlTcdDuS52ML/fhBCHg==
X-Google-Smtp-Source: ABdhPJzw05xSQUr8sv5tybez7a1UjA08ZX3+IphDDor9JPMxpPIYk2AbEVoc+Zme1c+SaC6Y7Q+yLEZUCS8iGRWWqJU=
X-Received: by 2002:a05:651c:990:b0:240:752f:a224 with SMTP id
 b16-20020a05651c099000b00240752fa224mr19983426ljq.266.1646213537916; Wed, 02
 Mar 2022 01:32:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1646094455.git.darren@os.amperecomputing.com> <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
In-Reply-To: <84e7cb911936f032318b6b376cf88009c90d93d5.1646094455.git.darren@os.amperecomputing.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 2 Mar 2022 10:32:06 +0100
Message-ID: <CAKfTPtAQwJYy4UDAgF3Va_MJTDj+UpxuU3UqTWZ5gjwmcTf5wA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Mar 2022 at 01:35, Darren Hart <darren@os.amperecomputing.com> wrote:
>
> Ampere Altra defines CPU clusters in the ACPI PPTT. They share a Snoop
> Control Unit, but have no shared CPU-side last level cache.
>
> cpu_coregroup_mask() will return a cpumask with weight 1, while
> cpu_clustergroup_mask() will return a cpumask with weight 2.
>
> As a result, build_sched_domain() will BUG() once per CPU with:
>
> BUG: arch topology borken
>      the CLS domain not a subset of the MC domain
>
> The MC level cpumask is then extended to that of the CLS child, and is
> later removed entirely as redundant. This sched domain topology is an
> improvement over previous topologies, or those built without
> SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> With the current scheduler model and heuristics, this is a desirable
> default topology for Ampere Altra and Altra Max system.
>
> Introduce an alternate sched domain topology for arm64 without the MC
> level and test for llc_sibling weight 1 across all CPUs to enable it.
>
> Do this in arch/arm64/kernel/smp.c (as opposed to
> arch/arm64/kernel/topology.c) as all the CPU sibling maps are now
> populated and we avoid needing to extend the drivers/acpi/pptt.c API to
> detect the cluster level being above the cpu llc level. This is
> consistent with other architectures and provides a readily extensible
> mechanism for other alternate topologies.
>
> The final sched domain topology for a 2 socket Ampere Altra system is
> unchanged with or without CONFIG_SCHED_CLUSTER, and the BUG is avoided:
>
> For CPU0:
>
> CONFIG_SCHED_CLUSTER=y
> CLS  [0-1]
> DIE  [0-79]
> NUMA [0-159]
>
> CONFIG_SCHED_CLUSTER is not set
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
> ---
>  arch/arm64/kernel/smp.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 27df5c1e6baa..3597e75645e1 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -433,6 +433,33 @@ static void __init hyp_mode_check(void)
>         }
>  }
>
> +static struct sched_domain_topology_level arm64_no_mc_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +       { cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> +#endif
> +
> +#ifdef CONFIG_SCHED_CLUSTER
> +       { cpu_clustergroup_mask, cpu_cluster_flags, SD_INIT_NAME(CLS) },
> +#endif
> +
> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +       { NULL, },
> +};
> +
> +static void __init update_sched_domain_topology(void)
> +{
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               if (cpu_topology[cpu].llc_id != -1 &&

Have you tested it with a non-acpi system ? AFAICT, llc_id is only set
by ACPI system and  llc_id == -1 for others like DT based system

> +                   cpumask_weight(&cpu_topology[cpu].llc_sibling) > 1)
> +                       return;
> +       }
> +
> +       pr_info("No LLC siblings, using No MC sched domains topology\n");
> +       set_sched_topology(arm64_no_mc_topology);
> +}
> +
>  void __init smp_cpus_done(unsigned int max_cpus)
>  {
>         pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
> @@ -440,6 +467,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
>         hyp_mode_check();
>         apply_alternatives_all();
>         mark_linear_text_alias_ro();
> +       update_sched_domain_topology();
>  }
>
>  void __init smp_prepare_boot_cpu(void)
> --
> 2.31.1
>
