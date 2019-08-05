Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E611B8145A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfHEIgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:36:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43713 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfHEIgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 04:36:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so61503662oif.10;
        Mon, 05 Aug 2019 01:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OtRSIguKOv7zIsZgv8aLGiWOV71DQCuKF1WWLvQ/ts=;
        b=sDiYfr8NyS7gO+VAZ/tBMzkDRBlvg22YhMutAcg7IZZD8FBJKbTuu0B8zqAm1TFmvO
         bVqk6ONOSRPhRqGbEBHzD3x+8y1xmpGwfmxtLbcMsXtJZuwc8E8yzgZ67V9iH6H4QHV2
         KXkTga6XCnGZ7vGhOFuDw9ZQKjwsDXL8u+ZI012aIUoYZKMEFqIKWMgly7JvBZMWG9Zm
         uiYTmIiYqIQUxgLjLad2ngUO8BnEosBGCkD3lj+wzMnIt5vCLDwB7fsn9Ko/JjnVQwit
         UDKwU+QjZr0pOVr5pbIkYFyVO1BfvzsEKoiZy0+FRRmaC7S7a4T+WGb8VbkyTyTQjtTN
         Yi9A==
X-Gm-Message-State: APjAAAUahoNaeZ2LpcT6Wkb6PkzgmCTAmfSNinHmnS3lIIAXZElczLDL
        2gPORKDBLDIP3IAUTrLrKmFcUoE18Dj8RGQGl6g=
X-Google-Smtp-Source: APXvYqzptRCEZ3O3VTh+dWJbaewHGMvttEmampT8Y6ZF/UP5Mp/uYEFm+nFP6TD3n8EPdgwQktQBzUqZ43EkMSyyGww=
X-Received: by 2002:aca:5a41:: with SMTP id o62mr10383463oib.110.1564994169130;
 Mon, 05 Aug 2019 01:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
 <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
 <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
 <2676200.jfxhmTd764@kreacher> <000401d54a0c$2f03aa50$8d0afef0$@net>
In-Reply-To: <000401d54a0c$2f03aa50$8d0afef0$@net>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 5 Aug 2019 10:35:54 +0200
Message-ID: <CAJZ5v0idOvmYHVYjQ5YYPBH0MYMEPMu+m7kDRgtBi8yqyEuyAQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
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

On Sat, Aug 3, 2019 at 5:00 PM Doug Smythies <dsmythies@telus.net> wrote:
>
> On 2019.08.02 02:28 Rafael J. Wysocki wrote:
> > On Friday, August 2, 2019 11:17:55 AM CEST Rafael J. Wysocki wrote:
> >> On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >>>
> >>> Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
> >>> which can be used to force a limit on the min/max P state of the driver.
> >>> Though these files eventually control the min/max frequencies that the
> >>> CPUs will run at, they don't make a change to policy->min/max values.
> >>
> >> That's correct.
> >>
> >>> When the values of these files are changed (in passive mode of the
> >>> driver), it leads to calling ->limits() callback of the cpufreq
> >>> governors, like schedutil. On a call to it the governors shall
> >>> forcefully update the frequency to come within the limits.
> >>
> >> OK, so the problem is that it is a bug to invoke the governor's ->limits()
> >> callback without updating policy->min/max, because that's what
> >> "limits" mean to the governors.
> >>
> >> Fair enough.
> >
> > AFAICS this can be addressed by adding PM QoS freq limits requests of each CPU to
> > intel_pstate in the passive mode such that changing min_perf_pct or max_perf_pct
> > will cause these requests to be updated.
>
> All governors for the intel_cpufreq (intel_pstate in passive mode) CPU frequency
> scaling driver are broken with respect to this issue, not just the schedutil
> governor.

Right.

My point is that that changing min_perf_pct or max_perf_pct should
cause policy limits to be updated (which is not the case now) instead
of running special driver code on every frequency update just in case
the limits have changed in the meantime.
