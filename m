Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187864D6549
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 16:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349974AbiCKPyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 10:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350566AbiCKPyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 10:54:15 -0500
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58D9ECC57;
        Fri, 11 Mar 2022 07:53:11 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id l2so17819717ybe.8;
        Fri, 11 Mar 2022 07:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FEtrVBpJ9DBkNlbjxVJR5SHVgIP3hXEvRRRjSXbn5+4=;
        b=N4HcMhA1dOsjtmB6aWz1HIPAMT3s+zwJ0qkHV9mZA1fcHOO9GIi3NRu2iUOsb+OnD8
         zq2vkKL6ALVTFFBfmSkizHvGeLyjl79p0MOJGCPi49dh9jPXtcrZZMbkgktEC2zYStAY
         DJbWsxs1zxTf2EPYATHgu2Zsejynkb8JQ7TurJ2lPnDUBMpTjuC+1saDNvRkMP02xgJs
         WApW8JgWmk3BrH8IENLUfbKRt2MDpluSW1SuKYPyppP66rYk9xs6Tf6j0lMrS0X/uoH4
         HOGSZJR6065KTiZijC9U+uWMqSEiFyllikMmZBDM7JfZ36oX6TP7mAllJpei49SXsndx
         VguQ==
X-Gm-Message-State: AOAM530b6mTLt5TJlIAJRW/WZxMq7cFM5MUskPkYuw5RDh3kSCDUjDGC
        +45FwwGEIZ5COpjt6g/wjVW+q6Arq/WaJ0dUrLs=
X-Google-Smtp-Source: ABdhPJxU3SRPSOiwueLKQjDEtPITtq/dfRJ1NV9l2AVmzq8xiqXtHR1a4E/0K4VPjjN0/g7BtgqFri/2EM9XXP4vgnw=
X-Received: by 2002:a25:d7c2:0:b0:628:9d06:457b with SMTP id
 o185-20020a25d7c2000000b006289d06457bmr8462316ybg.137.1647013990912; Fri, 11
 Mar 2022 07:53:10 -0800 (PST)
MIME-Version: 1.0
References: <20220311081111.159639-1-zhengzucheng@huawei.com>
In-Reply-To: <20220311081111.159639-1-zhengzucheng@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 11 Mar 2022 16:52:59 +0100
Message-ID: <CAJZ5v0jponp=ijVx6W=eNEGrfTKh0KbGmOQG_V0P-Mq366559g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: fix cpufreq_get() can't get correct CPU frequency
To:     z00314508 <zhengzucheng@huawei.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 9:11 AM z00314508 <zhengzucheng@huawei.com> wrote:
>
> From: Zucheng Zheng <zhengzucheng@huawei.com>
>
> On some specific platforms, the cpufreq driver does not define
> cpufreq_driver.get() routine (eg:x86 intel_pstate driver), as a

I guess you mean the cpufreq driver ->get callback.

No, intel_pstate doesn't implement it, because it cannot reliably
return the current CPU frequency.

> result, the cpufreq_get() can't get the correct CPU frequency.

No, it can't, if intel_pstate is the driver, but what's the problem?
This function is only called in one place in the kernel and not on x8
even.

> Modern x86 processors include the hardware needed to accurately
> calculate frequency over an interval -- APERF, MPERF and the TSC.

You can compute the average frequency over an interval, but ->get is
expected to return the actual current frequency at the time call time.

> Here we use arch_freq_get_on_cpu() in preference to any driver
> driver-specific cpufreq_driver.get() routine to get CPU frequency.
>
> Fixes: f8475cef9008 ("x86: use common aperfmperf_khz_on_cpu() to calculate KHz using APERF/MPERF")

No kidding.

> Signed-off-by: Zucheng Zheng <zhengzucheng@huawei.com>
> ---
>  drivers/cpufreq/cpufreq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 80f535cc8a75..d777257b4454 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1806,10 +1806,14 @@ unsigned int cpufreq_get(unsigned int cpu)
>  {
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>         unsigned int ret_freq = 0;
> +       unsigned int freq;
>
>         if (policy) {
>                 down_read(&policy->rwsem);
> -               if (cpufreq_driver->get)
> +               freq = arch_freq_get_on_cpu(policy->cpu);
> +               if (freq)
> +                       ret_freq = freq;
> +               else if (cpufreq_driver->get)

Again, what problem exactly does this address?

>                         ret_freq = __cpufreq_get(policy);
>                 up_read(&policy->rwsem);
>
> --
