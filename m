Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06755A40
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 23:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfFYVvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 17:51:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35172 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 17:51:39 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E749580792; Tue, 25 Jun 2019 23:51:25 +0200 (CEST)
Date:   Tue, 25 Jun 2019 23:51:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.19 84/90] cfg80211: fix memory leak of wiphy device name
Message-ID: <20190625215135.GA32248@amd>
References: <20190624092313.788773607@linuxfoundation.org>
 <20190624092319.410368076@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20190624092319.410368076@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Biggers <ebiggers@google.com>
>=20
> commit 4f488fbca2a86cc7714a128952eead92cac279ab upstream.
>=20
> In wiphy_new_nm(), if an error occurs after dev_set_name() and
> device_initialize() have already been called, it's necessary to call
> put_device() (via wiphy_free()) to avoid a memory leak.
=2E...
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -498,7 +498,7 @@ use_default_name:
>  				   &rdev->rfkill_ops, rdev);
> =20
>  	if (!rdev->rfkill) {
> -		kfree(rdev);
> +		wiphy_free(&rdev->wiphy);
>  		return NULL;
>  	}

Is kfree(rdev) still neccessary?
drivers/net/wireless/marvell/libertas/cfg.c seems to suggest so.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0Sl2cACgkQMOfwapXb+vLhTwCglgF6Ac1EPb3f4Ml0x9RvA0e/
TwcAn35frZye+nut7S+KbBU6lPQZWLqb
=WN88
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
