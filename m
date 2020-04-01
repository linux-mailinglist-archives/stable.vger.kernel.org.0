Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBECC19B4F0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgDARyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 13:54:53 -0400
Received: from foss.arm.com ([217.140.110.172]:58090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDARyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 13:54:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35A061FB;
        Wed,  1 Apr 2020 10:54:52 -0700 (PDT)
Received: from mbp (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 062EA3F52E;
        Wed,  1 Apr 2020 10:54:50 -0700 (PDT)
Date:   Wed, 1 Apr 2020 18:54:44 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Amit Kachhap <Amit.Kachhap@arm.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: Always force a branch protection mode when the
 compiler has one
Message-ID: <20200401175444.GF9434@mbp>
References: <20200331194459.54740-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331194459.54740-1-broonie@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> userspace but not built for pointer authentication itself.

With 5.7 you won't be able to configure user and kernel PAC support
independently. So, I guess that's something only for prior kernel
versions.

> In that case our
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

I don't think we need to bother with a Kconfig entry here. We did it for
the other options since CONFIG_ARM64_PTR_AUTH has a dependency on them.

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

And a $(call cc-option,-mbranch-protection=none) here.

branch-prot-flags-y is only introduced in 5.7, so backporting may look
slightly weirder.

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

Or just use an else clause here with:

KBUILD_CFLAGS += ($call cc-option,-mbranch-protection=none).

On backports, we just drop else/endif since they don't exist.

Not a strong preference really, just looking to have backports resemble
upstream better. I can fix it up locally, whichever variant we go for
(or even this one).

-- 
Catalin
