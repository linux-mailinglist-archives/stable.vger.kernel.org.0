Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7A12FB45
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgACRMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:12:16 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52412 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgACRMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:12:15 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D641E1C2461; Fri,  3 Jan 2020 18:12:13 +0100 (CET)
Date:   Fri, 3 Jan 2020 18:12:13 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 062/114] f2fs: choose hardlimit when softlimit is
 larger than hardlimit in f2fs_statfs_project()
Message-ID: <20200103171213.GC14328@amd>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220035.294585461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20200102220035.294585461@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chengguang Xu <cgxu519@mykernel.net>
>=20
> [ Upstream commit 909110c060f22e65756659ec6fa957ae75777e00 ]
>=20
> Setting softlimit larger than hardlimit seems meaningless
> for disk quota but currently it is allowed. In this case,
> there may be a bit of comfusion for users when they run
> df comamnd to directory which has project quota.
>=20
> For example, we set 20M softlimit and 10M hardlimit of
> block usage limit for project quota of test_dir(project id 123).

> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/f2fs/super.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 7a9cc64f5ca3..662c7de58b99 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -1148,9 +1148,13 @@ static int f2fs_statfs_project(struct super_block =
*sb,
>  		return PTR_ERR(dquot);
>  	spin_lock(&dquot->dq_dqb_lock);
> =20
> -	limit =3D (dquot->dq_dqb.dqb_bsoftlimit ?
> -		 dquot->dq_dqb.dqb_bsoftlimit :
> -		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
> +	limit =3D 0;
> +	if (dquot->dq_dqb.dqb_bsoftlimit)
> +		limit =3D dquot->dq_dqb.dqb_bsoftlimit;
> +	if (dquot->dq_dqb.dqb_bhardlimit &&
> +			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
> +		limit =3D dquot->dq_dqb.dqb_bhardlimit;
> +
>  	if (limit && buf->f_blocks > limit) {

>> blocksize disappeared here. That can't be right.

Plus, is this just obfuscated way of saying

limit =3D min_not_zero(dquot->dq_dqb.dqb_bsoftlimit, dquot->dq_dqb.dqb_bhar=
dlimit)?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4Pde0ACgkQMOfwapXb+vLqwgCfQB23lTPPylgzByCY4o28WHli
ZSEAmwVz9M718u4eqzta/6qKREiJLCk4
=iDPi
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
