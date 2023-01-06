Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33DF65FFA0
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 12:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjAFLhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 06:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjAFLhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 06:37:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009B71897
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 03:37:39 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pDl2X-0008Kq-JE; Fri, 06 Jan 2023 12:37:37 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:ace:f7a6:f9d4:3e8a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C38DF14FE83;
        Fri,  6 Jan 2023 11:37:36 +0000 (UTC)
Date:   Fri, 6 Jan 2023 12:37:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] can: isotp: handle wait_event_interruptible() return
 values
Message-ID: <20230106113731.irqfxdpn5ygae44e@pengutronix.de>
References: <20230104164605.39666-1-socketcan@hartkopp.net>
 <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
 <20bef3ed-47ef-8042-6b98-1f498b81962f@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ushtqqd6jbjlmlrn"
Content-Disposition: inline
In-Reply-To: <20bef3ed-47ef-8042-6b98-1f498b81962f@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ushtqqd6jbjlmlrn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.01.2023 13:58:30, Oliver Hartkopp wrote:
>=20
>=20
> On 05.01.23 10:32, Marc Kleine-Budde wrote:
> > On 04.01.2023 17:46:05, Oliver Hartkopp wrote:
> > > When wait_event_interruptible() has been interrupted by a signal the
> > > tx.state value might not be ISOTP_IDLE. Force the state machines
> > > into idle state to inhibit the timer handlers to continue working.
> > >=20
> > > Cc: stable@vger.kernel.org # >=3D v5.15
> > > Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> >=20
> > Can you add a Fixes: tag?
>=20
> Yes. Sent out a V3.
>=20
> In fact I was not sure if it makes sense to apply the patch down to Linux
> 5.10 as it might increase the possibility to trigger a WARN(1) in the
> isotp_tx_timer_handler().
>=20
> The patch is definitely helpful for the latest code including commit
> 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive
> frames") introduced in Linux 5.18 and its fixes.
>=20
> I did some testing with very long ISOTP PDUs and killed the waiting
> isotp_release() with a Crtl-C.
>=20
> To prevent the WARN(1) we might also stick this patch to
>=20
> Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx
> processing")
>=20
> What do you think about the WARN(1)?

If this short patch avoids potential WARN()s it's stable material.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ushtqqd6jbjlmlrn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmO4B/cACgkQrX5LkNig
012pHAf/Wzm/yboJjvyc3kjgy4h0L9GPUQBrwxYvj/wXKIrao/bFRHEtI+arvYUo
qj292oqE7BEYv0U9K1srbCMDxisO0n7naVJ8YfO1zvGs29QJp+YIRlP0JngTZyHw
fEvG9stVwjSbasDfxerBVn+aD27CCv9kxTu+mHYOEa4X+4f5wOG+knhUolwHFdWP
97vFETs+yxII+3ccJSAWKUkpPgD708GyMp/msV0t5ujSmBEkzygaS2bHIWaejMAT
02K+c7rnq03AQtV5Yq4jJhDbn20vPpJxMIpQHFWGbv7bTVX67w736K3EppEt2Eq7
4vyumIlSnsCoQaDSHFeRnzsDJW18Wg==
=8m0r
-----END PGP SIGNATURE-----

--ushtqqd6jbjlmlrn--
