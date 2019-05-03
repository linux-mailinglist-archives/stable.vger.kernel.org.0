Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C105D129EE
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 10:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfECIcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 04:32:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50528 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECIcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 04:32:15 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id ED0A480376; Fri,  3 May 2019 10:32:03 +0200 (CEST)
Date:   Fri, 3 May 2019 10:32:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kangjie Lu <kjlu@umn.edu>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: Re: [PATCH 4.19 09/72] net: ieee802154: fix a potential NULL pointer
 dereference
Message-ID: <20190503083213.GB5834@amd>
References: <20190502143333.437607839@linuxfoundation.org>
 <20190502143334.240377603@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <20190502143334.240377603@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-05-02 17:20:31, Greg Kroah-Hartman wrote:
> [ Upstream commit 2795e8c251614ac0784c9d41008551109f665716 ]
>=20
> In case alloc_ordered_workqueue fails, the fix releases
> sources and returns -ENOMEM to avoid NULL pointer dereference.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>

> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/ad=
f7242.c
> index cd1d8faccca5..cd6b95e673a5 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1268,6 +1268,10 @@ static int adf7242_probe(struct spi_device *spi)
>  	INIT_DELAYED_WORK(&lp->work, adf7242_rx_cal_work);
>  	lp->wqueue =3D alloc_ordered_workqueue(dev_name(&spi->dev),
>  					     WQ_MEM_RECLAIM);
> +	if (unlikely(!lp->wqueue)) {
> +		ret =3D -ENOMEM;
> +		goto err_hw_init;
> +	}
>

This does ieee802154_free_hw(lp->hw) before adf7242_hw_init(). I don't
think that's correct.
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzL/I0ACgkQMOfwapXb+vJjvQCfZgzVG4aw7F9lyttv5J6laO/3
diUAoIk2C2O662Re/lTiqoMkWvxog/Kn
=pTKU
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
