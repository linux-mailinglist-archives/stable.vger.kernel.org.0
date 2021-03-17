Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7455233FBB0
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 00:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCQXKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 19:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhCQXJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 19:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0D9864E42;
        Wed, 17 Mar 2021 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616022589;
        bh=M0HrF9RySno8AsX4AO+jhQnN5bJj6rJG0DDV0d8t7GE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PXCap4kRk3laFJmvCvMLb4I64dll1trK/JMs3HI01sNkY8zb3mstDWDO6iZLnitVi
         lXzwrHy0/46Wkdt2iwvghJyFGGnjnEkcQAvsGfxggkvMstkSBtMr3IYjGXZBTVtB8G
         9r+N6UMg0BdKl89QdymtbkM1DHHj9WF3qU4xqN8VVOsJ6Fyx4tQqpzgpi9Kgeo+ugz
         OsvRnmkHtYd/8uNcKK+EaJRAhbpYXaDsyz+BtNqYNVtrM3sfG9hzU5DPDuxX6vRqS9
         GOF68SThOG1Y7z9mT9l2QtFF92xQRZDpnxdb3wOyPVjqluqoX8gf7h8fhqPnkwZrTq
         uA+lz35FSRi9g==
Date:   Thu, 18 Mar 2021 00:09:45 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org,
        =?UTF-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Pali =?UTF-8?B?Um9o?= =?UTF-8?B?w6Fy?= <pali@kernel.org>,
        stable@vger.kernel.org, Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
Message-ID: <20210318000945.73cb8698@kernel.org>
In-Reply-To: <20210317224549.GA93134@bjorn-Precision-5520>
References: <20210317115924.31885-1-kabel@kernel.org>
        <20210317224549.GA93134@bjorn-Precision-5520>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Mar 2021 17:45:49 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Zachary, author of 8a3ebd8de328]
>=20
> Thanks for the report and the patch, Marek!
>=20
> On Wed, Mar 17, 2021 at 12:59:24PM +0100, Marek Beh=C3=BAn wrote:
> > The ASMedia ASM1062 SATA controller causes an External Abort on
> > controllers which support Max Payload Size >=3D 512. It happens with
> > Aardvark PCIe controller (tested on Turris MOX) and also with DesignWare
> > controller (armada8k, tested on CN9130-CRB):
> >=20
> >   ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> >   ata1.00: ATA-9: WDC WD40EFRX-68WT0N0, 80.00A80, max UDMA/133
> >   ata1.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 32), AA
> >   ERROR:   Unhandled External Abort received on 0x80000000 at EL3!
> >   ERROR:    exception reason=3D1 syndrome=3D0x92000210
> >   PANIC at PC : 0x00000000040273bc
> >=20
> > Limiting Max Payload Size to 256 bytes solves this problem.
> >=20
> > On Turris MOX this problem first appeared when the pci-aardvark
> > controller started using the pci-emul-bridge API, in commit 8a3ebd8de328
> > ("PCI: aardvark: Implement emulated root PCI bridge config space"). =20
>=20
> Any ideas about why 8a3ebd8de328 made a difference?  Could there be a
> defect in 8a3ebd8de328?  Or maybe before 8a3ebd8de328 we didn't
> actually read or update MPS settings in the hardware?

Before 8a3ebd8de328 the PCIe subsystem could not detect that the MPS is
512 bytes, because the emulated bridge did not exists. So it did not try
to change MPS for the SATA controller, or changed it to minimum of 128
bytes. Once pci-emul-bridge was added, the PCIe subsystem had access to
the information that the aardvark controller supports 512 bytes, so it
tried to leverage it, since the SATA controller says it can handle 512
bytes MPS. But apparently it cannot.

> > On armada8k this was always a problem because it has HW root bridge. =20
>=20
> Can you please open a report at bugzilla.kernel.org and attach the
> complete "sudo lspci -vv" output for both systems?  I think it's OK to
> collect these with the patch applied; we should still be able to see
> the information we use to compute the MPS values.  But please include
> the CONFIG_PCIE_BUS_* settings and any "pcie_bus_*" kernel command
> line arguments.
>=20
> This quirk suggests that there's a hardware defect in the ASMedia
> ASM1062.  But if that's really the case, we should see reports on lots
> of platforms, and I'm only aware of these two.  You do mention that it
> was always a problem on armada8k; if you know of other reports of
> that, please include URLs in the bugzilla.

I think that most people use this adapter on x86 platforms. Maybe x86
PCIe controllers do not support 512 bytes MPS (at least my notebook
nor work computer don't). So this issue would be only detected by
someone who used this controller on a controller which supports 512+
bytes MPS. armada8k is mainly used for network devices, so PCIe
there is probably mostly used for wifi cards, and for SATA armada8k has
native controller, and also nVME. The most probable answer is that
noone used this controller on armada8k nor aardvark...

> If the problem only occurs on these platforms, my first guess would be
> a hardware defect in these platforms or a software defect in the PCIe
> controller driver.  It wouldn't surprise me if we have a generic PCI
> core defect in how we set MPS, either.

If someone has this card and a x86 or other PCIe controller capable of
512 byte MPS, maybe they could check.

But aramda8k PCIe controller (which is a DesignWare IP) is completely
different from aardvark (although they both are on Armada SOCs). I
think it is more probable that the problem is in the ASMedia SATA
controller, this controller has also other issues (firmware sometimes
crashing, for example).

> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > Reported-by: R=C3=B6tti <espressobinboardarmbiantempmailaddress@posteo.=
de>
> > Cc: Pali Roh=C3=A1r <pali@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/pci/quirks.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 653660e3ba9e..a561136efb08 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3251,6 +3251,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLAR=
E,
> >  			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
> >  			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
> > +/*
> > + * For some reason DECLARE_PCI_FIXUP_HEADER does not work with pci-aar=
dvark
> > + * controller. We have to use DECLARE_PCI_FIXUP_EARLY.
> > + */ =20
>=20
> This is curious, too.  If we need the quirk, I'd like to run this down
> to figure out why we need an EARLY instead of HEADER quirk.
> Differences like that suggest a bug elsewhere, or at least an
> unnecessary difference between PCIe controller drivers.

Now that I look at this, the comment is wrong. What I meant to say is
that when I used HEADER quirk, the PCIe subsystem did change the MPS to
512 bytes, so clearly the HAEDER quirk only comes after changing of MPS.

I think that the other quirks using the fixup_mpss_256 callback should
also use EARLY instead of HEADER. Maybe something changed in PCI API
sometime and noone noticed that these quirks stopped working?

Marek

> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
> > =20
> >  /*
> >   * Intel 5000 and 5100 Memory controllers have an erratum with read co=
mpletion
> > --=20
> > 2.26.2
> >  =20

