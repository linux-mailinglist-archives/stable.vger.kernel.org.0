Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05780314F85
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 13:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhBIMxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 07:53:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38794 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhBIMxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 07:53:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BC3E61C0B7A; Tue,  9 Feb 2021 13:52:52 +0100 (CET)
Date:   Tue, 9 Feb 2021 13:52:52 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.4 22/38] elfcore: fix building with clang
Message-ID: <20210209125252.GA23392@duo.ucw.cz>
References: <20210208145805.279815326@linuxfoundation.org>
 <20210208145806.154119176@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20210208145806.154119176@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Arnd Bergmann <arnd@arndb.de>
>=20
> commit 6e7b64b9dd6d96537d816ea07ec26b7dedd397b9 upstream.
>=20
> kernel/elfcore.c only contains weak symbols, which triggers a bug with
> clang in combination with recordmcount:
>=20
>   Cannot find symbol for section 2: .text.
>   kernel/elfcore.o: failed
>=20
> Move the empty stubs into linux/elfcore.h as inline functions.  As only
> two architectures use these, just use the architecture specific Kconfig
> symbols to key off the declaration.

4.4 has this:

config BINFMT_ELF32
        bool
        default y if MIPS32_O32 || MIPS32_N32
                select ELFCORE

in arch/mips. So I believe we'll see problems in that
configuration...?

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYCKFpAAKCRAw5/Bqldv6
8hssAJ9/9h+iulEHzSPXJouUEHjC32p9SwCfVyDRAdN/GYM5bhqrbphR/PNaaaw=
=6SVX
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
