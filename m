Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E110462B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 22:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTVyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 16:54:19 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55720 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTVyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 16:54:19 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A94131C1AB7; Wed, 20 Nov 2019 22:54:17 +0100 (CET)
Date:   Wed, 20 Nov 2019 22:54:17 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Shreyas NC <shreyas.nc@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 038/422] soundwire: Initialize completion for defer
 messages
Message-ID: <20191120215417.GA23361@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051402.440815842@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20191119051402.440815842@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-11-19 06:13:55, Greg Kroah-Hartman wrote:
> From: Shreyas NC <shreyas.nc@intel.com>
>=20
> [ Upstream commit a306a0e4a5326269b6c78d136407f08433ab5ece ]
>=20
> Deferred messages are async messages used to synchronize
> transitions mostly while doing a bank switch on multi links.
> On successful transitions these messages are marked complete
> and thereby confirming that all the buses performed bank switch
> successfully.
>=20
> So, initialize the completion structure for the same.
>=20
> Signed-off-by: Sanyog Kale <sanyog.r.kale@intel.com>

This is only called from sdw_transfer_defer() and that function is
called in mainline, but is unused in 4.19.X.

So I don't think this is suitable for -stable.

Best regards,
								Pavel

> diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
> index 83576810eee65..df172bf3925f6 100644
> --- a/drivers/soundwire/bus.c
> +++ b/drivers/soundwire/bus.c
> @@ -175,6 +175,7 @@ static inline int do_transfer_defer(struct sdw_bus *b=
us,
> =20
>  	defer->msg =3D msg;
>  	defer->length =3D msg->len;
> +	init_completion(&defer->complete);
> =20
>  	for (i =3D 0; i <=3D retry; i++) {
>  		resp =3D bus->ops->xfer_msg_defer(bus, msg, defer);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdW2CQAKCRAw5/Bqldv6
8tbaAKCiKoBQlQxQhcoxZTgnKYmZSnB/7gCfUFIzLIpunfiVjYK7GBpBIxxhG0g=
=U6zF
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
