Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B073C1A608D
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 22:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgDLUqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 16:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgDLUqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 16:46:09 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F5C0A3BF5;
        Sun, 12 Apr 2020 13:46:09 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F00A41C69AF; Sun, 12 Apr 2020 22:46:07 +0200 (CEST)
Date:   Sun, 12 Apr 2020 22:46:07 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: Re: [PATCH 4.19 20/54] power: supply: axp288_charger: Add special
 handling for HP Pavilion x2 10
Message-ID: <20200412204607.GB5796@duo.ucw.cz>
References: <20200411115508.284500414@linuxfoundation.org>
 <20200411115510.523425293@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20200411115510.523425293@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2020-04-11 14:09:02, Greg Kroah-Hartman wrote:
> From: Hans de Goede <hdegoede@redhat.com>
>=20
> commit 9c80662a74cd2a5d1113f5c69d027face963a556 upstream.
>=20
> Some HP Pavilion x2 10 models use an AXP288 for charging and fuel-gauge.
> We use a native power_supply / PMIC driver in this case, because on most
> models with an AXP288 the ACPI AC / Battery code is either completely
> missing or relies on custom / proprietary ACPI OpRegions which Linux
> does not implement.
>=20
> The native drivers mostly work fine, but there are 2 problems:
>=20
> 1. These model uses a Type-C connector for charging which the AXP288 does
> not support. As long as a Type-A charger (which uses the USB data pins for
> charger type detection) is used everything is fine. But if a Type-C
> charger is used (such as the charger shipped with the device) then the
> charger is not recognized.
>=20
> So we end up slowly discharging the device even though a charger is
> connected, because we are limiting the current from the charger to 500mA.
> To make things worse this happens with the device's official charger.
>=20
> Looking at the ACPI tables HP has "solved" the problem of the AXP288 not
> being able to recognize Type-C chargers by simply always programming the
> input-current-limit at 3000mA and relying on a Vhold setting of 4.7V
> (normally 4.4V) to limit the current intake if the charger cannot handle
> this.

Hmm.. Drawing 3A from port designed for .5A... is not that a bit
dangerous? It is certainly against the specs.

I believe it will work okay 90% of time, but maybe something overheats
or some fuse trips in the remaining cases. I believe I've seen fuse
triping on USB port of my home router..

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXpN+DwAKCRAw5/Bqldv6
8u9oAKC5lpXEWnBKfIzTnhMzbY37kb655QCfZUmwKkcsmbxbM9/YySEQ1ANbaIw=
=IJfG
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
