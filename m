Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9DF4525BC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359037AbhKPB5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240199AbhKOSO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:14:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D50AE633D5;
        Mon, 15 Nov 2021 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998557;
        bh=EZNXlae5JyPkpMtrTQq0EXsUxTU8AvvMCg9nrsBZC2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tB/p6KSoVdK0cgihDKV5kxiP/8iI49rno9sz0gdiDF/sI8U1pt1lFIyfNCqHuX9Pt
         wgLb54HyvV3g3GvhXiNCGwG9u420jmVWFife+/C04GLMu5WfXNQ2ywl4SPtOO7wiOq
         ZkNw44oGurKu3Eg8BBLcvkELinWSk6JoWc/9o1Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 553/575] powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC
Date:   Mon, 15 Nov 2021 18:04:38 +0100
Message-Id: <20211115165402.812455497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

upstream commit b7540d62509453263604a155bf2d5f0ed450cba2

Emit similar instruction sequences to commit a048a07d7f4535
("powerpc/64s: Add support for a store forwarding barrier at kernel
entry/exit") when encountering BPF_NOSPEC.

Mitigations are enabled depending on what the firmware advertises. In
particular, we do not gate these mitigations based on current settings,
just like in x86. Due to this, we don't need to take any action if
mitigations are enabled or disabled at runtime.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/956570cbc191cd41f8274bed48ee757a86dac62a.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
[adjust macros to account for commits 1c9debbc2eb539 and ef909ba954145e.
adjust security feature checks to account for commit 84ed26fd00c514]
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit64.h      |    8 ++---
 arch/powerpc/net/bpf_jit_comp64.c |   56 +++++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 8 deletions(-)

--- a/arch/powerpc/net/bpf_jit64.h
+++ b/arch/powerpc/net/bpf_jit64.h
@@ -16,18 +16,18 @@
  * with our redzone usage.
  *
  *		[	prev sp		] <-------------
- *		[   nv gpr save area	] 6*8		|
+ *		[   nv gpr save area	] 5*8		|
  *		[    tail_call_cnt	] 8		|
- *		[    local_tmp_var	] 8		|
+ *		[    local_tmp_var	] 16		|
  * fp (r31) -->	[   ebpf stack space	] upto 512	|
  *		[     frame header	] 32/112	|
  * sp (r1) --->	[    stack pointer	] --------------
  */
 
 /* for gpr non volatile registers BPG_REG_6 to 10 */
-#define BPF_PPC_STACK_SAVE	(6*8)
+#define BPF_PPC_STACK_SAVE	(5*8)
 /* for bpf JIT code internal usage */
-#define BPF_PPC_STACK_LOCALS	16
+#define BPF_PPC_STACK_LOCALS	24
 /* stack frame excluding BPF stack, ensure this is quadword aligned */
 #define BPF_PPC_STACKFRAME	(STACK_FRAME_MIN_SIZE + \
 				 BPF_PPC_STACK_LOCALS + BPF_PPC_STACK_SAVE)
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -15,6 +15,7 @@
 #include <linux/if_vlan.h>
 #include <asm/kprobes.h>
 #include <linux/bpf.h>
+#include <asm/security_features.h>
 
 #include "bpf_jit64.h"
 
@@ -56,9 +57,9 @@ static inline bool bpf_has_stack_frame(s
  *		[	prev sp		] <-------------
  *		[	  ...       	] 		|
  * sp (r1) --->	[    stack pointer	] --------------
- *		[   nv gpr save area	] 6*8
+ *		[   nv gpr save area	] 5*8
  *		[    tail_call_cnt	] 8
- *		[    local_tmp_var	] 8
+ *		[    local_tmp_var	] 16
  *		[   unused red zone	] 208 bytes protected
  */
 static int bpf_jit_stack_local(struct codegen_context *ctx)
@@ -66,12 +67,12 @@ static int bpf_jit_stack_local(struct co
 	if (bpf_has_stack_frame(ctx))
 		return STACK_FRAME_MIN_SIZE + ctx->stack_size;
 	else
-		return -(BPF_PPC_STACK_SAVE + 16);
+		return -(BPF_PPC_STACK_SAVE + 24);
 }
 
 static int bpf_jit_stack_tailcallcnt(struct codegen_context *ctx)
 {
-	return bpf_jit_stack_local(ctx) + 8;
+	return bpf_jit_stack_local(ctx) + 16;
 }
 
 static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
@@ -290,11 +291,34 @@ static int bpf_jit_emit_tail_call(u32 *i
 	return 0;
 }
 
+/*
+ * We spill into the redzone always, even if the bpf program has its own stackframe.
+ * Offsets hardcoded based on BPF_PPC_STACK_SAVE -- see bpf_jit_stack_local()
+ */
+void bpf_stf_barrier(void);
+
+asm (
+"		.global bpf_stf_barrier		;"
+"	bpf_stf_barrier:			;"
+"		std	21,-64(1)		;"
+"		std	22,-56(1)		;"
+"		sync				;"
+"		ld	21,-64(1)		;"
+"		ld	22,-56(1)		;"
+"		ori	31,31,0			;"
+"		.rept 14			;"
+"		b	1f			;"
+"	1:					;"
+"		.endr				;"
+"		blr				;"
+);
+
 /* Assemble the body code between the prologue & epilogue */
 static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			      struct codegen_context *ctx,
 			      u32 *addrs, bool extra_pass)
 {
+	enum stf_barrier_type stf_barrier = stf_barrier_type_get();
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
 	int i, ret;
@@ -665,6 +689,30 @@ emit_clear:
 		 * BPF_ST NOSPEC (speculation barrier)
 		 */
 		case BPF_ST | BPF_NOSPEC:
+			if (!security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) ||
+					(!security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR) &&
+					 (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) || !cpu_has_feature(CPU_FTR_HVMODE))))
+				break;
+
+			switch (stf_barrier) {
+			case STF_BARRIER_EIEIO:
+				EMIT(0x7c0006ac | 0x02000000);
+				break;
+			case STF_BARRIER_SYNC_ORI:
+				EMIT(PPC_INST_SYNC);
+				EMIT(PPC_RAW_LD(b2p[TMP_REG_1], 13, 0));
+				EMIT(PPC_RAW_ORI(31, 31, 0));
+				break;
+			case STF_BARRIER_FALLBACK:
+				EMIT(PPC_INST_MFLR | ___PPC_RT(b2p[TMP_REG_1]));
+				PPC_LI64(12, dereference_kernel_function_descriptor(bpf_stf_barrier));
+				EMIT(PPC_RAW_MTCTR(12));
+				EMIT(PPC_INST_BCTR | 0x1);
+				EMIT(PPC_RAW_MTLR(b2p[TMP_REG_1]));
+				break;
+			case STF_BARRIER_NONE:
+				break;
+			}
 			break;
 
 		/*


