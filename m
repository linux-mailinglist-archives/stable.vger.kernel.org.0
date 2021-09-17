Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCE140F409
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 10:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhIQI0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 04:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232713AbhIQI0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 04:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0876061108;
        Fri, 17 Sep 2021 08:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631867108;
        bh=qdJFyj06yBfXlZhRZDy4FYGP10Qe1Ow87PoRl1z2B90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wnlt34NTR/LPGMRwVwVMNLfMW+7RHfPRYAUaBwd0dfJ4O8ijy6MNy7fNnwBu4R2Wq
         9G6/VPYwhb5cNRzDWN6tw9cvzkyk2H9OV0HSurWh40rJrktYzWRU4gxzwOPXXT6Kha
         UbE449IyCN3cch+REuBgLs/eavnbkO0Uwd7jGlqI=
Date:   Fri, 17 Sep 2021 10:25:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YURQ4ZFDJ8E9MJZM@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kak9moe.ffs@tglx>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 12:32:17AM +0200, Thomas Gleixner wrote:
> Arnd,
> 
> On Wed, Sep 15 2021 at 21:00, Arnd Bergmann wrote:
> > On Tue, Sep 14, 2021 at 1:22 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>  /*
> >>   * Limits for settimeofday():
> >> @@ -124,10 +126,13 @@ static inline bool timespec64_valid_sett
> >>   */
> >>  static inline s64 timespec64_to_ns(const struct timespec64 *ts)
> >>  {
> >> -       /* Prevent multiplication overflow */
> >> -       if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
> >> +       /* Prevent multiplication overflow / underflow */
> >> +       if (ts->tv_sec >= KTIME_SEC_MAX)
> >>                 return KTIME_MAX;
> >>
> >> +       if (ts->tv_sec <= KTIME_SEC_MIN)
> >> +               return KTIME_MIN;
> >> +
> >
> > I just saw this get merged for the stable kernels, and had not seen this when
> > Thomas originally merged it.
> >
> > I can see how this helps the ptp_clock_adjtime() users, but I just
> > double-checked
> > what other callers exist, and I think it introduces a regression in setitimer(),
> > which does
> >
> >         nval = timespec64_to_ns(&value->it_value);
> >         ninterval = timespec64_to_ns(&value->it_interval);
> >
> > without any further range checking that I could find. Setting timers
> > with negative intervals sounds like a bad idea, and interpreting negative
> > it_value as a past time instead of KTIME_SEC_MAX sounds like an
> > unintended interface change.
> >
> > I haven't done any proper analysis of the changes, so maybe it's all
> > good, but I think we need to double-check this, and possibly revert
> > it from the stable kernels until a final conclusion.
> 
> I have done the analysis. setitimer() does not have any problem with
> that simply because it already checks at the call site that the seconds
> value is > 0 and so do all the other user visible interfaces. See
> get_itimerval() ...
> 
> Granted  that the kernel internal interfaces do not have those checks,
> but they already have other safety nets in place to prevent this and I
> could not identify any callsite which has trouble with that change.
> 
> If I failed to spot one then what the heck is the problem? It was broken
> before that change already!
> 
> I usually spend quite some time on tagging patches for stable and it's
> annoying me that this patch got reverted while stuff which I explicitely
> did not tag for stable got backported for whatever reason and completely
> against the stable rules:
> 
>   627ef5ae2df8 ("hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()")
> 
> What the heck qualifies this to be backported?
> 
>  1) It's hot of the press and just got merged in the 5.15-rc1 merge
>     window and is not tagged for stable
> 
>  2) https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
>     clearly states the rules but obviously our new fangled "AI" driven
>     approach to select patches for stable is blissfully ignorant of
>     these rules. I assume that AI stands for "Artifical Ignorance' here.
> 
> I already got a private bug report vs. that on 5.10.65. Annoyingly
> 5.10.5 does not have the issue despite the fact that the resulting diff
> between those two versions in hrtimer.c is just in comments.

Looks like Sasha picked it up with the AUTOSEL process, and emailed you
about this on Sep 5:
	https://lore.kernel.org/r/20210906012153.929962-12-sashal@kernel.org

I will revert it if you don't think it should be in the stable trees.

Also, if you want AUTOSEL to not look at any hrtimer.c patches, just let
us know and Sasha will add it to the ignore-list.

thanks,

greg k-h
