Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C898318833
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBKKco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:32:44 -0500
Received: from mx1.emlix.com ([136.243.223.33]:37006 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhBKKaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:30:35 -0500
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id D0C965F9C9;
        Thu, 11 Feb 2021 11:29:39 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date:   Thu, 11 Feb 2021 11:29:33 +0100
Message-ID: <3314666.Em9qtOGRgX@mobilepool36.emlix.com>
In-Reply-To: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1763431.qQEGOizavN"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart1763431.qQEGOizavN
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date: Thu, 11 Feb 2021 11:29:33 +0100
Message-ID: <3314666.Em9qtOGRgX@mobilepool36.emlix.com>
In-Reply-To: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com>

Am Dienstag, 9. Februar 2021, 09:44:33 CET schrieb Rolf Eike Beer:
> Am Dienstag, 9. Februar 2021, 05:59:56 CET schrieb Daniel D=C3=ADaz:
> > When compiling under OpenEmbedded, the following error is seen
> >=20
> > as of recently:
> >   /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
> >   /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a
> >=20
> > inside / /srv/oe/build/tmp/hosttools/ld: cannot find
> > /lib/ld-linux-x86-64.so.2 inside / collect2: error: ld returned 1 exit
> > status
> >=20
> >   make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1
>=20
> [...]
>=20
> > As per `make`'s documentation:
> >   LDFLAGS
> >  =20
> >     Extra flags to give to compilers when they are supposed to
> >     invoke the linker, =E2=80=98ld=E2=80=99, such as -L. Libraries (-lf=
oo)
> >     should be added to the LDLIBS variable instead.
> >  =20
> >   LDLIBS
> >  =20
> >     Library flags or names given to compilers when they are
> >     supposed to invoke the linker, =E2=80=98ld=E2=80=99. LOADLIBES is a
> >     deprecated (but still supported) alternative to LDLIBS.
> >     Non-library linker flags, such as -L, should go in the
> >     LDFLAGS variable.
>=20
> Correct. And the patch I use for my local 4.19 build actually uses LDLIBS,
> so it must have gone wrong in some rebase for one of the intermediate
> versions.
>=20
> Acked-by: Rolf Eike Beer <eb@emlix.com>

Ok, now actually with proper testing: no, your patch doesn't work. When=20
changing LDLIBS to LDFLAGS things do not show up on the commandline at all.

LDLIBS:

  gcc -Wp,-MMD,scripts/.sign-file.d -Wall -Wmissing-prototypes -Wstrict-
prototypes -O2 -fomit-frame-pointer -std=3Dgnu89      -I/opt/emlix/test/inc=
lude=20
=2DI ./scripts   -o scripts/sign-file /tmp/e2/build/linux-kernel/scripts/si=
gn-
file.c   -L/opt/emlix/test/lib -lcrypto -lz -ldl -pthread

LDFLAGS:

  gcc -Wp,-MMD,scripts/.sign-file.d -Wall -Wmissing-prototypes -Wstrict-
prototypes -O2 -fomit-frame-pointer -std=3Dgnu89      -I/opt/emlix/test/inc=
lude=20
=2DI ./scripts   -o scripts/sign-file /tmp/e2/build/linux-kernel/scripts/si=
gn-
file.c  =20

When looking closely you may notice that this is not entirely the same as=20
current master would output: I missed the CFLAGS for sign-file in my patch.=
=20
When testing your patch I accidentially had a .config that had module=20
signatures disabled, so I have not tested it actually, that's why I didn't=
=20
notice that it doesn't work.

I'm just guessing, but your build error looks like you are also cross-build=
ing=20
the tools, which is wrong. You want them to be host-tools. So don't export=
=20
PKG_CONFIG_SYSROOT_DIR, it would then try to link target libraries into a h=
ost =20
binary.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart1763431.qQEGOizavN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYCUHDQAKCRCr5FH7Xu2t
/DlBA/wOmT/FOjxipuiCwOtBZgASLr30Dy6hPGnMuwoyu7rJzoBkWrvAKE/Q3XTN
QCRTOcL/DTjJLjxTUBgyfQDgRSDIXCf6h1LYo5zBZV8YTYEeih9T1W4pNNNhD1yv
LKnI1Pgku3dHQhHgcM+3SWY+Vfxb7u9WyoPsvf4o2qXOwJsKrQ==
=hlG6
-----END PGP SIGNATURE-----

--nextPart1763431.qQEGOizavN--



