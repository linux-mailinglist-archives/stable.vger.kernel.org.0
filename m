Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7633E102EC0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 23:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSWA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 17:00:57 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35202 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfKSWA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 17:00:57 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AD1AB1C1998; Tue, 19 Nov 2019 23:00:55 +0100 (CET)
Date:   Tue, 19 Nov 2019 23:00:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 4.19 025/422] ecryptfs_lookup_interpose():
 lower_dentry->d_inode is not stable
Message-ID: <20191119220055.GC4495@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051401.707458888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20191119051401.707458888@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Al Viro <viro@zeniv.linux.org.uk>
>=20
> commit e72b9dd6a5f17d0fb51f16f8685f3004361e83d0 upstream.
>=20
> lower_dentry can't go from positive to negative (we have it pinned),
> but it *can* go from negative to positive.  So fetching ->d_inode
> into a local variable, doing a blocking allocation, checking that
> now ->d_inode is non-NULL and feeding the value we'd fetched
> earlier to a function that won't accept NULL is not a good idea.
>=20
> Cc: stable@vger.kernel.org
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -345,7 +345,15 @@ static struct dentry *ecryptfs_lookup_in
>  	dentry_info->lower_path.mnt =3D lower_mnt;
>  	dentry_info->lower_path.dentry =3D lower_dentry;
> =20
> -	if (d_really_is_negative(lower_dentry)) {
> +	/*
> +	 * negative dentry can go positive under us here - its parent is not
> +	 * locked.  That's OK and that could happen just as we return from
> +	 * ecryptfs_lookup() anyway.  Just need to be careful and fetch
> +	 * ->d_inode only once - it's not stable here.
> +	 */
> +	lower_inode =3D READ_ONCE(lower_dentry->d_inode);

Should this use d_inode_rcu() function, to keep the abstraction
provided by the header file?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3UZhYACgkQMOfwapXb+vJleQCfUWqbwogZDwonqJGENVIS3Xke
v5kAoKcgNZ6NYe26I2PVjBwGxl4F+EFK
=n2Vo
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
