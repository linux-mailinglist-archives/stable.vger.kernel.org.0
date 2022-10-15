Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B306A5FF9C3
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 13:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJOLT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 07:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJOLTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 07:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D246420
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 04:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F6D60C88
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 11:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C12C433D6;
        Sat, 15 Oct 2022 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665832762;
        bh=KHG7HVZ5S6NDYVXtRkMF2CxdWRI0GuJHWCxCvCd4QxI=;
        h=From:To:Cc:Subject:Date:From;
        b=Z6N4NItkXTF+NfBC4NW8Wl88UVogHp7/XExpFUFpjDMs2EO0UXRqS+oOH4OuHVxAq
         +1JMu7xwaE6FOfAPi9FqpFDpY7zxvH72qy69jCeKaNRKjK/yqJSlzg3v08c8m7U9d3
         mkuNUS+7vW/zSx1qvc2YLBk295d4LVOJbC5Vi/v8QYqDLevDAeZNDgeSTpDkOaEBc/
         Agp+arXDl4nftHmRUFzbaHwC2+K7PXlweDP92zreNn5QvQne3wrPM3XGAlHfjZV693
         SlmQp4LnVebVgrgDB0nur+gO1RFK1xMgcHmJcLbFR0bprRzGpYV6bnPiY5DTSFtFwL
         9aE472bkCtfvg==
From:   Conor Dooley <conor@kernel.org>
To:     stable@vger.kernel.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19] riscv: fix build with binutils 2.38
Date:   Sat, 15 Oct 2022 12:18:57 +0100
Message-Id: <20221015111856.3869148-1-conor@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

commit 6df2a016c0c8a3d0933ef33dd192ea6606b115e3 upstream.

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

The fix is to specify those extensions explicitly in -march. However as
older binutils version do not support this, we first need to detect
that.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[Conor: converted to the 4.19 style of march string generation]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
CC: Palmer Dabbelt <palmer@dabbelt.com>
CC: linux-riscv@lists.infradead.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

lkp has yet to complain, so here you go Greg..

 arch/riscv/Makefile | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 110be14e6122..b024029a2247 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -49,9 +49,16 @@ ifeq ($(CONFIG_RISCV_ISA_C),y)
 	KBUILD_ARCH_C = c
 endif
 
-KBUILD_AFLAGS += -march=$(KBUILD_MARCH)$(KBUILD_ARCH_A)fd$(KBUILD_ARCH_C)
+# Newer binutils versions default to ISA spec version 20191213 which moves some
+# instructions from the I extension to the Zicsr and Zifencei extensions.
+toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
+ifeq ($(toolchain-need-zicsr-zifencei),y)
+	KBUILD_ARCH_ZISCR_ZIFENCEI = _zicsr_zifencei
+endif
+
+KBUILD_AFLAGS += -march=$(KBUILD_MARCH)$(KBUILD_ARCH_A)fd$(KBUILD_ARCH_C)$(KBUILD_ARCH_ZISCR_ZIFENCEI)
 
-KBUILD_CFLAGS += -march=$(KBUILD_MARCH)$(KBUILD_ARCH_A)$(KBUILD_ARCH_C)
+KBUILD_CFLAGS += -march=$(KBUILD_MARCH)$(KBUILD_ARCH_A)$(KBUILD_ARCH_C)$(KBUILD_ARCH_ZISCR_ZIFENCEI)
 KBUILD_CFLAGS += -mno-save-restore
 KBUILD_CFLAGS += -DCONFIG_PAGE_OFFSET=$(CONFIG_PAGE_OFFSET)
 
-- 
2.37.3

