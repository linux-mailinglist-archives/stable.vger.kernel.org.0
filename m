Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446A9C1853
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfI2Rcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729879AbfI2Rcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC0721906;
        Sun, 29 Sep 2019 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778373;
        bh=f+mN/3SNEj0pxynAHt+FW+QiIG9PflCFqhGEbsaoz64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KsgokMWXk478jaYwmGOF3ULvRUukawPz85QB49SIjbIaerVn2myFGMqoyhIOxHTZ
         ogchGnGE1wjgMk3drAMJ+dXfGlLZIDaLaY80zppxkuoUvDSlmzcMkUUn+6ggFeZ03A
         nPqg5Bf64C8OloJsnqYQeLBKLdUmkR/yhevtbCbM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 03/42] MIPS: Don't use bc_false uninitialized in __mm_isBranchInstr
Date:   Sun, 29 Sep 2019 13:32:02 -0400
Message-Id: <20190929173244.8918-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173244.8918-1-sashal@kernel.org>
References: <20190929173244.8918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit c2869aafe7191d366d74c55cb8a93c6d0baba317 ]

clang warns:

arch/mips/kernel/branch.c:148:8: error: variable 'bc_false' is used
uninitialized whenever switch case is taken
[-Werror,-Wsometimes-uninitialized]
                case mm_bc2t_op:
                     ^~~~~~~~~~
arch/mips/kernel/branch.c:157:8: note: uninitialized use occurs here
                        if (bc_false)
                            ^~~~~~~~
arch/mips/kernel/branch.c:149:8: error: variable 'bc_false' is used
uninitialized whenever switch case is taken
[-Werror,-Wsometimes-uninitialized]
                case mm_bc1t_op:
                     ^~~~~~~~~~
arch/mips/kernel/branch.c:157:8: note: uninitialized use occurs here
                        if (bc_false)
                            ^~~~~~~~
arch/mips/kernel/branch.c:142:4: note: variable 'bc_false' is declared
here
                        int bc_false = 0;
                        ^
2 errors generated.

When mm_bc1t_op and mm_bc2t_op are taken, the bc_false initialization
does not happen, which leads to a garbage value upon use, as illustrated
below with a small sample program.

$ mipsel-linux-gnu-gcc --version | head -n1
mipsel-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

$ clang --version | head -n1
ClangBuiltLinux clang version 9.0.0 (git://github.com/llvm/llvm-project
544315b4197034a3be8acd12cba56a75fb1f08dc) (based on LLVM 9.0.0svn)

$ cat test.c
 #include <stdio.h>

 static void switch_scoped(int opcode)
 {
	 switch (opcode) {
	 case 1:
	 case 2: {
		 int bc_false = 0;

		 bc_false = 4;
	 case 3:
	 case 4:
		 printf("\t* switch scoped bc_false = %d\n", bc_false);
	 }
	 }
 }

 static void function_scoped(int opcode)
 {
	 int bc_false = 0;

	 switch (opcode) {
	 case 1:
	 case 2: {
		 bc_false = 4;
	 case 3:
	 case 4:
		 printf("\t* function scoped bc_false = %d\n", bc_false);
	 }
	 }
 }

 int main(void)
 {
	 int opcode;

	 for (opcode = 1; opcode < 5; opcode++) {
		 printf("opcode = %d:\n", opcode);
		 switch_scoped(opcode);
		 function_scoped(opcode);
		 printf("\n");
	 }

	 return 0;
 }

$ mipsel-linux-gnu-gcc -std=gnu89 -static test.c && \
  qemu-mipsel a.out
opcode = 1:
        * switch scoped bc_false = 4
        * function scoped bc_false = 4

opcode = 2:
        * switch scoped bc_false = 4
        * function scoped bc_false = 4

opcode = 3:
        * switch scoped bc_false = 2147483004
        * function scoped bc_false = 0

opcode = 4:
        * switch scoped bc_false = 2147483004
        * function scoped bc_false = 0

$ clang -std=gnu89 --target=mipsel-linux-gnu -m32 -static test.c && \
  qemu-mipsel a.out
opcode = 1:
        * switch scoped bc_false = 4
        * function scoped bc_false = 4

opcode = 2:
        * switch scoped bc_false = 4
        * function scoped bc_false = 4

opcode = 3:
        * switch scoped bc_false = 2147483004
        * function scoped bc_false = 0

opcode = 4:
        * switch scoped bc_false = 2147483004
        * function scoped bc_false = 0

Move the definition up so that we get the right behavior and mark it
__maybe_unused as it will not be used when CONFIG_MIPS_FP_SUPPORT
isn't enabled.

Fixes: 6a1cc218b9cc ("MIPS: branch: Remove FP branch handling when CONFIG_MIPS_FP_SUPPORT=n")
Link: https://github.com/ClangBuiltLinux/linux/issues/603
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/branch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/branch.c b/arch/mips/kernel/branch.c
index 180ad081afcf9..c2d88c1dcc0f8 100644
--- a/arch/mips/kernel/branch.c
+++ b/arch/mips/kernel/branch.c
@@ -58,6 +58,7 @@ int __mm_isBranchInstr(struct pt_regs *regs, struct mm_decoded_insn dec_insn,
 		       unsigned long *contpc)
 {
 	union mips_instruction insn = (union mips_instruction)dec_insn.insn;
+	int __maybe_unused bc_false = 0;
 
 	if (!cpu_has_mmips)
 		return 0;
@@ -139,7 +140,6 @@ int __mm_isBranchInstr(struct pt_regs *regs, struct mm_decoded_insn dec_insn,
 #ifdef CONFIG_MIPS_FP_SUPPORT
 		case mm_bc2f_op:
 		case mm_bc1f_op: {
-			int bc_false = 0;
 			unsigned int fcr31;
 			unsigned int bit;
 
-- 
2.20.1

