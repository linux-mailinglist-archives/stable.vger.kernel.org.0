Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAEDE1AE3
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390574AbfJWMkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 08:40:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36836 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390403AbfJWMkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 08:40:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so17400931qto.3
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 05:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHrU87Sp2KOFYTsvWXjU9c1Yq8vcTmrg/74YWaKD3a8=;
        b=V0U8f57hbh/kqVmvb4NEPwMp/oVE2TvJJWWuT8r2xtWeb2kjEKRohU30BBj1D4O2un
         4Asp50Vk4TlgIM4WOGwFVlt/TKVbThDn4wyzVG59Zg9+ehmrTo5NkWDVECEvYB/p05ij
         89oRzrjxzraFKPjN92uVcsNx6zorvZm3IXBPH0CJnFkAR5xewOtEd+zm7O/1awHRUvka
         gzQC9ZXN4h8zvTHMuZSl/BqXLn6DFqWjwp8DRxUAQoKbeC/souX0wtOIWdofNAByg3P0
         Va5RZDDIzcEaNgGF1aVCdJs+hTI8BcvIB0LhK1Gn37xmbwkx14+Hsx2pRSHXAnmh6ST1
         LA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHrU87Sp2KOFYTsvWXjU9c1Yq8vcTmrg/74YWaKD3a8=;
        b=Fejwq7w6MCvzW0zXa2bCVOV9c1Kqt50ppchYiWC2p8Sn3gXj6UthfuPTUZWmAMaL5I
         oNoW1FMVYiRvFxBumPeQpz0GJU4YmltnYUbS0avbTHjlr+/vbsYAadP/r5V1EsyzeRdZ
         VPcQwMry32mc/idAlrQXfJq5jzzg+lQNK/Gkp/UfPNbBoCtz0MBOrK7L4kHRwzoec1k5
         LIuYJOcZzbGYTCOMiW3UPw5bi5bbP//wFUoLVL05uwhEk7u6wCxLKzf1gDJcw+z5HJXZ
         CkiDPOU0KGxksufdujUf1yuKjsnDJzF3jeGIp0GQIa82e2A2KGE/XT2MunyiUueFoZHY
         wLxg==
X-Gm-Message-State: APjAAAW388YB5oLlyYFWRKB+uwFBN5SJfFk7SgOUGqh1QsLgrVfNeaJ2
        k1YWH2HC5k8UVucYJm7K0nL7C57/G4glwTPwevjSwg==
X-Google-Smtp-Source: APXvYqxmYjzw+S8GEZ4LSXFaGlWKYoIc87ESkRfbQVUthnxlSIcx3JRuSQnJS6UdQAlWpKex6x4TgBf0F79RTchEsJo=
X-Received: by 2002:a0c:fec3:: with SMTP id z3mr8670778qvs.122.1571834406888;
 Wed, 23 Oct 2019 05:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Oct 2019 14:39:55 +0200
Message-ID: <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
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

On Wed, Oct 23, 2019 at 2:16 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> On Mon, Oct 21, 2019 at 01:33:27PM +0200, Christian Brauner wrote:
> > When assiging and testing taskstats in taskstats_exit() there's a race
> > when writing and reading sig->stats when a thread-group with more than
> > one thread exits:
> >
> > cpu0:
> > thread catches fatal signal and whole thread-group gets taken down
> >  do_exit()
> >  do_group_exit()
> >  taskstats_exit()
> >  taskstats_tgid_alloc()
> > The tasks reads sig->stats without holding sighand lock.
> >
> > cpu1:
> > task calls exit_group()
> >  do_exit()
> >  do_group_exit()
> >  taskstats_exit()
> >  taskstats_tgid_alloc()
> > The task takes sighand lock and assigns new stats to sig->stats.
> >
> > The first approach used smp_load_acquire() and smp_store_release().
> > However, after having discussed this it seems that the data dependency
> > for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> > Furthermore, the smp_load_acquire() would only manage to order the stats
> > check before the thread_group_empty() check. So it seems just using
> > READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> > up for discussion at least.
>
> Mmh, the RELEASE was intended to order the memory initialization in
> kmem_cache_zalloc() with the later ->stats pointer assignment; AFAICT,
> there is no data dependency between such memory accesses.

I agree. This needs smp_store_release. The latest version that I
looked at contained:
smp_store_release(&sig->stats, stats_new);

> Correspondingly, the ACQUIRE was intended to order the ->stats pointer
> load with later, _independent dereferences of the same pointer; the
> latter are, e.g., in taskstats_exit() (but not thread_group_empty()).

How these later loads can be completely independent of the pointer
value? They need to obtain the pointer value from somewhere. And this
can only be done by loaded it. And if a thread loads a pointer and
then dereferences that pointer, that's a data/address dependency and
we assume this is now covered by READ_ONCE.
Or these later loads of the pointer can also race with the store? If
so, I think they also need to use READ_ONCE (rather than turn this earlier
pointer load into acquire).


> Looking again, I see that fill_tgid_exit()'s dereferences of ->stats
> are protected by ->siglock: maybe you meant to rely on such a critical
> section pairing with the critical section in taskstats_tgid_alloc()?
>
> That memcpy(-, tsk->signal->stats, -) at the end of taskstats_exit()
> also bugs me: could these dereferences of ->stats happen concurrently
> with other stores to the same memory locations?
>
> Thanks,
>   Andrea
