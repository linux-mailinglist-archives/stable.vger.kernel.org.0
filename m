Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09DB54707C
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 02:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345434AbiFKAUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 20:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242021AbiFKAUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 20:20:31 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F56392
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 17:20:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LKdlH4z01z4xD7;
        Sat, 11 Jun 2022 10:20:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1654906827;
        bh=SbyVkW30XJMxVw2Gk6H9g/s5MXMRghTSIc6MLFUR1gY=;
        h=From:To:Cc:Subject:Date:From;
        b=n+uAf2RbJPJ/SzqJ0PxwrOlnPJDTNW2Oq8f7R4uEdLmYlTEvpCVOkBzzFHEEBZFkv
         P6sTwZWbnGxZ4PY3eUUHvTNgeIqsz0HDbv9wQFBToJK2darfOZ9/R6AkMc/5uh40JV
         qCIpN2UMf0ikPO8EaF/DUdbmJ49mNvhIpaHc70QaJyogz8k78ij1U5tbFQJOHQMnpP
         mqQC7o08UiPspoa8Dp198/js7loMgA8/mBs9Ixsol/dpwluD8e6s078PUu64toF4pm
         0jsbdKIGs/RRDP10ndDcfi96JtaH/RPxtLQwbIGJ61ZxU+0ldCN+snw2dkxGIYqYeI
         kkvD/+oQaDVXQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
Cc:     <sashal@kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v5.15] powerpc/32: Fix overread/overwrite of thread_struct via ptrace
Date:   Sat, 11 Jun 2022 10:20:23 +1000
Message-Id: <20220611002023.935574-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8e1278444446fc97778a5e5c99bca1ce0bbc5ec9 upstream.

The ptrace PEEKUSR/POKEUSR (aka PEEKUSER/POKEUSER) API allows a process
to read/write registers of another process.

To get/set a register, the API takes an index into an imaginary address
space called the "USER area", where the registers of the process are
laid out in some fashion.

The kernel then maps that index to a particular register in its own data
structures and gets/sets the value.

The API only allows a single machine-word to be read/written at a time.
So 4 bytes on 32-bit kernels and 8 bytes on 64-bit kernels.

The way floating point registers (FPRs) are addressed is somewhat
complicated, because double precision float values are 64-bit even on
32-bit CPUs. That means on 32-bit kernels each FPR occupies two
word-sized locations in the USER area. On 64-bit kernels each FPR
occupies one word-sized location in the USER area.

Internally the kernel stores the FPRs in an array of u64s, or if VSX is
enabled, an array of pairs of u64s where one half of each pair stores
the FPR. Which half of the pair stores the FPR depends on the kernel's
endianness.

To handle the different layouts of the FPRs depending on VSX/no-VSX and
big/little endian, the TS_FPR() macro was introduced.

Unfortunately the TS_FPR() macro does not take into account the fact
that the addressing of each FPR differs between 32-bit and 64-bit
kernels. It just takes the index into the "USER area" passed from
userspace and indexes into the fp_state.fpr array.

On 32-bit there are 64 indexes that address FPRs, but only 32 entries in
the fp_state.fpr array, meaning the user can read/write 256 bytes past
the end of the array. Because the fp_state sits in the middle of the
thread_struct there are various fields than can be overwritten,
including some pointers. As such it may be exploitable.

It has also been observed to cause systems to hang or otherwise
misbehave when using gdbserver, and is probably the root cause of this
report which could not be easily reproduced:
  https://lore.kernel.org/linuxppc-dev/dc38afe9-6b78-f3f5-666b-986939e40fc6@keymile.com/

Rather than trying to make the TS_FPR() macro even more complicated to
fix the bug, or add more macros, instead add a special-case for 32-bit
kernels. This is more obvious and hopefully avoids a similar bug
happening again in future.

Note that because 32-bit kernels never have VSX enabled the code doesn't
need to consider TS_FPRWIDTH/OFFSET at all. Add a BUILD_BUG_ON() to
ensure that 32-bit && VSX is never enabled.

Fixes: 87fec0514f61 ("powerpc: PTRACE_PEEKUSR/PTRACE_POKEUSER of FPR registers in little endian builds")
Cc: stable@vger.kernel.org # v3.13+
Reported-by: Ariel Miculas <ariel.miculas@belden.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220609133245.573565-1-mpe@ellerman.id.au
---
 arch/powerpc/kernel/ptrace/ptrace-fpu.c | 20 ++++++++++++++------
 arch/powerpc/kernel/ptrace/ptrace.c     |  3 +++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace/ptrace-fpu.c b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
index 5dca19361316..09c49632bfe5 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-fpu.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
@@ -17,9 +17,13 @@ int ptrace_get_fpr(struct task_struct *child, int index, unsigned long *data)
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			*data = ((u32 *)child->thread.fp_state.fpr)[fpidx];
+		else
+			memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
+	} else
 		*data = child->thread.fp_state.fpscr;
 #else
 	*data = 0;
@@ -39,9 +43,13 @@ int ptrace_put_fpr(struct task_struct *child, int index, unsigned long data)
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			((u32 *)child->thread.fp_state.fpr)[fpidx] = data;
+		else
+			memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
+	} else
 		child->thread.fp_state.fpscr = data;
 #endif
 
diff --git a/arch/powerpc/kernel/ptrace/ptrace.c b/arch/powerpc/kernel/ptrace/ptrace.c
index 7c7093c17c45..ff5e46dbf7c5 100644
--- a/arch/powerpc/kernel/ptrace/ptrace.c
+++ b/arch/powerpc/kernel/ptrace/ptrace.c
@@ -446,4 +446,7 @@ void __init pt_regs_check(void)
 	 * real registers.
 	 */
 	BUILD_BUG_ON(PT_DSCR < sizeof(struct user_pt_regs) / sizeof(unsigned long));
+
+	// ptrace_get/put_fpr() rely on PPC32 and VSX being incompatible
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_PPC32) && IS_ENABLED(CONFIG_VSX));
 }
-- 
2.35.3

