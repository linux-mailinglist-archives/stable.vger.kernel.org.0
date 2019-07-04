Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1175F7AB
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 14:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfGDMH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 08:07:59 -0400
Received: from sauhun.de ([88.99.104.3]:36230 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfGDMH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 08:07:59 -0400
Received: from localhost (p2E56AA43.dip0.t-ipconnect.de [46.86.170.67])
        by pokefinder.org (Postfix) with ESMTPSA id C8ED32C290E;
        Thu,  4 Jul 2019 14:07:56 +0200 (CEST)
Date:   Thu, 4 Jul 2019 14:07:56 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
Message-ID: <20190704120756.GA1582@kunai>
References: <20190704113800.3299636-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20190704113800.3299636-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 04, 2019 at 01:37:47PM +0200, Arnd Bergmann wrote:
> gcc-9 complains about a blatant uninitialized variable use that
> all earlier compiler versions missed:
>=20
> drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
>=20
> Return -EINVAL instead here.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This is correct but missing that the above 'return ret' is broken, too.
ret is initialized but 0 in that case.

And maybe we can use something else than -EINVAL for this case? I am on
the go right now, I will look for a suggestion later.


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl0d7BgACgkQFA3kzBSg
KbY6MA/+MZnJI+HpdsYYnacUJPbBKtq73+/XNntSU3b6UPF1W0sqz6J4Dq0oWfJt
XCvyZIvynLXmakJvKtOo6DVmfw4UUkouolEknvrmC68Ng+G1ONH5ktqPR7zr0gAF
P2/Lz8lCjI4cnYt4A7Km3s52DzJSyG33H7IsdEgw6nunrOw1WlB8jyy+vTOGofW+
soPn6WfInVRq/2YTAbthPYPZEn45k2F/T1I6psP6+59Zp3gW8Dtk/FCisvukxOa1
2+X945XtosWVF5hfjgXzH/s9VyrjMVXAVDDc97lIUbnasCgmLMVEEVHf9wQFY6B9
CVNVWd99XRordyDACvCSSdbjLmajDfBDKk2D1atOEqMeVfW2dcBa3SrXQGJodBgj
M+6A2W3L4WvwllX9w4vZZaGVlaSmSUYbM5Cd1x5tzbUGhxIzvT0Q91gNT/Gy3YND
PqFUfQwh8gHnMIouYEHezAQJvjOqsCs4ie6mg587k3bJAcD8u+YJ7/Ah/Kvdevb2
JuuzHLJx+V5qwEOkoyvxzOwpyg6kHBmBUAkCtPT3BGz4fj+TvNDL1Q7U7l9JdQhB
qNgskuZMpZCYbjeCGV3eA4pGHfi8NGeJqbgz6iVG9FTnPfEQXEH3IVmvjqQF3QoW
VZWoK5vF+gpt3ui7FwIW1HZahQD5wjaPyCNrjqgu2TCRvotoJhg=
=WY5/
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
