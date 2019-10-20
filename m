Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FCDE0A2
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 23:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfJTVP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 17:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfJTVP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Oct 2019 17:15:56 -0400
Received: from earth.universe (cust-west-pareq2-46-193-15-226.wb.wifirst.net [46.193.15.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BF021928;
        Sun, 20 Oct 2019 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571606156;
        bh=tte/sBnIuHSqFUj7METw8OCBnma6Bu9TdJjj9VE6aFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CE1T6S4FRlUGeNzuEmYs5bwhJKmlCmh/XFk1nKSJj/b9M1uxmY8tS4vBnt+CabvC5
         um3MGzeABGtQwTDIhLWit2WJghI8eAyiPrXYyRlv5iMjlsN6gHoExsqTl8+FPTdQJy
         4aVub/3iSELPtCHczXt/cHfEP9Db5moLQ3XT/kDs=
Received: by earth.universe (Postfix, from userid 1000)
        id EBE0B3C0CA0; Sun, 20 Oct 2019 23:15:53 +0200 (CEST)
Date:   Sun, 20 Oct 2019 23:15:53 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v1] power: supply: ltc2941-battery-gauge: fix
 use-after-free
Message-ID: <20191020211553.cjfdpvhyqilhsbh4@earth.universe>
References: <20190919151137.9960-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3swbex74wzskpsoz"
Content-Disposition: inline
In-Reply-To: <20190919151137.9960-1-TheSven73@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3swbex74wzskpsoz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 19, 2019 at 11:11:37AM -0400, Sven Van Asbroeck wrote:
> This driver's remove path calls cancel_delayed_work().
> However, that function does not wait until the work function
> finishes. This could mean that the work function is still
> running after the driver's remove function has finished,
> which would result in a use-after-free.
>=20
> Fix by calling cancel_delayed_work_sync(), which ensures that
> that the work is properly cancelled, no longer running, and
> unable to re-schedule itself.
>=20
> This issue was detected with the help of Coccinelle.
>=20
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---

Thanks, queued.

-- Sebastian

>  drivers/power/supply/ltc2941-battery-gauge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power=
/supply/ltc2941-battery-gauge.c
> index da49436176cd..30a9014b2f95 100644
> --- a/drivers/power/supply/ltc2941-battery-gauge.c
> +++ b/drivers/power/supply/ltc2941-battery-gauge.c
> @@ -449,7 +449,7 @@ static int ltc294x_i2c_remove(struct i2c_client *clie=
nt)
>  {
>  	struct ltc294x_info *info =3D i2c_get_clientdata(client);
> =20
> -	cancel_delayed_work(&info->work);
> +	cancel_delayed_work_sync(&info->work);
>  	power_supply_unregister(info->supply);
>  	return 0;
>  }
> --=20
> 2.17.1
>=20

--3swbex74wzskpsoz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl2szokACgkQ2O7X88g7
+pqaChAApkJ+IwkcPqnt9sjPKSq0gxzC0zCQD2pFm+XFbAVmLBUEFHOX+cwcZWDi
CjlDRncen3sw9x29akza1mCaiQ0DxFbNVjZOswhRjkxkl5AcfMJZfv+QuhdRVeO2
6MvpGeS4rhrLNL/HGnNILMrkIc/92FxTluxf+gcwO4XV4C6G7wGm3gmC9oTYi9MK
zoRj+ucWdhP2/7TN4KzGt2ki7qnOQ2X1wzhqwZCzgeGnxWKaMx3bovrLW+bfFF9P
BTlovcmOAmKssbBOJxNLoQE1F3+rjcx+QDaS4bzGbVfyLNoPYNsDgRSBzm6J6qHW
cfshuVENlDUiqF1olQLBsBnlJPBgB/KH1QzTJQH6NWHTfx/sNO85xv8c2rGzIa8v
8P0zxSFpBcmKPVbvgfNS0MoyxX39AmfTzy7bsJ855rL+wyvZmavI1vNZ8Sr0nTTY
3IytCA3E5PSt2anm/Q/v+/1xzGHOygQbM1UrZg3pED4Ytt+SA3hwMx/f3lVfZa9y
PPSJTgzXMA1LhwjAuKDKyoblJ6J1ZqBud0Q91W0rDJI71ci3LZgdfj/NxN2GPrr1
Ge0J/jNEtpUOzpTuCz8NOIHGuOKoYpjLY1j1sCD8enc47MA8PVLBoCYk0VKE7wu6
7IqwsYkATfXhAp0zz/G7bOqXGFSBrYUlnJkwMu8BSj38OjJ5oYc=
=3Vuq
-----END PGP SIGNATURE-----

--3swbex74wzskpsoz--
