Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433784796B2
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 23:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhLQWBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 17:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhLQWBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 17:01:36 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A246C061574;
        Fri, 17 Dec 2021 14:01:36 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id 107so6852212uaj.10;
        Fri, 17 Dec 2021 14:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoEwO82N8JEJoXnSUG+GSVerpCTUhZOMlIkAkpcH0vQ=;
        b=Xo5yARbZhf+HJHyZ9+lD5Ng7hKxiuYlix90Nptjkg4t9MI+hDvUf1acjGabAWwR1Hh
         vpVxZqovEKlGWkRm1uXZex7OnD/6rEMYUsTnfGHj7G9fqIFjSy4pjjuABQLfAnX1R3ng
         mwDwLcRByce69MErW0yO8jAcvcTe9nj/c5CF//Jw/OdI0T2DJbvxnelSgZthDns9Q/uU
         wjqCpGrRKaTOIWG4yTVGJ8IEV773cnNnkLt+6Siohn0AbLESe90gJZyL+JcBOnE1aMD0
         fhFbX/9apLmNNQTDLXN2c/OXJ4oGhiEw5J9SDYvc8k+yXte5aAWl43kCb9Szl6mw0LiK
         J7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoEwO82N8JEJoXnSUG+GSVerpCTUhZOMlIkAkpcH0vQ=;
        b=GHy293IB30kELNHhbbqX09C1uDW1OHy9fl/0itNDZalnhlIxSvPLP/wGRUpso2Gsg8
         92mQeizkl8H6s0HCPZxJmiCCOIGUxHq/C7VBlUZtq6oi4t7OyvVRcY/XqymQJQcmLnV0
         sHe+jXVGC0w/XiYduJLIOlhZlIaDzhkGEWXivJN5x3UNxnNabEIx9KQqyjfUG4FrUL4Y
         s1W9rDcGKXWcB5F3P568ul0K0ls0zfxsCRNw8jJkgiy9lf4IFmvZ4dK55HjdeEV6sTzW
         /deq2XLzbDQuV5C0wMMFgstU2eqWstl6lTDe2zbZxRwl68dcRVkY0DOPPp3MY24Ljn7N
         AvtQ==
X-Gm-Message-State: AOAM531rrK0fQ4+9+IoryIgLIXOqWtTJm7IWvZCbDDjFknx50i4EwX84
        1eLizlxjggjvjgTJWpNbUiiTBPZSrtFK+OOjFKU=
X-Google-Smtp-Source: ABdhPJyOQlZt+douINckO8KsRS1LBU/hwg7J4MMY8sqbCzTxE/Bdgg6fVJIB4GfB50fc8S0OBdUnDebj2Wgrk+LU4vQ=
X-Received: by 2002:a05:6102:316c:: with SMTP id l12mr2040300vsm.1.1639778495180;
 Fri, 17 Dec 2021 14:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20211217021610.12801-1-yajun.deng@linux.dev> <YbyTuRWkB0gYbn7x@linutronix.de>
 <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
In-Reply-To: <CAPhsuW7GhYyfNOQg3VovU7cqC0nnRTbm1B7bFkWWa75k8YgHew@mail.gmail.com>
From:   Daniel Vacek <neelx.g@gmail.com>
Date:   Fri, 17 Dec 2021 23:01:23 +0100
Message-ID: <CAA7rmPFvJbK_3fx3cphMNGCMBGYobNSyscKbct1g_g5xZYet8w@mail.gmail.com>
Subject: Re: [PATCH v3] lib/raid6: Reduce high latency by using migrate
 instead of preempt
To:     Song Liu <song@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yajun Deng <yajun.deng@linux.dev>, masahiroy@kernel.org,
        williams@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 10:57 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Dec 17, 2021 at 5:42 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > On 2021-12-17 10:16:10 [+0800], Yajun Deng wrote:
> > > We found an abnormally high latency when executing modprobe raid6_pq, the
> > > latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
> > > 67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.
> > >
> > > How to reproduce:
> > >  - Install cyclictest
> > >      sudo apt install rt-tests
> > >  - Run cyclictest example in one terminal
> > >      sudo cyclictest -S -p 95 -d 0 -i 1000 -D 24h -m
> > >  - Modprobe raid6_pq in another terminal
> > >      sudo modprobe raid6_pq
> > >
> > > This is caused by ksoftirqd fail to scheduled due to disable preemption,
> > > this time is too long and unreasonable.
> > >
> > > Reduce high latency by using migrate_disabl()/emigrate_enable() instead of
> > > preempt_disable()/preempt_enable(), the latency won't greater than 100us.
> > >
> > > This patch beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no
> > > effect for CONFIG_PREEMPT_VOLUNTARY=y.
> >
> > Why does it matter? This is only during boot-up/ module loading or do I
> > miss something?
>
> Yes this only happens on boot-up and module loading.I don't know RT well
> enough to tell whether latency during module loading is an issue.

Nope. It is not.

> > The delay is a jiffy so it depends on CONFIG_HZ. You do benchmark for
> > the best algorithm and if you get preempted during that period then your
> > results may be wrong and you make a bad selection.
>
> With current code, the delay _should be_ 16 jiffies. However, the experiment
> hits way longer latencies. I agree this may cause inaccurate benchmark results
> and thus suboptimal RAID algorithm.

I explained this in the original thread. All the observed latencies
are really expected.

> I guess the key question is whether long latency at module loading time matters.
> If that doesn't matter, we should just drop this.

Again, it does not matter at all and here it is rather desired by design.

Drop this, please.

--nX

> Thanks,
> Song
