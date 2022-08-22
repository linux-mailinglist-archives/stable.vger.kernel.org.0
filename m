Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9A59BE4C
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiHVLPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiHVLPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:15:49 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594FA32BBA;
        Mon, 22 Aug 2022 04:15:48 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1C0D11C0001; Mon, 22 Aug 2022 13:15:47 +0200 (CEST)
Date:   Mon, 22 Aug 2022 13:15:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10 540/545] tee: add overflow check in
 register_shm_helper()
Message-ID: <20220822111546.GA7795@duo.ucw.cz>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153853.762825860@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20220819153853.762825860@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jens Wiklander <jens.wiklander@linaro.org>
>=20
> commit 573ae4f13f630d6660008f1974c0a8a29c30e18a upstream.
>=20
> With special lengths supplied by user space, register_shm_helper() has
> an integer overflow when calculating the number of pages covered by a
> supplied user space memory region.
>=20
> This causes internal_get_user_pages_fast() a helper function of
> pin_user_pages_fast() to do a NULL pointer dereference:

Maybe this needs fixing, but this fix adds a memory leak or two. Note
the goto err, that needs to be done.

Best regards,
								Pavel

Signed-off-by: Pavel Machek <pavel@denx.de>

> +++ b/drivers/tee/tee_shm.c
> @@ -222,6 +222,9 @@ struct tee_shm *tee_shm_register(struct
>  		goto err;
>  	}
> =20
> +	if (!access_ok((void __user *)addr, length))
> +		return ERR_PTR(-EFAULT);
> +
>  	mutex_lock(&teedev->mutex);
>  	shm->id =3D idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
>  	mutex_unlock(&teedev->mutex);
>=20


diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6e662fb131d5..283fa50676a2 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -222,8 +222,10 @@ struct tee_shm *tee_shm_register(struct tee_context *c=
tx, unsigned long addr,
 		goto err;
 	}
=20
-	if (!access_ok((void __user *)addr, length))
-		return ERR_PTR(-EFAULT);
+	if (!access_ok((void __user *)addr, length)) {
+		ret =3D ERR_PTR(-EFAULT);
+		goto err;
+	}
=20
 	mutex_lock(&teedev->mutex);
 	shm->id =3D idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYwNlYgAKCRAw5/Bqldv6
8rEvAJ4gSuJsaW+I7NP5zQXi+5g54XgV3wCfTKL8kfOnTwL1l/4nPoVVKLXS4vE=
=wjAN
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
