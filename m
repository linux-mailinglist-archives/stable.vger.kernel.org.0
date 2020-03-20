Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69B518C639
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 05:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCTECO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 00:02:14 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:56749 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCTECO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 00:02:14 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 73fd51e5;
        Fri, 20 Mar 2020 03:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=DrZKHDCv3yVNJ1fZFCAEuj6SPfo=; b=uX7U8I
        3cN4pBD9fWrWdby/qHhIo8nsgEAjKYehHPQd/Kk5+oHRGab2qYOyNHzu1sZE85c8
        htQjla/nOP1XM7jHo7zwOSGCyTfeETvs+r2Wl7rTsC4PTh4Nks/LcOJ19VwvhoT5
        FsHuGLzDoOjIMLzrwlbcuGPj8p/E4pZKO5pDYN2C9DOGRRJ1znA+kDkNeMvo7QOn
        x4WlbNWrO/PjyG5IcRo/39uB7p7JYhvCtIoWd5kMHuT83+Wd8pru5vMaHmjAYwL6
        L5YIc7UmNSqEKQFgeVKDa+fbJ+UwpT8FUITbYvuhPuZl6AeenGhD7CMl8MBt7ldE
        2yX6nQc3pDdPPQmQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6b52123a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 20 Mar 2020 03:55:37 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id h3so4408075ils.3;
        Thu, 19 Mar 2020 21:02:10 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1bo2sPlAd+yY/4BBIa5uwvnQRxKtqKy1I1TWuGvUWOsUYkuNtz
        OMRcFpcXChjsdqCvHDEGXQkqYsrAEz/XoaW1G5M=
X-Google-Smtp-Source: ADFU+vvnk2NRup2tSSE6Ao36+jOkzoTN5V53qyuvaZ3b1S4VSAqqkaPekitrZcopfvJKgvJcTG6SU87tGVnF/0N1ghw=
X-Received: by 2002:a92:cd4e:: with SMTP id v14mr6534247ilq.231.1584676929893;
 Thu, 19 Mar 2020 21:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
 <20200319022732.166085-1-Jason@zx2c4.com> <20200320034834.GA27372@gondor.apana.org.au>
In-Reply-To: <20200320034834.GA27372@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Mar 2020 22:01:58 -0600
X-Gmail-Original-Message-ID: <CAHmME9qYnb10J+jnBhv3TAfjgvoPeY_3kb4-K+nvZir1YrqvgQ@mail.gmail.com>
Message-ID: <CAHmME9qYnb10J+jnBhv3TAfjgvoPeY_3kb4-K+nvZir1YrqvgQ@mail.gmail.com>
Subject: Re: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk
 through blocks
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 9:48 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Mar 18, 2020 at 08:27:32PM -0600, Jason A. Donenfeld wrote:
> > Prior, passing in chunks of 2, 3, or 4, followed by any additional
> > chunks would result in the chacha state counter getting out of sync,
> > resulting in incorrect encryption/decryption, which is a pretty nasty
> > crypto vuln: "why do images look weird on webpages?" WireGuard users
> > never experienced this prior, because we have always, out of tree, used
> > a different crypto library, until the recent Frankenzinc addition. This
> > commit fixes the issue by advancing the pointers and state counter by
> > the actual size processed. It also fixes up a bug in the (optional,
> > costly) stride test that prevented it from running on arm64.
> >
> > Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> > Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: stable@vger.kernel.org # v5.5+
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  arch/arm64/crypto/chacha-neon-glue.c   |  8 ++++----
> >  lib/crypto/chacha20poly1305-selftest.c | 11 ++++++++---
> >  2 files changed, 12 insertions(+), 7 deletions(-)
>
> Patch applied.  Thanks.

Thanks! No idea whether Linus will skip a 5.6-rc7 with people not at
work due to the quarantines, so given the gravity of this bug, it
might be prudent to send a PR to him _now_, rather then waiting until
next week.

Jason
