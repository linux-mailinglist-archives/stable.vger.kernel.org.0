Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F3D428F6B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhJKN6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237380AbhJKN4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D94761100;
        Mon, 11 Oct 2021 13:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960413;
        bh=NS9LfDd6rwPe/bYgnHEpp/+ziDyP1MFKsMFrr8R572M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baHA4eOtG+9LWZ2JwJBc9xp1S526iLMnE3e70jkNfqhtZRqxsxESXY40mAjZZEIQv
         OHZhFPJOFlVAf+aumeo/Pf7J+1CJAP6SN0wtc/vvMrpGLwZtQmjZEZstMLeJr2x+bs
         hekjXBT6+bdw7XLHgRSrIeutPnKq/c5MwpsDE84k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/83] bpf, arm: Fix register clobbering in div/mod implementation
Date:   Mon, 11 Oct 2021 15:45:55 +0200
Message-Id: <20211011134509.592252683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 79e3445b38e0cab94264a3894c0c3d57c930b97e ]

On ARM CPUs that lack div/mod instructions, ALU32 BPF_DIV and BPF_MOD are
implemented using a call to a helper function. Before, the emitted code
for those function calls failed to preserve caller-saved ARM registers.
Since some of those registers happen to be mapped to BPF registers, it
resulted in eBPF register values being overwritten.

This patch emits code to push and pop the remaining caller-saved ARM
registers r2-r3 into the stack during the div/mod function call. ARM
registers r0-r1 are used as arguments and return value, and those were
already saved and restored correctly.

Fixes: 39c13c204bb1 ("arm: eBPF JIT compiler")
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/net/bpf_jit_32.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index ce8b04326352..1214e39aad5e 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -36,6 +36,10 @@
  *                        +-----+
  *                        |RSVD | JIT scratchpad
  * current ARM_SP =>      +-----+ <= (BPF_FP - STACK_SIZE + SCRATCH_SIZE)
+ *                        | ... | caller-saved registers
+ *                        +-----+
+ *                        | ... | arguments passed on stack
+ * ARM_SP during call =>  +-----|
  *                        |     |
  *                        | ... | Function call stack
  *                        |     |
@@ -63,6 +67,12 @@
  *
  * When popping registers off the stack at the end of a BPF function, we
  * reference them via the current ARM_FP register.
+ *
+ * Some eBPF operations are implemented via a call to a helper function.
+ * Such calls are "invisible" in the eBPF code, so it is up to the calling
+ * program to preserve any caller-saved ARM registers during the call. The
+ * JIT emits code to push and pop those registers onto the stack, immediately
+ * above the callee stack frame.
  */
 #define CALLEE_MASK	(1 << ARM_R4 | 1 << ARM_R5 | 1 << ARM_R6 | \
 			 1 << ARM_R7 | 1 << ARM_R8 | 1 << ARM_R9 | \
@@ -70,6 +80,8 @@
 #define CALLEE_PUSH_MASK (CALLEE_MASK | 1 << ARM_LR)
 #define CALLEE_POP_MASK  (CALLEE_MASK | 1 << ARM_PC)
 
+#define CALLER_MASK	(1 << ARM_R0 | 1 << ARM_R1 | 1 << ARM_R2 | 1 << ARM_R3)
+
 enum {
 	/* Stack layout - these are offsets from (top of stack - 4) */
 	BPF_R2_HI,
@@ -464,6 +476,7 @@ static inline int epilogue_offset(const struct jit_ctx *ctx)
 
 static inline void emit_udivmod(u8 rd, u8 rm, u8 rn, struct jit_ctx *ctx, u8 op)
 {
+	const int exclude_mask = BIT(ARM_R0) | BIT(ARM_R1);
 	const s8 *tmp = bpf2a32[TMP_REG_1];
 
 #if __LINUX_ARM_ARCH__ == 7
@@ -495,11 +508,17 @@ static inline void emit_udivmod(u8 rd, u8 rm, u8 rn, struct jit_ctx *ctx, u8 op)
 		emit(ARM_MOV_R(ARM_R0, rm), ctx);
 	}
 
+	/* Push caller-saved registers on stack */
+	emit(ARM_PUSH(CALLER_MASK & ~exclude_mask), ctx);
+
 	/* Call appropriate function */
 	emit_mov_i(ARM_IP, op == BPF_DIV ?
 		   (u32)jit_udiv32 : (u32)jit_mod32, ctx);
 	emit_blx_r(ARM_IP, ctx);
 
+	/* Restore caller-saved registers from stack */
+	emit(ARM_POP(CALLER_MASK & ~exclude_mask), ctx);
+
 	/* Save return value */
 	if (rd != ARM_R0)
 		emit(ARM_MOV_R(rd, ARM_R0), ctx);
-- 
2.33.0



