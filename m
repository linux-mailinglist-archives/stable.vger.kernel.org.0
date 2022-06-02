Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C71E53B66A
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 11:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiFBJyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 05:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiFBJyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 05:54:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4BC38BFC
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 02:54:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nwhWs-0005bQ-SW; Thu, 02 Jun 2022 11:54:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BDEEC8AE12;
        Thu,  2 Jun 2022 09:54:09 +0000 (UTC)
Date:   Thu, 2 Jun 2022 11:54:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     linux-can@vger.kernel.org,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock
 frequency regression
Message-ID: <20220602095409.2ytxs4y6o7ctbcp7@pengutronix.de>
References: <20220602063031.415858-1-extja@kvaser.com>
 <20220602063031.415858-2-extja@kvaser.com>
 <20220602080257.243x4brmkjgve5kr@pengutronix.de>
 <a4866c5a-5516-06cb-fa1a-83e5014f6d36@kvaser.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ktbmkykyshv7pgi6"
Content-Disposition: inline
In-Reply-To: <a4866c5a-5516-06cb-fa1a-83e5014f6d36@kvaser.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ktbmkykyshv7pgi6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.06.2022 11:22:31, Jimmy Assarsson wrote:
> > > diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drive=
rs/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > > index e67658b53d02..5880e9719c9d 100644
> > > --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > > +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
> > > @@ -94,10 +94,14 @@
> > >   static inline bool kvaser_is_leaf(const struct usb_device_id *id)
> > >   {
> > > -	return (id->idProduct >=3D USB_LEAF_DEVEL_PRODUCT_ID &&
> > > -		id->idProduct <=3D USB_CAN_R_PRODUCT_ID) ||
> > > -		(id->idProduct >=3D USB_LEAF_LITE_V2_PRODUCT_ID &&
> > > -		 id->idProduct <=3D USB_LEAF_PRODUCT_ID_END);
> > > +	return id->idProduct >=3D USB_LEAF_DEVEL_PRODUCT_ID &&
> > > +	       id->idProduct <=3D USB_CAN_R_PRODUCT_ID;
> > > +}
> > > +
> > > +static inline bool kvaser_is_leafimx(const struct usb_device_id *id)
> > > +{
> > > +	return id->idProduct >=3D USB_LEAF_LITE_V2_PRODUCT_ID &&
> > > +	       id->idProduct <=3D USB_LEAF_PRODUCT_ID_END;
> > >   }
> >=20
> > Is this getting a bit complicated now?
> > In this driver we have:
> >=20
> > 1) struct usb_device_id::driver_info
> > 2) kvaser_is_*()
> >=20
> > which is used to set
> >=20
> > 3) dev->card_data.leaf.family
> > 4) dev->ops
> >=20
> > and now you're adding:
> >=20
> > 5) dev->card_data.quirks
> >=20
> > which then affects
> >=20
> > 6) dev->cfg
> >=20
> > The straight forward way would be to define a struct that describes the
> > a device completely:
> >=20
> > struct kvaser_driver_info {
> >         u32 quirks;        /* KVASER_USB_HAS_ */
> >         enum kvaser_usb_leaf_family;
> >         const struct kvaser_usb_dev_*ops;
> >         const struct kvaser_usb_dev_*cfg;
> > };
> >=20
> > and then assign that to every device listed in the kvaser_usb_table.
>=20
> Thanks for the feedback!
> I agree, but I prefer if we can keep assigning dev->cfg based on the
> information that we get from the device.

Ok, if you cannot tell from the USB product ID.

> So we get:
> struct kvaser_driver_info {
>         u32 quirks;        /* KVASER_USB_HAS_ */

That holds the existing quirks and the new one.

>         enum kvaser_usb_leaf_family;
>         const struct kvaser_usb_dev_*ops;
> };
> And quirks and family still affect dev->cfg.

=2E..as is depends on sw_options read from the device?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ktbmkykyshv7pgi6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKYiL4ACgkQrX5LkNig
011ckAf9GFFU5+NXj9laAHhfz8N0GE8bBaa8HnZR3KZDIndXtUdw948wnE2RB13y
R/G8J4oet82ppgpd/s5Rt9YCiZiDCPifpigX/OEgluukTsMTrdZxR3TTXE34wIYH
TivQP5FgiMIY7HKliQnfLYQM4/TNTiHAws2Ros4mYvALbHNVWTFyuijCQniKJnUm
ouj2hpTYDbjxg1CTxBbVKduKip2hVrj4HFPdyt7B8ER887Lq+RpxmSMuH0kOQ+Mk
D3JD4XLLgJsXWKClw3T1ONp3SWKPno4BXkToBFWEpKD48HxJeEhozCUOEFBTzRSx
zA9ZrMehPgIBrFTcF6Tk1GrMRvhfig==
=0K0E
-----END PGP SIGNATURE-----

--ktbmkykyshv7pgi6--
