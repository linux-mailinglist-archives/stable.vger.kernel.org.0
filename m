Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06038514C29
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 16:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376913AbiD2OGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 10:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376912AbiD2OG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 10:06:27 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 327FF5BD34;
        Fri, 29 Apr 2022 06:54:42 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nkR4B-0004Nf-00; Fri, 29 Apr 2022 15:53:51 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 77961C01CB; Fri, 29 Apr 2022 15:53:38 +0200 (CEST)
Date:   Fri, 29 Apr 2022 15:53:38 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Message-ID: <20220429135338.GA3357@alpha.franken.de>
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
> 
> No other revision of either processor has ever been spotted.
> 
> Contrary to what has been stated in commit ce202cbb9e0b ("[MIPS] Assume 
> R4000/R4400 newer than 3.0 don't have the mfc0 count bug") marking the 
> CP0 counter as buggy does not preclude it from being used as either a 
> clock event or a clock source device.  It just cannot be used as both at 
> a time, because in that case clock event interrupts will be occasionally 
> lost, and the use as a clock event device takes precedence.
> 
> Compare against 0x4ff in `can_use_mips_counter' so that a single machine 
> instruction is produced.
> 
> References:
> 
> [1] "MIPS R4000PC/SC Errata, Processor Revision 2.2 and 3.0", MIPS
>     Technologies Inc., May 10, 1994, Erratum 53, p.13
> 
> [2] "MIPS R4400PC/SC Errata, Processor Revision 1.0", MIPS Technologies
>     Inc., February 9, 1994, Erratum 21, p.4
> 
> [3] "MIPS R4400PC/SC Errata, Processor Revision 2.0 & 3.0", MIPS 
>     Technologies Inc., January 24, 1995, Erratum 14, p.3
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: ce202cbb9e0b ("[MIPS] Assume R4000/R4400 newer than 3.0 don't have the mfc0 count bug")
> Cc: stable@vger.kernel.org # v2.6.24+
> ---
> Thomas,
> 
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
> 
>  Long-term I think this code should be factored out and rewritten so that 
> it lives in one place and can take advantage of compile-time constants, 
> which will be the case for the majority of platforms.  For the time being 
> fix the immediate breakage however.
> 
>  With the considerations above in mind, please apply.
> 
>   Maciej
> ---
>  arch/mips/include/asm/timex.h |    8 ++++----
>  arch/mips/kernel/time.c       |   11 +++--------
>  2 files changed, 7 insertions(+), 12 deletions(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
