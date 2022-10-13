Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD75FDA37
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJMNSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiJMNSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:18:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39903197F86
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D8F2B810B2
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 13:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE71C433C1;
        Thu, 13 Oct 2022 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665667076;
        bh=N48cQWVMXfLnkvPy6rE9+IJDnqiFwjCHxnKkJ6Mw05E=;
        h=Subject:To:Cc:From:Date:From;
        b=oj64EeKmtjISFmn5qg3wFKvZFg7kj3CxDYveZrYjWzFOz4OzJCL+urGDuG3l3O0w5
         vGsdmTHWIDMT9VtC92UXaD3kUR1CgCmn4tDgi6qeI4qGoLKBVrUHQMjDAqm71su6yO
         1PEc+KHWIhniSZI6Nv30sNWM2xg/wqpSHLm7u2CQ=
Subject: FAILED: patch "[PATCH] riscv: fix build with binutils 2.38" failed to apply to 5.19-stable tree
To:     aurelien@aurel32.net, alexandre.ghiti@canonical.com,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 15:10:48 +0200
Message-ID: <166566664822031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.


thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6df2a016c0c8a3d0933ef33dd192ea6606b115e3 Mon Sep 17 00:00:00 2001
From: Aurelien Jarno <aurelien@aurel32.net>
Date: Wed, 26 Jan 2022 18:14:42 +0100
Subject: [PATCH] riscv: fix build with binutils 2.38

From version 2.38, binutils default to ISA spec version 20191213. This
means that the csr read/write (csrr*/csrw*) instructions and fence.i
instruction has separated from the `I` extension, become two standalone
extensions: Zicsr and Zifencei. As the kernel uses those instruction,
this causes the following build failure:

  CC      arch/riscv/kernel/vdso/vgettimeofday.o
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'

The fix is to specify those extensions explicitely in -march. However as
older binutils version do not support this, we first need to detect
that.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 8a107ed18b0d..7d81102cffd4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+
+# Newer binutils versions default to ISA spec version 20191213 which moves some
+# instructions from the I extension to the Zicsr and Zifencei extensions.
+toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
+riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 

