Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F95E63EEC1
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLALE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLALEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:04:07 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427E7AB011;
        Thu,  1 Dec 2022 03:03:54 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id 4EABBBA3615;
        Thu,  1 Dec 2022 12:03:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669892632;
        bh=urq0lkT0BDJz23tDwsOh2qtGaagFlE0HTqa+o77ZBMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=VAUtdl8a0aH3z0uBZ/o9iHeLH07Qx1stv+B1xNBlQlPhLsDUAfDoztRTb7wZBlCtf
         R0kxuwgcTMF05yBec7ft+2LbooJgSpuLU3HJHw31YJnuQR5AboL+7dlnMvHT5gIvOq
         L9kfg3Fw9Glnt1ICea6YdU6wjw+cDcN+k1c9pfrgfe4e66nzc3/wNQtb2j1iqcHMAZ
         F45NKCZhuxg6vzJJhCmvmAsUJBdqztppSx7FxAkT8gEd1Osg/oqGorlvvJXkFtk2js
         VaeuFzEOHHWReiNo8mHz7TEXoykEeebN12MVu8Rqz+9Lolkyam53lpOaVf2qrqRoD0
         zv9F/wve2wThw==
Date:   Thu, 1 Dec 2022 12:03:29 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: Boot failure regression on 6.0.10 stable kernel on iMX7
Message-ID: <Y4iKAUav9ktuxncE@francesco-nb.int.toradex.com>
References: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
 <12f7fbb7-8252-4520-89c2-c5138931a696@denx.de>
 <Y4fCZmjDMtMMyu+E@francesco-nb.int.toradex.com>
 <fef2598e-e5fc-c4fc-0530-2d3c380ed39a@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fef2598e-e5fc-c4fc-0530-2d3c380ed39a@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ MTD maintainers/list

On Wed, Nov 30, 2022 at 11:59:04PM +0100, Marek Vasut wrote:
> On 11/30/22 21:51, Francesco Dolcini wrote:
> > On Wed, Nov 30, 2022 at 03:41:13PM +0100, Marek Vasut wrote:
> > > On 11/30/22 14:52, Francesco Dolcini wrote:
> > > > [    0.000000] Booting Linux on physical CPU 0x0
> > > > [    0.000000] Linux version 6.0.10 (francesco@francesco-nb) (arm-linux-gnueabihf-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.
> > > > 4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #36 SMP Wed Nov 30 14:07:15 CET 2022
> > > > ...
> > > > [    4.407499] gpmi-nand: error parsing ofpart partition /soc/nand-controller@33002000/partition@0 (/soc/nand-controller
> > > > @33002000)
> > > > [    4.438401] gpmi-nand 33002000.nand-controller: driver registered.
> > > > ...
> > > > [    5.933906] VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0): error -19
> > > > [    5.946504] Please append a correct "root=" boot option; here are the available partitions:
> > > > ...
> > > > 
> > > > Any idea? I'm not familiar with the gpmi-nand driver and I would just revert it, but
> > > > maybe you have a better idea.
> > > 
> > > Can you share the relevant snippet of your nand controller DT node ?
> > 
> > We just have
> > 
> > from imx7-colibri.dtsi,
> > 
> >    &gpmi {
> >    	fsl,use-minimum-ecc;
> >    	nand-ecc-mode = "hw";
> >    	nand-on-flash-bbt;
> >    	pinctrl-names = "default";
> >    	pinctrl-0 = <&pinctrl_gpmi_nand>;
> >    };
> > 
> > OF partition are created by U-Boot from
> >    mtdparts=mtdparts=gpmi-nand:512k(mx7-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,512k(u-boot-env),-(ubi)
> > env variables calling fdt_fixup_mtdparts from colibri_imx7.c
> > 
> > Everything is available in the upstream Linux/U-Boot git, no downstream
> > repo of any sort.
> > 
> > > Probably up to first partition is enough. I suspect you need to fill in the
> > > correct address-cells/size-cells there, which might be currently missing in
> > > your DT and worked by chance.
> > 
> > This is generated by U-Boot, I would need to dump what he did generate
> > from the standard fdt_fixup_mtdparts(). I will try to do it tomorrow
> > unless what I wrote here is already enough to understand what's going
> > on.
> 
> Oh drat ... I see. It's the u-boot fdt_node_set_part_info() which checks the
> current NAND controller #size-cells and uses that when generating MTD
> partitions 'reg' properties. Since #size-cells is now zero, the reg
> properties would be malformed.

I think the issue is slightly different, the u-boot code checks it and
if not set it defaults to #size-cells = <1>. Said that u-boot
never set #size-cells anywhere.

What is failing is ofpart_core.c:parse_fixed_partitions() in Linux with
#size-cells = <0>.


> Now, what I am unsure is whether the right fix is to update mx7 colibri DT
> and include &gpmi { #size-cells=<1>; }; , or , revert this patch. The former
> fixes the problem for colibri and retains the correct #size-cells=<0>
> behavior for any other board which does not specify MTD partitions in the
> GPMI NAND node. The later also covers boards which we don't know about which
> might also use generated MTD partitions in DT using fdt_fixup_mtdparts() in
> U-Boot, but I am not convinced that is correct.
> 
> So, would you be OK with fixing up the colibri mx7 DT with #size-cells=<1> ?

I am also not sure what is the right fix, however I am convinced that
the fix needs to be in Linux, we cannot really break the boot flow.

In a very pragmatic way I could just add the property to colibri-imx7
dtsi, but we are really breaking potential other users of it, anybody
using U-Boot to generate the partitions in the end ... (and the list is
not empty and not just the colibri*).

Would it make any sense to do something like that (untested!) ?

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index 192190c42fc8..fffd60acd926 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -122,6 +122,8 @@ static int parse_fixed_partitions(struct mtd_info *master,

                a_cells = of_n_addr_cells(pp);
                s_cells = of_n_size_cells(pp);
+               if (s_cells == 0)
+                       s_cells = 1; // for backward compatibility
                if (len / 4 != a_cells + s_cells) {
                        pr_debug("%s: ofpart partition %pOF (%pOF) error parsing reg property.\n",
                                 master->name, pp,

Francesco

