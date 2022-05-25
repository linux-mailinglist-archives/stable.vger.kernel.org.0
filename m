Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2E533AFA
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiEYKwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 06:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiEYKwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 06:52:53 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CCCB1F9;
        Wed, 25 May 2022 03:52:50 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 522771C0B92; Wed, 25 May 2022 12:52:49 +0200 (CEST)
Date:   Wed, 25 May 2022 12:52:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 04/33] Input: stmfts - fix reference leak in
 stmfts_input_open
Message-ID: <20220525105248.GA31002@duo.ucw.cz>
References: <20220523165746.957506211@linuxfoundation.org>
 <20220523165747.818755611@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20220523165747.818755611@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zheng Yongjun <zhengyongjun3@huawei.com>
>=20
> [ Upstream commit 26623eea0da3476446909af96c980768df07bbd9 ]
>=20
> pm_runtime_get_sync() will increment pm usage counter even it
> failed. Forgetting to call pm_runtime_put_noidle will result
> in reference leak in stmfts_input_open, so we should fix it.

This is wrong, AFAICT.

>  drivers/input/touchscreen/stmfts.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscre=
en/stmfts.c
> index d9e93dabbca2..9007027a7ad9 100644
> --- a/drivers/input/touchscreen/stmfts.c
> +++ b/drivers/input/touchscreen/stmfts.c
> @@ -344,11 +344,11 @@ static int stmfts_input_open(struct input_dev *dev)
> =20
>  	err =3D pm_runtime_get_sync(&sdata->client->dev);
>  	if (err < 0)
> -		return err;
> +		goto out;
> =20
>  	err =3D i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
>  	if (err)
> -		return err;
> +		goto out;
> =20
>  	mutex_lock(&sdata->mutex);
>  	sdata->running =3D true;
> @@ -371,7 +371,9 @@ static int stmfts_input_open(struct input_dev *dev)
>  				 "failed to enable touchkey\n");
>  	}
> =20
> -	return 0;
> +out:
> +	pm_runtime_put_noidle(&sdata->client->dev);
> +	return err;
>  }
> =20
>  static void stmfts_input_close(struct input_dev *dev)

We are now doing put even on the success path. That will break the
device... and will result in non-functional device and double put due
to the close path.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYo4KgAAKCRAw5/Bqldv6
8pnsAJ9QdlVNWhX78VODohF0ft2PRzO4bQCcCOhk6eraaxF95Mfm0sF5y6IXBl0=
=bLvk
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
