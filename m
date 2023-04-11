Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4F6DE012
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjDKPzP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Apr 2023 11:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjDKPzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:55:14 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FF9E58;
        Tue, 11 Apr 2023 08:55:13 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-94a34a0baf9so202023366b.1;
        Tue, 11 Apr 2023 08:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bn1y14BjDhP//nrN2QdcKOf1bYDsUrxiG7mmqhmvXP0=;
        b=XQPWg3R6XjwCEpTTLKpLxgiyI1fIXNaBuu3/m/KN3rRdUsvN+vEl1Kb8iTBxGSd1z0
         OmyV/AU8EgaMFYTizq3fxPRieIizcFW5Re1Wztw15my8SBDcQiPh/cfR6Xt7OAsMQ6g+
         GyBUirl2y6rt34kmJI55nly+zWWhi0goTs9iscvWQfrJeQ4g5z9zBXH4Dy+Ahp9qMvbM
         VLy+M7/PC9XhCpQNj5Sc4QyEJ9Sa4sIjUn8l6d5FKYpr9UYwlojlGpwCj9UggvCMVxDo
         N9vnxyZahn56d4eJbWVi3gcNqZ8vdhff7EwqVl6KAd7ZpHw80T9oUdz+GKm43BqinGD9
         V0QA==
X-Gm-Message-State: AAQBX9cZ50E2jTkYLgcL6K2i9499I71AOOLyJIpBXkuZG1jJFB7rbY/T
        3eadqD0cMHd6nOJys6ka3nvM9s/ZkFrSDOWDN+UdhpSwBG4=
X-Google-Smtp-Source: AKy350a1iBepfUVKkwKC63B/e2nAl1t2cKQisZ8M8ijwWnXhvgEiEzp0dKjhhj4DeCQBJNMvVIoF9tAprPRT8NzpLo8=
X-Received: by 2002:a50:d0d9:0:b0:4fb:f19:87f with SMTP id g25-20020a50d0d9000000b004fb0f19087fmr6811181edf.3.1681228511745;
 Tue, 11 Apr 2023 08:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230410095045.14872-1-wyes.karny@amd.com> <20230410095250.14908-1-wyes.karny@amd.com>
In-Reply-To: <20230410095250.14908-1-wyes.karny@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 11 Apr 2023 17:55:00 +0200
Message-ID: <CAJZ5v0jH4uatAR7HiGY_MYASOcdwxvwkUZaMCHcznd-0idLCUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq/schedutil: Add fast_switch callback check
To:     Wyes Karny <wyes.karny@amd.com>
Cc:     ray.huang@amd.com, rafael@kernel.org, viresh.kumar@linaro.org,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, joel@joelfernandes.org,
        gautham.shenoy@amd.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 11:53 AM Wyes Karny <wyes.karny@amd.com> wrote:
>
> The set value of `fast_switch_enabled` flag doesn't guarantee that
> fast_switch callback is set. For some drivers such as amd_pstate, the
> adjust_perf callback is used but it still sets `fast_switch_possible`
> flag. This is not wrong because this flag doesn't imply fast_switch
> callback is set, it implies whether the driver can guarantee that
> frequency can be changed on any CPU sharing the policy and that the
> change will affect all of the policy CPUs without the need to send any
> IPIs or issue callbacks from the notifier chain.  Therefore add an extra
> NULL check before calling fast_switch in sugov_update_single_freq
> function.
>
> Ideally `sugov_update_single_freq` function should not be called with
> amd_pstate. But in a corner case scenario, when aperf/mperf overflow
> occurs, kernel disables frequency invariance calculation which causes
> schedutil to fallback to sugov_update_single_freq which currently relies
> on the fast_switch callback.

Yes, it does.  Which is why that callback must be provided if the
driver sets fast_switch_enabled.

Overall, adjust_perf is optional, but fast_switch_enabled can only be
set if fast_switch is actually present.

Please fix the driver.

>
> Normal flow:
>   sugov_update_single_perf
>     cpufreq_driver_adjust_perf
>       cpufreq_driver->adjust_perf
>
> Error case flow:
>   sugov_update_single_perf
>     sugov_update_single_freq  <-- This is chosen because the freq invariant is disabled due to aperf/mperf overflow
>       cpufreq_driver_fast_switch
>          cpufreq_driver->fast_switch <-- Here NULL pointer dereference is happening, because fast_switch is not set
>
> Fix this NULL pointer dereference issue by doing a NULL check.
>
> Fixes: a61dec744745 ("cpufreq: schedutil: Avoid missing updates for one-CPU policies")
> Signed-off-by: Wyes Karny <wyes.karny@amd.com>
>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/cpufreq/cpufreq.c        | 11 +++++++++++
>  include/linux/cpufreq.h          |  1 +
>  kernel/sched/cpufreq_schedutil.c |  2 +-
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6d8fd3b8dcb5..364d31b55380 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2138,6 +2138,17 @@ unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_driver_fast_switch);
>
> +/**
> + * cpufreq_driver_has_fast_switch - Check "fast switch" callback.
> + *
> + * Return 'true' if the ->fast_switch callback is present for the
> + * current driver or 'false' otherwise.
> + */
> +bool cpufreq_driver_has_fast_switch(void)
> +{
> +       return !!cpufreq_driver->fast_switch;
> +}
> +
>  /**
>   * cpufreq_driver_adjust_perf - Adjust CPU performance level in one go.
>   * @cpu: Target CPU.
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 65623233ab2f..8a9286fc718b 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -604,6 +604,7 @@ struct cpufreq_governor {
>  /* Pass a target to the cpufreq driver */
>  unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
>                                         unsigned int target_freq);
> +bool cpufreq_driver_has_fast_switch(void);
>  void cpufreq_driver_adjust_perf(unsigned int cpu,
>                                 unsigned long min_perf,
>                                 unsigned long target_perf,
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index e3211455b203..a1c449525ac2 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -364,7 +364,7 @@ static void sugov_update_single_freq(struct update_util_data *hook, u64 time,
>          * concurrently on two different CPUs for the same target and it is not
>          * necessary to acquire the lock in the fast switch case.
>          */
> -       if (sg_policy->policy->fast_switch_enabled) {
> +       if (sg_policy->policy->fast_switch_enabled && cpufreq_driver_has_fast_switch()) {
>                 cpufreq_driver_fast_switch(sg_policy->policy, next_f);
>         } else {
>                 raw_spin_lock(&sg_policy->update_lock);
> --
> 2.34.1
>
