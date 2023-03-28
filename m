Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596F6CC4AC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjC1PHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjC1PHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D13ADBF6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C6B6183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB2EC433EF;
        Tue, 28 Mar 2023 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015874;
        bh=CTaLXR9sbgrsf9ov7NU4ET92zepwvOHdUkZEskpWCFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/URQCigrwBQOAivryo+nEgzFZJ3HPS2KFxz88C6Sl3PTFAjKl/ZV9a/KfbzKM6PC
         WhaqWT2zZiEravsPhMzNWvmUFq9FkYAAxWcH8I9J1Z7kvjEbHYCuvY3evrtExE2tnv
         9HdIWpTcHBY2i/+/dCJz7LwTG6SZFYiHXTAuRY+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 207/224] riscv: Handle zicsr/zifencei issues between clang and binutils
Date:   Tue, 28 Mar 2023 16:43:23 +0200
Message-Id: <20230328142625.989983395@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit e89c2e815e76471cb507bd95728bf26da7976430 upstream.

There are two related issues that appear in certain combinations with
clang and GNU binutils.

The first occurs when a version of clang that supports zicsr or zifencei
via '-march=' [1] (i.e, >= 17.x) is used in combination with a version
of GNU binutils that do not recognize zicsr and zifencei in the
'-march=' value (i.e., < 2.36):

  riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifencei2p0: Invalid or unknown z ISA extension: 'zifencei'
  riscv64-linux-gnu-ld: failed to merge target specific data of file fs/efivarfs/file.o
  riscv64-linux-gnu-ld: -march=rv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifencei2p0: Invalid or unknown z ISA extension: 'zifencei'
  riscv64-linux-gnu-ld: failed to merge target specific data of file fs/efivarfs/super.o

The second occurs when a version of clang that does not support zicsr or
zifencei via '-march=' (i.e., <= 16.x) is used in combination with a
version of GNU as that defaults to a newer ISA base spec, which requires
specifying zicsr and zifencei in the '-march=' value explicitly (i.e, >=
2.38):

  ../arch/riscv/kernel/kexec_relocate.S: Assembler messages:
  ../arch/riscv/kernel/kexec_relocate.S:147: Error: unrecognized opcode `fence.i', extension `zifencei' required
  clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)

This is the same issue addressed by commit 6df2a016c0c8 ("riscv: fix
build with binutils 2.38") (see [2] for additional information) but
older versions of clang miss out on it because the cc-option check
fails:

  clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupported standard user-level extension 'zicsr'
  clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupported standard user-level extension 'zicsr'

To resolve the first issue, only attempt to add zicsr and zifencei to
the march string when using the GNU assembler 2.38 or newer, which is
when the default ISA spec was updated, requiring these extensions to be
specified explicitly. LLVM implements an older version of the base
specification for all currently released versions, so these instructions
are available as part of the 'i' extension. If LLVM's implementation is
updated in the future, a CONFIG_AS_IS_LLVM condition can be added to
CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI.

To resolve the second issue, use version 2.2 of the base ISA spec when
using an older version of clang that does not support zicsr or zifencei
via '-march=', as that is the spec version most compatible with the one
clang/LLVM implements and avoids the need to specify zicsr and zifencei
explicitly due to still being a part of 'i'.

[1]: https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
[2]: https://lore.kernel.org/ZAxT7T9Xy1Fo3d5W@aurel32.net/

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1808
Co-developed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig  |   22 ++++++++++++++++++++++
 arch/riscv/Makefile |   10 ++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -442,6 +442,28 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zihintpause)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23600
 
+config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	def_bool y
+	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
+	depends on AS_IS_GNU && AS_VERSION >= 23800
+	help
+	  Newer binutils versions default to ISA spec version 20191213 which
+	  moves some instructions from the I extension to the Zicsr and Zifencei
+	  extensions.
+
+config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+	def_bool y
+	depends on TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	# https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
+	depends on CC_IS_CLANG && CLANG_VERSION < 170000
+	help
+	  Certain versions of clang do not support zicsr and zifencei via -march
+	  but newer versions of binutils require it for the reasons noted in the
+	  help text of CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI. This
+	  option causes an older ISA spec compatible with these older versions
+	  of clang to be passed to GAS, which has the same result as passing zicsr
+	  and zifencei to -march.
+
 config FPU
 	bool "FPU support"
 	default y
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -57,10 +57,12 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
 
-# Newer binutils versions default to ISA spec version 20191213 which moves some
-# instructions from the I extension to the Zicsr and Zifencei extensions.
-toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
-riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+ifdef CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+KBUILD_CFLAGS += -Wa,-misa-spec=2.2
+KBUILD_AFLAGS += -Wa,-misa-spec=2.2
+else
+riscv-march-$(CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI) := $(riscv-march-y)_zicsr_zifencei
+endif
 
 # Check if the toolchain supports Zicbom extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICBOM) := $(riscv-march-y)_zicbom


