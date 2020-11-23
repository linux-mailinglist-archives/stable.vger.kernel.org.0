Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFCE2C1702
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 21:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgKWUtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 15:49:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58432 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgKWUtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 15:49:14 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1khIls-0004zz-6m
        for stable@vger.kernel.org; Mon, 23 Nov 2020 20:49:12 +0000
Received: by mail-il1-f197.google.com with SMTP id w10so15036300ila.22
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 12:49:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aKKg6wsDaykJhzWuyANPFCAYRxtejbFckP15kDzwPrA=;
        b=LlNrdHuvKYOVI/mWkI12GrRp+RSLVfWZoAHtqRFH/Er6S5cXOIahpenkMiu8ojanDy
         XRd3vtvJJT/hw/1rpaIFIFoEKIgCYsbbmiNpEhkQmlSQJMYv0OUYZBZDQA0ofaDxbePn
         joxKmfdQ2rD0QKaijsY/v0Pf2ynnsvlkeQSOkDcG9x0rlW4WloQdX0WM1aA1PfPnxeWM
         RYhzr5vMC/qPwX1gPtSc/cG+ATYa4oEnUcqcjK+wjbsl/0Fgwtaku7lDR1X3F1sUnCC1
         +xPmFpqRUAEMhsqUp9KjI55qMAhlevyhFkL4hIvGI6jxV6E1PxS5+sHy/i8Wf6CuNrGK
         Jjlg==
X-Gm-Message-State: AOAM530Cbn2w/4BbN/qNuSLS5H6DIKmhL05DV/4BNsrrtOAlC+HlsTxt
        Q3h1xKVWAilxyxMty7xgeelDXYM7S1SaBkUhFgLMhNVK4c9Sj/06qtL9H/AnH/McJ70rc/ylYyG
        KBLDE0TfFc6QuTPgKzzLI1BU34nqxZE66iQ==
X-Received: by 2002:a92:d591:: with SMTP id a17mr1441547iln.51.1606164551120;
        Mon, 23 Nov 2020 12:49:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsVFmTJQa0sGKLVyLrPs1uS5N1qkeJJ5RbqqqHjnPMsF7w3O/qOHp/r3ZeWE3C7iefdhnW1w==
X-Received: by 2002:a92:d591:: with SMTP id a17mr1441531iln.51.1606164550824;
        Mon, 23 Nov 2020 12:49:10 -0800 (PST)
Received: from xps13.dannf (c-71-56-235-36.hsd1.co.comcast.net. [71.56.235.36])
        by smtp.gmail.com with ESMTPSA id o3sm8617248ilk.27.2020.11.23.12.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 12:49:09 -0800 (PST)
Date:   Mon, 23 Nov 2020 13:49:07 -0700
From:   dann frazier <dann.frazier@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH 4.4 17/70] crypto: arm64/sha - avoid non-standard inline
 asm tricks
Message-ID: <X7wgQ0EW4wKERbkq@xps13.dannf>
References: <20181126105046.722096341@linuxfoundation.org>
 <20181126105048.515352194@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126105048.515352194@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 26, 2018 at 11:50:32AM +0100, Greg Kroah-Hartman wrote:
> 4.4-stable review patch.  If anyone has any objections, please let me know.

fyi, I bisected a regression down to this commit. This apparently
causes an ADR_PREL_PG_HI21 relocation to be added to the sha{1,2}_ce
modules. Back in 4.4 ADR_PREL_PG_HI21 relocations were forbidden if
built with CONFIG_ARM64_ERRATUM_843419=y, so now the sha{1,2}_ce modules
fail to load:

[   37.866250] module sha1_ce: unsupported RELA relocation: 275

Looks like it should be an issue for 4.14.y as well, but I haven't yet
tested it.

  -dann

> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> commit f4857f4c2ee9aa4e2aacac1a845352b00197fb57 upstream.
> 
> Replace the inline asm which exports struct offsets as ELF symbols
> with proper const variables exposing the same values. This works
> around an issue with Clang which does not interpret the "i" (or "I")
> constraints in the same way as GCC.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm64/crypto/sha1-ce-core.S |    6 ++++--
>  arch/arm64/crypto/sha1-ce-glue.c |   11 +++--------
>  arch/arm64/crypto/sha2-ce-core.S |    6 ++++--
>  arch/arm64/crypto/sha2-ce-glue.c |   13 +++++--------
>  4 files changed, 16 insertions(+), 20 deletions(-)
> 
> --- a/arch/arm64/crypto/sha1-ce-core.S
> +++ b/arch/arm64/crypto/sha1-ce-core.S
> @@ -82,7 +82,8 @@ ENTRY(sha1_ce_transform)
>  	ldr		dgb, [x0, #16]
>  
>  	/* load sha1_ce_state::finalize */
> -	ldr		w4, [x0, #:lo12:sha1_ce_offsetof_finalize]
> +	ldr_l		w4, sha1_ce_offsetof_finalize, x4
> +	ldr		w4, [x0, x4]
>  
>  	/* load input */
>  0:	ld1		{v8.4s-v11.4s}, [x1], #64
> @@ -132,7 +133,8 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
>  	 * the padding is handled by the C code in that case.
>  	 */
>  	cbz		x4, 3f
> -	ldr		x4, [x0, #:lo12:sha1_ce_offsetof_count]
> +	ldr_l		w4, sha1_ce_offsetof_count, x4
> +	ldr		x4, [x0, x4]
>  	movi		v9.2d, #0
>  	mov		x8, #0x80000000
>  	movi		v10.2d, #0
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -17,9 +17,6 @@
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>  
> -#define ASM_EXPORT(sym, val) \
> -	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
> -
>  MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
> @@ -32,6 +29,9 @@ struct sha1_ce_state {
>  asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
>  				  int blocks);
>  
> +const u32 sha1_ce_offsetof_count = offsetof(struct sha1_ce_state, sst.count);
> +const u32 sha1_ce_offsetof_finalize = offsetof(struct sha1_ce_state, finalize);
> +
>  static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
>  			  unsigned int len)
>  {
> @@ -52,11 +52,6 @@ static int sha1_ce_finup(struct shash_de
>  	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
>  	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
>  
> -	ASM_EXPORT(sha1_ce_offsetof_count,
> -		   offsetof(struct sha1_ce_state, sst.count));
> -	ASM_EXPORT(sha1_ce_offsetof_finalize,
> -		   offsetof(struct sha1_ce_state, finalize));
> -
>  	/*
>  	 * Allow the asm code to perform the finalization if there is no
>  	 * partial data and the input is a round multiple of the block size.
> --- a/arch/arm64/crypto/sha2-ce-core.S
> +++ b/arch/arm64/crypto/sha2-ce-core.S
> @@ -88,7 +88,8 @@ ENTRY(sha2_ce_transform)
>  	ld1		{dgav.4s, dgbv.4s}, [x0]
>  
>  	/* load sha256_ce_state::finalize */
> -	ldr		w4, [x0, #:lo12:sha256_ce_offsetof_finalize]
> +	ldr_l		w4, sha256_ce_offsetof_finalize, x4
> +	ldr		w4, [x0, x4]
>  
>  	/* load input */
>  0:	ld1		{v16.4s-v19.4s}, [x1], #64
> @@ -136,7 +137,8 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
>  	 * the padding is handled by the C code in that case.
>  	 */
>  	cbz		x4, 3f
> -	ldr		x4, [x0, #:lo12:sha256_ce_offsetof_count]
> +	ldr_l		w4, sha256_ce_offsetof_count, x4
> +	ldr		x4, [x0, x4]
>  	movi		v17.2d, #0
>  	mov		x8, #0x80000000
>  	movi		v18.2d, #0
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -17,9 +17,6 @@
>  #include <linux/crypto.h>
>  #include <linux/module.h>
>  
> -#define ASM_EXPORT(sym, val) \
> -	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
> -
>  MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
> @@ -32,6 +29,11 @@ struct sha256_ce_state {
>  asmlinkage void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
>  				  int blocks);
>  
> +const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
> +					      sst.count);
> +const u32 sha256_ce_offsetof_finalize = offsetof(struct sha256_ce_state,
> +						 finalize);
> +
>  static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
>  			    unsigned int len)
>  {
> @@ -52,11 +54,6 @@ static int sha256_ce_finup(struct shash_
>  	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
>  	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
>  
> -	ASM_EXPORT(sha256_ce_offsetof_count,
> -		   offsetof(struct sha256_ce_state, sst.count));
> -	ASM_EXPORT(sha256_ce_offsetof_finalize,
> -		   offsetof(struct sha256_ce_state, finalize));
> -
>  	/*
>  	 * Allow the asm code to perform the finalization if there is no
>  	 * partial data and the input is a round multiple of the block size.
> 
> 
