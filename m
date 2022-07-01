Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF43563C3E
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 00:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiGAWR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 18:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiGAWR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 18:17:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D446D33EB6;
        Fri,  1 Jul 2022 15:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 872B3B83107;
        Fri,  1 Jul 2022 22:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78602C3411E;
        Fri,  1 Jul 2022 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656713844;
        bh=qn8KeIcg6p6x70nlZj4sdymg43tnl9ycS8r/KVGYWBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H83TOqsTu9Z06vEdS6cQCCvGtd0fvP4dXtldHjHFjMHXk01g0BVNzWlZRQrCCFYzK
         ABV9AmFU9GFLxfaC7rQWPgMbX6NKXYHMG6VeTR5f6W0T70V11W8EptbsABwPxt4W4g
         i6Wu97DhB1Db6gpS6sR6siOpcV6Qp9Vp9kinSYxRE5xMvFJcn55lQEoMy4ExOiRELX
         ers5txkf4Ad15PqCkiE/M33G6l07jCKank6GMPjUSVZmUeRSLOflNbh3FKsL+Tmzx7
         pPD/8UMytSm1y7nErPSxTJlxv0dy3ofPLBrrrqxTMtqw0fHzWymI6aUpmRGY/VME5o
         aT6xl9JyjNfhg==
Date:   Fri, 1 Jul 2022 15:17:21 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kolesa <daniel@octaforge.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] x86/Kconfig: Fix CONFIG_CC_HAS_SANE_STACKPROTECTOR when
 cross compiling with clang
Message-ID: <Yr9ycVVIfzHtsYyz@dev-arch.thelio-3990X>
References: <20220617180845.2788442-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617180845.2788442-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gentle ping for review.

On Fri, Jun 17, 2022 at 11:08:46AM -0700, Nathan Chancellor wrote:
> Chimera Linux notes that CONFIG_CC_HAS_SANE_STACKPROTECTOR cannot be
> enabled when cross compiling an x86_64 kernel with clang, even though it
> does work when natively compiling.
> 
> When building on aarch64:
> 
>   $ make -sj"$(nproc)" ARCH=x86_64 LLVM=1 defconfig
> 
>   $ grep STACKPROTECTOR .config
> 
> When building on x86_64:
> 
>   $ make -sj"$(nproc)" ARCH=x86_64 LLVM=1 defconfig
> 
>   $ grep STACKPROTECTOR .config
>   CONFIG_CC_HAS_SANE_STACKPROTECTOR=y
>   CONFIG_HAVE_STACKPROTECTOR=y
>   CONFIG_STACKPROTECTOR=y
>   CONFIG_STACKPROTECTOR_STRONG=y
> 
> When clang is invoked without a '--target' flag, code is generated for
> the default target, which is usually the host (it is configurable via
> cmake). As a result, the has-stack-protector scripts will generate code
> for the default target but check for x86 specific segment registers,
> which cannot succeed if the default target is not x86.
> 
> $(CLANG_FLAGS) contains an explicit '--target' flag so pass that
> variable along to the has-stack-protector scripts so that the stack
> protector can be enabled when cross compiling with clang. The 32-bit
> stack protector cannot currently be enabled with clang, as it does not
> support '-mstack-protector-guard-symbol', so this results in no
> functional change for ARCH=i386 when cross compiling.
> 
> Link: https://github.com/chimera-linux/cports/commit/0fb7e506d5f83fdf2104feb22cdac34934561226
> Link: https://github.com/llvm/llvm-project/issues/48553
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> 
> Fixes: 2a61f4747eea ("stack-protector: test compiler capability in Kconfig and drop AUTO mode")
> 
> might be appropriate; I am conflicted on fixes tags for problems that
> that arise due to use cases that were not considered at the time of a
> change, as it feels wrong to blame the commit for not looking far enough
> into the future where it might be common for people to have workstations
> running another architecture other than x86_64.
> 
> Chimera appears to use a 5.15 kernel so a
> 
> Cc: stable@vger.kernel.org
> 
> might be nice but some maintainers are picky about that so I leave it up
> to you all.
> 
>  arch/x86/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index be0b95e51df6..076adde7ead9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -391,8 +391,8 @@ config PGTABLE_LEVELS
>  
>  config CC_HAS_SANE_STACKPROTECTOR
>  	bool
> -	default $(success,$(srctree)/scripts/gcc-x86_64-has-stack-protector.sh $(CC)) if 64BIT
> -	default $(success,$(srctree)/scripts/gcc-x86_32-has-stack-protector.sh $(CC))
> +	default $(success,$(srctree)/scripts/gcc-x86_64-has-stack-protector.sh $(CC) $(CLANG_FLAGS)) if 64BIT
> +	default $(success,$(srctree)/scripts/gcc-x86_32-has-stack-protector.sh $(CC) $(CLANG_FLAGS))
>  	help
>  	  We have to make sure stack protector is unconditionally disabled if
>  	  the compiler produces broken code or if it does not let us control
> 
> base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
> -- 
> 2.36.1
> 
> 
