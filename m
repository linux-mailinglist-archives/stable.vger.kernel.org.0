Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557D527A241
	for <lists+stable@lfdr.de>; Sun, 27 Sep 2020 20:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI0SCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 14:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI0SCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Sep 2020 14:02:22 -0400
Received: from localhost (router.4pisysteme.de [80.79.225.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DBE8239EE;
        Sun, 27 Sep 2020 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601229741;
        bh=Pcdlp78cBYrlOzuuUxK1cg5jKmCZIVwx+ld131qYckM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQ2p5ClaHKssZ7nNk+wBddksdLSHrsob5OlGdBp2Jhs8+8m7xYwQ0f8gsoF/3SPaq
         8/MRgOEg2Oq36mlBE+oHzatHEYlDWIJRNmyX3cx+txbGQXxu8wzd/D2W0EH0BCUBie
         /TygWaMiIjx9G2DozYjR3/DfEAM97Ma935UyJ8m4=
Date:   Sun, 27 Sep 2020 20:02:19 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: imx: Fix external abort on interrupt in exit
 paths
Message-ID: <20200927180219.GF19475@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200920211238.13920-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <20200920211238.13920-1-krzk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2020 at 11:12:38PM +0200, Krzysztof Kozlowski wrote:
> If interrupt comes late, during probe error path or device remove (could
> be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> i2c_imx_isr() will access registers with the clock being disabled.  This
> leads to external abort on non-linefetch on Toradex Colibri VF50 module
> (with Vybrid VF5xx):
>=20
>     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d0=
03
>     Internal error: : 1008 [#1] ARM
>     Modules linked in:
>     CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>       (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
>       (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
>       (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
>       (really_probe) from [<80580380>] (driver_probe_device+0x60/0x170)
>       (driver_probe_device) from [<80580630>] (device_driver_attach+0x58/=
0x60)
>       (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/0xc0)
>       (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
>       (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1ec)
>       (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
>       (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
>       (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178/0x1=
dc)
>       (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
>       (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)
>=20
> Additionally, the i2c_imx_isr() could wake up the wait queue
> (imx_i2c_struct->queue) before its initialization happens.
>=20
> The resource-managed framework should not be used for interrupt handling,
> because the resource will be released too late - after disabling clocks.
> The interrupt handler is not prepared for such case.
>=20
> Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>=20

Applied to for-next, thanks!


--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl9w06sACgkQFA3kzBSg
KbZRug/9GShVTy90wo9UHy4Fnarxgy0JetTa/upHj8n9lOYCYgWyREp2EpH048pj
cR36wYDwq2bfyHghJYOL/UoQcNW7OXPVt1dBJvxgK0LwUAh/dG5NCColcTlMtmkj
MOvWjA/lbTHbW8SkY5dcdsB94R8rHf9+piBrjKOKUJsivD8LQvmlFfn+hPhQN8kn
3ZeMpCFKYFvVoTq1jiQfGRqEDHjb13SmPoebID7K6NZ6A0cLAGFe3NFvfWwi0Qgs
6JkzjwA2TuvqnB6tjzfJPxKo/gcChWeWcZNQ8ogDuc8QYbwFIAvY156vkdIVi2R/
hSdK23Do2OkZbjezY3QtFWEEZBzcb6lTXV1l4Uh83oUEA47lpe0l6/HOEWzEnzVU
iXm8yDZL8wW0MpCR5608SjRzPitFNtlCdeC4gc48snAkS341lVhFWWRzolw7CH/b
lrkoeEOtHTJDy52vX07mu7pOqXI2e3H232/NysXQ+hW/zAH3zjznJXkEd7TED4KP
UyQt+LMRaPmgC5OHmaGVEYU+i+VZbKep7xfJB4DqL3swp8IICAqs9Z2yqpMgQgTF
5qaUDWwn3lqtPsjkhieI7297XjiWCqMbwx4RwK+Euu5hkYz+f0QwxQNgGGn6wYuF
//tH/lqjgJ50pdtXLtdX6qVc0fGW67kmzalOYZWEzho91Fru0F0=
=qpFB
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
