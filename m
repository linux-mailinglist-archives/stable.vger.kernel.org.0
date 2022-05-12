Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400E0524E9C
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354603AbiELNr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354447AbiELNr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBEB6338A;
        Thu, 12 May 2022 06:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05880B8282F;
        Thu, 12 May 2022 13:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FDC385B8;
        Thu, 12 May 2022 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652363242;
        bh=QnAboaGCzXaUccvSKc1weEzH5sef3lKcxkcSkvyUbyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cw8tPsy76xnxGZoDDVUdaHcGQ/kQv6HUTeBWhvt/vgFwtbM7SVoxW7ncMlcuHOe9l
         d4Eb/rpJwXF3ysLAmUzEglMvtsbrpT05yYmpWZviP4aGzeVFCcP++Xa4yJijfz9yuo
         TFXurnnMhyI7UWo/F0NecA0z2j/PWh4DYJeBFirE=
Date:   Thu, 12 May 2022 15:47:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>, kbuild-all@lists.01.org,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10] arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
Message-ID: <Yn0P6G/TJK1kEUMs@kroah.com>
References: <20220510171523.98999-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510171523.98999-1-rppt@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 08:15:23PM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> commit 5e545df3292fbd3d5963c68980f1527ead2a2b3f upstream.
> 
> ARM is the only architecture that defines CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
> which in turn enables memmap_valid_within() function that is intended to
> verify existence  of struct page associated with a pfn when there are holes
> in the memory map.
> 
> However, the ARCH_HAS_HOLES_MEMORYMODEL also enables HAVE_ARCH_PFN_VALID
> and arch-specific pfn_valid() implementation that also deals with the holes
> in the memory map.
> 
> The only two users of memmap_valid_within() call this function after
> a call to pfn_valid() so the memmap_valid_within() check becomes redundant.
> 
> Remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL and memmap_valid_within() and rely
> entirely on ARM's implementation of pfn_valid() that is now enabled
> unconditionally.
> 
> Link: https://lkml.kernel.org/r/20201101170454.9567-9-rppt@kernel.org
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Ungerer <gerg@linux-m68k.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: Meelis Roos <mroos@linux.ee>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 8dd559d53b3b ("arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  Documentation/vm/memory-model.rst |  3 +--
>  arch/arm/Kconfig                  |  8 ++------
>  arch/arm/mach-bcm/Kconfig         |  1 -
>  arch/arm/mach-davinci/Kconfig     |  1 -
>  arch/arm/mach-exynos/Kconfig      |  1 -
>  arch/arm/mach-highbank/Kconfig    |  1 -
>  arch/arm/mach-omap2/Kconfig       |  1 -
>  arch/arm/mach-s5pv210/Kconfig     |  1 -
>  arch/arm/mach-tango/Kconfig       |  1 -
>  fs/proc/kcore.c                   |  2 --
>  include/linux/mmzone.h            | 31 -------------------------------
>  mm/mmzone.c                       | 14 --------------
>  mm/vmstat.c                       |  4 ----
>  13 files changed, 3 insertions(+), 66 deletions(-)

Both now queued up, thanks.

greg k-h
