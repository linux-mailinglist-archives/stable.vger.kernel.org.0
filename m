Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8763640BB0
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiLBRF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiLBRFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:05:36 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6F1D6782
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 09:05:33 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5889C2000B;
        Fri,  2 Dec 2022 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670000732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1543kr1BA4zVd3F4HG1WX2ZdFskLZROQv8ZbH894QY=;
        b=bJtZ3brfsuLZSQYMU4sy32nmifcHeTf/6v1x+/CYbuJJI2X7aPsIPm/19mV2M9HZQP4D65
        fu44hQSe+aSJYv3KaBvqKrxW25O9O62XyAf/BQWc7laFGOuTHdR6zkWRAAMj+TvTOiDNhn
        ySYzOnSxKfYHMm3tqARzEaDKXkYF55u4qTk8W9drYoFqf+Mvf1xurkFCm3SkQGE2kCLXOL
        toa1diIN7oYoGXHGAQM/r1K3bYsS8kSvsRFdK52KCuKV0/dhdhOulj2L2jgt1DFjjGRd0K
        RRbw5pYhLDOp2dnSHiQDIKeZ1MKWeEa8Win6fzNtbdt/7ZVQWkLTu+T2BV6OAg==
Date:   Fri, 2 Dec 2022 18:05:28 +0100
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
Message-ID: <20221202180528.173ee343@xps-13>
In-Reply-To: <Y4orsUIp3Ffz8m+r@francesco-nb.int.toradex.com>
References: <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
        <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
        <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
        <20221202164904.08d750df@xps-13>
        <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
        <Y4orsUIp3Ffz8m+r@francesco-nb.int.toradex.com>
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

Hi Francesco,

francesco@dolcini.it wrote on Fri, 2 Dec 2022 17:45:37 +0100:

> On Fri, Dec 02, 2022 at 05:17:59PM +0100, Marek Vasut wrote:
> > On 12/2/22 16:49, Miquel Raynal wrote: =20
> > > , not the NAND controller node. I hope this
> > > is correctly supported in U-Boot though. So if there is a NAND chip
> > > subnode, I suppose U-Boot would try to create the partitions that are
> > > inside, or even in the sub "partitions" container. =20
> >=20
> > My understanding is that U-Boot checks the nand-controller node size-ce=
lls,
> > not the nand-chip{} or partitions{} subnode size-cells . =20
> Not 100% correct.
>=20
>  - U-Boot before v2022.04 updates the nand-controller{} node, no matter w=
hat.
>  - U-Boot starting from v2022.04 looks for `partitions{}` into the
>    nand-controller{} node, and creates the partition into it if found.
>    If not found it behaves the same way as the previous versions.
>    See commit 36fee2f7621e ("common: fdt_support: add support for "partit=
ions" subnode to fdt_fixup_mtdparts()")
>=20
> I'd like to stress once more the fact that we cannot expect old U-Boot
> to be updated in the field, and they will keep generating the partitions
> as child of the nand-controller node whatever we do with the dts file.
>=20
> I think that this should be treated the same way as any other fixup we
> might have for broken firmware, especially considering that this used to
> "work" (yes, I can agree that it horrible, but I cannot change the past)
> without even a warning since the imx7 support was first introduced in
> the linux kernel years ago.
>=20
> > Francesco, can you please share the DT, including the U-Boot generated
> > partitions, which is passed to Linux on Colibri MX7 ? I think that shou=
ld
> > make all confusion go away. =20
>=20
> The device tree part is easy, just
> arch/arm/boot/dts/imx7d-colibri-eval-v3.dts.
>=20
> and the nand-controller node is coming from
>=20
> #include "imx7d.dtsi"
>=20
> plus
>=20
> &gpmi {
> 	fsl,use-minimum-ecc;
> 	nand-ecc-mode =3D "hw";
> 	nand-on-flash-bbt;
> 	pinctrl-names =3D "default";
> 	pinctrl-0 =3D <&pinctrl_gpmi_nand>;
> };
>=20
> The partitions nodes are generated 100% by U-Boot, nothing is present in
> the dts source files.

I hope if you provide a NAND chip child node, the partitions are created
at the right location, otherwise this is so, so wrong...

>=20
> With this DTS file as input, whatever U-Boot version is used I have the
> following generated:
>=20
> root@colibri-imx7-02844233:/# ls /proc/device-tree/soc/nand-controller@33=
002000/
> #address-cells          dma-names               nand-on-flash-bbt       p=
inctrl-0
> #size-cells             dmas                    partition@0             p=
inctrl-names
> assigned-clock-parents  fsl,use-minimum-ecc     partition@200000        r=
eg
> assigned-clocks         interrupt-names         partition@380000        r=
eg-names
> clock-names             interrupts              partition@400000        s=
tatus
> clocks                  name                    partition@80000
> compatible              nand-ecc-mode           phandle
>=20
> root@colibri-imx7-02844233:/# ls /proc/device-tree/soc/nand-controller@33=
002000/partition@*
> /proc/device-tree/soc/nand-controller@33002000/partition@0:
> label  name   reg
>=20
> /proc/device-tree/soc/nand-controller@33002000/partition@200000:
> label      name       read_only  reg
>=20
> /proc/device-tree/soc/nand-controller@33002000/partition@380000:
> label  name   reg
>=20
> /proc/device-tree/soc/nand-controller@33002000/partition@400000:
> label  name   reg
>=20
> /proc/device-tree/soc/nand-controller@33002000/partition@80000:
> label      name       read_only  reg
>=20
>=20


Thanks,
Miqu=C3=A8l
