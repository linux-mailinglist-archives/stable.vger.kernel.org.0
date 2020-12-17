Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7F2DD104
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 13:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgLQMCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 07:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgLQMCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 07:02:05 -0500
Date:   Thu, 17 Dec 2020 12:01:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608206484;
        bh=r7jUwdDtR40JwLDq4mN8x2Vdpjg4t/rJFJC0XlwKltM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=YC253vLNdtERLVRDsI1bn/nR9wmfN11MHTmXEIsd31azR4jyO+1EQyuBvbJBbeipx
         6Gsg5cPZjTaMw0+lcelI9BCq0Z+3PYzfyYqQWB4BUWbDv9U7yBx7blSS+iQH/EQoh4
         4JZx0aCB84UkDTdPIuDys50mhZCFVb2aWtC7uJEYu2FHvTk0YtcECivzX1bocVfGru
         u4/VmBoxro9bdA4gg2iVUXZCFQ+NMexV+Hiw0ErTCJ6HAMQem6gMG0b6WlmmDSFW1o
         mQUdhzceqOkZrZlNvZ2kQmB6n4fw7/wABkbg0D9DKz02F2tKLK9KVRVFhjkx5HNFCE
         a8OlX9bK2TVfg==
From:   Will Deacon <will@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        Alan Modra <amodra@gmail.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: link with -z norelro for LLD or aarch64-elf
Message-ID: <20201217120118.GC17544@willie-the-truck>
References: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
 <20201217004051.1247544-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217004051.1247544-1-ndesaulniers@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 04:40:51PM -0800, Nick Desaulniers wrote:
> With newer GNU binutils, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> BFD can produce this warning when the target emulation mode does not
> support RELRO relocation types, and -z relro or -z norelro is passed.
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
> LLD will always create RELRO relocation types regardless of target
> emulation.
> 
> To avoid the above warning when linking with BFD, pass -z norelro only
> when linking with LLD or with -maarch64linux.

Given that, prior to 3b92fa7485eb, we used to pass '-z norelro' if
CONFIG_RELOCATABLE then was this already broken with the ELF toolchain?

Will
