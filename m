Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639ED514629
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiD2KFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiD2KFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:05:03 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C645578FD4;
        Fri, 29 Apr 2022 03:01:43 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nkNRW-0002HQ-01; Fri, 29 Apr 2022 12:01:42 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 438A7C01CB; Fri, 29 Apr 2022 12:01:28 +0200 (CEST)
Date:   Fri, 29 Apr 2022 12:01:28 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Message-ID: <20220429100128.GB11365@alpha.franken.de>
References: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 24, 2022 at 12:46:23PM +0100, Maciej W. Rozycki wrote:
> Fix the discrepancy between the two places we check for the CP0 counter 
> erratum in along with the incorrect comparison of the R4400 revision 
> number against 0x30 which matches none and consistently consider all 
> R4000 and R4400 processors affected, as documented in processor errata 
> publications[1][2][3], following the mapping between CP0 PRId register 
> values and processor models:
> 
>   PRId   |  Processor Model
> ---------+--------------------
> 00000422 | R4000 Revision 2.2
> 00000430 | R4000 Revision 3.0
> 00000440 | R4400 Revision 1.0
> 00000450 | R4400 Revision 2.0
> 00000460 | R4400 Revision 3.0

interesting, where is this documented ? And it's quite funny that so far
everybody messed up revision printing for R4400 CPUs. 

>  Please review the requirements for SNI platforms.  In the case of an 
> erratic CP0 timer we give precedence to the use as a clock event rather 
> than clock source device; see `time_init' in arch/mips/kernel/time.c. 
> Therefore if SNI systems have no alternative timer interrupt source, then 
> the CP0 timer is supposed to still do regardless of the erratum.
>
>  Conversely a system can do without a high-precision clock source, in
> which case jiffies will be used.  Of course such a system will suffer if 
> used for precision timekeeping, but such is the price for broken hardware.  
> Don't SNI systems have any alternative timer available, not even the 
> venerable 8254?

all SNI systems have a i8254 in their EISA/PCI chipsets. But they aren't
that nice for clock events as their interupts are connected via an i8259
addresses via ISA PIO. 

>  With the considerations above in mind, please apply.

will do later.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
