Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E2F6B14CA
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 23:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCHWJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 17:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHWJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 17:09:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3942885379
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 14:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8291B81E0F
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 22:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27065C433EF;
        Wed,  8 Mar 2023 22:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678313361;
        bh=YjvsP3xGIY/OBQAOjH6ILlUgFSWUuguf/wwQlB08/I4=;
        h=From:To:Cc:Subject:Date:From;
        b=iIKyrvh24Sp1q+rzGLGhUtShBlWpH4yKtakn0yah+KrhBBVigUXGzDno4kYge1FLJ
         oc6J5smYtnYDkK4Rh4F/pwUW+iavBWLfvIHzfuQFjg2flhoQ9bAWEV5TXru/KhVUpV
         /nBBEDttzm+4WwDEX60wy2InRENdg5hDPggfjrMAavQd6tPJMLQBm+9MViorK3p6Fz
         DFGM+0FziPJgD2Rdtp3SUjvWowVsTjMSnLlkAc4gWT4D++xz24fgSuDvqnSTv7jocc
         m0eYCZgiI71B5YewaWPz1D6YkpTdIZ0sqXmaU5ksCU83o6kD0XXSkaUNpE4Vl0krNv
         bs7IgLI5B7d5A==
From:   Conor Dooley <conor@kernel.org>
To:     palmer@dabbelt.com
Cc:     conor@kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, nathan@kernel.org,
        naresh.kamboju@linaro.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, aurelien@aurel32.net,
        ndesaulniers@google.com, Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Date:   Wed,  8 Mar 2023 22:08:43 +0000
Message-Id: <20230308220842.1231003-1-conor@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5181; i=conor.dooley@microchip.com; h=from:subject; bh=e8x5OC9RRLdlP4Bz9tlTw5oReRU3raEf7fvxO+/8Qqc=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDCmc7JkT3F6dDJv+KJ9VbMrZ2wITfxak7d+kki7OoP/we fBJawadjlIWBjEOBlkxRZbE230tUuv/uOxw7nkLM4eVCWQIAxenAEzk1HxGhjel8gVrmv8p/j1z pWhlp6tqiQ+/R+Fxi+u1qf7iDqF7FzEynMkMSfzrK+Eu7dZh/579XUjUi4l5Jya98KuV9u55dcm JGQA=
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

The spec folk, in their infinite wisdom, moved both control and status
registers & the FENCE.I instructions out of the I extension into their
own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
spec [0].
The GCC/binutils crew decided [1] to move their default version of the
ISA spec to the 20191213 version of the ISA spec, which came into being
for version 2.38 of binutils and GCC 12. Building with this toolchain
configuration would result in assembler issues:
  CC      arch/riscv/kernel/vdso/vgettimeofday.o
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binutils
2.38") by Aurelien Jarno, but has proven fragile.

Before LLVM 17, LLVM did not support these extensions and, as such, the
cc-option check added by Aurelien worked. Since commit 22e199e6afb1
("[RISCV] Accept zicsr and zifencei command line options") however, LLVM
*does* support them and the cc-option check passes.

This surfaced as a problem while building the 5.10 stable kernel using
the default Tuxmake Debian image [2], as 5.10 did not yet support ld.lld,
and uses the Debian provided binutils 2.35.
Versions of ld prior to 2.38 will refuse to link if they encounter
unknown ISA extensions, and unfortunately Zifencei is not supported by
bintuils 2.35.

Instead of dancing around with adding these extensions to march, as we
currently do, Palmer suggested locking GCC builds to the same version of
the ISA spec that is used by LLVM. As far as I can tell, that is 2.2,
with, apparently [3], a lack of interest in implementing a flag like
GCC's -misa-spec at present.

Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS when
GCC is used & remove the march dance.

As clang does not accept this argument, I had expected to encounter
issues with the assembler, as neither zicsr nor zifencei are present in
the ISA string and the spec version *should* be defaulting to a version
that requires them to be present. The build passed however and the
resulting kernel worked perfectly fine for me on a PolarFire SoC...

Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf [0]
Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1ZeHHCYf4 [1]
Link: https://lore.kernel.org/all/CA+G9fYt9T=ELCLaB9byxaLW2Qf4pZcDO=huCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-version-misa-spec-gcc-flag-equivalent/66935 [3]
CC: stable@vger.kernel.org
Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
I think Aurelien's original commit message might actually not be quite
correct? I found, in my limited testing, that it is not the default
behaviour of gas that matters, but rather the toolchain itself?
My binutils versions (both those built using the clang-built-linux
tc-build scripts which do not set an ISA spec version, and one built
using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec version
set) do not encounter these issues.
From *my* testing, I was only able to reproduce the above build failures
because of *GCC* defaulting to a newer ISA spec version, and saw no
issues with CC=clang builds, where -misa-spec is not (AFAICT) passed to
gas.
I'm far from a toolchain person, so I am very very happy to have the
reason for that explained to me, as I've been scratching my head about
it all evening.

I'm also not super confident in my "as-option"ing, but it worked for me,
so it's gotta be perfect, right? riiight??

Changes from v1:
- entirely new approach to the issue
---
 arch/riscv/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 6203c3378922..2df7a5dc071c 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -57,10 +57,8 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
 
-# Newer binutils versions default to ISA spec version 20191213 which moves some
-# instructions from the I extension to the Zicsr and Zifencei extensions.
-toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
-riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+KBUILD_CFLAGS += $(call cc-option,-misa-spec=2.2)
+KBUILD_AFLAGS += $(call as-option,-Wa$(comma)-misa-spec=2.2)
 
 # Check if the toolchain supports Zihintpause extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
-- 
2.39.2

