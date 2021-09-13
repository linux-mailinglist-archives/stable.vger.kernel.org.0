Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC99E408DC9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbhIMNaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241807AbhIMNZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E506F6124E;
        Mon, 13 Sep 2021 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539345;
        bh=19f5p6usOD8tLFTyhjlvjeWKolLSWKRRZJ709tl8+pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwt57yWjrSl6RUcEDM8pyfekFkeJIZC889FXLepajZgbeGo3vRH7jgb5a+rJDaht4
         lMUcVa9w7OUmTJwb2gu2DJhwXzWeAkTUDl/e4yANUCtJHmMmLvcNcx8RTgFk2r7XF0
         c9bAfko72LkmFfKziqBe/e4uVzfGl94dzldvOvXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 127/144] bpf: Introduce BPF nospec instruction for mitigating Spectre v4
Date:   Mon, 13 Sep 2021 15:15:08 +0200
Message-Id: <20210913131052.174783641@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit f5e81d1117501546b7be050c5fbafa6efd2c722c upstream.

In case of JITs, each of the JIT backends compiles the BPF nospec instruction
/either/ to a machine instruction which emits a speculation barrier /or/ to
/no/ machine instruction in case the underlying architecture is not affected
by Speculative Store Bypass or has different mitigations in place already.

This covers both x86 and (implicitly) arm64: In case of x86, we use 'lfence'
instruction for mitigation. In case of arm64, we rely on the firmware mitigation
as controlled via the ssbd kernel parameter. Whenever the mitigation is enabled,
it works for all of the kernel code with no need to provide any additional
instructions here (hence only comment in arm64 JIT). Other archs can follow
as needed. The BPF nospec instruction is specifically targeting Spectre v4
since i) we don't use a serialization barrier for the Spectre v1 case, and
ii) mitigation instructions for v1 and v4 might be different on some archs.

The BPF nospec is required for a future commit, where the BPF verifier does
annotate intermediate BPF programs with speculation barriers.

Co-developed-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Benedict Schlueter <benedict.schlueter@rub.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[OP: - adjusted context for 5.4
     - apply riscv changes to /arch/riscv/net/bpf_jit_comp.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/net/bpf_jit_32.c         |    3 +++
 arch/arm64/net/bpf_jit_comp.c     |   13 +++++++++++++
 arch/mips/net/ebpf_jit.c          |    3 +++
 arch/powerpc/net/bpf_jit_comp64.c |    6 ++++++
 arch/riscv/net/bpf_jit_comp.c     |    4 ++++
 arch/s390/net/bpf_jit_comp.c      |    5 +++++
 arch/sparc/net/bpf_jit_comp_64.c  |    3 +++
 arch/x86/net/bpf_jit_comp.c       |    7 +++++++
 arch/x86/net/bpf_jit_comp32.c     |    6 ++++++
 include/linux/filter.h            |   15 +++++++++++++++
 kernel/bpf/core.c                 |   18 +++++++++++++++++-
 kernel/bpf/disasm.c               |   16 +++++++++-------
 12 files changed, 91 insertions(+), 8 deletions(-)

--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1602,6 +1602,9 @@ exit:
 		rn = arm_bpf_get_reg32(src_lo, tmp2[1], ctx);
 		emit_ldx_r(dst, rn, off, ctx, BPF_SIZE(code));
 		break;
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -701,6 +701,19 @@ emit_cond_jmp:
 		}
 		break;
 
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		/*
+		 * Nothing required here.
+		 *
+		 * In case of arm64, we rely on the firmware mitigation of
+		 * Speculative Store Bypass as controlled via the ssbd kernel
+		 * parameter. Whenever the mitigation is enabled, it works
+		 * for all of the kernel code with no need to provide any
+		 * additional instructions.
+		 */
+		break;
+
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1355,6 +1355,9 @@ jeq_common:
 		}
 		break;
 
+	case BPF_ST | BPF_NOSPEC: /* speculation barrier */
+		break;
+
 	case BPF_ST | BPF_B | BPF_MEM:
 	case BPF_ST | BPF_H | BPF_MEM:
 	case BPF_ST | BPF_W | BPF_MEM:
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -645,6 +645,12 @@ emit_clear:
 			break;
 
 		/*
+		 * BPF_ST NOSPEC (speculation barrier)
+		 */
+		case BPF_ST | BPF_NOSPEC:
+			break;
+
+		/*
 		 * BPF_ST(X)
 		 */
 		case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src */
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -1313,6 +1313,10 @@ out_be:
 		emit(rv_ld(rd, 0, RV_REG_T1), ctx);
 		break;
 
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
+
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_B:
 		emit_imm(RV_REG_T1, imm, ctx);
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -914,6 +914,11 @@ static noinline int bpf_jit_insn(struct
 		}
 		break;
 	/*
+	 * BPF_NOSPEC (speculation barrier)
+	 */
+	case BPF_ST | BPF_NOSPEC:
+		break;
+	/*
 	 * BPF_ST(X)
 	 */
 	case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src_reg */
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1287,6 +1287,9 @@ static int build_insn(const struct bpf_i
 			return 1;
 		break;
 	}
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -728,6 +728,13 @@ static int do_jit(struct bpf_prog *bpf_p
 			}
 			break;
 
+			/* speculation barrier */
+		case BPF_ST | BPF_NOSPEC:
+			if (boot_cpu_has(X86_FEATURE_XMM2))
+				/* Emit 'lfence' */
+				EMIT3(0x0F, 0xAE, 0xE8);
+			break;
+
 			/* ST: *(u8*)(dst_reg + off) = imm */
 		case BPF_ST | BPF_MEM | BPF_B:
 			if (is_ereg(dst_reg))
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1705,6 +1705,12 @@ static int do_jit(struct bpf_prog *bpf_p
 			i++;
 			break;
 		}
+		/* speculation barrier */
+		case BPF_ST | BPF_NOSPEC:
+			if (boot_cpu_has(X86_FEATURE_XMM2))
+				/* Emit 'lfence' */
+				EMIT3(0x0F, 0xAE, 0xE8);
+			break;
 		/* ST: *(u8*)(dst_reg + off) = imm */
 		case BPF_ST | BPF_MEM | BPF_H:
 		case BPF_ST | BPF_MEM | BPF_B:
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -68,6 +68,11 @@ struct ctl_table_header;
 /* unused opcode to mark call to interpreter with arguments */
 #define BPF_CALL_ARGS	0xe0
 
+/* unused opcode to mark speculation barrier for mitigating
+ * Speculative Store Bypass
+ */
+#define BPF_NOSPEC	0xc0
+
 /* As per nm, we expose JITed images as text (code) section for
  * kallsyms. That way, tools like perf can find it to match
  * addresses.
@@ -366,6 +371,16 @@ static inline bool insn_is_zext(const st
 		.dst_reg = 0,					\
 		.src_reg = 0,					\
 		.off   = 0,					\
+		.imm   = 0 })
+
+/* Speculation barrier */
+
+#define BPF_ST_NOSPEC()						\
+	((struct bpf_insn) {					\
+		.code  = BPF_ST | BPF_NOSPEC,			\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
 		.imm   = 0 })
 
 /* Internal classic blocks for direct assignment */
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -31,6 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
 
+#include <asm/barrier.h>
 #include <asm/unaligned.h>
 
 /* Registers */
@@ -1310,6 +1311,7 @@ static u64 ___bpf_prog_run(u64 *regs, co
 		/* Non-UAPI available opcodes. */
 		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
 		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
+		[BPF_ST  | BPF_NOSPEC] = &&ST_NOSPEC,
 	};
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
@@ -1550,7 +1552,21 @@ out:
 	COND_JMP(s, JSGE, >=)
 	COND_JMP(s, JSLE, <=)
 #undef COND_JMP
-	/* STX and ST and LDX*/
+	/* ST, STX and LDX*/
+	ST_NOSPEC:
+		/* Speculation barrier for mitigating Speculative Store Bypass.
+		 * In case of arm64, we rely on the firmware mitigation as
+		 * controlled via the ssbd kernel parameter. Whenever the
+		 * mitigation is enabled, it works for all of the kernel code
+		 * with no need to provide any additional instructions here.
+		 * In case of x86, we use 'lfence' insn for mitigation. We
+		 * reuse preexisting logic from Spectre v1 mitigation that
+		 * happens to produce the required code on x86 for v4 as well.
+		 */
+#ifdef CONFIG_X86
+		barrier_nospec();
+#endif
+		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
 		*(SIZE *)(unsigned long) (DST + insn->off) = SRC;	\
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -162,15 +162,17 @@ void print_bpf_insn(const struct bpf_ins
 		else
 			verbose(cbs->private_data, "BUG_%02x\n", insn->code);
 	} else if (class == BPF_ST) {
-		if (BPF_MODE(insn->code) != BPF_MEM) {
+		if (BPF_MODE(insn->code) == BPF_MEM) {
+			verbose(cbs->private_data, "(%02x) *(%s *)(r%d %+d) = %d\n",
+				insn->code,
+				bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
+				insn->dst_reg,
+				insn->off, insn->imm);
+		} else if (BPF_MODE(insn->code) == 0xc0 /* BPF_NOSPEC, no UAPI */) {
+			verbose(cbs->private_data, "(%02x) nospec\n", insn->code);
+		} else {
 			verbose(cbs->private_data, "BUG_st_%02x\n", insn->code);
-			return;
 		}
-		verbose(cbs->private_data, "(%02x) *(%s *)(r%d %+d) = %d\n",
-			insn->code,
-			bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
-			insn->dst_reg,
-			insn->off, insn->imm);
 	} else if (class == BPF_LDX) {
 		if (BPF_MODE(insn->code) != BPF_MEM) {
 			verbose(cbs->private_data, "BUG_ldx_%02x\n", insn->code);


