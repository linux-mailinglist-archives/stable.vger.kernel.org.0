Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1557B3749E4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEEVIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhEEVIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 17:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF906103E;
        Wed,  5 May 2021 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620248839;
        bh=XX1MaOTqwyZbNr2qmHq5rmE0mWNmyfdB4PmUbQZYwUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqUGfG4+pss2kUdZkYz06SbJtB1Rg53udv27PIENHNcJsIsyubScIIKfZW1Tkn++W
         xc97UDxnyPoz7YO0awonulkH074LQxGqj5cNRewqyF1U45u3aSD20rOZGpLidjS9Ob
         OQu1XFIOfNZX8oWFv39+1i8UtuJugoPZOfSu6Cp0I8mYA1oTZGiaZezylMCLHM8/tr
         8Tt+y2TarOj1SZPIcynZJb35lqKlJReKOdgAkmEU2XidP0wwmLK542EqbeYpRsAete
         n4Y3MS9C9uJ2+k4jcMEW6dmC3F7pspRVU0GX6Jlf+b71N4uYC2LlGR7RS/+sy520MT
         CSfXbwPg2l31w==
Date:   Wed, 5 May 2021 14:07:14 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jian Cai <jiancai@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, ndesaulniers@google.com, manojgupta@google.com,
        llozano@google.com, clang-built-linux@googlegroups.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arm64: vdso: remove commas between macro name and
 arguments
Message-ID: <YJMJAiwMPqlWmr8Y@archlinux-ax161>
References: <20210416203522.2397801-1-jiancai@google.com>
 <20210416232341.2421342-1-jiancai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210416232341.2421342-1-jiancai@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jian,

On Fri, Apr 16, 2021 at 04:23:41PM -0700, Jian Cai wrote:
> LLVM's integrated assembler does not support using commas separating
> the name and arguments in .macro. However, only spaces are used in the
> manual page. This replaces commas between macro names and the subsequent
> arguments with space in calls to clock_gettime_return to make it
> compatible with IAS.
> 
> Link:
> https://sourceware.org/binutils/docs/as/Macro.html#Macro
> https://github.com/ClangBuiltLinux/linux/issues/1349
> 
> Signed-off-by: Jian Cai <jiancai@google.com>

The actual patch itself looks fine to me but there should be some more
explanation in the commit message that this patch is for 4.19 only and
why it is not applicable upstream. Additionally, I would recommend using
the '--subject-prefix=' flag to 'git format-patch' to clarify that as
well, something like '--subject-prefix="PATCH 4.19 ONLY"'?

My explanation would be something like (take bits and pieces as you feel
necessary):

========================================================================

[PATCH 4.19 ONLY] arm64: vdso: remove commas between macro name and
arguments

LLVM's integrated assembler does not support using a comma to separate
a macro name and its arguments when there is only one argument with a
default value:

arch/arm64/kernel/vdso/gettimeofday.S:230:24: error: too many positional
arguments
 clock_gettime_return, shift=1
                       ^
arch/arm64/kernel/vdso/gettimeofday.S:253:24: error: too many positional
arguments
 clock_gettime_return, shift=1
                       ^
arch/arm64/kernel/vdso/gettimeofday.S:274:24: error: too many positional
arguments
 clock_gettime_return, shift=1
                       ^

This error is not in mainline because commit 28b1a824a4f4 ("arm64: vdso:
Substitute gettimeofday() with C implementation") rewrote this assembler
file in C as part of a 25 patch series that is unsuitable for stable.
Just remove the comma in the clock_gettime_return invocations in 4.19 so
that GNU as and LLVM's integrated assembler work the same.

========================================================================

I worded the first sentence the way that I did because correct me if I
am wrong but it seems that the integrated assembler has no issues with
the use of commas separating the arguments in a .macro definition as
that is done everywhere in arch/arm64, just not when there is a single
parameter with a default value because essentially what it is evaluating
it to is "clock_gettime_return ,shift=1", which according to the GAS
manual [1] means that "shift" is actually being set to 0 then there is an
other parameter, when it expects only one.

[1]: After the definition is complete, you can call the macro either as
‘reserve_str a,b’ (with ‘\p1’ evaluating to a and ‘\p2’ evaluating to
b), or as ‘reserve_str ,b’ (with ‘\p1’ evaluating as the default, in
this case ‘0’, and ‘\p2’ evaluating to b).

Lastly, Will or Catalin should ack this as an explicitly out of mainline
patch so that Greg or Sasha can take it. I would put them on the "To:"
line in addition to Greg and Sasha.

Hopefully this is helpful!

Cheers,
Nathan

> ---
> 
> Changes v1 -> v2:
>   Keep the comma in the macro definition to be consistent with other
>   definitions.
> 
> Changes v2 -> v3:
>   Edit tags.
> 
>  arch/arm64/kernel/vdso/gettimeofday.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/vdso/gettimeofday.S
> index 856fee6d3512..b6faf8b5d1fe 100644
> --- a/arch/arm64/kernel/vdso/gettimeofday.S
> +++ b/arch/arm64/kernel/vdso/gettimeofday.S
> @@ -227,7 +227,7 @@ realtime:
>  	seqcnt_check fail=realtime
>  	get_ts_realtime res_sec=x10, res_nsec=x11, \
>  		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>  
>  	ALIGN
>  monotonic:
> @@ -250,7 +250,7 @@ monotonic:
>  		clock_nsec=x15, xtime_sec=x13, xtime_nsec=x14, nsec_to_sec=x9
>  
>  	add_ts sec=x10, nsec=x11, ts_sec=x3, ts_nsec=x4, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>  
>  	ALIGN
>  monotonic_raw:
> @@ -271,7 +271,7 @@ monotonic_raw:
>  		clock_nsec=x15, nsec_to_sec=x9
>  
>  	add_ts sec=x10, nsec=x11, ts_sec=x13, ts_nsec=x14, nsec_to_sec=x9
> -	clock_gettime_return, shift=1
> +	clock_gettime_return shift=1
>  
>  	ALIGN
>  realtime_coarse:
> -- 
> 2.31.1.368.gbe11c130af-goog
> 
