Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F282514ABD
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352129AbiD2Nmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 09:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357952AbiD2Nmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 09:42:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AED1CB036;
        Fri, 29 Apr 2022 06:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4922622B7;
        Fri, 29 Apr 2022 13:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1C5C385B7;
        Fri, 29 Apr 2022 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651239552;
        bh=N9fQmEl3ImvB9J7VUSPgaqnkcUMXRSpOC2WJD514V+0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vRMWlIw46xZ4PUBO6CL6zDq8poNp54VbHQ7VuENmgOwp/wnbycRE4v3oQ5HMGV7Ja
         Ss5tiEpr8pbZYlY1z2QmGIKiKonn1xwlVYEFpQycPxgAdlUGowTcZ3aodlK1cO/DAs
         nZLYGcdp8B9dtNVbH3AAze2sEMO3lw5OdQNqnAJFCG8Jvr+PDm6yOwlGB4T15CieHl
         htZQ7qPZ2x01YVAviEsvaRZ4u6WdCAEW2Jkh216N5MtU0gQi9gPxS3fLqaJ3GV4H0o
         3CIK12NmGJs9NumheTn1zTN3swwTtur7aSUd0hKHR66PjyLGqmNb5eUuCK9JLBDJP2
         VAy3afiE8Wp6Q==
Received: by mail-oi1-f181.google.com with SMTP id l203so8577262oif.0;
        Fri, 29 Apr 2022 06:39:12 -0700 (PDT)
X-Gm-Message-State: AOAM533hpWj4ec1m2yQuxpTr5MzMMq6OlrDSJJzPU+boWzgROf/UxXdS
        idW845RNoPtymZ79XtAOP9nSyWZ57mYSm9QidbQ=
X-Google-Smtp-Source: ABdhPJyfcM/dpIqHcAvX21o5Cf+UNAua/EhPe35gS7dpx3y4FsOiH9bq+O94L0HeoPl+2Z1iI+tS76jLqoO83/0kiOI=
X-Received: by 2002:a05:6808:e8d:b0:322:bac0:2943 with SMTP id
 k13-20020a0568080e8d00b00322bac02943mr1461318oil.126.1651239551067; Fri, 29
 Apr 2022 06:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220426060107.7618-1-rppt@kernel.org>
In-Reply-To: <20220426060107.7618-1-rppt@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 29 Apr 2022 15:38:59 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG=-YFKLkv3EkMeuhS7fiuTsEctehxRCueyTuYBxY1kUQ@mail.gmail.com>
Message-ID: <CAMj1kXG=-YFKLkv3EkMeuhS7fiuTsEctehxRCueyTuYBxY1kUQ@mail.gmail.com>
Subject: Re: [PATCH v2] arm[64]/memremap: don't abuse pfn_valid() to ensure
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 at 08:01, Mike Rapoport <rppt@kernel.org> wrote:
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
> v2: don't remove pfn_valid() from try_ram_remap(), per Ard
>
>  arch/arm/include/asm/io.h   | 3 +++
>  arch/arm/mm/ioremap.c       | 8 ++++++++
>  arch/arm64/include/asm/io.h | 4 ++++
>  arch/arm64/mm/ioremap.c     | 8 ++++++++
>  4 files changed, 23 insertions(+)
>

I think this looks reasonable, but you'll need to split it in two if
it is going through the respective arch trees.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index 0c70eb688a00..2a0739a2350b 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -440,6 +440,9 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
>  #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>  extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
>  extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
> +extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
> +                                       unsigned long flags);
> +#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
>  #endif
>
>  /*
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index aa08bcb72db9..290702328a33 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -493,3 +493,11 @@ void __init early_ioremap_init(void)
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
>
> base-commit: b2d229d4ddb17db541098b83524d901257e93845
> --
> 2.28.0
>
