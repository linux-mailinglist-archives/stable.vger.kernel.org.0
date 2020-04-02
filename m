Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6863B19B9F6
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgDBBgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 21:36:13 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37315 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgDBBgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 21:36:13 -0400
Received: by mail-lf1-f67.google.com with SMTP id t11so1376442lfe.4
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 18:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4NjOGhfdlS01zHiaiGfeK4n/oNGr20mOQ6J0VtQZkU=;
        b=Iy/+QP+K5SVCnjZXEYKbe6gJZoALpPVWnCdKolTHVAcRIpAX95p8NjKGPKSonJCPQl
         f++BgT7PPp9l1iSRQ0/AkB8k2GJ9laThTMzZvs8e1TP/X1f6WX5Cn8xFtFCbwwx3rX8n
         RnnPYSdakwGWTapISLCz8yL9IB8meP8yGhRhNjjZEBk8dsZU1QIY+BK0XB9LSfeKWt0W
         o/ZyWF5EEO830dCD5ifrmYe5HtawBOZlRnV6pZmMlt43dZFsqqFubXhVRsFGQQ1NPDqe
         N9jUDMHkwlob6QtCmqRhRNG5E0keVN4DvKm0VvPZiQO901MdnKX/cFt9MAbYIYKiTjz2
         h+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4NjOGhfdlS01zHiaiGfeK4n/oNGr20mOQ6J0VtQZkU=;
        b=a3FTjfek8MRbFDjo6kHKZGuQJ3siWmERGjs3453FevdqvVL16TWljMkwECXP76pWH0
         LUr1la8iDJqUdGflCvl7t1Gag+Vto+x9cDtxuEhvRdmbRq5XQs6XH0ZkTxDz/aM9JGBO
         uEG8xPEyNsp6vDrgydyedBIaUWJTtYi8amVh2VZIDcncyYeUWId20670hCTEyiN4kRC9
         Vn1Vlwup9qsoNpqs/Q3kyJ81J8BkRp4TmvxoVnLVEgtIwJlVm5zYGnkzZzdasJh9JVg4
         MQJSRYW/wvwjxj1vrcdF/diuA2mqh32FbpQtpt+ZwzPwYSskTVSMvNOS3IhYMf2AcCKV
         QnBA==
X-Gm-Message-State: AGi0PuZelvgSKRa4Z7e0Qb3Z1ozspeGLzGqS28QUUBH9rSYUxyzAZCBd
        s0Sbv7VE4s2u9zJmLO7oR/PGlNVjdAYt9wYuSQgRiQ==
X-Google-Smtp-Source: APiQypJ85uH6hjieFIQ+DVaZ/3dHevVDests4L8XYzQdjxgBwQoqkLkbfa12keCBxd4QZw2RSaoFcAay8z6J77nuKhw=
X-Received: by 2002:a05:6512:3127:: with SMTP id p7mr583281lfd.108.1585791371001;
 Wed, 01 Apr 2020 18:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org> <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
 <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com> <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 2 Apr 2020 03:35:44 +0200
Message-ID: <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 2, 2020 at 1:55 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 1, 2020 at 4:51 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It's literally testing a sequence counter for equality. If you get
> > tearing in the high bits on the write (or the read), you'd still need
> > to have the low bits turn around 4G times to get a matching value.
>
> Put another way: first you'd have to work however many weeks to do 4
> billion execve() calls, and then you need to hit basically a
> single-instruction race to take advantage of it.
>
> Good luck with that. If you have that kind of God-like capability,
> whoever you're attacking stands no chance in the first place.

I'm not really worried about someone being able to hit this in
practice, especially given that the only thing it lets you do is send
signals; I just think that the code is wrong in principle, and that we
should avoid having "technically wrong, but works in practice" code in
the kernel.

This kind of intentional race might also trip up testing tools like
the upcoming KCSAN instrumentation, unless it is specifically
annotated as an intentionally racing instruction. (For now, KCSAN is
64-bit only, so it won't actually be able to detect this though; and
the current KCSAN development branch actually incorrectly considers
WRITE_ONCE() to always be atomic; but still, in principle it's the
kind of issue KCSAN is supposed to detect, I think.)

But even without KCSAN, if we have tearing stores racing with loads, I
think that we ought to *at least* have a comment noting that we're
intentionally doing that so that people don't copy this kind of code
to a place where the high bits change more frequently and correctness
matters more.

Since the read is already protected by the tasklist_lock, an
alternative might be to let the execve path also take that lock to
protect the sequence number update, given that execve is not a
particularly hot path. Or we could hand-code the equality check and
increment operations to be properly race-free.
