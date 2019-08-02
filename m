Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63107F02E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbfHBJSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:18:06 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40430 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfHBJSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 05:18:06 -0400
Received: by mail-oi1-f195.google.com with SMTP id w196so34983470oie.7;
        Fri, 02 Aug 2019 02:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xkFiSdpHUnfyoWjiC0O20PFSo9ZFj78rh5jCNoeTnAA=;
        b=BQFz+2GF1t7sEohOqsiXJ36+8/nQQdkp1RPuto3z1P/QTcPE1EvKwPLJ63GLuGaX+N
         KkLK+xeH7O165HsWrHiPFaYOPYxO/Q3haKyhcQ/jQ+kcx1SE/OQZ4EREPgpPSYDU7SjL
         c6SoCb52Wdx9DYTHP3MV07CtoGZM5VnPRxSK36D6l7haeknoHmQt5UvmdUrWBGMYzUWg
         F5TTfUdnDa448AxOQFK7+bWlTvi+zuY1en85c4c3KM28QqOE2q4714K08lRIAvpc7Mgp
         ByWFaKD6rSy67b4en6/Oh7ZAK+aj0vP8a75PKkYC/tnvqRlE940f26oULge74g29ucJ4
         tfuA==
X-Gm-Message-State: APjAAAUahhI8BFfeojURGMipjBJyP1mmqJqNr1R2qUXXQ4iHOP2WNmi8
        FTAxwiAy5upXKzBwGFFXPlw/VBf6OG/kWkvQlWM=
X-Google-Smtp-Source: APXvYqyZS9QZ2kNW1W+zc/Px9C3QI2WFuduW3A8Nk8BTEuK5oQ9wdhdvZBRBfJARZ59KGV8kJCdtOk4AoB8lN+iBQtM=
X-Received: by 2002:aca:edc8:: with SMTP id l191mr2172033oih.103.1564737485809;
 Fri, 02 Aug 2019 02:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
 <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
In-Reply-To: <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Aug 2019 11:17:55 +0200
Message-ID: <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Rafael Wysocki <rjw@rjwysocki.net>,
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

On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
> which can be used to force a limit on the min/max P state of the driver.
> Though these files eventually control the min/max frequencies that the
> CPUs will run at, they don't make a change to policy->min/max values.

That's correct.

> When the values of these files are changed (in passive mode of the
> driver), it leads to calling ->limits() callback of the cpufreq
> governors, like schedutil. On a call to it the governors shall
> forcefully update the frequency to come within the limits.

OK, so the problem is that it is a bug to invoke the governor's ->limits()
callback without updating policy->min/max, because that's what
"limits" mean to the governors.

Fair enough.

> For getting the value within limits, the schedutil governor calls
> cpufreq_driver_resolve_freq(), which eventually tries to call
> ->resolve_freq() callback for this driver. Since the callback isn't
> present, the schedutil governor fails to get the target freq within
> limit and sometimes aborts the update believing that the frequency is
> already set to the target value.
>
> This patch implements the resolve_freq() callback, so the correct target
> frequency can be returned by the driver and the schedutil governor gets
> the frequency within limits immediately.

So the problem is that ->resolve_freq() adds overhead and it adds that
overhead even if the limits don't change.  It just sits there and computes
things every time even if that is completely redundant.

So no, this is not the right way to fix it IMO.
