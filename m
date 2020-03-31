Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162C3199F64
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 21:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgCaTqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 15:46:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41972 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgCaTqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 15:46:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id a24so4006084pfc.8
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 12:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=McSfVGO53GT+onuty+si9A0D5AuT8lLRpPmZo3ttlOM=;
        b=eJAdqBJ2z+laXu2VLjBHH8VchzOd8EZdFs0BxtKQ4C/pCCkyIaYKGwn7nAtZ5zWCEd
         qAbDjfQh+SpNHwv6Oq2Dn4fxkbDnWRQgrkCbMgwp3KnFALPY9vpzQuEcHdt6FE8y5LER
         qwR8Hi1L0wq8QOAr2CPpwFg2W+GOyXG+PA7mI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=McSfVGO53GT+onuty+si9A0D5AuT8lLRpPmZo3ttlOM=;
        b=OqXkE7gmHCroa9IKNEN1lG/T4cfmGLnv5LcSIv7dhTt3VyMbzOVwsOUNJfWE5ksjr5
         CBttf8eVDaMmkIXhiSbtaYVnJirSD8ObJS8DTArWfW/+XA8xod///rORXz38eZ3bwSrt
         0Kl9ZmzdOW6B55T77Wl0oKq4cCKwt33IXYhYb5mvsdpzQWMgE/uyX2Vjwce7gKRDO0+x
         y/NrejMfv+ztWHw0E1yga5Ia4WtknFppytTCYlWjuG3U3ysnNOwPjSQ6yAUxeVtQabsm
         IhuA+fjQMAe/s2jhUiF/82NKNsKlaLv/TMh+ZQvliVTgJ4ejuHaK7gCI5az9H8bd3gK/
         4N0A==
X-Gm-Message-State: ANhLgQ2Wei3dscr6gzfvIWkqAzJuEp2wibJbaSSW58t/F1hNGiq8D2TI
        JFs2Ah4AJM3Zxul2GtssVmOl1g==
X-Google-Smtp-Source: ADFU+vv50aemtn2DxG4hvoaoGIYJraig6CnwiJgc4tMf4NsQFH4BpYFhb/jSce3yhJjyu+iPKsJ3Bw==
X-Received: by 2002:a63:3187:: with SMTP id x129mr18660713pgx.180.1585683995603;
        Tue, 31 Mar 2020 12:46:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o65sm13181259pfg.187.2020.03.31.12.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:46:34 -0700 (PDT)
Date:   Tue, 31 Mar 2020 12:46:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Szabolcs Nagy <szabolcs.nagy@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Always force a branch protection mode when the
 compiler has one
Message-ID: <202003311246.3BAE76AF1@keescook>
References: <20200331194459.54740-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331194459.54740-1-broonie@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 08:44:59PM +0100, Mark Brown wrote:
> Compilers with branch protection support can be configured to enable it by
> default, it is likely that distributions will do this as part of deploying
> branch protection system wide. As well as the slight overhead from having
> some extra NOPs for unused branch protection features this can cause more
> serious problems when the kernel is providing pointer authentication to
> userspace but not built for pointer authentication itself. In that case our
> switching of keys for userspace can affect the kernel unexpectedly, causing
> pointer authentication instructions in the kernel to corrupt addresses.
> 
> To ensure that we get consistent and reliable behaviour always explicitly
> initialise the branch protection mode, ensuring that the kernel is built
> the same way regardless of the compiler defaults.
> 
> Fixes: 7503197562567 (arm64: add basic pointer authentication support)
> Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/Kconfig  | 4 ++++
>  arch/arm64/Makefile | 7 ++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index d3efdc095a17..1e46746e8392 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1537,6 +1537,10 @@ config ARM64_PTR_AUTH
>  	  This feature works with FUNCTION_GRAPH_TRACER option only if
>  	  DYNAMIC_FTRACE_WITH_REGS is enabled.
>  
> +config CC_HAS_BRANCH_PROT_NONE
> +	# GCC 9 or later, clang 8 or later
> +	def_bool $(cc-option,-mbranch-protection=none)
> +
>  config CC_HAS_BRANCH_PROT_PAC_RET
>  	# GCC 9 or later, clang 8 or later
>  	def_bool $(cc-option,-mbranch-protection=pac-ret+leaf)
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index f15f92ba53e6..370fca6663c8 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
>  					include/generated/asm-offsets.h))
>  endif
>  
> +# Ensure that if the compiler supports branch protection we default it
> +# off, this will be overridden if we are using branch protection.
> +branch-prot-flags-$(CONFIG_CC_HAS_BRANCH_PROT_NONE) := -mbranch-protection=none
> +
>  ifeq ($(CONFIG_ARM64_PTR_AUTH),y)
>  branch-prot-flags-$(CONFIG_CC_HAS_SIGN_RETURN_ADDRESS) := -msign-return-address=all
>  branch-prot-flags-$(CONFIG_CC_HAS_BRANCH_PROT_PAC_RET) := -mbranch-protection=pac-ret+leaf
> @@ -73,9 +77,10 @@ branch-prot-flags-$(CONFIG_CC_HAS_BRANCH_PROT_PAC_RET) := -mbranch-protection=pa
>  # we pass it only to the assembler. This option is utilized only in case of non
>  # integrated assemblers.
>  branch-prot-flags-$(CONFIG_AS_HAS_PAC) += -Wa,-march=armv8.3-a
> -KBUILD_CFLAGS += $(branch-prot-flags-y)
>  endif
>  
> +KBUILD_CFLAGS += $(branch-prot-flags-y)
> +
>  ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
>  KBUILD_CPPFLAGS	+= -mbig-endian
>  CHECKFLAGS	+= -D__AARCH64EB__
> -- 
> 2.20.1
> 

-- 
Kees Cook
