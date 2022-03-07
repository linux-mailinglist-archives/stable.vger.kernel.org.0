Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE6C4CFE4C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 13:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242167AbiCGM0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 07:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242140AbiCGM0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 07:26:19 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18DA480926;
        Mon,  7 Mar 2022 04:25:25 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nRCQS-00072o-02; Mon, 07 Mar 2022 13:25:20 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 4DB79C1280; Mon,  7 Mar 2022 13:21:02 +0100 (CET)
Date:   Mon, 7 Mar 2022 13:21:02 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] DEC: Limit PMAX memory probing to R3k systems
Message-ID: <20220307122102.GC14422@alpha.franken.de>
References: <alpine.DEB.2.21.2203041838380.47558@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2203041838380.47558@angie.orcam.me.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 08:16:23PM +0000, Maciej W. Rozycki wrote:
> Recent tightening of the opcode table in binutils so as to consistently 
> disallow the assembly or disassembly of CP0 instructions not supported 
> by the processor architecture chosen has caused a regression like below:
> 
> arch/mips/dec/prom/locore.S: Assembler messages:
> arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this processor: r4600 (mips3) `rfe'
> 
> in a piece of code used to probe for memory with PMAX DECstation models, 
> which have non-REX firmware.  Those computers always have an R2000 CPU 
> and consequently the exception handler used in memory probing uses the 
> RFE instruction, which those processors use.
> 
> While adding 64-bit support this code was correctly excluded for 64-bit 
> configurations, however it should have also been excluded for irrelevant 
> 32-bit configurations.  Do this now then, and only enable PMAX memory 
> probing for R3k systems.
> 
> Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org # v2.6.12+
> ---
> Hi,
> 
>  I'm assuming this won't go back beyond commit 2a11c8ea20bf ("kconfig: 
> Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()") or any backport 
> will have to be rewritten to avoid IS_ENABLED.
> 
>  The original actual change named to fix ought to be commit dd82ef87e4c9 
> ("PROM interface rework to support a 64-bit kernel.") from the LMO repo: 
> <https://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git/commit/?id=dd82ef87e4c9>, 
> which introduced the `prom_is_rex' macro, which guards this code.  Said 
> commit predates the history of our main repository though.
> 
>  This change has actually been verified at runtime with a PMIN system 
> (effectively a PMAX, but with a slower R2000 CPU) and a 4MAX+ system (an 
> R4400SC-based machine), and naturally throughout the three possible build 
> configurations: R3k, R4k/32-bit, R4k/64-bit.
> 
>  It took longer than expected, but oh well...  Sorry for the inconvenience 
> caused.
> 
>  Please apply,
> 
>   Maciej
> ---
>  arch/mips/dec/prom/Makefile      |    2 +-
>  arch/mips/include/asm/dec/prom.h |   15 +++++----------
>  2 files changed, 6 insertions(+), 11 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
