Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3CF355C10
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 21:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhDFTPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 15:15:05 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51904 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhDFTPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 15:15:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D2BE21C0BC5; Tue,  6 Apr 2021 21:14:53 +0200 (CEST)
Date:   Tue, 6 Apr 2021 21:14:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Thierry Reding <treding@nvidia.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 5.10 079/126] drm/tegra: sor: Grab runtime PM reference
 across reset
Message-ID: <20210406191452.GA25862@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085033.686284735@linuxfoundation.org>
 <20210405154221.GB305@amd>
 <YGxK64XIou14JBa/@orome.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <YGxK64XIou14JBa/@orome.fritz.box>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > However, these functions alone don't provide any guarantees at the
> > > system level. Drivers need to ensure that the only a single consumer =
has
> > > access to the reset at the same time. In order for the SOR to be able=
 to
> > > exclusively access its reset, it must therefore ensure that the SOR
> > > power domain is not powered off by holding on to a runtime PM referen=
ce
> > > to that power domain across the reset assert/deassert operation.
> >=20
> > Yeah, but it should not leak the PM reference in the error handling.
>=20
> True. However the only reason why the code could realistically fail
> between pm_runtime_resume_and_get() and pm_runtime_put() is if we did
> not take the runtime PM reference (which would cause the call to
> reset_control_acquire() to fail).
>=20
> So the chances of this actually leaking are practically zero, so I
> didn't want to bloat this bugfix with what's essentially dead code. I
> can queue up your fix below for v5.14, though, since it's obviously
> more correct from a theoretical point of view.

Yes, that sounds like good solution, thanks!

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBssywACgkQMOfwapXb+vIt3ACcD7swSealTFQpOV3oi6VRfvXd
YEgAoIionJkH4CL8eN9W/fqhYk0MySi1
=o404
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
