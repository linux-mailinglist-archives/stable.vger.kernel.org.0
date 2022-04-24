Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1549950D543
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 23:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbiDXVWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 17:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiDXVWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 17:22:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B849C7E97;
        Sun, 24 Apr 2022 14:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3407B6134A;
        Sun, 24 Apr 2022 21:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B622C385AF;
        Sun, 24 Apr 2022 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650835157;
        bh=rpvLJ5VKob5Uj1ZAM+7DRly1YYYXvxcS7/lthEv2kog=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Vn3m9tCwgrCz93GMBKTN6oEwtTM0p0cufoPU3Q45IXCdPkQMJ9VxlYrehAExZPqmZ
         H4zu4/oaPdeMjUigYRQ2P6z89J2WkMZ6Pwr9BmXubnQZ5Ozmj6AAbGRBbWcUWcKrzK
         myU0daw6faLz+f7zdovWoPQBAwfLQFm5jnSDfsvkZ5jfd7G0HAaOa8P/ci7TIStFO2
         M/D1ZLaI//h/4+1HBSvII5V9qTWcw3xRFTCqd+mFTPDCzj0NkV7ZlNlyZfYj6YmHFL
         Z2CXBhFKSwSmQJ6DLh5ttI00RyuCMQsBfCQNUw6mi+Xxbbl3f4RvPnuABr2b5lRYTv
         mIbYb9+WFv9rw==
Received: by mail-ot1-f44.google.com with SMTP id r14-20020a9d750e000000b00605446d683eso9540289otk.10;
        Sun, 24 Apr 2022 14:19:17 -0700 (PDT)
X-Gm-Message-State: AOAM532JBi/C796ZW20wW24HQ81fRRZ/8APE3vPvVlQIoouBeX6YyQ6R
        WV7c9P6lyfknGbawRk9MuvQqQ00PhOETuLJwXDs=
X-Google-Smtp-Source: ABdhPJwdCMw141j1GjcdJMBl70601blQoIItkOit2tMczuv/JXn3GhaN1daZWcZ0Pcp0rU3th9MG1KkvhLZ/EALSUgo=
X-Received: by 2002:a05:6830:242d:b0:605:589f:e2a7 with SMTP id
 k13-20020a056830242d00b00605589fe2a7mr5403190ots.71.1650835156633; Sun, 24
 Apr 2022 14:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220424172044.22220-1-rppt@kernel.org>
In-Reply-To: <20220424172044.22220-1-rppt@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 24 Apr 2022 23:19:05 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGzL2u1gOBs7EutZXXej-2-a+EouEZySXXsQ0Dz0gaKTA@mail.gmail.com>
Message-ID: <CAMj1kXGzL2u1gOBs7EutZXXej-2-a+EouEZySXXsQ0Dz0gaKTA@mail.gmail.com>
Subject: Re: [PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure
 presence of linear map
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 24 Apr 2022 at 19:22, Mike Rapoport <rppt@kernel.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> The semantics of pfn_valid() is to check presence of the memory map for a
> PFN and not whether a PFN is covered by the linear map. The memory map may
> be present for NOMAP memory regions, but they won't be mapped in the linear
> mapping.  Accessing such regions via __va() when they are memremap()'ed
> will cause a crash.
>
> On v5.4.y the crash happens on qemu-arm with UEFI [1]:
>
> <1>[    0.084476] 8<--- cut here ---
> <1>[    0.084595] Unable to handle kernel paging request at virtual address dfb76000
> <1>[    0.084938] pgd = (ptrval)
> <1>[    0.085038] [dfb76000] *pgd=5f7fe801, *pte=00000000, *ppte=00000000
>
> ...
>
> <4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0x418)
> <4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+0x8/0x10)
> <4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_initcall+0x50/0x228)
> <4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_init_freeable+0x15c/0x1f8)
> <4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (kernel_init+0x8/0x10c)
> <4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
>
> On kernels v5.10.y and newer the same crash won't reproduce on ARM because
> commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
> for_each_mem_range()") changed the way memory regions are registered in the
> resource tree, but that merely covers up the problem.
>
> On ARM64 memory resources registered in yet another way and there the
> issue of wrong usage of pfn_valid() to ensure availability of the linear
> map is also covered.
>
> Implement arch_memremap_can_ram_remap() on ARM and ARM64 to prevent access
> to NOMAP regions via the linear mapping in memremap().
>
> Link: https://lore.kernel.org/all/Yl65zxGgFzF1Okac@sirena.org.uk
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Cc: stable@vger.kernel.org      # 5.4+
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/arm/include/asm/io.h   | 4 ++++
>  arch/arm/mm/ioremap.c       | 9 ++++++++-
>  arch/arm64/include/asm/io.h | 4 ++++
>  arch/arm64/mm/ioremap.c     | 8 ++++++++
>  kernel/iomem.c              | 2 +-
>  5 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index 0c70eb688a00..fbb2eeea7285 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -145,6 +145,10 @@ extern void __iomem * (*arch_ioremap_caller)(phys_addr_t, size_t,
>         unsigned int, void *);
>  extern void (*arch_iounmap)(volatile void __iomem *);
>
> +extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
> +                                       unsigned long flags);
> +#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
> +
>  /*
>   * Bad read/write accesses...
>   */
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index aa08bcb72db9..6eb1ad24544d 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -43,7 +43,6 @@
>  #include <asm/mach/pci.h>
>  #include "mm.h"
>
> -
>  LIST_HEAD(static_vmlist);
>
>  static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
> @@ -493,3 +492,11 @@ void __init early_ioremap_init(void)
>  {
>         early_ioremap_setup();
>  }
> +
> +bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
> +                                unsigned long flags)
> +{
> +       unsigned long pfn = PHYS_PFN(offset);
> +
> +       return memblock_is_map_memory(pfn);
> +}
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 7fd836bea7eb..3995652daf81 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -192,4 +192,8 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
>  extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
>  extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
>
> +extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
> +                                       unsigned long flags);
> +#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
> +
>  #endif /* __ASM_IO_H */
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index b7c81dacabf0..b21f91cd830d 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -99,3 +99,11 @@ void __init early_ioremap_init(void)
>  {
>         early_ioremap_setup();
>  }
> +
> +bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
> +                                unsigned long flags)
> +{
> +       unsigned long pfn = PHYS_PFN(offset);
> +
> +       return pfn_is_map_memory(pfn);
> +}
> diff --git a/kernel/iomem.c b/kernel/iomem.c
> index 62c92e43aa0d..e85bed24c0a9 100644
> --- a/kernel/iomem.c
> +++ b/kernel/iomem.c
> @@ -33,7 +33,7 @@ static void *try_ram_remap(resource_size_t offset, size_t size,
>         unsigned long pfn = PHYS_PFN(offset);
>
>         /* In the simple case just return the existing linear address */
> -       if (pfn_valid(pfn) && !PageHighMem(pfn_to_page(pfn)) &&
> +       if (!PageHighMem(pfn_to_page(pfn)) &&

This looks wrong to me. Calling any of the PageXxx() accessors is only
safe if the PFN is valid, since otherwise, we don't know if the
associated struct page exists.

>             arch_memremap_can_ram_remap(offset, size, flags))
>                 return __va(offset);
>
>
> base-commit: b2d229d4ddb17db541098b83524d901257e93845
> --
> 2.28.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
