Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091B425A95B
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 12:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIBKZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 06:25:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47058 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBKZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 06:25:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4090B1C0B7F; Wed,  2 Sep 2020 12:25:23 +0200 (CEST)
Date:   Wed, 2 Sep 2020 12:25:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 053/125] media: gpio-ir-tx: improve precision of
 transmitted signal due to scheduling
Message-ID: <20200902102521.GC3765@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150937.150292200@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <20200901150937.150292200@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> [ Upstream commit ea8912b788f8144e7d32ee61e5ccba45424bef83 ]
>=20
> usleep_range() may take longer than the max argument due to scheduling,
> especially under load. This is causing random errors in the transmitted
> IR. Remove the usleep_range() in favour of busy-looping with udelay().
>=20
> Signed-off-by: Sean Young <sean@mess.org>

I don't believe this should be in stable.

Yes, it probably fixes someone's remote control.

It also introduces > half a second (!) with interrupts disabled
(according to the code comments), which will break other devices on
the system.

Less intrusive solutions should be explored, first. Like.. if that
part is time-critical, perhaps it should set itself at realtime
priority, so that scheduler has motivation to schedule it at the right
times?

Perhaps usleep_range should be delta, delta+1?

Perhaps udelay makes sense to use for more than 10usec?

Best regards,
										Pavel

> @@ -87,13 +87,8 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int=
 *txbuf,
>  			// space
>  			edge =3D ktime_add_us(edge, txbuf[i]);
>  			delta =3D ktime_us_delta(edge, ktime_get());
> -			if (delta > 10) {
> -				spin_unlock_irqrestore(&gpio_ir->lock, flags);
> -				usleep_range(delta, delta + 10);
> -				spin_lock_irqsave(&gpio_ir->lock, flags);
> -			} else if (delta > 0) {
> +			if (delta > 0)
>  				udelay(delta);
> -			}
>  		} else {
>  			// pulse
>  			ktime_t last =3D ktime_add_us(edge, txbuf[i]);
> --=20
> 2.25.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX09zEQAKCRAw5/Bqldv6
8gtmAJ4whLb6KgxDaQ4G9FMHnFplfwvEUwCgo8yL6i1TXMs6lZakoDrMzLqk9mI=
=/W/6
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
