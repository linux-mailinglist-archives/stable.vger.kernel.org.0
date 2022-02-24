Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E024C335C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiBXRRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiBXRRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:17:50 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0413177753;
        Thu, 24 Feb 2022 09:17:20 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21OHC9uw018499;
        Thu, 24 Feb 2022 11:12:09 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21OHC8Yn018496;
        Thu, 24 Feb 2022 11:12:08 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 24 Feb 2022 11:12:07 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>, mpe@ellerman.id.au,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
Message-ID: <20220224171207.GM614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none> <1645678884.dsm10mudmp.astroid@bobo.none>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645678884.dsm10mudmp.astroid@bobo.none>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 03:05:28PM +1000, Nicholas Piggin wrote:
> + * gcc 10 started to emit a .machine directive at the beginning of generated
> + * .s files, which overrides assembler -Wa,-m<cpu> options passed down.
> + * Unclear if this behaviour will be reverted.

It will not be reverted.  If you need a certain .machine for some asm
code, you should write just that!

> +#ifdef CONFIG_CC_IS_GCC
> +#if (GCC_VERSION >= 100000)
> +#if (CONFIG_AS_VERSION == 23800)
> +asm(".machine any");
> +#endif
> +#endif
> +#endif
> +#endif /* __ASSEMBLY__ */

Abusing toplevel asm like this is broken and you *will* end up with
unhappiness all around.


Segher
