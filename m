Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F814F1AF7
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379329AbiDDVTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380258AbiDDTV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:21:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F037A93
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:19:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nbSEZ-0003k0-1H; Mon, 04 Apr 2022 21:19:27 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-3524-91ca-8473-ba45.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:3524:91ca:8473:ba45])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2B5BE5A437;
        Mon,  4 Apr 2022 19:19:26 +0000 (UTC)
Date:   Mon, 4 Apr 2022 21:19:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use
 after free of skb" failed to apply to 5.10-stable tree
Message-ID: <20220404191925.liav72moiotwwxxp@pengutronix.de>
References: <164881453855199@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mynnw4f4u67t4avy"
Content-Disposition: inline
In-Reply-To: <164881453855199@kroah.com>
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


--mynnw4f4u67t4avy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.04.2022 14:02:18, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here you are...or...it should show up here sooner or later:
https://lore.kernel.org/all/20220404190830.1241263-1-mkl@pengutronix.de

regards,
Marc

>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 2e8e79c416aae1de224c0f1860f2e3350fa171f8 Mon Sep 17 00:00:00 2001
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Thu, 17 Mar 2022 08:57:35 +0100
> Subject: [PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb
>=20
> can_put_echo_skb() will clone skb then free the skb. Move the
> can_put_echo_skb() for the m_can version 3.0.x directly before the
> start of the xmit in hardware, similar to the 3.1.x branch.
>=20
> Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
> Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix=
=2Ede
> Cc: stable@vger.kernel.org
> Reported-by: Hangyu Hua <hbh25y@gmail.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 1a4b56f6fa8c..b3b5bc1c803b 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1637,8 +1637,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_cl=
assdev *cdev)
>  		if (err)
>  			goto out_fail;
> =20
> -		can_put_echo_skb(skb, dev, 0, 0);
> -
>  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
>  			cccr =3D m_can_read(cdev, M_CAN_CCCR);
>  			cccr &=3D ~CCCR_CMR_MASK;
> @@ -1655,6 +1653,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_cl=
assdev *cdev)
>  			m_can_write(cdev, M_CAN_CCCR, cccr);
>  		}
>  		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
> +
> +		can_put_echo_skb(skb, dev, 0, 0);
> +
>  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
>  		/* End of xmit function for version 3.0.x */
>  	} else {
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mynnw4f4u67t4avy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJLRLoACgkQrX5LkNig
011mqggAm+nro9UoFEYQaAr6bIHebgH30W7Aw1fp8gYG64UwU27xZGKTsso1sIxj
L5JRyO8PR4aDySit4xm51oSCpxf9svBUATr7v742X+eYeShB1UhT7qUz2T/lAev2
zrUlueMTalZobspI+lwYnunnZK9ROKI+6DwVPSky8FC6dKvjqW5fa/epWsZkjqcN
iJDMV8WOJsJiER7WVr0Oo6E+NHP+CfW6D7JuBvgdmBGt1kNKS+JuUixYbiqaoBCX
peN7zF2JtYXAg31jMfntcrDvEVYiY9k5uwuhnTSZziclnYeNf9taX/GBYkaUVj6c
aUAC1EJkRhldYDKsjsavxGY0can3AQ==
=Ginx
-----END PGP SIGNATURE-----

--mynnw4f4u67t4avy--
