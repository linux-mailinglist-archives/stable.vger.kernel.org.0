Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2F81F5734
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgFJPB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 11:01:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42794 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgFJPB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 11:01:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 45AC81C0C0A; Wed, 10 Jun 2020 17:01:25 +0200 (CEST)
Date:   Wed, 10 Jun 2020 17:01:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        fengsheng <fengsheng5@huawei.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 15/28] spi: dw: use "smp_mb()" to avoid sending spi
 data error
Message-ID: <20200610150124.GA19775@amd>
References: <20200605140252.338635395@linuxfoundation.org>
 <20200605140253.279609547@linuxfoundation.org>
 <20200607200910.GA13138@amd>
 <20200608111619.GB4593@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20200608111619.GB4593@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-06-08 12:16:19, Mark Brown wrote:
> On Sun, Jun 07, 2020 at 10:09:11PM +0200, Pavel Machek wrote:
>=20
> > > Because of out-of-order execution about some CPU architecture,
> > > In this debug stage we find Completing spi interrupt enable ->
> > > prodrucing TXEI interrupt -> running "interrupt_transfer" function
> > > will prior to set "dw->rx and dws->rx_end" data, so this patch add
> > > memory barrier to enable dw->rx and dw->rx_end to be visible and
> > > solve to send SPI data error.
>=20
> > So, this is apparently CPU-vs-device issue...
>=20
> The commit message is a bit unclear but my read had been interrupt
> handler racing with sending new data rather than an ordering issue with
> writes to the hardware. =20

Aha, patch makes sense, then. Thanks for explanation!
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7g9cQACgkQMOfwapXb+vIkWwCfbC8j4ZPVgsy51QEIqbEOwPKC
D9EAnieBrQvggr96Nsofzj8jmC/ie/Ig
=LnUF
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
