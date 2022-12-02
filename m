Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7C640AFF
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiLBQnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiLBQnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:43:05 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD2CBE4DB
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 08:43:02 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E70B9E0008;
        Fri,  2 Dec 2022 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669999381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qzZdYWOBBoSv1bjeFreDloIADPQqX2dduLQgUUoXtj0=;
        b=RBG7jnhuQUO0w4/BrZr85FPKBqGguvX1wKjZi2R9g34YjMeUywCk4118bn5RXETNBddJ5L
        Z3iywTG/ZbZgBA68bFcbA1ARlPnPwcGdaX4B1UYsIqaGARRK5U2Ci9AKjWUYMrQO0+IZcC
        EvQ9k4MHGKzZFFlcRyRsZtZGM+RhNYuk6PdJ2BhUP4vNe25QzNUbqsG7VILEPx1zlc9lRH
        ZPhT41LpHukvhtmeVtAasCkLXU29SM4Svu1yjrnTJ5brHWtB7rqxoGxTnvD13C+hf+fX4Z
        23GNrQ31tU7cATdl2X4jBex6vq0ewDvSNdHtwMelmcbr/nI8+qc3sbdYjSuhQw==
Date:   Fri, 2 Dec 2022 17:42:55 +0100
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
Message-ID: <20221202174255.2c1cb2ff@xps-13>
In-Reply-To: <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
References: <20221202071900.1143950-1-francesco@dolcini.it>
        <20221202101418.6b4b3711@xps-13>
        <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
        <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
        <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
        <20221202164904.08d750df@xps-13>
        <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
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

Hi Marek,

marex@denx.de wrote on Fri, 2 Dec 2022 17:17:59 +0100:

> On 12/2/22 16:49, Miquel Raynal wrote:
> > Hi Marek, =20
>=20
> Hi,
>=20
> >> On 12/2/22 16:00, Miquel Raynal wrote: =20
> >>> Hi Marek, =20
> >>
> >> Hi,
> >> =20
> >>> marex@denx.de wrote on Fri, 2 Dec 2022 15:31:40 +0100: =20
> >>>    >>>> On 12/2/22 15:05, Miquel Raynal wrote: =20
> >>>>> Hi Francesco, =20
> >>>>
> >>>> Hi,
> >>>>
> >>>> [...] =20
> >>>>   >>>>> I still strongly disagree with the initial proposal but what=
 I think we =20
> >>>>> can do is:
> >>>>>
> >>>>> 1. To prevent future breakages:
> >>>>>      Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
> >>>>>      kernel should work.
> >>>>>
> >>>>> 2. To help tracking down situations like that:
> >>>>>      Keep the warning in ofpart.c but continue to fail.
> >>>>>
> >>>>> 3. To fix the current situation:
> >>>>>       Immediately revert commit (and prevent it from being backport=
ed):
> >>>>>       753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells=
")
> >>>>>       This way your own boot flow is fixed in the short term. =20
> >>>>
> >>>> Here I disagree, the fix is correct and I think we shouldn't
> >>>> proliferate incorrect DTs which don't match the binding document. =20
> >>>
> >>> I agree we should not proliferate incorrect DTs, so let's use a modern
> >>> description then =20
> >>
> >> Yes please !
> >> =20
> >>> , with a controller and a child node which defines the
> >>> chip. =20
> >>
> >> But what if there is no chip connected to the controller node ?
> >>
> >> If I understand the proposal here right (please correct me if I'm wron=
g), then: =20
> >=20
> > Good idea to summarize.
> >  =20
> >>
> >> 1) This is the original, old, wrong binding:
> >> &gpmi {
> >>     #size-cells =3D <1>;
> >>     ...
> >>     partition@N { ... };
> >> }; =20
> >=20
> > Yes.
> >  =20
> >>
> >>
> >> 2) This is the newer, but still wrong binding:
> >> &gpmi {
> >>     #size-cells =3D <0>;
> >>     ...
> >>     partitions {
> >>       partition@N { ... };
> >>     };
> >> }; =20
> >=20
> > Well, this is wrong description, but it would work (for compat reasons,
> > even though I don't think this is considered valid DT by the schemas).
> >  =20
> >>
> >> 3) This is the newest binding, what we want:
> >> &gpmi {
> >>     #size-cells =3D <0>;
> >>     ...
> >>     nand-chip {
> >>       partitions {
> >>         partition@N { ... };
> >>       };
> >>     };
> >> }; =20
> >=20
> > Yes
> >  =20
> >>
> >> But if there is no physical nand chip connected to the controller, wou=
ld we end up with empty nand-chip node in DT, like this?
> >> &gpmi {
> >>     #size-cells =3D <X>;
> >>     ...
> >>     nand-chip { /* empty */ };
> >> }; =20
> >=20
> > Is this really a concern? =20
>=20
> I don't know, maybe it is not.
>=20
> > If there is no NAND chip, the controller
> > should be disabled, no? I guess technically you could even use the
> > status property in the nand-chip node... =20
>=20
> Sure.
>=20
> > However, it should not be empty, at the very least a reg property
> > should indicate on which CS it is wired, as expected there:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Docu=
mentation/devicetree/bindings/mtd/nand-chip.yaml?h=3Dmtd/next =20
>=20
> OK, I see your point. So basically this?
>=20
> &gpmi {
>    #size-cells =3D <1>;
>    ...
>    nand-chip@0 {
>      reg =3D <0>;
>    };
> };
>=20
> btw. the GPMI NAND controller supports only one chipselect, so the reg in=
 nand-chip node makes little sense.

I randomly opened a reference manual (IMX6DQL.pdf), they say:

	"Up to four NAND devices, supported by four chip-selects and one
	 ganged ready/ busy."

Anyway, the NAND controller generic bindings which require this reg
property, what the controller or the driver actually supports, or even
how it is used on current designs is not relevant here.

> > But, as nand-chip.yaml references mtd.yaml, you can as well use
> > whatever is described here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Docu=
mentation/devicetree/bindings/mtd/mtd.yaml?h=3Dmtd/next
> >  =20
> >> What would be the gpmi controller size cells (X) in that case, still 0=
, right ? So how does that help solve this problem, wouldn't U-Boot still p=
opulate the partitions directly under the gpmi node or into partitions sub-=
node ? =20
> >=20
> > The commit that was pointed in the original fix clearly stated that the
> > NAND chip node was targeted =20
>=20
> I think this is another miscommunication here. The commit
>=20
> 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>=20
> modifies the size-cells of the NAND controller. The nand-chip is not invo=
lved in this at all . In the examples above, it's the "&gpmi" node size-cel=
ls that is modified.

Yes I know. I was referring to this commit, sorry:
36fee2f7621e ("common: fdt_support: add support for "partitions" subnode to=
 fdt_fixup_mtdparts()")

The log says:

	Listing MTD partitions directly in the flash mode has been
	deprecated for a while for kernel Device Trees. Look for a node "partition=
s" in the
	found flash nodes and use it instead of the flash node itself for the
	partition list when it exists, so Device Trees following the current
	best practices can be fixed up.

Which (I hope) means U-boot will equivalently try to play with the
partitions container, either in the controller node or in the chip node.

> > , not the NAND controller node. I hope this
> > is correctly supported in U-Boot though. So if there is a NAND chip
> > subnode, I suppose U-Boot would try to create the partitions that are
> > inside, or even in the sub "partitions" container. =20
>=20
> My understanding is that U-Boot checks the nand-controller node size-cell=
s, not the nand-chip{} or partitions{} subnode size-cells .

I don't think U-Boot cares.

> Francesco, can you please share the DT, including the U-Boot generated pa=
rtitions, which is passed to Linux on Colibri MX7 ? I think that should mak=
e all confusion go away.

Please also do it with the NAND chip described. If, when the NAND chip
is described U-Boot tries to create partitions in the controller node,
then the situation is even worse than I thought. But I believe
describing the node like a suggest in the DT should prevent the boot
failure while still allowing a rather good description of the hardware.

BTW I still think the relevant action right now is to revert the DT
patch.

Thanks,
Miqu=C3=A8l
