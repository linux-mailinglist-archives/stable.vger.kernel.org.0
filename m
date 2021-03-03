Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF932BC2A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhCCNln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:43 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:53080 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357109AbhCCISX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 03:18:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614759455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZLtfv7liP9sheIHc8guHWd/rOX+DY0HjRXJO3iGx6Ls=;
        b=Z4Q66JixWSvL71IvK1qW7OAR4IaSQ/LKHwRQKdJJTkNP3U0P5XiKwfSSTrKw7AjHvv4JAZ
        tVfjdNBydM7/ZLyDkd177/7lKeyeQ3ZvtC/Uo8AoWsnb+4CZMjXfrBB7fI63lqFQjjwfqz
        o4q8iRuMfVTh4jxex8jMH2mYFuy2vrg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a882ebe5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 3 Mar 2021 08:17:35 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id l8so23582875ybe.12;
        Wed, 03 Mar 2021 00:17:35 -0800 (PST)
X-Gm-Message-State: AOAM533Mv4FzRoZ/z385EeP1c2A3mD1NEN66753+QORL+MFmYNs0ObTY
        gs8fREIB+IQtL3TWLClSBTT2jeBXQx/8o4WISQU=
X-Google-Smtp-Source: ABdhPJz93Q3Jv/QF50GXR2Bhsjbv0T4QxtNh0FljLixDFb+T83c3Ipyvu3CjU+MwvyJ0LwA2MDPxk+24giyiM3mePv8=
X-Received: by 2002:a25:2d1f:: with SMTP id t31mr38765162ybt.239.1614759454472;
 Wed, 03 Mar 2021 00:17:34 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2103030122010.19637@angie.orcam.me.uk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 3 Mar 2021 09:17:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9qgEMdcVgkBkvBZ9Du=ae=wEyQ4uPa+Au8+LEs5ZQCzAg@mail.gmail.com>
Message-ID: <CAHmME9qgEMdcVgkBkvBZ9Du=ae=wEyQ4uPa+Au8+LEs5ZQCzAg@mail.gmail.com>
Subject: Re: [PATCH] crypto: mips/poly1305 - enable for all MIPS processors
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        George Cherian <gcherian@marvell.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>,
        Andy Polyakov <appro@cryptogams.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Maciej,

On Wed, Mar 3, 2021 at 2:16 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> The MIPS Poly1305 implementation is generic MIPS code written such as to
> support down to the original MIPS I and MIPS III ISA for the 32-bit and
> 64-bit variant respectively.  Lift the current limitation then to enable
> code for MIPSr1 ISA or newer processors only and have it available for
> all MIPS processors.

That sounds like a good solution to me. Thanks for doing the research
on it. Assuming your findings hold up:

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

I'm also CC'ing Andy on this, who wrote the original assembly, in case
he has some last minute objection.

Jason

>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: a11d055e7a64 ("crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized implementation")
> Cc: stable@vger.kernel.org # v5.5+
> ---
> On Wed, 3 Mar 2021, Jason A. Donenfeld wrote:
>
> > >> Would you mind sending this for 5.12 in an rc at some point, rather
> > >> than waiting for 5.13? I'd like to see this backported to 5.10 and 5.4
> > >> for OpenWRT.
> > >
> > > why is this so important for OpenWRT ? Just to select CRYPTO_POLY1305_MIPS
> > > ?
> >
> > Yes. The performance boost on Octeon is significant for WireGuard users.
>
>  But that's the wrong fix for that purpose.  I've skimmed over that module
> and there's nothing MIPS64-specific there.  In fact it's plain generic
> MIPS assembly, with some R2 optimisations enabled where applicable but not
> necessary (and then R6 tweaks, but that's irrelevant here).
>
>  As a matter of interest I have just built it successfully for a MIPS I
> DECstation configuration:
>
> $ file arch/mips/crypto/poly1305-mips.ko
> arch/mips/crypto/poly1305-mips.ko: ELF 32-bit LSB relocatable, MIPS, MIPS-I version 1 (SYSV), BuildID[sha1]=d36384d94f60ba7deff638ca8a24500120b45b56, not stripped
> $
>
> Patch included, please apply.
>
>  So while your change is surely right, what you want is this really.
>
>   Maciej
> ---
>  arch/mips/crypto/Makefile |    4 ++--
>  crypto/Kconfig            |    2 +-
>  drivers/net/Kconfig       |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> Index: linux/arch/mips/crypto/Makefile
> ===================================================================
> --- linux.orig/arch/mips/crypto/Makefile
> +++ linux/arch/mips/crypto/Makefile
> @@ -12,8 +12,8 @@ AFLAGS_chacha-core.o += -O2 # needed to
>  obj-$(CONFIG_CRYPTO_POLY1305_MIPS) += poly1305-mips.o
>  poly1305-mips-y := poly1305-core.o poly1305-glue.o
>
> -perlasm-flavour-$(CONFIG_CPU_MIPS32) := o32
> -perlasm-flavour-$(CONFIG_CPU_MIPS64) := 64
> +perlasm-flavour-$(CONFIG_32BIT) := o32
> +perlasm-flavour-$(CONFIG_64BIT) := 64
>
>  quiet_cmd_perlasm = PERLASM $@
>        cmd_perlasm = $(PERL) $(<) $(perlasm-flavour-y) $(@)
> Index: linux/crypto/Kconfig
> ===================================================================
> --- linux.orig/crypto/Kconfig
> +++ linux/crypto/Kconfig
> @@ -772,7 +772,7 @@ config CRYPTO_POLY1305_X86_64
>
>  config CRYPTO_POLY1305_MIPS
>         tristate "Poly1305 authenticator algorithm (MIPS optimized)"
> -       depends on CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
> +       depends on MIPS
>         select CRYPTO_ARCH_HAVE_LIB_POLY1305
>
>  config CRYPTO_MD4
> Index: linux/drivers/net/Kconfig
> ===================================================================
> --- linux.orig/drivers/net/Kconfig
> +++ linux/drivers/net/Kconfig
> @@ -92,7 +92,7 @@ config WIREGUARD
>         select CRYPTO_POLY1305_ARM if ARM
>         select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
>         select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
> -       select CRYPTO_POLY1305_MIPS if CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
> +       select CRYPTO_POLY1305_MIPS if MIPS
>         help
>           WireGuard is a secure, fast, and easy to use replacement for IPSec
>           that uses modern cryptography and clever networking tricks. It's
