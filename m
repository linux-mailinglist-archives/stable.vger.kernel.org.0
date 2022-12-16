Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD24564EB76
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLPMhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPMhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:37:41 -0500
Received: from smtp-out-03.comm2000.it (smtp-out-03.comm2000.it [212.97.32.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E4413CEC
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 04:37:40 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-03.comm2000.it (Postfix) with ESMTPSA id 58526B43495;
        Fri, 16 Dec 2022 13:37:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1671194258;
        bh=kDORtdg4hjythgYzGqCY1n8MJSAxGyPQa2nVmtNblHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Ash002jd2Njm2tORVDlkgLXhBEB+YEbrXj1jTZZLB0+JKH3Gf7IqdT8c99AUEvwTJ
         OVAZ+nE6tpmM1OiAkC0HbEPr0+1FJAUotKZG1HtMdxyJIPW2XARvtjI8ldjpJRNYlu
         xthK4C+p7dy3IREqtoI8ceTSddaQZtEqvCD4qlEyrPViHg6s5U09WQUhoaOkxn3Hxo
         XMvDqY6nEEVNRIP5WtQw012W0aBuIUQ6tvrTROEYC8+IJ85dTocAAG0zYFTDVzRZ8F
         qJV2SOf5o+BhtwW5jsp1YQUPDH6k1kQi5OF0s+RYFNAIkYaYxsdwLOJTWI9Czt0Ds3
         XEVd6KzRIV+cw==
Date:   Fri, 16 Dec 2022 13:37:31 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Message-ID: <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
 <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
 <20221216120155.4b78e5cf@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216120155.4b78e5cf@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 12:01:55PM +0100, Miquel Raynal wrote:
> marex@denx.de wrote on Fri, 16 Dec 2022 11:46:18 +0100:
> > On 12/16/22 08:45, Francesco Dolcini wrote:
> > > On Thu, Dec 15, 2022 at 08:16:04AM +0100, Miquel Raynal wrote:  
> > >> I am still against piggy hacks in the generic ofpart.c driver, but
> > >> what we could do however is a DT fixup in the init_machine (or the
> > >> dt_fixup) hook for imx7 Colibri, very much like this:
> > >> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/board-v7.c#L111
> > >> Plus a warning there saying "your dt is broken, update your firmware".  
> > > 
> > > I have a couple of concerns/question with this approach:
> > >   - do we have a single point to handle this? Different architectures are
> > >     affected by these issue. Duplicating the fixup code in multiple place
> > >     does not seems a great idea
> > >   - If we believe that the device tree is wrong, in the i.MX7 case
> > >     because of #size-cells should be set to 0 and not 1, we should not
> > >     alter the FDT. Other part of the code could rely on this being
> > >     correctly set to 0 moving forward.
> > > 
> > > If I understood you are proposing to have a fixup at the machine level
> > > that is converting a valid nand-controller node definition to a "broken"
> > > one. Unless I misunderstood you and you are thinking about rewriting the
> > > whole MTD partition from a broken definition to a proper one.
> 
> No, quite the opposite.
>
> Either size-cell is wrong which makes the description totally
> inconsistent (if size-cell is there, it must have a use, otherwise why
> do we keep it?) and we must fix it, or it is right and we should not
> touch it.
> 
> What I propose is to check very early whether the description is
> consistent on the board known to have this problem. If the description
> is wrong, we fix it and the generic parser can then do its work
> properly.

What if we add `nand-chip{}` children in the future (the i.MX nand
controller has nothing implemented not described in the schema so far,
but it is something that is supported by the hw)? Will this idea still
works?

> > > On Thu, Dec 15, 2022 at 09:04:46AM +0100, Miquel Raynal wrote:  
> > >> marex@denx.de wrote on Thu, 15 Dec 2022 08:45:33 +0100:  
> > >>> Sadly, it does only fix the known cases, not the unknown cases like
> > >>> downstream forks which never get any bootloader updates ever, and
> > >>> which you can't find in upstream U-Boot, and which you therefore
> > >>> cannot easily catch in the arch side fixup.  
> > >>
> > >> And ?  
> > > 
> > > I'm not personally and directly concerned, since the machine I care are
> > > all available upstream and known, however this is a general problem with
> > > U-Boot code being at the same time widely used on a range of embedded
> > > products and producing a broken MTD partition list.
> > > 
> > > I think we will just silently break boards and just creating a lot of
> > > issues to people. We would just introduce regression to the users, being
> > > aware of it and deliberately decide to not care and move the problem to
> > > someone else. I do not think this is a good way to go.  
> 
> What?

Let me rephrase, I was not clear enough.

> Since when my proposal is breaking boards? My proposal leads to a
> situation where:
> - If you have a board that has an inconsistent description but worked,
>   it will still work.
> - If you have a board that has a consistent description and worked, it
>   will still work.
> - If your have a board that has an inconsistent description and got
>   broken *recently* by another change (typically you "fix" the DT in
>   Linux to comply with the bindings), then you get a warning that leads
>   you on the right path, you then update your bootloader if you can,
>   but either way you add your machine compatible to the list of devices
>   which need the early fix and your boot is fixed.

This implies that we can proactively catch all the affected boards. I do
not believe this is reasonable and because of that my comment before
about creating regression to the users.

Francesco


