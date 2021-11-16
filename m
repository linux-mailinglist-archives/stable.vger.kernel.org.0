Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AC74538BE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhKPRuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:50:55 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:37808 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhKPRuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:50:54 -0500
Received: by mail-oi1-f181.google.com with SMTP id bj13so213439oib.4;
        Tue, 16 Nov 2021 09:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u8e7hzTw8B2j6N2eJqtuT11zBVR9b0rrryuunla9JsI=;
        b=4IIALVPc5cYSVp/vaAcDt/fMidapHGh2qhjZzL6UjTo3U2z8E4ozyMFOHMUHvNpevs
         /ymKovHk8kbwkVgffi2C6dFrZpjeLLWSl7BlTGu96vtmvccdnQ0zZrx3qtpuN0nfIvrB
         nVBPNjunTfZm8JZac2AtA/TlOq9qMifdadw+0POcZQ5nZd08ybWvEi0Ck31DuGP0dNWx
         CiqyHyTrBeu57j3/UPrN9qO51N11mvv8U/gQIx6u9o+6YSHwMs46EGhZjwy5xPhTMJ13
         AtsFtedEus2ywmFMbRAFJ6dZvDEHIP12TFbG6Sbz91u40cINLeK+PUKEJKd5zK+fXFbG
         iJFQ==
X-Gm-Message-State: AOAM532Sa7zTPjH38fUn+2ZT4A1H6EYU4Up3+fOOuTMiKkKiR2T2+3Zd
        6YU5nlmx1aeTeIkT0ly5NdQTyb8Fo0kzzMwjF/biHL0tsJ4=
X-Google-Smtp-Source: ABdhPJwiFE2QcWklcUZ1lmcx262LXQjyeJUNXjPVxiTg84yya3jCmcIvVEFwQgezqNmiDmcZ3x6MRiogMotvbtg/BiU=
X-Received: by 2002:a05:6808:14c2:: with SMTP id f2mr8036609oiw.154.1637084876799;
 Tue, 16 Nov 2021 09:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20211115134017.1257932-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20211115134017.1257932-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 16 Nov 2021 18:47:45 +0100
Message-ID: <CAJZ5v0jk3KB6+uynpvdBAO+Q-Qr4HiCam=x4dxzT6NFWjROLzg@mail.gmail.com>
Subject: Re: [UPDATE][PATCH] cpufreq: intel_pstate: Fix EPP restore after offline/online
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 2:40 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> When using performance policy, EPP value is restored to non "performance"
> mode EPP after offline and online.
>
> For example:
> cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
> performance
> echo 0 > /sys/devices/system/cpu/cpu1/online
> echo 1 > /sys/devices/system/cpu/cpu1/online
> cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
> balance_performance
>
> The commit 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
> optimized save restore path of the HWP request MSR, when there is no
> change in the policy. Also added special processing for performance mode
> EPP. If EPP has been set to "performance" by the active mode "performance"
> scaling algorithm, replace that value with the cached EPP. This ends up
> replacing with cached EPP during offline, which is restored during online
> again.
>
> So add a change which will set cpu_data->epp_policy to zero, when in
> performance policy and has non zero epp. In this way EPP is set to zero
> again.
>
> Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org # v5.9+
> ---
> Update: Minor optimization to skip non performance policy code path
>
>  drivers/cpufreq/intel_pstate.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 815df3daae9d..6d7d73a0c66b 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -936,11 +936,17 @@ static void intel_pstate_hwp_set(unsigned int cpu)
>         max = cpu_data->max_perf_ratio;
>         min = cpu_data->min_perf_ratio;
>
> -       if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE)
> -               min = max;
> -
>         rdmsrl_on_cpu(cpu, MSR_HWP_REQUEST, &value);
>
> +       if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE) {
> +               min = max;
> +               epp = 0;
> +               if (boot_cpu_has(X86_FEATURE_HWP_EPP))
> +                       epp = (value >> 24) & 0xff;
> +               if (epp)
> +                       cpu_data->epp_policy = 0;
> +       }

I understand the bug, but it should not be necessary to check this
every time intel_pstate_hwp_set() runs.

> +
>         value &= ~HWP_MIN_PERF(~0L);
>         value |= HWP_MIN_PERF(min);
>
> --

Isn't the following sufficient (modulo the gmail-induced whitespace damage)?

---
 drivers/cpufreq/intel_pstate.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-pm/drivers/cpufreq/intel_pstate.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
+++ linux-pm/drivers/cpufreq/intel_pstate.c
@@ -1006,6 +1006,12 @@ static void intel_pstate_hwp_offline(str
          */
         value &= ~GENMASK_ULL(31, 24);
         value |= HWP_ENERGY_PERF_PREFERENCE(cpu->epp_cached);
+        /*
+         * However, make sure that EPP will be set to "performance" when
+         * the CPU is brought back online again and the "performance"
+         * scaling algorithm is still in effect.
+         */
+        cpu->epp_policy = CPUFREQ_POLICY_UNKNOWN;
     }

     /*
