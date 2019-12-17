Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879B412291A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfLQKpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:45:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43858 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQKpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 05:45:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE3661C25AF; Tue, 17 Dec 2019 11:45:21 +0100 (CET)
Date:   Tue, 17 Dec 2019 11:45:20 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Arnd Bergmann <arnd@arndb.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
        nekit1000@gmail.com, mpartap@gmx.net, merlijn@wizzup.org,
        martin_rysavy@centrum.cz
Cc:     Sekhar Nori <nsekhar@ti.com>, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: TI omap compile problem in 5.5-rc1? was Re: [PATCH] ARM: davinci:
 select CONFIG_RESET_CONTROLLER
Message-ID: <20191217104520.GA6812@amd>
References: <20191210195202.622734-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20191210195202.622734-1-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Selecting RESET_CONTROLLER is actually required, otherwise we
> can get a link failure in the clock driver:
>=20
> drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
> psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_regist=
er'
> drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> psc-da850.c:(.text+0x24): undefined reference to
> `reset_controller_add_lookup'

Does omap need similar handing in 5.5-rc1?

  LD      .tmp_vmlinux1
  drivers/soc/ti/omap_prm.o: In function `omap_prm_probe':
  omap_prm.c:(.text+0x4d0): undefined reference to
  `devm_reset_controller_register'
  /data/fast/l/k/Makefile:1077: recipe for target 'vmlinux' failed
  make[1]: *** [vmlinux] Error 1

Enabling reset controller seems to help::

Reset Controller Support (RESET_CONTROLLER) [Y/n/?] (NEW)
  TI SYSCON Reset Driver (RESET_TI_SYSCON) [N/m/y/?] (NEW)

Best regards,
									Pavel
								=09
--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl34scAACgkQMOfwapXb+vJX/QCaAiolSUbq20R1wAUi547D5rKC
5RUAoIioT2u+yCvZCDxs+tUsZ16rutri
=bJen
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
