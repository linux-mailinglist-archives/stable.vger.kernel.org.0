Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A32421420
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbhJDQdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235704AbhJDQdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 12:33:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5DE61184;
        Mon,  4 Oct 2021 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633365084;
        bh=xC5zyZY8esd3E0X5X90FwEIpcl9VP5zy4k4PAm5SGaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i8vpfOh36DB3ixtiEcbdS4OLgvMOR/hegKqLFwK4uQxo6TYEMtzZC/AgqfHRcsCrH
         cdqpPpDN/5F0k83bkujOD4sGzMzu3p1p3uS+YkT8w9/pO000h5fy+b3qk1CbrFxcxr
         0U300JuKxhKys0R8t8DGKNv1a3sUrtga2qYt3mBU2cCinNBTD7vbqWvt5tGLg5adwr
         2SAsOKN24KBWCOTSJ/eoAR834iFjXHoHq4IxcN256S/i+K+J12wRbB0gYnX51/v97N
         3qR6OdTxIt6B459Jetw/vdgRxwapwC0N+TtIMiOD+lEMNIx/Kpk3Glu5fEPUKG+EK1
         UGF+AH67qVZMw==
Date:   Mon, 4 Oct 2021 17:31:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVssWYaxuQDi8jI5@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk>
 <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk>
 <20211004154436.GY3544071@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Vk4aO1eaTM88kUGw"
Content-Disposition: inline
In-Reply-To: <20211004154436.GY3544071@ziepe.ca>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Vk4aO1eaTM88kUGw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 12:44:36PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 04, 2021 at 03:12:20PM +0100, Mark Brown wrote:
> > On Mon, Oct 04, 2021 at 10:17:56AM -0300, Jason Gunthorpe wrote:

> > > When something like kexec happens we need the machine to be in a state
> > > where random DMA's are not corrupting memory.

> > That's all well and good but there's no point in implementing something
> > half baked that's opening up a whole bunch of opportunities to crash the
> > system if more work comes in after it's half broken the device setup. =
=20

> Well, that is up to the driver implementing this. It looks like device
> shutdown is called before the userspace is all nuked so yes,
> concurrency with userspace is a possible concern here.

It's not just userspace that can initiate things - interrupts are also
an issue, someone could press a button or whatever.  Frankly for SPI the
quiescing part doesn't seem like logic that should be implemented in
drivers, it's a subsystem level thing since there's nothing driver
specific about it.

> > > Due to the emergency sort of nature it is not appropriate to do
> > > locking complicated sorts of things like struct device unregistrations
> > > here.

> > That's just not what's actually implemented in a bunch of places, nor
> > something one would infer from the documentation ("Called at shut-down
> > to quiesce the device", no mention of emergency cases which I'd guess
> > would just be kdump) -=20

> Drivers mis understanding stuff is not new..

Not just drivers, entire subsystems.  And like I say given the
documentation I'd be hard pressed to say that it's a misunderstanding.

> > that's a different thing and definitely abusing the API.  I would guess
> > that a good proportion of people implementing it are more worried about
> > clean system shutdown than they are about kdump.

> The other important case is to get the device cleaned up enough to
> pass back to firmware for platforms that use a firmware
> shutdown/reboot path.

Right, so the other cases I'm aware of are doing pretty much that -
bringing things down to a state where the system can reboot cleanly.
That can definitely include things like blocking for some hardware, and
you're going to need some concurrency handling which means a combination
of locking and infrequently tested lockless code paths.

In the case of this specific driver I'm still not clear that the best
thing isn't just to delete the shutdown callback and let any ongoing
transfers complete, though I guess there'd be issues in kexec cases with
long enough tansfers.

--Vk4aO1eaTM88kUGw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbLFgACgkQJNaLcl1U
h9CBKQf9GQ2KXuo+WmJK0ivezZx5gC5jF7VSvNRus+fKLGu5Uorq8FQ3ylrl1/pR
85lCQLPVoaHAzKbptULKGdqo4kp/Rz623GgSEHAbSazeq+jiO4Okp/BgcYr6swYT
PU3xCob1clSWHd7TaUort5ObersVFAmy3egaELXdpDTy6o7/W1JmR5ikEDuEg5Us
EWNn9h2oeYcqkbygqa+0yiA2/Z+UICUyv1ZI6GLGIAZqiWH/hLF2o0fxkKLDbMNw
BjuDlgtc4FEn6fss/GojWqaHO+OSObdDFeJMckiBIEKW7IxHYOKOm6gVDc/2neFV
sECi73OZzJz9snQva6F8G6ZZ+h9/bA==
=3RQB
-----END PGP SIGNATURE-----

--Vk4aO1eaTM88kUGw--
