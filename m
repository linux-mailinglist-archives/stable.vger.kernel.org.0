Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBF52019D2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbgFSRzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 13:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbgFSRzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 13:55:24 -0400
Received: from earth.universe (dyndsl-037-138-190-043.ewe-ip-backbone.de [37.138.190.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB782053B;
        Fri, 19 Jun 2020 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592589323;
        bh=IyFmyA/Yk2YkDZNGlb+HjNAe4pqU3k0vVzuoupw5GDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o0plxateUPBswEeUrt8Rh8w0mJqodkcKNVTr2I8goEfkkqrZ5AIp2NhdtAKol+VcC
         1fNEcbegvYafaWZFDlIXfEml1Ik2q9vrzCFV9qqeSgqe3g8xS293hzA0x9SMTZ5NTf
         AkjmB8B7TVXHIyhSWASxniOtv/D4yTeHJmDclWB0=
Received: by earth.universe (Postfix, from userid 1000)
        id 9AAC93C08CD; Fri, 19 Jun 2020 19:55:21 +0200 (CEST)
Date:   Fri, 19 Jun 2020 19:55:21 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     "Andrew F. Davis" <afd@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
Message-ID: <20200619175521.xrcd7ahvjtc4zoqi@earth.universe>
References: <20200525113220.369-1-krzk@kernel.org>
 <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
 <20200527074254.vhyfntpolphj3eeq@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bptvdc4ovioh7sxm"
Content-Disposition: inline
In-Reply-To: <20200527074254.vhyfntpolphj3eeq@pali>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bptvdc4ovioh7sxm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 27, 2020 at 09:42:54AM +0200, Pali Roh=E1r wrote:
> On Tuesday 26 May 2020 21:16:28 Andrew F. Davis wrote:
> > On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> > > This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> > >=20
> > > If device was unbound and bound, the polling interval would be set to=
 0.
> > > This is both unexpected and messes up with other bq27xxx devices (if
> > > more than one battery device is used).
> > >=20
> > > This reset of polling interval was added in commit 8cfaaa811894
> > > ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> > > stating that power_supply_unregister() calls get_property().  However=
 in
> > > Linux kernel v3.1 and newer, such call trace does not exist.
> > > Unregistering power supply does not call get_property() on unregister=
ed
> > > power supply.
> > >=20
> > > Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistrin=
g bq27x00 driver")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > >=20
> > > ---
> > >=20
> > > I really could not identify the issue being fixed in offending commit
> > > 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x=
00
> > > driver"), therefore maybe I missed here something important.
> > >=20
> > > Please share your thoughts on this.
> >=20
> > I'm having a hard time finding the OOPS also. Maybe there is a window
> > where the poll function is running or about to run where
> > cancel_delayed_work_sync() is called and cancels the work, only to have
> > an interrupt or late get_property call in to the poll function and
> > re-schedule it.
> >=20
> > What we really need is to do is look at how we are handling the polling
> > function. It gets called from the workqueue, from a threaded interrupt
> > context, and from a power supply framework callback, possibly all at the
> > same time. Sometimes its protected by a lock, sometimes not. Updating
> > the device's cached data should always be locked.
> >=20
> > What's more is the poll function is self-arming, so if we call
> > cancel_delayed_work_sync() (remove it from the work queue then then wait
> > for it to finish if running), are we sure it wont have just re-arm itse=
lf?
> >=20
> > We should make the only way we call the poll function be through the
> > work queue, (plus make sure all accesses to the cache are locked).
> >=20
> > Andrew
>=20
> I do not remember details too. It is long time ago.
>=20
> CCing Ivaylo Dimitrov as he may remember something...

Applying this revert introduces at least a race condition when
userspace reads sysfs files while kernel removes the driver.

So looking at the entrypoints for schedules:

bq27xxx_battery_i2c_probe:
  Not relevant, probe is done when the battery is being removed.

poll_interval_param_set:
  Can be avoided by unregistering from the list earlier. This
  is the right thing to do considering the battery is added to
  the list as last step in the probe routine, it should be removed
  first during teardown.

bq27xxx_external_power_changed:
  This can happen at any time while the power-supply device is
  registered, because of the code in get_property.

bq27xxx_battery_poll:
  This can happen at any time while the power-supply device is
  registered.

As far as I can see the only thing in the delayed work needing
the power-supply device is power_supply_changed(). If we add a
check, that di->bat is not NULL, we should be able to reorder
teardown like this:

1. remove from list
2. unregister power-supply device and set to di->bat to NULL
3. cancel delayed work
4. destroy mutex

Also I agree with Andrew, that the locking looks fishy. I think
the lock needs to be moved, so that the call to
bq27xx_battery_update(di) in bq27xxx_battery_poll is protected.

-- Sebastian

> > > ---
> > >  drivers/power/supply/bq27xxx_battery.c | 8 --------
> > >  1 file changed, 8 deletions(-)
> > >=20
> > > diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/s=
upply/bq27xxx_battery.c
> > > index 942c92127b6d..4c94ee72de95 100644
> > > --- a/drivers/power/supply/bq27xxx_battery.c
> > > +++ b/drivers/power/supply/bq27xxx_battery.c
> > > @@ -1905,14 +1905,6 @@ EXPORT_SYMBOL_GPL(bq27xxx_battery_setup);
> > > =20
> > >  void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
> > >  {
> > > -	/*
> > > -	 * power_supply_unregister call bq27xxx_battery_get_property which
> > > -	 * call bq27xxx_battery_poll.
> > > -	 * Make sure that bq27xxx_battery_poll will not call
> > > -	 * schedule_delayed_work again after unregister (which cause OOPS).
> > > -	 */
> > > -	poll_interval =3D 0;
> > > -
> > >  	cancel_delayed_work_sync(&di->work);
> > > =20
> > >  	power_supply_unregister(di->bat);
> > >=20

--bptvdc4ovioh7sxm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl7s+/0ACgkQ2O7X88g7
+ppQzA//SWcqaQntFbKQv8z/4GHcuJ7qIX8cTG/v3v9yVDhtNkxg1404eAoDt9yh
lWXfmm/1ANPfl6BaiFoaWqV5S7+ZbCYh8VXoAq3EFWBpiof7GpoQ5zJjKOR1f6Nj
S2RcywA1tN9pofeWrkH7K+hy7NYcnpOuew5etZ2MqZ6cCvq79A6+iQP2Wu9hCKt8
A4vEvIMi29Q9mmG3LOsImPjAWCWKyvrKI5WefnYMUcX8BHSuxiB5vk+jvbzHZarr
ZsBMspMbcEUq2N8M80Idrltp0ugo3QsZNE9GKVQ0wJnIE3O1eI24w6RBKlJ0Nf+T
D8vVdmFM8h/4CQeWPESxi1gNkRlAX3iYAEg9+nOhPR2DU6PeaQT0ZrVthlY1Z9qt
XyYXVusja+pVkBCBrD43bIYgD5I0dUaY2ud0try+eGD5IlTr2SdKa5Hc0yEOFYCk
yqBsKq1THlkhtfFP/PXz+9/dhLvd6QShca5WWB+kSWK/MX8dNhL+kcFhfcDjp5x0
NpQ9fpYtZTTyxj0WuGbg9VVVysz7bYtvrXBOt1Ls4159UzBuRFQjfAJywaa78qd6
GfzsG8s7mtbKgLpLNSk1qWWidMIUHTVipZffdDFpmAxsmX5MajHAaWpSqqMju8C0
j//ACKzlaeUiWjHwLtD5xDJeasmC3Fjet3e09pc0x1geqLkUD1M=
=aSj0
-----END PGP SIGNATURE-----

--bptvdc4ovioh7sxm--
