Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C023844EF30
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 23:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhKLWZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 17:25:46 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKLWZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 17:25:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7D85D1C0B76; Fri, 12 Nov 2021 23:22:52 +0100 (CET)
Date:   Fri, 12 Nov 2021 23:22:51 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 5.10 03/77] ARM: 9134/1: remove duplicate memcpy()
 definition
Message-ID: <20211112222251.GC2999@amd>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082511.897153779@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline
In-Reply-To: <20211101082511.897153779@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit eaf6cc7165c9c5aa3c2f9faa03a98598123d0afb upstream.
>=20
> Both the decompressor code and the kasan logic try to override
> the memcpy() and memmove()  definitions, which leading to a clash
> in a KASAN-enabled kernel with XZ decompression:
>=20
> arch/arm/boot/compressed/decompress.c:50:9: error: 'memmove' macro redefi=
ned [-Werror,-Wmacro-redefined]
>  #define memmove memmove
>         ^
> arch/arm/include/asm/string.h:59:9: note: previous definition is here
>  #define memmove(dst, src, len) __memmove(dst, src, len)
>         ^
> arch/arm/boot/compressed/decompress.c:51:9: error: 'memcpy' macro redefin=
ed [-Werror,-Wmacro-redefined]
>  #define memcpy memcpy
>         ^
> arch/arm/include/asm/string.h:58:9: note: previous definition is here
>  #define memcpy(dst, src, len) __memcpy(dst, src, len)
>         ^
>=20
> Here we want the set of functions from the decompressor, so undefine
> the other macros before the override.

AFAICT the conflicting defines are not present in v4.4 or v5.10, so
warnings should not be there and #undefs are not needed.

Best regards,
								Pavel

> +++ b/arch/arm/boot/compressed/decompress.c
> @@ -47,7 +47,10 @@ extern char * strchrnul(const char *, in
>  #endif
> =20
>  #ifdef CONFIG_KERNEL_XZ
> +/* Prevent KASAN override of string helpers in decompressor */
> +#undef memmove
>  #define memmove memmove
> +#undef memcpy
>  #define memcpy memcpy
>  #include "../../../../lib/decompress_unxz.c"
>  #endif
>=20

--=20
http://www.livejournal.com/~pavelmachek

--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGO6TsACgkQMOfwapXb+vKp+QCgpkpTZIuWRDaun+TXrC2xCK8o
zxwAn3B2BFdt3l+k7RFrHfSoDAWzrqEl
=JfEA
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
