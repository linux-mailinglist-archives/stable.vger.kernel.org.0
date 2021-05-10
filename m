Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5B377D9C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEJIE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhEJIE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 04:04:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41DD61108;
        Mon, 10 May 2021 08:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620633833;
        bh=3pVlZd3endQBC1asJ5OJ1LBt8LcXCHuSEw4u58gmNgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1BOnYO8kW6IDQ469LmdKmEzDvbwEK+bfcPtTBh/BbPZEWMwQjN0Eq7HZ2gz9MhDVU
         yPB0Mu8ysv1TFX2tDJw851gUD0GyVaF64BxB5UN0oR4keLu66BtGJPkmUOFOn41L7j
         k+rI4b+W/6awXs88loMN0gYfqvj9AFZfFRAtiBOs=
Date:   Mon, 10 May 2021 10:03:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jian Cai <jiancai@google.com>, sashal@kernel.org, will@kernel.org,
        catalin.marinas@arm.com, stable@vger.kernel.org,
        ndesaulniers@google.com, manojgupta@google.com, llozano@google.com,
        clang-built-linux@googlegroups.com,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.19 ONLY v4] arm64: vdso: remove commas between macro
 name and arguments
Message-ID: <YJjo5xRF9zZnVouN@kroah.com>
References: <20210506012508.3822221-1-jiancai@google.com>
 <fd08dce2-71c0-3414-d661-d065480c04ff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd08dce2-71c0-3414-d661-d065480c04ff@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 10:43:33AM -0700, Nathan Chancellor wrote:
> On 5/5/2021 6:25 PM, Jian Cai wrote:
> > LLVM's integrated assembler appears to assume an argument with default
> > value is passed whenever it sees a comma right after the macro name.
> > It will be fine if the number of following arguments is one less than
> > the number of parameters specified in the macro definition. Otherwise,
> > it fails. For example, the following code works:
> > 
> > $ cat foo.s
> > .macro  foo arg1=2, arg2=4
> >          ldr r0, [r1, #\arg1]
> >          ldr r0, [r1, #\arg2]
> > .endm
> > 
> > foo, arg2=8
> > 
> > $ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
> > arm-linux-gnueabihf-objdump -dr ias.o
> > 
> > ias.o:     file format elf32-littlearm
> > 
> > Disassembly of section .text:
> > 
> > 00000000 <.text>:
> >     0: e5910001 ldr r0, [r1, #2]
> >     4: e5910003 ldr r0, [r1, #8]
> > 
> > While the the following code would fail:
> > 
> > $ cat foo.s
> > .macro  foo arg1=2, arg2=4
> >          ldr r0, [r1, #\arg1]
> >          ldr r0, [r1, #\arg2]
> > .endm
> > 
> > foo, arg1=2, arg2=8
> > 
> > $ llvm-mc -triple=armv7a -filetype=obj foo.s -o ias.o
> > foo.s:6:14: error: too many positional arguments
> > foo, arg1=2, arg2=8
> > 
> > This causes build failures as follows:
> > 
> > arch/arm64/kernel/vdso/gettimeofday.S:230:24: error: too many positional
> > arguments
> >   clock_gettime_return, shift=1
> >                         ^
> > arch/arm64/kernel/vdso/gettimeofday.S:253:24: error: too many positional
> > arguments
> >   clock_gettime_return, shift=1
> >                         ^
> > arch/arm64/kernel/vdso/gettimeofday.S:274:24: error: too many positional
> > arguments
> >   clock_gettime_return, shift=1
> > 
> > This error is not in mainline because commit 28b1a824a4f4 ("arm64: vdso:
> > Substitute gettimeofday() with C implementation") rewrote this assembler
> > file in C as part of a 25 patch series that is unsuitable for stable.
> > Just remove the comma in the clock_gettime_return invocations in 4.19 so
> > that GNU as and LLVM's integrated assembler work the same.
> > 
> > Link:
> > https://github.com/ClangBuiltLinux/linux/issues/1349
> > 
> > Suggested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Jian Cai <jiancai@google.com>
> 
> Thanks for the updated example and explanation, this looks good to me now.
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Now queued up, thanks.

greg k-h
