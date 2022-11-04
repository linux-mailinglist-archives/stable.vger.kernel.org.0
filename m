Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC38619E32
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKDRMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiKDRL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:11:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42903326FB
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:11:58 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B26FE1C09D8; Fri,  4 Nov 2022 18:11:55 +0100 (CET)
Date:   Fri, 4 Nov 2022 18:11:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 69/91] ipv6: ensure sane device mtu in tunnels
Message-ID: <20221104171155.GA29661@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022056.996215743@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20221102022056.996215743@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit d89d7ff01235f218dad37de84457717f699dee79 ]
>=20
> Another syzbot report [1] with no reproducer hints
> at a bug in ip6_gre tunnel (dev:ip6gretap0)
>=20
> Since ipv6 mcast code makes sure to read dev->mtu once
> and applies a sanity check on it (see commit b9b312a7a451
> "ipv6: mcast: better catch silly mtu values"), a remaining
> possibility is that a layer is able to set dev->mtu to
> an underflowed value (high order bit set).
>=20
> This could happen indeed in ip6gre_tnl_link_config_route(),
> ip6_tnl_link_config() and ipip6_tunnel_bind_dev()
>=20
> Make sure to sanitize mtu value in a local variable before
> it is written once on dev->mtu, as lockless readers could
> catch wrong temporary value.

Ok, but now types seem to be confused:

> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 3a2741569b84..0d4cab94c5dd 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>  	struct net_device *tdev =3D NULL;
>  	struct __ip6_tnl_parm *p =3D &t->parms;
>  	struct flowi6 *fl6 =3D &t->fl.u.ip6;
> -	unsigned int mtu;
>  	int t_hlen;
> +	int mtu;
> =20
>  	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
>  	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
> @@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>  			dev->hard_header_len =3D tdev->hard_header_len + t_hlen;
>  			mtu =3D min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);

mtu is now signed, but we still do min_t on unsigned types.

> -			dev->mtu =3D mtu - t_hlen;
> +			mtu =3D mtu - t_hlen;
>  			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
> -				dev->mtu -=3D 8;
> +				mtu -=3D 8;
>

I don't see overflow potential right away, but it may be worth fixing.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VH2wAKCRAw5/Bqldv6
8uotAJ4pYyzbaTLCHpWzacTvQFPvCt73WQCaAxktuaUB/Zxx4BkdtirNDZUI45A=
=XIKy
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
