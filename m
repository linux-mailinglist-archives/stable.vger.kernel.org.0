Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E422A29A1
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgKBLgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:36:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60488 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgKBLgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 06:36:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 95CE01C0B7D; Mon,  2 Nov 2020 12:36:48 +0100 (CET)
Date:   Mon, 2 Nov 2020 12:36:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201102113648.GB9840@duo.ucw.cz>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
 <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>> perf failures are as usual. powerpc:
> >=20
> > Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> > cs-etm: Move definition of 'traceid_list' global variable from header
> > file") included in 4.19.152 or is a bugfix underway?
> >=20
>=20
> The problem is:
>=20
> In file included from util/evlist.h:15:0,
>                  from util/evsel.c:30:
> util/evsel.c: In function =E2=80=98perf_evsel__exit=E2=80=99:
> util/util.h:25:28: error: passing argument 1 of =E2=80=98free=E2=80=99 di=
scards =E2=80=98const=E2=80=99 qualifier from pointer target type
> /usr/include/stdlib.h:563:13: note: expected =E2=80=98void *=E2=80=99 but=
 argument is of type =E2=80=98const char *=E2=80=99
>  extern void free (void *__ptr) __THROW;
>=20
> This is seen with older versions of gcc (6.5.0 in my case). I have no ide=
a why
> newer versions of gcc/glibc accept this (afaics free() still expects a ch=
ar *,
> not a const char *). The underlying problem is that pmu_name should not be
> declared const char *, but char *, since it is allocated. The upstream ve=
rsion
> of perf no longer uses the same definition of zfree(). It was changed from
> 	#define zfree(ptr) ({ free(*ptr); *ptr =3D NULL; })
> to
> 	#define zfree(ptr) __zfree((void **)(ptr))
> which does the necessary typecast. The fix would be to either change the =
definition
> of zfree to add the typecast, or to change the definition of pmu_name to =
drop the const.
> Both would only apply to v4.19.y. I don't know if either would be accepta=
ble.

As the problem is already fixed in the mainline, either solution
should be acceptable for -stable.

Probably the one adjusting the zfree() is more suitable, as that is
the way it was solved in the mainline.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5/vUAAKCRAw5/Bqldv6
8mfgAJ9bqTjoqjGvlZk42QcL0GkMgyXv5wCcD6REtgSe4R0YPakDwLMVM0xteAo=
=eUJL
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
