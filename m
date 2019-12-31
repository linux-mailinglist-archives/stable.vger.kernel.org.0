Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986B912D822
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 12:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfLaLCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 06:02:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45666 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfLaLCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 06:02:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 554DE1C2605; Tue, 31 Dec 2019 12:02:35 +0100 (CET)
Date:   Tue, 31 Dec 2019 12:02:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Faiz Abbas <faiz_abbas@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 4.19 215/219] mmc: sdhci: Update the tuning failed
 messages to pr_debug level
Message-ID: <20191231110234.GA14641@amd>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162542.999358059@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20191229162542.999358059@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-29 18:20:17, Greg Kroah-Hartman wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
>=20
> commit 2c92dd20304f505b6ef43d206fff21bda8f1f0ae upstream.
>=20
> Tuning support in DDR50 speed mode was added in SD Specifications Part1
> Physical Layer Specification v3.01. Its not possible to distinguish
> between v3.00 and v3.01 from the SCR and that is why since
> commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
> tuning failures are ignored in DDR50 speed mode.
>=20
> Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
> error gets printed during enumeration and also if retune is triggered at
> any time during operation. Update the printk level to pr_debug so that
> these errors don't lead to false error reports.

Well, downgrading level might be ok, but people will still see the
message in dmesg.

> +++ b/drivers/mmc/host/sdhci.c
> @@ -2244,8 +2244,8 @@ static void __sdhci_execute_tuning(struc
>  		sdhci_send_tuning(host, opcode);
> =20
>  		if (!host->tuning_done) {
> -			pr_info("%s: Tuning timeout, falling back to fixed sampling clock\n",
> -				mmc_hostname(host->mmc));
> +			pr_debug("%s: Tuning timeout, falling back to fixed sampling clock\n",
> +				 mmc_hostname(host->mmc));

Maybe adding something like "(this is expected on SD cards
implementing phy specification v3.00)" to the user-visible text would
be even better?=20

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4LKsoACgkQMOfwapXb+vKHgACbBlWS6E/Nn/z1rfJwBpatiK/S
SQIAoImGETp/MGWkJGSVdtofXsJmuf4p
=h7c1
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
