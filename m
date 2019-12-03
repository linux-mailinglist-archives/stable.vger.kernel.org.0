Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1437410FA6C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 10:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLCJGu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Dec 2019 04:06:50 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36875 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCJGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 04:06:50 -0500
Received: by mail-oi1-f195.google.com with SMTP id x195so2600013oix.4;
        Tue, 03 Dec 2019 01:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=99SpjBDj/3zwk9C1FEoFJcHmxVqPzeCRBXa6juwGTEo=;
        b=TEUHwVtDBshfdDUNHM8pS8IOzahJbWBFwHrmrzXCITlpR5oXGkztp1u2jY26UCg7hk
         koHU4dlOKtPjEPZVx9JUQNWrkx5VN2SXI/fZbG2gcJhoXSQZzz9WTJyEFfE93X9aWM0b
         IBfvF2/gtJh/eCKWOevR/Us2m1Yj8RBOMA+GiVvn+1ZW5DhQazWaeqC3EHUFHtofUo6r
         e0obTx+QUqHk3KqAzPxN4gLFzekg4nCx+Bxw5JepMs46BwMcr1KA9RX/V7gy9bATGApy
         kxqWF7v35WyFC2mHI7AtbkqScfHPeGN54jL9xYk2r2GG0kmcqsJVkQ+le8nEcrSphfe5
         6adg==
X-Gm-Message-State: APjAAAXlnNEnVgUyyjscpwg5fc6iKxoh/wdLydNnpCzaiEUgnCPeXAS6
        zoPPqgWXT4DfnzbyteHqLbyl7ftO4Nnc+KtMARo=
X-Google-Smtp-Source: APXvYqwjoAhTRQ0xt52tIil49EnXS94YzS6iwjxlAYBuKV4vu5fc6aAklzn5FAd1MfYR6UoPe+55WjaSd8AcyJHVit0=
X-Received: by 2002:aca:4e87:: with SMTP id c129mr511543oib.153.1575364009649;
 Tue, 03 Dec 2019 01:06:49 -0800 (PST)
MIME-Version: 1.0
References: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr> <3a95d445-1f5c-7750-f0de-ddc427800b3b@kernel.dk>
In-Reply-To: <3a95d445-1f5c-7750-f0de-ddc427800b3b@kernel.dk>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 3 Dec 2019 10:06:37 +0100
Message-ID: <CAMuHMdUzqnPpbSXB1JaY-+BbAvKno3akSYi6c8ZLQfLuOCC7rg@mail.gmail.com>
Subject: Re: Build failure on latest powerpc/merge (311ae9e159d8 io_uring: fix
 dead-hung for non-iter fixed rw)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

On Fri, Nov 29, 2019 at 5:06 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 11/29/19 6:53 AM, Christophe Leroy wrote:
> >     CC      fs/io_uring.o
> > fs/io_uring.c: In function ‘loop_rw_iter’:
> > fs/io_uring.c:1628:21: error: implicit declaration of function ‘kmap’
> > [-Werror=implicit-function-declaration]
> >       iovec.iov_base = kmap(iter->bvec->bv_page)
> >                        ^
> > fs/io_uring.c:1628:19: warning: assignment makes pointer from integer
> > without a cast [-Wint-conversion]
> >       iovec.iov_base = kmap(iter->bvec->bv_page)
> >                      ^
> > fs/io_uring.c:1643:4: error: implicit declaration of function ‘kunmap’
> > [-Werror=implicit-function-declaration]
> >       kunmap(iter->bvec->bv_page);
> >       ^
> >
> >
> > Reverting commit 311ae9e159d8 ("io_uring: fix dead-hung for non-iter
> > fixed rw") clears the failure.
> >
> > Most likely an #include is missing.
>
> Huh weird how the build bots didn't catch that. Does the below work?

Thanks, this fixes the same issue on SuperH:

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -69,6 +69,7 @@
>   #include <linux/nospec.h>
>   #include <linux/sizes.h>
>   #include <linux/hugetlb.h>
> +#include <linux/highmem.h>
>
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
