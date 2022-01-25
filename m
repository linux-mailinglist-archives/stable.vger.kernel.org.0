Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB8F49BA5D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349928AbiAYR3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588141AbiAYR1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:27:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0226C061749
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 09:27:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D08B817E6
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB6C340E0;
        Tue, 25 Jan 2022 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643131638;
        bh=W1JGIllnulbFNWiwuGchryI71/BkLOUPO/+XB5WOUgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gwfhQKJhgQ4QLE0wtqIDBPxCQSMA8/s+65K0/YTYQStKNuU8VEoTj1e3V+sKKQ4bJ
         XgoXeXGCjUxVjpTqGiPuX13bxfhgaurJS2rKJtRYL1Y9cVa1En7k7YF5j2JMTsKBSB
         W2YgPdyGECrq+EMMLj0lRBXwAwCcWod3fCwckGxXTZFu1oy/qQExRfecnr39LW5jPi
         yZl6NQveyXxtKsdpqN1qa3Z6lZ9Rt/CtDLrjOt24hixPTe0am9aTFQw+tD/A9xxSHm
         nCI+dyx3E68cUahLDgA1MmGDR8/xjRFUeTyodlTY1zzpZxDQQDQiHZJ0cbSrEsZcpp
         U9CjMB/c2ihrw==
Date:   Tue, 25 Jan 2022 10:27:14 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev
Subject: Re: stable-rc 5.4 queue riscv tinyconfig build failed
Message-ID: <YfAy8u5u43x1z/jg@archlinux-ax161>
References: <CA+G9fYuxkfKF=+xebi5z8VodYoXa2G-Agxw49ftz9vck7MxP+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuxkfKF=+xebi5z8VodYoXa2G-Agxw49ftz9vck7MxP+Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

On Tue, Jan 25, 2022 at 07:18:16PM +0530, Naresh Kamboju wrote:
> Hi Greg,
> 
> Regression found on
> stable-rc 5.4 queue riscv tinyconfig build failed.
> 
> Not sure which patch is causing build failures.
> We will bisect and get back to you.

These should not be recent failures on 5.4, they should have always been
there.

> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current LLVM_IAS=1 ARCH=riscv
> CROSS_COMPILE=riscv64-linux-gnu- HOSTCC=clang CC=clang
> 
> In file included from /builds/linux/kernel/dma/mapping.c:8:
> In file included from /builds/linux/include/linux/memblock.h:13:
> In file included from /builds/linux/include/linux/mm.h:10:
> In file included from /builds/linux/include/linux/gfp.h:6:
> In file included from /builds/linux/include/linux/mmzone.h:8:
> In file included from /builds/linux/include/linux/spinlock.h:51:
> In file included from /builds/linux/include/linux/preempt.h:78:
> In file included from ./arch/riscv/include/generated/asm/preempt.h:1:
> In file included from /builds/linux/include/asm-generic/preempt.h:5:
> In file included from /builds/linux/include/linux/thread_info.h:22:
> /builds/linux/arch/riscv/include/asm/current.h:30:9: warning: variable
> 'tp' is uninitialized when used here [-Wuninitialized]
>         return tp;
>                ^~
> /builds/linux/arch/riscv/include/asm/current.h:29:33: note: initialize
> the variable 'tp' to silence this warning
>         register struct task_struct *tp __asm__("tp");
>                                        ^
>                                         = NULL

Resolved by commit 52e7c52d2ded ("RISC-V: Stop relying on GCC's register
allocator's hueristics").

It had two follow up fixes:

af2bdf828f79 ("RISC-V: stacktrace: Declare sp_in_global outside ifdef")
8356c379cfba ("RISC-V: gp_in_global needs register keyword")

> clang: warning: argument unused during compilation: '-no-pie'
> [-Wunused-command-line-argument]

Resolved by commit 7f3d349065d0 ("riscv: Use $(LD) instead of $(CC) to
link vDSO"). I don't think that will backport clean but it is not an
error so I would not worry about it.

> In file included from /builds/linux/arch/riscv/kernel/cpu.c:7:
> In file included from /builds/linux/include/linux/seq_file.h:8:
> In file included from /builds/linux/include/linux/mutex.h:14:
> /builds/linux/arch/riscv/include/asm/current.h:30:9: warning: variable
> 'tp' is uninitialized when used here [-Wuninitialized]
>         return tp;
>                ^~
> /builds/linux/arch/riscv/include/asm/current.h:29:33: note: initialize
> the variable 'tp' to silence this warning
>         register struct task_struct *tp __asm__("tp");
>                                        ^
>                                         = NULL
> 1 warning generated.
> 1 warning generated.
> 1 warning generated.
> 1 warning generated.
> <instantiation>:1:1: error: unrecognized instruction mnemonic
> LOCAL _restore_kernel_tpsp
> ^
> /builds/linux/arch/riscv/kernel/entry.S:163:2: note: while in macro
> instantiation
>  SAVE_ALL
>  ^
> <instantiation>:2:2: error: unrecognized instruction mnemonic
>  LOCAL _save_context
>  ^

Should be resolved with commits fdff9911f266 ("RISC-V: Inline the
assembly register save/restore macros") and abc71bf0a703 ("RISC-V: Stop
using LOCAL for the uaccess fixups").

There might be other issues lurking, I would not say we had decent
RISC-V build support with LLVM until maybe 5.10 or so (that is the
version that we start testing RISC-V at in our CI).

Cheers,
Nathan
