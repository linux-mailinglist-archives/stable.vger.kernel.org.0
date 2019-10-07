Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B93CDE4D
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 11:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfJGJiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 05:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfJGJiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 05:38:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B1C21655;
        Mon,  7 Oct 2019 09:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570441101;
        bh=3zhwfHIcLxbbQ+KpMXuhI+igbeHR1uDpFIhjOQRNKws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xhb9NYnljNV1xaVQoNXkMjTFv8xFVwvlhvXK4T26Gs97v9UHxKRdpu+nh7lconEFf
         LaCA52oK2CY9iuiQSync4Amm0bhSZeC0dviaQ3ejyxtBkyzHUoF8aKDt+3Ed3clXCW
         TS3MgAFsmDHpRMFHKaLl8QSae5HIAOztyxbzJvYY=
Date:   Mon, 7 Oct 2019 11:38:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Martijn Coenen <maco@android.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Mattias Nissler <mnissler@chromium.org>
Subject: Re: [PATCH 4.9 30/47] ANDROID: binder: remove waitqueue when thread
 exits.
Message-ID: <20191007093819.GA84909@kroah.com>
References: <20191006172016.873463083@linuxfoundation.org>
 <20191006172018.480360174@linuxfoundation.org>
 <CAB0TPYGO8Nm_Qz0kzSvX69NApiPwu4xV19F=KhyLe5DO3DoLTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB0TPYGO8Nm_Qz0kzSvX69NApiPwu4xV19F=KhyLe5DO3DoLTw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 11:33:53AM +0200, Martijn Coenen wrote:
> On Sun, Oct 6, 2019 at 7:23 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Martijn Coenen <maco@android.com>
> >
> > commit f5cb779ba16334b45ba8946d6bfa6d9834d1527f upstream.
> >
> > binder_poll() passes the thread->wait waitqueue that
> > can be slept on for work. When a thread that uses
> > epoll explicitly exits using BINDER_THREAD_EXIT,
> > the waitqueue is freed, but it is never removed
> > from the corresponding epoll data structure. When
> > the process subsequently exits, the epoll cleanup
> > code tries to access the waitlist, which results in
> > a use-after-free.
> >
> > Prevent this by using POLLFREE when the thread exits.
> >
> > Signed-off-by: Martijn Coenen <maco@android.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Cc: stable <stable@vger.kernel.org> # 4.14
> > [backport BINDER_LOOPER_STATE_POLL logic as well]
> > Signed-off-by: Mattias Nissler <mnissler@chromium.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/android/binder.c |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -334,7 +334,8 @@ enum {
> >         BINDER_LOOPER_STATE_EXITED      = 0x04,
> >         BINDER_LOOPER_STATE_INVALID     = 0x08,
> >         BINDER_LOOPER_STATE_WAITING     = 0x10,
> > -       BINDER_LOOPER_STATE_NEED_RETURN = 0x20
> > +       BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
> > +       BINDER_LOOPER_STATE_POLL        = 0x40,
> >  };
> >
> >  struct binder_thread {
> > @@ -2628,6 +2629,18 @@ static int binder_free_thread(struct bin
> >                 } else
> >                         BUG();
> >         }
> > +
> > +       /*
> > +        * If this thread used poll, make sure we remove the waitqueue
> > +        * from any epoll data structures holding it with POLLFREE.
> > +        * waitqueue_active() is safe to use here because we're holding
> > +        * the inner lock.
> 
> This should be "global lock" in 4.9 and 4.4 :)

I'll go update the comment now, thanks!

> Otherwise LGTM, thanks!

thanks for the review.

greg k-h
