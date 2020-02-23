Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D6216973B
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 11:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgBWKnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 05:43:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59134 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWKnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 05:43:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 57D831C036E; Sun, 23 Feb 2020 11:43:00 +0100 (CET)
Date:   Sun, 23 Feb 2020 11:42:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 023/191] gpio: gpio-grgpio: fix possible
 sleep-in-atomic-context bugs in grgpio_irq_map/unmap()
Message-ID: <20200223104259.GE14067@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072253.959264040@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <20200221072253.959264040@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jia-Ju Bai <baijiaju1990@gmail.com>
>=20
> [ Upstream commit e36eaf94be8f7bc4e686246eed3cf92d845e2ef8 ]
>=20
> The driver may sleep while holding a spinlock.

True.

But you can't fix the bug by simply removing the locking, as now
nothing prevents grgpio_irq_unmap() from running while
grgpio_irq_map() is proceeding.

grgpio_irq_map()
	lirq->irq =3D irq;
	(drops the lock)

grgpio_irq_unmap()
	(gets the lock)
 	if (lirq->irq =3D=3D irq) {
	 	...
		(proceeds to work with half-initialized structure)

Best regards,
							Pavel


> index 60a1556c570a4..c1be299e5567b 100644
> --- a/drivers/gpio/gpio-grgpio.c
> +++ b/drivers/gpio/gpio-grgpio.c
> @@ -258,17 +258,16 @@ static int grgpio_irq_map(struct irq_domain *d, uns=
igned int irq,
>  	lirq->irq =3D irq;
>  	uirq =3D &priv->uirqs[lirq->index];
>  	if (uirq->refcnt =3D=3D 0) {
> +		spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
>  		ret =3D request_irq(uirq->uirq, grgpio_irq_handler, 0,
>  				  dev_name(priv->dev), priv);
>  		if (ret) {
>  			dev_err(priv->dev,
>  				"Could not request underlying irq %d\n",
>  				uirq->uirq);
> -
> -			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
> -
>  			return ret;
>  		}
> +		spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
>  	}
>  	uirq->refcnt++;
> =20
> @@ -314,8 +313,11 @@ static void grgpio_irq_unmap(struct irq_domain *d, u=
nsigned int irq)
>  	if (index >=3D 0) {
>  		uirq =3D &priv->uirqs[lirq->index];
>  		uirq->refcnt--;
> -		if (uirq->refcnt =3D=3D 0)
> +		if (uirq->refcnt =3D=3D 0) {
> +			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
>  			free_irq(uirq->uirq, priv);
> +			return;
> +		}
>  	}
> =20
>  	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5SVzMACgkQMOfwapXb+vL+JwCdEwe6zEdEsetf589qzMa8M06F
Z70AoKi1JX4soqRIs0+AhB6rVkdNjadx
=xN3n
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
