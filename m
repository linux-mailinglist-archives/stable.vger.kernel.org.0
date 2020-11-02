Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3702A2609
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 09:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgKBIXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 03:23:53 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33002 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgKBIXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 03:23:53 -0500
Received: by mail-ed1-f66.google.com with SMTP id v4so13509704edi.0
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 00:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TZs0TcvSWLBHOqopWkTRDgLTMK1vu9BumbKPDaVCEo=;
        b=GuQ+gm/qFHhHqYCPcnlDYVN9+J9CUN28rlgj3znMAnQxf2zDayk+MHUCUn0WCdad+u
         e2hiAW4kk1Qr71+75pMGw4/Sy3EZCxdk6praoKvt2LN1sUY8jehdeQ0RF/S36QHvpjKM
         EZ1v8e9C8qvnq/uirybKxiFLFJxXsyFRuFVFiiM/1GKe+ssC5LJSSm3Z0wDFNKD2xyum
         kcd38/SbN3pLfW4myGUGgf1rBUY4cu1GzFeRTd8Mna4HD9BiH0GNHHRuqTQ3ZtkqILqT
         neGH/T03z1OtpBJFstsWBAcVW6cgC3kggRf4DSA+W1K6yUAZFOX/l2oqCbtCj7WoZmgm
         VnvA==
X-Gm-Message-State: AOAM530+ZsLRE1rXELmIXFhU2nYU0lEL779SnH9O0/L6BRyaOQIMagTn
        plJLnlHwrT79JUr7+drFhrWfOk0IcIE=
X-Google-Smtp-Source: ABdhPJzOJP6JprdhCh2YdRPBkaT3kawc0WyRQeiYwgT3bDIcw3XiQbHAuRrgxg/+zzXyHl2wvAjClA==
X-Received: by 2002:a05:6402:742:: with SMTP id p2mr15667840edy.107.1604305428975;
        Mon, 02 Nov 2020 00:23:48 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id y1sm10228448edj.76.2020.11.02.00.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 00:23:47 -0800 (PST)
Subject: Re: [PATCH] x86_64: Change .weak to SYM_FUNC_START_WEAK for
 arch/x86/lib/mem*_64.S
To:     =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
Cc:     X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20201029180525.1797645-1-maskray@google.com>
 <a7d7b3d9-a902-346c-0b9c-d2364440e70b@kernel.org>
 <CAFP8O3JEOXJumFtPh4dwiYT2FHt+27epqnBUQ-2622Mm29trcQ@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <aa69278b-c07b-99b7-ebb0-b1a0adb4efd5@kernel.org>
Date:   Mon, 2 Nov 2020 09:23:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <CAFP8O3JEOXJumFtPh4dwiYT2FHt+27epqnBUQ-2622Mm29trcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30. 10. 20, 17:08, Fāng-ruì Sòng wrote:
> On Fri, Oct 30, 2020 at 2:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>>
>> On 29. 10. 20, 19:05, Fangrui Song wrote:
>>> Commit 393f203f5fd5 ("x86_64: kasan: add interceptors for
>>> memset/memmove/memcpy functions") added .weak directives to
>>> arch/x86/lib/mem*_64.S instead of changing the existing SYM_FUNC_START_*
>>> macros.
>>
>> There were no SYM_FUNC_START_* macros in 2015.
> 
> include/linux/linkage.h had WEAK in 2015 and WEAK should have been
> used instead. Do I just need to fix the description?
> 
>>> This can lead to the assembly snippet `.weak memcpy ... .globl
>>> memcpy`
>>
>> SYM_FUNC_START_LOCAL(memcpy)
>> does not add .globl, so I don't understand the rationale.
> 
> There is no problem using
> .weak
> SYM_FUNC_START_LOCAL
> just looks suspicious so I changed it, too.

So the commit log doesn't correspond to your changes ;). You need to 
update it and describe the difference from memmove/memset properly.

>>> which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
>>> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
>>> https://reviews.llvm.org/D90108) will error on such an overridden symbol
>>> binding.
>>>
>>> Use the appropriate SYM_FUNC_START_WEAK instead.
>>>
>>> Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
>>> Reported-by: Sami Tolvanen <samitolvanen@google.com>
>>> Signed-off-by: Fangrui Song <maskray@google.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    arch/x86/lib/memcpy_64.S  | 4 +---
>>>    arch/x86/lib/memmove_64.S | 4 +---
>>>    arch/x86/lib/memset_64.S  | 4 +---
>>>    3 files changed, 3 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
>>> index 037faac46b0c..1e299ac73c86 100644
>>> --- a/arch/x86/lib/memcpy_64.S
>>> +++ b/arch/x86/lib/memcpy_64.S
>>> @@ -16,8 +16,6 @@
>>>     * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
>>>     */
>>>
>>> -.weak memcpy
>>> -
>>>    /*
>>>     * memcpy - Copy a memory block.
>>>     *
>>> @@ -30,7 +28,7 @@
>>>     * rax original destination
>>>     */
>>>    SYM_FUNC_START_ALIAS(__memcpy)
>>> -SYM_FUNC_START_LOCAL(memcpy)
>>> +SYM_FUNC_START_WEAK(memcpy)
>>>        ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
>>>                      "jmp memcpy_erms", X86_FEATURE_ERMS
>>>
>>> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
>>> index 7ff00ea64e4f..41902fe8b859 100644
>>> --- a/arch/x86/lib/memmove_64.S
>>> +++ b/arch/x86/lib/memmove_64.S
>>> @@ -24,9 +24,7 @@
>>>     * Output:
>>>     * rax: dest
>>>     */
>>> -.weak memmove
>>> -
>>> -SYM_FUNC_START_ALIAS(memmove)
>>> +SYM_FUNC_START_WEAK(memmove)
>>>    SYM_FUNC_START(__memmove)
>>>
>>>        mov %rdi, %rax
>>> diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
>>> index 9ff15ee404a4..0bfd26e4ca9e 100644
>>> --- a/arch/x86/lib/memset_64.S
>>> +++ b/arch/x86/lib/memset_64.S
>>> @@ -6,8 +6,6 @@
>>>    #include <asm/alternative-asm.h>
>>>    #include <asm/export.h>
>>>
>>> -.weak memset
>>> -
>>>    /*
>>>     * ISO C memset - set a memory block to a byte value. This function uses fast
>>>     * string to get better performance than the original function. The code is
>>> @@ -19,7 +17,7 @@
>>>     *
>>>     * rax   original destination
>>>     */
>>> -SYM_FUNC_START_ALIAS(memset)
>>> +SYM_FUNC_START_WEAK(memset)
>>>    SYM_FUNC_START(__memset)
>>>        /*
>>>         * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
>>>
>>
>>
>> --
>> js
>> suse labs
> 
> 
> 


-- 
js
