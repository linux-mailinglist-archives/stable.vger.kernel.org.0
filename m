Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B206B1E6319
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390610AbgE1N6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 09:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390569AbgE1N6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 09:58:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AD6C05BD1E;
        Thu, 28 May 2020 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FR6rpUTDy6YkCkRcXhb1NZpZMquu6OHks1/TSntn5g8=; b=0FISDt0iywTeivhDGysA/zkgE
        nTZuqcGb0OeYxSpAkY8KjuTh+iYDw8FNu2qxnIPR1H0s5XuPX+TuV7ubJYjdTh5nfdmylkfihePRc
        oHXIAaXsrGKymN14NAX3l4c+FFo76k4pktkmRpWeg9wa4Psy2EbWleD4SnMx9L7O1mRaENI/YI4G9
        ZL2gjrYCRdNfgicuMARIrOwDAXMWXI6OE55kc1efIJ8y7metKX27qMoPbh8Pi82QjvScNVOwSZVBu
        n17EM1j7xmIZUUDkt/T4e+LAABaL3klLcotDxI4jtgYxb3+KPWXqzdpyrGP3+B2jICVimdiLI9LhM
        Kx8X+ic1g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:46204)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeJ3C-0005VB-Kn; Thu, 28 May 2020 14:58:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeJ3B-0007Ww-I5; Thu, 28 May 2020 14:58:25 +0100
Date:   Thu, 28 May 2020 14:58:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
Message-ID: <20200528135825.GV1551@shell.armlinux.org.uk>
References: <20200527140758.162280-1-linus.walleij@linaro.org>
 <20200527141807.GQ1551@shell.armlinux.org.uk>
 <CACRpkdbnLS2G6UH3L5u71RvP-heDqoOk+k9cW=9_4pJ_u3w0zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbnLS2G6UH3L5u71RvP-heDqoOk+k9cW=9_4pJ_u3w0zg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 03:46:04PM +0200, Linus Walleij wrote:
> On Wed, May 27, 2020 at 4:18 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > On Wed, May 27, 2020 at 04:07:58PM +0200, Linus Walleij wrote:
> 
> > > We provided the right semantics on open drain lines being
> > > by definition output but incidentally the irq set up function
> > > would only allow IRQs on lines that were "not output".
> > >
> > > Fix the semantics to allow output open drain lines to be used
> > > for IRQs.
> > >
> > > Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> > > Cc: Russell King <linux@armlinux.org.uk>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 256efaea1fdc ("gpiolib: fix up emulated open drain outputs")
> >
> > As I've pointed out in the reporting thread, I don't think it can be
> > justified as a regression - it's a bug in its own right that has been
> > discovered by unifying the gpiolib semantics, since the cec-gpio code
> > will fail on hardware that can provide real open-drain outputs
> > irrespective of that commit.
> >
> > So, you're really fixing a deeper problem that was never discovered
> > until gpiolib's semantics were fixed to be more uniform.
> 
> You're right, I was thinking of Fixes: as more of a mechanical
> instruction to the stable kernel maintainers administrative machinery.
> 
> I will use the other way to signal to stable where to apply this.

I think it makes sense to apply this patch to stable kernels prior to
the commit mentioned in the Fixes tag - but how far back is a good
question.  Certainly to the point that we ended up with code relying
on this behaviour (so when cec-gpio was introduced?)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
