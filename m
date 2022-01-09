Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B53488879
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiAIJbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 04:31:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56118 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiAIJbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 04:31:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 69DEE1C0B77; Sun,  9 Jan 2022 10:31:00 +0100 (CET)
Date:   Sun, 9 Jan 2022 10:30:59 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     gregkh@linuxfoundation.org
Cc:     dsahern@kernel.org, davem@davemloft.net, nicolas.dichtel@6wind.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv6: Check attribute length for
 RTA_GATEWAY in multipath" failed to apply to 4.4-stable tree
Message-ID: <20220109093058.GA8434@amd>
References: <164156331217042@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <164156331217042@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I could not find better place to reply.

I see this patch is queued for 5.10 and 4.19. But it is wrong:

> >From 4619bcf91399f00a40885100fb61d594d8454033 Mon Sep 17 00:00:00 2001
> From: David Ahern <dsahern@kernel.org>
> Date: Thu, 30 Dec 2021 17:36:33 -0700
> Subject: [PATCH] ipv6: Check attribute length for RTA_GATEWAY in multipath
>  route
>=20
> Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
> does the current nla_get_in6_addr. nla_memcpy protects against accessing
> memory greater than what is in the attribute, but there is no check
> requiring the attribute to have an IPv6 address. Add it.
>=20
> Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath
> (ECMP)")

=2E..> @@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib=
6_config *cfg,
> =20
>  			nla =3D nla_find(attrs, attrlen, RTA_GATEWAY);
>  			if (nla) {
> -				r_cfg.fc_gateway =3D nla_get_in6_addr(nla);
> +				int ret;
> +
> +				ret =3D fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
> +							extack);
> +				if (ret)
> +					return ret;
> +

Direct return may not be used here. It needs to goto cleanup.

It is already fixed in mainline, so you can probably just cherry-pick
followup patch, too.

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHaq1IACgkQMOfwapXb+vK0TwCeJpducTKAUOJTWpBJfruYF1u5
jN8AoKdQVmx9xEZeFwbm1ytG+bLXMzmR
=4ZQJ
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
