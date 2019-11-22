Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92E106CE4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfKVK4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbfKVK4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B1092071F;
        Fri, 22 Nov 2019 10:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420159;
        bh=tHgi9Wp14BgK4UBirussamIO0BKZDp50/pt2pgUw9xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O30dMMRxPwCxn7ngqWWZzNPCBjRU0QxI3lPTdzGod8d7+5JA7m9RnYxGuoD5eFWdU
         vlW/Am2xvqdFQS0UsTdiPywHnoNHroPjWgX6Cox0KFTusraExLl0LVCY63JaW+hGDF
         fLGCXt1b8F/agHwpd9aQvUPeFsttE8zOdFsamka8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <itugrok@yahoo.com>,
        Wang YanQing <udknight@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 014/220] bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE, BPF_JSLT, BPF_JSGE}
Date:   Fri, 22 Nov 2019 11:26:19 +0100
Message-Id: <20191122100913.621561877@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

commit 711aef1bbf88212a21f7103e88f397b47a528805 upstream.

The current method to compare 64-bit numbers for conditional jump is:

1) Compare the high 32-bit first.

2) If the high 32-bit isn't the same, then goto step 4.

3) Compare the low 32-bit.

4) Check the desired condition.

This method is right for unsigned comparison, but it is buggy for signed
comparison, because it does signed comparison for low 32-bit too.

There is only one sign bit in 64-bit number, that is the MSB in the 64-bit
number, it is wrong to treat low 32-bit as signed number and do the signed
comparison for it.

This patch fixes the bug and adds a testcase in selftests/bpf for such bug.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205469
Reported-by: Tony Ambardar <itugrok@yahoo.com>
Cc: Tony Ambardar <itugrok@yahoo.com>
Cc: stable@vger.kernel.org #v4.19
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |  221 +++++++++++++++++++++++++++++++-----------
 1 file changed, 168 insertions(+), 53 deletions(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -117,6 +117,8 @@ static bool is_simm32(s64 value)
 #define IA32_JLE 0x7E
 #define IA32_JG  0x7F
 
+#define COND_JMP_OPCODE_INVALID	(0xFF)
+
 /*
  * Map eBPF registers to IA32 32bit registers or stack scratch space.
  *
@@ -1380,6 +1382,75 @@ static inline void emit_push_r64(const u
 	*pprog = prog;
 }
 
+static u8 get_cond_jmp_opcode(const u8 op, bool is_cmp_lo)
+{
+	u8 jmp_cond;
+
+	/* Convert BPF opcode to x86 */
+	switch (op) {
+	case BPF_JEQ:
+		jmp_cond = IA32_JE;
+		break;
+	case BPF_JSET:
+	case BPF_JNE:
+		jmp_cond = IA32_JNE;
+		break;
+	case BPF_JGT:
+		/* GT is unsigned '>', JA in x86 */
+		jmp_cond = IA32_JA;
+		break;
+	case BPF_JLT:
+		/* LT is unsigned '<', JB in x86 */
+		jmp_cond = IA32_JB;
+		break;
+	case BPF_JGE:
+		/* GE is unsigned '>=', JAE in x86 */
+		jmp_cond = IA32_JAE;
+		break;
+	case BPF_JLE:
+		/* LE is unsigned '<=', JBE in x86 */
+		jmp_cond = IA32_JBE;
+		break;
+	case BPF_JSGT:
+		if (!is_cmp_lo)
+			/* Signed '>', GT in x86 */
+			jmp_cond = IA32_JG;
+		else
+			/* GT is unsigned '>', JA in x86 */
+			jmp_cond = IA32_JA;
+		break;
+	case BPF_JSLT:
+		if (!is_cmp_lo)
+			/* Signed '<', LT in x86 */
+			jmp_cond = IA32_JL;
+		else
+			/* LT is unsigned '<', JB in x86 */
+			jmp_cond = IA32_JB;
+		break;
+	case BPF_JSGE:
+		if (!is_cmp_lo)
+			/* Signed '>=', GE in x86 */
+			jmp_cond = IA32_JGE;
+		else
+			/* GE is unsigned '>=', JAE in x86 */
+			jmp_cond = IA32_JAE;
+		break;
+	case BPF_JSLE:
+		if (!is_cmp_lo)
+			/* Signed '<=', LE in x86 */
+			jmp_cond = IA32_JLE;
+		else
+			/* LE is unsigned '<=', JBE in x86 */
+			jmp_cond = IA32_JBE;
+		break;
+	default: /* to silence GCC warning */
+		jmp_cond = COND_JMP_OPCODE_INVALID;
+		break;
+	}
+
+	return jmp_cond;
+}
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		  int oldproglen, struct jit_context *ctx)
 {
@@ -1835,11 +1906,7 @@ static int do_jit(struct bpf_prog *bpf_p
 		case BPF_JMP | BPF_JGT | BPF_X:
 		case BPF_JMP | BPF_JLT | BPF_X:
 		case BPF_JMP | BPF_JGE | BPF_X:
-		case BPF_JMP | BPF_JLE | BPF_X:
-		case BPF_JMP | BPF_JSGT | BPF_X:
-		case BPF_JMP | BPF_JSLE | BPF_X:
-		case BPF_JMP | BPF_JSLT | BPF_X:
-		case BPF_JMP | BPF_JSGE | BPF_X: {
+		case BPF_JMP | BPF_JLE | BPF_X: {
 			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
 			u8 sreg_lo = sstk ? IA32_ECX : src_lo;
@@ -1866,6 +1933,40 @@ static int do_jit(struct bpf_prog *bpf_p
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
 			goto emit_cond_jmp;
 		}
+		case BPF_JMP | BPF_JSGT | BPF_X:
+		case BPF_JMP | BPF_JSLE | BPF_X:
+		case BPF_JMP | BPF_JSLT | BPF_X:
+		case BPF_JMP | BPF_JSGE | BPF_X: {
+			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
+			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 sreg_lo = sstk ? IA32_ECX : src_lo;
+			u8 sreg_hi = sstk ? IA32_EBX : src_hi;
+
+			if (dstk) {
+				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EAX),
+				      STACK_VAR(dst_lo));
+				EMIT3(0x8B,
+				      add_2reg(0x40, IA32_EBP,
+					       IA32_EDX),
+				      STACK_VAR(dst_hi));
+			}
+
+			if (sstk) {
+				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_ECX),
+				      STACK_VAR(src_lo));
+				EMIT3(0x8B,
+				      add_2reg(0x40, IA32_EBP,
+					       IA32_EBX),
+				      STACK_VAR(src_hi));
+			}
+
+			/* cmp dreg_hi,sreg_hi */
+			EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
+			EMIT2(IA32_JNE, 10);
+			/* cmp dreg_lo,sreg_lo */
+			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
+			goto emit_cond_jmp_signed;
+		}
 		case BPF_JMP | BPF_JSET | BPF_X: {
 			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
@@ -1926,11 +2027,7 @@ static int do_jit(struct bpf_prog *bpf_p
 		case BPF_JMP | BPF_JGT | BPF_K:
 		case BPF_JMP | BPF_JLT | BPF_K:
 		case BPF_JMP | BPF_JGE | BPF_K:
-		case BPF_JMP | BPF_JLE | BPF_K:
-		case BPF_JMP | BPF_JSGT | BPF_K:
-		case BPF_JMP | BPF_JSLE | BPF_K:
-		case BPF_JMP | BPF_JSLT | BPF_K:
-		case BPF_JMP | BPF_JSGE | BPF_K: {
+		case BPF_JMP | BPF_JLE | BPF_K: {
 			u32 hi;
 			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
 			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
@@ -1956,50 +2053,9 @@ static int do_jit(struct bpf_prog *bpf_p
 			/* cmp dreg_lo,sreg_lo */
 			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
 
-emit_cond_jmp:		/* Convert BPF opcode to x86 */
-			switch (BPF_OP(code)) {
-			case BPF_JEQ:
-				jmp_cond = IA32_JE;
-				break;
-			case BPF_JSET:
-			case BPF_JNE:
-				jmp_cond = IA32_JNE;
-				break;
-			case BPF_JGT:
-				/* GT is unsigned '>', JA in x86 */
-				jmp_cond = IA32_JA;
-				break;
-			case BPF_JLT:
-				/* LT is unsigned '<', JB in x86 */
-				jmp_cond = IA32_JB;
-				break;
-			case BPF_JGE:
-				/* GE is unsigned '>=', JAE in x86 */
-				jmp_cond = IA32_JAE;
-				break;
-			case BPF_JLE:
-				/* LE is unsigned '<=', JBE in x86 */
-				jmp_cond = IA32_JBE;
-				break;
-			case BPF_JSGT:
-				/* Signed '>', GT in x86 */
-				jmp_cond = IA32_JG;
-				break;
-			case BPF_JSLT:
-				/* Signed '<', LT in x86 */
-				jmp_cond = IA32_JL;
-				break;
-			case BPF_JSGE:
-				/* Signed '>=', GE in x86 */
-				jmp_cond = IA32_JGE;
-				break;
-			case BPF_JSLE:
-				/* Signed '<=', LE in x86 */
-				jmp_cond = IA32_JLE;
-				break;
-			default: /* to silence GCC warning */
+emit_cond_jmp:		jmp_cond = get_cond_jmp_opcode(BPF_OP(code), false);
+			if (jmp_cond == COND_JMP_OPCODE_INVALID)
 				return -EFAULT;
-			}
 			jmp_offset = addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
 				EMIT2(jmp_cond, jmp_offset);
@@ -2009,7 +2065,66 @@ emit_cond_jmp:		/* Convert BPF opcode to
 				pr_err("cond_jmp gen bug %llx\n", jmp_offset);
 				return -EFAULT;
 			}
+			break;
+		}
+		case BPF_JMP | BPF_JSGT | BPF_K:
+		case BPF_JMP | BPF_JSLE | BPF_K:
+		case BPF_JMP | BPF_JSLT | BPF_K:
+		case BPF_JMP | BPF_JSGE | BPF_K: {
+			u8 dreg_lo = dstk ? IA32_EAX : dst_lo;
+			u8 dreg_hi = dstk ? IA32_EDX : dst_hi;
+			u8 sreg_lo = IA32_ECX;
+			u8 sreg_hi = IA32_EBX;
+			u32 hi;
+
+			if (dstk) {
+				EMIT3(0x8B, add_2reg(0x40, IA32_EBP, IA32_EAX),
+				      STACK_VAR(dst_lo));
+				EMIT3(0x8B,
+				      add_2reg(0x40, IA32_EBP,
+					       IA32_EDX),
+				      STACK_VAR(dst_hi));
+			}
+
+			/* mov ecx,imm32 */
+			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_ECX), imm32);
+			hi = imm32 & (1 << 31) ? (u32)~0 : 0;
+			/* mov ebx,imm32 */
+			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_EBX), hi);
+			/* cmp dreg_hi,sreg_hi */
+			EMIT2(0x39, add_2reg(0xC0, dreg_hi, sreg_hi));
+			EMIT2(IA32_JNE, 10);
+			/* cmp dreg_lo,sreg_lo */
+			EMIT2(0x39, add_2reg(0xC0, dreg_lo, sreg_lo));
+
+			/*
+			 * For simplicity of branch offset computation,
+			 * let's use fixed jump coding here.
+			 */
+emit_cond_jmp_signed:	/* Check the condition for low 32-bit comparison */
+			jmp_cond = get_cond_jmp_opcode(BPF_OP(code), true);
+			if (jmp_cond == COND_JMP_OPCODE_INVALID)
+				return -EFAULT;
+			jmp_offset = addrs[i + insn->off] - addrs[i] + 8;
+			if (is_simm32(jmp_offset)) {
+				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
+			} else {
+				pr_err("cond_jmp gen bug %llx\n", jmp_offset);
+				return -EFAULT;
+			}
+			EMIT2(0xEB, 6);
 
+			/* Check the condition for high 32-bit comparison */
+			jmp_cond = get_cond_jmp_opcode(BPF_OP(code), false);
+			if (jmp_cond == COND_JMP_OPCODE_INVALID)
+				return -EFAULT;
+			jmp_offset = addrs[i + insn->off] - addrs[i];
+			if (is_simm32(jmp_offset)) {
+				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
+			} else {
+				pr_err("cond_jmp gen bug %llx\n", jmp_offset);
+				return -EFAULT;
+			}
 			break;
 		}
 		case BPF_JMP | BPF_JA:


