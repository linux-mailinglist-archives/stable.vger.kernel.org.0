Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBA6E33A9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502401AbfJXNOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:14:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45989 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502431AbfJXNOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:14:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id q70so15780879qke.12
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 06:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQHcyUnSIp339K9FKmfDYw9UCbM8Q9Ch8P2/s1FBU9s=;
        b=msl1HfiQYnIpkl7hU80XjsF7bZtllIkrpxf3WO7plSCw75gbGg9RfOzqf2ThJZSI9i
         hySC5uA444uiteodVBFS1PuxXkqcIBEAGVnS9rhaFOgYInfKZb2HE4tv+ORlaR3bd5V7
         6bULjoWlbDAk3UE14BgBJOacrxfygYoQHHuPXVPNi0LoRJcSqnb/qH5qPywqpal6Veo4
         nSXSq5u5REQ7ylpz/K9g4INW6rc8Emxwne+UJN6j7alhtV4PJe+7UK7ju1lsMeLtp7eY
         G1B/60+BQkYSYGxZlGD9iZnpGHT9I2XFZhaoNBH2iEhi+A4e9IbyLeZNH/UH0opzzvl3
         E/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQHcyUnSIp339K9FKmfDYw9UCbM8Q9Ch8P2/s1FBU9s=;
        b=UwLBJesHSHw1abUc5WWHFfTBbaqXUdiZAEfxUCcEJU+gDp420fwKUUgHrau6M6GAiK
         hqh7leoYX9E5ADAw2JDLUPw3NUjiHNguM5k/7RmJs6WC9vyDJcKpm3f1kvn9LmS2lIwX
         EDVlg3g09j8u6c6kC0XS8I+kiTCV+xbBfNmraYfwLwlMoPA2+3GDUKp9AUbOywPIq/RS
         DxofQxMRUv8omJIwNrMJzbdmuc7PFnBh2HrYf3e/zlxRSME7h6KdsZ7v71ZIaAhIjhkM
         FNed138MQbMHtpFdQxqPdu/odrXwJSpPTYd6bDn8cfiQkTcBbNQxrAr0trDvj0On5deT
         Wtyw==
X-Gm-Message-State: APjAAAW484GGPxJddl9iAp9QFubrSTF4EE8y9ZWb3CtFajxbg8PxJC70
        Pm0TtqZbP45OUFCAhcvx6OreHm3i+x6qm6wYN4h7tA==
X-Google-Smtp-Source: APXvYqwZ7apFX/YX+sP24Otc+tiWUNJLzt1FSVCurx1ko1dlteIYXugGs1AhlFccwEmG7l/NhWDo20oDb1SkZ5RCcGw=
X-Received: by 2002:a05:620a:a11:: with SMTP id i17mr3508638qka.8.1571922840980;
 Thu, 24 Oct 2019 06:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com> <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Oct 2019 15:13:48 +0200
Message-ID: <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>,
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

On Thu, Oct 24, 2019 at 3:05 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> On Thu, Oct 24, 2019 at 01:51:20PM +0200, Dmitry Vyukov wrote:
> > On Thu, Oct 24, 2019 at 1:32 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > > How these later loads can be completely independent of the pointer
> > > > value? They need to obtain the pointer value from somewhere. And this
> > > > can only be done by loaded it. And if a thread loads a pointer and
> > > > then dereferences that pointer, that's a data/address dependency and
> > > > we assume this is now covered by READ_ONCE.
> > >
> > > The "dependency" I was considering here is a dependency _between the
> > > load of sig->stats in taskstats_tgid_alloc() and the (program-order)
> > > later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
> > > such a dependency should correspond to a dependency chain at the asm
> > > or registers level from the first load to the later loads; e.g., in:
> > >
> > >   Thread [register r0 contains the address of sig->stats]
> > >
> > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > >      ...
> > >   B: LOAD r2,[r0]       // LOAD *(sig->stats)
> > >   C: LOAD r3,[r2]
> > >
> > > there would be no such dependency from A to C.  Compare, e.g., with:
> > >
> > >   Thread [register r0 contains the address of sig->stats]
> > >
> > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > >      ...
> > >   C: LOAD r3,[r1]       // LOAD *(sig->stats)
> > >
> > > AFAICT, there's no guarantee that the compilers will generate such a
> > > dependency from the code under discussion.
> >
> > Fixing this by making A ACQUIRE looks like somewhat weird code pattern
> > to me (though correct). B is what loads the address used to read
> > indirect data, so B ought to be ACQUIRE (or LOAD-DEPENDS which we get
> > from READ_ONCE).
> >
> > What you are suggesting is:
> >
> > addr = ptr.load(memory_order_acquire);
> > if (addr) {
> >   addr = ptr.load(memory_order_relaxed);
> >   data = *addr;
> > }
> >
> > whereas the canonical/non-convoluted form of this pattern is:
> >
> > addr = ptr.load(memory_order_consume);
> > if (addr)
> >   data = *addr;
>
> No, I'd rather be suggesting:
>
>   addr = ptr.load(memory_order_acquire);
>   if (addr)
>     data = *addr;
>
> since I'd not expect any form of encouragement to rely on "consume" or
> on "READ_ONCE() + true-address-dependency" from myself.  ;-)

But why? I think kernel contains lots of such cases and it seems to be
officially documented by the LKMM:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
address dependencies and ppo
Am I missing something? Why do we need acquire with address dependency?

> IAC, v6 looks more like:
>
>   addr = ptr.load(memory_order_consume);
>   if (!!addr)
>     *ptr = 1;
>   data = *ptr;
>
> to me (hence my comments/questions ...).
>
> Thanks,
>   Andrea
