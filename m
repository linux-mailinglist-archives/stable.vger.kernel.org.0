Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7B409C53
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhIMSeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:34:50 -0400
Received: from comms.puri.sm ([159.203.221.185]:56034 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236549AbhIMSet (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 14:34:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 95AF4DFA1F;
        Mon, 13 Sep 2021 11:33:01 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id chX-iOGg-ZNZ; Mon, 13 Sep 2021 11:33:00 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        stable@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH 1/2] power: supply: max17042_battery: Clear status bits in interrupt handler
Date:   Mon, 13 Sep 2021 20:32:52 +0200
Message-ID: <5702731.UytLkSCjyO@pliszka>
In-Reply-To: <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm> <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>
Content-Type: multipart/signed; boundary="nextPart89881716.T3fe8mzVK5"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart89881716.T3fe8mzVK5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <anton.vorontsov@linaro.org>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, Dirk Brandewie <dirk.brandewie@gmail.com>, stable@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH 1/2] power: supply: max17042_battery: Clear status bits in interrupt handler
Date: Mon, 13 Sep 2021 20:32:52 +0200
Message-ID: <5702731.UytLkSCjyO@pliszka>
In-Reply-To: <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>
References: <20210912205402.160939-1-sebastian.krzyszkowiak@puri.sm> <0123524d-b767-5b5b-8b14-60d8cea3c429@canonical.com>

On poniedzia=C5=82ek, 13 wrze=C5=9Bnia 2021 15:02:34 CEST Krzysztof Kozlows=
ki wrote:
> On 12/09/2021 22:54, Sebastian Krzyszkowiak wrote:
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
> >=20
> >  drivers/power/supply/max17042_battery.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/power/supply/max17042_battery.c
> > b/drivers/power/supply/max17042_battery.c index
> > 8dffae76b6a3..c53980c8432a 100644
> > --- a/drivers/power/supply/max17042_battery.c
> > +++ b/drivers/power/supply/max17042_battery.c
> > @@ -876,6 +876,9 @@ static irqreturn_t max17042_thread_handler(int id,
> > void *dev)>=20
> >  		max17042_set_soc_threshold(chip, 1);
> >  =09
> >  	}
> >=20
> > +	regmap_clear_bits(chip->regmap, MAX17042_STATUS,
> > +			  0xFFFF & ~(STATUS_POR_BIT |=20
STATUS_BST_BIT));
> > +
>=20
> Are you sure that this was the reason of interrupt storm? Not incorrect
> SoC value (read from register for ModelGauge m3 while not configuring
> fuel gauge model).

Yes, I am sure. I have observed this on a fully configured max17055 with=20
ModelGauge m5. It also makes sense to me based on what I read in the code a=
nd=20
datasheets.

There were two kinds of storms - the short ones happening on each SOC chang=
e=20
caused by SOC threshold alerts set by max17042_set_soc_threshold which=20
eventually got cleared by reconfiguring the thresholds; and a huge one=20
happening when SOC got down to 0% that did not get away until the battery g=
ot=20
charged to at least 1% at which point the thresholds got reconfigured again=
=20
(which is how I noticed the underflow fixed by the second patch).

Besides, I also have patches for configuring m5 gauge via DT that I'll send=
=20
once I clean them up.

> You should only clear bits which you are awaken for... Have in mind that
> in DT-configuration the fuel gauge is most likely broken by missing
> configuration. With alert enabled, several other config fields should be
> cleared.

I have checked all the bits in the Status register and aside of Bst, POR an=
d=20
bunch of "don't-care" bits they're all alert indicators that we either hand=
le=20
explicitly in the interrupt handler (Smn/Smx) or implicitly via=20
power_supply_changed (Imn/Imx, Vmn/Vmx, Tmn/Tmx, dSOCi, Bi/Br). The driver=
=20
unconditionally enables alerts for SOC thresholds and all the rest stays=20
effectively disabled at POR; however, a bootloader or firmware may configur=
e it=20
differently, which may be wanted for things like resuming from suspend when=
 a=20
bad condition happens. Therefore we need to clear all the bits anyway and I=
'm=20
not sure whether iterating through them in a "if set then clear" loop gains=
 us=20
anything aside of additional lines of code.

> Best regards,
> Krzysztof

Cheers,
Sebastian
--nextPart89881716.T3fe8mzVK5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEIt2frgBqEUNYNmF86PI1zzvbw/8FAmE/mVQACgkQ6PI1zzvb
w/+Grw//R2Lf0O3clBJBYHfOdbwZS/SSetxXxps9CzCOu6GZ9NYUvaBe9TwPUrJP
lXhAjPG9pCUyRMWIIAX72KdjLS5I8YHm7JxeqGyNJjr9vrdoT7GEirTIJN7AoyZN
kAepbOND3DE6DpzX/McQq8vNsvtJc5lco3oMr8KEzYrKaP+HBe7tN5ZnJ3IJ4Vcy
5XyYdDglP1wZceiKe8Qb1PwEn/xhYDMbgCyHGQzYcB7gEP8E6OgkOV1jk4bJk2fa
XivbylCTqljKAmALJ1DBv1mwJ8XO5WqJLmwphRXSc4hxgiodyx3K94cxHnYcg3Al
ycazR5wF2gT0BKuTH44Uz4ZdxoLgi6uSZqoy/LQ7XhdboJr2+FRRlyakO3d1DYqT
1VIkECYeyWZtJOudhr+m2yIxTZRd3EUmYMV+l1AKoQk0ZJrMMxTnbYjI0h+CYYvL
WLcuM9lcoWgNANkFVA4N9EK8edKxHeHtVAfoL/++6VMfmqdOyEZG0K6MwpOQt/U7
R8ECgYfwIodTTLD/P3gbet8TJwvu19E/ldls23CRpbWi9XOu9rzMztCMwUc6LWx4
Cnu0XJNso3J5pG3RHl6Nwgu9bgHpTbM10lz/pokOYfroDdO7mv6KmwN/OWnFrBxE
s7HjT1N//3tiBWdwP68y4P3aPfSEXK4zTN0xCxgYZqIEvs+rbDg=
=W1i9
-----END PGP SIGNATURE-----

--nextPart89881716.T3fe8mzVK5--



