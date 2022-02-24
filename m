Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630554C33D0
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiBXRe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiBXRe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:34:28 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC67324FA34;
        Thu, 24 Feb 2022 09:33:58 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21OHTnZm019553;
        Thu, 24 Feb 2022 11:29:49 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21OHTmdO019552;
        Thu, 24 Feb 2022 11:29:48 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 24 Feb 2022 11:29:48 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
Message-ID: <20220224172948.GN614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none> <1645678884.dsm10mudmp.astroid@bobo.none> <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com> <1645694174.z03tip9set.astroid@bobo.none> <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com> <1645700767.qxyu8a9wl9.astroid@bobo.none>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645700767.qxyu8a9wl9.astroid@bobo.none>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 24, 2022 at 09:13:25PM +1000, Nicholas Piggin wrote:
> Excerpts from Arnd Bergmann's message of February 24, 2022 8:20 pm:
> > Again, there should be a minimum number of those .machine directives
> > in inline asm as well, which tends to work out fine as long as the
> > entire kernel is built with the correct -march= option for the minimum
> > supported CPU, and stays away from inline asm that requires a higher
> > CPU level.
> 
> There's really no advantage to them, and they're ugly and annoying
> and if we applied the concept consistently for all asm they would grow 
> to a very large number.

The advantage is that you get machine code that *works*.  There are
quite a few mnemonics that translate to different instructions with
different machine options!  We like to get the intended instructions
instead of something that depends on what assembler options the user
has passed behind our backs.

> The idea they'll give you good static checking just doesn't really
> pan out.

That never was a goal of this at all.

-many was very problematical for GCC itself.  We no longer use it.


Segher
