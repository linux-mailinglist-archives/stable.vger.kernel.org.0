Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A976A4895F6
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 11:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiAJKHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 05:07:11 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59314 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiAJKHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 05:07:11 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8E2651C0B76; Mon, 10 Jan 2022 11:07:08 +0100 (CET)
Date:   Mon, 10 Jan 2022 11:07:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 09/43] netrom: fix copying in user data in
 nr_setsockopt
Message-ID: <20220110100708.GA5588@duo.ucw.cz>
References: <20220110071817.337619922@linuxfoundation.org>
 <20220110071817.669190550@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20220110071817.669190550@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Christoph Hellwig <hch@lst.de>
>=20
> commit 3087a6f36ee028ec095c04a8531d7d33899b7fed upstream.
>=20
> This code used to copy in an unsigned long worth of data before
> the sockptr_t conversion, so restore that.

Maybe, but then	the size checks	need to	be updated, too.

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/netrom/af_netrom.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/net/netrom/af_netrom.c
> +++ b/net/netrom/af_netrom.c
> @@ -306,7 +306,7 @@ static int nr_setsockopt(struct socket *
>  	if (optlen < sizeof(unsigned int))

This should   be   < sizeof(unsigned long)) ... AFAICT.

>  		return -EINVAL;
> =20
> -	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
> +	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
>  		return -EFAULT;
> =20

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYdwFTAAKCRAw5/Bqldv6
8vfBAJ0RhsWD/rzFW3orbWdDzc4TZzvGTgCgrVp1cMAZ+2WFDCPjok5cxZxbg6s=
=kxTY
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
