Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76318978C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 10:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgCRJC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 05:02:56 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43448 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgCRJC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 05:02:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0F8A61C0322; Wed, 18 Mar 2020 10:02:54 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:02:53 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 03/89] cgroup, netclassid: periodically release
 file_lock on classid updating
Message-ID: <20200318090253.GA32397@duo.ucw.cz>
References: <20200317103259.744774526@linuxfoundation.org>
 <20200317103300.173739219@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20200317103300.173739219@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dmitry Yakunin <zeil@yandex-team.ru>
>=20
> [ Upstream commit 018d26fcd12a75fb9b5fe233762aa3f2f0854b88 ]
=2E..
> Now update is non atomic and socket may be skipped using calls:
>=20
> dup2(oldfd, newfd);
> close(oldfd);
>=20
> But this case is not typical. Moreover before this patch skip is possible
> too by hiding socket fd in unix socket buffer.

Dunno. This makes interface even more interesting.

> +
>  static int update_classid_sock(const void *v, struct file *file, unsigne=
d n)
>  {
>  	int err;
> +	struct update_classid_context *ctx =3D (void *)v;
>  	struct socket *sock =3D sock_from_file(file, &err);
>
=2E..
> +	if (--ctx->batch =3D=3D 0) {
> +		ctx->batch =3D UPDATE_CLASSID_BATCH;
> +		return n + 1;
> +	}
>  	return 0;
>  }

We take "const void *" and then write to it. That's asking for
trouble... right? Should the const annotation be removed, at least for
sake of humans trying to understand the code?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXnHjvQAKCRAw5/Bqldv6
8ltcAKC4P/hM60j4SfDJ/8gr8w3PMtcMdQCfU7uvgqqEAvk+R5iIVCrYfnnF14c=
=i9db
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
