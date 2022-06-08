Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BD3542ECE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbiFHLIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237961AbiFHLI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:08:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7479C20C6D9
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 04:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YdPHfvD+N+FQ+mrqZRikIOfI4xZVVhOwugReh3/JtuQ=; b=cTj6IK6nnwaTrL+YRkf6TR0fB0
        8WJqY808LFud8KfVeGSVLms8KXcPtjiT+HKupQQtp64Ith99InjOh6ZARP2Ca1+21s1hjN46GBStw
        LEUx5Akb0+kbv5GRFfADHRRU78T4pKJ4yZlye81tmyS/qTNbytRC5uVraO4j8KfuMCqxOssR1xFdv
        TI/QiaWdUM3QREfpKE62qhNRWIOfMYblSF0EIYiZ7okuw8g0JvG0gfO9JYiWNcH8jGYFfT4GJMnMt
        o7P9aSxaC3+n9JDjuLw13Iw83kRCo857kEMLLchsf6vsgszPNS1cHLEUDaWHlHE2wt4g1vSzimNOC
        x0x7u6Zw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32786)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nytXu-0004f7-P1; Wed, 08 Jun 2022 12:08:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nytXs-0001jN-Bm; Wed, 08 Jun 2022 12:08:16 +0100
Date:   Wed, 8 Jun 2022 12:08:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Eric Schikschneit <eric.schikschneit@novatechautomation.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
Message-ID: <YqCDIMoHL23XHTFp@shell.armlinux.org.uk>
References: <CY1PR07MB2700E81609B0967127D0773381DF9@CY1PR07MB2700.namprd07.prod.outlook.com>
 <cad76252-ec94-779e-aa31-b487526a2154@leemhuis.info>
 <CY1PR07MB27008E7B556EF9ABF609F85081A59@CY1PR07MB2700.namprd07.prod.outlook.com>
 <2725aaed-6c31-2cce-dcd2-55f2f1ed533c@leemhuis.info>
 <YqBphR1XTcqqbvG9@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqBphR1XTcqqbvG9@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 10:19:01AM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 08, 2022 at 10:54:48AM +0200, Thorsten Leemhuis wrote:
> > On 07.06.22 13:58, Eric Schikschneit wrote:
> > > I am limited by the availability of the preempt-rt kernels that are 
> > > available on the yocto project. The newest kernel I see listed is 
> > > 5.15.44 on: https://git.yoctoproject.org/linux-yocto/
> > 
> > Well, it's up to Russel if that is enough for him, as he authored
> > c859e0d479b3 ("gpio: omap: ensure irq is enabled before wakeup") and
> > thus should look into this regression.
> 
> I've already made it clear that is something I can no longer do; I
> no longer have the knowledge, nor do I have the hardware to test
> for this regression.

There's a lot of debugging that needs to be done that can only be done
by the reporter to work out exactly what is going on. Most of what is
below is guess work - as I say, I don't have the knowledge, but what
follows is based on what would be a sensible investigation approach.

As I understand it having *briefly* looked at what I guess is the right
SPI code - I don't know - I'm guessing the CS lines are manually
controlled by the SPI driver via the GPIO layer.

If that is correct, the SPI driver must be itself deasserting the CS
line at the inappropriate point. This means the reporter needs to
locate where that is happening, and work out why the driver is doing
that. dump_stack() can be inserted at the appropriate point(s) to get
a stack trace to show the call path, which may or may not reveal how
we got there.

Also, we have no idea what the SPI device is, or how the driver for the
SPI device is using the SPI subsystem. Are there two separate transfers
being issued to the SPI subsystem, and is the CS signal being
deasserted between those two transfers?

If that is the case, deasserting the CS signal between the two
transfers seems to me to be entirely reasonable - as once a transfer
has completed, the SPI bus _could_ be used to access another peripheral
before the second transfer is acted upon. If this is the case, then
this commit has revealed a latent bug.

If CS is deasserted between two separate SPI transactions, but the chip
must not see CS deasserted, then that would be a bug in the SPI device
driver and have nothing to do with the GPIO layer. The change in the
GPIO code would have revealed a latent bug in the SPI side of things
(maybe the SPI device driver.)

There is just so much that is unknown here, and there is nothing I can
do here locally to debug this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
