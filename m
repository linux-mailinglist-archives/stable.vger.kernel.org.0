Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C18529A741
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895307AbgJ0JED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408257AbgJ0JEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:04:02 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C7820870;
        Tue, 27 Oct 2020 09:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603789441;
        bh=5Gcw7k0eUtljJox1AOmH5be3N3M7rGCdkSsXn5sHhMY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=2TqSgyuRxdL6Z+vnabD+7abFdLlwaIKQzpiyD+Tszjc2AKXnhdAs1Ewgn9txa3p9H
         akVVQvT4Rw9auyBSIEDIQ2zubuNcJOdxfJnn9JyrF2KEZU1ok/4m5vrAlmL+VvC359
         xlQ8D9ds40Q7IMoN/W5NsXJRGxifTew7WFDxOUiM=
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>, pawell@cadence.com, rogerq@ti.com
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com,
        Peter Chen <peter.chen@nxp.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: cdns3: gadget: suspicious implicit sign extension
In-Reply-To: <20201016101659.29482-2-peter.chen@nxp.com>
References: <20201016101659.29482-1-peter.chen@nxp.com>
 <20201016101659.29482-2-peter.chen@nxp.com>
Date:   Tue, 27 Oct 2020 11:03:54 +0200
Message-ID: <87zh48ca6d.fsf@kernel.org>
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

I'll apply, but it looks like a pointless fix. We shouldn't need it for
stable.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl+X4noRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQb92w/+KT5diuJ2aHTvSkzd+nyEQOaHQARFXHJH
xYr/LtgQL+51xiV7vi/UEhHuZHmize/4jNXe8bPLkBYsiCSjUkJpV3uptQ64Rj3J
DBtSOZaPkGZoy2AGyCVjL6iv3c3JvtHoaQSxSEdA6NsGYIFKCI7+QaaKv0nRXaOS
JF5jQgoLeporKsKmB60xx8TUkKWF0ohG+wxt+CrPDwhF1ONlSKavEzP8z+EHrKZT
SINn7kCV+mhCa90v4hJD+jk4wrY/VH8KE5ccERyNZqzRoMx8xk7PODSJHybyKhs+
VWZ9Rb4C/eM1y5/qeGafdaigbE5vQix8mzu00TmmI3QL99jqmwb5SCzjMkjqhQIv
dzxddMI//AjNTrq//OADL2B/F8J16d7ID0HqX3EXG9ZU4cSxrFtJBfTiW2UAPdyL
lm0rlQPixCZrEh0pKkbUuWnuvRx71YBXewNkmcjBoAP17EJABRKU2auP65PSCz/m
9Xx6+ZLgpZeEn4RrVzeNRRFZwbCO9mJkkeiCjckgFwN0hIR95+h/c497cZjILkMk
CVJmnmDj0F2Y7dJ5fGeRCmLf7s440oDLqnaXUIV7nsO1gFzjd66y0SKsUpsHtyqJ
5jjsiO1TTQoKjtWhym/UZYy8+QpXNpFali0+FlYvkEfvNg0YJKAZoAkkToOGqf27
z2jwPm6hvKU=
=TDeG
-----END PGP SIGNATURE-----
--=-=-=--
