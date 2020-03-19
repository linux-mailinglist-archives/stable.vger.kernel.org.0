Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B8218ABBC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 05:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgCSEZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 00:25:56 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:46005 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCSEZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 00:25:55 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0712e1ae;
        Thu, 19 Mar 2020 04:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=MZwVSXAE6iQ6mpmW/k+rzr/Ifms=; b=Zgc/My
        ZZk5NMR6InJet56FPRr6aq77nJ1M9z70Cp63JHyJW8I6W7iwHL7yNxeKTaGHYO/P
        177+huS83jiGeZdlH5QUbphN9tSl2kymNoGl7aMA1/4z2QF7eo5CURjUcqhwUZLN
        m5uOHrmNxgxfAfb7jmAfo/+1vzod1kcEq4N1xZMGPOw5w0Tjl7zM3/x8bhHBHrd7
        3uhEFSvK9GcUx6SqbhTluWbOKOChtIt1AIO/p0q+74pkrJby6dQYB7GW8MzoZX0/
        ej7nYqtrjLmv5/pMFaaJwlMpF2uXbKBwxjvDk7Qev5orvpN7lTyjEYl/jaTrPwip
        nIeEc93LLGRrDrhA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 653e646b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 04:19:27 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id k29so1035796ilg.0;
        Wed, 18 Mar 2020 21:25:53 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1tOVTljWlaGroE7nUMPNmqjqeoKuVc8XpsDknnGO6MYJsT4GMS
        y69zHjCVgWXvzqzLz33f89Gw2Wj3oS37H8573bo=
X-Google-Smtp-Source: ADFU+vvLWa1F1lZ8noNezKtk4VYJZHBDRdFV9jO6jCrVxgq6Bj5Ed7nFt0P2eILiyqoOf4Sf0kg4Etel8/L8y6bVUHI=
X-Received: by 2002:a92:c990:: with SMTP id y16mr1394184iln.207.1584591952483;
 Wed, 18 Mar 2020 21:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
 <20200319022732.166085-1-Jason@zx2c4.com> <20200319032526.GH2334@sol.localdomain>
In-Reply-To: <20200319032526.GH2334@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 18 Mar 2020 22:25:40 -0600
X-Gmail-Original-Message-ID: <CAHmME9rV7rknXMmjhNj--ZWvya7ZG37tnKQB+vxuqok4nLJwTg@mail.gmail.com>
Message-ID: <CAHmME9rV7rknXMmjhNj--ZWvya7ZG37tnKQB+vxuqok4nLJwTg@mail.gmail.com>
Subject: Re: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk
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

On Wed, Mar 18, 2020 at 9:25 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Mar 18, 2020 at 08:27:32PM -0600, Jason A. Donenfeld wrote:
> > It also fixes up a bug in the (optional, costly) stride test that
> > prevented it from running on arm64.
> [...]
> > diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
> > index c391a91364e9..fa43deda2660 100644
> > --- a/lib/crypto/chacha20poly1305-selftest.c
> > +++ b/lib/crypto/chacha20poly1305-selftest.c
> > @@ -9028,10 +9028,15 @@ bool __init chacha20poly1305_selftest(void)
> >            && total_len <= 1 << 10; ++total_len) {
> >               for (i = 0; i <= total_len; ++i) {
> >                       for (j = i; j <= total_len; ++j) {
> > +                             k = 0;
> >                               sg_init_table(sg_src, 3);
> > -                             sg_set_buf(&sg_src[0], input, i);
> > -                             sg_set_buf(&sg_src[1], input + i, j - i);
> > -                             sg_set_buf(&sg_src[2], input + j, total_len - j);
> > +                             if (i)
> > +                                     sg_set_buf(&sg_src[k++], input, i);
> > +                             if (j - i)
> > +                                     sg_set_buf(&sg_src[k++], input + i, j - i);
> > +                             if (total_len - j)
> > +                                     sg_set_buf(&sg_src[k++], input + j, total_len - j);
> > +                             sg_init_marker(sg_src, k);
> >                               memset(computed_output, 0, total_len);
> >                               memset(input, 0, total_len);
>
> So with this test fix, does this test find the bug?

Yes.

> Apparently the empty scatterlist elements caused some problem?  What was
> that problem exactly?  And what do you mean by this "prevented the test
> from running on arm64"?  If there is a problem it seems we should
> something else about about it, e.g. debug checks that work in consistent
> way on all architectures, documenting what the function expects, or make
> it just work properly with empty scatterlist elements.

Yea, my next plan was to look into what's going on there. In case
you're curious, here's what happens:

[    0.355761] [ffffffff041e9508] pgd=000000004ffe9003,
pud=000000004ffe9003, pmd=0000000000000000
[    0.356212] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[    0.356587] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc5+ #10
[    0.356695] Hardware name: linux,dummy-virt (DT)
[    0.356972] pstate: 20000005 (nzCv daif -PAN -UAO)
[    0.357158] pc : scatterwalk_copychunks+0x13c/0x1e0
[    0.357257] lr : scatterwalk_copychunks+0xe0/0x1e0
[    0.357379] sp : ffffff800f82f970
[    0.357450] x29: ffffff800f82f970 x28: ffffff800f838000
[    0.357607] x27: ffffff800f838000 x26: 0000000000000001
[    0.357725] x25: ffffff800f82faf0 x24: ffffff800f82fa10
[    0.357820] x23: 0000000000000010 x22: 0000000000000000
[    0.357898] x21: 0000000000000000 x20: 0000000100200000
[    0.357978] x19: ffffff8000000000 x18: 0000000000000014
[    0.358132] x17: 0000000000000000 x16: 0000000000000002
[    0.358214] x15: 00000000074c5755 x14: 0000000000000002
[    0.358310] x13: 074c57550311ac67 x12: 09579e470077af1a
[    0.358453] x11: 1d3f98018ec6f5bb x10: 3e6144a223343e11
[    0.358560] x9 : 0000000000000000 x8 : ffffff800f82fcc0
[    0.358638] x7 : 0000000000000000 x6 : ffffff800fa55000
[    0.358711] x5 : 0000000000001000 x4 : 0000000000000000
[    0.358781] x3 : ffffffff001e9540 x2 : ffffffff001e9540
[    0.358855] x1 : ffffffff041e9500 x0 : ffffff800f82fd60
[    0.359007] Call trace:
[    0.359177]  scatterwalk_copychunks+0x13c/0x1e0
[    0.359269]  scatterwalk_map_and_copy+0x50/0xa8
[    0.359339]  chacha20poly1305_crypt_sg_inplace+0x3f4/0x418
[    0.359418]  chacha20poly1305_encrypt_sg_inplace+0x10/0x18
[    0.359511]  chacha20poly1305_selftest+0x4dc/0x618
[    0.359581]  mod_init+0xc/0x2c
[    0.359630]  do_one_initcall+0x58/0x11c
[    0.359687]  kernel_init_freeable+0x174/0x1e0
[    0.359751]  kernel_init+0x10/0x100
[    0.359803]  ret_from_fork+0x10/0x18
[    0.360074] Code: f9400002 530c7c21 927ef442 8b011841 (f9400423)
[    0.360257] ---[ end trace 0b64264f8a25dbdf ]---
[    0.360453] Kernel panic - not syncing: Fatal exception
[    0.360597] SMP: stopping secondary CPUs
[    0.360835] Kernel Offset: disabled
[    0.360985] CPU features: 0x00002,00002000
[    0.361042] Memory Limit: none
