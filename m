Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21EB473705
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 22:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbhLMVzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 16:55:12 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33262 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240574AbhLMVzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 16:55:09 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BEE631C0B79; Mon, 13 Dec 2021 22:55:07 +0100 (CET)
Date:   Mon, 13 Dec 2021 22:55:00 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris.paterson2@renesas.com, alice.ferrazzi@miraclelinux.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <20211213215500.GA18010@duo.ucw.cz>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213103536.GC17683@duo.ucw.cz>
 <YbdAE9r9GXZlnyfr@kroah.com>
 <YbdCag/DPOOrweZX@kroah.com>
 <20211213191648.GA21320@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20211213191648.GA21320@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I'm getting a lot of build failures -- missing gmp.h:
> > > >=20
> > > >   UPD     include/generated/utsrelease.h
> > > > 1317In file included from /builds/hVatwYBy/68/cip-project/cip-testi=
ng/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc=
/arm-linux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
> > > > 1318                 from scripts/gcc-plugins/gcc-common.h:7,
> > > > 1319                 from scripts/gcc-plugins/arm_ssp_per_task_plug=
in.c:3:
> > > > 1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/=
gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1=
=2E0/plugin/include/system.h:687:10: fatal error: gmp.h: No such file or di=
rectory
> > > > 1321 #include <gmp.h>
> > > > 1322          ^~~~~~~
> > > > 1323compilation terminated.
> > > > 1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc=
-plugins/arm_ssp_per_task_plugin.so' failed
> > > > 1325
> > > >=20
> > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tre=
e/linux-5.10.y
> > >=20
> > > What gcc plugins are you trying to build with?
> >=20
> > Also, kernelci seems normal for this release:
> > 	https://linux.kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/=
v5.10.84-133-gf6a609e247c6/
> >=20
> > But your tests show problems:
> > 	https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipeli=
nes/428150268/failures
> > all for gcc plugins.
> >=20
> > I did take changes for the gcc plugins to get them to work for gcc 11,
> > maybe gcc8 is too old for them now?
>=20
> Not sure. Maybe they never worked for us, but without test compile,
> they are now enabled and thus can break the build?
>=20
> 1e8600 gcc-plugins: simplify GCC plugin-dev capability test
>=20
> Could be capable of doing that. Let me cc our people doing the
> testing and let me try to do some test compiles...

Ok, so if I revert 1e8600 things start working again:

https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/428666243

as that is only speedup and apparently not needed for following
patches, that might be the easiest solution?

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYbfBNAAKCRAw5/Bqldv6
8shiAKCfhs89DPuerxpXfN2bcYU+APy17ACfbUm4zg0hW2sXMuIWJ4o75x34NDs=
=JEK4
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
