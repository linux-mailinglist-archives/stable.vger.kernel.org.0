Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54DF4E846C
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 22:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiCZVgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiCZVgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 17:36:47 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5406367;
        Sat, 26 Mar 2022 14:35:10 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 86F7D1C0BB0; Sat, 26 Mar 2022 22:35:08 +0100 (CET)
Date:   Sat, 26 Mar 2022 22:35:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220326213508.GA19319@duo.ucw.cz>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Can someone check this? AFAICT this is buggy.
> >=20
> > static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *ad=
dr)
> > {
> >         struct sock *sk =3D sock->sk;
> >         struct llc_sock *llc =3D llc_sk(sk);
> >         struct llc_sap *sap;
> >         int rc =3D -EINVAL;
> >=20
> >         if (!sock_flag(sk, SOCK_ZAPPED))
> >                 goto out;
> >=20
> > There are 'goto out's from both before dev_get() and after it,
> > dev_put() will be called with NULL pointer. dev_put() can't handle
> > NULL at least in the old kernels... this is simply confused.
> >=20
> > Mainline has dev_put_track() there, but I see same confusion.
> >=20
> > Best regards,
>=20
> commit 2d327a79ee17 ("llc: only change llc->dev when bind() succeeds"),
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D2d327a79ee176930dc72c131a970c891d367c1dc
>=20
> Should be in mainline on Thursday, LMK if we need to accelerate.
> IDK if anyone enables LLC2.

Thank you, yes, that looks good at the fast glance.

But this patch does more harm than good on its own, so I believe it
should be dropped for now, and only queued when the fixes are
available.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYj+HDAAKCRAw5/Bqldv6
8mq1AJ0bTNob2KnQ6EoqC7ZTKarL9RKpqACdFQheyFUb4iymIl7EtfgaH1hnpz4=
=CQRa
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
