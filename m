Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509652999CB
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 23:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394562AbgJZWkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 18:40:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43851 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394612AbgJZWkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 18:40:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id l28so14396332lfp.10
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 15:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5mpdK7QEfDL5slMiMMuatEPuKSHdDFbWljAr9yhKWI=;
        b=v55KPbIzkQ6XpCeJxtQgHmpkBNNN3Vy4h0+4aIkEH2igYiZnH3CJAMrDuHf4tTQvx5
         +wXxRLMS9dNA15/QVPY7OUGem1hJkBceu7Qdttdve4KhzOvZExMdsVKYf6MXC5q5nBxM
         ISMeVIjjKOUupiKOaEUrZycc/H68pAdqeHFEeGIWgKeX/aVznb3gEMTl0+pY3SlQwmhL
         4P0OPOFRSDesfWW6znsYcdBpbch5cxisQWglfrmvWLm7vAWsovJGRlypeM3gwYPgCVsJ
         Iz2407lA5bXQ2uYEgM/3LbzxpmTCudk6S2cEF3eN8yhmyvi0FvkkcZ22BJTwAtCS1z+8
         VgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5mpdK7QEfDL5slMiMMuatEPuKSHdDFbWljAr9yhKWI=;
        b=Yj6M1jHLlczTpx6ltjo8Y0L52FQLuj8aoAsCD+hpcelNViuZYXjXI53EQq1PStKDKv
         lJqsthMA6QYhgq41Ub9TBbX3rW8QcSxlyhJ2nV0Kv9Vb9I5qqEEqcjBOnPx4fgFM92fX
         9HnGSZn1A6of47p7+aZWlvLQqI4ecpvcpBxrrEfvAYWM8dyTv27RmnQXdomv+tvjIBsl
         2rk9TNcwOR26KcQ2gculrG02Fn6gNBYkwYH498w9L1fakPo6/wnyJG9XlfR1+9t/F733
         XdioReoflUT/4ja7akzxQHGaW0i770PGq6489CNR4RnGa3zbMYD0AsahEFXJAfKV1kUh
         qjVg==
X-Gm-Message-State: AOAM533Aj4fAmPn250EDCO90mi3fAENodO+VuyZ+5ls2UXFOS04GYUyp
        zQ7TSmiG9LQ4R0qGBlsFtLwPD1VFbU+OWfihlxumHg==
X-Google-Smtp-Source: ABdhPJxjFDjWOwRZrKpaQ7DfqAb76Wdq0EnB5RBSKFjRVQvhEwDyFBnOIEaqJQyewYmpprB2TRhB0ucxFKBwT21u16o=
X-Received: by 2002:a05:6512:52f:: with SMTP id o15mr5593174lfc.381.1603752038729;
 Mon, 26 Oct 2020 15:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org> <CAG48ez2Og6fWUKZbNO5EtYK-jS+J8rf6r+rOyfUp1MUuy4kMyA@mail.gmail.com>
 <20201026215658.GA185792@sol.localdomain>
In-Reply-To: <20201026215658.GA185792@sol.localdomain>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 26 Oct 2020 23:40:12 +0100
Message-ID: <CAG48ez2u-B_DQ5yyiexycTz6okQZvU0rB3+MG1nAFtoahfPa6Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - avoid undefined behavior accessing salg_name
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-hardening@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Oct 26, 2020 at 10:23:35PM +0100, 'Jann Horn' via syzkaller-bugs wrote:
> > On Mon, Oct 26, 2020 at 9:08 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > Commit 3f69cc60768b ("crypto: af_alg - Allow arbitrarily long algorithm
> > > names") made the kernel start accepting arbitrarily long algorithm names
> > > in sockaddr_alg.
> >
> > That's not true; it's still limited by the size of struct
> > sockaddr_storage (128 bytes total for the entire address).
>
> Interesting, so the actual limit is 104 bytes.  It seems like the intent of that
> commit was to make it unlimited, though...
>
> > If you make it longer, __copy_msghdr_from_user() will silently truncate the
> > size.
>
> That's used for sys_sendmsg(), which AFAICT isn't relevant here.  sockaddr_alg
> is used with sys_bind(), which fails with EINVAL if the address is longer than
> sizeof(struct sockaddr_storage).

Ugh, of course you're right, sorry.

> However, since sys_sendmsg() is truncating overly-long addresses, it's probably
> the case that sizeof(struct sockaddr_storage) can never be increased in the
> future...

Eh, I think there'd probably be bigger issues with that elsewhere.

> > > This is broken because the kernel can access indices >= 64 in salg_name,
> > > which is undefined behavior -- even though the memory that is accessed
> > > is still located within the sockaddr structure.  It would only be
> > > defined behavior if the array were properly marked as arbitrary-length
> > > (either by making it a flexible array, which is the recommended way
> > > these days, or by making it an array of length 0 or 1).
> > >
> > > We can't simply change salg_name into a flexible array, since that would
> > > break source compatibility with userspace programs that embed
> > > sockaddr_alg into another struct, or (more commonly) declare a
> > > sockaddr_alg like 'struct sockaddr_alg sa = { .salg_name = "foo" };'.
> > >
> > > One solution would be to change salg_name into a flexible array only
> > > when '#ifdef __KERNEL__'.  However, that would keep userspace without an
> > > easy way to actually use the longer algorithm names.
> > >
> > > Instead, add a new structure 'sockaddr_alg_new' that has the flexible
> > > array field, and expose it to both userspace and the kernel.
> > > Make the kernel use it correctly in alg_bind().
> > [...]
> > > @@ -147,7 +147,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> > >         const u32 allowed = CRYPTO_ALG_KERN_DRIVER_ONLY;
> > >         struct sock *sk = sock->sk;
> > >         struct alg_sock *ask = alg_sk(sk);
> > > -       struct sockaddr_alg *sa = (void *)uaddr;
> > > +       struct sockaddr_alg_new *sa = (void *)uaddr;
> > >         const struct af_alg_type *type;
> > >         void *private;
> > >         int err;
> > > @@ -155,7 +155,11 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> > >         if (sock->state == SS_CONNECTED)
> > >                 return -EINVAL;
> > >
> > > -       if (addr_len < sizeof(*sa))
> > > +       BUILD_BUG_ON(offsetof(struct sockaddr_alg_new, salg_name) !=
> > > +                    offsetof(struct sockaddr_alg, salg_name));
> > > +       BUILD_BUG_ON(offsetof(struct sockaddr_alg, salg_name) != sizeof(*sa));
> > > +
> > > +       if (addr_len < sizeof(*sa) + 1)
> > >                 return -EINVAL;
> > >
> > >         /* If caller uses non-allowed flag, return error. */
> > > @@ -163,7 +167,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> > >                 return -EINVAL;
> > >
> > >         sa->salg_type[sizeof(sa->salg_type) - 1] = 0;
> > > -       sa->salg_name[sizeof(sa->salg_name) + addr_len - sizeof(*sa) - 1] = 0;
> > > +       sa->salg_name[addr_len - sizeof(*sa) - 1] = 0;
> >
> > This looks like an out-of-bounds write in the case `addr_len ==
> > sizeof(struct sockaddr_storage)`.

Sorry, I've been unusually unconcentrated today. Sorry about the
noise, ignore what I said.
