Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A460F47B461
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhLTUb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:31:59 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45108 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhLTUbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:31:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D74E1C0B9B; Mon, 20 Dec 2021 21:31:37 +0100 (CET)
Date:   Mon, 20 Dec 2021 21:31:36 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 18/56] hv: utils: add PTP_1588_CLOCK to Kconfig to
 fix build
Message-ID: <20211220203136.GA4116@duo.ucw.cz>
References: <20211220143023.451982183@linuxfoundation.org>
 <20211220143024.049888083@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20211220143024.049888083@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> [ Upstream commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 ]
>=20
> The hyperv utilities use PTP clock interfaces and should depend a
> a kconfig symbol such that they will be built as a loadable module or
> builtin so that linker errors do not happen.
>=20
> Prevents these build errors:
>=20
> ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
> hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
> ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
> hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'

This is bad idea for 4.19:

> +++ b/drivers/hv/Kconfig
> @@ -16,6 +16,7 @@ config HYPERV_TSCPAGE
>  config HYPERV_UTILS
>  	tristate "Microsoft Hyper-V Utilities driver"
>  	depends on HYPERV && CONNECTOR && NLS
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	help
>  	  Select this option to enable the Hyper-V Utilities.

grep -ri PTP_1588_CLOCK_OPTIONAL .

Results in no result in 4.19. So this will break hyperv. No results in
5.10, either, so it is bad idea there, too.

								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYcDoKAAKCRAw5/Bqldv6
8oBMAKCgnb4ZMZKPGEbClgzgV4g8aC9yXwCfXuY6nLMvzo2dUc8uwd+QynOEeqU=
=Y+0N
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
