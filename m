Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D873B4125
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFYKL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhFYKL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D2A8613FF;
        Fri, 25 Jun 2021 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624615775;
        bh=bRP9TyRcnckW40uJixbVPjGUqG59vJZKCwinMx0WGVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0QGPR81pKA/prmQ9Whv67dgkKqhUu6ZTMC0KRnAmOfr1wU6WbjRwPowZ+VpYclJ4/
         EWlyEiOGYqelApHH/9/7J9Bp4d3jAtRBY/ITWN+nrr0MV1UopHti6SLTZW/k+1NVEW
         yUR4d81YdQ2kTRIvE22FZACg+4DMZT3nIPGxa7/4=
Date:   Fri, 25 Jun 2021 12:09:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH stable v5.4] arm64: link with -z norelro for LLD or
 aarch64-elf
Message-ID: <YNWrXZNrtdg+8wEK@kroah.com>
References: <20210624170919.3d018a1a@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210624170919.3d018a1a@xhacker.debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 24, 2021 at 05:09:19PM +0800, Jisheng Zhang wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> commit 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 upstream.
> 
> With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> BFD can produce this warning when the target emulation mode does not
> support RELRO program headers, and -z relro or -z norelro is passed.
> 
> Alan Modra clarifies:
>   The default linker emulation for an aarch64-linux ld.bfd is
>   -maarch64linux, the default for an aarch64-elf linker is
>   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
>   you get an emulation that doesn't support -z relro.
> 
> The ARCH=arm64 kernel prefers -maarch64elf, but may fall back to
> -maarch64linux based on the toolchain configuration.
> 
> LLD will always create RELRO program header regardless of target
> emulation.
> 
> To avoid the above warning when linking with BFD, pass -z norelro only
> when linking with LLD or with -maarch64linux.
> 
> Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELOCATABLE")
> Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
> Cc: <stable@vger.kernel.org> # 5.0.x-
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Reported-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Cc: Alan Modra <amodra@gmail.com>
> Cc: Fāng-ruì Sòng <maskray@google.com>
> Link: https://lore.kernel.org/r/20201218002432.788499-1-ndesaulniers@google.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
