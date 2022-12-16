Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C1664E9E4
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiLPLCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLPLCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:02:02 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1612BD2
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:02:00 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5A60A20008;
        Fri, 16 Dec 2022 11:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671188519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrRmFSTxWSFOcAFF91oEN2EuEZEt1gzRnrXqpvlWtAY=;
        b=CspEJzDlwWrWwvnJSBeZSQ9SFAGNYQXpI7a4PI7LvQOike5EZZF7+uKgv7iHWvt0teaFeX
        V7pgGpiJBZGUcK4ua3uw5SYAOFo7vteXZGV6+uJPIHUK3PQAoiPiuH8noqmb2J/8aNsM0r
        /lqcqFE8gDh2dKQ0Y3GO0MQGbEKtcxRY5bM2leqJ/IbFv0hMbkly2/DmDNYiz18uFfhtAp
        yVg//iCmMimR4SxUv5R1BVV7JT3zvEyPvWY2z0ThC1ieBDj9KBVFa75eOcy7L+03ET7Tdd
        o0ioHcYNR8uAX80T4FcPb7pxpde3ywmit5pvDCH5iFEvNTfCVzKG7bAp32P78w==
Date:   Fri, 16 Dec 2022 12:01:55 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20221216120155.4b78e5cf@xps-13>
In-Reply-To: <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


marex@denx.de wrote on Fri, 16 Dec 2022 11:46:18 +0100:

> On 12/16/22 08:45, Francesco Dolcini wrote:
> > Hello Marek and Miquel, =20
>=20
> Hi,
>=20
> > On Thu, Dec 15, 2022 at 08:16:04AM +0100, Miquel Raynal wrote: =20
> >> So my first first idea was to avoid using the broken "fixup mtdparts"
> >> function in U-Boot and I am still convinced this is what we should do
> >> in priority. =20
> >=20
> > This is something that was already discussed, but I was not really
> > thinking much on it till now. Do you think that the whole idea of
> > editing the MTD partitions from the firmware is wrong and we should just
> > pass the partition on the command line OR that the current
> > implementation is broken and can/should be fixed? =20
>=20
> No, patching the partition layout into DT is fine. Firmwares of all kinds=
 have been patching various parts of the DT before passing it to OS since f=
orever, or more recently, merging multiple DT fragments and passing the com=
posite DT to Linux.
>=20
> As far as I recall, OF predates Linux and the OF tree has been usually as=
sembled by the Forth firmware of that era from various chunks stored in dif=
ferent parts of the system. So this patching is fundamental part of the des=
ign since the beginning.
>=20
> It is difficult to describe complex structure like the partition mapping =
on kernel command line, it should really be in DT or other such structure, =
so patching it into the DT is fine.

I think describing it in the DT is fine and welcome.
I think patching it in the DT is ugly. My 2cts.

> The only detail here is, it should be patched into the DT correctly  ... =
and ... if old firmwares do not do that, Linux should fix it up.  You don't=
 throw away your old PC just because it doesn't have perfect  ACPI tables o=
ne would expect today, I don't see why we should do that  with DT machines.
>=20
> >> I am still against piggy hacks in the generic ofpart.c driver, but
> >> what we could do however is a DT fixup in the init_machine (or the
> >> dt_fixup) hook for imx7 Colibri, very much like this:
> >> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/boa=
rd-v7.c#L111
> >> Plus a warning there saying "your dt is broken, update your firmware".=
 =20
> >=20
> > I have a couple of concerns/question with this approach:
> >   - do we have a single point to handle this? Different architectures a=
re
> >     affected by these issue. Duplicating the fixup code in multiple pla=
ce
> >     does not seems a great idea
> >   - If we believe that the device tree is wrong, in the i.MX7 case
> >     because of #size-cells should be set to 0 and not 1, we should not
> >     alter the FDT. Other part of the code could rely on this being
> >     correctly set to 0 moving forward.
> >=20
> > If I understood you are proposing to have a fixup at the machine level
> > that is converting a valid nand-controller node definition to a "broken"
> > one. Unless I misunderstood you and you are thinking about rewriting the
> > whole MTD partition from a broken definition to a proper one.

No, quite the opposite.

Either size-cell is wrong which makes the description totally
inconsistent (if size-cell is there, it must have a use, otherwise why
do we keep it?) and we must fix it, or it is right and we should not
touch it.

What I propose is to check very early whether the description is
consistent on the board known to have this problem. If the description
is wrong, we fix it and the generic parser can then do its work
properly.

> >=20
> > On Thu, Dec 15, 2022 at 09:04:46AM +0100, Miquel Raynal wrote: =20
> >> marex@denx.de wrote on Thu, 15 Dec 2022 08:45:33 +0100: =20
> >>> Sadly, it does only fix the known cases, not the unknown cases like
> >>> downstream forks which never get any bootloader updates ever, and
> >>> which you can't find in upstream U-Boot, and which you therefore
> >>> cannot easily catch in the arch side fixup. =20
> >>
> >> And ? =20
> >=20
> > I'm not personally and directly concerned, since the machine I care are
> > all available upstream and known, however this is a general problem with
> > U-Boot code being at the same time widely used on a range of embedded
> > products and producing a broken MTD partition list.
> >=20
> > I think we will just silently break boards and just creating a lot of
> > issues to people. We would just introduce regression to the users, being
> > aware of it and deliberately decide to not care and move the problem to
> > someone else. I do not think this is a good way to go. =20

What? Since when my proposal is breaking boards? My proposal leads to a
situation where:
- If you have a board that has an inconsistent description but worked,
  it will still work.
- If you have a board that has a consistent description and worked, it
  will still work.
- If your have a board that has an inconsistent description and got
  broken *recently* by another change (typically you "fix" the DT in
  Linux to comply with the bindings), then you get a warning that leads
  you on the right path, you then update your bootloader if you can,
  but either way you add your machine compatible to the list of devices
  which need the early fix and your boot is fixed.
- If you add support for a new board with an old kernel and have an
  inconsistent description it does not "just work because we have an
  automatic piggy hack in the driver". I am against it.

Whether or not it is acceptable by arch maintainer is something else,
we won't know until we include them in the loop with a proper patch.

Thanks,
Miqu=C3=A8l
