Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE5763F473
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiLAPqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiLAPqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:46:23 -0500
Received: from smtp-out-03.comm2000.it (smtp-out-03.comm2000.it [212.97.32.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1AE06;
        Thu,  1 Dec 2022 07:46:21 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-03.comm2000.it (Postfix) with ESMTPSA id 10EDAB4ADB8;
        Thu,  1 Dec 2022 16:46:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669909578;
        bh=MpoeK/SVoG4QpF0S5JGnpX9gBKGENx9957gTXLHgZpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=pLs+K9RJaACcee8bsgicL0FTI1HERRpymVb828paH+hJDTf2GOxGGBVLqa3515BxJ
         Hov/Zjv/4xC/tUcmXiy/X+qkTerfOjHHG8yn4e9hJPQs6RffRcGlE0BPx4MxxP38XE
         IOp2l8MnOB74JsdWSZ3NcleHfXSASMzFNYQEMSKjGX0+v7Mb3HW0nXYVIGBDgCwRi6
         axSeO71hcPTsiY4V8mdmbP2wl4Qgx77s1vPtIp8bwBECdweO4Wj/s5UHWt37OkQR8H
         53uEBjwpFyB1HbrddlzM0bDWKQ6TUlE/LhgutLsWkzk0MjSq8d79SMyWgDaO0v9rOZ
         uJyzCD8opB46w==
Date:   Thu, 1 Dec 2022 16:45:53 +0100
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
        Vignesh Raghavendra <vigneshr@ti.com>, u-boot@lists.denx.de
Subject: Re: Boot failure regression on 6.0.10 stable kernel on iMX7
Message-ID: <Y4jMMeyktJLHb9ji@francesco-nb.int.toradex.com>
References: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
 <12f7fbb7-8252-4520-89c2-c5138931a696@denx.de>
 <Y4fCZmjDMtMMyu+E@francesco-nb.int.toradex.com>
 <fef2598e-e5fc-c4fc-0530-2d3c380ed39a@denx.de>
 <Y4iKAUav9ktuxncE@francesco-nb.int.toradex.com>
 <b5080dd6-40b3-a8f2-0c4e-4c1e52e67fe8@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5080dd6-40b3-a8f2-0c4e-4c1e52e67fe8@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ u-boot list

On Thu, Dec 01, 2022 at 12:25:34PM +0100, Marek Vasut wrote:
> On 12/1/22 12:03, Francesco Dolcini wrote:
> > On Wed, Nov 30, 2022 at 11:59:04PM +0100, Marek Vasut wrote:
> > > On 11/30/22 21:51, Francesco Dolcini wrote:
> > > > On Wed, Nov 30, 2022 at 03:41:13PM +0100, Marek Vasut wrote:
> > > > > On 11/30/22 14:52, Francesco Dolcini wrote:
> > > > > > [    0.000000] Booting Linux on physical CPU 0x0
> > > > > > [    0.000000] Linux version 6.0.10 (francesco@francesco-nb) (arm-linux-gnueabihf-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.
> > > > > > 4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #36 SMP Wed Nov 30 14:07:15 CET 2022
> > > > > > ...
> > > > > > [    4.407499] gpmi-nand: error parsing ofpart partition /soc/nand-controller@33002000/partition@0 (/soc/nand-controller
> > > > > > @33002000)
> > > > > > [    4.438401] gpmi-nand 33002000.nand-controller: driver registered.
> > > > > > ...
> > > > > > [    5.933906] VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0): error -19
> > > > > > [    5.946504] Please append a correct "root=" boot option; here are the available partitions:
> > > > > > ...
> > > > > > 
> > > > > > Any idea? I'm not familiar with the gpmi-nand driver and I would just revert it, but
> > > > > > maybe you have a better idea.
> > > > > 
> > > > ...
> > > > OF partition are created by U-Boot from
> > > >     mtdparts=mtdparts=gpmi-nand:512k(mx7-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,512k(u-boot-env),-(ubi)
> > > > env variables calling fdt_fixup_mtdparts from colibri_imx7.c
> > > > 
> > > > This is generated by U-Boot, I would need to dump what he did generate
> > > > from the standard fdt_fixup_mtdparts(). I will try to do it tomorrow
> > > > unless what I wrote here is already enough to understand what's going
> > > > on.
> > > 
> > > Oh drat ... I see. It's the u-boot fdt_node_set_part_info() which checks the
> > > current NAND controller #size-cells and uses that when generating MTD
> > > partitions 'reg' properties. Since #size-cells is now zero, the reg
> > > properties would be malformed.
> > 
> > I think the issue is slightly different, the u-boot code checks it and
> > if not set it defaults to #size-cells = <1>. Said that u-boot
> > never set #size-cells anywhere.
> 
> Which it really should, can you send a patch there too ?

I guess that it is slightly more complicated.

U-Boot directly updates the nand-controller root node with the
partitions, unless there is already a partitions child node present. In
the first case (legacy OF partition definition) setting the #size-cells
does not seems that correct, while in the second case I agree it should
really do it. I'll see what I can come-up with.

> > diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
> > index 192190c42fc8..fffd60acd926 100644
> > --- a/drivers/mtd/parsers/ofpart_core.c
> > +++ b/drivers/mtd/parsers/ofpart_core.c
> > @@ -122,6 +122,8 @@ static int parse_fixed_partitions(struct mtd_info *master,
> > 
> >                  a_cells = of_n_addr_cells(pp);
> >                  s_cells = of_n_size_cells(pp);
> > +               if (s_cells == 0)
> > +                       s_cells = 1; // for backward compatibility
> >                  if (len / 4 != a_cells + s_cells) {
> >                          pr_debug("%s: ofpart partition %pOF (%pOF) error parsing reg property.\n",
> >                                   master->name, pp,
> 
> You might want to print a warning too, so users would fix their DTs, since
> once there is MTD partition > 4 GiB, this would break. Otherwise I like this
> option.

I tested it and it's working as expected, I'll send a proper patch soon.

Francesco

