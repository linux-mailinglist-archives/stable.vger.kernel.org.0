Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA86390BD
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 21:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKYUdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 15:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKYUcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 15:32:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2442B2FFF8
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 12:32:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyfMz-0003CL-4C; Fri, 25 Nov 2022 21:32:21 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:7110:a7cf:cd17:d31a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BB1BB129EC6;
        Fri, 25 Nov 2022 20:32:19 +0000 (UTC)
Date:   Fri, 25 Nov 2022 21:32:17 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Fink <pfink@christ-es.de>, stable@vger.kernel.org,
        Ryan Edwards <ryan.edwards@gmail.com>
Subject: Re: [PATCH] can: gs_usb: fix size parameter to usb_free_coherent()
 calls
Message-ID: <20221125203217.cuv63t4ijxwmqun7@pengutronix.de>
References: <20221125201727.1558965-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dsuqs6rbhixbi7gv"
Content-Disposition: inline
In-Reply-To: <20221125201727.1558965-1-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dsuqs6rbhixbi7gv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

with v5.18-rc1 in commit

| c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in struct g=
s_host_frame")

a bug in the gs_usb driver in the usage of usb_free_coherent() was
introduced. With v6.1-rc1

| 62f102c0d156 ("can: gs_usb: remove dma allocations")

the DMA allocation was removed altogether from the driver, fixing the
bug unintentionally.

We can either cherry-pick 62f102c0d156 ("can: gs_usb: remove dma
allocations") on v6.0, v5.19, and v5.18 or apply this patch, which fixes
the usage of usb_free_coherent() only.

regards,
Marc

On 25.11.2022 21:17:27, Marc Kleine-Budde wrote:
> In commit c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for
> data in struct gs_host_frame") the driver was extended from a compile
> time constant USB transfer size to a transfer size depending on
> attached USB device and configured CAN mode.
>=20
> During this conversion the size parameter of some usb_free_coherent()
> calls were not converted. To fix this issue replace the compile time
> constant sizeof(struct gs_host_frame) by hf_size_{rx,tx} for RX
> respectively TX USB transfers.
>=20
> Fixes: c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in s=
truct gs_host_frame")
> Cc: Peter Fink <pfink@christ-es.de>
> Cc: stable@vger.kernel.org
> Reported-by: Ryan Edwards <ryan.edwards@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/usb/gs_usb.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
> index cd4115a1b81c..57917955b8e4 100644
> --- a/drivers/net/can/usb/gs_usb.c
> +++ b/drivers/net/can/usb/gs_usb.c
> @@ -699,7 +699,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *=
skb,
>  	return NETDEV_TX_OK;
> =20
>   badidx:
> -	usb_free_coherent(dev->udev, urb->transfer_buffer_length,
> +	usb_free_coherent(dev->udev, dev->hf_size_tx,
>  			  urb->transfer_buffer, urb->transfer_dma);
>   nomem_hf:
>  	usb_free_urb(urb);
> @@ -787,7 +787,7 @@ static int gs_can_open(struct net_device *netdev)
> =20
>  				usb_unanchor_urb(urb);
>  				usb_free_coherent(dev->udev,
> -						  sizeof(struct gs_host_frame),
> +						  dev->parent->hf_size_rx,
>  						  buf,
>  						  buf_dma);
>  				usb_free_urb(urb);
> @@ -864,7 +864,7 @@ static int gs_can_close(struct net_device *netdev)
>  		usb_kill_anchored_urbs(&parent->rx_submitted);
>  		for (i =3D 0; i < GS_MAX_RX_URBS; i++)
>  			usb_free_coherent(dev->udev,
> -					  sizeof(struct gs_host_frame),
> +					  dev->parent->hf_size_rx,
>  					  dev->rxbuf[i],
>  					  dev->rxbuf_dma[i]);
>  	}
> --=20
> 2.35.1
>=20
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--dsuqs6rbhixbi7gv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOBJk4ACgkQrX5LkNig
013cIwf7BJDWe2z9XRyRnN9BfJMEdgmgZFMGr9lYR+m4LxjS/RrZWY8vGGO0cwGk
XibRaww1mjIRX3kyastgcdbemDM3MuFNjmAejDxOHw+QztvJjb2zG6QqFUJz5C9u
8IcyTP0tdIJlY5Qd897FUzutX8ryYvJUkWpHqjO4uVGZkgLpthO23KhAmfEgOY6a
B5TinPIb0aD8xzuqJoXDzW9Y0neHjF1OCGCTOQGBxrjnH40Yyqprhi/R+GqMz2JT
sHVUaZROjF98TqtN3wYwmVkG7Mh0tdZPOItz+TvIRhSKJ0Ek27kzKOaJsfAhWrNH
/Kaaiux2NNI141w3JFcWE8AsXxPAwA==
=pfV0
-----END PGP SIGNATURE-----

--dsuqs6rbhixbi7gv--
