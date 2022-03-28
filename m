Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087284E90C5
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbiC1JKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiC1JKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:10:16 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1C913F61;
        Mon, 28 Mar 2022 02:08:34 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C36591C0B82; Mon, 28 Mar 2022 11:08:31 +0200 (CEST)
Date:   Mon, 28 Mar 2022 11:08:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220328090830.GA24435@amd>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YkAziXrW7/Fbqo/b@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <YkAziXrW7/Fbqo/b@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Can someone check this? AFAICT this is buggy.
> > >=20
> > > static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *=
addr)
> > > {
> > >         struct sock *sk =3D sock->sk;
> > >         struct llc_sock *llc =3D llc_sk(sk);
> > >         struct llc_sap *sap;
> > >         int rc =3D -EINVAL;
> > >=20
> > >         if (!sock_flag(sk, SOCK_ZAPPED))
> > >                 goto out;
> > >=20
> > > There are 'goto out's from both before dev_get() and after it,
> > > dev_put() will be called with NULL pointer. dev_put() can't handle
> > > NULL at least in the old kernels... this is simply confused.
> > >=20
> > > Mainline has dev_put_track() there, but I see same confusion.
> > >=20
> > > Best regards,
> >=20
> > commit 2d327a79ee17 ("llc: only change llc->dev when bind() succeeds"),
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?=
id=3D2d327a79ee176930dc72c131a970c891d367c1dc
> >=20
> > Should be in mainline on Thursday, LMK if we need to accelerate.
> > IDK if anyone enables LLC2.
>=20
> I'll queue this up now, thanks.

As the changelog says, this needs b37a46683739, otherwise there will
be oops-es in even more cases.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJBew0ACgkQMOfwapXb+vL+3QCbB8OPjMf8jjD9ZWJVZH5BCY61
vJUAoKjHhZQ7OWTNL2kEtaxZ7pn7Mui5
=GOu8
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
