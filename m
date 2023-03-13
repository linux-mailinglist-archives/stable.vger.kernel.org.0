Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DAA6B85CC
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 00:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCMXCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 19:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCMXBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 19:01:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041A3769ED;
        Mon, 13 Mar 2023 16:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E05A5B815FC;
        Mon, 13 Mar 2023 23:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B3C433EF;
        Mon, 13 Mar 2023 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748448;
        bh=JCeQvBY6bMqovbU34cXbJ4Zgnocr52q58fWGR8Okslg=;
        h=From:Date:Subject:To:Cc:From;
        b=db8ONJnU3rzg0GkiT8U7ITxd6f/Pcpenykg1Q3Gh7uOGiQUfuKf+uowPWc92kRciM
         XClRrybnkrciyd9wLhE/RVuTmdPSSpoo7sk4Uu7cFGrpVokmkJWJOy7Hrynp5WTs1A
         tKssWkWDmsSGhK3ZFN2v3EDos4Sx/zcxpYCOHTvciNdA1uUZhLXT8xgvToT2/9EtRR
         eyHRXwwGypRwKKEKNAucW0swKGz8yjRYkcN5tV3YiY7srhFlfRiL7r9aGbsW3iv4AB
         bOT+ASwBhst36EDe6ab+VBcGUZgESIgn8UzP1gnHdQMCaarY5lvCF/UM1LOA2QscI7
         IAT03dPN/YTGw==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Mon, 13 Mar 2023 16:00:23 -0700
Subject: [PATCH] riscv: Handle zicsr/zifencei issues between clang and
 binutils
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAarD2QC/x2NQQrDMAwEvxJ0riC2A6X9SulBVuRGhzpFKiE05
 O91clkYFmY2cDEVh3u3gcmirnNtEC4d8ET1JahjY4h9TH0KCU2dF/wpu7UtUlkUi5LzjPE2BCb
 Jch0ZmiGTC2ajytPheJN/xY7jY1J0PbOP577/AX8nSeKGAAAA
To:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, conor.dooley@microchip.com
Cc:     nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6797; i=nathan@kernel.org;
 h=from:subject:message-id; bh=JCeQvBY6bMqovbU34cXbJ4Zgnocr52q58fWGR8Okslg=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCn8q+W/p6yaqjirarFIdECezW+de4YNOQ0aynImBz++m
 sKzSO9uRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhI53xGhu3M74vyHI/Vdh0N
 Fnbm+HaSU2tO389nYWqvr3sy9NQrrWFkaFCeGvwou9z2E8P1nR6KSVdWnPwXds6/6nW4bNjJte0
 XWQE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
This is essentially a v3 of Conor's v1 and v2 but since I am sending the
patch after finding a separate but related issue, I left it at v1:

- v1: https://lore.kernel.org/20230223220546.52879-1-conor@kernel.org/
- v2: https://lore.kernel.org/20230308220842.1231003-1-conor@kernel.org/

I have built allmodconfig with the following toolchain combinations to
confirm this problem is resolved:

- clang 12/17 + GNU as and ld 2.35/2.39
- clang 12/17 with the integrated assembler + GNU ld 2.35/2.39
- clang 12/17 with the integrated assembler + ld.lld

There are a couple of other incompatibilities between clang-17 and GNU
binutils that I had to patch to get allmodconfig to build successfully
but those are less likely to be hit in practice because the full LLVM
stack can be used with LLVM versions 13.x and newer. I will follow up
with separate issues and patches.
---
 arch/riscv/Kconfig  | 22 ++++++++++++++++++++++
 arch/riscv/Makefile | 10 ++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c5e42cc37604..5b182d1c196c 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -464,6 +464,28 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
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
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 4de83b9b1772..b05e833a022d 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -57,10 +57,12 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
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
 
 # Check if the toolchain supports Zihintpause extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause

---
base-commit: eeac8ede17557680855031c6f305ece2378af326
change-id: 20230313-riscv-zicsr-zifencei-fiasco-2941caebe7dc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

