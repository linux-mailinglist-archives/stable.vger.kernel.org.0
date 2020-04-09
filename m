Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686F61A3543
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 15:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgDIN7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 09:59:01 -0400
Received: from sauhun.de ([88.99.104.3]:59294 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgDIN7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 09:59:01 -0400
Received: from localhost (p54B33209.dip0.t-ipconnect.de [84.179.50.9])
        by pokefinder.org (Postfix) with ESMTPSA id CD0952C1FDE;
        Thu,  9 Apr 2020 15:58:58 +0200 (CEST)
Date:   Thu, 9 Apr 2020 15:58:58 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND
 flag on BYT and CHT
Message-ID: <20200409135858.GE1136@ninjato>
References: <20200407181116.61066-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <20200407181116.61066-1-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 07, 2020 at 08:11:16PM +0200, Hans de Goede wrote:
> We already set DPM_FLAG_SMART_PREPARE, so we completely skip all
> callbacks (other then prepare) where possible, quoting from
> dw_i2c_plat_prepare():
>=20
>         /*
>          * If the ACPI companion device object is present for this device=
, it
>          * may be accessed during suspend and resume of other devices via=
 I2C
>          * operation regions, so tell the PM core and middle layers to av=
oid
>          * skipping system suspend/resume callbacks for it in that case.
>          */
>         return !has_acpi_companion(dev);
>=20
> Also setting the DPM_FLAG_SMART_SUSPEND will cause acpi_subsys_suspend()
> to leave the controller runtime-suspended even if dw_i2c_plat_prepare()
> returned 0.
>=20
> Leaving the controller runtime-suspended normally, when the I2C controller
> is suspended during the suspend_late phase, is not an issue because
> the pm_runtime_get_sync() done by i2c_dw_xfer() will (runtime-)resume it.
>=20
> But for dw I2C controllers on Bay- and Cherry-Trail devices acpi_lpss.c
> leaves the controller alive until the suspend_noirq phase, because it may
> be used by the _PS3 ACPI methods of PCI devices and PCI devices are left
> powered on until the suspend_noirq phase.
>=20
> Between the suspend_late and resume_early phases runtime-pm is disabled.
> So for any ACPI I2C OPRegion accesses done after the suspend_late phase,
> the pm_runtime_get_sync() done by i2c_dw_xfer() is a no-op and the
> controller is left runtime-suspended.
>=20
> i2c_dw_xfer() has a check to catch this condition (rather then waiting
> for the I2C transfer to timeout because the controller is suspended).
> acpi_subsys_suspend() leaving the controller runtime-suspended in
> combination with an ACPI I2C OPRegion access done after the suspend_late
> phase triggers this check, leading to the following error being logged
> on a Bay Trail based Lenovo Thinkpad 8 tablet:
>=20
> [   93.275882] i2c_designware 80860F41:00: Transfer while suspended
> [   93.275993] WARNING: CPU: 0 PID: 412 at drivers/i2c/busses/i2c-designw=
are-master.c:429 i2c_dw_xfer+0x239/0x280
> ...
> [   93.276252] Workqueue: kacpi_notify acpi_os_execute_deferred
> [   93.276267] RIP: 0010:i2c_dw_xfer+0x239/0x280
> ...
> [   93.276340] Call Trace:
> [   93.276366]  __i2c_transfer+0x121/0x520
> [   93.276379]  i2c_transfer+0x4c/0x100
> [   93.276392]  i2c_acpi_space_handler+0x219/0x510
> [   93.276408]  ? up+0x40/0x60
> [   93.276419]  ? i2c_acpi_notify+0x130/0x130
> [   93.276433]  acpi_ev_address_space_dispatch+0x1e1/0x252
> ...
>=20
> So since on BYT and CHT platforms we want ACPI I2c OPRegion accesses
> to work until the suspend_noirq phase, we need the controller to be
> runtime-resumed during the suspend phase if it is runtime-suspended
> suspended at that time. This means that we must not set the
> DPM_FLAG_SMART_SUSPEND on these platforms.
>=20
> On BYT and CHT we already have a special ACCESS_NO_IRQ_SUSPEND flag
> to make sure the controller stays functional until the suspend_noirq
> phase. This commit makes the driver not set the DPM_FLAG_SMART_SUSPEND
> flag when that flag is set.
>=20
> Cc: stable@vger.kernel.org
> Fixes: b30f2f65568f ("i2c: designware: Set IRQF_NO_SUSPEND flag for all B=
YT and CHT controllers")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Applied to for-current, thanks!


--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6PKiIACgkQFA3kzBSg
KbbBkw//e2KN5CvLP6AZzV4CffpueQ3raRdlim5bFriBY+osRRGDTSwZMbOl+ABU
6S/o2FkLhWf7Flezra3bVrPAEOh8i33cKLyDKHjZV87MBJAIUENB1h5qO88EznEk
wPj7Oldy6v33ibUkOjF0ShJPh8GeunaqkjCVHLV57wB9Efe5UQ4EhArLfUzg96C9
9qKYOUmYyjJu50YvhGNo00UDyLDAsvIygCW9DdnsTl6xVbNQDQ4YzkCWo3794UVa
TsWk5/PLiyztcCsHq0b92lBkALVnaaCNV9QKk9dQ5IA8XabPu+F16RO4G8WjRy8r
77mz/MJRjOc+sQnhHewM7PCA14pf49OjFycLZeunmc7LhMJnWsDaD5RW79BvBcU5
h/Ikgo/a3Uv79uc0uQuYPfnscMIheK4vRK2kGJ82/3TTUy/LErS5ntnCJpBrje9J
wSFhtLWSxeoi1CxzmPEubOyuM1XDd9T0kWicwj6n0aBxRVCqG5EY8gmWpSC5Vz7N
8azTJroHp36dlQiBN0txHMLQw6bOmZ0RjmD/NP1G6SakbrOGDk0db+t6HItLnigt
WEWzp+QJdIYoPc96UPOC3sppP70o0VWdlLfkoZYzBjk+0ndlRtN21LrV0ol2EUGQ
i1pSechX2rtIlu/AirZiDLSE4+wV0EJeCTsIaalOLkpPUA3Kpg4=
=Irkd
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
