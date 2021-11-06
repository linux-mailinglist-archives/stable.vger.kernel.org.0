Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D89446F28
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 17:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhKFRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 13:02:29 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50108 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKFRC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 13:02:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 404B61F43EAB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1636217986; bh=0r1swLHxVET117HgXltXN3t3NXGFxmmKr4fDub5VpRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I6SZ2xPbZKTPrdqeRKCuCVLc9/dWDbGXyLn9hMh5pwotkM/obVbDYrFRfufHSpThC
         kgIXPwqgzZTwDMaJ4LtgYASC1/5LXIAbApWODTBksgSuiNno/ERdUAKcLUO/nSWd07
         RLniaYUpUcwr1cRVzJlOIAvps/fljjSPHsWsKLp/gPfmZZOm/N1HYjam/d4vbtf+0d
         rXvvy6ZFkrKdV+JgXmJhn3nhvComVS20vHUSYPze1UEqdJxrb3DBK5XWLqTmPCUg+r
         OJ2OP4rFDGCxAcizAUVChxWDvzbpOOZi/RALrRf6WsCUlSM4D+Ze3UUVXVt54k6S+b
         Pc7+32yTS1ovw==
Received: by earth.universe (Postfix, from userid 1000)
        id 302033C0F95; Sat,  6 Nov 2021 17:59:44 +0100 (CET)
Date:   Sat, 6 Nov 2021 17:59:44 +0100
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Matthias Klose <doko@debian.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: drop cc-option fallbacks for architecture selection
Message-ID: <20211106165944.vstqt3stm2tvudjq@earth.universe>
References: <20211018140735.3714254-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6r27ozfpadfyu6vf"
Content-Disposition: inline
In-Reply-To: <20211018140735.3714254-1-arnd@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6r27ozfpadfyu6vf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 18, 2021 at 04:07:12PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Naresh and Antonio ran into a build failure with latest Debian
> armhf compilers, with lots of output like
>=20
>  tmp/ccY3nOAs.s:2215: Error: selected processor does not support `cpsid i=
' in ARM mode
>=20
> As it turns out, $(cc-option) fails early here when the FPU is not
> selected before CPU architecture is selected, as the compiler
> option check runs before enabling -msoft-float, which causes
> a problem when testing a target architecture level without an FPU:
>=20
> cc1: error: '-mfloat-abi=3Dhard': selected architecture lacks an FPU
>=20
> Passing e.g. -march=3Darmv6k+fp in place of -march=3Darmv6k would avoid t=
his
> issue, but the fallback logic is already broken because all supported
> compilers (gcc-5 and higher) are much more recent than these options,
> and building with -march=3Darmv5t as a fallback no longer works.
>=20
> The best way forward that I see is to just remove all the checks, which
> also has the nice side-effect of slightly improving the startup time for
> 'make'.
>=20
> The -mtune=3Dmarvell-f option was apparently never supported by any mainl=
ine
> compiler, and the custom Codesourcery gcc build that did support is
> now too old to build kernels, so just use -mtune=3Dxscale unconditionally
> for those.
>=20
> This should be safe to apply on all stable kernels, and will be required
> in order to keep building them with gcc-11 and higher.
>=20
> Reported-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D996419
> Cc: Matthias Klose <doko@debian.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks, I ran into this issue after affected gcc release migrated to
Debian testing. The patch makes the kernel compile again:

Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Would be great if this could become part of 5.16-rc1, which is
usually used as base by subsystem maintainers.

Thanks,

-- Sebastian

>  arch/arm/Makefile | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 847c31e7c368..fa45837b8065 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -60,15 +60,15 @@ KBUILD_CFLAGS	+=3D $(call cc-option,-fno-ipa-sra)
>  # Note that GCC does not numerically define an architecture version
>  # macro, but instead defines a whole series of macros which makes
>  # testing for a specific architecture or later rather impossible.
> -arch-$(CONFIG_CPU_32v7M)	=3D-D__LINUX_ARM_ARCH__=3D7 -march=3Darmv7-m -W=
a,-march=3Darmv7-m
> -arch-$(CONFIG_CPU_32v7)		=3D-D__LINUX_ARM_ARCH__=3D7 $(call cc-option,-m=
arch=3Darmv7-a,-march=3Darmv5t -Wa$(comma)-march=3Darmv7-a)
> -arch-$(CONFIG_CPU_32v6)		=3D-D__LINUX_ARM_ARCH__=3D6 $(call cc-option,-m=
arch=3Darmv6,-march=3Darmv5t -Wa$(comma)-march=3Darmv6)
> +arch-$(CONFIG_CPU_32v7M)	=3D-D__LINUX_ARM_ARCH__=3D7 -march=3Darmv7-m
> +arch-$(CONFIG_CPU_32v7)		=3D-D__LINUX_ARM_ARCH__=3D7 -march=3Darmv7-a
> +arch-$(CONFIG_CPU_32v6)		=3D-D__LINUX_ARM_ARCH__=3D6 -march=3Darmv6
>  # Only override the compiler option if ARMv6. The ARMv6K extensions are
>  # always available in ARMv7
>  ifeq ($(CONFIG_CPU_32v6),y)
> -arch-$(CONFIG_CPU_32v6K)	=3D-D__LINUX_ARM_ARCH__=3D6 $(call cc-option,-m=
arch=3Darmv6k,-march=3Darmv5t -Wa$(comma)-march=3Darmv6k)
> +arch-$(CONFIG_CPU_32v6K)	=3D-D__LINUX_ARM_ARCH__=3D6 -march=3Darmv6k
>  endif
> -arch-$(CONFIG_CPU_32v5)		=3D-D__LINUX_ARM_ARCH__=3D5 $(call cc-option,-m=
arch=3Darmv5te,-march=3Darmv4t)
> +arch-$(CONFIG_CPU_32v5)		=3D-D__LINUX_ARM_ARCH__=3D5 -march=3Darmv5te
>  arch-$(CONFIG_CPU_32v4T)	=3D-D__LINUX_ARM_ARCH__=3D4 -march=3Darmv4t
>  arch-$(CONFIG_CPU_32v4)		=3D-D__LINUX_ARM_ARCH__=3D4 -march=3Darmv4
>  arch-$(CONFIG_CPU_32v3)		=3D-D__LINUX_ARM_ARCH__=3D3 -march=3Darmv3m
> @@ -82,7 +82,7 @@ tune-$(CONFIG_CPU_ARM720T)	=3D-mtune=3Darm7tdmi
>  tune-$(CONFIG_CPU_ARM740T)	=3D-mtune=3Darm7tdmi
>  tune-$(CONFIG_CPU_ARM9TDMI)	=3D-mtune=3Darm9tdmi
>  tune-$(CONFIG_CPU_ARM940T)	=3D-mtune=3Darm9tdmi
> -tune-$(CONFIG_CPU_ARM946E)	=3D$(call cc-option,-mtune=3Darm9e,-mtune=3Da=
rm9tdmi)
> +tune-$(CONFIG_CPU_ARM946E)	=3D-mtune=3Darm9e
>  tune-$(CONFIG_CPU_ARM920T)	=3D-mtune=3Darm9tdmi
>  tune-$(CONFIG_CPU_ARM922T)	=3D-mtune=3Darm9tdmi
>  tune-$(CONFIG_CPU_ARM925T)	=3D-mtune=3Darm9tdmi
> @@ -90,11 +90,11 @@ tune-$(CONFIG_CPU_ARM926T)	=3D-mtune=3Darm9tdmi
>  tune-$(CONFIG_CPU_FA526)	=3D-mtune=3Darm9tdmi
>  tune-$(CONFIG_CPU_SA110)	=3D-mtune=3Dstrongarm110
>  tune-$(CONFIG_CPU_SA1100)	=3D-mtune=3Dstrongarm1100
> -tune-$(CONFIG_CPU_XSCALE)	=3D$(call cc-option,-mtune=3Dxscale,-mtune=3Ds=
trongarm110) -Wa,-mcpu=3Dxscale
> -tune-$(CONFIG_CPU_XSC3)		=3D$(call cc-option,-mtune=3Dxscale,-mtune=3Dst=
rongarm110) -Wa,-mcpu=3Dxscale
> -tune-$(CONFIG_CPU_FEROCEON)	=3D$(call cc-option,-mtune=3Dmarvell-f,-mtun=
e=3Dxscale)
> -tune-$(CONFIG_CPU_V6)		=3D$(call cc-option,-mtune=3Darm1136j-s,-mtune=3D=
strongarm)
> -tune-$(CONFIG_CPU_V6K)		=3D$(call cc-option,-mtune=3Darm1136j-s,-mtune=
=3Dstrongarm)
> +tune-$(CONFIG_CPU_XSCALE)	=3D-mtune=3Dxscale
> +tune-$(CONFIG_CPU_XSC3)		=3D-mtune=3Dxscale
> +tune-$(CONFIG_CPU_FEROCEON)	=3D-mtune=3Dxscale
> +tune-$(CONFIG_CPU_V6)		=3D-mtune=3Darm1136j-s
> +tune-$(CONFIG_CPU_V6K)		=3D-mtune=3Darm1136j-s
> =20
>  # Evaluate tune cc-option calls now
>  tune-y :=3D $(tune-y)
> --=20
> 2.29.2
>=20

--6r27ozfpadfyu6vf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmGGtHsACgkQ2O7X88g7
+poOyg/8CrSiTeC8Wx69EGHpwzski/6Da3YzHYtJiLBnZgwTYYtYp+QhXlIFshia
LkHUeFFV9ABjmYPrA2Z785Vfm2w2ttk4A6dBsNrWesyUk4eif9+dGHq6vGwqVRk2
z9MIp4o27JNMKk8DF1xdz0T7RuaKJ+NVKQraZo/EghuFSCPJrMiZCK8Jzm0yYMS2
1jgM2mOVX6NXtACeaPzfB0uIAJVbI7Fo9VN9wkt3s8eVSN0yLGJ7qJc25Wm1qno7
UTuIJnBS+OspbAJGdKGFaizRZbORHv763M+0keqSzKYHxyuvp7lcB9w7C+t7LyWI
fbeFlt/rTZuXuT80LQXhnvyRwloPf1iyaNU8HuvoaXmF+02JtGXahKVIw0FH/LM0
/v6BfPvw/GiCE+HgzaXSa3bxkzRrwYml8vEvscVXNtYJ8SFLQKj590wl08TPwzXO
EeEHbMP4wBxEM8uIkKWct9k5/LpznhLkYR5yuwBQZx+aUidBrDEiQi87VKoTlsqo
6kldXVOmyJqQztESIIKhLXE9EoCy2v6QgicI05GBeugqPEqFRYgGmX8OqxouLuXf
wWZtWh/mhrIpZVTuBWecnQSDbWnzLmYg1NthwoF6J+5PMlM0grBk/2nk0S/mo66f
WcuFdemTiVwL6gEzeH67c1rn1KcmdlfzurfOucnfdrVTGr40DwA=
=6clU
-----END PGP SIGNATURE-----

--6r27ozfpadfyu6vf--
