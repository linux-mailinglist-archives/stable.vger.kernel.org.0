Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119D9453E3C
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 03:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhKQCM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 21:12:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:25221 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhKQCM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 21:12:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257628133"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="257628133"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 18:09:22 -0800
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="645676624"
Received: from dhrupadx-mobl1.gar.corp.intel.com ([10.215.188.156])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 18:09:19 -0800
Message-ID: <adc7132c8655bd4d1c8b6129578e931a14fe1db2.camel@linux.intel.com>
Subject: Re: [UPDATE][PATCH] cpufreq: intel_pstate: Fix EPP restore after
 offline/online
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Date:   Tue, 16 Nov 2021 18:09:15 -0800
In-Reply-To: <CAJZ5v0jk3KB6+uynpvdBAO+Q-Qr4HiCam=x4dxzT6NFWjROLzg@mail.gmail.com>
References: <20211115134017.1257932-1-srinivas.pandruvada@linux.intel.com>
         <CAJZ5v0jk3KB6+uynpvdBAO+Q-Qr4HiCam=x4dxzT6NFWjROLzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-16 at 18:47 +0100, Rafael J. Wysocki wrote:
> On Mon, Nov 15, 2021 at 2:40 PM Srinivas Pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
> > 
> > When using performance policy, EPP value is restored to non
> > "performance"
> > mode EPP after offline and online.
> > 
> > For example:
> > cat
> > /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
> > performance
> > echo 0 > /sys/devices/system/cpu/cpu1/online
> > echo 1 > /sys/devices/system/cpu/cpu1/online
> > cat
> > /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
> > balance_performance
> > 
> > The commit 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and
> > ->online callbacks")
> > optimized save restore path of the HWP request MSR, when there is
> > no
> > change in the policy. Also added special processing for performance
> > mode
> > EPP. If EPP has been set to "performance" by the active mode
> > "performance"
> > scaling algorithm, replace that value with the cached EPP. This
> > ends up
> > replacing with cached EPP during offline, which is restored during
> > online
> > again.
> > 
> > So add a change which will set cpu_data->epp_policy to zero, when
> > in
> > performance policy and has non zero epp. In this way EPP is set to
> > zero
> > again.
> > 
> > Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and -
> > >online callbacks")
> > Signed-off-by: Srinivas Pandruvada <
> > srinivas.pandruvada@linux.intel.com>
> > Cc: stable@vger.kernel.org # v5.9+
> > ---
> > Update: Minor optimization to skip non performance policy code path
> > 
> >  drivers/cpufreq/intel_pstate.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/intel_pstate.c
> > b/drivers/cpufreq/intel_pstate.c
> > index 815df3daae9d..6d7d73a0c66b 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -936,11 +936,17 @@ static void intel_pstate_hwp_set(unsigned int
> > cpu)
> >         max = cpu_data->max_perf_ratio;
> >         min = cpu_data->min_perf_ratio;
> > 
> > -       if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE)
> > -               min = max;
> > -
> >         rdmsrl_on_cpu(cpu, MSR_HWP_REQUEST, &value);
> > 
> > +       if (cpu_data->policy == CPUFREQ_POLICY_PERFORMANCE) {
> > +               min = max;
> > +               epp = 0;
> > +               if (boot_cpu_has(X86_FEATURE_HWP_EPP))
> > +                       epp = (value >> 24) & 0xff;
> > +               if (epp)
> > +                       cpu_data->epp_policy = 0;
> > +       }
> 
> I understand the bug, but it should not be necessary to check this
> every time intel_pstate_hwp_set() runs.
> 
> > +
> >         value &= ~HWP_MIN_PERF(~0L);
> >         value |= HWP_MIN_PERF(min);
> > 
> > --
> 
> Isn't the following sufficient (modulo the gmail-induced whitespace
> damage)?
> 
> ---
>  drivers/cpufreq/intel_pstate.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-pm/drivers/cpufreq/intel_pstate.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> +++ linux-pm/drivers/cpufreq/intel_pstate.c
> @@ -1006,6 +1006,12 @@ static void intel_pstate_hwp_offline(str
>           */
>          value &= ~GENMASK_ULL(31, 24);
>          value |= HWP_ENERGY_PERF_PREFERENCE(cpu->epp_cached);
> +        /*
> +         * However, make sure that EPP will be set to "performance"
> when
> +         * the CPU is brought back online again and the
> "performance"
> +         * scaling algorithm is still in effect.
> +         */
> +        cpu->epp_policy = CPUFREQ_POLICY_UNKNOWN;
>      }
> 
>      /*
This works also.

Thanks,
Srinivas

