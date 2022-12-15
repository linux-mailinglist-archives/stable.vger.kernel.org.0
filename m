Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4064D727
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 08:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLOHQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 02:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiLOHQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 02:16:12 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F61D3D3B3
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 23:16:08 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8CECA24000B;
        Thu, 15 Dec 2022 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671088566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjs0BTHy5OYclPFTcRH7p3xakt32ngPq+Fwkx7p7KHI=;
        b=kZsaGY2H83YUuoYv/we8kuEoU3b3UErQPfDWT+qLA0VINHWSV9XEQMNkJePzKpzkWLoJ/z
        3WbhCAIIkOuTeUQ8i5Jyu3ALGQV96TdxtI/+TWV1CMzL8zOTH+xTZa6IvsWNk/NE+YKh18
        79Eb2pMCRkM77kv9Nl55Aoympy71iQZ9kJhZI7iChhCdsxC3vDrNeoHy8CBByCNPbQYtvI
        jAfQdqt9rLUPyHalmRp8QRxk2MDZLMXgRZf8vJ5Z8OFa9KODjBBpgDIgvwPWQcV5a0Ahqv
        1b0/2s6r5kHfQO3DTM5ptACGEjSUhg+A/6tk8DkqTP6cjNq+Byr+k1leq8TvWA==
Date:   Thu, 15 Dec 2022 08:16:04 +0100
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
Message-ID: <20221215081604.5385fa56@xps-13>
In-Reply-To: <ecca019d-b0b7-630c-4221-2684cb51634c@denx.de>
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

Hi Marek & Francesco,

marex@denx.de wrote on Mon, 5 Dec 2022 17:25:11 +0100:

> On 12/5/22 14:49, Miquel Raynal wrote:
> > Hi Francesco, =20
>=20
> Hi,
>=20
> > francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:26:44 +0100:
> >  =20
> >> On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote: =20
> >>> But here I would say this is a firmware bug and it might have to be h=
andled
> >>> like a firmware bug, i.e. with fixup in the partition parser. I seem =
to be
> >>> changing my opinion here again. =20
> >>
> >> I was thinking at this over the weekend, and I came to the following
> >> ideas:
> >>
> >>   - we need some improvement on the fixup we already have in the
> >>     partition parser. We cannot ignore the fdt produced by U-Boot - as
> >>     bad as it is.
> >>   - the proposed fixup is fine for the immediate need, but it is
> >>     not going to be enough to cover the general issue with the U-Boot
> >>     generated partitions. U-Boot might keep generating partitions as d=
irect
> >>     child of the nand controller even when a partitions{} node is
> >>     available. In this case the current parser just fails since it loo=
ks
> >>     only into it and it will find it empty.
> >>   - the current U-Boot only handle partitions{} as a direct child of t=
he
> >>     nand-controller, the nand-chip is ignored. This is not the way it =
is
> >>     supposed to work. U-Boot code would need to be improved. =20
> >=20
> > I've been thinking about it this weekend as well and the current fix
> > which "just set" s_cell to 1 seems risky for me, it is typically the
> > type of quick & dirty fix that might even break other board (nobody
> > knew that U-Boot current logic expected #size-cells to be set in the
> > DT, what if another "broken" DT expects the opposite...) =20
>=20
> Then with the current configuration, such broken DT would not work, since=
 current DT does set #size-cells=3D<1> (wrongly).
>=20
> > , not
> > mentioning potential issues with big storages (> 4GiB).
> >=20
> > All in all, I really think we should revert the DT change now, reverting
> > as little to no drawbacks besides a dt_binding_check warning and gives
> > us time to deal with it properly (both in U-Boot and Linux). =20
>=20
> I am really not happy with this, but if that's marked as intermediate fix=
, go for it.
>=20
> How do we deal with this in the long run however? Parser-side fix like th=
is one, maybe with better heuristics ?

Yesterday while talking about an ACPI mis-description which needed
fixing, I realized fixing up what the firmware provides to Linux should
preferably be handled as early as possible. So my first first idea was
to avoid using the broken "fixup mtdparts" function in U-Boot and I am
still convinced this is what we should do in priority. However, as
rightly pointed in this thread, we need to take care about the case
where someone would use a newer DT (let's say, with the reverted changed
reverted again) with an old U-Boot. I am still against piggy hacks in
the generic ofpart.c driver, but what we could do however is a DT
fixup in the init_machine (or the dt_fixup) hook for imx7 Colibri, very
much like this:
https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/board-v7=
.c#L111
Plus a warning there saying "your dt is broken, update your firmware".

So next time someone stumbles upon this issue, we can tell them "fix
your bootloader", and apply the same hack in their board family (there
are three or four IIRC which might be concerned some day).

That would fix all cases and only have an impact on the affected boards.

Thanks,
Miqu=C3=A8l
