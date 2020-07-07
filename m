Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D931217A91
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 23:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgGGVda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 17:33:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35118 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbgGGVd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 17:33:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 39D6A1C0C0A; Tue,  7 Jul 2020 23:33:27 +0200 (CEST)
Date:   Tue, 7 Jul 2020 23:33:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 17/36] cxgb4: use correct type for all-mask IP
 address comparison
Message-ID: <20200707213326.GB11158@amd>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.959174058@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <20200707145749.959174058@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>=20
> [ Upstream commit f286dd8eaad5a2758750f407ab079298e0bcc8a5 ]
>=20
> Use correct type to check for all-mask exact match IP addresses.
>=20
> Fixes following sparse warnings due to big endian value checks
> against 0xffffffff in is_addr_all_mask():
> cxgb4_filter.c:977:25: warning: restricted __be32 degrades to integer
> cxgb4_filter.c:983:37: warning: restricted __be32 degrades to integer
> cxgb4_filter.c:984:37: warning: restricted __be32 degrades to integer
> cxgb4_filter.c:985:37: warning: restricted __be32 degrades to integer
> cxgb4_filter.c:986:37: warning: restricted __be32 degrades to integer

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/=
net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> index 7dddb9e748b81..86745f33a252d 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> @@ -810,16 +810,16 @@ static bool is_addr_all_mask(u8 *ipmask, int family)
>  		struct in_addr *addr;
> =20
>  		addr =3D (struct in_addr *)ipmask;
> -		if (addr->s_addr =3D=3D 0xffffffff)
> +		if (ntohl(addr->s_addr) =3D=3D 0xffffffff)

Endianity does not really matter for ~0, but can compiler figure it
out?

would it be better to do these tests as=20

      if (foo =3D=3D htonl(0xffffffff))

to make it clear to the compiler?

Thanks,
								Pavel

>  	} else if (family =3D=3D AF_INET6) {
>  		struct in6_addr *addr6;
> =20
>  		addr6 =3D (struct in6_addr *)ipmask;
> -		if (addr6->s6_addr32[0] =3D=3D 0xffffffff &&
> -		    addr6->s6_addr32[1] =3D=3D 0xffffffff &&
> -		    addr6->s6_addr32[2] =3D=3D 0xffffffff &&
> -		    addr6->s6_addr32[3] =3D=3D 0xffffffff)
> +		if (ntohl(addr6->s6_addr32[0]) =3D=3D 0xffffffff &&
> +		    ntohl(addr6->s6_addr32[1]) =3D=3D 0xffffffff &&
> +		    ntohl(addr6->s6_addr32[2]) =3D=3D 0xffffffff &&
> +		    ntohl(addr6->s6_addr32[3]) =3D=3D 0xffffffff)
>  			return true;
>  	}
>  	return false;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8E6iYACgkQMOfwapXb+vJLpACdEj/Y83rAxd9brW1nECrg00xp
ZhIAn1OLUasoKxmEd9olKPWbXPxy/3UR
=t1HC
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
