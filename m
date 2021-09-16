Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3C540EBE3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 22:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhIPU7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 16:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhIPU7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 16:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9ECD610E9;
        Thu, 16 Sep 2021 20:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631825894;
        bh=Ij3jy+0naXru4qplk2bFcqix18civQibXeaMryrF+n4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z8pVXEu4B/ZFwImGV+e0oxjTvSZzaqDvzqQifzG93U2ND4dV+og6/OrL30UfC5ufI
         keJt+/WOo2E+lZBPtS6oARgu51nWob6/YqioyXNfzFn0Vn3URyKlrX8L68BeSmTmPD
         +qwL0aejOmC5J6qJTwXp9loxqBCYSKJ85kyI+YLsthLje6yRLWc6XqpqCHyPD8yJhy
         UaO1JJwtAJMvIwCmgqXkZMiy2WZAtHsSSeBRXohyMrrFhnMYmDSR3ovEs2k2IzjI85
         4XwaB41zX5IHsIxjhe2Fanhw0yZhzBHE6DaQXuXXboIPmPkTvncLPHfFxGknWslAtv
         XA4hJswstJ3NQ==
Received: by mail-wm1-f53.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so8367097wmc.0;
        Thu, 16 Sep 2021 13:58:13 -0700 (PDT)
X-Gm-Message-State: AOAM533EBFuNJIOfpESy0yrh5Orzd4lUiE2XlegYA2LhQ7Ro2DHnTCr2
        go6VzvtX+2W2eIc7ffYBl1wb1Ufqag7IuQG9Ei4=
X-Google-Smtp-Source: ABdhPJzdSEKjGdtI6wQE+5SV8fBCl5xZ2dy9zyjsOAJwrpUh2YykjqSEE+GnZrRbGnbWRbmDbp12sTT9+vDHdvZWH3w=
X-Received: by 2002:a05:600c:896:: with SMTP id l22mr11717834wmp.173.1631825892472;
 Thu, 16 Sep 2021 13:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com> <AM0PR01MB5410E0963A0AF9A525509DB2EEDC9@AM0PR01MB5410.eurprd01.prod.exchangelabs.com>
In-Reply-To: <AM0PR01MB5410E0963A0AF9A525509DB2EEDC9@AM0PR01MB5410.eurprd01.prod.exchangelabs.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 16 Sep 2021 22:57:56 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Cnr7LjWmXqSbhnc_jyjseCCztxLv8+v5ojhLXJ+_MyQ@mail.gmail.com>
Message-ID: <CAK8P3a0Cnr7LjWmXqSbhnc_jyjseCCztxLv8+v5ojhLXJ+_MyQ@mail.gmail.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in timespec64_to_ns()
To:     OPENSOURCE Lukas Hannen 
        <lukas.hannen@opensource.tttech-industrial.com>
Cc:     "EMC: linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 6:50 PM OPENSOURCE Lukas Hannen
<lukas.hannen@opensource.tttech-industrial.com> wrote:
>
> > I can see how this helps the ptp_clock_adjtime() users, but I just double-checked what
> > other callers exist, and I think it introduces a regression in setitimer(), which does
> >
> >         nval = timespec64_to_ns(&value->it_value);
> >         ninterval = timespec64_to_ns(&value->it_interval);
> >
> > without any further range checking that I could find. Setting timers with negative intervals
> > sounds like a bad idea, and interpreting negative it_value as a past time instead of KTIME_SEC_MAX
> > sounds like an unintended interface change.
>
> Hello Arnd,
>
> I have looked into this, and it seems like before your
> commit bd40a175769d ("y2038: itimer: change implementation to timespec64")
> the "clamping and converting to positive ns" was done using timeval_to_ktime()
> and ktime_to_ns().

Actually, looking back at this change, I see that there was an
explicit timeval_valid()
check in get_itimerval(), and this was moved around but is still
there, I guess we're
good for this syscall, and the user-visible behavior never actually changed.

> When Commit c5021b2547ad ( "time: Prevent undefined behaviour in timespec64_to_ns()" )
> put this functionally into timespec64_to_ns(), the patchnotes mentioned the clamping to
> KTIME_SEC_MAX, but did not mention the explicit need to return KTIME_SEC_MAX for any
> negative input.

Right.

> Since timespec64_to_ns() is widely used in drivers, where negative nanosecond values are
> quite sensible, I propose to view both of the effects I mentioned above as separate functionalities,
>
> either to be implemented as separate functions in time64.h (named, for example, timespec64_to_ns()
> and timespec64_to_positive_ns),

I don't mind having the common version work the way it does after your patch, I
was only worried about silently changing the behavior for a documented syscall.

> or alternatively, since the setitimer() code seems to be the only one not expecting negative nanoseconds
> out of timespec64_to_ns() when fed negative input, the clamping of negative nanosecond values
> to KTIME_SEC_MAX to be moved into the setitimer() code, and timespec64_to_ns() to be changed
> according to the patch I submitted.
>
> Both of those alternatives seem trivial and I can send in patches for both of them,
> but since this is more a matter of style I would like to hear your opinions on this beforehand.

It looks like we don't have to do anything for setitimer(), but that
was just the first one that
I happened to look at. Did you check the other instances to see if
anything might be going
wrong there? If they are all good,  then I have no other concerns and
we should probably
put your fix back into the stable kernels (Greg has just reverted it
after my initial mail).

I went through all instances other than the ptp related ones, and I'm
pretty confident
that they are all good now, in each case either your patch fixes a bug
or the value is
already known to be positive and it doesn't matter. Are you confident
that the ptp
instances are all good as well?

I did stumble over one small detail:

        if (ts->tv_sec <= KTIME_SEC_MIN)
                return KTIME_MIN;

I think this is not entirely correct for the case of tv_sec==KTIME_SEC_MIN
with a nonzero tv_nsec, as we now round down to the full second. Not sure
if that's worth changing, as we also round up for any value between
KTIME_SEC_MAX*NSEC_PER_SEC and KTIME_MAX, or between
KTIME_MIN and KTIME_SEC_MIN*NSEC_PER_SEC.
In practice I guess we care very little about the last nanosecond in the corner
cases.

        Arnd
