Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8E571605
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbfGWK1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:27:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39327 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731327AbfGWK1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:27:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id r21so37454709otq.6;
        Tue, 23 Jul 2019 03:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajM+r2IdQ5rZtdFxjvMvXdnx3KB/ur/wGMtOzOPKc3A=;
        b=oTwcSa/Sq+jmf1Q1GUK+n17NQeQo+4tD1dCkHHljZuxVErqVR/a0hP6RySZAFhzOP2
         3RO6JT+qEGgAudlfpf9s08LEDrj7vvanJ4ej7GYktw9zmhYNIN/oykCIxuDLwdbPZyCk
         fyIcZ5p3nHe8yuhl5gdZ43cG6HqClExly5py2lo6jSBJ8fLxsMjFGObjOlIG20pq9ATx
         YChIRPMAH5lhF+jBxPekQWOreXmkH7XLrJY0q9KNInirUUGgfCC+HVAPibXFPdy9x8vJ
         e1TmasSv3uYYywPeVzpgXFbxMbkyPR1UUKcuxKBtfOdF7tGbej+9GYM30tzLzUldKnLw
         yqKw==
X-Gm-Message-State: APjAAAVnVg/5DjcIqNFa0mu3qzpJbCJRWLYMPWW0NG8H9TLR9PK6hjsA
        Uk1bdqQZ7Obhgq0VpmtUbG3HYvpr7/thSf7Hq+U=
X-Google-Smtp-Source: APXvYqyRVvENaHdkxd3zgc6Gq0sdtakc+B0KKzT2csgrP84kMpJoBRiwQsWbqWCRDKE+CZYjkVIkPmOMjti7CiZ83SE=
X-Received: by 2002:a9d:6b96:: with SMTP id b22mr56703354otq.262.1563877663855;
 Tue, 23 Jul 2019 03:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
In-Reply-To: <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 23 Jul 2019 12:27:32 +0200
Message-ID: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
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

On Tue, Jul 23, 2019 at 11:15 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 23-07-19, 00:10, Doug Smythies wrote:
> > On 2019.07.21 23:52 Viresh Kumar wrote:
> >
> > > To avoid reducing the frequency of a CPU prematurely, we skip reducing
> > > the frequency if the CPU had been busy recently.
> > >
> > > This should not be done when the limits of the policy are changed, for
> > > example due to thermal throttling. We should always get the frequency
> > > within limits as soon as possible.
> > >
> > > Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> > > Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> > > Reported-by: Doug Smythies <doug.smythies@gmail.com>
> > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > ---
> > > @Doug: Please try this patch, it must fix the issue you reported.
> >
> > It fixes the driver = acpi-cpufreq ; governor = schedutil test case
> > It does not fix the driver = intel_cpufreq ; governor = schedutil test case
> >
> > I have checked my results twice, but will check again in the day or two.
>
> The patch you tried to revert wasn't doing any driver specific stuff
> but only schedutil. If that revert fixes your issue with both the
> drivers, then this patch should do it as well.
>
> I am clueless now on what can go wrong with intel_cpufreq driver with
> schedutil now.
>
> Though there is one difference between intel_cpufreq and acpi_cpufreq,
> intel_cpufreq has fast_switch_possible=true and so it uses slightly
> different path in schedutil. I tried to look from that perspective as
> well but couldn't find anything wrong.

acpi-cpufreq should use fast switching on the Doug's system too.

> If you still find intel_cpufreq to be broken, even with this patch,
> please set fast_switch_possible=false instead of true in
> __intel_pstate_cpu_init() and try tests again. That shall make it very
> much similar to acpi-cpufreq driver.

I wonder if this helps.  Even so, we want fast switching to be used by
intel_cpufreq.

Anyway, it looks like the change reverted by the Doug's patch
introduced a race condition that had not been present before.  Namely,
need_freq_update is cleared in get_next_freq() when it is set _or_
when the new freq is different from the cached one, so in the latter
case if it happens to be set by sugov_limits() after evaluating
sugov_should_update_freq() (which returned 'true' for timing reasons),
that update will be lost now. [Previously the update would not be
lost, because the clearing of need_freq_update depended only on its
current value.] Where it matters is that in the "need_freq_update set"
case, the "premature frequency reduction avoidance" should not be
applied (as you noticed and hence the $subject patch).

However, even with the $subject patch, need_freq_update may still be
set by sugov_limits() after the check added by it and then cleared by
get_next_freq(), so it doesn't really eliminate the problem.

IMO eliminating would require invalidating next_freq this way or
another when need_freq_update is set in sugov_should_update_freq(),
which was done before commit ecd2884291261e3fddbc7651ee11a20d596bb514.
