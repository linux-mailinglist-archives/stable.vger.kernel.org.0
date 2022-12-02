Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06B6405BD
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 12:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiLBLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 06:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiLBLX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 06:23:56 -0500
Received: from smtp-out-08.comm2000.it (smtp-out-08.comm2000.it [212.97.32.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0CBC35AE
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 03:23:54 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-08.comm2000.it (Postfix) with ESMTPSA id AE007426699;
        Fri,  2 Dec 2022 12:23:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669980233;
        bh=2yMwEa354inPXmbR8rAZ8QtOb/l/03HU/z5fqaDWm4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=mUQCcDqM4DTU+11m+iyl0ujX6hLLfBJECJaE0fDrif/2C+3b+StbD1R5jOqhjzLOq
         kgZOobJdYCHJVsjU7H4Hw7lxxtpIEAkqB/ybaPOAQXVOt5GWT1Kl3yV8X8bjN5SIyV
         joQkbFwxWPRsZrEtXvIk5aOTdYWadpw84z2JtedeL0zj4IaeE0DGJHuoaqG6bZlp99
         Mzu028UL1Em+F2XslfmWD1rgvOIiM3YykotIVSew85TC3aOkmfujHzUZ6SQlqsXXgL
         mJYzGxVibVVvcD/qeMBU1Rp7wtn7Gm6lgM0yjHklr4DpqVEjO/bTxxU/w1q+sid0kj
         374MSeOpepl8w==
Date:   Fri, 2 Dec 2022 12:23:37 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
References: <20221202071900.1143950-1-francesco@dolcini.it>
 <20221202101418.6b4b3711@xps-13>
 <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
 <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
 <20221202115327.4475d3a2@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202115327.4475d3a2@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ u-boot list

On Fri, Dec 02, 2022 at 11:53:27AM +0100, Miquel Raynal wrote:
> francesco@dolcini.it wrote on Fri, 2 Dec 2022 11:24:29 +0100:
> > On Fri, Dec 02, 2022 at 11:12:43AM +0100, Francesco Dolcini wrote:
> > > On Fri, Dec 02, 2022 at 10:14:18AM +0100, Miquel Raynal wrote:  
> > > > francesco@dolcini.it wrote on Fri,  2 Dec 2022 08:19:00 +0100:  
> > > > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > > > 
> > > > > Add a fallback mechanism to handle the case in which #size-cells is set
> > > > > to <0>. According to the DT binding the nand controller node should have
> > > > > set it to 0 and this is not compatible with the legacy way of
> > > > > specifying partitions directly as child nodes of the nand-controller node.  
> > > > 
> > > > I understand the problem, I understand the fix, but I have to say, I
> > > > strongly dislike it :) Touching an mtd core driver to fix a single
> > > > broken use case like that is... problematic, for the least.  
> > > I just noticed it 2 days after this patch was backported to a stable
> > > kernel, I am just the first one to notice, we are not talking about a single
> > > use case.
> > >   
> > > > I am sorry but if a 6.0 kernel breaks because:  
> > > Not only kernel 6.0 is currently broken. This patch is going to be
> > > backported to any stable kernel given the fixes tag it has.
> > >   
> > > > If you really want to workaround U-Boot, either you revert that patch
> > > > or you just fix the DT description instead. The parent/child/partitions
> > > > scheme has been enforced for maybe 5 years now and for a good reason: a
> > > > NAND controller with partitions does not make _any_ sense. There are
> > > > plenty of examples out there, imx7-colibri.dtsi has received many
> > > > updates since its introduction (for the best), so why not this one?  
> > > 
> > > I can and I will update imx7-colibri.dtsi (patch coming),
> 
> :thumb_up:
> 
> > > but is this
> > > good enough given the kind of boot failure regression this introduce? We
> > > are going to have old u-boot around that will not work with it, and the  
> > 
> > Just another piece of information, support for the partitions node in
> > U-Boot was added in version v2022.04 [1], we are not talking about ancient
> > old legacy stuff.
> 
> If it is so recent, then this is what needs to be fixed, and it should
> not bother "many" people because 2022.04 is not so old.
> 
> So I am a bit lost, IIUC what is currently broken is:
> - U-Boot > 2022.04 and any version of Linux with the backport?
> 
> > If I add the partitions node as a child of my nand controller, as I was
> > planning to do and I wrote 10 lines above, I will create a new flavor of
> > non-booting system with U-Boot older than v2022.04 :-/
> 
> I think there is a little confusion here. You are referring to the NAND
I guess I have not explained myself well enough :-)

U-Boot is creating the partitions in the dtb, they are not defined in
the source dts file (this is common practice with multiple boards).

Before v2022.04 it was always updating the nand-controller node,
starting from v2022.04 if there is a dedicated `partitions` node it uses
it. This is just the reverse of what ofpart_core.c is doing (if the
partitions node is there it assumes the partitions should go into it,
otherwise it proceeds with the legacy way).

Let's have a concrete example with colibri-imx7.

Current status:
 - The nand-controller node does not include any partitions child, any
   U-Boot version will just add the partition directly as child of the
   nand controller. This is where I am hitting this boot regression now.

Potential change I envisioned here:
 - I add the partitions node to the nand-controller, e.g.

--- a/arch/arm/boot/dts/imx7-colibri.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri.dtsi
@@ -380,6 +380,12 @@ &gpmi {
        nand-on-flash-bbt;
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_gpmi_nand>;
+
+       partitions {
+               compatible = "fixed-partitions";
+               #address-cells = <1>;
+               #size-cells = <1>;
+       };
 };

 - U-Boot >= v2022.04 will just work fine creating the partitions as
   currently described in the bindings.
 - U-Boot < v2022.04 will still create the partitions as child of the
   nand-controller node. Linux will see that a `partitions` node exists
   but it will be empty, leading to a boot failure in case mtd is used
   as boot device.


> controller node, the commit refers to the NAND chip node. What this
> commit does looks fine because it just tries to use the partitions {}
> node rather than the NAND chip node and if the partitions {} node
> already exist, I expect #address-cells and #size-cells to be defined
> and be != 0 already.
yes, this commit is perfectly fine I agree.

The reality is that people is using newer kernel with older U-Boot, and
I do not think that deliberately breaking this use case is what the
Linux kernel should do.

I do not think that I can push a change in the DTS that will break
booting any board using an older U-Boot.

Francesco

