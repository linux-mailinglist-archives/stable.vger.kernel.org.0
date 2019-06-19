Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFB4B221
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 08:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfFSGdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 02:33:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:37414 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfFSGdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 02:33:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 23:33:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="asc'?scan'208";a="243221487"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2019 23:33:44 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
In-Reply-To: <20190618143120.GI31871@localhost>
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com> <20190614145236.GB3849@localhost> <877e9kiuew.fsf@linux.intel.com> <20190618143120.GI31871@localhost>
Date:   Wed, 19 Jun 2019 09:33:40 +0300
Message-ID: <877e9if5iz.fsf@linux.intel.com>
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
>> Johan Hovold <johan@kernel.org> writes:
>> > On Tue, Jun 11, 2019 at 08:24:16PM +0300, Felipe Balbi wrote:
>> >> If we happen to have two XHCI controllers with DbC capability, then
>> >> there's no hope this will ever work as the global pointer will be
>> >> overwritten by the controller that probes last.
>> >>=20
>> >> Avoid this problem by keeping the tty_driver struct pointer inside
>> >> struct xhci_dbc.
>> >
>> > How did you test this patch?
>>=20
>> by running it on a machine that actually has two DbCs
>>=20
>> >> @@ -279,52 +279,52 @@ static const struct tty_operations dbc_tty_ops =
=3D {
>> >>  	.unthrottle		=3D dbc_tty_unthrottle,
>> >>  };
>> >>=20=20
>> >> -static struct tty_driver *dbc_tty_driver;
>> >> -
>> >>  int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci)
>> >>  {
>> >>  	int			status;
>> >>  	struct xhci_dbc		*dbc =3D xhci->dbc;
>> >>=20=20
>> >> -	dbc_tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
>> >> +	dbc->tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
>> >>  					  TTY_DRIVER_DYNAMIC_DEV);
>> >> -	if (IS_ERR(dbc_tty_driver)) {
>> >> -		status =3D PTR_ERR(dbc_tty_driver);
>> >> -		dbc_tty_driver =3D NULL;
>> >> +	if (IS_ERR(dbc->tty_driver)) {
>> >> +		status =3D PTR_ERR(dbc->tty_driver);
>> >> +		dbc->tty_driver =3D NULL;
>> >>  		return status;
>> >>  	}
>> >>=20=20
>> >> -	dbc_tty_driver->driver_name =3D "dbc_serial";
>> >> -	dbc_tty_driver->name =3D "ttyDBC";
>> >> +	dbc->tty_driver->driver_name =3D "dbc_serial";
>> >> +	dbc->tty_driver->name =3D "ttyDBC";
>> >
>> > You're now registering multiple drivers for the same thing (and wasting
>> > a major number for each) and specifically using the same name, which
>> > should lead to name clashes when registering the second port.
>>=20
>> No warnings were printed while running this, actually. Odd
>
> Odd indeed. I get the expected warning from sysfs when trying to
> register a second tty using an already registered name:
>
> [  643.360555] sysfs: cannot create duplicate filename '/class/tty/ttyS0'
> [  643.360637] CPU: 1 PID: 2383 Comm: modprobe Not tainted 5.2.0-rc1 #2
> [  643.360702] Hardware name:  /D34010WYK, BIOS WYLPT10H.86A.0051.2019.03=
22.1320 03/22/2019
> [  643.360784] Call Trace:
> [  643.360823]  dump_stack+0x46/0x60
> [  643.360865]  sysfs_warn_dup.cold.3+0x17/0x2f
> [  643.360914]  sysfs_do_create_link_sd.isra.2+0xa6/0xc0
> [  643.360961]  device_add+0x30d/0x660
> [  643.360987]  tty_register_device_attr+0xdd/0x1d0
> [  643.361018]  ? sysfs_create_file_ns+0x5d/0x90
> [  643.361049]  usb_serial_device_probe+0x72/0xf0 [usbserial]
> ...
>
> Are you sure you actually did register two xhci debug ttys?

hmm, let me check:

int xhci_dbc_tty_register_device(struct xhci_hcd *xhci)
{
	int			ret;
	struct device		*tty_dev;
	struct xhci_dbc		*dbc =3D xhci->dbc;
	struct dbc_port		*port =3D &dbc->port;

	xhci_dbc_tty_init_port(xhci, port);
	tty_dev =3D tty_port_register_device(&port->port,
					   dbc_tty_driver, 0, NULL);

	[...]
}

static void xhci_dbc_handle_events(struct work_struct *work)
{
	int			ret;
	enum evtreturn		evtr;
	struct xhci_dbc		*dbc;
	unsigned long		flags;
	struct xhci_hcd		*xhci;

	dbc =3D container_of(to_delayed_work(work), struct xhci_dbc, event_work);
	xhci =3D dbc->xhci;

	spin_lock_irqsave(&dbc->lock, flags);
	evtr =3D xhci_dbc_do_handle_events(dbc);
	spin_unlock_irqrestore(&dbc->lock, flags);

	switch (evtr) {
	case EVT_GSER:
		ret =3D xhci_dbc_tty_register_device(xhci);

	[...]
}

static int xhci_dbc_start(struct xhci_hcd *xhci)
{
	int			ret;
	unsigned long		flags;
	struct xhci_dbc		*dbc =3D xhci->dbc;

	WARN_ON(!dbc);

	pm_runtime_get_sync(xhci_to_hcd(xhci)->self.controller);

	spin_lock_irqsave(&dbc->lock, flags);
	ret =3D xhci_do_dbc_start(xhci);
	spin_unlock_irqrestore(&dbc->lock, flags);

	if (ret) {
		pm_runtime_put(xhci_to_hcd(xhci)->self.controller);
		return ret;
	}

	return mod_delayed_work(system_wq, &dbc->event_work, 1);
}

static ssize_t dbc_store(struct device *dev,
			 struct device_attribute *attr,
			 const char *buf, size_t count)
{
	struct xhci_hcd		*xhci;

	xhci =3D hcd_to_xhci(dev_get_drvdata(dev));

	if (!strncmp(buf, "enable", 6))
		xhci_dbc_start(xhci);
	else if (!strncmp(buf, "disable", 7))
		xhci_dbc_stop(xhci);
	else
		return -EINVAL;

	return count;
}

Hmm, so it only really registers after writing to sysfs file. Man, this
is an odd driver :-)

@Mathias, can you drop the previous fix? I'll try to come up with a
better version of this.

@Johan, thanks for the review.

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl0J10QACgkQzL64meEa
mQbpMxAAqxt6iZem55dprW88PUOdiJBNIj1IsKe07R4ElMD88YD9PshR5UHqBhy4
89LMOFEk05Z4OBMWYtGuAGE5e8RAqlM3uZub3iWgQkDj/ya4hQvxE3VqUZaf/uAF
5/HJKEio1zW01CqCjgwRBQ16m93+QcVSqH3LBlWMJ+RNLvvj1Fg7iyNMSHCMp7m+
04bEljqDTmiNsg5n9Zshc0ZD9Hxcj1yE4sZe0L9NpYNxBVOtmraT3hN7B37M/7eu
BfmfeImW2G+wOe//ujLbs3IAcPnVs3OQ7X6qUbpWAczTCXMnl0LdYUuBIRuP0yuD
sMptailGg3e+3pWD6FIJ/Ykq7jH3Uu7iUP71ljd8Di+LmUTdGBJKSwiAG9hXXJjd
pBvZjPYdXi2eimdVXCygGweRWRThmGksHJXZwCu55+Y3kDZgNNGmetVkOxPrAVhv
P1KJjYKwkVKkoYbHVbvGbMDVSda0lqq4Wb9Dt/pPSt/sTSc2WWsDhi/7fO/lcax7
Rq5MX1WSTEQmjXcOIR58bpCZqQQRfVJLCEkIfXzIw2ZwGkISyBeBuxQImToVCvVK
aA86SzM5azDpocsowhZyc6FzpAxDG3HVTtqcIcupcfEc7uWe8ITYpC3iwc6Mww1W
I1mlg8uAjhE9FmqWimW6B5XqS7PGHBkdrVn1gaLPPZkC7fincF4=
=7dTY
-----END PGP SIGNATURE-----
--=-=-=--
