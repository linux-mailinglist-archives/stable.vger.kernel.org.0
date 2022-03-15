Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00D64D997B
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 11:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347587AbiCOKuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348663AbiCOKto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 06:49:44 -0400
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E5B2BB09;
        Tue, 15 Mar 2022 03:47:47 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id o5so7560522ybe.2;
        Tue, 15 Mar 2022 03:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PldGcjBa0JTGcjD5vlBABlzXMAzHs2EeEmRgowZ+/0=;
        b=drxBHxSOCd3erDdf4oJp9pBviGPO4SxdorjF+2S8WKN2TqNfXK3xR2WFLU5M6JFD1X
         Wc++nsXZLk/kmVtjRyBOalqy0mkySbs0D3L0O/HuAeyuX64zEifU+Ch64bg3xmvmjRn6
         IZ3Kdh3npn9ft7X6auXwXOEEJ6E3RMVq3nikfBYhZMIsX4IXryTBS117cygdR36u7TOG
         Ckb65tDTdXihXOPCR/0yZpSMKGcc4vGpzCMA08Kke5floZVznGbbeFClW/UumvOwXRU4
         7iYz+mVfUKoPgHMDzpozk45NK0mjHBzZILDZyzC9LApJTf6K/vr4pRYI4+KOSx4gHduO
         kVYQ==
X-Gm-Message-State: AOAM531ecsmcQWpDfXnPfua41jiowyaen5JLqFGpIgIWwvVB9/5AKw2u
        9jlWvYByWKX8rCH7DZ6oCW73fCxTKgc8S1+yDxY=
X-Google-Smtp-Source: ABdhPJwfV5tUV70S6cOpeBS40bDAmQlYNQTWZLSGirDiSZJsrPNaLHOQqJyGmXVIbI3Fs10Vx7cOslcHb+DxmtObygk=
X-Received: by 2002:a25:3a41:0:b0:628:86a2:dbc with SMTP id
 h62-20020a253a41000000b0062886a20dbcmr21529994yba.633.1647341266808; Tue, 15
 Mar 2022 03:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220311081111.159639-1-zhengzucheng@huawei.com>
 <CAJZ5v0jponp=ijVx6W=eNEGrfTKh0KbGmOQG_V0P-Mq366559g@mail.gmail.com> <100a5228-a941-0ff7-8133-14273472b6f5@huawei.com>
In-Reply-To: <100a5228-a941-0ff7-8133-14273472b6f5@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 15 Mar 2022 11:47:35 +0100
Message-ID: <CAJZ5v0jL03nfk7Zof3rrXtupdNY1YK-o-gFhRxbOGvp-vnT6fw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: fix cpufreq_get() can't get correct CPU frequency
To:     zhengzucheng <zhengzucheng@huawei.com>
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

On Tue, Mar 15, 2022 at 3:30 AM zhengzucheng <zhengzucheng@huawei.com> wrote:
>
>
>
> On 2022/3/11 23:52, Rafael J. Wysocki wrote:
> > On Fri, Mar 11, 2022 at 9:11 AM z00314508 <zhengzucheng@huawei.com> wrote:
> >> From: Zucheng Zheng <zhengzucheng@huawei.com>
> >>
> >> On some specific platforms, the cpufreq driver does not define
> >> cpufreq_driver.get() routine (eg:x86 intel_pstate driver), as a
> > I guess you mean the cpufreq driver ->get callback.
> >
> > No, intel_pstate doesn't implement it, because it cannot reliably
> > return the current CPU frequency.
> >
> >> result, the cpufreq_get() can't get the correct CPU frequency.
> > No, it can't, if intel_pstate is the driver, but what's the problem?
> > This function is only called in one place in the kernel and not on x8
> > even.
> >
> >> Modern x86 processors include the hardware needed to accurately
> >> calculate frequency over an interval -- APERF, MPERF and the TSC.
> > You can compute the average frequency over an interval, but ->get is
> > expected to return the actual current frequency at the time call time.
> >
> >> Here we use arch_freq_get_on_cpu() in preference to any driver
> >> driver-specific cpufreq_driver.get() routine to get CPU frequency.
> >>
> >> Fixes: f8475cef9008 ("x86: use common aperfmperf_khz_on_cpu() to calculate KHz using APERF/MPERF")
> > No kidding.
> >
> >> Signed-off-by: Zucheng Zheng <zhengzucheng@huawei.com>
> >> ---
> >>   drivers/cpufreq/cpufreq.c | 6 +++++-
> >>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index 80f535cc8a75..d777257b4454 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -1806,10 +1806,14 @@ unsigned int cpufreq_get(unsigned int cpu)
> >>   {
> >>          struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> >>          unsigned int ret_freq = 0;
> >> +       unsigned int freq;
> >>
> >>          if (policy) {
> >>                  down_read(&policy->rwsem);
> >> -               if (cpufreq_driver->get)
> >> +               freq = arch_freq_get_on_cpu(policy->cpu);
> >> +               if (freq)
> >> +                       ret_freq = freq;
> >> +               else if (cpufreq_driver->get)
> > Again, what problem exactly does this address?
> Thank you for review.
>
> In some scenarios, cpufreq driver ->get is not defined,
> some driver get the CPU frequency by calling cpufreq_get() will return 0.

Which driver?  Again, there is only one calling cpufreq_get() in the
kernel tree and it is not on x86.

> The modification to this problem is inspired by the implementation of
> the show_scaling_cur_freq().
> >
> >>                          ret_freq = __cpufreq_get(policy);
> >>                  up_read(&policy->rwsem);
> >>
> >> --

The answer to my question appears to be that you want cpufreq_get() to
be consistent with show_scaling_cur_freq().

Fair enough, but in that case please make them both call the same
lower-level routine implementing the desired behavior so as to avoid
code duplication.
