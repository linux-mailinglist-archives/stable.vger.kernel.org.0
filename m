Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E65A154668
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 15:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBFOpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 09:45:13 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33310 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgBFOpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 09:45:12 -0500
Received: by mail-ot1-f66.google.com with SMTP id b18so5708010otp.0;
        Thu, 06 Feb 2020 06:45:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYD6Qn+f8O19n6jnbN4GmWDjU8MnxsjL6RmYBktzX6A=;
        b=XroesZcVBYWRUVanRb6CT3oiXt1PVz4u/55Iae1H7IBjCLRwgiY91Ha5bt1TCL6swk
         Lm39dxXchE0eTzcFeNwQ4qNnFjVf8ecbP6km6URHIdVnRptG6LpSIjvlB/+N9DolgeJu
         nwwcFFJRZgechdj9Xn03/vAQra2MRbrBpLInhMyA9usZHtH/fFBqU/7lrauh5s1T5eJf
         qasb146HczZZUUiMOlBKfJIGps5bJtpEtkpNxOfjv9WZAemXyE+yRIrB8zY+0PxvFPvj
         IZ52fjcbGwlSmC90pT5f1dM/Rhgm91bBqfGcvuLxh0YhiCQtRGJoUDBNrBNzAtLiZIzP
         N4gA==
X-Gm-Message-State: APjAAAWchglkdfrJG+wqaYWYfj1CR3h+Fc8U/Rv0qrcrFQgJITkm0Htb
        w5bCIITQ431kIKr9gTM3j2Ff8xCnsxzVNwUX1U4=
X-Google-Smtp-Source: APXvYqyBBc29/Ijg8aP7euisquvo66G+D60N9QvVlXsbMPCrQqHLz5pKWCMv7f1iVeOMhJHx9xjsFMRcmhcR3vTsNq8=
X-Received: by 2002:a05:6830:1d55:: with SMTP id p21mr30533670oth.145.1581000311584;
 Thu, 06 Feb 2020 06:45:11 -0800 (PST)
MIME-Version: 1.0
References: <20200202161914.9551-1-gilad@benyossef.com>
In-Reply-To: <20200202161914.9551-1-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 6 Feb 2020 15:45:00 +0100
Message-ID: <CAMuHMdVgxBx2x7=nTK0HtvufMNBGLruUD6Y1a0pSnX+CDsvCDA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - dec auth tag size from cryptlen map
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        stable <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gilad,

On Sun, Feb 2, 2020 at 5:19 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Remove the auth tag size from cryptlen before mapping the destination
> in out-of-place AEAD decryption thus resolving a crash with
> extended testmgr tests.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: stable@vger.kernel.org # v4.19+

Thanks, this fixes the crash seen on R-Car H3 ES2.0 with renesas_defconfig,
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n, and CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Remaining issues reported during boot:
  1. alg: skcipher: blocksize for xts-aes-ccree (1) doesn't match
generic impl (16)
  2. alg: aead: rfc4543-gcm-aes-ccree decryption unexpectedly
succeeded on test vector "random: alen=16 plen=39 authsize=16 klen=20
novrfy=1"; expected_error=-EBADMSG or -22, cfg="random: may_sleep
use_digest src_divs=[4.47%@+3553, 30.80%@+4065, 12.0%@+11,
6.22%@+2999, 46.51%@alignmask+3468]"

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
