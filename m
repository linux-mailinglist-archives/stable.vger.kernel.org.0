Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6A640486
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiLBKYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 05:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBKYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 05:24:49 -0500
Received: from smtp-out-08.comm2000.it (smtp-out-08.comm2000.it [212.97.32.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1310D26AC0
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 02:24:48 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-08.comm2000.it (Postfix) with ESMTPSA id 1C91D426A44;
        Fri,  2 Dec 2022 11:24:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1669976685;
        bh=8mV1uDAsqGTcFlpWfAUtgES7Hcz7KKv0WrqMDW2T7qI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=b36p1ywq4DgK//mM/hLiBj8zUn9DFVkoB7fUDAV1aO7kU5sJsSg8eF3LWFGKSxXdO
         mh18+lf9V9kpq8kwUlqoMGIG/x1K9bNCydfwZ0N8+YNyEnwBbwwiu5KwsKHklrYg3l
         VJ0ibSh2AOrYORI3fxVmjmfUMfMF1wIZLWKLCv8fkSwJFGFnYu2nDshEyGxbMTWyVk
         mEpmDR6w6tUcErne+JhKTMRTlYEb5k1rmqVn44T49xVzbzNFwHfARx1wmhNQg8LSxV
         XpvPW3EMnSbiCH4oQtbny41LOcfN/ZwqyRp4vZFQFuYa1u2h2SBu1lqcsJAqKiX/Zq
         xodsBO++S8lcw==
Date:   Fri, 2 Dec 2022 11:24:29 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
References: <20221202071900.1143950-1-francesco@dolcini.it>
 <20221202101418.6b4b3711@xps-13>
 <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 11:12:43AM +0100, Francesco Dolcini wrote:
> Hello Miquel,
> 
> On Fri, Dec 02, 2022 at 10:14:18AM +0100, Miquel Raynal wrote:
> > francesco@dolcini.it wrote on Fri,  2 Dec 2022 08:19:00 +0100:
> > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > 
> > > Add a fallback mechanism to handle the case in which #size-cells is set
> > > to <0>. According to the DT binding the nand controller node should have
> > > set it to 0 and this is not compatible with the legacy way of
> > > specifying partitions directly as child nodes of the nand-controller node.
> > 
> > I understand the problem, I understand the fix, but I have to say, I
> > strongly dislike it :) Touching an mtd core driver to fix a single
> > broken use case like that is... problematic, for the least.
> I just noticed it 2 days after this patch was backported to a stable
> kernel, I am just the first one to notice, we are not talking about a single
> use case.
> 
> > I am sorry but if a 6.0 kernel breaks because:
> Not only kernel 6.0 is currently broken. This patch is going to be
> backported to any stable kernel given the fixes tag it has.
> 
> > If you really want to workaround U-Boot, either you revert that patch
> > or you just fix the DT description instead. The parent/child/partitions
> > scheme has been enforced for maybe 5 years now and for a good reason: a
> > NAND controller with partitions does not make _any_ sense. There are
> > plenty of examples out there, imx7-colibri.dtsi has received many
> > updates since its introduction (for the best), so why not this one?
> 
> I can and I will update imx7-colibri.dtsi (patch coming), but is this
> good enough given the kind of boot failure regression this introduce? We
> are going to have old u-boot around that will not work with it, and the

Just another piece of information, support for the partitions node in
U-Boot was added in version v2022.04 [1], we are not talking about ancient
old legacy stuff.

If I add the partitions node as a child of my nand controller, as I was
planning to do and I wrote 10 lines above, I will create a new flavor of
non-booting system with U-Boot older than v2022.04 :-/

U-Boot older than v2022.04 will update the nand controller node never
the less, the partition node will still be there and Linux will use it,
but it will be empty since nobody populate it.

Francesco

[1] commit 36fee2f7621e ("common: fdt_support: add support for "partitions" subnode to fdt_fixup_mtdparts()")
