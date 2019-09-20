Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8715B8EE5
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 13:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392182AbfITLUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 07:20:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57778 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392160AbfITLUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 07:20:53 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 0657D80E74; Fri, 20 Sep 2019 13:20:36 +0200 (CEST)
Date:   Fri, 20 Sep 2019 13:20:51 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 65/79] net: aquantia: fix out of memory condition on
 rx side
Message-ID: <20190920112051.GA7865@amd>
References: <20190919214807.612593061@linuxfoundation.org>
 <20190919214813.375849733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20190919214813.375849733@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit be6cef69ba570ebb327eba1ef6438f7af49aaf86 ]
>=20
> On embedded environments with hard memory limits it is a normal although
> rare case when skb can't be allocated on rx part under high traffic.
>=20
> In such OOM cases napi_complete_done() was not called.
> So the napi object became in an invalid state like it is "scheduled".
> Kernel do not re-schedules the poll of that napi object.
>=20
> Consequently, kernel can not remove that object the system hangs on
> `ifconfig down` waiting for a poll.
>=20
> We are fixing this by gracefully closing napi poll routine with correct
> invocation of napi_complete_done.
>=20
> This was reproduced with artificially failing the allocation of skb to
> simulate an "out of memory" error case and check that traffic does
> not get stuck.


> --- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
> @@ -89,6 +89,7 @@ static int aq_vec_poll(struct napi_struct *napi, int bu=
dget)
>  			}
>  		}
> =20
> +err_exit:
>  		if (!was_tx_cleaned)
>  			work_done =3D budget;
> =20

This results in some... really "interesting" code that could use some
refactoring.

First, "goto err_exit" is now same as break.

Second, if (!self) now sets variable that is never used. "if (!self)
return 0;" would be more readable and would allow for less confusing
indentation.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2EthMACgkQMOfwapXb+vJiLgCgvR/dsXLl7RIL25aTTMbMnIcm
mesAnRrHpjtVksxLg5V+89Mhlzx77MkC
=wJAn
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
