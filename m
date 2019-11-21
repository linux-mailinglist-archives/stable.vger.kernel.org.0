Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016A2105B0E
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKUUVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:21:43 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46426 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKUUVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 15:21:43 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5DF181C1BCF; Thu, 21 Nov 2019 21:21:41 +0100 (CET)
Date:   Thu, 21 Nov 2019 21:21:40 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 241/422] net: socionext: Fix two
 sleep-in-atomic-context bugs in ave_rxfifo_reset()
Message-ID: <20191121202140.GA7573@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051414.641566074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20191119051414.641566074@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0020f5c807ef67954d9210eea0ba17a6134cdf7d ]
>=20
> The driver may sleep with holding a spinlock.
> The function call paths (from bottom to top) in Linux-4.17 are:
>=20
> [FUNC] usleep_range
> drivers/net/ethernet/socionext/sni_ave.c, 892:
> 	usleep_range in ave_rxfifo_reset
> drivers/net/ethernet/socionext/sni_ave.c, 932:
> 	ave_rxfifo_reset in ave_irq_handler
>=20
> [FUNC] usleep_range
> drivers/net/ethernet/socionext/sni_ave.c, 888:
> 	usleep_range in ave_rxfifo_reset
> drivers/net/ethernet/socionext/sni_ave.c, 932:
> 	ave_rxfifo_reset in ave_irq_handler
>=20
> To fix these bugs, usleep_range() is replaced with udelay().

I don't believe this is serious enough for -stable, but more
importantly:

> +++ b/drivers/net/ethernet/socionext/sni_ave.c
> @@ -906,11 +906,11 @@ static void ave_rxfifo_reset(struct net_device *nde=
v)
> =20
>  	/* assert reset */
>  	writel(AVE_GRR_RXFFR, priv->base + AVE_GRR);
> -	usleep_range(40, 50);
> +	udelay(50);
> =20
>  	/* negate reset */
>  	writel(0, priv->base + AVE_GRR);
> -	usleep_range(10, 20);
> +	udelay(20);
>

udelay(40) / udelay(10) should be enough here.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdbx1AAKCRAw5/Bqldv6
8lsUAJ0Y8goOEYKzk+t/j8TzwhKtk/nf5wCeJX3E5CvCZSNLVxyHha0EDUnewew=
=d7wy
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
