Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701DF4A40E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfFRObY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:31:24 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35219 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRObX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:31:23 -0400
Received: by mail-lf1-f66.google.com with SMTP id a25so9461074lfg.2;
        Tue, 18 Jun 2019 07:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KS72y9tYRBol5/KnOsvhBghl9/3z1sLdxINCtK5+heI=;
        b=J2UqlpY0VhOSeTS4dgxMAgAd6hBDiaCwTNzVxmJ2VZms8tyJE1a2Hve0Puner0kfOd
         ZAMMtWFn46WtQdtU4tl2k13xmKFY0Xml/uCz1v5LzpkugSlVqT1zOiICh2ieleaTf/qz
         /enwofIAuzpBQY3ricVfXQW468TKkAiky3Az0g8FQIWwc/YYwBuxHhGCWHCNHQatQ5S1
         Sb4Ri/styKtyt8TRLcvBAmwRq+G55VaMTwk5DOzkyKCs6KKfgTFMg/dd1Zyy6Yafp5g+
         N54VlgF9uQ5OW/mBVBZA8GWGkwCXFzLuC0HlgMOexu8poRnSmX1qwrLXT380LFQ54LTM
         QNXA==
X-Gm-Message-State: APjAAAX5QO/ZjTxaCtrh+PXixjYH1ARNg8BepWF6zOwx8is7OeqxhV3+
        YbDdXXN9hC4cjd1sENh4NEmy2UXt
X-Google-Smtp-Source: APXvYqyfQKY0PhE0ARY+YledqeQb5c9mIdNB9g3MFnizu9PXBdrn2bxvwPxlsY4fnyHI5bAoigjZ0A==
X-Received: by 2002:a19:6703:: with SMTP id b3mr59753084lfc.153.1560868282087;
        Tue, 18 Jun 2019 07:31:22 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id z12sm2222078lfg.67.2019.06.18.07.31.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:31:20 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hdF8q-0007ep-Te; Tue, 18 Jun 2019 16:31:20 +0200
Date:   Tue, 18 Jun 2019 16:31:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
Message-ID: <20190618143120.GI31871@localhost>
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
 <20190614145236.GB3849@localhost>
 <877e9kiuew.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <877e9kiuew.fsf@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2019 at 09:43:19AM +0300, Felipe Balbi wrote:
>=20
> Hi,
>=20
> Johan Hovold <johan@kernel.org> writes:
> > On Tue, Jun 11, 2019 at 08:24:16PM +0300, Felipe Balbi wrote:
> >> If we happen to have two XHCI controllers with DbC capability, then
> >> there's no hope this will ever work as the global pointer will be
> >> overwritten by the controller that probes last.
> >>=20
> >> Avoid this problem by keeping the tty_driver struct pointer inside
> >> struct xhci_dbc.
> >
> > How did you test this patch?
>=20
> by running it on a machine that actually has two DbCs
>=20
> >> @@ -279,52 +279,52 @@ static const struct tty_operations dbc_tty_ops =
=3D {
> >>  	.unthrottle		=3D dbc_tty_unthrottle,
> >>  };
> >> =20
> >> -static struct tty_driver *dbc_tty_driver;
> >> -
> >>  int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci)
> >>  {
> >>  	int			status;
> >>  	struct xhci_dbc		*dbc =3D xhci->dbc;
> >> =20
> >> -	dbc_tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
> >> +	dbc->tty_driver =3D tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
> >>  					  TTY_DRIVER_DYNAMIC_DEV);
> >> -	if (IS_ERR(dbc_tty_driver)) {
> >> -		status =3D PTR_ERR(dbc_tty_driver);
> >> -		dbc_tty_driver =3D NULL;
> >> +	if (IS_ERR(dbc->tty_driver)) {
> >> +		status =3D PTR_ERR(dbc->tty_driver);
> >> +		dbc->tty_driver =3D NULL;
> >>  		return status;
> >>  	}
> >> =20
> >> -	dbc_tty_driver->driver_name =3D "dbc_serial";
> >> -	dbc_tty_driver->name =3D "ttyDBC";
> >> +	dbc->tty_driver->driver_name =3D "dbc_serial";
> >> +	dbc->tty_driver->name =3D "ttyDBC";
> >
> > You're now registering multiple drivers for the same thing (and wasting
> > a major number for each) and specifically using the same name, which
> > should lead to name clashes when registering the second port.
>=20
> No warnings were printed while running this, actually. Odd

Odd indeed. I get the expected warning from sysfs when trying to
register a second tty using an already registered name:

[  643.360555] sysfs: cannot create duplicate filename '/class/tty/ttyS0'
[  643.360637] CPU: 1 PID: 2383 Comm: modprobe Not tainted 5.2.0-rc1 #2
[  643.360702] Hardware name:  /D34010WYK, BIOS WYLPT10H.86A.0051.2019.0322=
=2E1320 03/22/2019
[  643.360784] Call Trace:
[  643.360823]  dump_stack+0x46/0x60
[  643.360865]  sysfs_warn_dup.cold.3+0x17/0x2f
[  643.360914]  sysfs_do_create_link_sd.isra.2+0xa6/0xc0
[  643.360961]  device_add+0x30d/0x660
[  643.360987]  tty_register_device_attr+0xdd/0x1d0
[  643.361018]  ? sysfs_create_file_ns+0x5d/0x90
[  643.361049]  usb_serial_device_probe+0x72/0xf0 [usbserial]
=2E..

Are you sure you actually did register two xhci debug ttys?

Johan

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCXQj1qwAKCRALxc3C7H1l
CL/OAQCsHyez+eOKy5J2+gS1uwdz4rgQpPM/wj8cQMuU/MEFgQD+L8qQ89I/nF6X
wI5NDR8tbnOfR3r5l5QF9t2SRZiVgwY=
=4XXc
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
