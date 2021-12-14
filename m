Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A750473EFB
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 10:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhLNJJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 04:09:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59144 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhLNJJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 04:09:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C258613CA
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 09:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E503C34601;
        Tue, 14 Dec 2021 09:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639472987;
        bh=TY/uteTvb0qT4VLNjiomjceokQrEp7xF5R/gKZPG7PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znV+Q6OQULeeyq3fIDGuLNKmV8Fi/KjxkIzWBa0PcD35fOs+uEz/qdKkjDtg5oME/
         Kyv9vobIm0EfgRXBzMsD2FzP6/Caa4y9LCIxOkt1Ab39TSG42h8twUqdNSnNoUEu+Z
         p9GQwzPv+5NDxRqitzLXEvurITjpl+5XVaKKhJ3o=
Date:   Tue, 14 Dec 2021 10:09:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
Message-ID: <YbhfWHTL8Kobq9vv@kroah.com>
References: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 11, 2021 at 11:19:00AM -0600, Tom Lendacky wrote:
> commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream
> to be applied to 4.14, 4.19 and 5.4.
> 
> Reserving memory using efi_mem_reserve() calls into the x86
> efi_arch_mem_reserve() function. This function will insert a new EFI
> memory descriptor into the EFI memory map representing the area of
> memory to be reserved and marking it as EFI runtime memory. As part
> of adding this new entry, a new EFI memory map is allocated and mapped.
> The mapping is where a problem can occur. This new memory map is mapped
> using early_memremap() and generally mapped encrypted, unless the new
> memory for the mapping happens to come from an area of memory that is
> marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
> be mapped unencrypted. However, during replacement of the old memory map,
> efi_mem_type() is disabled, so the new memory map will now be long-term
> mapped encrypted (in efi.memmap), resulting in the map containing invalid
> data and causing the kernel boot to crash.
> 
> Since it is known that the area will be mapped encrypted going forward,
> explicitly map the new memory map as encrypted using early_memremap_prot().
> 
> Cc: <stable@vger.kernel.org> # 4.14.x
> Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> Link: https://lore.kernel.org/all/ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com/
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ardb: incorporate Kconfig fix by Arnd]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/Kconfig               | 1 +
>  arch/x86/platform/efi/quirks.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c2a3ec3dd850..c6c71592f6e4 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1990,6 +1990,7 @@ config EFI
>  	depends on ACPI
>  	select UCS2_STRING
>  	select EFI_RUNTIME_WRAPPERS
> +	select ARCH_USE_MEMREMAP_PROT
>  	---help---
>  	  This enables the kernel to use EFI runtime services that are
>  	  available (such as the EFI variable services).
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index aefe845dff59..6ca88fbc009c 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -279,7 +279,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>  		return;
>  	}
>  
> -	new = early_memremap(new_phys, new_size);
> +	new = early_memremap_prot(new_phys, new_size,
> +				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
>  	if (!new) {
>  		pr_err("Failed to map new boot services memmap\n");
>  		return;
> -- 
> 2.33.1
> 

This seems to cause config warnings as reported here:
	https://lore.kernel.org/r/CA+G9fYsEQCjOi_58WcMb4i-2t1Gv=KjPuWa6L792YAZF=zzinw@mail.gmail.com
and:
	https://lore.kernel.org/r/CA+G9fYuCFSbLMarXOnapUXN_NRgQMkjfr_rSTPjzBJQ-FT-Q3g@mail.gmail.com

so I will be dropping this commit from the 4.14, 4.19, and 5.4 trees.
Can you please fix this up and resend?

thanks,

greg k-h
