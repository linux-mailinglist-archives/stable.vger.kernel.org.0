Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A543133CAE
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 09:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgAHILv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 03:11:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42778 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAHILv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 03:11:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5DE561C259B; Wed,  8 Jan 2020 09:11:49 +0100 (CET)
Date:   Wed, 8 Jan 2020 09:11:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 040/115] drm: limit to INT_MAX in create_blob ioctl
Message-ID: <20200108081148.GC619@amd>
References: <20200107205240.283674026@linuxfoundation.org>
 <20200107205301.771918206@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <20200107205301.771918206@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-01-07 21:54:10, Greg Kroah-Hartman wrote:
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>=20
> [ Upstream commit 5bf8bec3f4ce044a223c40cbce92590d938f0e9c ]
>=20
> The hardened usercpy code is too paranoid ever since commit 6a30afa8c1fb
> ("uaccess: disallow > INT_MAX copy sizes")

> Code itself should have been fine as-is.
>=20
> Link: http://lkml.kernel.org/r/20191106164755.31478-1-daniel.vetter@ffwll=
=2Ech
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Reported-by: syzbot+fb77e97ebf0612ee6914@syzkaller.appspotmail.com
> Fixes: 6a30afa8c1fb ("uaccess: disallow > INT_MAX copy sizes")

There is no such thing as commit 6a30afa8c1fb. Apparently this is
talking about commit "6d13de1489b6bf539695f96d945de3860e6d5e17", but
that one is not in 4.19-stable.

Do we need this in 4.19-stable?
								Pavel

> +++ b/drivers/gpu/drm/drm_property.c
> @@ -556,7 +556,7 @@ drm_property_create_blob(struct drm_device *dev, size=
_t length,
>  	struct drm_property_blob *blob;
>  	int ret;
> =20
> -	if (!length || length > ULONG_MAX - sizeof(struct drm_property_blob))
> +	if (!length || length > INT_MAX - sizeof(struct drm_property_blob))
>  		return ERR_PTR(-EINVAL);
> =20
>  	blob =3D kvzalloc(sizeof(struct drm_property_blob)+length, GFP_KERNEL);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4VjsQACgkQMOfwapXb+vKqNQCgiNkwp3nBb4NgjoP6vToJP2Wn
hpYAoLmFv3iKEeTaZ0Kw9mGusDOM2zxx
=UxKP
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
