Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC952998B2
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 22:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgJZVYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 17:24:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33506 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731694AbgJZVYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 17:24:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id l2so14110008lfk.0
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 14:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SmqPQzTxMFONQmC5uW8UTd8kW/+6dHu+eNEq5/wa33c=;
        b=wSeeY//9Rx8NmPLlC8ebnjxfkvSlOK1T651eFLQgaKlAx3ugOwHRopjfZxtKpxs6Y7
         ntZMbZ7C2MvOLQpN4xeSh8vgG3GtJLAofXfQG5duXY5A3iYieSds0iZylRXxOiCeX0FQ
         6NJxnkGxBUUDBYUXD8bOUVd3tB6BajLihkAtJRxR2XWDfPdEUoStvV5/vwBsdflIYJ3n
         VEiNccaqVDntWiUVBkdBLgebFvyOH7rzSXjMgf3nu/RqKLH2lf5xznAjvvQKO6vbvyEf
         ahULyn1oCbe/2hOzAkoMjzcPCC+mcY2xgjxoKoOcotiQarHM3SXMPWaqdJr1sqHGmrj5
         BwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SmqPQzTxMFONQmC5uW8UTd8kW/+6dHu+eNEq5/wa33c=;
        b=j5sNXuEA39vbC7oMdTYjdBwRRDGcw6bpqU4IUSsGqxj1+7Q0fBs6M5HL1pe8G8H+01
         nQe0yN88sqkVQJzUcvS9d8/olNZ/nzuElAxoGmUpix1bezW9oXwXNRQLb0vXkX3AVVYk
         Pmi2QKnaihVoE3/sbGQUYbsRWyo3l3AF2aoxWXa41Q4YgrJm20cUiHNjVPO3Z17keV1R
         z8LQPpJsMSTpnUghM5YO2sUGt1766hHA7uZxuWQsgXBNzVlkvgEBz8pvXA1gmizn0ySm
         t38SM/AqhDHnU0NmUaX6rHT9QIAyZqUz+io8TIy5+7xY0TMnPJifpYvZmnFJHpKzkaEK
         wMpQ==
X-Gm-Message-State: AOAM530FRbVgfgp4nJ1SbX9GKNlH6IkLoEDf3XFP6W4MawSjuwoBHBd0
        /JGpXXBzumMrAS9ja4dtT2Qn64d2FmfronF7fWPiHA==
X-Google-Smtp-Source: ABdhPJxfMX7rMGWHEd1Qd4RDbT2HrSTNYD7mItOORVkjg8nDp22FxxINJnBvFvDBminBErNddYPmM+KntioJ8s/qFy4=
X-Received: by 2002:a05:6512:52f:: with SMTP id o15mr5485016lfc.381.1603747442929;
 Mon, 26 Oct 2020 14:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org>
In-Reply-To: <20201026200715.170261-1-ebiggers@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 26 Oct 2020 22:23:35 +0100
Message-ID: <CAG48ez2Og6fWUKZbNO5EtYK-jS+J8rf6r+rOyfUp1MUuy4kMyA@mail.gmail.com>
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

On Mon, Oct 26, 2020 at 9:08 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Commit 3f69cc60768b ("crypto: af_alg - Allow arbitrarily long algorithm
> names") made the kernel start accepting arbitrarily long algorithm names
> in sockaddr_alg.

That's not true; it's still limited by the size of struct
sockaddr_storage (128 bytes total for the entire address). If you make
it longer, __copy_msghdr_from_user() will silently truncate the size.

> This is broken because the kernel can access indices >= 64 in salg_name,
> which is undefined behavior -- even though the memory that is accessed
> is still located within the sockaddr structure.  It would only be
> defined behavior if the array were properly marked as arbitrary-length
> (either by making it a flexible array, which is the recommended way
> these days, or by making it an array of length 0 or 1).
>
> We can't simply change salg_name into a flexible array, since that would
> break source compatibility with userspace programs that embed
> sockaddr_alg into another struct, or (more commonly) declare a
> sockaddr_alg like 'struct sockaddr_alg sa = { .salg_name = "foo" };'.
>
> One solution would be to change salg_name into a flexible array only
> when '#ifdef __KERNEL__'.  However, that would keep userspace without an
> easy way to actually use the longer algorithm names.
>
> Instead, add a new structure 'sockaddr_alg_new' that has the flexible
> array field, and expose it to both userspace and the kernel.
> Make the kernel use it correctly in alg_bind().
[...]
> @@ -147,7 +147,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>         const u32 allowed = CRYPTO_ALG_KERN_DRIVER_ONLY;
>         struct sock *sk = sock->sk;
>         struct alg_sock *ask = alg_sk(sk);
> -       struct sockaddr_alg *sa = (void *)uaddr;
> +       struct sockaddr_alg_new *sa = (void *)uaddr;
>         const struct af_alg_type *type;
>         void *private;
>         int err;
> @@ -155,7 +155,11 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>         if (sock->state == SS_CONNECTED)
>                 return -EINVAL;
>
> -       if (addr_len < sizeof(*sa))
> +       BUILD_BUG_ON(offsetof(struct sockaddr_alg_new, salg_name) !=
> +                    offsetof(struct sockaddr_alg, salg_name));
> +       BUILD_BUG_ON(offsetof(struct sockaddr_alg, salg_name) != sizeof(*sa));
> +
> +       if (addr_len < sizeof(*sa) + 1)
>                 return -EINVAL;
>
>         /* If caller uses non-allowed flag, return error. */
> @@ -163,7 +167,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>                 return -EINVAL;
>
>         sa->salg_type[sizeof(sa->salg_type) - 1] = 0;
> -       sa->salg_name[sizeof(sa->salg_name) + addr_len - sizeof(*sa) - 1] = 0;
> +       sa->salg_name[addr_len - sizeof(*sa) - 1] = 0;

This looks like an out-of-bounds write in the case `addr_len ==
sizeof(struct sockaddr_storage)`.
