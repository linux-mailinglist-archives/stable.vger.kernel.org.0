Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB94DBF52
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 07:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiCQGVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 02:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiCQGVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 02:21:35 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B86131942;
        Wed, 16 Mar 2022 23:10:33 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id z8so8388175ybh.7;
        Wed, 16 Mar 2022 23:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VR1NhHDBNWvTmsBrOFP6HJbH1ggjLumhtoOfnuEXWKI=;
        b=fu4hQROzacXnjEwEickLat//Rsxu9Mg2FA2L9aNavavKzn0dy5RrL8/eZ8e2nZF3bv
         fVW2xyaDnnwnoC0HgYzzqDf09WFCtCDRjgFQPFkVSLXbiDLAJVHOjSXybUgX449Pw7eT
         Q2hxqjQvk5Ms4SAMC/5SebEIT7IGnNuzkKTZkdxBvHReCBY5is2qRUoczKFGn7vFMt7Z
         xWnHJ8ehuz1yo5/EBZY95KOoGP0rjCQWHC5goHSZNz0f+2JZEbtWneqri0DerNcbrjxG
         2N5hVUQwtat2x1LfXr9o4w4e017Jzf03v8joZg+SU0MHa/Zl03jK6+N/OuWOI0SwIRu4
         s5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VR1NhHDBNWvTmsBrOFP6HJbH1ggjLumhtoOfnuEXWKI=;
        b=oxi4u5knUQTV9ogG9CfMlIS1xBJH0yeGBfxGypQR7F4/VWux0WN1EHzYzTw12uSbW5
         QW30Ye+0tuvWMcJjjkWMNsFDE5gC2akIEaW4T8iR3dcAgl2199SrY1HlPYymZvKUvgy6
         jBYMnxiXP4qTR6Ff56Ha6xrnPFp6McU5yr19OLvkxhmpBdbjXd2/uHoeOVGV1Pd0izh6
         QfM+NSU7R+kq21wiZdd8cPOH/k5Jb7mjjU5aUcamNnrnMIiF1C/3HR8mGyqmPheEB1B+
         A20HjAjQqmiRU8wWl3o3rrBrpo9QB+OtRciZMZHqhU24LjIWH7cr7z1uGIHITBjLJhPH
         PS1A==
X-Gm-Message-State: AOAM530wFEl3YTWrahrkAgOkPogwHrP1RD8RH6NfNrBpadZXaIDFpAXy
        rueVfEpZSNbRDy9JqpW2NQE0xdLjtcJlqIWca4k=
X-Google-Smtp-Source: ABdhPJzQqgUkL5oq0fuMuFq3UxEvtkIDlfD5E6dHXD5tJDQpxFdTJEw7TX0b6u6guiTEMMBwB50+ZyiQdXb65QCDXvs=
X-Received: by 2002:a05:6902:13c1:b0:61d:969c:109c with SMTP id
 y1-20020a05690213c100b0061d969c109cmr3275233ybu.133.1647497432674; Wed, 16
 Mar 2022 23:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
In-Reply-To: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
From:   Barry Song <21cnbao@gmail.com>
Date:   Thu, 17 Mar 2022 19:10:19 +1300
Message-ID: <CAGsJ_4x-ZmAfAGBmAY6HoWNGuCVc945Er4v337eGHR_zLcCHFQ@mail.gmail.com>
Subject: Re: [PATCH v3] topology: make core_mask include at least cluster_siblings
To:     Darren Hart <darren@os.amperecomputing.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
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

On Sat, Mar 5, 2022 at 8:54 AM Darren Hart
<darren@os.amperecomputing.com> wrote:
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
> the CLS domain not a subset of the MC domain
>
> The MC level cpumask is then extended to that of the CLS child, and is
> later removed entirely as redundant. This sched domain topology is an
> improvement over previous topologies, or those built without
> SCHED_CLUSTER, particularly for certain latency sensitive workloads.
> With the current scheduler model and heuristics, this is a desirable
> default topology for Ampere Altra and Altra Max system.
>
> Rather than create a custom sched domains topology structure and
> introduce new logic in arch/arm64 to detect these systems, update the
> core_mask so coregroup is never a subset of clustergroup, extending it
> to cluster_siblings if necessary.
>
> This has the added benefit over a custom topology of working for both
> symmetric and asymmetric topologies. It does not address systems where
> the cluster topology is above a populated mc topology, but these are not
> considered today and can be addressed separately if and when they
> appear.
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
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Barry Song <song.bao.hua@hisilicon.com>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: D. Scott Phillips <scott@os.amperecomputing.com>
> Cc: Ilkka Koskinen <ilkka@os.amperecomputing.com>
> Cc: <stable@vger.kernel.org> # 5.16.x
> Suggested-by: Barry Song <song.bao.hua@hisilicon.com>
> Signed-off-by: Darren Hart <darren@os.amperecomputing.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
> v1: Drop MC level if coregroup weight == 1
> v2: New sd topo in arch/arm64/kernel/smp.c
> v3: No new topo, extend core_mask to cluster_siblings
>
>  drivers/base/arch_topology.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> index 976154140f0b..a96f45db928b 100644
> --- a/drivers/base/arch_topology.c
> +++ b/drivers/base/arch_topology.c
> @@ -628,6 +628,14 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>                         core_mask = &cpu_topology[cpu].llc_sibling;
>         }
>
> +       /*
> +        * For systems with no shared cpu-side LLC but with clusters defined,
> +        * extend core_mask to cluster_siblings. The sched domain builder will
> +        * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> +        */
> +       if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> +               core_mask = &cpu_topology[cpu].cluster_sibling;
> +
>         return core_mask;
>  }
>
> --
> 2.31.1
>

Thanks
Barry
