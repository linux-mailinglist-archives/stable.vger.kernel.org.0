Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48EF2B871F
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 23:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgKRWFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 17:05:50 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34414 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgKRWFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 17:05:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3FAC71C0B87; Wed, 18 Nov 2020 23:05:46 +0100 (CET)
Date:   Wed, 18 Nov 2020 23:05:45 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 019/101] can: peak_usb: add range checking in decode
 operations
Message-ID: <20201118220545.GB23840@amd>
References: <20201117122113.128215851@linuxfoundation.org>
 <20201117122114.030656831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <20201117122114.030656831@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI!

> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> [ Upstream commit a6921dd524fe31d1f460c161d3526a407533b6db ]
>=20
> These values come from skb->data so Smatch considers them untrusted.  I
> believe Smatch is correct but I don't have a way to test this.
>=20
> The usb_if->dev[] array has 2 elements but the index is in the 0-15
> range without checks.  The cfd->len can be up to 255 but the maximum
> valid size is CANFD_MAX_DLEN (64) so that could lead to memory
> corruption.

If this is untrusted, does it need to use _nospec() variants?

> index 41988358f63c8..19600d35aac55 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> @@ -476,12 +476,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_us=
b_fd_if *usb_if,
>  				     struct pucan_msg *rx_msg)
>  {
=2E..
>  	const u16 rx_msg_flags =3D le16_to_cpu(rm->flags);
> =20
> +	if (pucan_msg_get_channel(rm) >=3D ARRAY_SIZE(usb_if->dev))
> +		return -ENOMEM;

Furthermore, should it use -EINVAL here

> +	if (pucan_stmsg_get_channel(sm) >=3D ARRAY_SIZE(usb_if->dev))
> +		return -ENOMEM;

and here, and perhaps use a helper function?

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+1mrkACgkQMOfwapXb+vIKvwCePWcS9J0JMSVUbaioUvBR68C5
R6UAoKGNGoTw/A6Pf/o/+7F3X63wATXW
=AI7I
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
