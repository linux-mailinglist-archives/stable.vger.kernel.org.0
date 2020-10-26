Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E6F299931
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 22:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391301AbgJZV5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 17:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390265AbgJZV5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 17:57:01 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 481982084C;
        Mon, 26 Oct 2020 21:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603749420;
        bh=R+obtcU/s4vSbo5rZODZBjaaAgLCDGZtwJiSZGh8KDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R8xepUxVq/1oH7oTecTcsFE+/ejXfnm05vsSH+TJJwytUEdyvNtRMewUARFUPBtEY
         CDw6Dob0BpnHmZrnyTY3CbfSO+/K7Nx8JdTOSO1b9dHyaS2z7Et/o95SgPB+myYR13
         P3Ugescy28F3uwfvh/0+dHZEDLjS1YFy+v1/urWA=
Date:   Mon, 26 Oct 2020 14:56:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jann Horn <jannh@google.com>
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
Subject: Re: [PATCH] crypto: af_alg - avoid undefined behavior accessing
 salg_name
Message-ID: <20201026215658.GA185792@sol.localdomain>
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org>
 <CAG48ez2Og6fWUKZbNO5EtYK-jS+J8rf6r+rOyfUp1MUuy4kMyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2Og6fWUKZbNO5EtYK-jS+J8rf6r+rOyfUp1MUuy4kMyA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:23:35PM +0100, 'Jann Horn' via syzkaller-bugs wrote:
> On Mon, Oct 26, 2020 at 9:08 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Commit 3f69cc60768b ("crypto: af_alg - Allow arbitrarily long algorithm
> > names") made the kernel start accepting arbitrarily long algorithm names
> > in sockaddr_alg.
> 
> That's not true; it's still limited by the size of struct
> sockaddr_storage (128 bytes total for the entire address).

Interesting, so the actual limit is 104 bytes.  It seems like the intent of that
commit was to make it unlimited, though...

> If you make it longer, __copy_msghdr_from_user() will silently truncate the
> size.

That's used for sys_sendmsg(), which AFAICT isn't relevant here.  sockaddr_alg
is used with sys_bind(), which fails with EINVAL if the address is longer than
sizeof(struct sockaddr_storage).

However, since sys_sendmsg() is truncating overly-long addresses, it's probably
the case that sizeof(struct sockaddr_storage) can never be increased in the
future...

> 
> > This is broken because the kernel can access indices >= 64 in salg_name,
> > which is undefined behavior -- even though the memory that is accessed
> > is still located within the sockaddr structure.  It would only be
> > defined behavior if the array were properly marked as arbitrary-length
> > (either by making it a flexible array, which is the recommended way
> > these days, or by making it an array of length 0 or 1).
> >
> > We can't simply change salg_name into a flexible array, since that would
> > break source compatibility with userspace programs that embed
> > sockaddr_alg into another struct, or (more commonly) declare a
> > sockaddr_alg like 'struct sockaddr_alg sa = { .salg_name = "foo" };'.
> >
> > One solution would be to change salg_name into a flexible array only
> > when '#ifdef __KERNEL__'.  However, that would keep userspace without an
> > easy way to actually use the longer algorithm names.
> >
> > Instead, add a new structure 'sockaddr_alg_new' that has the flexible
> > array field, and expose it to both userspace and the kernel.
> > Make the kernel use it correctly in alg_bind().
> [...]
> > @@ -147,7 +147,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> >         const u32 allowed = CRYPTO_ALG_KERN_DRIVER_ONLY;
> >         struct sock *sk = sock->sk;
> >         struct alg_sock *ask = alg_sk(sk);
> > -       struct sockaddr_alg *sa = (void *)uaddr;
> > +       struct sockaddr_alg_new *sa = (void *)uaddr;
> >         const struct af_alg_type *type;
> >         void *private;
> >         int err;
> > @@ -155,7 +155,11 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> >         if (sock->state == SS_CONNECTED)
> >                 return -EINVAL;
> >
> > -       if (addr_len < sizeof(*sa))
> > +       BUILD_BUG_ON(offsetof(struct sockaddr_alg_new, salg_name) !=
> > +                    offsetof(struct sockaddr_alg, salg_name));
> > +       BUILD_BUG_ON(offsetof(struct sockaddr_alg, salg_name) != sizeof(*sa));
> > +
> > +       if (addr_len < sizeof(*sa) + 1)
> >                 return -EINVAL;
> >
> >         /* If caller uses non-allowed flag, return error. */
> > @@ -163,7 +167,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> >                 return -EINVAL;
> >
> >         sa->salg_type[sizeof(sa->salg_type) - 1] = 0;
> > -       sa->salg_name[sizeof(sa->salg_name) + addr_len - sizeof(*sa) - 1] = 0;
> > +       sa->salg_name[addr_len - sizeof(*sa) - 1] = 0;
> 
> This looks like an out-of-bounds write in the case `addr_len ==
> sizeof(struct sockaddr_storage)`.

I think you mean addr_len == sizeof(*sa)?  That's what the
'if (addr_len < sizeof(*sa) + 1) return -EINVAL' above is for.

- Eric
