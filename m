Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770CE4E8400
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 21:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiCZULF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 16:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiCZULD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 16:11:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE872F025;
        Sat, 26 Mar 2022 13:09:25 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3695B1C0BB0; Sat, 26 Mar 2022 21:09:23 +0100 (CET)
Date:   Sat, 26 Mar 2022 21:09:22 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220326200922.GA9262@duo.ucw.cz>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20220325150420.029041400@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Dumazet <edumazet@google.com>
>=20
> commit 764f4eb6846f5475f1244767d24d25dd86528a4a upstream.
>=20
> Whenever llc_ui_bind() and/or llc_ui_autobind()
> took a reference on a netdevice but subsequently fail,
> they must properly release their reference
> or risk the infamous message from unregister_netdevice()
> at device dismantle.
>=20
> unregister_netdevice: waiting for eth0 to become free. Usage count =3D
> 3

Can someone check this? AFAICT this is buggy.

static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
{
        struct sock *sk =3D sock->sk;
        struct llc_sock *llc =3D llc_sk(sk);
        struct llc_sap *sap;
        int rc =3D -EINVAL;

        if (!sock_flag(sk, SOCK_ZAPPED))
                goto out;

There are 'goto out's from both before dev_get() and after it,
dev_put() will be called with NULL pointer. dev_put() can't handle
NULL at least in the old kernels... this is simply confused.

Mainline has dev_put_track() there, but I see same confusion.

Best regards,
								Pavel


> --- a/net/llc/af_llc.c
> +++ b/net/llc/af_llc.c
> @@ -311,6 +311,10 @@ static int llc_ui_autobind(struct socket
>  	sock_reset_flag(sk, SOCK_ZAPPED);
>  	rc =3D 0;
>  out:
> +	if (rc) {
> +		dev_put(llc->dev);
> +		llc->dev =3D NULL;
> +	}
>  	return rc;
>  }
> =20
> @@ -409,6 +413,10 @@ static int llc_ui_bind(struct socket *so
>  out_put:
>  	llc_sap_put(sap);
>  out:
> +	if (rc) {
> +		dev_put(llc->dev);
> +		llc->dev =3D NULL;
> +	}
>  	release_sock(sk);
>  	return rc;
>  }
>=20

--=20
 'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany'


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYj9y8gAKCRAw5/Bqldv6
8h/cAJ4vX1+h9QW7Q/pvas30WjEzLdg8MwCfZF1E35R7f/ffM8EqeyceUOPfknQ=
=lPmf
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
