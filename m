Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7DACDBDC
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 08:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfJGG2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 02:28:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46763 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfJGG2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 02:28:52 -0400
Received: by mail-io1-f67.google.com with SMTP id c6so25967637ioo.13
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F+oN7OhnQuDvPSd+hXHX3nHOZPOSv2CcWvqNvOXGack=;
        b=d5LjPYjP+oNF04YEV5GbXFOT9tv6SH9ye5Tbl6yGeP0zjdpS+DlWNLTBe0M/MDPXqU
         R0F1KG0AnpPuAqsEq4RR2+ddYspdUw5CZKPJfJEKsF68KIA4nvRK1nEGQz2nmeqlXNBJ
         4S2D7ehGpwiiCuqug+J03fCCb1b3fpOvFcSIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F+oN7OhnQuDvPSd+hXHX3nHOZPOSv2CcWvqNvOXGack=;
        b=E32wSbmrEeKELq/kIk1kxVZthzIfIiqoC1XNX5zorGXJHbBwlGSrqOEuMCq1w159Oy
         ZKkPJMI6gX2uS1+co6gQ0GR8sm/hIn29Z6pvQixBKwhrQ9IWO+CVmG///gvO0RZph48W
         WSMFlk9FrBriEZX2DtIMva8f+4EA4MkTk5SF0FXqWtSKWs4w6N0AHSUz3BxHWGOUZd1S
         8lz3gM7ZTWm+i2wuD1oj/pNF69sOSzyYDmR84vWkZ5yJ9lgyD5GI9G+Tj3+IwneELwwi
         SSOlOxe3RZVdZZhnKtY6eT+2PZh8TOMTdAXxav3gtR1vKChayRC81gmF2qSvamG//EZo
         pmjg==
X-Gm-Message-State: APjAAAXzv2ss1nIFwW0dou74AuNfgEK8XTpB6JfA6bpVfbmwFbvaAwiS
        zQY18NMwhy46UF8JiElg84K4Th8AaE6c4a1Aj9uV7A==
X-Google-Smtp-Source: APXvYqyKVIPCD1bpT+A3W2k0M7W9D8lrhhjDLqSK6n+0PrJuZ2ksgWc+AfWhMWKW5xHnyCK35m4ZP3jAL3uh28nm/TQ=
X-Received: by 2002:a92:d847:: with SMTP id h7mr10737243ilq.85.1570429731325;
 Sun, 06 Oct 2019 23:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191006172016.873463083@linuxfoundation.org> <20191006172018.480360174@linuxfoundation.org>
 <20191006173202.GA832@sol.localdomain> <20191006182433.GA217738@kroah.com>
In-Reply-To: <20191006182433.GA217738@kroah.com>
From:   Mattias Nissler <mnissler@chromium.org>
Date:   Sun, 6 Oct 2019 23:28:40 -0700
Message-ID: <CAKUbbxKbR6R_VM233pkw7_rxv_DMJoBPC_U5ZgVkR6GpXVAScw@mail.gmail.com>
Subject: Re: [PATCH 4.9 30/47] ANDROID: binder: remove waitqueue when thread exits.
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Todd Kjos <tkjos@google.com>, Martijn Coenen <maco@android.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(resend, apologies for accidental HTML reply)

On Sun, Oct 6, 2019 at 11:24 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Oct 06, 2019 at 10:32:02AM -0700, Eric Biggers wrote:
> > On Sun, Oct 06, 2019 at 07:21:17PM +0200, Greg Kroah-Hartman wrote:
> > > From: Martijn Coenen <maco@android.com>
> > >
> > > commit f5cb779ba16334b45ba8946d6bfa6d9834d1527f upstream.
> > >
> > > binder_poll() passes the thread->wait waitqueue that
> > > can be slept on for work. When a thread that uses
> > > epoll explicitly exits using BINDER_THREAD_EXIT,
> > > the waitqueue is freed, but it is never removed
> > > from the corresponding epoll data structure. When
> > > the process subsequently exits, the epoll cleanup
> > > code tries to access the waitlist, which results in
> > > a use-after-free.
> > >
> > > Prevent this by using POLLFREE when the thread exits.
> > >
> > > Signed-off-by: Martijn Coenen <maco@android.com>
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Cc: stable <stable@vger.kernel.org> # 4.14
> > > [backport BINDER_LOOPER_STATE_POLL logic as well]
> > > Signed-off-by: Mattias Nissler <mnissler@chromium.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/android/binder.c |   17 ++++++++++++++++-
> > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > >
> > > --- a/drivers/android/binder.c
> > > +++ b/drivers/android/binder.c
> > > @@ -334,7 +334,8 @@ enum {
> > >     BINDER_LOOPER_STATE_EXITED      = 0x04,
> > >     BINDER_LOOPER_STATE_INVALID     = 0x08,
> > >     BINDER_LOOPER_STATE_WAITING     = 0x10,
> > > -   BINDER_LOOPER_STATE_NEED_RETURN = 0x20
> > > +   BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
> > > +   BINDER_LOOPER_STATE_POLL        = 0x40,
> > >  };
> > >
> > >  struct binder_thread {
> > > @@ -2628,6 +2629,18 @@ static int binder_free_thread(struct bin
> > >             } else
> > >                     BUG();
> > >     }
> > > +
> > > +   /*
> > > +    * If this thread used poll, make sure we remove the waitqueue
> > > +    * from any epoll data structures holding it with POLLFREE.
> > > +    * waitqueue_active() is safe to use here because we're holding
> > > +    * the inner lock.
> > > +    */
> > > +   if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
> > > +       waitqueue_active(&thread->wait)) {
> > > +           wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
> > > +   }
> > > +
> > >     if (send_reply)
> > >             binder_send_failed_reply(send_reply, BR_DEAD_REPLY);
> > >     binder_release_work(&thread->todo);
> > > @@ -2651,6 +2664,8 @@ static unsigned int binder_poll(struct f
> > >             return POLLERR;
> > >     }
> > >
> > > +   thread->looper |= BINDER_LOOPER_STATE_POLL;
> > > +
> > >     wait_for_proc_work = thread->transaction_stack == NULL &&
> > >             list_empty(&thread->todo) && thread->return_error == BR_OK;
> > >
> >
> > Are you sure this backport is correct, given that in 4.9, binder_poll()
> > sometimes uses proc->wait instead of thread->wait?:

Jann's PoC calls the BINDER_THREAD_EXIT ioctl to free the
binder_thread which will then cause the UAF, and this is cut off by
the patch. IIUC, you are worried about a similar AUF on the proc->wait
access. I am not 100% sure, but I think the binder_proc lifetime
matches the corresponding struct file instance, so it shouldn't be
possible to get the binder_proc deallocated while still being able to
access it via filp->private_data.

> >
> >         wait_for_proc_work = thread->transaction_stack == NULL &&
> >                 list_empty(&thread->todo) && thread->return_error == BR_OK;
> >
> >         binder_unlock(__func__);
> >
> >         if (wait_for_proc_work) {
> >                 if (binder_has_proc_work(proc, thread))
> >                         return POLLIN;
> >                 poll_wait(filp, &proc->wait, wait);
> >                 if (binder_has_proc_work(proc, thread))
> >                         return POLLIN;
> >         } else {
> >                 if (binder_has_thread_work(thread))
> >                         return POLLIN;
> >                 poll_wait(filp, &thread->wait, wait);
> >                 if (binder_has_thread_work(thread))
> >                         return POLLIN;
> >         }
> >         return 0;
>
> I _think_ the backport is correct, and I know someone has verified that
> the 4.4.y backport works properly and I don't see much difference here
> from that version.
>
> But I will defer to Todd and Martijn here, as they know this code _WAY_
> better than I do.  The codebase has changed a lot from 4.9.y to 4.14.y
> so it makes it hard to do equal comparisons simply.
>
> Todd and Martijn, thoughts?
>
> thanks,
>
> greg k-h
