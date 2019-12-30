Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2312CEA7
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 11:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfL3KOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 05:14:23 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57904 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfL3KOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 05:14:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0F6051C2604; Mon, 30 Dec 2019 11:14:21 +0100 (CET)
Date:   Mon, 30 Dec 2019 11:14:20 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Merlijn Wajer <merlijn@wizzup.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 162/434] power: supply: cpcap-battery: Check voltage
 before orderly_poweroff
Message-ID: <20191230101420.GA11922@amd>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172712.537510975@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20191229172712.537510975@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-29 18:23:35, Greg Kroah-Hartman wrote:
> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit 639c1524da3b273d20c42ff2387d08eb4b12e903 ]
>=20
> We can get the low voltage interrupt trigger sometimes way too early,
> maybe because of CPU load spikes. This causes orderly_poweroff() be
> called too easily.
>=20
> Let's check the voltage before orderly_poweroff in case it was not
> yet a permanent condition. We will be getting more interrupts anyways
> if the condition persists.
>=20
> Let's also show the measured voltages for low battery and battery
> empty warnings since we have them.

I don't believe this is good idea for stable.

Yes, it may be useful on older batteries, but may cause too late
shutdowns on new batteries, or something like that. Certainly needs a
lot more testing than it got.

Best regards,
							Pavel

> Cc: Merlijn Wajer <merlijn@wizzup.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/power/supply/cpcap-battery.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/=
cpcap-battery.c
> index 61d6447d1966..00a96e4a1cdc 100644
> --- a/drivers/power/supply/cpcap-battery.c
> +++ b/drivers/power/supply/cpcap-battery.c
> @@ -562,12 +562,14 @@ static irqreturn_t cpcap_battery_irq_thread(int irq=
, void *data)
>  	switch (d->action) {
>  	case CPCAP_BATTERY_IRQ_ACTION_BATTERY_LOW:
>  		if (latest->current_ua >=3D 0)
> -			dev_warn(ddata->dev, "Battery low at 3.3V!\n");
> +			dev_warn(ddata->dev, "Battery low at %imV!\n",
> +				latest->voltage / 1000);
>  		break;
>  	case CPCAP_BATTERY_IRQ_ACTION_POWEROFF:
> -		if (latest->current_ua >=3D 0) {
> +		if (latest->current_ua >=3D 0 && latest->voltage <=3D 3200000) {
>  			dev_emerg(ddata->dev,
> -				  "Battery empty at 3.1V, powering off\n");
> +				  "Battery empty at %imV, powering off\n",
> +				  latest->voltage / 1000);
>  			orderly_poweroff(true);
>  		}
>  		break;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4JzfwACgkQMOfwapXb+vL56ACeLmgSqGAZlFg6JQS4nsWN1zLk
PF8An1U/nOXr0XWkU1Ldtf54vlvlrl5z
=PN0n
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
