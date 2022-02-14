Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1284B47A2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiBNJmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244451AbiBNJke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:40:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E4EAE73;
        Mon, 14 Feb 2022 01:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB21D60F87;
        Mon, 14 Feb 2022 09:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363BC340E9;
        Mon, 14 Feb 2022 09:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831355;
        bh=ttAjhxJxsbbfewrD5hFVV63NeMqgPW7t1AYSU8g2YOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCbEU942iDmoaXXeFmPI1wE/f4KRFgFEv+HCihF8PclM4anP1sblDxA0Z0I7m8VTs
         So5S/yGkAOXG8/5X8ppj5UIv4tQDX1q0zwXc65xAJhDYXhy8E0Yw3uWKgJqwXGWTB9
         qS5nqYFpkEijeEGs+XJd+febiKsMCFKfjBRPoAyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.4 27/71] riscv: fix build with binutils 2.38
Date:   Mon, 14 Feb 2022 10:25:55 +0100
Message-Id: <20220214092452.926762935@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

commit 6df2a016c0c8a3d0933ef33dd192ea6606b115e3 upstream.

>From version 2.38, binutils default to ISA spec version 20191213. This
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -48,6 +48,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32
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
 


