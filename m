Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D28714B7
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfGWJN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:13:29 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41150 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfGWJN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:13:29 -0400
Received: by mail-oi1-f195.google.com with SMTP id g7so31762677oia.8;
        Tue, 23 Jul 2019 02:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wujA94+Og9Bx9XzZozqqH52IFciDgKWmF/1WB888+Tw=;
        b=R6LWVFAU6Z/PmvNWFEMKWwXBmV8B2yUImSYjMEQFv5FQgTAkxcVF/ll+2oB/fw0Yqv
         Mm+J/Q+iSKwZ4zx/6N4J7KXMiwDJdjHWouUtB5Y/wik7kcEp24D0Lu6gh0uCT2OXOPBp
         FI9VtqPmjNf6eLNZjG8kJ11PfgeiEMZnt9WeLcy4R2hakHo9LeeMfbYEHsvPq7PKV96v
         YAlwDz9SuFZrjEXh7TFz6xwgirrjWILlFgCGvRyT6AfZyV24gmKha3PnzwqGXDCXMCYh
         rY2JOGuOeT/NXcbnkehneEcmsXbArC3CJhRbODPQDiY93xwpELER4P2Pi8ycge62VK6h
         HYhA==
X-Gm-Message-State: APjAAAX8GnFN/j53diH/MJW3F16GuFu3arC+TvNQ7v5MsqB+R5KW4Jl8
        pEKg6flU4ebIT9VPvF7L73oyqj8WNXmaZJ17vEY=
X-Google-Smtp-Source: APXvYqycTX8Zfj7JWcbdeDeuWvjXA1EJqOWRQ4+e1v+Vfhp98qBwthTQGrb2dWn3PpBWJ+qFbxBXPbisFLBGOnH0g4s=
X-Received: by 2002:aca:edc8:: with SMTP id l191mr36097785oih.103.1563873208155;
 Tue, 23 Jul 2019 02:13:28 -0700 (PDT)
MIME-Version: 1.0
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net>
In-Reply-To: <001201d54125$a6a82350$f3f869f0$@net>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 23 Jul 2019 11:13:17 +0200
Message-ID: <CAJZ5v0gRRC3pzgDzp-FDuFtFKWE_9=1DKNTmWa-aR_bW6J14xg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
To:     Doug Smythies <dsmythies@telus.net>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 9:10 AM Doug Smythies <dsmythies@telus.net> wrote:
>
> On 2019.07.21 23:52 Viresh Kumar wrote:
>
> > To avoid reducing the frequency of a CPU prematurely, we skip reducing
> > the frequency if the CPU had been busy recently.
> >
> > This should not be done when the limits of the policy are changed, for
> > example due to thermal throttling. We should always get the frequency
> > within limits as soon as possible.
> >
> > Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> > Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> > Reported-by: Doug Smythies <doug.smythies@gmail.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > @Doug: Please try this patch, it must fix the issue you reported.
>
> It fixes the driver = acpi-cpufreq ; governor = schedutil test case
> It does not fix the driver = intel_cpufreq ; governor = schedutil test case

So what's the difference between them, with the patch applied?

> I have checked my results twice, but will check again in the day or two.

OK, thanks!
