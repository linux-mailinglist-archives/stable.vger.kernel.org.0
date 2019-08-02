Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B417F00F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbfHBJMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:12:08 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44541 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfHBJMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 05:12:07 -0400
Received: by mail-ot1-f66.google.com with SMTP id b7so27257091otl.11;
        Fri, 02 Aug 2019 02:12:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=abG3po4zp9c8UuzkODHbdu2ibw0Ez70ol3ic6n5iN0A=;
        b=hOu7/iHSbRCBpM+ARpptmKQWfNxYRBRx+ng0GPGhyro7ovVB1DpC+O8YuFt2V36mfd
         KoD66O783eLyqT8mo5MdiYjA7gJFqSwGG9qPISqF3du1SHj/lg+Isbnu3O42EnPpPLJy
         rslAFj///pU45GQ7a01r2S0GvyjWmSnP81zRCeTfm3tvT2A3p53eS1kBX3cgewrxfNQW
         /Pa+8O8OOWpWIEGgilkKGmQ/jjm/tsRGTYqugMc3XtpYWF7WouyM0H+WifLN4XigI+vv
         +9eWj6xunaH8vidkviTqGBjuA+Aexlk2XyNj7M4qA9BmdIKZHT+RBcDd/xP/8qubGUMD
         yahA==
X-Gm-Message-State: APjAAAU+jr/MYsDQzoi5pVvWK6Ze16C99dT36PAYwBa78kG8gA8vzzTJ
        XXgD2uh9RjjLA3urQr0B0DLJFM94gRSn3CuNzv4=
X-Google-Smtp-Source: APXvYqwu/rzc+VgpWJHddMl0wT0GWxmDQPke0wlrjccwsyrUdcsO95Yc99v7js/L501HBAcETbUpboHeFKlB4yaCWd8=
X-Received: by 2002:a9d:7a51:: with SMTP id z17mr14030375otm.266.1564737126640;
 Fri, 02 Aug 2019 02:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
In-Reply-To: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Aug 2019 11:11:55 +0200
Message-ID: <CAJZ5v0g=zXWps29EiFJBPozyw4b9z0YOhtU-UV6hfyu8NbVKNw@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] cpufreq: schedutil: Don't skip freq update when
 limits change
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Rafael Wysocki <rjw@rjwysocki.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> To avoid reducing the frequency of a CPU prematurely, we skip reducing
> the frequency if the CPU had been busy recently.
>
> This should not be done when the limits of the policy are changed, for
> example due to thermal throttling. We should always get the frequency
> within the new limits as soon as possible.
>
> Trying to fix this by using only one flag, i.e. need_freq_update, can
> lead to a race condition where the flag gets cleared without forcing us
> to change the frequency at least once. And so this patch introduces
> another flag to avoid that race condition.
>
> Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> Reported-by: Doug Smythies <doug.smythies@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V2->V3:
> - Updated commit log.
>
> V1->V2:
> - Fixed the race condition using a different flag.
>
> @Doug: I haven't changed the code since you last tested these. Your
> Tested-by tag can be useful while applying the patches. Thanks.
>
>  kernel/sched/cpufreq_schedutil.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index 636ca6f88c8e..2f382b0959e5 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -40,6 +40,7 @@ struct sugov_policy {
>         struct task_struct      *thread;
>         bool                    work_in_progress;
>
> +       bool                    limits_changed;
>         bool                    need_freq_update;
>  };
>
> @@ -89,8 +90,11 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
>             !cpufreq_this_cpu_can_update(sg_policy->policy))
>                 return false;
>
> -       if (unlikely(sg_policy->need_freq_update))
> +       if (unlikely(sg_policy->limits_changed)) {
> +               sg_policy->limits_changed = false;
> +               sg_policy->need_freq_update = true;
>                 return true;
> +       }
>
>         delta_ns = time - sg_policy->last_freq_update_time;
>
> @@ -437,7 +441,7 @@ static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
>  static inline void ignore_dl_rate_limit(struct sugov_cpu *sg_cpu, struct sugov_policy *sg_policy)
>  {
>         if (cpu_bw_dl(cpu_rq(sg_cpu->cpu)) > sg_cpu->bw_dl)
> -               sg_policy->need_freq_update = true;
> +               sg_policy->limits_changed = true;
>  }
>
>  static void sugov_update_single(struct update_util_data *hook, u64 time,
> @@ -447,7 +451,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
>         struct sugov_policy *sg_policy = sg_cpu->sg_policy;
>         unsigned long util, max;
>         unsigned int next_f;
> -       bool busy;
> +       bool busy = false;

This shouldn't be necessary ->

>
>         sugov_iowait_boost(sg_cpu, time, flags);
>         sg_cpu->last_update = time;
> @@ -457,7 +461,9 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
>         if (!sugov_should_update_freq(sg_policy, time))
>                 return;
>
> -       busy = sugov_cpu_is_busy(sg_cpu);
> +       /* Limits may have changed, don't skip frequency update */
> +       if (!sg_policy->need_freq_update)
> +               busy = sugov_cpu_is_busy(sg_cpu);

-> if this is rewritten as

busy = !sg_policy->need_freq_update && sugov_cpu_is_busy(sg_cpu);

which is simpler and avoids the extra branch.


>
>         util = sugov_get_util(sg_cpu);
>         max = sg_cpu->max;
> @@ -831,6 +837,7 @@ static int sugov_start(struct cpufreq_policy *policy)
>         sg_policy->last_freq_update_time        = 0;
>         sg_policy->next_freq                    = 0;
>         sg_policy->work_in_progress             = false;
> +       sg_policy->limits_changed               = false;
>         sg_policy->need_freq_update             = false;
>         sg_policy->cached_raw_freq              = 0;
>
> @@ -879,7 +886,7 @@ static void sugov_limits(struct cpufreq_policy *policy)
>                 mutex_unlock(&sg_policy->work_lock);
>         }
>
> -       sg_policy->need_freq_update = true;
> +       sg_policy->limits_changed = true;
>  }
>
>  struct cpufreq_governor schedutil_gov = {
> --
> 2.21.0.rc0.269.g1a574e7a288b
>
