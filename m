Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67915EA60F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiIZM2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiIZM15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:27:57 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D0B1BB6;
        Mon, 26 Sep 2022 04:07:44 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A613D1C0016; Mon, 26 Sep 2022 12:29:23 +0200 (CEST)
Date:   Mon, 26 Sep 2022 12:29:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yihao Han <hanyihao@vivo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/30] video: fbdev: simplefb: Check before clk_put()
 not needed
Message-ID: <20220926102926.GB8978@amd>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.416842592@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <20220926100736.416842592@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Yihao Han <hanyihao@vivo.com>
>=20
> [ Upstream commit 5491424d17bdeb7b7852a59367858251783f8398 ]
>=20
> clk_put() already checks the clk ptr using !clk and IS_ERR()
> so there is no need to check it again before calling it.

This does not really fix any bug, so I'd preffer not to have it in
stable.

Best regards,
							Pavel

> +++ b/drivers/video/fbdev/simplefb.c
> @@ -231,8 +231,7 @@ static int simplefb_clocks_init(struct simplefb_par *=
par,
>  		if (IS_ERR(clock)) {
>  			if (PTR_ERR(clock) =3D=3D -EPROBE_DEFER) {
>  				while (--i >=3D 0) {
> -					if (par->clks[i])
> -						clk_put(par->clks[i]);
> +					clk_put(par->clks[i]);
>  				}
>  				kfree(par->clks);
>  				return -EPROBE_DEFER;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxfwYACgkQMOfwapXb+vJpxACcDzA4ANFw7Cv4hLHOf6YE61/I
59UAn1Jggubwf/eQAeCEL6m20W1KKzjT
=9QLu
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
