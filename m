Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5117760201F
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJRBFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJRBFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:05:11 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6937B1EC
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:05:05 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id k3so15244027ybk.9
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eQCfqscqzNBxELvowdNNs0ma/7asNhj+qVzhKhnJnDE=;
        b=jNf1p2CbV+fl61r8bbxrmviDcypw33+1Rz5+FbUa6io+zWENnUt3Sow1fzHwy+qrIg
         MfF10tohSqggysbYUWAO2d9LPBEa7WVfo4KrfIyHYQtFnfr+ZVBV9asZZR7dl3JI36AZ
         MOPZrgJC0EECXU7l423ikOUozvyHP1M/6w/91zy69nZccFbLsrkDCV2OdMaPJ2ZOoOAa
         xzu2IzXwCBuUT8wrgBJN/SaY4oBgsVGnY6rtqQJJMFwRvjC6EINmbXuNmL4RWFOg5JWv
         UouVbfymwhyRCHTdFhoCk37BqJHHrt8GTWvgoXSvTduIlvbFEZ1AldNXeDGbtxWp0Xye
         4rmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQCfqscqzNBxELvowdNNs0ma/7asNhj+qVzhKhnJnDE=;
        b=yQ+qWAg5eipWN3V7u5yxc2lkN5MczzIaVec5EmMcuguUyiTmWTaClIXzBZajfx2SBA
         bjhYysnBdF2kC12fin56ttPsIqRPTUUDdqndo6sTRsINyhBNa8WHK8+utCW8WcEUkbv9
         dBxmFDFYjHekfzIjNYZiVyOaJ+Sm6USdz/tlcYUHG2n5FmJewE93r+UXlgjoMyr6lBU1
         IcQY071Ga2OKB51oIz3je/w4yB9il3ASnR6RCGUqmSeD92J6hkVDtWa8FERCoMIkHhSy
         z1n0lk5T7FQcRrabphxMOm/c0a1tvTDLN4yQ+sxlMWaoLv7i8Sb5mU3NKKP//Wf2Fg4Y
         np1Q==
X-Gm-Message-State: ACrzQf2fsPUJv9foRkHLS0nHwp+RAgQ1eJKeSwjwzdrJrK/PB4y2oCMs
        c6HwlD8qaAx6sRVjnoDxFxjoixhnZWE7+jtMRCoTOg==
X-Google-Smtp-Source: AMsMyM6R8N6NdW53GBrILF5vH+gQ9kXLIE543YHFar3pJqTF5MZkwHwG2d9E7ZdX1Wx0B3leY2Th6WZUZy1qioVyHTU=
X-Received: by 2002:a25:c242:0:b0:6b0:1bd:754a with SMTP id
 s63-20020a25c242000000b006b001bd754amr372335ybf.125.1666055104849; Mon, 17
 Oct 2022 18:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221018000839.2730954-1-sashal@kernel.org> <20221018000839.2730954-5-sashal@kernel.org>
In-Reply-To: <20221018000839.2730954-5-sashal@kernel.org>
From:   Marco Elver <elver@google.com>
Date:   Mon, 17 Oct 2022 18:04:28 -0700
Message-ID: <CANpmjNMH9jr4nMpjcq8AZj3K-frtB6=WNbk+EY5-3_89YGrtaA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.19 05/29] powerpc/hw_breakpoint: Avoid relying
 on caller synchronization
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Oct 2022 at 17:08, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Marco Elver <elver@google.com>
>
> [ Upstream commit f95e5a3d59011eec1257d0e76de1e1f8969d426f ]
>
> Internal data structures (cpu_bps, task_bps) of powerpc's hw_breakpoint
> implementation have relied on nr_bp_mutex serializing access to them.
>
> Before overhauling synchronization of kernel/events/hw_breakpoint.c,
> introduce 2 spinlocks to synchronize cpu_bps and task_bps respectively,
> thus avoiding reliance on callers synchronizing powerpc's hw_breakpoint.
>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Marco Elver <elver@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Acked-by: Ian Rogers <irogers@google.com>
> Link: https://lore.kernel.org/r/20220829124719.675715-10-elver@google.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Backporting this patch seems unnecessary if we're not backporting the
hw_breakpoint overhaul.

Without the overhaul, nothing will break without this patch.

Thanks,
-- Marco

> ---
>  arch/powerpc/kernel/hw_breakpoint.c | 53 ++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 13 deletions(-)
>
> diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
> index 2669f80b3a49..8db1a15d7acb 100644
> --- a/arch/powerpc/kernel/hw_breakpoint.c
> +++ b/arch/powerpc/kernel/hw_breakpoint.c
> @@ -15,6 +15,7 @@
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/smp.h>
> +#include <linux/spinlock.h>
>  #include <linux/debugfs.h>
>  #include <linux/init.h>
>
> @@ -129,7 +130,14 @@ struct breakpoint {
>         bool ptrace_bp;
>  };
>
> +/*
> + * While kernel/events/hw_breakpoint.c does its own synchronization, we cannot
> + * rely on it safely synchronizing internals here; however, we can rely on it
> + * not requesting more breakpoints than available.
> + */
> +static DEFINE_SPINLOCK(cpu_bps_lock);
>  static DEFINE_PER_CPU(struct breakpoint *, cpu_bps[HBP_NUM_MAX]);
> +static DEFINE_SPINLOCK(task_bps_lock);
>  static LIST_HEAD(task_bps);
>
>  static struct breakpoint *alloc_breakpoint(struct perf_event *bp)
> @@ -174,7 +182,9 @@ static int task_bps_add(struct perf_event *bp)
>         if (IS_ERR(tmp))
>                 return PTR_ERR(tmp);
>
> +       spin_lock(&task_bps_lock);
>         list_add(&tmp->list, &task_bps);
> +       spin_unlock(&task_bps_lock);
>         return 0;
>  }
>
> @@ -182,6 +192,7 @@ static void task_bps_remove(struct perf_event *bp)
>  {
>         struct list_head *pos, *q;
>
> +       spin_lock(&task_bps_lock);
>         list_for_each_safe(pos, q, &task_bps) {
>                 struct breakpoint *tmp = list_entry(pos, struct breakpoint, list);
>
> @@ -191,6 +202,7 @@ static void task_bps_remove(struct perf_event *bp)
>                         break;
>                 }
>         }
> +       spin_unlock(&task_bps_lock);
>  }
>
>  /*
> @@ -200,12 +212,17 @@ static void task_bps_remove(struct perf_event *bp)
>  static bool all_task_bps_check(struct perf_event *bp)
>  {
>         struct breakpoint *tmp;
> +       bool ret = false;
>
> +       spin_lock(&task_bps_lock);
>         list_for_each_entry(tmp, &task_bps, list) {
> -               if (!can_co_exist(tmp, bp))
> -                       return true;
> +               if (!can_co_exist(tmp, bp)) {
> +                       ret = true;
> +                       break;
> +               }
>         }
> -       return false;
> +       spin_unlock(&task_bps_lock);
> +       return ret;
>  }
>
>  /*
> @@ -215,13 +232,18 @@ static bool all_task_bps_check(struct perf_event *bp)
>  static bool same_task_bps_check(struct perf_event *bp)
>  {
>         struct breakpoint *tmp;
> +       bool ret = false;
>
> +       spin_lock(&task_bps_lock);
>         list_for_each_entry(tmp, &task_bps, list) {
>                 if (tmp->bp->hw.target == bp->hw.target &&
> -                   !can_co_exist(tmp, bp))
> -                       return true;
> +                   !can_co_exist(tmp, bp)) {
> +                       ret = true;
> +                       break;
> +               }
>         }
> -       return false;
> +       spin_unlock(&task_bps_lock);
> +       return ret;
>  }
>
>  static int cpu_bps_add(struct perf_event *bp)
> @@ -234,6 +256,7 @@ static int cpu_bps_add(struct perf_event *bp)
>         if (IS_ERR(tmp))
>                 return PTR_ERR(tmp);
>
> +       spin_lock(&cpu_bps_lock);
>         cpu_bp = per_cpu_ptr(cpu_bps, bp->cpu);
>         for (i = 0; i < nr_wp_slots(); i++) {
>                 if (!cpu_bp[i]) {
> @@ -241,6 +264,7 @@ static int cpu_bps_add(struct perf_event *bp)
>                         break;
>                 }
>         }
> +       spin_unlock(&cpu_bps_lock);
>         return 0;
>  }
>
> @@ -249,6 +273,7 @@ static void cpu_bps_remove(struct perf_event *bp)
>         struct breakpoint **cpu_bp;
>         int i = 0;
>
> +       spin_lock(&cpu_bps_lock);
>         cpu_bp = per_cpu_ptr(cpu_bps, bp->cpu);
>         for (i = 0; i < nr_wp_slots(); i++) {
>                 if (!cpu_bp[i])
> @@ -260,19 +285,25 @@ static void cpu_bps_remove(struct perf_event *bp)
>                         break;
>                 }
>         }
> +       spin_unlock(&cpu_bps_lock);
>  }
>
>  static bool cpu_bps_check(int cpu, struct perf_event *bp)
>  {
>         struct breakpoint **cpu_bp;
> +       bool ret = false;
>         int i;
>
> +       spin_lock(&cpu_bps_lock);
>         cpu_bp = per_cpu_ptr(cpu_bps, cpu);
>         for (i = 0; i < nr_wp_slots(); i++) {
> -               if (cpu_bp[i] && !can_co_exist(cpu_bp[i], bp))
> -                       return true;
> +               if (cpu_bp[i] && !can_co_exist(cpu_bp[i], bp)) {
> +                       ret = true;
> +                       break;
> +               }
>         }
> -       return false;
> +       spin_unlock(&cpu_bps_lock);
> +       return ret;
>  }
>
>  static bool all_cpu_bps_check(struct perf_event *bp)
> @@ -286,10 +317,6 @@ static bool all_cpu_bps_check(struct perf_event *bp)
>         return false;
>  }
>
> -/*
> - * We don't use any locks to serialize accesses to cpu_bps or task_bps
> - * because are already inside nr_bp_mutex.
> - */
>  int arch_reserve_bp_slot(struct perf_event *bp)
>  {
>         int ret;
> --
> 2.35.1
>
