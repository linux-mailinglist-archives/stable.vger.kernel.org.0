Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF662319AD7
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 08:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBLHqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 02:46:23 -0500
Received: from mx1.emlix.com ([136.243.223.33]:39676 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhBLHp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 02:45:58 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 3B5F45FA8D;
        Fri, 12 Feb 2021 08:44:52 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date:   Fri, 12 Feb 2021 08:44:46 +0100
Message-ID: <5043253.pljLzkpU8D@mobilepool36.emlix.com>
In-Reply-To: <3314666.Em9qtOGRgX@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com> <3314666.Em9qtOGRgX@mobilepool36.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4651014.Q3cAxzu4sR"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart4651014.Q3cAxzu4sR
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date: Fri, 12 Feb 2021 08:44:46 +0100
Message-ID: <5043253.pljLzkpU8D@mobilepool36.emlix.com>
In-Reply-To: <3314666.Em9qtOGRgX@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com> <3314666.Em9qtOGRgX@mobilepool36.emlix.com>

Am Donnerstag, 11. Februar 2021, 11:29:33 CET schrieb Rolf Eike Beer:

> I'm just guessing, but your build error looks like you are also
> cross-building the tools, which is wrong. You want them to be host-tools.
> So don't export PKG_CONFIG_SYSROOT_DIR, it would then try to link target
> libraries into a host binary.

I have looked again how I do it:

# this is for additional _host_ .pc files
export PKG_CONFIG_PATH=3D${prefix}/lib/pkgconfig

Then have a target-pkg-config, so this code inside several kernel Makefiles=
=20
will work:

PKG_CONFIG ?=3D $(CROSS_COMPILE)pkg-config

And then export your PKG_CONFIG_SYSROOT_DIR and the like inside that. I bet=
=20
you have all of this already in place, so just remove the SYSROOT_DIR from=
=20
your kernel build script and things should work.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart4651014.Q3cAxzu4sR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYCYx7gAKCRCr5FH7Xu2t
/NFpA/4qRzioJrV+c8gA4uYr32DEh5trgWBTbP6ErS8e9Ow99Qz5lZUI6ZQyBGvT
I7PizSc19s4hWyt87AbD8syBwBZCRzFkcUYpU4T7a01gIUeQ4Lo7oPIdxG1haO44
kgujtdugBr13B0/HG71ZZuNK2qstq7lDUaGoUn4f/KVbmKKKug==
=R6I3
-----END PGP SIGNATURE-----

--nextPart4651014.Q3cAxzu4sR--



