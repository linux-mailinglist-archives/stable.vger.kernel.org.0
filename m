Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159BF3A3124
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhFJQpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 12:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhFJQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 12:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A61560FDA;
        Thu, 10 Jun 2021 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623343354;
        bh=EIDifK6jf6MgC1sFt3cf8qGcGiF4IAvL00gBZkMEqQc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fytVhHWTmTy8QxU8u895ibp3VqbqqQcCbEYj31Pqr5ftUbrX2FahMEXPpK4Omw+wl
         0f3AzHnZhlts/2a28zumR2jcAtnxBk3SvTvzh4Omw9n99pJCaKFMmHIOnNrJzA8kqB
         cbq/S5Ch4i8SK2TllE30EzpZwYPINaraOuJv+oT4pA/KAufkkiCSQ97TYOvLPq7X7b
         YPTCYXJ1929TXCs3h85sqkbajEXqQz/cgtioBFDMGNhj7AG3pNLF9rqe38Fr31KzWx
         Es+Ysco5ZucjICHuS73hn6OHg5b9k2vKrevUXPn2YrYW4BsXrcanENE//Lw3TgjPt9
         llnQpVFJ6z19A==
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
To:     torvic9@mailbox.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <214134496.67043.1623317284090@office.mailbox.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <ea01f4cb-3e65-0b79-ae93-ba0957e076fc@kernel.org>
Date:   Thu, 10 Jun 2021 09:42:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <214134496.67043.1623317284090@office.mailbox.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tor,

On 6/10/2021 2:28 AM, torvic9@mailbox.org wrote:
> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
> leading to the following error message when building a LTO kernel with
> Clang-13 and LLD-13:
> 
>      ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
>      '-stack-alignment=8'.  Try 'ld.lld --help'
>      ld.lld: Did you mean '--stackrealign=8'?
> 
> It also appears that the '-code-model' flag is not necessary anymore starting
> with LLVM-9 [2].
> 
> Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.
> 
> This is for linux-stable 5.12.
> Another patch will be submitted for 5.13 shortly (unless there are objections).

This patch needs to be accepted into mainline first before it can go to 
stable so this line needs to be removed. The rest of the description 
looks good to me, good job on being descriptive!

> Discussion: https://github.com/ClangBuiltLinux/linux/issues/1377
> [1]: https://reviews.llvm.org/D103048
> [2]: https://reviews.llvm.org/D52322

As Greg's auto-response points out, there needs to be an actual

Cc: stable@vger.kernel.org

here in the patch, rather than just cc'ing stable@vger.kernel.org 
through email.

> Signed-off-by: Tor Vic <torvic9@mailbox.org>

The actual patch itself looks good and I have verified that it fixes the 
build error. On the resend with the above fixed, please feel free to add:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
>   arch/x86/Makefile | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 1f2e5bf..2855a1a 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -192,8 +192,9 @@ endif
>   KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
>   
>   ifdef CONFIG_LTO_CLANG
> -KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
> -		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
> +ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
> +KBUILD_LDFLAGS	+= -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
> +endif
>   endif
>   
>   ifdef CONFIG_X86_NEED_RELOCS
> 

Cheers,
Nathan
