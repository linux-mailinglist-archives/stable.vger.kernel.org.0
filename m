Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66886463338
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhK3Lus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:50:48 -0500
Received: from mail-oo1-f50.google.com ([209.85.161.50]:36481 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241436AbhK3LuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 06:50:11 -0500
Received: by mail-oo1-f50.google.com with SMTP id g11-20020a4a754b000000b002c679a02b18so6625853oof.3;
        Tue, 30 Nov 2021 03:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjMUthcTPIiga1LMGsJE+FmlQCkDz2Z0fHsgTYEAKpI=;
        b=dSyP+BKAcc/IwjooLfDZUCInAu+i+htAhWOjO4l+mfRO1sYMVEdz4FH7MXKvQiCaVM
         ocCnzBk82h6nZ//hKEEzgAi9+YT2zV0FZFXWmgtk84d4ZCBrbXsoIGkQAb3TXNchg6Pg
         fmZwAoFtZRgV/vTh3GnYmDbC8YBLrCrDChRYItkk3sLXhf4TpwFGPz875qcDy1UEbgjQ
         326Sd1RiDEiLeKUD5O7UfkC43GtOVNZYgclnZ1TC+TOhG+cTOoG/n8hxzAnwcrBEFHMv
         JLy0wgrYrvk7Ts4AIUlZvghQpULKTw3FBXJFrRTQe/Mhq2dt+vAEkIPUPT+pJg99AAcb
         OjVQ==
X-Gm-Message-State: AOAM532SOX0MUxu9aJqmHvnKSgT0D0j4V+ZhXGJoYbJfE+RxNib4Uu45
        9ZuyyzkhIT/G0Qrrg78sZ2NaixIPfNMTrEwwdmU=
X-Google-Smtp-Source: ABdhPJzZz9fmKhAIzkZDOWBm78WYvwBLWziGXnbzHzeu/W7/mlQoZXyKxNxgTt1MZyDOKnFdVtL1bUeI6KZFAnpn6oc=
X-Received: by 2002:a05:6820:388:: with SMTP id r8mr35255875ooj.0.1638272811661;
 Tue, 30 Nov 2021 03:46:51 -0800 (PST)
MIME-Version: 1.0
References: <20211029122359.1.I1e23f382fbd8beb19fe1c06d70798b292012c57a@changeid>
 <CAE=gft4MRvq-VCBW4EX4dGfPi4s7Lco8h6Z_ejRH5A1e-K2-yA@mail.gmail.com>
 <CAJZ5v0hsGFHxcTb8PUkGSm9oas1wdquB=euofS19zriRc1CXYw@mail.gmail.com>
 <CAE=gft6CjUhkcrmcjVEOp5S+rgqN1_ZGTKbK0DierTanu0d16A@mail.gmail.com>
 <CAJZ5v0gamixc4dkBEXJjjw5zQynuz8BkQ9xv8YpbjkTkdMb2TQ@mail.gmail.com> <CAE=gft6o0JxhDgazPA5DVbL6hQ+36D_GkzgN-AuR3YA43NSqaw@mail.gmail.com>
In-Reply-To: <CAE=gft6o0JxhDgazPA5DVbL6hQ+36D_GkzgN-AuR3YA43NSqaw@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 30 Nov 2021 12:46:34 +0100
Message-ID: <CAJZ5v0ixOCnT_JyQ1gpvc9rdH_zK7gLrke0wJSLUagd=-qf0sA@mail.gmail.com>
Subject: Re: [PATCH] PM / hibernate: Fix snapshot partial write lengths
To:     Evan Green <evgreen@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 5:50 PM Evan Green <evgreen@chromium.org> wrote:
>
> On Wed, Nov 24, 2021 at 4:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Tue, Nov 16, 2021 at 9:22 PM Evan Green <evgreen@chromium.org> wrote:
> > >
> > > On Tue, Nov 16, 2021 at 9:54 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > >
> > > > On Mon, Nov 15, 2021 at 6:13 PM Evan Green <evgreen@chromium.org> wrote:
> > > > >
> > > > > Gentle bump.
> > > > >
> > > > >
> > > > > On Fri, Oct 29, 2021 at 12:24 PM Evan Green <evgreen@chromium.org> wrote:
> > > > > >
> > > > > > snapshot_write() is inappropriately limiting the amount of data that can
> > > > > > be written in cases where a partial page has already been written. For
> > > > > > example, one would expect to be able to write 1 byte, then 4095 bytes to
> > > > > > the snapshot device, and have both of those complete fully (since now
> > > > > > we're aligned to a page again). But what ends up happening is we write 1
> > > > > > byte, then 4094/4095 bytes complete successfully.
> > > > > >
> > > > > > The reason is that simple_write_to_buffer()'s second argument is the
> > > > > > total size of the buffer, not the size of the buffer minus the offset.
> > > > > > Since simple_write_to_buffer() accounts for the offset in its
> > > > > > implementation, snapshot_write() can just pass the full page size
> > > > > > directly down.
> > > > > >
> > > > > > Signed-off-by: Evan Green <evgreen@chromium.org>
> > > > > > ---
> > > > > >
> > > > > >  kernel/power/user.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > > > > > index 740723bb388524..ad241b4ff64c58 100644
> > > > > > --- a/kernel/power/user.c
> > > > > > +++ b/kernel/power/user.c
> > > > > > @@ -177,7 +177,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
> > > > > >                 if (res <= 0)
> > > > > >                         goto unlock;
> > > > > >         } else {
> > > > > > -               res = PAGE_SIZE - pg_offp;
> > > > > > +               res = PAGE_SIZE;
> > > > > >         }
> > > > > >
> > > > > >         if (!data_of(data->handle)) {
> > > > > > --
> > > >
> > > > Do you actually see this problem in practice?
> > >
> > > Yes. I may fire up another thread to explain why I'm stuck doing a
> > > partial page write, and how I might be able to stop doing that in the
> > > future with some kernel help. But either way, this is a bug.
> >
> > OK, patch applied as 5.16-rc material.
> >
> > I guess it should go into -stable kernels too?
>
> Yes, putting it into -stable would make sense also. I should have CCed
> them originally, doing that now.

Well, you need to point them to the upstream commit to backport.

In this particular case it would be

commit 88a5045f176b78c33a269a30a7b146e99c550bd9 (pm-sleep)
Author: Evan Green <evgreen@chromium.org>
Date:   Fri Oct 29 12:24:22 2021 -0700

   PM: hibernate: Fix snapshot partial write lengths

I'll send an inclusion request for this.  I guess it should go into
all of the applicable -stable series, right?
