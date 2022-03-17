Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF094DCFA5
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 21:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiCQUtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 16:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiCQUtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 16:49:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC41AA8E5;
        Thu, 17 Mar 2022 13:48:06 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p8so7769404pfh.8;
        Thu, 17 Mar 2022 13:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=njBL1mxoEng7tVDrEjek9QFtAEEhmO0f5Yln/xxwvDw=;
        b=lXM8OrqufnEFzjbGiqqWqKBGx879TMVpq4VVaebGl/WM2lSF2X9FYJlXLdvfJKuQaG
         YQKdWFVaTCtyNLuDOpXLhyXgNeL5GJKiW8cIm4AT0q1TK4GU6owp6UQ2o+cZerBWC1jy
         fsit++BGImvQU2Qmyr5Zz85X7ZQgOLvB21OgXawVkuy8EGZfIP+yMqIrFGT7h4e5OTA9
         20cy/iQaNLqpaUpw/KZuvTfvbh0pjAN0T1j1kBFQI9C/4et6L/d1bzIv5YW5u1HTM8Rl
         ew3NoNnSMhqh/+N5qJEDTqQLhpYpn68XZWKVP0NRXZRy/UqGG5tCbMwYApCJeQjm5Mz/
         sseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=njBL1mxoEng7tVDrEjek9QFtAEEhmO0f5Yln/xxwvDw=;
        b=5xaJ/H6Ywi1jFv+G4ejUV3mdCbqCwgexWHVVDgb4l/3E6/yXqt8d5MNEJQD1mG/f6p
         GRU3WgUxd8MeMReyEzYR2WdqNN8oQlouDFtlD2X5njd28zwMIbcQ8GiIST02qQODkGJ7
         KZdAlVA7cr5SqDzM1hiOJwL4RqzXi3ghnvkfi1ljz9eCelu2bZHvz4Ma/Gt3LvmeGf0N
         W/3aAZVq0a/qbYBFm76CcMRPHtUa1pRU1sr/KDBCiRxMAI9lXW+Gn1NER29cqS1whu+K
         3yrtBz4Z4f34OxYWp2S5Iw8OwYTWySiRNL64YdLhUh/gttF6IyNn/t3Yn7dc3ZB7iIYb
         lmlA==
X-Gm-Message-State: AOAM531CJXMQ1EeY6u9jm6GTCYWT1vH2XrbGpN322qQ6P6HijdQ/ipZA
        UumARXnq+vOrIq93n8qwrjEHh8059tM=
X-Google-Smtp-Source: ABdhPJy+GaP9Ye3xYXvE+Sw33CdxTFOEry8xKg8X5JOEdb2vXx3lktHLE4949AUo0qIPycpc5Be5BA==
X-Received: by 2002:a63:7702:0:b0:382:24f1:b70f with SMTP id s2-20020a637702000000b0038224f1b70fmr1519933pgc.144.1647550086039;
        Thu, 17 Mar 2022 13:48:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oo17-20020a17090b1c9100b001bf0ccc59c2sm11038810pjb.16.2022.03.17.13.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 13:48:05 -0700 (PDT)
Subject: Re: [PATCH 5.4 18/43] arm64: entry: Add macro for reading symbol
 addresses from the trampoline
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220317124527.672236844@linuxfoundation.org>
 <20220317124528.180267687@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <113e7675-4263-2a20-81d0-9634f03511d2@gmail.com>
Date:   Thu, 17 Mar 2022 13:48:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220317124528.180267687@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.
> 
> The trampoline code needs to use the address of symbols in the wider
> kernel, e.g. vectors. PC-relative addressing wouldn't work as the
> trampoline code doesn't run at the address the linker expected.
> 
> tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
> set, in which case it uses the data page as a literal pool because
> the data page can be unmapped when running in user-space, which is
> required for CPUs vulnerable to meltdown.
> 
> Pull this logic out as a macro, instead of adding a third copy
> of it.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit causes a linking failure with CONFIG_ARM_SDE_INTERFACE=y
enabled in the kernel:

  LD      .tmp_vmlinux.kallsyms1
/local/users/fainelli/buildroot/output/arm64/host/bin/aarch64-linux-ld:
arch/arm64/kernel/entry.o: in function `__sdei_asm_exit_trampoline':
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/arch/arm64/kernel/entry.S:1352:
undefined reference to `__sdei_asm_trampoline_next_handler'
make[2]: *** [Makefile:1100: vmlinux] Error 1
make[1]: *** [package/pkg-generic.mk:295:
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/.stamp_built]
Error 2
make: *** [Makefile:27: _all] Error 2


> ---
>  arch/arm64/kernel/entry.S | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 14351ee5e812..e4b5a15c2e2e 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -1063,6 +1063,15 @@ alternative_else_nop_endif
>  	sub	\dst, \dst, PAGE_SIZE
>  	.endm
>  
> +	.macro tramp_data_read_var	dst, var
> +#ifdef CONFIG_RANDOMIZE_BASE
> +	tramp_data_page		\dst
> +	add	\dst, \dst, #:lo12:__entry_tramp_data_\var
> +	ldr	\dst, [\dst]
> +#else
> +	ldr	\dst, =\var
> +#endif
> +	.endm
>  
>  #define BHB_MITIGATION_NONE	0
>  #define BHB_MITIGATION_LOOP	1
> @@ -1093,13 +1102,8 @@ alternative_else_nop_endif
>  	b	.
>  2:
>  	tramp_map_kernel	x30
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	tramp_data_page		x30
>  alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
> -	ldr	x30, [x30]
> -#else
> -	ldr	x30, =vectors
> -#endif
> +	tramp_data_read_var	x30, vectors
>  alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
>  	prfm	plil1strm, [x30, #(1b - \vector_start)]
>  alternative_else_nop_endif
> @@ -1183,7 +1187,12 @@ END(tramp_exit_compat)
>  	.align PAGE_SHIFT
>  	.globl	__entry_tramp_data_start
>  __entry_tramp_data_start:
> +__entry_tramp_data_vectors:
>  	.quad	vectors
> +#ifdef CONFIG_ARM_SDE_INTERFACE
> +__entry_tramp_data___sdei_asm_trampoline_next_handler:
> +	.quad	__sdei_asm_handler
> +#endif /* CONFIG_ARM_SDE_INTERFACE */
>  	.popsection				// .rodata
>  #endif /* CONFIG_RANDOMIZE_BASE */
>  #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
> @@ -1310,13 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
>  	 */
>  1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
>  
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	tramp_data_page		x4
> -	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
> -	ldr	x4, [x4]
> -#else
> -	ldr	x4, =__sdei_asm_handler
> -#endif
> +	tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
>  	br	x4
>  ENDPROC(__sdei_asm_entry_trampoline)
>  NOKPROBE(__sdei_asm_entry_trampoline)
> @@ -1339,12 +1342,6 @@ ENDPROC(__sdei_asm_exit_trampoline)
>  NOKPROBE(__sdei_asm_exit_trampoline)
>  	.ltorg
>  .popsection		// .entry.tramp.text
> -#ifdef CONFIG_RANDOMIZE_BASE
> -.pushsection ".rodata", "a"
> -__sdei_asm_trampoline_next_handler:
> -	.quad	__sdei_asm_handler
> -.popsection		// .rodata
> -#endif /* CONFIG_RANDOMIZE_BASE */
>  #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
>  
>  /*
> 


-- 
Florian
