Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4051882D71
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbfHFIGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 04:06:03 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44974 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbfHFIGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 04:06:03 -0400
Received: by mail-oi1-f193.google.com with SMTP id e189so65138979oib.11;
        Tue, 06 Aug 2019 01:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLfJxrItS5i2yAvJInGgelnco6bcSti3r2wL1VlofFg=;
        b=RJDX3GveCjaScf11R8uzm3PPi3xXl/d48qEib5ZoKFKfylAQXH6EYXeHOG4e4PhgjX
         NYfHO+AHOdEqQnD0xye04yEag2GqHIuqUFAFbbIyK1eoSgVxRfCU/OL8zQYbffuhlMP5
         0w5SwrczZNrSqnS5y9JtCTirxFrlq6Hb0Lw1yiDI1anC4zYCg4ytAL9h2ZlEvBz3Qkj/
         4EFO6AecQqBiSEdWK30szd/J3NARmBrnQaxyLSgp/RXKw5LDItHDtERJqtL+zGljFl+M
         NnsZCt6E569zDnLrW8JgQ+ogqzKj9BISY+vIF4Tn/q7GylIrOs1ULeLM5r42uv2SzwJj
         UO9w==
X-Gm-Message-State: APjAAAVF1uk+v69LSD2bRi4HRg+7MADCZXLEzk5VgGU70glzThaNNF3C
        GmSFcLx4aizZiN3kgMXtnkIFERaZrwi8uA4arPA=
X-Google-Smtp-Source: APXvYqyLQKZMc6OARyXAA5bgNuojMgNMFqi0RC50XL/T1ZP4rZT2XmCEiCdGhjsQ+Op7NfcPSUNiklHa2fNC9P2yZq4=
X-Received: by 2002:aca:5a41:: with SMTP id o62mr1795289oib.110.1565078761925;
 Tue, 06 Aug 2019 01:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
 <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
 <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
 <2676200.jfxhmTd764@kreacher> <20190806041048.ksqs3l5bzsakaael@vireshk-i7>
In-Reply-To: <20190806041048.ksqs3l5bzsakaael@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 6 Aug 2019 10:05:51 +0200
Message-ID: <CAJZ5v0hepyx_yVC=di7E6VSme4GF11p+OhQfA==1p5-FwVRM0Q@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
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

On Tue, Aug 6, 2019 at 6:10 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 02-08-19, 11:28, Rafael J. Wysocki wrote:
> > On Friday, August 2, 2019 11:17:55 AM CEST Rafael J. Wysocki wrote:
> > > On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > > >
> > > > Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
> > > > which can be used to force a limit on the min/max P state of the driver.
> > > > Though these files eventually control the min/max frequencies that the
> > > > CPUs will run at, they don't make a change to policy->min/max values.
> > >
> > > That's correct.
> > >
> > > > When the values of these files are changed (in passive mode of the
> > > > driver), it leads to calling ->limits() callback of the cpufreq
> > > > governors, like schedutil. On a call to it the governors shall
> > > > forcefully update the frequency to come within the limits.
> > >
> > > OK, so the problem is that it is a bug to invoke the governor's ->limits()
> > > callback without updating policy->min/max, because that's what
> > > "limits" mean to the governors.
> > >
> > > Fair enough.
> >
> > AFAICS this can be addressed by adding PM QoS freq limits requests of each CPU to
> > intel_pstate in the passive mode such that changing min_perf_pct or max_perf_pct
> > will cause these requests to be updated.
>
> Right, that sounds like a good plan.
>
> But that will never make it to the stable kernels as there will be a
> long dependency of otherwise unrelated patches to get that done. My
> initial thought was to get this patch merged as it is and then later
> migrate to QoS, but since this patch doesn't fix ondemand and
> conservative, this patch isn't good enough as well.

Right.

> Maybe we should add the regular notifier based solution first, mark it
> for stable kernels, and then add the QoS specific solution ?

I'm not sure if -stable kernels really need a fix here.

Let's just make sure that the mainline is OK and let's go straight for
the final approach.
