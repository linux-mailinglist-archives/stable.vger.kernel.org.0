Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8316BEB7
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 11:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgBYK2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 05:28:12 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39558 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730175AbgBYK2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 05:28:12 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6237F1C0411; Tue, 25 Feb 2020 11:28:10 +0100 (CET)
Date:   Tue, 25 Feb 2020 11:28:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 079/191] orinoco: avoid assertion in case of NULL
 pointer
Message-ID: <20200225102809.GA2591@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072300.728391700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20200221072300.728391700@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Aditya Pakki <pakki001@umn.edu>
>=20
> [ Upstream commit c705f9fc6a1736dcf6ec01f8206707c108dca824 ]
>=20
> In ezusb_init, if upriv is NULL, the code crashes. However, the caller
> in ezusb_probe can handle the error and print the failure message.
> The patch replaces the BUG_ON call to error return.

The caller already checked that upriv is not NULL, AFAICT.

    priv =3D alloc_orinocodev(sizeof(*upriv), &udev->dev,
    	                         ezusb_hard_reset, NULL);
    if (!priv) {
        err("Couldn't allocate orinocodev");
        retval =3D -ENOMEM;
        goto exit;
    }
				=20
I don't see this as an improvement.

Best regards,
							Pavel
						=09

> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
> @@ -1364,7 +1364,8 @@ static int ezusb_init(struct hermes *hw)
>  	int retval;
> =20
>  	BUG_ON(in_interrupt());
> -	BUG_ON(!upriv);
> +	if (!upriv)
> +		return -EINVAL;
> =20
>  	upriv->reply_count =3D 0;
>  	/* Write the MAGIC number on the simulated registers to keep

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5U9rkACgkQMOfwapXb+vKmjQCgwzqrB0WO/uxLdAnnaigxtoxo
tcwAn1E7yollUJFJJh4qsgtVH6WaXjZX
=dz+r
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
