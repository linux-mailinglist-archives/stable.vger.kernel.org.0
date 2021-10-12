Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51B342A904
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 18:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhJLQDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 12:03:40 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55042 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhJLQDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 12:03:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id D1D361F43D5D
Received: by earth.universe (Postfix, from userid 1000)
        id 2A7FC3C0CA8; Tue, 12 Oct 2021 18:01:35 +0200 (CEST)
Date:   Tue, 12 Oct 2021 18:01:35 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, kernel@puri.sm,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] power: supply: max17042_battery: Clear status
 bits in interrupt handler
Message-ID: <20211012160135.ldmhwkpmijkziuob@earth.universe>
References: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
 <11303414.9r73sBlGM0@pliszka>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xvqbm6c6fc54g2fj"
Content-Disposition: inline
In-Reply-To: <11303414.9r73sBlGM0@pliszka>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xvqbm6c6fc54g2fj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 11, 2021 at 05:32:30AM +0200, Sebastian Krzyszkowiak wrote:
> On wtorek, 14 wrze=C5=9Bnia 2021 14:18:05 CEST Sebastian Krzyszkowiak wro=
te:
> > The gauge requires us to clear the status bits manually for some alerts
> > to be properly dismissed. Previously the IRQ was configured to react on=
ly
> > on falling edge, which wasn't technically correct (the ALRT line is act=
ive
> > low), but it had a happy side-effect of preventing interrupt storms
> > on uncleared alerts from happening.
> >=20
> > Fixes: 7fbf6b731bca ("power: supply: max17042: Do not enforce (incorrec=
t)
> > interrupt trigger type") Cc: <stable@vger.kernel.org>
> > Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> > ---
> > v2: added a comment on why it clears all alert bits
> > ---
> >  drivers/power/supply/max17042_battery.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/power/supply/max17042_battery.c
> > b/drivers/power/supply/max17042_battery.c index 8dffae76b6a3..da78ffe6a=
3ec
> > 100644
> > --- a/drivers/power/supply/max17042_battery.c
> > +++ b/drivers/power/supply/max17042_battery.c
> > @@ -876,6 +876,10 @@ static irqreturn_t max17042_thread_handler(int id,=
 void
> > *dev) max17042_set_soc_threshold(chip, 1);
> >  	}
> >=20
> > +	/* we implicitly handle all alerts via power_supply_changed */
> > +	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
> > +			  0xFFFF & ~(STATUS_POR_BIT |=20
> STATUS_BST_BIT));
> > +
> >  	power_supply_changed(chip->battery);
> >  	return IRQ_HANDLED;
> >  }
>=20
> Ping? Seems this didn't get applied yet.

Thanks, both queued now.

-- Sebastian

--xvqbm6c6fc54g2fj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmFlsVoACgkQ2O7X88g7
+pqAdhAAkmAkbekB6xd9dau2QCUIctjPFmP9zA+Zi4l2ZWEaq1pGVmfj2uHyOxkp
R3kmp8oNIp24nW5LQWUYM/57HLKVLitr8wumuEZFGtW8pStex7T5UM/MhExLtwgU
qoNmwX06TpToZQ7PYBPwko0CYtK8cXK2c0WwNe1fQ9ncaPZKBZYXdXggIKDpsg2q
52B8JZ2JbQ0GvQ8ebtEg/DxlrhtEs67TCfZ0Z8bW+vA5xpuKOUf+MIo6sx2VtWk/
P9vUVwMjU/VjsczJ5khI+WP1EEF74x2AAfX3iL82GCNvZQUqHJ9RrrRw2VT5onOl
Sbytk4dYLLfX+8KJFd7PAHMqeWZhnUIgH+u9d2YnVpG1XXhU+lRvpoVfpiD9y1l6
giJ/stBoicQ61iCwDfFN9sp8bRckWIFnTdpGw3AV3nzG4oTn/BaYmNrFMEKK/jwa
/wFAYKegT4YTEDhxV48rwQ6zCJcq7uj8fjGbmoHmIE4/zoqptJhhbZgVDnsnL6N+
Q7vCKL8PHJc8wyj8UmytfTtumRiRY+kYQKPbMA8O4byFeEqGub0GG0g1fNg+Gktv
4BcZgfRSTCluAigfdYmtch1mQGz1eIiIx2qWrSI6YhCljhqXMkU421bSLGqYJgRk
eihtlnivCkmT2dG6TOS8ZWXEtSqdqvx0f1sAEC7K+YACc2qKtpg=
=qE2g
-----END PGP SIGNATURE-----

--xvqbm6c6fc54g2fj--
