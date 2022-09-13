Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12AA5B7178
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiIMOhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiIMOfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAA96B642
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 07:20:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oY6l5-0003zp-Ah; Tue, 13 Sep 2022 16:19:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:e27a:1417:2420:c072])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 20A36E2236;
        Tue, 13 Sep 2022 14:19:26 +0000 (UTC)
Date:   Tue, 13 Sep 2022 16:19:17 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 5.19 123/192] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Message-ID: <20220913141917.ukoid65sqao5f4lg@pengutronix.de>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220913140416.124325107@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="af6c52mww4vpchdw"
Content-Disposition: inline
In-Reply-To: <20220913140416.124325107@linuxfoundation.org>
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


--af6c52mww4vpchdw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On 13.09.2022 16:03:49, Greg Kroah-Hartman wrote:
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

there's a revert pending for this patch:

| https://lore.kernel.org/all/20220912070143.98153-1-francesco.dolcini@tora=
dex.com

=2E..as it causes troubles in 6.0-rc4:

| https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutronix.d=
e/
| https://lore.kernel.org/all/CAHk-=3Dwj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5WMj8eh=
eb3A9WHw@mail.gmail.com/

please drop this patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--af6c52mww4vpchdw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMgkWIACgkQrX5LkNig
012O6Qf+IMmJPdO6Klc+65dYelBzSP71ECLl5oevZ3+kFxdgPaUdeuQUbjt/d7q1
daOodkWOcmkL/NStL6xRJJ/0SZ0q0hfP0KqP4BbIjaGSiox/C4lD1Feo/hRTHs+z
Qmvh5a7wdzXMqCKx8pF439QAaKetnwKwS8ZcIJ282clRy+KqQU7i57N/4S82qpKO
g1Q6KS3JWZF3a/8GK4sSh07jAa2W1CaPkMhxjNXnSHhk8OomKCvVrt4c5eN+YJu5
RoZ/0Hb9z2dWBAFyqeyB0zkiN76c7aqCxcy61eofobdhT1ypzOnTtDvxa95Xdz2V
w5JiujUU7gnQLoIAT9SyXG+TmcUidQ==
=v56d
-----END PGP SIGNATURE-----

--af6c52mww4vpchdw--
