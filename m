Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BED65D0CF
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 11:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjADKkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 05:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjADKkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 05:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C288412D16;
        Wed,  4 Jan 2023 02:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D58616BC;
        Wed,  4 Jan 2023 10:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BC1C433D2;
        Wed,  4 Jan 2023 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672828808;
        bh=6FPalQcepNo+BytQcBdBWjxpEdX/NRvyniuyigHLcxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mmEmzDPfxMmSxpPDiRkY/nrdd55CTcgFlLje3h7S1aWx78vpJkREtHfhbxXc81T7Q
         qMFgGjpIqNSe755Gb1gYu21gADJJqZWcSIH3lMfcz82jyHw7giqOU1xIaPhhrKrBwr
         FxH18m8dfPhQHz2E70eVL5ogOM1QDy2b5lKfeI+/xqtuig4OPnoUHSg1yqpBgEhHom
         FQTXcDn8nuyVlgbx9yrJrcIJ6nXVSisum4vbvhoAklLPl3DrfATQI0nOKhHOJpMcFv
         PiwWMtcwC/NySZWPvd9znWYUYvt9G/RLrz5WYfnTfBXNfJGiesqWlfD0zb2qg6NB3G
         z35omPmmuzYPg==
Date:   Wed, 4 Jan 2023 10:40:03 +0000
From:   Lee Jones <lee@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Cc:     linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y7VXg5MCRyAJFmus@google.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205201210.463781-2-ardb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Dec 2022, Ard Biesheuvel wrote:

> With the introduction of PRMT in the ACPI subsystem, the EFI rts
> workqueue is no longer the only caller of efi_call_virt_pointer() in the
> kernel. This means the EFI runtime services lock is no longer sufficient
> to manage concurrent calls into firmware, but also that firmware calls
> may occur that are not marshalled via the workqueue mechanism, but
> originate directly from the caller context.
> 
> For added robustness, and to ensure that the runtime services have 8 KiB
> of stack space available as per the EFI spec, introduce a spinlock
> protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> serialization between the EFI rts workqueue (which itself serializes EFI
> runtime calls) and other callers of efi_call_virt_pointer().
> 
> While at it, use the stack pivot to avoid reloading the shadow call
> stack pointer from the ordinary stack, as doing so could produce a
> gadget to defeat it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/efi.h       |  3 +++
>  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
>  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
>  3 files changed, 40 insertions(+), 1 deletion(-)

Could we have this in Stable please?

Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")

Ard, do we need Patch 2 as well, or can this be applied on its own?

> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index 7c12e01c2b312e7b..1c408ec3c8b3a883 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -25,6 +25,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
>  ({									\
>  	efi_virtmap_load();						\
>  	__efi_fpsimd_begin();						\
> +	spin_lock(&efi_rt_lock);					\
>  })
>  
>  #undef arch_efi_call_virt
> @@ -33,10 +34,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
>  
>  #define arch_efi_call_virt_teardown()					\
>  ({									\
> +	spin_unlock(&efi_rt_lock);					\
>  	__efi_fpsimd_end();						\
>  	efi_virtmap_unload();						\
>  })
>  
> +extern spinlock_t efi_rt_lock;
>  efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
>  
>  #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
> diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
> index 75691a2641c1c0f8..b2786b968fee68dd 100644
> --- a/arch/arm64/kernel/efi-rt-wrapper.S
> +++ b/arch/arm64/kernel/efi-rt-wrapper.S
> @@ -16,6 +16,12 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
>  	 */
>  	stp	x1, x18, [sp, #16]
>  
> +	ldr_l	x16, efi_rt_stack_top
> +	mov	sp, x16
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	str	x18, [sp, #-16]!
> +#endif
> +
>  	/*
>  	 * We are lucky enough that no EFI runtime services take more than
>  	 * 5 arguments, so all are passed in registers rather than via the
> @@ -29,6 +35,7 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
>  	mov	x4, x6
>  	blr	x8
>  
> +	mov	sp, x29
>  	ldp	x1, x2, [sp, #16]
>  	cmp	x2, x18
>  	ldp	x29, x30, [sp], #32
> @@ -42,6 +49,10 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
>  	 * called with preemption disabled and a separate shadow stack is used
>  	 * for interrupts.
>  	 */
> -	mov	x18, x2
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	ldr_l	x18, efi_rt_stack_top
> +	ldr	x18, [x18, #-16]
> +#endif
> +
>  	b	efi_handle_corrupted_x18	// tail call
>  SYM_FUNC_END(__efi_rt_asm_wrapper)
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index a908a37f03678b6b..8cb2e005f8aca589 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -144,3 +144,28 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
>  	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
>  	return s;
>  }
> +
> +DEFINE_SPINLOCK(efi_rt_lock);
> +
> +asmlinkage u64 *efi_rt_stack_top __ro_after_init;
> +
> +/* required by the EFI spec */
> +static_assert(THREAD_SIZE >= SZ_8K);
> +
> +int __init arm64_efi_rt_init(void)
> +{
> +	void *p = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
> +				       VMALLOC_START, VMALLOC_END, GFP_KERNEL,
> +				       PAGE_KERNEL, 0, NUMA_NO_NODE,
> +				       __builtin_return_address(0));
> +
> +	if (!p) {
> +		pr_warn("Failed to allocate EFI runtime stack\n");
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +		return -ENOMEM;
> +	}
> +
> +	efi_rt_stack_top = p + THREAD_SIZE;
> +	return 0;
> +}
> +core_initcall(arm64_efi_rt_init);
> -- 
> 2.35.1
> 
> 

-- 
Lee Jones [李琼斯]
