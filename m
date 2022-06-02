Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA89A53B4B3
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiFBIDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiFBIDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:03:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E9F65E8
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 01:03:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nwfnH-0007BP-GD; Thu, 02 Jun 2022 10:02:59 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3982E8ACED;
        Thu,  2 Jun 2022 08:02:58 +0000 (UTC)
Date:   Thu, 2 Jun 2022 10:02:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     linux-can@vger.kernel.org,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock
 frequency regression
Message-ID: <20220602080257.243x4brmkjgve5kr@pengutronix.de>
References: <20220602063031.415858-1-extja@kvaser.com>
 <20220602063031.415858-2-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rn5i24yumlhici3h"
Content-Disposition: inline
In-Reply-To: <20220602063031.415858-2-extja@kvaser.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rn5i24yumlhici3h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.06.2022 08:30:30, Jimmy Assarsson wrote:
> The firmware of M32C based Leaf devices expects bittiming parameters
> calculated for 16MHz clock.
> Since we use the actual clock frequency of the device, the device may end
> up with wrong bittiming parameters, depending on user requested parameter=
s.
>=20
> This regression affects M32C based Leaf devices with non-16MHz clock.

Oh. Thanks for the patch!

> Fixes: fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from devic=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> ---
>  drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  4 +++
>  .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 20 +++++++++++----
>  .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 25 ++++++++++++-------
>  3 files changed, 35 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/ca=
n/usb/kvaser_usb/kvaser_usb.h
> index 3a49257f9fa6..cb588228d7a1 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
> @@ -44,6 +44,9 @@
>  #define KVASER_USB_CAP_EXT_CAP			0x02
>  #define KVASER_USB_HYDRA_CAP_EXT_CMD		0x04
> =20
> +/* Quriks */
      ^^^^^^
Typo

> +#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ BIT(0)
> +
>  struct kvaser_usb_dev_cfg;
> =20
>  enum kvaser_usb_leaf_family {
> @@ -65,6 +68,7 @@ struct kvaser_usb_dev_card_data_hydra {
>  struct kvaser_usb_dev_card_data {
>  	u32 ctrlmode_supported;
>  	u32 capabilities;
> +	u32 quirks;
>  	union {
>  		struct {
>  			enum kvaser_usb_leaf_family family;
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/n=
et/can/usb/kvaser_usb/kvaser_usb_core.c
> index e67658b53d02..5880e9719c9d 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> @@ -94,10 +94,14 @@
> =20
>  static inline bool kvaser_is_leaf(const struct usb_device_id *id)
>  {
> -	return (id->idProduct >=3D USB_LEAF_DEVEL_PRODUCT_ID &&
> -		id->idProduct <=3D USB_CAN_R_PRODUCT_ID) ||
> -		(id->idProduct >=3D USB_LEAF_LITE_V2_PRODUCT_ID &&
> -		 id->idProduct <=3D USB_LEAF_PRODUCT_ID_END);
> +	return id->idProduct >=3D USB_LEAF_DEVEL_PRODUCT_ID &&
> +	       id->idProduct <=3D USB_CAN_R_PRODUCT_ID;
> +}
> +
> +static inline bool kvaser_is_leafimx(const struct usb_device_id *id)
> +{
> +	return id->idProduct >=3D USB_LEAF_LITE_V2_PRODUCT_ID &&
> +	       id->idProduct <=3D USB_LEAF_PRODUCT_ID_END;
>  }

Is this getting a bit complicated now?
In this driver we have:

1) struct usb_device_id::driver_info
2) kvaser_is_*()

which is used to set

3) dev->card_data.leaf.family
4) dev->ops

and now you're adding:

5) dev->card_data.quirks

which then affects

6) dev->cfg

The straight forward way would be to define a struct that describes the
a device completely:

struct kvaser_driver_info {
       u32 quirks;        /* KVASER_USB_HAS_ */
       enum kvaser_usb_leaf_family;
       const struct kvaser_usb_dev_*ops;
       const struct kvaser_usb_dev_*cfg;
};

and then assign that to every device listed in the kvaser_usb_table.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rn5i24yumlhici3h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKYbq4ACgkQrX5LkNig
0134SwgAo7kM+MSnTM5MROSLKE1xf8uKlu+9V4IdaKxd6kunXyF8gAkKd3vQpwBE
3a+qkQpPX+1xhsQEgLJqq4GIdI/2bdkDKI/YnDhjdT14WhrJjLeuLFuka0/MT1a0
wXJdGu84iHQRFL23uH3R7Ar3lYByLzXbye7ibduHL1BOUkvYXgPYHy4BYE1fyU4l
wcD0jH6cxEP9ZTXAMNI3cChuVta0hiqksE+HxV82SDzghLvXKvZMktoBIQOAXWIl
kVUkNRydVu0RzuovVgxevtd/w7YV3W/LHzX2sBnRl7tGR3W7XhxLpVCyUPIncVMW
U7UJCRVeIBfXxPMzTZPe8aWOzqkcbw==
=6DJ1
-----END PGP SIGNATURE-----

--rn5i24yumlhici3h--
