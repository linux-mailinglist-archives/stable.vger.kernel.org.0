Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1212218AA51
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 02:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSBdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 21:33:33 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:37707 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSBdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 21:33:33 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ab13c9fe;
        Thu, 19 Mar 2020 01:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=tbcq0Axwh/JCWoU7MoZFYwgJiLg=; b=YDvQto
        OSHTMslNq2WZ1KXNACW9+HFA8PUj+L0xzCytT/Yf3Erm0TadPRNyDbo3hlNcQDtP
        QFSoNA9at8Y0pc05Cv0I7js9EJo5ibqIleXIYbEdOxiNiy4zXC+nJYf+w12ILRLe
        gMC9tomWTsuamgpbLfzXI7WO2Sg+hfFntfw1akLVVY4+IRIrRAEBMBced92ZRdyg
        gO6wnXDlpA1/mAZXmYOUGTTZdnrAUojCzgkeKQahd/7QhjwuFlva8lT+pH4IoRgR
        6y5XXHjwwAxdqKk/MWfrtxFgK3959VJt0t82BCvD3dHrX6GNLmorrFydm93DsoX4
        Tobk62KxeByIuxbw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e9c52afb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 01:27:04 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id p1so737731ils.5;
        Wed, 18 Mar 2020 18:33:29 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1l+qhaRz9jed+HRS5mZKCweV6/lp4nFaqvRZpCDXDU4VQUhu2T
        W5nQY4i2i/rs8Ub/4/hQPOWNwtNYpR1UgJ3T0N4=
X-Google-Smtp-Source: ADFU+vvrGYpI+OaDphhDjrefdHS6y36hdlyfqznfvb/SncGk9mGJ8cnLFNQbtq7omqAImuJ0wndJxEnWVJhEI6H4xo0=
X-Received: by 2002:a92:c52b:: with SMTP id m11mr1034387ili.38.1584581609026;
 Wed, 18 Mar 2020 18:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200318234518.83906-1-Jason@zx2c4.com> <20200319002359.GF2334@sol.localdomain>
In-Reply-To: <20200319002359.GF2334@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 18 Mar 2020 19:33:18 -0600
X-Gmail-Original-Message-ID: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
Message-ID: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
Subject: Re: [PATCH URGENT crypto] crypto: arm64/chacha - correctly walk
 through blocks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Eric,

On Wed, Mar 18, 2020 at 6:24 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Thanks for fixing this!  We definitely should get this fix to Linus for 5.6.
> But I don't think your description of this bug dating back to 2018 is accurate,
> because this bug only affects the new library interface to ChaCha20 which was
> added in v5.5.  In the "regular" crypto API case, the "walksize" is set to
> '5 * CHACHA_BLOCK_SIZE', and chacha_doneon() is guaranteed to be called with a
> multiple of '5 * CHACHA_BLOCK_SIZE' except at the end.  Thus the code worked
> fine with the regular crypto API.

Ahhh, that seems correct.

> > +             state[12] += round_up(l, CHACHA_BLOCK_SIZE) / CHACHA_BLOCK_SIZE;
>
> Use DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE)?

Duh, oops, thanks. Will send a v2 in a few minutes.

By the way, I took a brief look at the other implementations
accessible from lib/crypto and I didn't see the same issue over there.
But I wouldn't mind an extra pair of eyes, if you want to give it a
quick look too.

Jason
