Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A102A01C7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgJ3Js5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 05:48:57 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:33435 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgJ3Js5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 05:48:57 -0400
Received: by mail-ej1-f66.google.com with SMTP id 7so7771161ejm.0
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 02:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AYmQosucJns9hYMiH6q24/+ExkliqlAKBjzr6XJWoUI=;
        b=dPLQ0Mi4OBq6BJyhqXYKOBhIJDEmQ5WTyy9n+QhxfVm5eAKqnlyfwE/oVIusnbGTm9
         q7iMy3Fa43U0Kh1UbhIXGx0XBCzYNd3Nr6YUeBeK9+z418z6ojSmSBSO6D3//jMRAd+I
         f9gGg0T5bYo2Zq/tiojYl4UNG8zT30+aPi0BfNez/kP5M5xexvoD4ICqOVI012HG//zc
         tR8bHYutkrtK8X7tzQ03kQBV14Rajdk/AefAn1jr7/DaoBmQpxU1fvruR8zHOjreNaUW
         Ja/7ipn+cvPLUJiWnuCca5X4VUlouPxpvNflr0ips5g40oliu2fpfjpdE8q6Gav0rfYb
         ggQw==
X-Gm-Message-State: AOAM532Q3dGUlw1eNhZxAuLTYmQ1XNpGdKT5D82Nb4qsX/IPupR6TJbG
        hv9Vop2BDtRxKBmYRoMId1b0bRV7YzI=
X-Google-Smtp-Source: ABdhPJyXWtJsFiKRZNLAIGHKujlsfJkh2hgV2LAeTP5VtVMIgT2lKKqG2/IKqEqisJmSfgG1Xira5Q==
X-Received: by 2002:a17:906:c1ce:: with SMTP id bw14mr1543129ejb.302.1604051334639;
        Fri, 30 Oct 2020 02:48:54 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id k4sm2155859edq.73.2020.10.30.02.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 02:48:53 -0700 (PDT)
Subject: Re: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for
 arch/x86/lib/mem*_64.S
To:     Fangrui Song <maskray@google.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     clang-built-linux@googlegroups.com, Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
References: <20201029180525.1797645-1-maskray@google.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a7d7b3d9-a902-346c-0b9c-d2364440e70b@kernel.org>
Date:   Fri, 30 Oct 2020 10:48:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201029180525.1797645-1-maskray@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29. 10. 20, 19:05, Fangrui Song wrote:
> Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
> memset/memmove/memcpy functions") added .weak directives to
> arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_*
> macros.

There were no SYM_FUNC_START_* macros in 2015.

> This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy`

SYM_FUNC_START_LOCAL(memcpy)
does not add .globl, so I don't understand the rationale.

> which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
> 
> Use the appropriate SYM_FUNC_START_WEAK instead.
> 
> Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>   arch/x86/lib/memcpy_64.S  | 4 +---
>   arch/x86/lib/memmove_64.S | 4 +---
>   arch/x86/lib/memset_64.S  | 4 +---
>   3 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index 037faac46b0c..1e299ac73c86 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -16,8 +16,6 @@
>    * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
>    */
>   
> -.weak memcpy
> -
>   /*
>    * memcpy - Copy a memory block.
>    *
> @@ -30,7 +28,7 @@
>    * rax original destination
>    */
>   SYM_FUNC_START_ALIAS(__memcpy)
> -SYM_FUNC_START_LOCAL(memcpy)
> +SYM_FUNC_START_WEAK(memcpy)
>   	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
>   		      "jmp memcpy_erms", X86_FEATURE_ERMS
>   
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 7ff00ea64e4f..41902fe8b859 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -24,9 +24,7 @@
>    * Output:
>    * rax: dest
>    */
> -.weak memmove
> -
> -SYM_FUNC_START_ALIAS(memmove)
> +SYM_FUNC_START_WEAK(memmove)
>   SYM_FUNC_START(__memmove)
>   
>   	mov %rdi, %rax
> diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
> index 9ff15ee404a4..0bfd26e4ca9e 100644
> --- a/arch/x86/lib/memset_64.S
> +++ b/arch/x86/lib/memset_64.S
> @@ -6,8 +6,6 @@
>   #include <asm/alternative-asm.h>
>   #include <asm/export.h>
>   
> -.weak memset
> -
>   /*
>    * ISO C memset - set a memory block to a byte value. This function uses fast
>    * string to get better performance than the original function. The code is
> @@ -19,7 +17,7 @@
>    *
>    * rax   original destination
>    */
> -SYM_FUNC_START_ALIAS(memset)
> +SYM_FUNC_START_WEAK(memset)
>   SYM_FUNC_START(__memset)
>   	/*
>   	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
> 


-- 
js
suse labs
