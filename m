Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E66947A28
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfFQGn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 02:43:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:10351 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfFQGn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 02:43:26 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 23:43:25 -0700
X-ExtLoop1: 1
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2019 23:43:23 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
In-Reply-To: <20190614145236.GB3849@localhost>
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com> <20190614145236.GB3849@localhost>
Date:   Mon, 17 Jun 2019 09:43:19 +0300
Message-ID: <877e9kiuew.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Johan Hovold <johan@kernel.org> writes:
> On Tue, Jun 11, 2019 at 08:24:16PM +0300, Felipe Balbi wrote:
>> If we happen to have two XHCI controllers with DbC capability, then
>> there's no hope this will ever work as the global pointer will be
>> overwritten by the controller that probes last.
>>=20
>> Avoid this problem by keeping the tty_driver struct pointer inside
>> struct xhci_dbc.
>
> How did you test this patch?

by running it on a machine that actually has two DbCs

>> @@ -279,52 +279,52 @@ static const struct tty_operations dbc_tty_ops =3D=
 {
>>  	.unthrottle		=3D dbc_tty_unthrottle,
>>  };
>>=20=20
>> -static struct tty_driver *dbc_tty_driver;
>> -
>>  int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci)
>>  {
>>  	int			status;
>>  	struct xhci_dbc		*dbc =3D xhci->dbc;
>>=20=20
>> -	dbc_tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
>> +	dbc->tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
>>  					  TTY_DRIVER_DYNAMIC_DEV);
>> -	if (IS_ERR(dbc_tty_driver)) {
>> -		status =3D PTR_ERR(dbc_tty_driver);
>> -		dbc_tty_driver =3D NULL;
>> +	if (IS_ERR(dbc->tty_driver)) {
>> +		status =3D PTR_ERR(dbc->tty_driver);
>> +		dbc->tty_driver =3D NULL;
>>  		return status;
>>  	}
>>=20=20
>> -	dbc_tty_driver->driver_name =3D "dbc_serial";
>> -	dbc_tty_driver->name =3D "ttyDBC";
>> +	dbc->tty_driver->driver_name =3D "dbc_serial";
>> +	dbc->tty_driver->name =3D "ttyDBC";
>
> You're now registering multiple drivers for the same thing (and wasting
> a major number for each) and specifically using the same name, which
> should lead to name clashes when registering the second port.

No warnings were printed while running this, actually. Odd

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl0HNocACgkQzL64meEa
mQZ15w/+PSNuZguE3u8MmOXmYZXL8RbCVfJ7a32qsArdpVQpGvqO1UWlUj//56/B
UFRdlYItN4llIabTGKIhgQ/gK45pJlYCWCBSrMKuMgUW/L6H+KZZ3beFGYEH2yF/
wSTl/GkF7Oqu0bUoQ6GOs+Ek32jsHGk0sEy7SNGO6WeAx0DrZKV/rl/UtRvcd4+6
5fJvx8mAHcjhx0dVXsL0SB9S1rPdWkDit2fkKp3Q+EsvczETJHszpU7Bv4d+3ktG
L6q27vSu3rXGWBgD0vx8qLYwAiTqgtdGILx6A6ugkkF39lRa3/9oxKRkoy2EWoWW
faUO7AxO27IyTuJdectxkzdT/Mz1dDfk0pYZ0PMccJBnSLIxxbULpEQQAGx/JGHW
CZuOfa7VpVGYhN5OAfZkDUcPLt7DL/c0qVRRXUYywHUlTdlbYF8TEWnPYyugiFiD
b6eeDLuc8wf4ARecbHPg3RhJVeK1wIP/r+S97jJTMC2o5Lu8BeCauXEw2S+Sn8ya
Gj7BUBvVe76doJIWQmDia/POek0zns9ZaMpKw9BCS284XnD32jxInazYxU7vUBjd
WvMH51zxD3K6FC1BLm9EatU6I05l/Qh3s4eLygDbYduInSRk+AAeLD2xBic69dCL
AQEuikqJhQ5jtQ88nSS/kVeaDhWTaXOp6ncPxXvqpupG9AhWvyY=
=NdX0
-----END PGP SIGNATURE-----
--=-=-=--
