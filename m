Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE0375994
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 19:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhEFRod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 13:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236301AbhEFRod (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 13:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23686102A;
        Thu,  6 May 2021 17:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620323014;
        bh=LJzHyecmZhWMd6TrHOugsQjNslKCwtZOvVulyfCZyTk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Zh6a1Jz2O2ox82vIqGJ6TMm/hw9CM9L8WRMPjIaDY5Jc9Hwu2/ZQdzjtvi+Ak/7GT
         sK8r29obvojVKDxXENw3L07RHlOrRO3wjjgWwDA8EM8lUgGdlrvKketRQ25kJwEDqx
         RuzAx/Yn9EMz6YkPnX/SsUjfs6iIwU6orGxeyVtU2i5RfxvjveuClG0PIdpkUNkb3Z
         0enjqcTstAM4apHKhOHx8YhHp3RW+lqMKdkjw1pDd3br4L85Ydykmu75sEuF0VH8/Y
         73moXI/9dbkgd+LcANqVOc/z1RUei6IKLCtJnXYt3+prZlVcdwTYZMgNRQQL1Ohzzr
         X5iPdn/6u95Lg==
Subject: Re: [PATCH 4.19 ONLY v4] arm64: vdso: remove commas between macro
 name and arguments
To:     Jian Cai <jiancai@google.com>, gregkh@linuxfoundation.org,
        sashal@kernel.org, will@kernel.org, catalin.marinas@arm.com
Cc:     stable@vger.kernel.org, ndesaulniers@google.com,
        manojgupta@google.com, llozano@google.com,
        clang-built-linux@googlegroups.com,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210506012508.3822221-1-jiancai@google.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <fd08dce2-71c0-3414-d661-d065480c04ff@kernel.org>
Date:   Thu, 6 May 2021 10:43:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210506012508.3822221-1-jiancai@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/2021 6:25 PM, Jian Cai wrote:
> LLVM's integrated assembler appears to assume an argument with default
> value is passed whenever it sees a comma right after the macro name.
> It will be fine if the number of following arguments is one less than
> the number of parameters specified in the macro definition. Otherwise,
> it fails. For example, the following code works:
> 
> $ cat foo.s
> .macro  foo arg1=2, arg2=4
>          ldr r0, [r1, #\arg1]
>          ldr r0, [r1, #\arg2]
> .endm
> 
> foo, arg2=8
> 
> $ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
> arm-linux-gnueabihf-objdump -dr ias.o
> 
> ias.o:     file format elf32-littlearm
> 
> Disassembly of section .text:
> 
> 00000000 <.text>:
>     0: e5910001 ldr r0, [r1, #2]
>     4: e5910003 ldr r0, [r1, #8]
> 
> While the the following code would fail:
> 
> $ cat foo.s
> .macro  foo arg1=2, arg2=4
>          ldr r0, [r1, #\arg1]
>          ldr r0, [r1, #\arg2]
> .endm
> 
> foo, arg1=2, arg2=8
> 
> $ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
> foo.s:6:14: error: too many positional arguments
> foo, arg1=2, arg2=8
> 
> This causes build failures as follows:
> 
> arch/arm64/kernel/vdso/gettimeofday.S:230:24: error: too many positional
> arguments
>   clock_gettime_return, shift=1
>                         ^
> arch/arm64/kernel/vdso/gettimeofday.S:253:24: error: too many positional
> arguments
>   clock_gettime_return, shift=1
>                         ^
> arch/arm64/kernel/vdso/gettimeofday.S:274:24: error: too many positional
> arguments
>   clock_gettime_return, shift=1
> 
> This error is not in mainline because commit 28b1a824a4f4 ("arm64: vdso:
> Substitute gettimeofday() with C implementation") rewrote this assembler
> file in C as part of a 25 patch series that is unsuitable for stable.
> Just remove the comma in the clock_gettime_return invocations in 4.19 so
> that GNU as and LLVM's integrated assembler work the same.
> 
> Link:
> https://github.com/ClangBuiltLinux/linux/issues/1349
> 
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Jian Cai <jiancai@google.com>

Thanks for the updated example and explanation, this looks good to me now.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
> Changes v1 -> v2:
>    Keep the comma in the macro definition to be consistent with other
>    definitions.
> 
> Changes v2 -> v3:
>    Edit tags.
> 
> Changes v3 -> v4:
>    Update the commit message based on Nathan's comments.
> 
>   arch/arm64/kernel/vdso/gettimeofday.S | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
> index 856fee6d3512..b6faf8b5d1fe 100644
> --- a/arch/arm64/kernel/vdso/gettimeofday.S
> +++ b/arch/arm64/kernel/vdso/gettimeofday.S
> @@ -227,7 +227,7 @@ realtime:
>   	seqcnt_check fail=realtime
>   	get_ts_realtime res_sec=x10, res_nsec=x11, \
>   		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>   
>   	ALIGN
>   monotonic:
> @@ -250,7 +250,7 @@ monotonic:
>   		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
>   
>   	add_ts sec=x10, nsec=x11, ts_sec=x3, ts_nsec=x4, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>   
>   	ALIGN
>   monotonic_raw:
> @@ -271,7 +271,7 @@ monotonic_raw:
>   		clock_nsec=x15, nsec_to_sec=x9
>   
>   	add_ts sec=x10, nsec=x11, ts_sec=x13, ts_nsec=x14, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>   
>   	ALIGN
>   realtime_coarse:
> 

