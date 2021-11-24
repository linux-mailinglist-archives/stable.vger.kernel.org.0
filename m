Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6C45CC25
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350669AbhKXSiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242504AbhKXSiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 13:38:11 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4DEC061574;
        Wed, 24 Nov 2021 10:35:01 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso5638528otf.12;
        Wed, 24 Nov 2021 10:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oH9617U/I6DUrRnDR7qed36ELwMrT7li0leYhJzrg/Q=;
        b=OMApE8FVHQTEHQAlJlWDdzx0Hkuhoy8ec9F6qIx8r+SrqRiCwLxpfi9lj+aIUZvmvh
         Kpqn0fYhcAwYDHoCaVqpUe0lw5GtPbJGNwqH+1jt82etMsOVUDhZO12orREQGQWRbIph
         ctoZ/DcnSuSoUdlxm5Zp5K/gmzyjOph3nJDcryFI/stliQRn6/8RA90XJ0mXwv/WgAoC
         X0OHQFxkL2TGLvPTo2ou+hyEpOxV4OGcx8nT0i9i0JrAX+Ck42w7VzYYhIbmLd5+tYGq
         gR127Jp7DVtKhE+t1kW4/fJCU5V/MK6DlC44PWkVOHNGM4MvgO3Qlrgcac+5NrK5BxRx
         fTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oH9617U/I6DUrRnDR7qed36ELwMrT7li0leYhJzrg/Q=;
        b=1tr1qZgJVecgNtULcVHI6EEazlVjKJEGQACQf/6v7+57HtrYuOgJ8hon/LdI8Xx/OE
         LZpwiYSEIOOQ2b1Gy8po3n3PbvNPcumX+u/A/wx11HQSYywRyXSfBVbmUeEt28b8aaMe
         zQ/mE6RBdwYu0ong1pJKTyK/h/xJyVZCP9qCKfEFiZEe0vYFvFy3gQdT5WVloL+igaZL
         AG+uDMGfcKXI+h7ifgS0RHLbtX9fpfVQbBXYgmVWQ7cegK/oEF/EomOSWhk0LP9gGTC+
         ps9L+NXROlI6qgrVsfLuDM1E2lvHsjqYCv3NzLaOOd86QiHptzvsB+udwItW6/S8m/DD
         EvfQ==
X-Gm-Message-State: AOAM531twmssBxyPD7sZun9pnsG8if4v6f5OJeg8EZksUEhGgNyUoy5p
        sfUr6WgBkFyXv0XEDPoIO54zfdFdlr6DzaINoBY=
X-Google-Smtp-Source: ABdhPJxWqBKi3hO9YjvGnIaDU9k+d5+vybcoHZCPY7s6hCAFNZPj4lQgQtQ/b3shnR02c+nj7oV9jkFcKq/YeXCZgXU=
X-Received: by 2002:a9d:63d2:: with SMTP id e18mr15490894otl.28.1637778901019;
 Wed, 24 Nov 2021 10:35:01 -0800 (PST)
MIME-Version: 1.0
References: <20211124115702.361983534@linuxfoundation.org> <20211124115706.507376250@linuxfoundation.org>
 <619E4ABA.DC78AA58@users.sourceforge.net> <YZ5ayhuOMZwkd9j6@kroah.com>
 <20211124173310.GA12039@mail.hallyn.com> <YZ6BR09OXP8x7lRs@kroah.com>
In-Reply-To: <YZ6BR09OXP8x7lRs@kroah.com>
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Wed, 24 Nov 2021 19:34:50 +0100
Message-ID: <CAJ2a_DejJibTyiiA-+A1WbhcyYD17-h+9FuXL5=sCHEs9Qv+BA@mail.gmail.com>
Subject: Re: [PATCH 5.10 130/154] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alistair Delva <adelva@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>,
        SElinux list <selinux@vger.kernel.org>,
        linux-security-module@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 24, 2021 at 11:33:11AM -0600, Serge E. Hallyn wrote:
> > On Wed, Nov 24, 2021 at 04:31:22PM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Nov 24, 2021 at 04:22:50PM +0200, Jari Ruusu wrote:
> > > > Greg Kroah-Hartman wrote:
> > > > > From: Alistair Delva <adelva@google.com>
> > > > >
> > > > > commit 94c4b4fd25e6c3763941bdec3ad54f2204afa992 upstream.
> > > >  [SNIP]
> > > > > --- a/block/ioprio.c
> > > > > +++ b/block/ioprio.c
> > > > > @@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
> > > > >
> > > > >         switch (class) {
> > > > >                 case IOPRIO_CLASS_RT:
> > > > > -                       if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> > > > > +                       /*
> > > > > +                        * Originally this only checked for CAP_SYS_ADMIN,
> > > > > +                        * which was implicitly allowed for pid 0 by security
> > > > > +                        * modules such as SELinux. Make sure we check
> > > > > +                        * CAP_SYS_ADMIN first to avoid a denial/avc for
> > > > > +                        * possibly missing CAP_SYS_NICE permission.
> > > > > +                        */
> > > > > +                       if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
> > > > >                                 return -EPERM;
> > > > >                         fallthrough;
> > > > >                         /* rt has prio field too */
> > > >
> > > > What exactly is above patch trying to fix?
> > > > It does not change control flow at all, and added comment is misleading.
> > >
> > > See the thread on the mailing list for what it does and why it is
> > > needed.
> > >
> > > It does change the result when selinux is enabled.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The case where we create a newer more fine grained capability which is a
> > sub-cap of a broader capability like CAP_SYS_ADMIN is analogous.  See
> > check_syslog_permissions() for instance.
> >
> > So I think a helper like
> >
> > int capable_either_or(int cap1, int cap2) {
> >       if (has_capability_noaudit(current, cap1))
> >               return 0;
> >       return capable(cap2);
> > }
> >
> > might be worthwhile.
>

I proposed an early prototype at
https://patchwork.kernel.org/project/selinux/patch/20211116112437.43412-1-cgzones@googlemail.com/

> Sure, feel free to work on that and submit it, but for now, this change
> is needed.
>

I would argue this change is not necessary since the actual syscall
still succeeds as this is only an informative avc denial message about
a failed capability check. But this ship has sailed...

> thanks,
>
> greg k-h
