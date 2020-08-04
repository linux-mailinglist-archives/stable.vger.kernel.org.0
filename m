Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9CD23B56C
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgHDHLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:11:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46652 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgHDHLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 03:11:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E137A1C0BD7; Tue,  4 Aug 2020 09:11:32 +0200 (CEST)
Date:   Tue, 4 Aug 2020 09:11:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 09/56] btrfs: inode: Verify inode mode to avoid NULL
 pointer dereference
Message-ID: <20200804071132.d6awebnvt7gnqfkb@duo.ucw.cz>
References: <20200803121850.306734207@linuxfoundation.org>
 <20200803121850.766021165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yjcilnnh4hcnw3yn"
Content-Disposition: inline
In-Reply-To: <20200803121850.766021165@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yjcilnnh4hcnw3yn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> @@ -6993,6 +7010,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_i=
node *inode,
>  	extent_start =3D found_key.offset;
>  	if (found_type =3D=3D BTRFS_FILE_EXTENT_REG ||
>  	    found_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> +		/* Only regular file could have regular/prealloc extent */
> +		if (!S_ISREG(inode->vfs_inode.i_mode)) {
> +			ret =3D -EUCLEAN;
> +			btrfs_crit(fs_info,
> +		"regular/prealloc extent found for non-regular inode %llu",
> +				   btrfs_ino(inode));
> +			goto out;
> +		}

This sets ret, but function returns err. Fix was already submitted.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yjcilnnh4hcnw3yn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXykKJAAKCRAw5/Bqldv6
8lPtAKCAuPe8M3HnW3Z3IA/nVTAhwsI54gCfesblQgYJ/89COm5D1BJQiW3/AVM=
=dtAj
-----END PGP SIGNATURE-----

--yjcilnnh4hcnw3yn--
