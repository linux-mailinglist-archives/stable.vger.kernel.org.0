Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056151D2096
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 23:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgEMVDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 17:03:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51200 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgEMVDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 17:03:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 088FC1C0285; Wed, 13 May 2020 23:03:12 +0200 (CEST)
Date:   Wed, 13 May 2020 23:03:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH 4.19 35/48] batman-adv: Fix refcnt leak in
 batadv_store_throughput_override
Message-ID: <20200513210311.GA1822@duo.ucw.cz>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094400.720293748@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20200513094400.720293748@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
>=20
> commit 6107c5da0fca8b50b4d3215e94d619d38cc4a18c upstream.
>=20
> batadv_show_throughput_override() invokes batadv_hardif_get_by_netdev(),
> which gets a batadv_hard_iface object from net_dev with increased refcnt
> and its reference is assigned to a local pointer 'hard_iface'.
>=20
> When batadv_store_throughput_override() returns, "hard_iface" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
>=20
> The issue happens in one error path of
> batadv_store_throughput_override(). When batadv_parse_throughput()
> returns NULL, the refcnt increased by batadv_hardif_get_by_netdev() is
> not decreased, causing a refcnt leak.
>=20
> Fix this issue by jumping to "out" label when batadv_parse_throughput()
> returns NULL.

Ok, this fixes the issue, but it brings up a question:


> --- a/net/batman-adv/sysfs.c
> +++ b/net/batman-adv/sysfs.c
> @@ -1093,7 +1093,7 @@ static ssize_t batadv_store_throughput_o
>  	ret =3D batadv_parse_throughput(net_dev, buff, "throughput_override",
>  				      &tp_override);
>  	if (!ret)
> -		return count;
> +		goto out;
>

If parsing of value from userspace failed we are currently returning
success. That seems wrong. Should we return -EINVAL instead?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXrxgjwAKCRAw5/Bqldv6
8jBxAKCPatfcX8F+QT4Xyocp9Z5aK5zspQCfeBHvHJ78hSvs+RqKA0ND11ZVfKs=
=SVkw
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
