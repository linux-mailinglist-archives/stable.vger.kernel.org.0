Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED8D457855
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 22:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhKSVuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 16:50:19 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45810 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhKSVuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 16:50:18 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BF5E21C0B76; Fri, 19 Nov 2021 22:47:14 +0100 (CET)
Date:   Fri, 19 Nov 2021 22:47:13 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 5.10 11/21] arm64: vdso32: suppress error message for
 make mrproper
Message-ID: <20211119214713.GB23353@amd>
References: <20211119171443.892729043@linuxfoundation.org>
 <20211119171444.250202515@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <20211119171444.250202515@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 14831fad73f5ac30ac61760487d95a538e6ab3cb upstream.
>=20
> When running the following command without arm-linux-gnueabi-gcc in
> one's $PATH, the following warning is observed:
>=20
> $ ARCH=3Darm64 CROSS_COMPILE_COMPAT=3Darm-linux-gnueabi- make -j72 LLVM=
=3D1 mrproper
> make[1]: arm-linux-gnueabi-gcc: No such file or directory
>=20
> This is because KCONFIG is not run for mrproper, so CONFIG_CC_IS_CLANG
> is not set, and we end up eagerly evaluating various variables that try
> to invoke CC_COMPAT.

Upstream commit is fine, but 5.10 port misses the 2> part of the
change.

> +++ b/arch/arm64/kernel/vdso32/Makefile
> @@ -48,7 +48,8 @@ cc32-as-instr =3D $(call try-run,\
>  # As a result we set our own flags here.
> =20
>  # KBUILD_CPPFLAGS and NOSTDINC_FLAGS from top-level Makefile
> -VDSO_CPPFLAGS :=3D -D__KERNEL__ -nostdinc -isystem $(shell $(CC_COMPAT) =
-print-file-name=3Dinclude)
> +VDSO_CPPFLAGS :=3D -D__KERNEL__ -nostdinc
> +VDSO_CPPFLAGS +=3D -isystem $(shell $(CC_COMPAT) -print-file-name=3Dincl=
ude)
>  VDSO_CPPFLAGS +=3D $(LINUXINCLUDE)
> =20
>  # Common C and assembly flags
>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGYG2EACgkQMOfwapXb+vL4rgCfYzUkzxNDInZpk57h1LGRUuGs
XPcAoMFyVPOXJC4ahYmOp0fi0SWmo7Ip
=osPH
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
