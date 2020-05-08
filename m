Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02711CB902
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEHUaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 16:30:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56072 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgEHUaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 16:30:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7A1921C025E; Fri,  8 May 2020 22:30:21 +0200 (CEST)
Date:   Fri, 8 May 2020 22:30:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: Re: [PATCH 4.19 32/32] drm/atomic: Take the atomic toys away from X
Message-ID: <20200508203021.GA18233@duo.ucw.cz>
References: <20200508123034.886699170@linuxfoundation.org>
 <20200508123039.718403889@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20200508123039.718403889@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>=20
> commit 26b1d3b527e7bf3e24b814d617866ac5199ce68d upstream.
>=20
> The -modesetting ddx has a totally broken idea of how atomic works:
> - doesn't disable old connectors, assuming they get auto-disable like
>   with the legacy setcrtc
> - assumes ASYNC_FLIP is wired through for the atomic ioctl
> - not a single call to TEST_ONLY
>=20
> Iow the implementation is a 1:1 translation of legacy ioctls to
> atomic, which is a) broken b) pointless.
>=20
> We already have bugs in both i915 and amdgpu-DC where this prevents us
> from enabling neat features.
>=20
> If anyone ever cares about atomic in X we can easily add a new atomic
> level (req->value =3D=3D 2) for X to get back the shiny toys.
>=20
> Since these broken versions of -modesetting have been shipping,
> there's really no other way to get out of this bind.

This is quite crazy. You really should not fight with X like
that. Will it break someone's setup?

> @@ -321,7 +321,12 @@ drm_setclientcap(struct drm_device *dev,
>  	case DRM_CLIENT_CAP_ATOMIC:
>  		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
>  			return -EINVAL;
> -		if (req->value > 1)
> +		/* The modesetting DDX has a totally broken idea of atomic. */
> +		if (current->comm[0] =3D=3D 'X' && req->value =3D=3D 1) {
> +			pr_info("broken atomic modeset userspace detected, disabling atomic\n=
");
> +			return -EOPNOTSUPP;
> +		}
> +		if (req->value > 2)

Really? Checking first letter of command name? Is there no other way
to do it? Should it at least check full command name, so my
XtremeWindowingSystem can continue working?

Is this justified? If this is not an regression, you should simply ask
people to update their X server, not add crazy hack in kernel for
that.

Does it even work? Will not comm[0] be "/" in many cases?

root     13628  1.6  2.5 914196 150524 tty7    Ssl+ Apr19 482:32 /usr/lib/x=
org/Xorg :0 -seat seat0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7 -n=
ovtswitch

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXrXBXQAKCRAw5/Bqldv6
8vpQAJ4zhHO6X7W2juDP9b+LBH5YxRrwgQCgiPy0KmyBeUzQoQO4Zs88noz7E74=
=N84f
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
