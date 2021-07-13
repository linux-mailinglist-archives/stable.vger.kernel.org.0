Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041A83C782D
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGMUv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:51:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49672 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMUv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:51:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DDA291C0B7F; Tue, 13 Jul 2021 22:49:06 +0200 (CEST)
Date:   Tue, 13 Jul 2021 22:49:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linyu Yuan <linyyuan@codeaurora.com>
Subject: Re: [PATCH 5.10 021/593] usb: gadget: eem: fix echo command packet
 response issue
Message-ID: <20210713204906.GB21897@amd>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060845.545018422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20210712060845.545018422@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> fix it by allocating a usb request from IN endpoint of eem interface,
> and transmit the usb request to same IN endpoint of eem interface.

>  drivers/usb/gadget/function/f_eem.c |   43
> @@ -439,11 +449,36 @@ static int eem_unwrap(struct gether *por
>  				skb_trim(skb2, len);
>  				put_unaligned_le16(BIT(15) | BIT(11) | len,
>  							skb_push(skb2, 2));
> +
> +				ep =3D port->in_ep;
> +				req =3D usb_ep_alloc_request(ep, GFP_ATOMIC);
> +				if (!req) {
> +					dev_kfree_skb_any(skb2);
> +					goto next;
> +				}
> +
> +				req->buf =3D kmalloc(skb2->len, GFP_KERNEL);
> +				if (!req->buf) {
> +					usb_ep_free_request(ep, req);
> +					dev_kfree_skb_any(skb2);
> +					goto next;
> +				}

This does not make sense; either both allocations can be GFP_KERNEL or
both must be GFP_ATOMIC, no?

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDt/EIACgkQMOfwapXb+vKHPwCfYxQpOCk72piI9ImUqBMNrzEP
wWAAni6DSGoWyVRURaLhoDDYU/FIpzgy
=9oae
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
