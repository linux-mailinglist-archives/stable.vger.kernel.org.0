Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F4AD9AB
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 15:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfIINGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 09:06:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56116 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfIINGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 09:06:46 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 1C60981FD3; Mon,  9 Sep 2019 15:06:30 +0200 (CEST)
Date:   Mon, 9 Sep 2019 15:06:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 27/57] cxgb4: fix a memory leak bug
Message-ID: <20190909130643.GC18869@amd>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121136.425579987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20190908121136.425579987@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-09-08 13:41:51, Greg Kroah-Hartman wrote:
> [ Upstream commit c554336efa9bbc28d6ec14efbee3c7d63c61a34f ]
>=20
> In blocked_fl_write(), 't' is not deallocated if bitmap_parse_user() fail=
s,
> leading to a memory leak bug. To fix this issue, free t before returning
> the error.

The code is quite strange ... it seems to use kvfree when free would
be enough. Is that worth fixing? blocked_fl_read() seems to have same
problem.

Best regards,

								Pavel

> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers=
/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> index 0f72f9c4ec74c..b429b726b987b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
> @@ -3276,8 +3276,10 @@ static ssize_t blocked_fl_write(struct file *filp,=
 const char __user *ubuf,
>  		return -ENOMEM;
> =20
>  	err =3D bitmap_parse_user(ubuf, count, t, adap->sge.egr_sz);
> -	if (err)
> +	if (err) {
> +		kvfree(t);
>  		return err;
> +	}
> =20
>  	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
>  	kvfree(t);

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl12TmMACgkQMOfwapXb+vLr7ACgrFqWKI1vmjVdxL7GjkyyFF9F
RKgAnR2ZVLEjzTRxzR3wkxeI1Vyz1RMP
=2REJ
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
