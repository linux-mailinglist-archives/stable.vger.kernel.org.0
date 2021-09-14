Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E9740A8AB
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhINHyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhINHyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:54:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBF5661056;
        Tue, 14 Sep 2021 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631605969;
        bh=0naE1qrmfOABfJYDDKG+OSU0koFiRK7dYXmRlyCjsXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZkLO4m9MHy8PBhbfTRXr8fhl5bHGkGyH/wsqBD4YU9DW7nyho+OqiGZPNblu5M1sf
         U4RofQhole4A8lSQR0hLevVv4fAqU2v240nEdSpWZTpjYdBHSP8+S9aiwY0KCLjVNR
         af2xtYNzRqdLmAVIjBgaOMmzpTTzZebW0C5uCEim0aF9Ub/hsLiPPvN93MxhQt45le
         2F27uqpnIsvrZGwtmLM3hUP7PtYCpCngw1uhA6n9O7wPGsVErK0Xuj3/yiuhslvO+6
         sPwudecKzamFRoLcU34Dd8fj74uuEMFVt6QlHVz+XtoDFwfdgagZLvjf0IIf/VhDPr
         kdaXff9YicfjQ==
Date:   Tue, 14 Sep 2021 10:52:39 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, jroedel@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/64/mm: Map all kernel memory into trampoline_pgd
Message-ID: <YUBUx6KVwAp9b3b4@kernel.org>
References: <20210913095236.24937-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913095236.24937-1-joro@8bytes.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 11:52:36AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The trampoline_pgd only maps the 0xfffffff000000000-0xffffffffffffffff
> range of kernel memory (with 4-level paging). This range contains the
> kernels text+data+bss mappings and the module mapping space, but not the
> direct mapping and the vmalloc area.
> 
> This is enough to get an application processors out of real-mode, but
> for code that switches back to real-mode the trampoline_pgd is missing
> important parts of the address space. For example, consider this code
> from arch/x86/kernel/reboot.c, function machine_real_restart() for a
> 64-bit kernel:
> 
> 	#ifdef CONFIG_X86_32
> 		load_cr3(initial_page_table);
> 	#else
> 		write_cr3(real_mode_header->trampoline_pgd);
> 
> 		/* Exiting long mode will fail if CR4.PCIDE is set. */
> 		if (boot_cpu_has(X86_FEATURE_PCID))
> 			cr4_clear_bits(X86_CR4_PCIDE);
> 	#endif
> 
> 		/* Jump to the identity-mapped low memory code */
> 	#ifdef CONFIG_X86_32
> 		asm volatile("jmpl *%0" : :
> 			     "rm" (real_mode_header->machine_real_restart_asm),
> 			     "a" (type));
> 	#else
> 		asm volatile("ljmpl *%0" : :
> 			     "m" (real_mode_header->machine_real_restart_asm),
> 			     "D" (type));
> 	#endif
> 
> The code switches to the trampoline_pgd, which unmaps the direct mapping
> and also the kernel stack. The call to cr4_clear_bits() will find no
> stack and crash the machine. The real_mode_header pointer below points
> into the direct mapping, and dereferencing it also causes a crash.
> 
> The reason this does not crash always is only that kernel mappings are
> global and the CR3 switch does not flush those mappings. But if theses
> mappings are not in the TLB already, the above code will crash before it
> can jump to the real-mode stub.
> 
> Extend the trampoline_pgd to contain all kernel mappings to prevent
> these crashes and to make code which runs on this page-table more
> robust.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/realmode/init.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 31b5856010cb..7a08c96cb42a 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -72,6 +72,7 @@ static void __init setup_real_mode(void)
>  #ifdef CONFIG_X86_64
>  	u64 *trampoline_pgd;
>  	u64 efer;
> +	int i;
>  #endif
>  
>  	base = (unsigned char *)real_mode_header;
> @@ -128,8 +129,17 @@ static void __init setup_real_mode(void)
>  	trampoline_header->flags = 0;
>  
>  	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
> +
> +	/*
> +	 * Map all of kernel memory into the trampoline PGD so that it includes
> +	 * the direct mapping and vmalloc space. This is needed to keep the
> +	 * stack and real_mode_header mapped when switching to this page table.
> +	 */
> +	for (i = pgd_index(__PAGE_OFFSET); i < PTRS_PER_PGD; i++)
> +		trampoline_pgd[i] = init_top_pgt[i].pgd;

Don't we need to update the trampoline_pgd in sync_global_pgds() as well?

> +
> +	/* Map the real mode stub as virtual == physical */
>  	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
> -	trampoline_pgd[511] = init_top_pgt[511].pgd;
>  #endif
>  
>  	sme_sev_setup_real_mode(trampoline_header);
> -- 
> 2.33.0
> 

-- 
Sincerely yours,
Mike.
