Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D1B1F0F71
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 22:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgFGUJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 16:09:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50840 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgFGUJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 16:09:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5ADE61C0BD2; Sun,  7 Jun 2020 22:09:11 +0200 (CEST)
Date:   Sun, 7 Jun 2020 22:09:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        fengsheng <fengsheng5@huawei.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 15/28] spi: dw: use "smp_mb()" to avoid sending spi
 data error
Message-ID: <20200607200910.GA13138@amd>
References: <20200605140252.338635395@linuxfoundation.org>
 <20200605140253.279609547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20200605140253.279609547@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Because of out-of-order execution about some CPU architecture,
> In this debug stage we find Completing spi interrupt enable ->
> prodrucing TXEI interrupt -> running "interrupt_transfer" function
> will prior to set "dw->rx and dws->rx_end" data, so this patch add
> memory barrier to enable dw->rx and dw->rx_end to be visible and
> solve to send SPI data error.

So, this is apparently CPU-vs-device issue...

> +++ b/drivers/spi/spi-dw.c
> @@ -304,6 +304,9 @@ static int dw_spi_transfer_one(struct spi_controller =
*master,
>  	dws->len =3D transfer->len;
>  	spin_unlock_irqrestore(&dws->buf_lock, flags);
> =20
> +	/* Ensure dw->rx and dw->rx_end are visible */
> +	smp_mb();
> +

But we use SMP-only memory barrier, thus the bug will still be there
in single-processor configurations. Should this be mb()?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7dSWYACgkQMOfwapXb+vK1GgCeKhaQnkGotAXJ3JtVtBG/A9mH
rU0AniQYz4+EoB5HTc6vo3KNbewgHGFg
=8y43
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
