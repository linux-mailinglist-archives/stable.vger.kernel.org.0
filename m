Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205545FE288
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJMTNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJMTNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:13:18 -0400
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914AA15B13C
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 12:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=YN6mk+SH6VeqhZ/teXu9sGnPb4Z/BPkxE0dwxD0b+9s=; b=qkW6CQbC910UyedEZ0bf1DovM3
        w/GtMlnsTg4XqfvqWoNiJT2MTtKAbAHc7YOd55TOVpESD9ZXSCxESvJGROGnHD7PN4UyaqBvSquvA
        IPiXqavYV0FiIyLKmqRHRn4eReXZS2UlBP0cMqsfdTfA/1O5ckKD6ULeUlVoIrIUCrC4joelY9Ioq
        DQqsyj8+BikfI8jCbeu/wv5Tu6unErXu1UlY3CM435tQUX4fTwlJPji3lTJCXsgRGRgnwwsBWIi6S
        Lxj+2Y+K7ys9S/ZWLzq/c4/KViIbW+YqMuWU4yO+bAibM5IrSdiRPLqAtkf8Uz9eZ5GxU+RHoBa+n
        2u91kD3w==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1oj3dp-005kTV-Uz; Thu, 13 Oct 2022 21:13:13 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.96)
        (envelope-from <aurelien@aurel32.net>)
        id 1oj3dp-002xTN-1m;
        Thu, 13 Oct 2022 21:13:13 +0200
Date:   Thu, 13 Oct 2022 21:13:13 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     gregkh@linuxfoundation.org
Cc:     alexandre.ghiti@canonical.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: fix build with binutils 2.38"
 failed to apply to 6.0-stable tree
Message-ID: <Y0hjSdcCipuvpIJ9@aurel32.net>
References: <166566664730112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166566664730112@kroah.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-13 15:10, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This patch has been merged in kernel 5.17, so it does not need to be
"backported" to kernel 6.0.

Regards
Aurelien

> ------------------ original commit in Linus's tree ------------------
> 
> From 6df2a016c0c8a3d0933ef33dd192ea6606b115e3 Mon Sep 17 00:00:00 2001
> From: Aurelien Jarno <aurelien@aurel32.net>
> Date: Wed, 26 Jan 2022 18:14:42 +0100
> Subject: [PATCH] riscv: fix build with binutils 2.38
> 
> From version 2.38, binutils default to ISA spec version 20191213. This
> means that the csr read/write (csrr*/csrw*) instructions and fence.i
> instruction has separated from the `I` extension, become two standalone
> extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> this causes the following build failure:
> 
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
> 
> The fix is to specify those extensions explicitely in -march. However as
> older binutils version do not support this, we first need to detect
> that.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> 
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 8a107ed18b0d..7d81102cffd4 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
>  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
> +
> +# Newer binutils versions default to ISA spec version 20191213 which moves some
> +# instructions from the I extension to the Zicsr and Zifencei extensions.
> +toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> +riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> +
>  KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
>  KBUILD_AFLAGS += -march=$(riscv-march-y)
>  
> 
> 

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
