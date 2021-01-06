Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769BB2EBE41
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhAFNI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:08:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44542 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFNI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 08:08:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F0ACE1C0B92; Wed,  6 Jan 2021 14:07:45 +0100 (CET)
Date:   Wed, 6 Jan 2021 14:07:45 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 34/47] rtc: sun6i: Fix memleak in sun6i_rtc_clk_init
Message-ID: <20210106130745.GA8113@duo.ucw.cz>
References: <20210104155705.740576914@linuxfoundation.org>
 <20210104155707.382290687@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20210104155707.382290687@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dinghao Liu <dinghao.liu@zju.edu.cn>
>=20
> [ Upstream commit 28d211919e422f58c1e6c900e5810eee4f1ce4c8 ]
>=20
> When clk_hw_register_fixed_rate_with_accuracy() fails,
> clk_data should be freed. It's the same for the subsequent
> two error paths, but we should also unregister the already
> registered clocks in them.

This still leaks rtc, AFAICT. What is worse, sun6i_rtc will point to
invalid memory after the error exit.

Something like this?

Best regards,
								Pavel

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index e85abe805606..59389bb99e39 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -211,6 +211,7 @@ static void __init sun6i_rtc_clk_init(struct device_nod=
e *node)
 	rtc->base =3D of_io_request_and_map(node, 0, of_node_full_name(node));
 	if (IS_ERR(rtc->base)) {
 		pr_crit("Can't map RTC registers");
+		kfree(rtc);
 		goto err;
 	}
=20
@@ -272,6 +273,8 @@ static void __init sun6i_rtc_clk_init(struct device_nod=
e *node)
 	clk_hw_unregister_fixed_rate(rtc->int_osc);
 err:
 	kfree(clk_data);
+	kfree(rtc);
+	sun6i_rtc =3D NULL;
 }
 CLK_OF_DECLARE_DRIVER(sun6i_rtc_clk, "allwinner,sun6i-a31-rtc",
 		      sun6i_rtc_clk_init);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/W2IQAKCRAw5/Bqldv6
8mPXAJ0da3pksK41IGG2AIKibMwdM6cKZACeOOzM5Pu7sFekg9AjxyoX0yO2I08=
=OMHb
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
