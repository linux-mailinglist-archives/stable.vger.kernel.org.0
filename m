Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE63599A33
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347652AbiHSKpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347538AbiHSKpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:45:39 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F4FC2778;
        Fri, 19 Aug 2022 03:45:37 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 87D9C1C0003; Fri, 19 Aug 2022 12:45:35 +0200 (CEST)
Date:   Fri, 19 Aug 2022 12:45:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.15 089/779] md-raid10: fix KASAN warning
Message-ID: <20220819104534.GA11901@duo.ucw.cz>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180341.087873206@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20220815180341.087873206@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mikulas Patocka <mpatocka@redhat.com>
>=20
> commit d17f744e883b2f8d13cca252d71cfe8ace346f7d upstream.
>=20
> There's a KASAN warning in raid10_remove_disk when running the lvm
> test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> value "number" is valid.
>=20
> BUG: KASAN: slab-out-of-bounds in raid10_remove_disk+0x61/0x2a0 [raid10]
> Read of size 8 at addr ffff889108f3d300 by task mdX_raid10/124682

Is this place for array_index_nospec?

Best regards,
								Pavel

> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2139,9 +2139,12 @@ static int raid10_remove_disk(struct mdd
>  	int err =3D 0;
>  	int number =3D rdev->raid_disk;
>  	struct md_rdev **rdevp;
> -	struct raid10_info *p =3D conf->mirrors + number;
> +	struct raid10_info *p;
> =20
>  	print_conf(conf);
> +	if (unlikely(number >=3D mddev->raid_disks))
> +		return 0;
> +	p =3D conf->mirrors + number;
>  	if (rdev =3D=3D p->rdev)
>  		rdevp =3D &p->rdev;
>  	else if (rdev =3D=3D p->replacement)
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYv9pzgAKCRAw5/Bqldv6
8v/gAJ4sTX5X3zY3ubBbRZSn/XTq14xIywCeNyHFEYnBxjdVRIz+YCGiu7U2uls=
=mCrN
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
