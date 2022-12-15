Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2B64D780
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 09:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiLOIFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 03:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLOIEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 03:04:54 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22619D
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 00:04:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ECFE2FF803;
        Thu, 15 Dec 2022 08:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671091489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJMSUayvugL6MlhockYElUgFDKfHQF7VlLpAvaOCTyU=;
        b=GcnQz6Wp7Md0AacQlPQ2MfiPQio3iVlu1Tq3D6uJnRelE/NIlnQK45X8jp6bMtav8eUT9U
        vF6vwVV1EPH0Zi6M5AhiYLypvxp5l/g8D+4YDZkLmLMHQkFaB7dvL0/9MVLm/w1I5rGNYU
        Hb++XjuuguhISsLWsSehFSFHaT2oViPuUoAagPzrhnzAXKPhgnQhuOXSAQwUZW5of0dOwd
        Gm1euP/4Du9dX7bUMmKq98ph2vfArXJcbSAmg/oHZUzcK2sylutEA1LVbEXHeRjk5IdvgV
        y0UlcOn9VQM+GQd68r7XN/vKGNh0yI1zMblF2g+1xwR3j+9NcuOIrF94dxMvlg==
Date:   Thu, 15 Dec 2022 09:04:46 +0100
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
Message-ID: <20221215090446.28363133@xps-13>
In-Reply-To: <ac50a1ee-4312-48f6-af78-7b95a77e6fda@denx.de>
References: <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
        <20221202164904.08d750df@xps-13>
        <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
        <20221202174255.2c1cb2ff@xps-13>
        <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
        <20221202175730.231d75d5@xps-13>
        <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
        <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
        <20221205144917.6514168a@xps-13>
        <ecca019d-b0b7-630c-4221-2684cb51634c@denx.de>
        <20221215081604.5385fa56@xps-13>
        <ac50a1ee-4312-48f6-af78-7b95a77e6fda@denx.de>
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

Hi Marek,

marex@denx.de wrote on Thu, 15 Dec 2022 08:45:33 +0100:

> On 12/15/22 08:16, Miquel Raynal wrote:
> > Hi Marek & Francesco, =20
>=20
> Hi,
>=20
> > marex@denx.de wrote on Mon, 5 Dec 2022 17:25:11 +0100:
> >  =20
> >> On 12/5/22 14:49, Miquel Raynal wrote: =20
> >>> Hi Francesco, =20
> >>
> >> Hi,
> >> =20
> >>> francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:26:44 +0100: =20
> >>>    >>>> On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote: =
=20
> >>>>> But here I would say this is a firmware bug and it might have to be=
 handled
> >>>>> like a firmware bug, i.e. with fixup in the partition parser. I see=
m to be
> >>>>> changing my opinion here again. =20
> >>>>
> >>>> I was thinking at this over the weekend, and I came to the following
> >>>> ideas:
> >>>>
> >>>>    - we need some improvement on the fixup we already have in the
> >>>>      partition parser. We cannot ignore the fdt produced by U-Boot -=
 as
> >>>>      bad as it is.
> >>>>    - the proposed fixup is fine for the immediate need, but it is
> >>>>      not going to be enough to cover the general issue with the U-Bo=
ot
> >>>>      generated partitions. U-Boot might keep generating partitions a=
s direct
> >>>>      child of the nand controller even when a partitions{} node is
> >>>>      available. In this case the current parser just fails since it =
looks
> >>>>      only into it and it will find it empty.
> >>>>    - the current U-Boot only handle partitions{} as a direct child o=
f the
> >>>>      nand-controller, the nand-chip is ignored. This is not the way =
it is
> >>>>      supposed to work. U-Boot code would need to be improved. =20
> >>>
> >>> I've been thinking about it this weekend as well and the current fix
> >>> which "just set" s_cell to 1 seems risky for me, it is typically the
> >>> type of quick & dirty fix that might even break other board (nobody
> >>> knew that U-Boot current logic expected #size-cells to be set in the
> >>> DT, what if another "broken" DT expects the opposite...) =20
> >>
> >> Then with the current configuration, such broken DT would not work, si=
nce current DT does set #size-cells=3D<1> (wrongly).
> >> =20
> >>> , not
> >>> mentioning potential issues with big storages (> 4GiB).
> >>>
> >>> All in all, I really think we should revert the DT change now, revert=
ing
> >>> as little to no drawbacks besides a dt_binding_check warning and gives
> >>> us time to deal with it properly (both in U-Boot and Linux). =20
> >>
> >> I am really not happy with this, but if that's marked as intermediate =
fix, go for it.
> >>
> >> How do we deal with this in the long run however? Parser-side fix like=
 this one, maybe with better heuristics ? =20
> >=20
> > Yesterday while talking about an ACPI mis-description which needed
> > fixing, I realized fixing up what the firmware provides to Linux should
> > preferably be handled as early as possible. So my first first idea was
> > to avoid using the broken "fixup mtdparts" function in U-Boot and I am
> > still convinced this is what we should do in priority. However, as
> > rightly pointed in this thread, we need to take care about the case
> > where someone would use a newer DT (let's say, with the reverted changed
> > reverted again) with an old U-Boot. I am still against piggy hacks in
> > the generic ofpart.c driver, but what we could do however is a DT
> > fixup in the init_machine (or the dt_fixup) hook for imx7 Colibri, very
> > much like this:
> > https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/boar=
d-v7.c#L111
> > Plus a warning there saying "your dt is broken, update your firmware". =
=20
>=20
> This does not work, because the old U-Boot fixup_mtdparts() may be applie=
d on any machine,

No: https://elixir.bootlin.com/u-boot/latest/A/ident/fdt_fixup_mtdparts
And we should make our best so its use does not proliferate.
It's not like there is half a dozen of good ways to describe and forward
partitions today.

> it is not colibri mx7 specific. Also, new arch-side workaround are
> really not welcome by the architecture maintainers as far as I can
> tell.

So what? Let's propose the change and see what the maintainers have to
say. I am open to discussion.

As I said, it is not colibri mx7 specific, there are a few boards which
might be affected, they are all clearly identifiable with a compatible.
It's not the entire planet either.

> > So next time someone stumbles upon this issue, we can tell them "fix
> > your bootloader", and apply the same hack in their board family (there
> > are three or four IIRC which might be concerned some day). =20
>=20
> There are also those machines we do not even know about which might be ge=
nerating bogus DT using old U-Boot and fixup_mtdparts(), so, unless there i=
s some all-arch fixup implementation, we wouldn't be able to fix them all o=
n arch side. I think the all-arch fixup implementation would be the driver =
one, i.e. this patch as it is (or maybe with some improvement).

If we don't know about them, as you say, I don't feel concerned.

If something is buggy, people will report it, we will point them in the
right direction so they can fix their firmware and propose a similar
fix in their case which will involve adding a new machine compatible to
the list of boards that should tweak the #size-cell property.

> > That would fix all cases and only have an impact on the affected boards=
. =20
>=20
> Sadly, it does only fix the known cases, not the unknown cases like downs=
tream forks which never get any bootloader updates ever, and which you can'=
t find in upstream U-Boot, and which you therefore cannot easily catch in t=
he arch side fixup.

And ?

Thanks,
Miqu=C3=A8l
