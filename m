Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447333776BE
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 15:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEINLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 09:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhEINLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 09:11:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10787C061573;
        Sun,  9 May 2021 06:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jmMlMrReug8dSG3qMgbDjrwA6zFS6KOYzBiUrMYLurI=; b=cNvbXvPjSI+Vkyp34Q1pYieCF
        DMTf/bm9yJ3Nao7+sGIoIAs+4g4EKyThDYzxI41glhBzBSqN9FqgmTtkChW05uHo2MLMAotv2mBIn
        Vu22decVhvbON5QdKBb2ORDsbT2wubaeRrq4hL8jueKSsJTOYgCPAqKytiikARd+tAHj5VqAiCYJr
        +XzykKeew2SKNrR/ZmKDNCKxQ6CA1BwAnU+imRMpZSlw3aO7H04avilESyyYTUuhaLYBKScJd1NPR
        ivKCS3iQjAF58z5XAlr5R+XvI0Gis3vNeOuNezYrGisoE+PbI1oH9iG2eWzAPgmJx8nuhnMLUZ8wC
        j9ic4idew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43814)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lfjC1-0007H1-FH; Sun, 09 May 2021 14:09:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lfjC0-0007f1-Sx; Sun, 09 May 2021 14:09:56 +0100
Date:   Sun, 9 May 2021 14:09:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] arm: Enlarge IO_SPACE_LIMIT needed for some SoC
Message-ID: <20210509130956.GI1336@shell.armlinux.org.uk>
References: <20210508175537.202-1-ansuelsmth@gmail.com>
 <20210508185043.GF1336@shell.armlinux.org.uk>
 <YJcV6I6yYt5zIsXQ@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJcV6I6yYt5zIsXQ@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 12:51:20AM +0200, Ansuel Smith wrote:
> On Sat, May 08, 2021 at 07:50:44PM +0100, Russell King - ARM Linux admin wrote:
> > On Sat, May 08, 2021 at 07:55:35PM +0200, Ansuel Smith wrote:
> > > Ipq8064 SoC requires larger IO_SPACE_LIMIT or second and third pci port
> > > fails to register the IO addresses and connected device doesn't work.
> > > 
> > > Cc: <stable@vger.kernel.org> # 4.9+
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > 
> > I don't see any consideration of whether this increase results in any
> > clashes with any other related areas. Also, there is no update of the
> > memory layout documentation.
> > 
> > The memory layout documentation says:
> > 
> > =============== =============== ===============================================
> > Start           End             Use
> > =============== =============== ===============================================
> > fee00000        feffffff        Mapping of PCI I/O space. This is a static
> >                                 mapping within the vmalloc space.
> > 
> > which means there's a maximum of 0x001fffff available. You are
> > increasing it's size from 0x000fffff to 0x00ffffff. This means it
> > expands from 0xfee00000 through to 0xffdfffff.
> > 
> > This conflicts with these entries:
> > 
> > ffc80000        ffefffff        Fixmap mapping region.  Addresses provided
> >                                 by fix_to_virt() will be located here.
> > 
> > ffc00000        ffc7ffff        Guard region
> > 
> > ff800000        ffbfffff        Permanent, fixed read-only mapping of the
> >                                 firmware provided DT blob
> > 
> > So, I have no option but to NAK this change. Sorry.
> > 
> > You can find this documentation in the "Documentation" subdirectory.
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> Hi,
> Thanks a lot for the review and sorry for the mess. Just to make sure I
> don't push a very wrong patch another time. ipq8064 require 0x300000 of
> IO space if all 3 lines are used. From what I can read in the
> documentation, the PCI I/O mapping section does have space and can be
> expanded to ff0fffff without causing collision. So I have to update that
> part and the IO_LIMIT to 0x2fffff. Tell me if I'm completely wrong and
> again, thanks for the review.

Well, an obvious question would be: do you really need that much IO
space? PCs have got away with 64K of IO space without having a problem
for years, so 64K per bus should be fine. If you have 3 buses, that
should be 3 * 64K or 192K.

I would bet in the normal circumstance that the IO space on every PCI
bus is very sparsely used, so using 1MiB per bus seems over the top.

That said, using 1MB each for three buses takes the top of the IO space
to 0xff100000, which shouldn't be a problem, assuming memory.rst is up
to date.

In any case, I really don't think such a change has anything to do with
stable kernels, so please drop that for your next submission.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
