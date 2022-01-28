Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346C749FE31
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbiA1QhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:37:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38284 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350198AbiA1QhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 11:37:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C1260A37;
        Fri, 28 Jan 2022 16:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E01C340E7;
        Fri, 28 Jan 2022 16:37:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WPFDHaST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643387830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=guMFLMofiqe5xiQ2BRsEVmO5w5+mC76cL6WiryePP2M=;
        b=WPFDHaSTuo9cwPUupNClF1shvSf/TIevVpkraCRUH76k02rT29m2qByqhBfQEsIyhmcJRl
        nBLgcMHUwfHVN3F55umgCkvQkOXM01TFoM7VXMDBMGNKo0oMMe/fKeuKKoXhQ2psiO1hEH
        JOf9xDGK+UQNaBH2GjHFBponi4zHdGw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 87c3a824 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 28 Jan 2022 16:37:10 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id g14so20060351ybs.8;
        Fri, 28 Jan 2022 08:37:10 -0800 (PST)
X-Gm-Message-State: AOAM531G8xB1LijkHOqTguMwtjoViu76odh3lojCVazlBVmtJqWTSqx7
        e8ePGxirtCwFyzm41++lq0qp7hHK0ldUwUg7cB4=
X-Google-Smtp-Source: ABdhPJy1iWCC+Hxhg7PgyfiasJi3h1JaHkK5F4sYfUNJqUKwZaOS7KLWZ5w7OUg3uouEzt6KRyGZxjOdxsqI2MakiA4=
X-Received: by 2002:a05:6902:1501:: with SMTP id q1mr14890230ybu.638.1643387828559;
 Fri, 28 Jan 2022 08:37:08 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com> <YfQPVp8TULSq3V+l@linutronix.de>
 <CAHmME9pmdeLBKJbTaVQv-z9J81qKA=R4uoZ1DeXABy6Lt3bXuA@mail.gmail.com> <YfQWlM9b4l2IO43l@linutronix.de>
In-Reply-To: <YfQWlM9b4l2IO43l@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 28 Jan 2022 17:36:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9pmGAAsUf4bLABB6oCDqDxVZBcQzADiDoA8ZD2s5n_1LQ@mail.gmail.com>
Message-ID: <CAHmME9pmGAAsUf4bLABB6oCDqDxVZBcQzADiDoA8ZD2s5n_1LQ@mail.gmail.com>
Subject: Re: [PATCH] random: remove batched entropy locking
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sebastian,

I wrote in my last message, "I don't think that thread needs to spill
over here, though," but clearly you disagreed, which is fine I guess.
Replies inline below:

On Fri, Jan 28, 2022 at 5:15 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> > I did, and my reply is here:
> > https://lore.kernel.org/lkml/CAHmME9pzdXyD0oRYyCoVUSqqsA9h03-oR7kcNhJuPEcEMTJYgw@mail.gmail.com/
> >
> > I was hoping for a series that addresses these issues. As I mentioned
> > before, I'm not super keen on deferring that processing in a
> > conditional case and having multiple entry ways into that same
> > functionality. I don't think that's worth it, especially if your
> > actual concern is just userspace calling RNDADDTOENTCNT too often
> > (which can be safely ratelimited). I don't think that thread needs to
>
> And what do you do in ratelimiting?

If I'm understanding the RT issue correctly, the problem is that
userspace can `for (;;) iotl(...);`, and the high frequency of ioctls
then increases the average latency of interrupts to a level beyond the
requirements for RT. The idea of ratelimiting the ioctl would be so
that userspace is throttled from calling it too often, so that the
average latency isn't increased.

> As I explained, you get 20 that
> "enter" and the following are block. The first 20 are already
> problematic and you need a plan-B for those that can't enter.
> So I suggested a mutex_t around the ioctl() which would act as a rate
> limiting. You did not not follow up on that idea.

A mutex_t would be fine I think? I'd like to see what this looks like
in code, but conceptually I don't see why not.

> Please ignore Jonathan report for now. As I tried to explain: This
> lockdep report shows a serious problem on PREEMPT_RT. There is _no_ need
> to be concerned on a non-PREEMPT_RT kernel. But it should be addressed.
> If this gets merged as-is then thanks to the stable tag it will get
> backported (again no change for !RT) and will collide with PREEMPT_RT
> patch. And as I mentioned, the locking is not working on PREEMPT_RT.

Gotcha, okay, that makes sense. It sounds like Andy's patch and your
patch might both be part of the same non-stable-marked coin for
cutting down on locks in the IRQ path.

[Relatedly, I've been doing a bit of research on other ways to cut
down the amount of processing we're doing in the IRQ path, such as
<https://xn--4db.cc/K4zqXPh8/diff>. This is really not ready to go,
and I'm not ready to have a discussion on the crypto there (please,
nobody comment on the crypto there yet; I'll be really annoyed), but
the general gist is that I think it might be possible to reduce the
number of cycles spent in IRQ with some nice new tricks.]

Jason
