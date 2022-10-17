Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D90A601266
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJQPGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiJQPGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106611E3DB;
        Mon, 17 Oct 2022 08:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FCB3B81900;
        Mon, 17 Oct 2022 15:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA77C433C1;
        Mon, 17 Oct 2022 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666019006;
        bh=wkfEOBdQV5UQPxxjuXF1Ckat4z1Z45fUh9Ug6FoaDrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJLPO/w2HX8WTzYHCZp/p/XTe1yx6/FByXFtAJY3JECefjb5OAfwD2g4//PfW4BH+
         31QCv8FztxXHPOna9JqiMV7ZS0AsP7Z5YmD1yV9JrzccLuC+zw/ZhoptvmvKi8hrVj
         sFx23RArpsD2F7sqdm2TLFqnPTF2SvjEVyOWnaZ5S/7WlDphDh85teb/PNeJORYU4z
         o4o7gBGO5Wo/vJoY3R4jCoSl8ynxG0I47VztZuZiAW7mMavHR0NbmPAbaavQrwq6Eb
         SdfdZkoo0hYeO26I3Gz3oGFisZrhJVfyV4XXFaI1PkNQgQ5SelGLn5HSjTVfGebgNG
         xlggoiQtWJwkw==
Date:   Mon, 17 Oct 2022 08:03:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/Kconfig: Drop check for '-mabi=ms' for
 CONFIG_EFI_STUB
Message-ID: <Y01uuzirnLLRSEEI@dev-arch.thelio-3990X>
References: <20220929152010.835906-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929152010.835906-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi x86 folks,

Would it be possible to pick this up for 6.1 so it can start filtering
into the stable trees? I know it came down towards the beginning of the
merge window so I understand the silence but I have had a couple of
people independently report this problem when they used a newer snapshot
of LLVM. This problem is not immediately obvious if you do not have a
previous configuration to diff against.

Cheers,
Nathan

On Thu, Sep 29, 2022 at 08:20:10AM -0700, Nathan Chancellor wrote:
> A recent change in LLVM made CONFIG_EFI_STUB unselectable because it no
> longer pretends to support '-mabi=ms', breaking the dependency in
> Kconfig. Lack of CONFIG_EFI_STUB can prevent kernels from booting via
> EFI in certain circumstances.
> 
> This check was added by commit 8f24f8c2fc82 ("efi/libstub: Annotate
> firmware routines as __efiapi") to ensure that '__attribute__((ms_abi))'
> was available, as '-mabi=ms' is not actually used in any cflags.
> According to the GCC documentation, this attribute has been supported
> since GCC 4.4.7. The kernel currently requires GCC 5.1 so this check is
> not necessary; even when that change landed in 5.6, the kernel required
> GCC 4.9 so it was unnecessary then as well.  Clang supports
> '__attribute__((ms_abi))' for all versions that are supported for
> building the kernel so no additional check is needed. Remove the
> 'depends on' line altogether to allow CONFIG_EFI_STUB to be selected
> when CONFIG_EFI is enabled, regardless of compiler.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1725
> Link: https://gcc.gnu.org/onlinedocs/gcc-4.4.7/gcc/Function-Attributes.html
> Link: https://github.com/llvm/llvm-project/commit/d1ad006a8f64bdc17f618deffa9e7c91d82c444d
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f9920f1341c8..81012154d9ed 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1956,7 +1956,6 @@ config EFI
>  config EFI_STUB
>  	bool "EFI stub support"
>  	depends on EFI
> -	depends on $(cc-option,-mabi=ms) || X86_32
>  	select RELOCATABLE
>  	help
>  	  This kernel feature allows a bzImage to be loaded directly
> 
> base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
> -- 
> 2.37.3
> 
> 
