Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F086A64EC2B
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiLPNh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPNh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:37:29 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7726C13D72
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 05:37:27 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E3D71C000D;
        Fri, 16 Dec 2022 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671197846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nT70aYBg/Cm2D0ciqkmRaEWnOMLvAiB0CQw5gxyN+z8=;
        b=DYKGlGavHsjxuGJLdYUHbxApcucPG5WoqMZrlwyAH436ycQPTFbBcz573UkC6mkd7u3itR
        PuDdZw+ZqUCNc/WlQgkjTQRLGy9c4FRD0SN9Rxyg0wVcpnYAXKp8OF1CUslIfGjGYhx6U3
        gVk9wWe5SPUKCC3Mk0jf+Ole+8gX09FKLLBInkKFEWxUfMxwUyJWcvMgSxVUuqporRhGLT
        hEMBmY/68YbvqzUTddZuGM6Wi4EMG4HmJYnkluPMq+7r5IsWETqUajdlE6jxrjlK4fyWcd
        DGQhDTV1JdlrLz7kUEDXDjv0NPfq7Zn+DQwsTYKd05PoVUsBYoW85of02aRkvg==
Date:   Fri, 16 Dec 2022 14:37:20 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Marek Vasut <marex@denx.de>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20221216143720.3c8923d8@xps-13>
In-Reply-To: <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
        <20221216120155.4b78e5cf@xps-13>
        <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Fri, 16 Dec 2022 13:37:31 +0100:

> On Fri, Dec 16, 2022 at 12:01:55PM +0100, Miquel Raynal wrote:
> > marex@denx.de wrote on Fri, 16 Dec 2022 11:46:18 +0100: =20
> > > On 12/16/22 08:45, Francesco Dolcini wrote: =20
> > > > On Thu, Dec 15, 2022 at 08:16:04AM +0100, Miquel Raynal wrote:   =20
> > > >> I am still against piggy hacks in the generic ofpart.c driver, but
> > > >> what we could do however is a DT fixup in the init_machine (or the
> > > >> dt_fixup) hook for imx7 Colibri, very much like this:
> > > >> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu=
/board-v7.c#L111
> > > >> Plus a warning there saying "your dt is broken, update your firmwa=
re".   =20
> > > >=20
> > > > I have a couple of concerns/question with this approach:
> > > >   - do we have a single point to handle this? Different architectur=
es are
> > > >     affected by these issue. Duplicating the fixup code in multiple=
 place
> > > >     does not seems a great idea
> > > >   - If we believe that the device tree is wrong, in the i.MX7 case
> > > >     because of #size-cells should be set to 0 and not 1, we should =
not
> > > >     alter the FDT. Other part of the code could rely on this being
> > > >     correctly set to 0 moving forward.
> > > >=20
> > > > If I understood you are proposing to have a fixup at the machine le=
vel
> > > > that is converting a valid nand-controller node definition to a "br=
oken"
> > > > one. Unless I misunderstood you and you are thinking about rewritin=
g the
> > > > whole MTD partition from a broken definition to a proper one. =20
> >=20
> > No, quite the opposite.
> >
> > Either size-cell is wrong which makes the description totally
> > inconsistent (if size-cell is there, it must have a use, otherwise why
> > do we keep it?) and we must fix it, or it is right and we should not
> > touch it.
> >=20
> > What I propose is to check very early whether the description is
> > consistent on the board known to have this problem. If the description
> > is wrong, we fix it and the generic parser can then do its work
> > properly. =20
>=20
> What if we add `nand-chip{}` children in the future (the i.MX nand
> controller has nothing implemented not described in the schema so far,
> but it is something that is supported by the hw)? Will this idea still
> works?

I think yes. I mean, moving to a

nand-controller { nand-chip { partitions { part@x part@y } } }

scheme is what we should eventually find on all maintained boards, but
I would say, at the very least, the description must be coherent.

But my previous answer was only focusing on the case where you change
something in the kernel or in the DT that breaks the board because of
the mess fdt_fixup_mtdparts() brings.

> > > > On Thu, Dec 15, 2022 at 09:04:46AM +0100, Miquel Raynal wrote:   =20
> > > >> marex@denx.de wrote on Thu, 15 Dec 2022 08:45:33 +0100:   =20
> > > >>> Sadly, it does only fix the known cases, not the unknown cases li=
ke
> > > >>> downstream forks which never get any bootloader updates ever, and
> > > >>> which you can't find in upstream U-Boot, and which you therefore
> > > >>> cannot easily catch in the arch side fixup.   =20
> > > >>
> > > >> And ?   =20
> > > >=20
> > > > I'm not personally and directly concerned, since the machine I care=
 are
> > > > all available upstream and known, however this is a general problem=
 with
> > > > U-Boot code being at the same time widely used on a range of embedd=
ed
> > > > products and producing a broken MTD partition list.
> > > >=20
> > > > I think we will just silently break boards and just creating a lot =
of
> > > > issues to people. We would just introduce regression to the users, =
being
> > > > aware of it and deliberately decide to not care and move the proble=
m to
> > > > someone else. I do not think this is a good way to go.   =20
> >=20
> > What? =20
>=20
> Let me rephrase, I was not clear enough.
>=20
> > Since when my proposal is breaking boards? My proposal leads to a
> > situation where:
> > - If you have a board that has an inconsistent description but worked,
> >   it will still work.
> > - If you have a board that has a consistent description and worked, it
> >   will still work.
> > - If your have a board that has an inconsistent description and got
> >   broken *recently* by another change (typically you "fix" the DT in
> >   Linux to comply with the bindings), then you get a warning that leads
> >   you on the right path, you then update your bootloader if you can,
> >   but either way you add your machine compatible to the list of devices
> >   which need the early fix and your boot is fixed. =20
>=20
> This implies that we can proactively catch all the affected boards. I do
> not believe this is reasonable and because of that my comment before
> about creating regression to the users.

I really don't understand the reasoning here.

What I say is: let's fix the boards known to be incorrectly described
when we break them so they continue working with a broken firmware.

What regression could this possibly bring? I don't care about catching
the 2k boards out there which work but wrongly describe their
partitions. If they work, they will continue working.

You and Marek say: let's blindly always change a property in the DT, no
matter if the board is broken, even if we don't know if this is the
right thing to do, and apply this to the entire world.

But with this approach you're not worried about regressions.

I am sorry it does not stand.

Thanks,
Miqu=C3=A8l
