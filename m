Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE193134E9
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfECVci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 17:32:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43717 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfECVci (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 17:32:38 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id A4A3C8029B; Fri,  3 May 2019 23:32:25 +0200 (CEST)
Date:   Fri, 3 May 2019 23:32:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Richard Leitner <richard.leitner@skidata.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: Re: [PATCH 4.19 57/72] usb: usb251xb: fix to avoid potential NULL
 pointer dereference
Message-ID: <20190503213235.GA9080@amd>
References: <20190502143333.437607839@linuxfoundation.org>
 <20190502143337.920245890@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20190502143337.920245890@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-05-02 17:21:19, Greg Kroah-Hartman wrote:
> [ Upstream commit 41f00e6e9e55546390031996b773e7f3c1d95928 ]
>=20
> of_match_device in usb251xb_probe can fail and returns a NULL pointer.
> The patch avoids a potential NULL pointer dereference in this scenario.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> Reviewed-by: Richard Leitner <richard.leitner@skidata.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
> ---
>  drivers/usb/misc/usb251xb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/misc/usb251xb.c b/drivers/usb/misc/usb251xb.c
> index a6efb9a72939..5f7734c729b1 100644
> --- a/drivers/usb/misc/usb251xb.c
> +++ b/drivers/usb/misc/usb251xb.c
> @@ -601,7 +601,7 @@ static int usb251xb_probe(struct usb251xb *hub)
>  							   dev);
>  	int err;
> =20
> -	if (np) {
> +	if (np && of_id) {
>  		err =3D usb251xb_get_ofdata(hub,
>  					  (struct usb251xb_data *)of_id->data);
>  		if (err) {

Are you sure this si correct?

If of_id is NULL, this will proceed without setting up hub->conf_data
etc.

I'd expect it to just return error from probe...?

Was this tested?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzMs3MACgkQMOfwapXb+vLeUwCffAQl097l+ldIHRzD82ZPEins
9EkAnij+KD3rJiHxpmfiMFZgqIix6iU/
=E/gX
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
