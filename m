Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2984C1AE4
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiBWSYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbiBWSYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:24:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037EB4831E;
        Wed, 23 Feb 2022 10:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7669B8216C;
        Wed, 23 Feb 2022 18:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C198AC340E7;
        Wed, 23 Feb 2022 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645640661;
        bh=Ok0TjFXJ89KIp9SMK2a9xW2sNM6gB+qMJkswhq8JnIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTuTE0XGFGAJp8v05Cqya1ji7cwN6A+kZRXDoM+tDKsq0ziH/y4Y/Bt6tIeHDPl2+
         BVmlbklfFhrtWXnT0AV279eA8SvTkC1e7x/HI4VV0iM1Z6VWjDpppjqXY4hKHPE5NZ
         v1cprPuaRA4NOc1YV9KFqVplvrhBh2cIA/Abc1gI=
Date:   Wed, 23 Feb 2022 19:24:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        david regan <dregan@mail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:NAND FLASH SUBSYSTEM" <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND stable 4.9] mtd: rawnand: brcmnand: Fixed
 incorrect sub-page ECC status
Message-ID: <YhZ70pTGdGoPEMUb@kroah.com>
References: <20220223174431.1083-1-f.fainelli@gmail.com>
 <20220223174431.1083-3-f.fainelli@gmail.com>
 <YhZ0vZxlp1VTgNG8@kroah.com>
 <325bb69b-691b-3c61-9578-d42ec33277b8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325bb69b-691b-3c61-9578-d42ec33277b8@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 09:54:59AM -0800, Florian Fainelli wrote:
> 
> 
> On 2/23/2022 9:54 AM, Greg KH wrote:
> > On Wed, Feb 23, 2022 at 09:44:31AM -0800, Florian Fainelli wrote:
> > > From: david regan <dregan@mail.com>
> > > 
> > > commit 36415a7964711822e63695ea67fede63979054d9 upstream
> > > 
> > > The brcmnand driver contains a bug in which if a page (example 2k byte)
> > > is read from the parallel/ONFI NAND and within that page a subpage (512
> > > byte) has correctable errors which is followed by a subpage with
> > > uncorrectable errors, the page read will return the wrong status of
> > > correctable (as opposed to the actual status of uncorrectable.)
> > > 
> > > The bug is in function brcmnand_read_by_pio where there is a check for
> > > uncorrectable bits which will be preempted if a previous status for
> > > correctable bits is detected.
> > > 
> > > The fix is to stop checking for bad bits only if we already have a bad
> > > bits status.
> > > 
> > > Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
> > > Signed-off-by: david regan <dregan@mail.com>
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02
> > > [florian: make patch apply to 4.14, file was renamed]
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > ---
> > >   drivers/mtd/nand/brcmnand/brcmnand.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Why is this a RESEND?  What happened with the first set?
> 
> I forgot to copy stable and you and Sasha, wanted to make it clear to the
> MTD folks why this is being resent.

But this commit is already in the 4.14.268 and 4.19.231 release, why do
we need to add it again?

For 4.9 we need the backport, I'll take that one...

thanks,

greg k-h
