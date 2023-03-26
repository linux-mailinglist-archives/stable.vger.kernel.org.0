Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFA6C96FA
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjCZQyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjCZQyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 12:54:44 -0400
X-Greylist: delayed 365 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Mar 2023 09:54:43 PDT
Received: from iad0.nichi.link (iad0.nichi.link [IPv6:2a01:4ff:f0:db00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D5561BC;
        Sun, 26 Mar 2023 09:54:43 -0700 (PDT)
Received: from [IPV6:2402:f000:2:c801:3a00:25ff:fe59:8c06] (unknown [IPv6:2402:f000:2:c801:3a00:25ff:fe59:8c06])
        by iad0.nichi.link (Postfix) with ESMTPA id DD5A887A02;
        Sun, 26 Mar 2023 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nichi.co; s=default;
        t=1679849316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWn62rWoesr1V+Jp7k/v6C+Nt0B/JD6KJm7XDX0ZcKc=;
        b=F4FKRJcUCMPpnaM9P5gN6jHEGLeMEv2703QQMls5hBQlIuu7B37ZLAroMiOHDz0ft2j9EG
        7bwp10mFfNIwt6S7z15djRxHlN42VxOTUMTElNyhDiIUxqWH945MbE7oOz4ueh7zfblIco
        lb+YloLzv045ZonQ40my3l7bIV7Lfgg=
Message-ID: <3db66793-c647-f6c9-7c5b-d7a331c8f328@nichi.co>
Date:   Mon, 27 Mar 2023 00:48:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] purgatory: fix disabling debug info
To:     Alyssa Ross <hi@alyssa.is>, Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org
References: <20230326153412.63128-1-hi@alyssa.is>
Content-Language: en-US
From:   Nick Cao <nickcao@nichi.co>
In-Reply-To: <20230326153412.63128-1-hi@alyssa.is>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With this patch applied on top of 
https://github.com/NickCao/linux/tree/f258de7fdb1e69492f8962da5d34646da49685db, 
the built kernel image no longer contains reference to the source 
directory (which is not allowed in the Nixpkgs kernel building 
infrastructure).

Tested-by: Nick Cao <nickcao@nichi.co>

On 3/26/23 23:34, Alyssa Ross wrote:
> Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> -Wa versions of both of those if building with Clang and GNU as.  As a
> result, debug info was being generated for the purgatory objects, even
> though the intention was that it not be.
> 
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> Cc: stable@vger.kernel.org
> ---
>   arch/riscv/purgatory/Makefile | 12 ++++++------
>   arch/x86/purgatory/Makefile   |  4 ++--
>   2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
> index d16bf715a586..97001798fa19 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,12 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
>   CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
>   CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
>   
> -AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
> +AFLAGS_REMOVE_entry.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_memcpy.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_memset.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strcmp.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strlen.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_strncmp.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
>   
>   $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>   		$(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc26381..f1b1ef6c4cbf 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,8 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
>   CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
>   CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
>   
> -AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
> +AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
> +AFLAGS_REMOVE_entry64.o			+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
>   
>   $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>   		$(call if_changed,ld)
> 
> base-commit: da8e7da11e4ba758caf4c149cc8d8cd555aefe5f
