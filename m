Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F50FB8EFD
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438190AbfITL2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 07:28:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59019 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438188AbfITL2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 07:28:05 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 40A4480FFD; Fri, 20 Sep 2019 13:27:49 +0200 (CEST)
Date:   Fri, 20 Sep 2019 13:28:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.19 18/79] nl80211: Fix possible Spectre-v1 for CQM RSSI
 thresholds
Message-ID: <20190920112803.GB7865@amd>
References: <20190919214807.612593061@linuxfoundation.org>
 <20190919214809.383428098@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20190919214809.383428098@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 4b2c5a14cd8005a900075f7dfec87473c6ee66fb upstream.
>=20
> commit 1222a1601488 ("nl80211: Fix possible Spectre-v1 for CQM
> RSSI thresholds") was incomplete and requires one more fix to
> prevent accessing to rssi_thresholds[n] because user can control
> rssi_thresholds[i] values to make i reach to n. For example,
> rssi_thresholds =3D {-400, -300, -200, -100} when last is -34.

> @@ -10270,9 +10270,11 @@ static int cfg80211_cqm_rssi_update(stru
>  	hyst =3D wdev->cqm_config->rssi_hyst;
>  	n =3D wdev->cqm_config->n_rssi_thresholds;
> =20
> -	for (i =3D 0; i < n; i++)
> +	for (i =3D 0; i < n; i++) {
> +		i =3D array_index_nospec(i, n);
>  		if (last < wdev->cqm_config->rssi_thresholds[i])
>  			break;
> +	}
> =20

Variable "i" is not controlled by userspace: it is initialized by
kernel and runs from 0 to n.

I don't see a spectre vulnerability here.

[In fact, other array_index_nospec() uses in this function seem also
unneccessary.]

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2Et8MACgkQMOfwapXb+vJqxQCfdRihxvPW6Qr9626ZJozDV8Lf
xFcAoJwcJWyP3GPk1hlsmm4QZA53vhkI
=0z8r
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
