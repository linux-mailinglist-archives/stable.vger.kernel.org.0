Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3514E2604E
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 11:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfEVJTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 05:19:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42697 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEVJTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 05:19:03 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 86BFA80378; Wed, 22 May 2019 11:18:50 +0200 (CEST)
Date:   Wed, 22 May 2019 11:18:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH 4.19 067/105] ext4: protect journal inodes blocks using
 block_validity
Message-ID: <20190522091859.GD8174@amd>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115251.802050920@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <20190520115251.802050920@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-05-20 14:14:13, Greg Kroah-Hartman wrote:
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> commit 345c0dbf3a30872d9b204db96b5857cd00808cae upstream.
>=20
> Add the blocks which belong to the journal inode to block_validity's
> system zone so attempts to deallocate or overwrite the journal due a
> corrupted file system where the journal blocks are also claimed by
> another inode.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D202879
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> +static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
> +{
> +	struct inode *inode;
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_map_blocks map;
> +	u32 i =3D 0, err =3D 0, num, n;
> +
> +	if ((ino < EXT4_ROOT_INO) ||
> +	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
> +		return -EINVAL;
> +	inode =3D ext4_iget(sb, ino, EXT4_IGET_SPECIAL);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +	num =3D (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	while (i < num) {
> +		map.m_lblk =3D i;
> +		map.m_len =3D num - i;
> +		n =3D ext4_map_blocks(NULL, inode, &map, 0);
> +		if (n < 0) {
> +			err =3D n;
> +			break;
> +		}

n is unsigned, so this can not happen. Commit 102/ actually fixes this
up. Should they be merged together?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzlFAMACgkQMOfwapXb+vJq4wCgn36T6gqyb9hYAkUACt/sWf6X
Vx4AoLpp/mcCGyVZaXMnQ/iuqO+XYHEf
=vNgS
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
