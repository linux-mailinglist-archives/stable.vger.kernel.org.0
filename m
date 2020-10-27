Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C854229A735
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408132AbgJ0JDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408143AbgJ0JDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:03:37 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581A3206DC;
        Tue, 27 Oct 2020 09:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603789417;
        bh=+88N+jaf6zFgt8gBGY6GxL5Kq0Ie4Xujwte+ErsZbrg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UL33vr29j+dVAhlRaFzJ/uPlfCEPQwT/+SG2eygmGjo5z/siQ+27w3v+iXnOL8YYq
         c+nh4h+BWxMv3dL59qQiAYmdFb0snTxaaivi6oDjHoqhSE5/WieZGeEgkFxOCSHogu
         R2Y5dHMoof54GJZsVotOhz2JWrek9M3OyQecylZc=
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>, pawell@cadence.com, rogerq@ti.com
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com,
        Peter Chen <peter.chen@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign extension
In-Reply-To: <20201016101659.29482-2-peter.chen@nxp.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com>
Date:   Tue, 27 Oct 2020 11:03:29 +0200
Message-ID: <871rhkdori.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Peter Chen <peter.chen@nxp.com> writes:
> For code:
> trb->length =3D cpu_to_le32(TRB_BURST_LEN(priv_ep->trb_burst_size)
> 	       	| TRB_LEN(length));
>
> TRB_BURST_LEN(priv_ep->trb_burst_size) may be overflow for int 32 if
> priv_ep->trb_burst_size is equal or larger than 0x80;
>
> Below is the Coverity warning:
> sign_extension: Suspicious implicit sign extension: priv_ep->trb_burst_si=
ze
> with type u8 (8 bits, unsigned) is promoted in priv_ep->trb_burst_size <<=
 24
> to type int (32 bits, signed), then sign-extended to type unsigned long
> (64 bits, unsigned). If priv_ep->trb_burst_size << 24 is greater than 0x7=
FFFFFFF,
> the upper bits of the result will all be 1.

looks like a false positive...

> Cc: <stable@vger.kernel.org> #v5.8+
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/usb/cdns3/gadget.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/cdns3/gadget.h b/drivers/usb/cdns3/gadget.h
> index 1ccecd237530..020936cb9897 100644
> --- a/drivers/usb/cdns3/gadget.h
> +++ b/drivers/usb/cdns3/gadget.h
> @@ -1072,7 +1072,7 @@ struct cdns3_trb {
>  #define TRB_TDL_SS_SIZE_GET(p)	(((p) & GENMASK(23, 17)) >> 17)
>=20=20
>  /* transfer_len bitmasks - bits 31:24 */
> -#define TRB_BURST_LEN(p)	(((p) << 24) & GENMASK(31, 24))
> +#define TRB_BURST_LEN(p)	(unsigned int)(((p) << 24) & GENMASK(31, 24))

... because TRB_BURST_LEN() is used to intialize a __le32 type. Even if
it ends up being sign extended, the top 32-bits will be ignored.

I'll apply, but it looks like a pointless fix. We shouldn't need it for sta=
ble

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl+X4mERHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQa8Ug/9GY0hScyIyCfZE4ugHeECPPIsjd1xC2ac
PpKkhf88Lb1BLLsNOXXEXwMeAza3B2pxt2MQWhZhSNiSU5WOa4P9E1F6nXpcjp46
RwDTk4mzyWVjfFqQYcF5ZDwT/6+49YKif0TO9OQQg5CGMaa+VK9+o8jLxKl/TYHG
dKnjfhIwkbA3NPMbfm0d445JT1evMDHCK7qt487eK+ifNRXdv6IWMuB/JHMe+ny/
V7Ygc7IKSnoo0CaAyj3/oQchsTyW+cleT3TXPYXUQIHjXuGJDvv1E5thVva0D4zF
yjMKFe+0TIW0SqMflg2ufV9MBQoqNqmzJGWB5N0+nhp4XFBWYts5JEHDejZyVosT
glhhROCFEMMAieqHb1XwcoPNRmNGvWKdRMhaANyUhBPxMe6Kf50FLbja7cgGay4K
aRqKlYnw8GbS4de6ZCYj8AZpQPFvHFnX6S2rNSo4hrWrbR5+/rmPVuWwf2tejt21
Ko7ch82bTNKCdYnu5THByGmOfnckZiTk1fLu8P7ygqcrnfSO8xeKjiARSN98EAgf
kYqacE90zCysiF7tthEw7cmWaWODBm+JUw/4pgAJingYX9a2Saib/9ZbQ4aFiZhh
ToHIMovA4z2M9/g/g4IbWsiJEhXDNRI4fpgDDTyxmGRyWgeBnW8JaMSorJt6y8AU
YQpldMS6fP8=
=W+KT
-----END PGP SIGNATURE-----
--=-=-=--
