Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE745B7785
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiIMROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiIMROP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:14:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E86B2A717
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:03:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oY8Hl-0003F9-NB; Tue, 13 Sep 2022 17:57:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e27a:1417:2420:c072])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1A6D1E2363;
        Tue, 13 Sep 2022 15:57:17 +0000 (UTC)
Date:   Tue, 13 Sep 2022 17:57:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 5.10 59/79] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Message-ID: <20220913155709.4xtmo3gephilcwk3@pengutronix.de>
References: <20220913140350.291927556@linuxfoundation.org>
 <20220913140353.063220321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6lghwa3xlo5fb2a3"
Content-Disposition: inline
In-Reply-To: <20220913140353.063220321@linuxfoundation.org>
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


--6lghwa3xlo5fb2a3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.09.2022 16:05:04, Greg Kroah-Hartman wrote:
> From: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
>=20
> [ Upstream commit b353b241f1eb9b6265358ffbe2632fdcb563354f ]
>=20
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
>=20
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock=
 is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutr=
onix.de/
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>
> Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> # Toradex Ap=
alis iMX6
> Link: https://lore.kernel.org/r/20220901140402.64804-1-csokas.bence@prola=
n.hu
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

If possible please drop this patch, a revert for this is pending. For
details see:

https://lore.kernel.org/all/20220913141917.ukoid65sqao5f4lg@pengutronix.de/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6lghwa3xlo5fb2a3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMgqFIACgkQrX5LkNig
012TTAf+P0rJtQK4dwHta/xlt6YZr7XEt4I0c6vwW0QOxPT0YP/tAckl0TPf9Y6r
vkkokyECbOx0yjTow08sJDHvOpikQ0rcLCafpa4sY/emrxCBbMHJVAoXAsP2e3Mu
hQBDq8jNfoFCgfg1Uvt9BU3ChI1JKkjbbf+Hmzw8MNfLW2QWOLglY/T13SNyEHQP
4wWbewWvgDU5bzUBcXMjUuxZukMTUOGiArjY2ruHt8D2PQgo3Snx+S4sAUIe6VrR
W94t1xTk9rGV29Z/gxAL7GfyFH5vqVShz2H/RfN0h/yiM2y7DsEehO32vaDoLME/
iJs6D0Ie7sbkiIBiiB5N9R4LlmUATg==
=Exn+
-----END PGP SIGNATURE-----

--6lghwa3xlo5fb2a3--
