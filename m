Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820F64C51A1
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 23:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbiBYWjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 17:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiBYWjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 17:39:05 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E5C140C5;
        Fri, 25 Feb 2022 14:38:31 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21PMXKWJ022487;
        Fri, 25 Feb 2022 16:33:20 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21PMXJBw022486;
        Fri, 25 Feb 2022 16:33:19 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Fri, 25 Feb 2022 16:33:19 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: fix build errors
Message-ID: <20220225223319.GT614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none> <1645678884.dsm10mudmp.astroid@bobo.none> <20220224171207.GM614@gate.crashing.org> <1645748601.idp48wexp9.astroid@bobo.none>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645748601.idp48wexp9.astroid@bobo.none>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 10:32:02AM +1000, Nicholas Piggin wrote:
> Excerpts from Segher Boessenkool's message of February 25, 2022 3:12 am:
> > On Thu, Feb 24, 2022 at 03:05:28PM +1000, Nicholas Piggin wrote:
> >> + * gcc 10 started to emit a .machine directive at the beginning of generated
> >> + * .s files, which overrides assembler -Wa,-m<cpu> options passed down.
> >> + * Unclear if this behaviour will be reverted.
> > 
> > It will not be reverted.  If you need a certain .machine for some asm
> > code, you should write just that!
> 
> It should be reverted because it breaks old binutils which did not have
> the workaround patch for this broken gcc behaviour. And it is just
> unnecessary because -m option can already be used to do the same thing.
> 
> Not that I expect gcc to revert it.

Nothing will happen if you do not file a bug report.  And do read the
bug reporting instructions first please.

> >> +#ifdef CONFIG_CC_IS_GCC
> >> +#if (GCC_VERSION >= 100000)
> >> +#if (CONFIG_AS_VERSION == 23800)
> >> +asm(".machine any");
> >> +#endif
> >> +#endif
> >> +#endif
> >> +#endif /* __ASSEMBLY__ */
> > 
> > Abusing toplevel asm like this is broken and you *will* end up with
> > unhappiness all around.
> 
> It actually unbreaks things and reduces my unhappiness.

It is broken.  You will need -fno-toplevel-reorder, and you really do
not want that, if you *can* use it in the kernel even.

> It's only done 
> for broken compiler versions and only where as does not have the 
> workaround for the breakage.

What compiler versions?  Please file a PR.


Segher
