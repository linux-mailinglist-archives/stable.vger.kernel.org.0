Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37269E1C3C
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 15:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405226AbfJWNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 09:20:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40314 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405079AbfJWNU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 09:20:57 -0400
Received: by mail-qk1-f194.google.com with SMTP id y81so15804673qkb.7
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 06:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YwwNpmL2qofOV8Q5k6r574f7T2+vRZXIkcIV7+Y6rBI=;
        b=ZDHJdHlL5AdijBqcdxZsoO9L4x7ScTRmOv8LUuZQbn7FrCQWwG1H0Wz9V/IwI4EQHQ
         McJUW7C8oblxaGBX6LVHOcvt4JetIFSiSRE8gcTvqfHk6zdL57YSeXrRZw0gWglqy/ww
         CzSVjcUdtIvAMTcyppi/1O9Ir2gJdBK1FS/E1v2NMjLVTl/3nXrOQYLFncWEdVSLceL2
         LaUW7pUJ6Q5CI51RvzHExHmD9Cs76brOPn2XG6cUXnU2fNnGy/oyv70avZBEeqfCr+7y
         kGgUfKkD68Es5/rkogjFcO4C4PoDfNmbyKV8v3ZL3f2ioE6XYtd5NvzgBaH9GLdwziZN
         4Rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YwwNpmL2qofOV8Q5k6r574f7T2+vRZXIkcIV7+Y6rBI=;
        b=qXp3QoVA1T9Ts51K+5UaoQmfl2jb+LhUCRLafeOvf6MGyIey3JSGsrl9KmTYkosH0I
         216Y+T6s4Ioy6MwaG87hq9nb9uyPfADKXyPq3f6B5EPBNtZkc2FXiTkjoq4GcbIw4NMe
         xtnknRs3MVSnM80f2+JWQmxVQVSg8rRoRbAqxXYgYJYH15POi1yc3dG3uKvjIgjh+Mmc
         olpD6FEO913+/If6Ofq9wAa+krBHVfp3wqUX7oIoE7QbPNBSldzJ3KwKxZSoGR7WQ5qh
         mfrGqGAUxPZrEFU/FW9wQUprNYhDf9U5DBLETCg9HmJC+8vBrQ/MGnnnnbJAiEsk/7xc
         ulwg==
X-Gm-Message-State: APjAAAUaqu9ZDgVXWlUVDEADnEONyGwAN2H2tuQhV1J45NJG/vyH5yyV
        /EfkBVl20F0Tn6WssNf3bXdNdsB2mgZx4v6ZTTaEiQ==
X-Google-Smtp-Source: APXvYqwm8FLLm/Dz/favs/ArMRNPU0mJU/x4AHqcbIg3zqTnGH6NmjNQEyBE8uKYPGV2+Qnm+JUJIzlbAhW8lIyWEUc=
X-Received: by 2002:a37:4a87:: with SMTP id x129mr8200691qka.43.1571836856063;
 Wed, 23 Oct 2019 06:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com> <20191023131151.ajgnbcvnec3ouc6y@wittgenstein>
In-Reply-To: <20191023131151.ajgnbcvnec3ouc6y@wittgenstein>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Oct 2019 15:20:44 +0200
Message-ID: <CACT4Y+bud1J5jdCvxjs92s+m9PB3vqsi0MXOJ_nR0-2uy_uUrw@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Will Deacon <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 3:11 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Wed, Oct 23, 2019 at 02:39:55PM +0200, Dmitry Vyukov wrote:
> > On Wed, Oct 23, 2019 at 2:16 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > On Mon, Oct 21, 2019 at 01:33:27PM +0200, Christian Brauner wrote:
> > > > When assiging and testing taskstats in taskstats_exit() there's a race
> > > > when writing and reading sig->stats when a thread-group with more than
> > > > one thread exits:
> > > >
> > > > cpu0:
> > > > thread catches fatal signal and whole thread-group gets taken down
> > > >  do_exit()
> > > >  do_group_exit()
> > > >  taskstats_exit()
> > > >  taskstats_tgid_alloc()
> > > > The tasks reads sig->stats without holding sighand lock.
> > > >
> > > > cpu1:
> > > > task calls exit_group()
> > > >  do_exit()
> > > >  do_group_exit()
> > > >  taskstats_exit()
> > > >  taskstats_tgid_alloc()
> > > > The task takes sighand lock and assigns new stats to sig->stats.
> > > >
> > > > The first approach used smp_load_acquire() and smp_store_release().
> > > > However, after having discussed this it seems that the data dependency
> > > > for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> > > > Furthermore, the smp_load_acquire() would only manage to order the stats
> > > > check before the thread_group_empty() check. So it seems just using
> > > > READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> > > > up for discussion at least.
> > >
> > > Mmh, the RELEASE was intended to order the memory initialization in
> > > kmem_cache_zalloc() with the later ->stats pointer assignment; AFAICT,
> > > there is no data dependency between such memory accesses.
> >
> > I agree. This needs smp_store_release. The latest version that I
> > looked at contained:
> > smp_store_release(&sig->stats, stats_new);
>
> This is what really makes me wonder. Can the compiler really re-order
> the kmem_cache_zalloc() call with the assignment.

Yes.
Not sure about compiler, but hardware definitely can. And generally
one does not care if it's compiler or hardware.

> If that's really the
> case then shouldn't all allocation functions have compiler barriers in
> them? This then seems like a very generic problem.

No.
One puts memory barriers into synchronization primitives.
This equally affects memset's, memcpy's and in fact all normal stores.
Adding a memory barrier to every normal store is not the solution to
this. The memory barrier is done before publication of the memory. And
we already have smp_store_release for this. So if one doesn't publish
objects with a plain store (which breaks all possible rules anyways)
and uses a proper primitive, there is no problem.

> > > Correspondingly, the ACQUIRE was intended to order the ->stats pointer
> > > load with later, _independent dereferences of the same pointer; the
> > > latter are, e.g., in taskstats_exit() (but not thread_group_empty()).
> >
> > How these later loads can be completely independent of the pointer
> > value? They need to obtain the pointer value from somewhere. And this
> > can only be done by loaded it. And if a thread loads a pointer and
> > then dereferences that pointer, that's a data/address dependency and
> > we assume this is now covered by READ_ONCE.
> > Or these later loads of the pointer can also race with the store? If
>
> To clarify, later loads as in taskstats_exit() and thread_group_empty(),
> not the later load in the double-checked locking case.
>
> > so, I think they also need to use READ_ONCE (rather than turn this earlier
> > pointer load into acquire).
>
> Using READ_ONCE() in the alloc, taskstat_exit(), and
> thread_group_empty() case.
>
> Christian
