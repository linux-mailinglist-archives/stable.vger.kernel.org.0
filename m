Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8D63DA665
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhG2O3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:29:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhG2O3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 10:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627568954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8rprxl3FocOXbhXJPD5+gp5oklLSxk2ZLSSYEsUHTlc=;
        b=FgLCunXTXE7c24XOqCIic3p/zu5cUUS+gtzAiD5NFy+UZE8RTdCJO+K38Fwon9Z0TunQOH
        ovXje0vT56aKGa626XZA8RzOx5UijR7LpearDJcvQ9vHJNpZQq8vUBwxNxHmQdm6IVMKH/
        T0XnI33d7itEAcpfW2eebut8SNtDdEc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-KkMFFx9IMeG_dX7fOlICSg-1; Thu, 29 Jul 2021 10:29:13 -0400
X-MC-Unique: KkMFFx9IMeG_dX7fOlICSg-1
Received: by mail-qk1-f197.google.com with SMTP id p14-20020a05620a22eeb02903b94aaa0909so3908860qki.15
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 07:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8rprxl3FocOXbhXJPD5+gp5oklLSxk2ZLSSYEsUHTlc=;
        b=U3AbBEObAwEJlkmXuodChQ/lvRWrvkpT7IuSwlNw2fYMU6pjKeFRvsZmV6jj9UJfCx
         NEjAiymRALqzKncT8zMHoKFaKCnwnq74bo45z8s+39ETwGkkLKaVzCYYAgdmpsTZpQ1y
         IyGaSxwZHkPPHiIIg3bfqpBi7Kg7UWbTktrX4LLTeWPRBuaJ58wdE3juO/AoWe+vA4cN
         v3l9mjb+uUsa9GwtcrQfrJJXP+am71oobKKu9rH2lL7NKh2vCGB1oCoLbTfp5CPA4RlD
         Sz+2+BbPmSwId8Sn2/MKytkYIopQM9kbuFW/NuESWRBnFCHUJzyD6nVlBeRvEI/C5d/T
         Cgow==
X-Gm-Message-State: AOAM533TYFnqOt5Rvk5aThZnWzKj4Axdkyp3Or2sDPDd7CBukNccOsOU
        yrUwg2cAXMMV+Su8VrrEy/yMiHUkEHV5OPR+5YpBMp5bK+e/pxfvrgP5Sf7jIWAZj5zkeoJD2JX
        BG3YaaQBSZExm+VbZiWYjtRr+o6EzN/RE
X-Received: by 2002:ae9:dcc6:: with SMTP id q189mr5451216qkf.390.1627568952829;
        Thu, 29 Jul 2021 07:29:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7GAxKW9wCI+aT6box4kBql7mgRZBjdR1yCI+w2rMZPZJFjbkNS0X/5I4dfmGXa+D7YqpbFHFfXuDvHA30Dpg=
X-Received: by 2002:ae9:dcc6:: with SMTP id q189mr5451198qkf.390.1627568952606;
 Thu, 29 Jul 2021 07:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153621.2658658-1-gregkh@linuxfoundation.org> <202107261049.DC0C9178@keescook>
In-Reply-To: <202107261049.DC0C9178@keescook>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Thu, 29 Jul 2021 16:29:01 +0200
Message-ID: <CAOssrKdjuUbyHmzwLJFtu-KibPgG3s=LoDq3fgzkv=kTG+mZiQ@mail.gmail.com>
Subject: Re: [PATCH net] af_unix: fix garbage collect vs. MSG_PEEK
To:     Kees Cook <keescook@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 9:27 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jul 26, 2021 at 05:36:21PM +0200, Greg Kroah-Hartman wrote:
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > Gc assumes that in-flight sockets that don't have an external ref can't
>
> I think this commit log could be expanded. I had to really study things
> to even beging to understand what was going on. I assume "Gc" here means
> specifically unix_gc()?

Yeah, the original description was not too good.  Commit cbcf01128d0a
("af_unix: fix garbage collect vs MSG_PEEK") now in Linus' tree has a
much expanded description.

> I note that unix_tot_inflight isn't an atomic but is read outside of
> locking by unix_release_sock() and wait_for_unix_gc(), which seems wrong
> (or at least inefficient).

I don't think it matters in practice.   Do you have specific worries?

> Doesn't this mean total_refs and inflight_refs can still get out of
> sync? What keeps an skb from being "visible" to unix_peek_fds() between
> the unix_gx() spin_unlock() and the unix_peek_fds() fget()?
>
> A: unix_gx():
>         spin_lock()
>         find "total_refs == inflight_refs", add to hitlist
>         spin_unlock()
> B: unix_peek_fds():
>         fget()
> A: unix_gc():
>         walk hitlist and free(skb)
> B: unix_peek_fds():
>         *use freed skb*
>
> I feel like I must be missing something since the above race would
> appear to exist even for unix_attach_fds()/unix_detach_fds():

What you are missing is that anything that could have been peeked must
not have been garbage collected.  I.e. the garbage collection
algorithm will find that there's an external in-flight reference to
the peeked socket and so it will not add it to the hitlist.

Thanks,
Miklos

