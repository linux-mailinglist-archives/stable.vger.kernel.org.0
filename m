Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34666D1220
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 00:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjC3W3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 18:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjC3W3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 18:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2484211F;
        Thu, 30 Mar 2023 15:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64BDC621C1;
        Thu, 30 Mar 2023 22:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7A5C433D2;
        Thu, 30 Mar 2023 22:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680215370;
        bh=u2AAe8FW/d2n59lqS7oxavb/IFRSqDdeC/+2NOlYXK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AUlflJsHxIOWgUT8O51/LP3fvE+9CyMewxcLGkAwdlQZ/H6ZsEKF2KE3nKN1Ne6Wl
         ub3IbFjL4UMTqa/YilAfGgiGN7fKyCAmN15sdnrUCuvaSu0ex3iJ+ROlvHaLbOutTM
         r2MOJff0meJ5288S/Vy8745DraPnWP33+SqkeHd7MIctbhNWtJj3af4Fx8pBkPYM1z
         mZufZAet1ZMNREpUalbCkfJLP9VjwZH4tDbiQnFMitrYNon+zYhEyEylGIMbz1A//r
         fhAtB2eaMa202c6M0GWDq5KpMctuL2nPH5Dv9+WZypHfUujGzukIGVRRwTJvFrFQEy
         RDtSQJIxPstIA==
Date:   Thu, 30 Mar 2023 15:29:28 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Cao <nickcao@nichi.co>, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] purgatory: fix disabling debug info
Message-ID: <20230330222928.GA644044@dev-arch.thelio-3990X>
References: <20230330182223.181775-1-hi@alyssa.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330182223.181775-1-hi@alyssa.is>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 06:22:24PM +0000, Alyssa Ross wrote:
> Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> -Wa versions of both of those if building with Clang and GNU as.  As a
> result, debug info was being generated for the purgatory objects, even
> though the intention was that it not be.
> 
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> Cc: stable@vger.kernel.org
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>

This is definitely more future proof.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> v2: https://lore.kernel.org/r/20230326182120.194541-1-hi@alyssa.is
> 
> Difference from v2: replaced asflags-remove-y with every possible
> debug flag with asflags-y += -g0, as suggested by Nick Desaulniers.
> 
> Additionally, I've CCed the x86 maintainers this time, since Masahiro
> said he would like acks from subsystem maintainers, and
> get_maintainer.pl didn't pick them the first time around.
> 
>  arch/riscv/purgatory/Makefile | 7 +------
>  arch/x86/purgatory/Makefile   | 3 +--
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
> index d16bf715a586..9c1e71853ee7 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
>  
> -AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
> +asflags-y			+= -g0
>  
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc26381..8e6c81b1c8f7 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
>  
> -AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
> +asflags-y			+= -g0
>  
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> -- 
> 2.37.1
> 
> 
