Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3969A10534B
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUNjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:39:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59426 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKUNjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 08:39:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 78F5E1C1B7B; Thu, 21 Nov 2019 14:39:19 +0100 (CET)
Date:   Thu, 21 Nov 2019 14:39:19 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 166/422] f2fs: fix memory leak of percpu counter in
 fill_super()
Message-ID: <20191121133918.GA15106@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051409.193853097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20191119051409.193853097@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chao Yu <yuchao0@huawei.com>
>=20
> [ Upstream commit 4a70e255449c9a13eed7a6eeecc85a1ea63cef76 ]
>=20
> In fill_super -> init_percpu_info, we should destroy percpu counter
> in error path, otherwise memory allcoated for percpu counter will
> leak.

> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 58931d55dc1d2..c5d28e92d146e 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -2516,8 +2516,12 @@ static int init_percpu_info(struct f2fs_sb_info *s=
bi)
>  	if (err)
>  		return err;
> =20
> -	return percpu_counter_init(&sbi->total_valid_inode_count, 0,
> +	err =3D percpu_counter_init(&sbi->total_valid_inode_count, 0,
>  								GFP_KERNEL);
> +	if (err)
> +		percpu_counter_destroy(&sbi->alloc_valid_block_count);
> +
> +	return err;
>  }

Are you sure this is good idea? Normally when _init() fails, the thing
is not allocated, and there is nothing to destroy...

If you are right, there's same bug in fs/xfs/xfs_buf.c .

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdaThgAKCRAw5/Bqldv6
8tH8AJ0Ruqu80UgKnnneJwc+YmADySjjqgCfQmZgg+xyO9X/oIf4LYnYdhp+5Mg=
=dWS4
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
