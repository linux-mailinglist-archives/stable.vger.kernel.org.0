Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9C64082B
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiLBOGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiLBOGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:06:09 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F0D49E3
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:06:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4AD82C000C;
        Fri,  2 Dec 2022 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669989962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZwPEMsk3iVcTfUXNdycqjkaeCLeKIl6lTS9C9qSpeY=;
        b=dJGlFM1SPaZ0j4uLBbGbxgKUblaYsQLr5YrT2BSK3A1nuo3y9JG9Q/5QhiMBjktFaO/s70
        SoiD44DKRpmIDGgV7NIOG33BGza4c1Q4OfXl6yGiEAmmN3dSBAu5ddGqDEDOMLaK9JucmJ
        Xrh8f4GjrutJeQtwukF5d7YKQCvc96X+cx4lCApCm24h/UUrJIIY6EF1v5cfp8skADsJO1
        Ev9y7UT7NV5qSGIxLk+tgjxj7gFSzcZMla/7nbB6n5eZFrul6PtOKoqTbSqly6lQEug62a
        5THDLsB6zrFT5ZpKGStEumqdEyxb+kKiNBzHgUaeFI5SojQeXbQcJvb0Hyy6KQ==
Date:   Fri, 2 Dec 2022 15:05:56 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20221202150556.14c5ae43@xps-13>
In-Reply-To: <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
References: <20221202071900.1143950-1-francesco@dolcini.it>
        <20221202101418.6b4b3711@xps-13>
        <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
        <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
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

francesco@dolcini.it wrote on Fri, 2 Dec 2022 12:23:37 +0100:

> + u-boot list
>=20
> On Fri, Dec 02, 2022 at 11:53:27AM +0100, Miquel Raynal wrote:
> > francesco@dolcini.it wrote on Fri, 2 Dec 2022 11:24:29 +0100: =20
> > > On Fri, Dec 02, 2022 at 11:12:43AM +0100, Francesco Dolcini wrote: =20
> > > > On Fri, Dec 02, 2022 at 10:14:18AM +0100, Miquel Raynal wrote:   =20
> > > > > francesco@dolcini.it wrote on Fri,  2 Dec 2022 08:19:00 +0100:   =
=20
> > > > > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > > > >=20
> > > > > > Add a fallback mechanism to handle the case in which #size-cell=
s is set
> > > > > > to <0>. According to the DT binding the nand controller node sh=
ould have
> > > > > > set it to 0 and this is not compatible with the legacy way of
> > > > > > specifying partitions directly as child nodes of the nand-contr=
oller node.   =20
> > > > >=20
> > > > > I understand the problem, I understand the fix, but I have to say=
, I
> > > > > strongly dislike it :) Touching an mtd core driver to fix a single
> > > > > broken use case like that is... problematic, for the least.   =20
> > > > I just noticed it 2 days after this patch was backported to a stable
> > > > kernel, I am just the first one to notice, we are not talking about=
 a single
> > > > use case.
> > > >    =20
> > > > > I am sorry but if a 6.0 kernel breaks because:   =20
> > > > Not only kernel 6.0 is currently broken. This patch is going to be
> > > > backported to any stable kernel given the fixes tag it has.
> > > >    =20
> > > > > If you really want to workaround U-Boot, either you revert that p=
atch
> > > > > or you just fix the DT description instead. The parent/child/part=
itions
> > > > > scheme has been enforced for maybe 5 years now and for a good rea=
son: a
> > > > > NAND controller with partitions does not make _any_ sense. There =
are
> > > > > plenty of examples out there, imx7-colibri.dtsi has received many
> > > > > updates since its introduction (for the best), so why not this on=
e?   =20
> > > >=20
> > > > I can and I will update imx7-colibri.dtsi (patch coming), =20
> >=20
> > :thumb_up:
> >  =20
> > > > but is this
> > > > good enough given the kind of boot failure regression this introduc=
e? We
> > > > are going to have old u-boot around that will not work with it, and=
 the   =20
> > >=20
> > > Just another piece of information, support for the partitions node in
> > > U-Boot was added in version v2022.04 [1], we are not talking about an=
cient
> > > old legacy stuff. =20
> >=20
> > If it is so recent, then this is what needs to be fixed, and it should
> > not bother "many" people because 2022.04 is not so old.
> >=20
> > So I am a bit lost, IIUC what is currently broken is:
> > - U-Boot > 2022.04 and any version of Linux with the backport?
> >  =20
> > > If I add the partitions node as a child of my nand controller, as I w=
as
> > > planning to do and I wrote 10 lines above, I will create a new flavor=
 of
> > > non-booting system with U-Boot older than v2022.04 :-/ =20
> >=20
> > I think there is a little confusion here. You are referring to the NAND=
 =20
> I guess I have not explained myself well enough :-)

Ok, there is still a confusion. Even though I think your logic still
applies, I want to emphasis on how wrong it is to define partitions in
the NAND _controller_ node rather than the NAND _chip_ node. And I
think this might have an impact on our final choice.

> U-Boot is creating the partitions in the dtb, they are not defined in
> the source dts file (this is common practice with multiple boards).

That fdt_fixup_mtdparts() thing is a mistake. The original idea is:

1. Define wrong nodes in your DT
2. Fix your DT at run time in U-Boot
3. Provide the "fixed" DT to Linux

Now step #2 now produces wrong FDT. So what, we should darken even
more the of partition driver in Linux to workaround it? At most what we
can do is warn the user so that people don't loose time understanding
what happens, but I am against supporting this, ever.

> Before v2022.04 it was always updating the nand-controller node,
> starting from v2022.04 if there is a dedicated `partitions` node it uses
> it.

Sounds reasonable.

> This is just the reverse of what ofpart_core.c is doing (if the
> partitions node is there it assumes the partitions should go into it,
> otherwise it proceeds with the legacy way).

Yes, that's how we handle legacy bindings.

> Let's have a concrete example with colibri-imx7.
>=20
> Current status:
>  - The nand-controller node does not include any partitions child, any
>    U-Boot version will just add the partition directly as child of the
>    nand controller. This is where I am hitting this boot regression now.

Not exactly. It worked until now because your original DT already
included #size-cells =3D <1> I believe. It does not do that anymore and
that is why you get your boot regression: because the DT was modified.

The reason why the DT got modified however is interesting. The commit
log says the goal is to comply with modern bindings, which is great.
But if you break how your board boots, then you should probably not do
that. And if we really care about complying with the bindings, there
is something much more interesting than fixing a single property:
distinguishing the NAND controller vs. the NAND chip(s), which has been
enforced since 2016 (which probably predates the imx7-colibri.dtsi, but
whatever):
2d472aba15ff ("mtd: nand: document the NAND controller/NAND chip DT represe=
ntation")

> Potential change I envisioned here:
>  - I add the partitions node to the nand-controller, e.g.
>=20
> --- a/arch/arm/boot/dts/imx7-colibri.dtsi
> +++ b/arch/arm/boot/dts/imx7-colibri.dtsi
> @@ -380,6 +380,12 @@ &gpmi {
>         nand-on-flash-bbt;
>         pinctrl-names =3D "default";
>         pinctrl-0 =3D <&pinctrl_gpmi_nand>;
> +
> +       partitions {
> +               compatible =3D "fixed-partitions";
> +               #address-cells =3D <1>;
> +               #size-cells =3D <1>;
> +       };
>  };
>=20
>  - U-Boot >=3D v2022.04 will just work fine creating the partitions as
>    currently described in the bindings.
>  - U-Boot < v2022.04 will still create the partitions as child of the
>    nand-controller node. Linux will see that a `partitions` node exists
>    but it will be empty, leading to a boot failure in case mtd is used
>    as boot device.
>=20
>=20
> > controller node, the commit refers to the NAND chip node. What this
> > commit does looks fine because it just tries to use the partitions {}
> > node rather than the NAND chip node and if the partitions {} node
> > already exist, I expect #address-cells and #size-cells to be defined
> > and be !=3D 0 already. =20
> yes, this commit is perfectly fine I agree.
>=20
> The reality is that people is using newer kernel with older U-Boot, and
> I do not think that deliberately breaking this use case is what the
> Linux kernel should do.

Agreed.

> I do not think that I can push a change in the DTS that will break
> booting any board using an older U-Boot.

That's however the initial cause of this discovery. A DT change broke
your boot flow. I'm saying "your" boot flow because I am not sure it
affects "any" board.

For now it only affects the imx7 colibri boards because of:
753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")

But all these boards could be affected in the same way because of some
machine code playing with fdt_fixup_mtdparts():
* arch/arm/mach-uniphier/fdt-fixup.c
* board/compulab/cm_fx6/cm_fx6.c
* board/gateworks/gw_ventana/gw_ventana.c
* board/isee/igep003x/board.c
* board/isee/igep00x0/igep00x0.c
* board/phytec/phycore_am335x_r2/board.c
* board/st/stm32mp1/stm32mp1.c
* board/toradex/colibri-imx6ull/colibri-imx6ull.c
* board/toradex/colibri_imx7/colibri_imx7.c
* board/toradex/colibri_vf/colibri_vf.c
That's of course way too much possible failures.

I still strongly disagree with the initial proposal but what I think we
can do is:

1. To prevent future breakages:=20
  Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
  kernel should work.

2. To help tracking down situations like that:
  Keep the warning in ofpart.c but continue to fail.

3. To fix the current situation:
   Immediately revert commit (and prevent it from being backported):
   753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
   This way your own boot flow is fixed in the short term.

4. There is no reason to partially fix a DT like what the above did
   besides trying to avoid warnings emitted by the DT check tools. If
   complying with modern bindings is a goal (and I think it should
   be), then we can modernize this DT without breaking the boot flow:
   Instead of only setting #size-cell =3D <0>, you can as well define
   in your DT a subnode to define the NAND chip. NAND chips are not
   supposed to have #size-cells properties, but in the past they did,
   which means #address-cells and #size-cells are allowed (and marked
   deprecated in the schema). So in practice, the dt-schema will not
   warn you if they are there, which means you can still set
   #size-cell =3D <1>.

   Please mind, the tools have been updated very recently to match
   what I am describing above, so they will likely still report
   errors until v6.2-rc1, see:
   https://lore.kernel.org/linux-mtd/20221114090315.848208-1-miquel.raynal@=
bootlin.com/

Does this sound reasonable?

Thanks,
Miqu=C3=A8l
