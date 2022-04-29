Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F45515397
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 20:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353211AbiD2S0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 14:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiD2S0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 14:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE9433366;
        Fri, 29 Apr 2022 11:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A3C36241A;
        Fri, 29 Apr 2022 18:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3060FC385A4;
        Fri, 29 Apr 2022 18:23:28 +0000 (UTC)
Date:   Fri, 29 Apr 2022 19:23:24 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Tucker <gtucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Will Deacon <will@kernel.org>,
        "kernelci . org bot" <bot@kernelci.org>,
        kernelci-results@groups.io,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] arm[64]/memremap: don't abuse pfn_valid() to ensure
 presence of linear map
Message-ID: <YmwtHOSy2vf3vw0Y@arm.com>
References: <20220426060107.7618-1-rppt@kernel.org>
 <CAMj1kXG=-YFKLkv3EkMeuhS7fiuTsEctehxRCueyTuYBxY1kUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG=-YFKLkv3EkMeuhS7fiuTsEctehxRCueyTuYBxY1kUQ@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 03:38:59PM +0200, Ard Biesheuvel wrote:
> On Tue, 26 Apr 2022 at 08:01, Mike Rapoport <rppt@kernel.org> wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> >
> > The semantics of pfn_valid() is to check presence of the memory map for a
> > PFN and not whether a PFN is covered by the linear map. The memory map may
> > be present for NOMAP memory regions, but they won't be mapped in the linear
> > mapping.  Accessing such regions via __va() when they are memremap()'ed
> > will cause a crash.
> >
> > On v5.4.y the crash happens on qemu-arm with UEFI [1]:
> >
> > <1>[    0.084476] 8<--- cut here ---
> > <1>[    0.084595] Unable to handle kernel paging request at virtual address dfb76000
> > <1>[    0.084938] pgd = (ptrval)
> > <1>[    0.085038] [dfb76000] *pgd=5f7fe801, *pte=00000000, *ppte=00000000
> >
> > ...
> >
> > <4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0x418)
> > <4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+0x8/0x10)
> > <4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_initcall+0x50/0x228)
> > <4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_init_freeable+0x15c/0x1f8)
> > <4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (kernel_init+0x8/0x10c)
> > <4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> >
> > On kernels v5.10.y and newer the same crash won't reproduce on ARM because
> > commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
> > for_each_mem_range()") changed the way memory regions are registered in the
> > resource tree, but that merely covers up the problem.
> >
> > On ARM64 memory resources registered in yet another way and there the
> > issue of wrong usage of pfn_valid() to ensure availability of the linear
> > map is also covered.
> >
> > Implement arch_memremap_can_ram_remap() on ARM and ARM64 to prevent access
> > to NOMAP regions via the linear mapping in memremap().
> >
> > Link: https://lore.kernel.org/all/Yl65zxGgFzF1Okac@sirena.org.uk
> > Reported-by: "kernelci.org bot" <bot@kernelci.org>
> > Tested-by: Mark Brown <broonie@kernel.org>
> > Cc: stable@vger.kernel.org      # 5.4+
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> > v2: don't remove pfn_valid() from try_ram_remap(), per Ard
> >
> >  arch/arm/include/asm/io.h   | 3 +++
> >  arch/arm/mm/ioremap.c       | 8 ++++++++
> >  arch/arm64/include/asm/io.h | 4 ++++
> >  arch/arm64/mm/ioremap.c     | 8 ++++++++
> >  4 files changed, 23 insertions(+)
> >
> 
> I think this looks reasonable, but you'll need to split it in two if
> it is going through the respective arch trees.

I guess that would be best. Otherwise, if Andrew picks it up:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
