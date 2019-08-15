Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B758E530
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 09:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfHOHHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 03:07:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52158 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730186AbfHOHHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 03:07:42 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 114F880BC7; Thu, 15 Aug 2019 09:07:26 +0200 (CEST)
Date:   Thu, 15 Aug 2019 09:07:39 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 024/113] tty: serial: msm_serial: avoid system
 lockup condition
Message-ID: <20190815070739.GA3906@amd>
References: <20190729190655.455345569@linuxfoundation.org>
 <20190729190701.631193260@linuxfoundation.org>
 <20190731190533.GA4630@amd>
 <ca8ee0ab-dac5-28db-cac2-20e188473da6@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <ca8ee0ab-dac5-28db-cac2-20e188473da6@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> [ Upstream commit ba3684f99f1b25d2a30b6956d02d339d7acb9799 ]

> > Should it use something like 5000*udelay(100), instead, as that has
> > chance to result in closer-to-500msec wait?
>=20
> the half a second timeout didnt mean to be accurate but a worst case
> scenario...I am not sure accuracy matters.

Well, I'd be afraid that it would wait 5 seconds, not half a
second. udelay(1) may be very inaccurate.

> >>  	while (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY)) {
> >>  		if (msm_read(port, UART_ISR) & UART_ISR_TX_READY)
> >>  			break;
> >>  		udelay(1);
> >> +		if (!timeout--)
> >> +			break;
> >>  	}
> >>  	msm_write(port, UART_CR_CMD_RESET_TX_READY, UART_CR);
> >>  }
> >=20
> > Plus, should it do some kind of dev_err() to let users know that
> > something went very wrong with their serial?
>=20
> I did consider this but then I thought that 1/2 second without
> interrupts on the core should not go unnoticed. But I might be wrong.

Well, maybe it will be noticed, but user will have no idea what caused
it.

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1VBLsACgkQMOfwapXb+vJ/JACeLdowu6zpV4u3EcD06Nal+ndM
VtUAn1YYozTjmj0qVSW+pNe3KSrsOK3X
=Nl4A
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
