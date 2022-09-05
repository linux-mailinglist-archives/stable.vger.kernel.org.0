Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26F15AD378
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiIENKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiIENKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:10:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE4737F84
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 06:10:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVBs2-0008JM-RM; Mon, 05 Sep 2022 15:10:34 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:86c0:9b80:5c95:555])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DA758DAC9A;
        Mon,  5 Sep 2022 13:10:32 +0000 (UTC)
Date:   Mon, 5 Sep 2022 15:10:32 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     linux-can@vger.kernel.org,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 14/15] can: kvaser_usb: Add struct kvaser_usb_busparams
Message-ID: <20220905131032.u2avrm3tbqehvdnv@pengutronix.de>
References: <20220903182344.139-1-extja@kvaser.com>
 <20220903182559.189-14-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cca7x3kor5zegp4v"
Content-Disposition: inline
In-Reply-To: <20220903182559.189-14-extja@kvaser.com>
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


--cca7x3kor5zegp4v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.09.2022 20:25:58, Jimmy Assarsson wrote:
> Add struct kvaser_usb_busparams containing the busparameters used in
> CMD_{SET,GET}_BUSPARAMS* commands.

| drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c:167:30: error: field
| busparams within 'struct kvaser_cmd_busparams' is less aligned than
| 'struct kvaser_usb_busparams' and is usually due to 'struct
| kvaser_cmd_busparams' being packed, which can lead to unaligned
| accesses [-Werror,-Wunaligned-access]
|         struct kvaser_usb_busparams busparams;
|                                     ^
| 1 error generated.

Fixed while applying.

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/=
usb/kvaser_usb/kvaser_usb.h
index 040885c7d0c4..778b61c90c2b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -82,7 +82,7 @@ struct kvaser_usb_busparams {
        u8 tseg2;
        u8 sjw;
        u8 nsamples;
-};
+} __packed;
=20
 struct kvaser_usb {
        struct usb_device *udev;

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cca7x3kor5zegp4v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMV9UUACgkQrX5LkNig
010rIgf+NEiGJkIS1et3lprNhZPB1OGL0TqC+j1AWOqF8L8CHKbBZG6aXOMYO1R5
s68hATlMvyZ5ToROnbqy1uvTFPYpvNt+CvWfKP2bHLDvR9Ea8AvCVQS3FIYU8vUX
rGL/Xy/o6nNnAI7jxza5JjjYB0D1uTC/+IoLVC+XnFsgSh9H2GmfGg/rPFz+cGPx
rYg/T0gZR+Af04+ve+DwO761D//x5WnIURjcQDMuMsxb3lysc/8sxfAbbFmcvJZ8
mziyj116h4n7xVkAARuSuNZJn5XofeLvtiLcdzZN9xVAYCf13i3JMrVcKn8tDN6X
DysK7PbETUtIRhG0jGr0HKe3cQqRtQ==
=nTSe
-----END PGP SIGNATURE-----

--cca7x3kor5zegp4v--
