Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71233390FC
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhCLPRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:17:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhCLPRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 10:17:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E727464FCE;
        Fri, 12 Mar 2021 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615562228;
        bh=teWZH5IRebQbacXOyacm0Vpj0YMmVKRVQuQG4BAku70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdG006f34lXoAhj+kle8myJouN4B/Mp6GIsf5SWMRHQAijeAH8qQ1ZQAZKaToEReO
         5zz9sIIf+bX/KL7865OEL1LBZB+xhPvOPVTMXC9a7p1V47iL9/DUK9m/KFhBrKqocl
         AvofOOZTmW0EyUQnPy0owuvfSXD124VGbV7sI2IQEqCRZ55ItVAX/3CmRrzrvJ7YsL
         snALUtWJSO2c3V5QRnPI0O1lBWRXPMKmF4Ml/Lt5rdtBmzfWKafy5pDWuK3VRHggr0
         PMAyfP0VWM2DI7YuabDq9QAwvroqq8VVsU+g6nBYVsZNV4OdaK3eHZ2qHmEVlr0YbM
         FFEWbfANhqj6w==
Date:   Fri, 12 Mar 2021 16:17:04 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell:
 armada-37xx: move firmware node to generic dtsi file
Message-ID: <20210312161704.5e575906@kernel.org>
In-Reply-To: <YEt/Ll08M1cwgGR/@lunn.ch>
References: <20210308153703.23097-1-kabel@kernel.org>
        <20210308153703.23097-4-kabel@kernel.org>
        <87czw4kath.fsf@BL-laptop>
        <20210312101027.1997ec75@kernel.org>
        <YEt/Ll08M1cwgGR/@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Mar 2021 15:48:14 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Mar 12, 2021 at 10:10:27AM +0100, Marek Beh=C3=BAn wrote:
> > On Fri, 12 Mar 2021 09:58:34 +0100
> > Gregory CLEMENT <gregory.clement@bootlin.com> wrote:
> >  =20
> > > Hello Marek,
> > >  =20
> > > > From: Pali Roh=C3=A1r <pali@kernel.org>
> > > >
> > > > Move the turris-mox-rwtm firmware node from Turris MOX' device tree=
 into
> > > > the generic armada-37xx.dtsi file.   =20
> > >=20
> > > I disagree with this patch. This firmware is specific to Turris MOX so
> > > it is not something that should be exposed to all the Armada 3700 bas=
ed
> > > boards.
> > >=20
> > > If you want you still can create an dtsi for this and include it when
> > > needed.
> > >=20
> > > Gregory =20
> >=20
> > Gregory, we are planning to send pull-request for TF-A documentation,
> > adding information that people can compile the firmware with CZ.NIC's
> > firmware.
> >=20
> > Since this firmware exposes HW random number generator, it is
> > possible that people will start using it for espressobin.
> >=20
> > In that case this won't be specific for Turris MOX anymore. =20
>=20
> Part of the problem is that it looks specific to the Turris MOX.
>=20
> But please help me understand the big picture first.  How is the
> firmware distributed? Is the binary part of linux-firmware? How does
> it get loaded? Does the firmware contain anything which is specific to
> the Turris MOX? Could the hardware number generator part be split out
> into a more generic sounding name blob?
>=20
>      Andrew

Hello Andrew,

The WTMI firmware is loaded before kernel. This firmware is loaded by
BootROM, and it is this firmware that does DDR training before loading
TF-A + U-Boot.

For example for ESPRESSObin you have several repositories you need to
create a final flash-image.bin containing this WTMI firmware + TF-A +
U-Boot. These repositories are:
  trusted-firmware-a (contains documentation how to build all this)
  A3700-utils-marvell
  u-boot
  mv-ddr-marvell
=46rom these sources you are able to create a final flash-image.bin that
you can flash onto the SPI-NOR (or eMMC or other devices which A3720
can boot from).

The A3700-utils-marvell repository contains the code of the WTMI
firmware.

On Turris MOX this is a little bit different, because
- we have implemented the WTMI firmware differently (more mailbox
  commands, HW crypto, ...)
- it supports retrieving MOX board information (MAC addresses, serial
  number) stored in eFuses (this information is stored in a specific
  way that in only true for MOX)
- the firmware binary must be signed by our private key in order to
  boot on MOX.

  This is because the secure firmware has access to an ECDSA engine
  with a private key storage in eFuses (each MOX has its own private
  key generated and stored into the eFuses when manufactured)
  In order to disallow hackers to somehow extract the private key,
  the firmware must be signed so that they cannot load arbitrary
  firmware into the secure processor.

BUT
- since this firmware is able to provide HWRNG, we wanted to make it
  available for other Armada 3720 boards
- we updated the code so that users can build it for non-MOX devices
- it does not have to be signed for other devices
- it does not contain MOX specific stuff for non-MOX devices

So currently when users build the flash-image.bin binary containing
WTMI firmware, they are using code from A3700-utils-marvell. This code
is split into 2 parts:
- sys_init - does HW and DDR initialization and execution of an "app"
- efuse - default "app" which is loaded by sys_init
The way it is written is that user can select a different "app" when
building, and we have updated Turris MOX firmware code to be loadable
as this "app" for sys_init. (And we have renamed it from "Turris MOX
secure firmware" to "CZ.NIC's Armada 3720 secure firmware").

> Could the hardware number generator part be split out into a more
> generic sounding name blob?

It basically is. As I have written above, when users build the
flash-image.bin with CZ.NIC's firmware, the prompt does not say
anything about Turris MOX. Instead it says something like
  CZ.NIC's Armada 3720 Secure Firmware version build date
  Running on ESPRESSObin
and currently provides only the random number generator command.

So theoretically the turris-mox-rwtm driver can be renamed into
something else and we can add a different compatible in order not to
sound so turris-mox specific.

Marek
