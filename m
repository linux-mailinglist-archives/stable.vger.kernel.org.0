Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2DE3CB728
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhGPMNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 08:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232085AbhGPMNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 08:13:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24EEA6128B;
        Fri, 16 Jul 2021 12:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626437426;
        bh=Oi9M1FnUn5e6PKKsPa8PI7WcOoFC+K32ceOQ98rLJCs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Orphy0+GFAEfcVZy9yZqB5p7ky4hLZ0YYs6o9KF+a4klC91YHgFeioM8sIF50dNDG
         babGnhsvAaKe+6IyFJG/4iFr9v8gRVTSAQNImLrYepIYEMKDbGOgQl74Y4ZB7+lBX8
         6XSS1N3N/AI3AdQsgk6YgRVAs0gWxRT0ExVivCvg9w+wfHK1Q6TsJ7jqfSuRouJMGE
         BvzkXR9Z+amZdh7ob+IRZwn155Oecv4ZZtlTkt2VDNDg6Two0ci5yZHXxzYNsUF/Zf
         j+jGlftTvI1r6VELV1KgJ2eY+HjQ4JAMppiqqpGOZL/dc5IQ5zHj0C9zwx7VX1L0dj
         C0TgmpaLF2TlA==
Received: by mail-oi1-f182.google.com with SMTP id t25so10588785oiw.13;
        Fri, 16 Jul 2021 05:10:26 -0700 (PDT)
X-Gm-Message-State: AOAM533n644O0UYns/2A5z2NVCoREO9tIylSeKby+xssGCMHiIxX3DgW
        t/uwlcnjOSUd5Ria26MLIre4+s04OcB+RveUmSQ=
X-Google-Smtp-Source: ABdhPJwO2rOiZGFUAuLZ6xGESBy20y8GPeDv89fUsa0DONO3TPaC/69qOoyztsFiak9DuENASrV6yJ8fglb96eYUTRo=
X-Received: by 2002:aca:4c49:: with SMTP id z70mr7521680oia.174.1626437425519;
 Fri, 16 Jul 2021 05:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210713184326.570923-1-maz@kernel.org>
In-Reply-To: <20210713184326.570923-1-maz@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 16 Jul 2021 14:10:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEB6eRPOLAaz7gWgUrpn2R6fy6kJ=S8u_54kNfQCbEfqg@mail.gmail.com>
Message-ID: <CAMj1kXEB6eRPOLAaz7gWgUrpn2R6fy6kJ=S8u_54kNfQCbEfqg@mail.gmail.com>
Subject: Re: [PATCH v2] firmware/efi: Tell memblock about EFI iomem reservations
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wnliu@google.com, Moritz Fischer <mdf@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Jul 2021 at 20:43, Marc Zyngier <maz@kernel.org> wrote:
>
> kexec_load_file() relies on the memblock infrastructure to avoid
> stamping over regions of memory that are essential to the survival
> of the system.
>
> However, nobody seems to agree how to flag these regions as reserved,
> and (for example) EFI only publishes its reservations in /proc/iomem
> for the benefit of the traditional, userspace based kexec tool.
>
> On arm64 platforms with GICv3, this can result in the payload being
> placed at the location of the LPI tables. Shock, horror!
>
> Let's augment the EFI reservation code with a memblock_reserve() call,
> protecting our dear tables from the secondary kernel invasion.
>
> Reported-by: Moritz Fischer <mdf@kernel.org>
> Tested-by: Moritz Fischer <mdf@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

Thanks, I'll queue this as a fix.

> ---
>  drivers/firmware/efi/efi.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 4b7ee3fa9224..847f33ffc4ae 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -896,6 +896,7 @@ static int __init efi_memreserve_map_root(void)
>  static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
>  {
>         struct resource *res, *parent;
> +       int ret;
>
>         res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
>         if (!res)
> @@ -908,7 +909,17 @@ static int efi_mem_reserve_iomem(phys_addr_t addr, u64 size)
>
>         /* we expect a conflict with a 'System RAM' region */
>         parent = request_resource_conflict(&iomem_resource, res);
> -       return parent ? request_resource(parent, res) : 0;
> +       ret = parent ? request_resource(parent, res) : 0;
> +
> +       /*
> +        * Given that efi_mem_reserve_iomem() can be called at any
> +        * time, only call memblock_reserve() if the architecture
> +        * keeps the infrastructure around.
> +        */
> +       if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !ret)
> +               memblock_reserve(addr, size);
> +
> +       return ret;
>  }
>
>  int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
> --
> 2.30.2
>
