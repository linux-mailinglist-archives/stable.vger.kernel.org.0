Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480995147A4
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbiD2K7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358074AbiD2K7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:59:13 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18F3EA76DD;
        Fri, 29 Apr 2022 03:55:54 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 97E2792009C; Fri, 29 Apr 2022 12:55:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 8B80892009B;
        Fri, 29 Apr 2022 11:55:53 +0100 (BST)
Date:   Fri, 29 Apr 2022 11:55:53 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
In-Reply-To: <20220429100128.GB11365@alpha.franken.de>
Message-ID: <alpine.DEB.2.21.2204291119040.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk> <20220429100128.GB11365@alpha.franken.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Apr 2022, Thomas Bogendoerfer wrote:

> > Fix the discrepancy between the two places we check for the CP0 counter 
> > erratum in along with the incorrect comparison of the R4400 revision 
> > number against 0x30 which matches none and consistently consider all 
> > R4000 and R4400 processors affected, as documented in processor errata 
> > publications[1][2][3], following the mapping between CP0 PRId register 
> > values and processor models:
> > 
> >   PRId   |  Processor Model
> > ---------+--------------------
> > 00000422 | R4000 Revision 2.2
> > 00000430 | R4000 Revision 3.0
> > 00000440 | R4400 Revision 1.0
> > 00000450 | R4400 Revision 2.0
> > 00000460 | R4400 Revision 3.0
> 
> interesting, where is this documented ? And it's quite funny that so far
> everybody messed up revision printing for R4400 CPUs. 

 That's just observation combined with past discussions with Ralf.

 Basically the PRId implementation number is 0x04 for both the R4000 and 
the R4400 (the only difference between the two CPUs is the addition of the 
write-back buffer in the latter one, making it weakly ordered).  And then 
the PRId revision number matches exactly the documented CPU revision for 
the R4000, while for the R4400 you need to subtract 3 from the PRId 
revision number to get the documented CPU revision (i.e. what would be 
R4000 Revision 4.0 actually became R4400 Revision 1.0).

 At this time no old MIPSer from the SGI days may be around to confirm or 
contradict this observation.  Documentation explicitly says[1]:

"The revision number can distinguish some chip revisions, however there is 
no guarantee that changes to the chip will necessarily be reflected in the 
PRId register, or that changes to the revision number necessarily reflect 
real chip changes.  For this reason, these values are not listed and 
software should not rely on the revision number in the PRId register to 
characterize the chip."

but surely the author didn't have errata workarounds in mind plus all CPU 
revisions have already been manufactured so the mapping has been fixed.

> >  Conversely a system can do without a high-precision clock source, in
> > which case jiffies will be used.  Of course such a system will suffer if 
> > used for precision timekeeping, but such is the price for broken hardware.  
> > Don't SNI systems have any alternative timer available, not even the 
> > venerable 8254?
> 
> all SNI systems have a i8254 in their EISA/PCI chipsets. But they aren't
> that nice for clock events as their interupts are connected via an i8259
> addresses via ISA PIO. 

 Interrupts are used for clock events, so you don't need one here.  For 
clock sources you just read the counter.

 That said reading from the 8254 is messy too and you may need a spinlock 
(you need to write the Counter Latch or Read-Back command to the control 
register and then issue consecutive two reads to the requested timer's 
data register[2]).  Which is I guess why support for it has been removed 
from x86 code.  For non-SMP it might be good enough.

> >  With the considerations above in mind, please apply.
> 
> will do later.

 Great, thanks!

References:

[1] Joe Heinrich: "MIPS R4000 Microprocessor User's Manual", Second
    Edition, MIPS Technologies, Inc., April 1, 1994, Chapter 4 "Memory 
    Management", p.90

[2] "8254 Programmable Interval Timer", Intel Corporation, Order Number: 
    231164-005, September 1993, Section "Read Operations", pp.7-9

  Maciej
