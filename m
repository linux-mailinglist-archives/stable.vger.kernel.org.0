Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F65138CA0
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 09:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgAMIIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 03:08:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40062 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgAMIIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 03:08:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D7E171C2228; Mon, 13 Jan 2020 09:08:02 +0100 (CET)
Date:   Mon, 13 Jan 2020 09:08:02 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 41/84] rfkill: Fix incorrect check to avoid NULL
 pointer dereference
Message-ID: <20200113080801.GA15986@amd>
References: <20200111094845.328046411@linuxfoundation.org>
 <20200111094901.927519712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20200111094901.927519712@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Aditya Pakki <pakki001@umn.edu>
>=20
> [ Upstream commit 6fc232db9e8cd50b9b83534de9cd91ace711b2d7 ]
>=20
> In rfkill_register, the struct rfkill pointer is first derefernced
> and then checked for NULL. This patch removes the BUG_ON and returns
> an error to the caller in case rfkill is NULL.

I don't see the dereference; address of field in structure is taken,
but that does not need a dereference. Not sure if it is valid C, but
I'm pretty sure it does not cause any problems.

Plus I wonder if this is a good idea. Noone should be doing
rfkill_register(NULL)...

Best regards,
								Pavel

> @@ -1014,10 +1014,13 @@ static void rfkill_sync_work(struct work_struct *=
work)
>  int __must_check rfkill_register(struct rfkill *rfkill)
>  {
>  	static unsigned long rfkill_no;
> -	struct device *dev =3D &rfkill->dev;
> +	struct device *dev;
>  	int error;
> =20
> -	BUG_ON(!rfkill);
> +	if (!rfkill)
> +		return -EINVAL;
> +
> +	dev =3D &rfkill->dev;
> =20
>  	mutex_lock(&rfkill_global_mutex);
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4cJWEACgkQMOfwapXb+vK7nACgguqHNu0b5vaJ0b5N7qkGLfPZ
UPkAn1aFFD7FTbKE0Kq6QsoNDYMyYG5U
=47B8
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
