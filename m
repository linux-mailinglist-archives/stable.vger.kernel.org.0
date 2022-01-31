Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219024A505A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 21:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiAaUlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 15:41:42 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:39501 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiAaUli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 15:41:38 -0500
Received: by mail-lf1-f42.google.com with SMTP id b9so29372132lfq.6
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 12:41:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y5CAFZHFmG1usH+4Kjgs23qfFRVTNq83qGUrkqG5xRE=;
        b=D4AsvJi7aAKcoY66YpVlKXksbhbw2owPStBMjycSDhub4imx/NZjH5uB5AKvX6wz1B
         ITi644x9r25Us13fYHRuvhni0O61+Y646vyWtCVe/UzmXATkZOn7/3nofl/cweuwkVeY
         yC8TmTesiBcIdVLlu0wZpC1nuxGGBbr2zgodYZiwjMJER7BovQ2XQE7lGv0Fbf6jfEei
         mswQ4y+DUwdbue2ZBJxi5+e2f615/RFXQ8mr//YRTRE3m6ybcE1YI13eSZnHp9RFsr6T
         52gYMhzAdd6yhCDpGBK7e2IN0RP6zCd2JZ8wRAyqg2EfpuddawsDblQZHMpkdBpfhJ3z
         fjqA==
X-Gm-Message-State: AOAM532wq4trqGWYcD6aS4T1+42xSBaLnyQjrgNXsQA6NxhfHv4wM4vv
        5vZAfaZwSnJnFnwzDAZ7oSc54M77zqHIZA1bH4aRjvVo2F4=
X-Google-Smtp-Source: ABdhPJxu6NjC8BJW0fU3cRQh3bRfAd4WDteuPke7V9omScKKzH/cHdiN/w6PvjANYhDV6g5YVS6lQkdpU0981Yoc9CA=
X-Received: by 2002:ac2:4bc1:: with SMTP id o1mr16760799lfq.528.1643661697421;
 Mon, 31 Jan 2022 12:41:37 -0800 (PST)
MIME-Version: 1.0
References: <164361730315712@kroah.com>
In-Reply-To: <164361730315712@kroah.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Mon, 31 Jan 2022 12:41:26 -0800
Message-ID: <CAM9d7cgm1QRscxxtapdHZxzpVTfbwY91xHkDq5Vy-30N6mzXWw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] perf/core: Fix cgroup event list
 management" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "stable # 4 . 5" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 31, 2022 at 12:29 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I think it fails because the dependent commit ef54c1a476ae ("perf:
Rework perf_event_exit_event()") was reverted already (because
of the issue this commit fixes).

Could you please try it again with the above commit?  If it still doesn't
work, please let me know.

Thanks,
Namhyung

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From c5de60cd622a2607c043ba65e25a6e9998a369f9 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Mon, 24 Jan 2022 11:58:08 -0800
> Subject: [PATCH] perf/core: Fix cgroup event list management
>
> The active cgroup events are managed in the per-cpu cgrp_cpuctx_list.
> This list is only accessed from current cpu and not protected by any
> locks.  But from the commit ef54c1a476ae ("perf: Rework
> perf_event_exit_event()"), it's possible to access (actually modify)
> the list from another cpu.
>
> In the perf_remove_from_context(), it can remove an event from the
> context without an IPI when the context is not active.  This is not
> safe with cgroup events which can have some active events in the
> context even if ctx->is_active is 0 at the moment.  The target cpu
> might be in the middle of list iteration at the same time.
>
> If the event is enabled when it's about to be closed, it might call
> perf_cgroup_event_disable() and list_del() with the cgrp_cpuctx_list
> on a different cpu.
>
> This resulted in a crash due to an invalid list pointer access during
> the cgroup list traversal on the cpu which the event belongs to.
>
> Let's fallback to IPI to access the cgrp_cpuctx_list from that cpu.
> Similarly, perf_install_in_context() should use IPI for the cgroup
> events too.
>
> Fixes: ef54c1a476ae ("perf: Rework perf_event_exit_event()")
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/20220124195808.2252071-1-namhyung@kernel.org
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b1c1928c0e7c..76c754e45d01 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2462,7 +2462,11 @@ static void perf_remove_from_context(struct perf_event *event, unsigned long fla
>          * event_function_call() user.
>          */
>         raw_spin_lock_irq(&ctx->lock);
> -       if (!ctx->is_active) {
> +       /*
> +        * Cgroup events are per-cpu events, and must IPI because of
> +        * cgrp_cpuctx_list.
> +        */
> +       if (!ctx->is_active && !is_cgroup_event(event)) {
>                 __perf_remove_from_context(event, __get_cpu_context(ctx),
>                                            ctx, (void *)flags);
>                 raw_spin_unlock_irq(&ctx->lock);
> @@ -2895,11 +2899,14 @@ perf_install_in_context(struct perf_event_context *ctx,
>          * perf_event_attr::disabled events will not run and can be initialized
>          * without IPI. Except when this is the first event for the context, in
>          * that case we need the magic of the IPI to set ctx->is_active.
> +        * Similarly, cgroup events for the context also needs the IPI to
> +        * manipulate the cgrp_cpuctx_list.
>          *
>          * The IOC_ENABLE that is sure to follow the creation of a disabled
>          * event will issue the IPI and reprogram the hardware.
>          */
> -       if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF && ctx->nr_events) {
> +       if (__perf_effective_state(event) == PERF_EVENT_STATE_OFF &&
> +           ctx->nr_events && !is_cgroup_event(event)) {
>                 raw_spin_lock_irq(&ctx->lock);
>                 if (ctx->task == TASK_TOMBSTONE) {
>                         raw_spin_unlock_irq(&ctx->lock);
>
