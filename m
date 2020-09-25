Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB2278F18
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgIYQvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:51:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34594 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgIYQvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:51:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 419F51C0C4A; Fri, 25 Sep 2020 18:51:35 +0200 (CEST)
Date:   Fri, 25 Sep 2020 18:51:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kfir Itzhak <mastertheknife@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 23/37] ipv4: Update exception handling for multipath
 routes via same device
Message-ID: <20200925165134.GA7253@duo.ucw.cz>
References: <20200925124720.972208530@linuxfoundation.org>
 <20200925124724.448531559@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20200925124724.448531559@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 2fbc6e89b2f1403189e624cabaf73e189c5e50c6 ]
>=20
> Kfir reported that pmtu exceptions are not created properly for
> deployments where multipath routes use the same device.

This is mismerged (in a way that does not affect functionality):


> @@ -779,6 +779,8 @@ static void __ip_do_redirect(struct rtab
>  			if (fib_lookup(net, fl4, &res, 0) =3D=3D 0) {
>  				struct fib_nh *nh =3D &FIB_RES_NH(res);
> =20
> +				fib_select_path(net, &res, fl4, skb);
> +				nh =3D &FIB_RES_NH(res);
>  				update_or_create_fnhe(nh, fl4->daddr, new_gw,
>  						0, false,

nh is assigned value that is never used. Mainline patch removes the
assignment (but variable has different type).

4.19 should delete the assignment, too.

Best regards,
								Pavel

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f60e28418ece..84de87b7eedc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -777,7 +777,7 @@ static void __ip_do_redirect(struct rtable *rt, struct =
sk_buff *skb, struct flow
 			neigh_event_send(n, NULL);
 		} else {
 			if (fib_lookup(net, fl4, &res, 0) =3D=3D 0) {
-				struct fib_nh *nh =3D &FIB_RES_NH(res);
+				struct fib_nh *nh;
=20
 				fib_select_path(net, &res, fl4, skb);
 				nh =3D &FIB_RES_NH(res);


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX24gFgAKCRAw5/Bqldv6
8oJ8AJ9aaZ5VFjdoC1MlzVWNOHLPXUSxxwCgvL0JSbW+WA9qbi47KAD6yNkrwig=
=zt7i
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
