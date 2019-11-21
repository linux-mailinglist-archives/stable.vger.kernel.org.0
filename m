Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37451104CD7
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKUHqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:46:23 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:42530 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfKUHqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 02:46:22 -0500
Received: by mail-pj1-f66.google.com with SMTP id y21so1082612pjn.9;
        Wed, 20 Nov 2019 23:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kW0Dz4V+ee0qrFX4ScjboJErsd+VrXqYtO0YunlLbfg=;
        b=SYRYAzQxQqPeS1LlADkUBOlXTMc6UIKnaFqoKDwU1ZwLAEw9hx3lMFWdkt9DmUuq8v
         oeCHBpM2Sb/JQgdhD+FPK2P3GKIZlAYwZWTYdGyN2wD7DL8XCAAXvNaGCw6xLe8JF5Nf
         M6J9xIcE3fDh4Ea0lMKO2q7gS/4cpP+Fkph5rn1GjAX16E59yj0wfat1lTh6S5UXKgUE
         C1yQoRon9cmEFo5G+sh60RI4eoDT0eu/aUXtUH3QbDK/7xq18/xnluFD4QioXQEbXMx9
         im7/uibMlHD4G6ppHTB7+s7vDruyjPBhlivVFN3cOuxxOJYGVmdUcWQYRL4PdlZRQvSq
         NxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kW0Dz4V+ee0qrFX4ScjboJErsd+VrXqYtO0YunlLbfg=;
        b=F8sdqtMnHJlKI4xCE39FRhbAdTR3QZwOtcHOWv/aYuAoyg3gyD/HljHxwqZp7x4TAu
         X+woKS93t6ad6ncXoS49tW5c3Pa6DcxvpswtLUpey4hZXZYmHom1EAGTdBZluZqAnCaP
         zkZZEGhPS1YnEVnoNmS16O9rAIScNussi+RvR+6oq8Lan/40wKZ8Soe1COqfPVtXCnJV
         HfrB58y3gkbfvpJb+N4JuXhTAOvgQ3aArbs/F5qqhiwYZdBeSX2N/E6Ujw92d5p73hRS
         6JZ6CpF1m92NwlRR24PqrgYQH2LpSR6MJDVNG2WHHUue0F2GZnt0TCLbZPLghxBuJUsM
         5/4g==
X-Gm-Message-State: APjAAAWLXc1tLZNr9bIc8CYnivc+oOIqhYKg4/9MBL/ljUC43QSCC8hw
        2awa8Uk2P5twCEwMB97OsgE=
X-Google-Smtp-Source: APXvYqzGVAVmAJPNl9+1BONXt6bl6zIfKHZrvIMSTo8mD2DCWM6fRo24/PZgMsWr71bZSXcCiC1xHA==
X-Received: by 2002:a17:902:7c0e:: with SMTP id x14mr7337469pll.277.1574322381079;
        Wed, 20 Nov 2019 23:46:21 -0800 (PST)
Received: from udknight.localhost ([183.250.89.86])
        by smtp.gmail.com with ESMTPSA id 67sm1770973pjz.27.2019.11.20.23.46.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 23:46:20 -0800 (PST)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id xAL7hcDw015411;
        Thu, 21 Nov 2019 15:43:38 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id xAL7haKr015409;
        Thu, 21 Nov 2019 15:43:36 +0800
Date:   Thu, 21 Nov 2019 15:43:36 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, daniel@iogearbox.net, itugrok@yahoo.com,
        bpf@vger.kernel.org
Subject: [PATCH] bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE,
 BPF_JSLT, BPF_JSGE}
Message-ID: <20191121074336.GA15326@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

This patch fixes the bug.

Note:
The original commit adds a testcase in selftests/bpf for such bug, this
backport patch doesn't include the testcase, because the testcase needs
another upstream commit.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205469
Reported-by: Tony Ambardar <itugrok@yahoo.com>
Cc: Tony Ambardar <itugrok@yahoo.com>
Cc: stable@vger.kernel.org #v4.19
Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 arch/x86/net/bpf_jit_comp32.c | 221 ++++++++++++++++++++++++++--------
 1 file changed, 168 insertions(+), 53 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 8f6cc71e0848..85f1f11a45bf 100644
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
@@ -1613,6 +1615,75 @@ static inline void emit_push_r64(const u8 src[], u8 **pprog)
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
@@ -2068,11 +2139,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
@@ -2099,6 +2166,40 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
@@ -2159,11 +2260,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
@@ -2189,50 +2286,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
@@ -2242,7 +2298,66 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
+
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
-- 
2.17.1
