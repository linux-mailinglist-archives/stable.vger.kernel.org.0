Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0F15F33C9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiJCQmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 12:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJCQle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 12:41:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5471CFCD;
        Mon,  3 Oct 2022 09:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E4DB80D89;
        Mon,  3 Oct 2022 16:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DAC433C1;
        Mon,  3 Oct 2022 16:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664815281;
        bh=ewRIHxFHQnpnU+77QvY0efvP5IYmrYF1YUCXFo+oQUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ObCftzAOdYjUvr9qOMLruH34zB69a8teiZ4pyncy9G1zYaSLtr23c9a0KjJclRexZ
         F/8W27RkAL5CqSEVqsJRaid8iW7LVfzITG8cAsxFV0rs16ihk+Sj/Azj3Mnh3MJ0Ia
         tleI8op8c5grkm1q7k0wmPCPZsj4qOozn+9D0i3j0P0CYxBDffMKuS9dJEMqaBykXG
         Mtl+SiJmmPR963j7imay5w4JIPkrz/CEimvcOE8/kpNXJGe1S+9MxgTGN3QUKB6Ir+
         S4a5VhYH/XRu9S6ek+dW35L8OMg6q2mFukS1zOL5meswXWDPnBznvhvurD7NtvlB+g
         PfGHX3DF7Jg6A==
Date:   Mon, 3 Oct 2022 09:41:19 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] hardening: Remove Clang's enable flag for
 -ftrivial-auto-var-init=zero
Message-ID: <YzsQr/DqrNzJILkr@dev-arch.thelio-3990X>
References: <20220930060624.2411883-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930060624.2411883-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 11:06:24PM -0700, Kees Cook wrote:
> Now that Clang's -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
> option is no longer required, remove it from the command line. Clang 16
> and later will warn when it is used, which will cause Kconfig to think
> it can't use -ftrivial-auto-var-init=zero at all. Check for whether it
> is required and only use it when so.
> 
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: linux-kbuild@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Cc: stable@vger.kernel.org
> Fixes: f02003c860d9 ("hardening: Avoid harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO")
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks for sending this change!

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

Please consider getting this to Linus ASAP so that this can start
filtering into stable now that the LLVM change has landed, as I lost the
ability to use CONFIG_INIT_STACK_ALL_ZERO after upgrading my toolchain
over the weekend :)

Additionally, I am not sure the fixes tag is going to ensure that this
change automatically makes it back to 5.15 and 5.10, which have
commit f0fe00d4972a ("security: allow using Clang's zero initialization
for stack variables") but not commit f02003c860d9 ("hardening: Avoid
harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO"). I guess if I
am reading the stable documentation right, we could do something like:

Cc: stable@vger.kernel.org # dcb7c0b9461c + f02003c860d9
Fixes: f0fe00d4972a ("security: allow using Clang's zero initialization for stack variables")

but I am not sure. I guess we can always just send manual backports
once it is merged.

> ---
>  Makefile                   |  4 ++--
>  security/Kconfig.hardening | 14 ++++++++++----
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c7705f749601..02c857e2243c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -831,8 +831,8 @@ endif
>  # Initialize all stack variables with a zero value.
>  ifdef CONFIG_INIT_STACK_ALL_ZERO
>  KBUILD_CFLAGS	+= -ftrivial-auto-var-init=zero
> -ifdef CONFIG_CC_IS_CLANG
> -# https://bugs.llvm.org/show_bug.cgi?id=45497
> +ifdef CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
> +# https://github.com/llvm/llvm-project/issues/44842
>  KBUILD_CFLAGS	+= -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
>  endif
>  endif
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index bd2aabb2c60f..995bc42003e6 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -22,11 +22,17 @@ menu "Memory initialization"
>  config CC_HAS_AUTO_VAR_INIT_PATTERN
>  	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
>  
> -config CC_HAS_AUTO_VAR_INIT_ZERO
> -	# GCC ignores the -enable flag, so we can test for the feature with
> -	# a single invocation using the flag, but drop it as appropriate in
> -	# the Makefile, depending on the presence of Clang.
> +config CC_HAS_AUTO_VAR_INIT_ZERO_BARE
> +	def_bool $(cc-option,-ftrivial-auto-var-init=zero)
> +
> +config CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
> +	# Clang 16 and later warn about using the -enable flag, but it
> +	# is required before then.
>  	def_bool $(cc-option,-ftrivial-auto-var-init=zero -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang)
> +	depends on !CC_HAS_AUTO_VAR_INIT_ZERO_BARE
> +
> +config CC_HAS_AUTO_VAR_INIT_ZERO
> +	def_bool CC_HAS_AUTO_VAR_INIT_ZERO_BARE || CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER
>  
>  choice
>  	prompt "Initialize kernel stack variables at function entry"
> -- 
> 2.34.1
> 
