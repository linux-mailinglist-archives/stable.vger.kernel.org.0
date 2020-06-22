Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB091203727
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 14:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgFVMry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 08:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgFVMry (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 08:47:54 -0400
Received: from earth.universe (dyndsl-095-033-171-070.ewe-ip-backbone.de [95.33.171.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E7CE20732;
        Mon, 22 Jun 2020 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592830073;
        bh=9Re5akuR6NIoireyv+6Ht4gLVRTm4t0PACrNuuNfhtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V9D0zURrJlhwPBPo3XyWM/9eJigrZUUlupjY9HgUM5mI6KiVge9wFLkm7HOiDA9lG
         aqy8jXzzEtPAezHuiwNavEhx+LuYTf1b4wpxRohFHaBFMziMUXfvZYgKg+K44RG5V+
         XqSkc2cAKt7cVy3oB3ld+WrFe14qILl0n7KEizwc=
Received: by earth.universe (Postfix, from userid 1000)
        id EEF373C08CD; Mon, 22 Jun 2020 14:47:50 +0200 (CEST)
Date:   Mon, 22 Jun 2020 14:47:50 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
Message-ID: <20200622124750.fdv2cfvlpdngjrfh@earth.universe>
References: <20200525113220.369-1-krzk@kernel.org>
 <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
 <20200527074254.vhyfntpolphj3eeq@pali>
 <20200619175521.xrcd7ahvjtc4zoqi@earth.universe>
 <20200622082248.GB28886@kozik-lap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bkvzieuydifiq24i"
Content-Disposition: inline
In-Reply-To: <20200622082248.GB28886@kozik-lap>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bkvzieuydifiq24i
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 22, 2020 at 10:22:48AM +0200, Krzysztof Kozlowski wrote:
> On Fri, Jun 19, 2020 at 07:55:21PM +0200, Sebastian Reichel wrote:
> > On Wed, May 27, 2020 at 09:42:54AM +0200, Pali Roh=E1r wrote:
> > > On Tuesday 26 May 2020 21:16:28 Andrew F. Davis wrote:
> > > > On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> > > > > This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> > > > >=20
> > > > > If device was unbound and bound, the polling interval would be se=
t to 0.
> > > > > This is both unexpected and messes up with other bq27xxx devices =
(if
> > > > > more than one battery device is used).
> > > > >=20
> > > > > This reset of polling interval was added in commit 8cfaaa811894
> > > > > ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver=
")
> > > > > stating that power_supply_unregister() calls get_property().  How=
ever in
> > > > > Linux kernel v3.1 and newer, such call trace does not exist.
> > > > > Unregistering power supply does not call get_property() on unregi=
stered
> > > > > power supply.
> > > > >=20
> > > > > Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregis=
tring bq27x00 driver")
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > >=20
> > > > > ---
> > > > >=20
> > > > > I really could not identify the issue being fixed in offending co=
mmit
> > > > > 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring b=
q27x00
> > > > > driver"), therefore maybe I missed here something important.
> > > > >=20
> > > > > Please share your thoughts on this.
> > > >=20
> > > > I'm having a hard time finding the OOPS also. Maybe there is a wind=
ow
> > > > where the poll function is running or about to run where
> > > > cancel_delayed_work_sync() is called and cancels the work, only to =
have
> > > > an interrupt or late get_property call in to the poll function and
> > > > re-schedule it.
> > > >=20
> > > > What we really need is to do is look at how we are handling the pol=
ling
> > > > function. It gets called from the workqueue, from a threaded interr=
upt
> > > > context, and from a power supply framework callback, possibly all a=
t the
> > > > same time. Sometimes its protected by a lock, sometimes not. Updati=
ng
> > > > the device's cached data should always be locked.
> > > >=20
> > > > What's more is the poll function is self-arming, so if we call
> > > > cancel_delayed_work_sync() (remove it from the work queue then then=
 wait
> > > > for it to finish if running), are we sure it wont have just re-arm =
itself?
> > > >=20
> > > > We should make the only way we call the poll function be through the
> > > > work queue, (plus make sure all accesses to the cache are locked).
> > > >=20
> > > > Andrew
> > >=20
> > > I do not remember details too. It is long time ago.
> > >=20
> > > CCing Ivaylo Dimitrov as he may remember something...
> >=20
> > Applying this revert introduces at least a race condition when
> > userspace reads sysfs files while kernel removes the driver.
> >=20
> > So looking at the entrypoints for schedules:
> >=20
> > bq27xxx_battery_i2c_probe:
> >   Not relevant, probe is done when the battery is being removed.
> >=20
> > poll_interval_param_set:
> >   Can be avoided by unregistering from the list earlier. This
> >   is the right thing to do considering the battery is added to
> >   the list as last step in the probe routine, it should be removed
> >   first during teardown.
>=20
> Yes, good point.
>=20
> > bq27xxx_external_power_changed:
> >   This can happen at any time while the power-supply device is
> >   registered, because of the code in get_property.
> >=20
> > bq27xxx_battery_poll:
> >   This can happen at any time while the power-supply device is
> >   registered.
> >=20
> > As far as I can see the only thing in the delayed work needing
> > the power-supply device is power_supply_changed(). If we add a
> > check, that di->bat is not NULL, we should be able to reorder
> > teardown like this:
>=20
> Except power_supply structure there is the device state struct
> bq27xxx_device_info 'di'. If bq27xxx_battery_poll() is called
> during the unbind, it will access the 'di' which is being freed by
> devm-framework. And just checking for di->bat is also not thread
> safe (can be reordered).
>=20
> I think there is no easy few-line fix for this.  Instead, the
> workqueue scheduling should be guarded everywhere by device-instance
> mutex (bq27xxx_device_info.lock).

Freeing of bq27xxx_device_info 'di' is not a problem, since
the managed resource is attached to the i2c device, not the
power-supply device. The I2C device is still available after
step A2 from the list below, only the power-supply device will
be unregistered/free'd. As a result after step A2 external
power change can no longer happen and  get_property can no
longer be called, so no new work can be scheduled (apart from
requeuing). After step A3 work incl. requeuing is stopped
(cancel_delayed_work_sync handles work requeing itself).

The alternative would be to introduce a flag in di, that the
device is about to teardown and avoid rescheduling work from
external_power_changed + get_property when that is set. Then
it would be possible to teardown like this:

B1. get mutex, set teardown flag, release mutex
B2. remove from list
B3. cancel delayed work
B4. unregister power-supply device
B5. destroy mutex

> > A1. remove from list
> > A2. unregister power-supply device and set to di->bat to NULL
> > A3. cancel delayed work
> > A4. destroy mutex
> >=20
> > Also I agree with Andrew, that the locking looks fishy. I think
> > the lock needs to be moved, so that the call to
> > bq27xx_battery_update(di) in bq27xxx_battery_poll is protected.
>=20
> Exactly.
>=20
> Best regards,
> Krzysztof

-- Sebastian

--bkvzieuydifiq24i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl7wqFEACgkQ2O7X88g7
+pqTQA/+MORas3EhJ3vlt25nefVqt4lMc+7lNyThwGaxMS+lG27N4pVLpRkTfWyk
vbEaoFL6U+renxHLOOvQAvN9t74G7FAjobZXJRSiyrqu5MQCW1fizBRdq3dvRmE+
tkl7YLYJulNiIniwJHUiKECWFhfZF0E3GTodhtrJlHgySWeD/VcImCXa4gIYVPSD
hP5pKhgcebfva0uyuKHnIhLss+ZwDX90mraa2s6nIjyt8w5WZcqoj8QRZQvFj3Vb
oN+qwl/ILaSDB5jj9ruuoiICRhEJOYZG3g2FcFgwjr2+Gf137co4jE8QNK16nfyz
i9hZA0e/EHuVf59nYqWEul4e0k+NcjSGF6vhh2/i7vx0PnCARALC2/PzHBZ6prbl
2VcIdABMzipqG76b5td8eXs6jVHB/F3GmKrJ6iVXGL08KyYO6JTbCx8prGet2OrL
iHN4zGIc+14wuCgANFevImtlaGmFAa7lp6XZ7RUr4HkIn2US8M7FRD4yh0HJSFEZ
pYCm5ekMtmQknXX065FbqfBzSDIS97WpUxdpvaXwnFEEhyPTiHJpyI6EnJ22SPpp
TM9Iv56jHvYscXyM1BdaNs4gqSSJV46uxRc19GBQvhQnIYD5CbZvVOQis+OVU4xd
6YtpAYZU01MwB7ws5r012qzHQOGojQo9c3+ACpx+5cHFnC2r0Hc=
=NKgl
-----END PGP SIGNATURE-----

--bkvzieuydifiq24i--
