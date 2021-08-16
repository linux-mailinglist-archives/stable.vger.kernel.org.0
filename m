Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C03ED2E0
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbhHPLIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 07:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhHPLIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 07:08:45 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486EEC061764;
        Mon, 16 Aug 2021 04:08:14 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id BB8571F42B20
Received: by earth.universe (Postfix, from userid 1000)
        id 340193C0C9B; Mon, 16 Aug 2021 13:08:10 +0200 (CEST)
Date:   Mon, 16 Aug 2021 13:08:10 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] power: supply: max17042: handle fails of reading
 status register
Message-ID: <20210816110810.sw2jkt2dqlo3iedr@earth.universe>
References: <20210816082716.21193-1-krzysztof.kozlowski@canonical.com>
 <820c80fa-c412-dd71-62a4-0ba1e1a97820@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6vwwvktmiv53b3xj"
Content-Disposition: inline
In-Reply-To: <820c80fa-c412-dd71-62a4-0ba1e1a97820@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6vwwvktmiv53b3xj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 16, 2021 at 10:42:01AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 8/16/21 10:27 AM, Krzysztof Kozlowski wrote:
> > Reading status register can fail in the interrupt handler.  In such
> > case, the regmap_read() will not store anything useful under passed
> > 'val' variable and random stack value will be used to determine type of
> > interrupt.
> >=20
> > Handle the regmap_read() failure to avoid handling interrupt type and
> > triggering changed power supply event based on random stack value.
> >=20
> > Fixes: 39e7213edc4f ("max17042_battery: Support regmap to access device=
's registers")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>=20
> Thanks, the entire series looks good to me:
>=20
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>=20
> For the series.

Thanks, series queued.

-- Sebastian

>=20
> Regards,
>=20
> Hans
>=20
> > ---
> >  drivers/power/supply/max17042_battery.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/su=
pply/max17042_battery.c
> > index ce2041b30a06..858ae97600d4 100644
> > --- a/drivers/power/supply/max17042_battery.c
> > +++ b/drivers/power/supply/max17042_battery.c
> > @@ -869,8 +869,12 @@ static irqreturn_t max17042_thread_handler(int id,=
 void *dev)
> >  {
> >  	struct max17042_chip *chip =3D dev;
> >  	u32 val;
> > +	int ret;
> > +
> > +	ret =3D regmap_read(chip->regmap, MAX17042_STATUS, &val);
> > +	if (ret)
> > +		return IRQ_HANDLED;
> > =20
> > -	regmap_read(chip->regmap, MAX17042_STATUS, &val);
> >  	if ((val & STATUS_INTR_SOCMIN_BIT) ||
> >  		(val & STATUS_INTR_SOCMAX_BIT)) {
> >  		dev_info(&chip->client->dev, "SOC threshold INTR\n");
> >=20
>=20

--6vwwvktmiv53b3xj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmEaRxMACgkQ2O7X88g7
+poBKhAAk5pmj5Djl2zZVinaNrMQkERWS5zRujTOO105iG1WIdst9L1KbJUwVng7
12lgHIeeQi+GeaW69Ytd7Rm7WhTZp/kE1R2qyfNOQKMs1x9eRZAcgK7slhspUPCb
e/YNN41n3h90ulV34Zn87Ta4sTPoCUkz89XUs45qE00oK03y6ySXJnwT919BXSsr
9Ix1bVDcWTz98limS+rB3YsSDUL5r9LJ1wuu8azTemdvGIXDppZ2QYiUzbOlrO1R
JrLa/O3q/OgpWJUi2iu1gaXvOU9WR4V/slgUG9FOgpgfFN+bSgqtYe6NX+Yk2zDu
E2XbPxSbH83ktRmw9TAC0DJYpkOgcA9g8Xl+4oc1YcPDUDqMVMqP/gZ0L5waxlK6
ukA8dLox/+cGScT7ajDFh4g409XfQ4YHFukNTe+DRt04ovX1R13SIHhS59BkSzjT
MFYgfesyJdYoLX6aDdQFl/KUg/G3/dJ8YxTsyOYW00ErDPu141HgEkKNTEmt2HoV
85qN8RuoPCIv92lieAOJenjsQXmYHD3p/hRTBdLlqsraoqdWQXK2yYNdJB9RL4Vj
5VM692MuWbsPoQ5MyMt/1+6xkCBoHKdHgHjghsViwvyWA28OnFBPCKidxCc26QK2
sQa0+8+32ke4ITG50k5Uj506PGkpRehovfMCQ6vPQxJlQYtTx6s=
=qDkR
-----END PGP SIGNATURE-----

--6vwwvktmiv53b3xj--
