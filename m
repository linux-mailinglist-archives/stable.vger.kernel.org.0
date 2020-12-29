Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1002E7504
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 23:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgL2Wmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 17:42:46 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgL2Wmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 17:42:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 477B61C0B7C; Tue, 29 Dec 2020 23:42:03 +0100 (CET)
Date:   Tue, 29 Dec 2020 23:42:02 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 191/717] memstick: fix a double-free bug in
 memstick_check
Message-ID: <20201229224202.GA32501@amd>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125030.121361557@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20201228125030.121361557@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Qinglang Miao <miaoqinglang@huawei.com>
>=20
> [ Upstream commit e3e9ced5c93803d5b2ea1942c4bf0192622531d6 ]
>=20
> kfree(host->card) has been called in put_device so that
> another kfree would raise cause a double-free bug.

> +++ b/drivers/memstick/core/memstick.c
> @@ -468,7 +468,6 @@ static void memstick_check(struct work_struct *work)
>  			host->card =3D card;
>  			if (device_register(&card->dev)) {
>  				put_device(&card->dev);
> -				kfree(host->card);
>  				host->card =3D NULL;
>  			}

Does the host->card =3D NULL need to be removed, too (and following code
refactored)? put_device() needs that pointer to be able to free it and
it can do so asynchronously.

This will cause crashes; they should be easy to reproduce with
CONFIG_DEBUG_KOBJECT_RELEASE due to delay in kobject_release() AFAICT.

Best regards,								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/rsLoACgkQMOfwapXb+vIp9QCgiGA7sg6njdUTVICgURx0nQY6
cNYAoK2WHpH/AHlOPo/11nbX/0tb9GJO
=50XO
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
