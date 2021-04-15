Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E854360A78
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDON00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232332AbhDON0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 09:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30368611F1;
        Thu, 15 Apr 2021 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618493162;
        bh=a8YGM1QHoejUmqiDy7BCC4AnhOry2uZdLnJGbKmlUmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JIQBEpSUcpxCqzmgP/zge9t7wuxruG3GEHMThTNvEAs1l3ScE8wGKihQsAAZrWg+K
         ha6HQSdyAN4sLgi2Czq+M/vhfPtmAmJf3N7Vw+uK4+MmXdHlNF2w2v0aw8+tdlhB5O
         dw34wOlvjzszW8UISFNUnETSsGNi7IbT4m/a9AmgmqhDCv7nOnYCwigxjugK3A11AQ
         0s0iiduCcDKkhYz+eEBKhHcgnOrnxuOaaZgi5jC2tp1V+DG//N42TT7EeL6JPWBWzp
         EGSx2KsM1G1kWeQxp2MSjq6YKdJpPQhDffcuUD+PfzN7MW+R8R2Y/LC6bjBApUNg5k
         0+r+/BMs3uuTg==
Date:   Thu, 15 Apr 2021 06:25:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Jian Cai <jiancai@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: alternatives: Move length validation in
 alternative_{insn,endif}
Message-ID: <YHg+5RSG4XPLlZD8@archlinux-ax161>
References: <20210414000803.662534-1-nathan@kernel.org>
 <20210415091743.GB1015@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415091743.GB1015@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 10:17:43AM +0100, Catalin Marinas wrote:
> Hi Nathan,
> 
> On Tue, Apr 13, 2021 at 05:08:04PM -0700, Nathan Chancellor wrote:
> > After commit 2decad92f473 ("arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
> > set atomically"), LLVM's integrated assembler fails to build entry.S:
> > 
> > <instantiation>:5:7: error: expected assembly-time absolute expression
> >  .org . - (664b-663b) + (662b-661b)
> >       ^
> > <instantiation>:6:7: error: expected assembly-time absolute expression
> >  .org . - (662b-661b) + (664b-663b)
> >       ^
> 
> I tried the latest Linus' tree and linux-next (defconfig) with this
> commit in and I can't get your build error. I used both clang-10 from
> Debian stable and clang-11 from Debian sid. So, which clang version did
> you use or which kernel config options?
> 
> -- 
> Catalin
> 

Hi Catalin,

Interesting, this reproduces for me with LLVM 12 or newer with just
defconfig.

$ make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1 defconfig arch/arm64/kernel/entry.o

https://github.com/ClangBuiltLinux/continuous-integration2/runs/2350258778?check_suite_focus=true

Cheers,
Nathan
