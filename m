Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC440640B08
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiLBQpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiLBQpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:45:43 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04579C82DE
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 08:45:41 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 950A9561702;
        Fri,  2 Dec 2022 17:45:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669999539;
        bh=rDhRZkMjIul++T92YcO2Em+dmofCRBVb85rkOgmruxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=brl/D33BjmmEo+v9O60MrEkcqNX1LUCyi3J5i7ekEAiLZ0+Et6Xn0uYg7MPhb/366
         MSa899RvLnw8xESwV7CYiDJXThx+hzkh6OgQ+ohuMShZJfi/3BCh/HQCWP43ixim7V
         FVQH9AjcVFHPiBp6BuE+TjZgZJ73655183ySlZgASo7Rp11nJb3eBsUGTszlc+tV3u
         WdgFBtipHim65efataTitg5XzOCacT6epsZNuZqosoF1qaJHisO90yWkRwD1HSzcaX
         MNn+6upbFBRHZRlyc1+Fy5+/Zc6VYn+rgxA78KjszyIXquF3xtOM1Yy4okayVD7Eb9
         7RSTgeyGdtNzg==
Date:   Fri, 2 Dec 2022 17:45:37 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y4orsUIp3Ffz8m+r@francesco-nb.int.toradex.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 05:17:59PM +0100, Marek Vasut wrote:
> On 12/2/22 16:49, Miquel Raynal wrote:
> > , not the NAND controller node. I hope this
> > is correctly supported in U-Boot though. So if there is a NAND chip
> > subnode, I suppose U-Boot would try to create the partitions that are
> > inside, or even in the sub "partitions" container.
> 
> My understanding is that U-Boot checks the nand-controller node size-cells,
> not the nand-chip{} or partitions{} subnode size-cells .
Not 100% correct.

 - U-Boot before v2022.04 updates the nand-controller{} node, no matter what.
 - U-Boot starting from v2022.04 looks for `partitions{}` into the
   nand-controller{} node, and creates the partition into it if found.
   If not found it behaves the same way as the previous versions.
   See commit 36fee2f7621e ("common: fdt_support: add support for "partitions" subnode to fdt_fixup_mtdparts()")

I'd like to stress once more the fact that we cannot expect old U-Boot
to be updated in the field, and they will keep generating the partitions
as child of the nand-controller node whatever we do with the dts file.

I think that this should be treated the same way as any other fixup we
might have for broken firmware, especially considering that this used to
"work" (yes, I can agree that it horrible, but I cannot change the past)
without even a warning since the imx7 support was first introduced in
the linux kernel years ago.

> Francesco, can you please share the DT, including the U-Boot generated
> partitions, which is passed to Linux on Colibri MX7 ? I think that should
> make all confusion go away.

The device tree part is easy, just
arch/arm/boot/dts/imx7d-colibri-eval-v3.dts.

and the nand-controller node is coming from

#include "imx7d.dtsi"

plus

&gpmi {
	fsl,use-minimum-ecc;
	nand-ecc-mode = "hw";
	nand-on-flash-bbt;
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_gpmi_nand>;
};

The partitions nodes are generated 100% by U-Boot, nothing is present in
the dts source files.

With this DTS file as input, whatever U-Boot version is used I have the
following generated:

root@colibri-imx7-02844233:/# ls /proc/device-tree/soc/nand-controller@33002000/
#address-cells          dma-names               nand-on-flash-bbt       pinctrl-0
#size-cells             dmas                    partition@0             pinctrl-names
assigned-clock-parents  fsl,use-minimum-ecc     partition@200000        reg
assigned-clocks         interrupt-names         partition@380000        reg-names
clock-names             interrupts              partition@400000        status
clocks                  name                    partition@80000
compatible              nand-ecc-mode           phandle

root@colibri-imx7-02844233:/# ls /proc/device-tree/soc/nand-controller@33002000/partition@*
/proc/device-tree/soc/nand-controller@33002000/partition@0:
label  name   reg

/proc/device-tree/soc/nand-controller@33002000/partition@200000:
label      name       read_only  reg

/proc/device-tree/soc/nand-controller@33002000/partition@380000:
label  name   reg

/proc/device-tree/soc/nand-controller@33002000/partition@400000:
label  name   reg

/proc/device-tree/soc/nand-controller@33002000/partition@80000:
label      name       read_only  reg


