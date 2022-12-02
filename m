Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A600640B7A
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiLBQ7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiLBQ7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:59:12 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F3DE1B
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 08:57:38 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B8260240007;
        Fri,  2 Dec 2022 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670000257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=etV1734mfvPax6/p8v/lvQ2TEAFZx3vL9Ncfy36x1/M=;
        b=JF2tgYrz642xaQPLHkiGmJiM2nH0qI2IHlE76bzooVceCMHmb7QZgLxZF5riFGnWRFvSH9
        fsS4w4LchSvYci+mJxBBYsIXv1HXLpUJG7iYOKDRaec1w/9pQLTI8BUaZrX/KWcZ++Lzll
        mlAgYG6ZLgswg75Z6z6AkWsWENqSguNArHyN3GGBYwrGvSIhSQHMd2qQqn45wJ0ucXTodE
        4ctUpyP48csCXvIK67y1LcP4tEH5Jvcp/YvofnFe2FZPjjh+aqXQB5xaFi5J1ZEB0vrV7U
        BM9LrHjT/7QceVfVEbfmn+lu7TLCvx/ESJR64j2TxlFJj1p6kC6uSLABYxuJgg==
Date:   Fri, 2 Dec 2022 17:57:30 +0100
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
Message-ID: <20221202175730.231d75d5@xps-13>
In-Reply-To: <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
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
        <20221202174255.2c1cb2ff@xps-13>
        <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

marex@denx.de wrote on Fri, 2 Dec 2022 17:52:05 +0100:

> On 12/2/22 17:42, Miquel Raynal wrote:
> > Hi Marek, =20
>=20
> Hi,
>=20
> [...]
>=20
> >>> However, it should not be empty, at the very least a reg property
> >>> should indicate on which CS it is wired, as expected there:
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Do=
cumentation/devicetree/bindings/mtd/nand-chip.yaml?h=3Dmtd/next =20
> >>
> >> OK, I see your point. So basically this?
> >>
> >> &gpmi {
> >>     #size-cells =3D <1>;
> >>     ...
> >>     nand-chip@0 {
> >>       reg =3D <0>;
> >>     };
> >> };
> >>
> >> btw. the GPMI NAND controller supports only one chipselect, so the reg=
 in nand-chip node makes little sense. =20
> >=20
> > I randomly opened a reference manual (IMX6DQL.pdf), they say:
> >=20
> > 	"Up to four NAND devices, supported by four chip-selects and one
> > 	 ganged ready/ busy." =20
>=20
> Doh, and MX7D has the same controller, so size-cells =3D <1>; makes sense=
 with nand-chip@N {} .

Actually #address-cells is here for that. You need to point at one CS,
so in most cases this is:

controller {
	#address-cells =3D <1>;
	#size-cells =3D <0>;
	chip@N {
		reg =3D <N>;
	};
};

>=20
> > Anyway, the NAND controller generic bindings which require this reg
> > property, what the controller or the driver actually supports, or even
> > how it is used on current designs is not relevant here.
> >  =20
> >>> But, as nand-chip.yaml references mtd.yaml, you can as well use
> >>> whatever is described here:
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Do=
cumentation/devicetree/bindings/mtd/mtd.yaml?h=3Dmtd/next =20
> >>>    >>>> What would be the gpmi controller size cells (X) in that case=
, still 0, right ? So how does that help solve this problem, wouldn't U-Boo=
t still populate the partitions directly under the gpmi node or into partit=
ions sub-node ? =20
> >>>
> >>> The commit that was pointed in the original fix clearly stated that t=
he
> >>> NAND chip node was targeted =20
> >>
> >> I think this is another miscommunication here. The commit
> >>
> >> 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> >>
> >> modifies the size-cells of the NAND controller. The nand-chip is not i=
nvolved in this at all . In the examples above, it's the "&gpmi" node size-=
cells that is modified. =20
> >=20
> > Yes I know. I was referring to this commit, sorry:
> > 36fee2f7621e ("common: fdt_support: add support for "partitions" subnod=
e to fdt_fixup_mtdparts()")
> >=20
> > The log says:
> >=20
> > 	Listing MTD partitions directly in the flash mode has been
> > 	deprecated for a while for kernel Device Trees. Look for a node "parti=
tions" in the
> > 	found flash nodes and use it instead of the flash node itself for the
> > 	partition list when it exists, so Device Trees following the current
> > 	best practices can be fixed up.
> >=20
> > Which (I hope) means U-boot will equivalently try to play with the
> > partitions container, either in the controller node or in the chip node.
> >  =20
> >>> , not the NAND controller node. I hope this
> >>> is correctly supported in U-Boot though. So if there is a NAND chip
> >>> subnode, I suppose U-Boot would try to create the partitions that are
> >>> inside, or even in the sub "partitions" container. =20
> >>
> >> My understanding is that U-Boot checks the nand-controller node size-c=
ells, not the nand-chip{} or partitions{} subnode size-cells . =20
> >=20
> > I don't think U-Boot cares.
> >  =20
> >> Francesco, can you please share the DT, including the U-Boot generated=
 partitions, which is passed to Linux on Colibri MX7 ? I think that should =
make all confusion go away. =20
> >=20
> > Please also do it with the NAND chip described. If, when the NAND chip
> > is described U-Boot tries to create partitions in the controller node,
> > then the situation is even worse than I thought. But I believe
> > describing the node like a suggest in the DT should prevent the boot
> > failure while still allowing a rather good description of the hardware.
> >=20
> > BTW I still think the relevant action right now is to revert the DT
> > patch. =20
>=20
> I am starting to bank toward that variant as well (thanks for clarifying =
the rationale in the discussion, that helped a lot).
>=20
> But then, the follow up fix would be what exactly, update the binding doc=
ument to require #size-cells =3D <1>; ?


Thanks,
Miqu=C3=A8l
