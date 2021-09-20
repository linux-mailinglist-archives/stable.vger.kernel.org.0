Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975FC411FC4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353536AbhITRpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349043AbhITRnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA957617E2;
        Mon, 20 Sep 2021 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157757;
        bh=dOi3B5GTO/4/L+8Rzny4NP7semEhOsXe+eYl+rBloYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTOTKZglXBlEwh6+UsHYSqtwldyULCA/NMOPCkMo6pK3aLNZjjc6YUj0n08GE19Rd
         0p1rhEjVoHuos9FlGB1AupREvVpLQDnhLDcmBbA6O7c+41Op+c3a+U1ePvqP7lMfEl
         z1oYUPXY+MMposzWu0PkK5evuU7gMnxEkwYMlggY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        Benedict Schlueter <benedict.schlueter@rub.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 136/293] bpf: Introduce BPF nospec instruction for mitigating Spectre v4
Date:   Mon, 20 Sep 2021 18:41:38 +0200
Message-Id: <20210920163937.943372030@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
[OP: adjusted context for 4.19, drop riscv and ppc32 changes]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/net/bpf_jit_32.c         |    3 +++
 arch/arm64/net/bpf_jit_comp.c     |   13 +++++++++++++
 arch/mips/net/ebpf_jit.c          |    3 +++
 arch/powerpc/net/bpf_jit_comp64.c |    6 ++++++
 arch/s390/net/bpf_jit_comp.c      |    5 +++++
 arch/sparc/net/bpf_jit_comp_64.c  |    3 +++
 arch/x86/net/bpf_jit_comp.c       |    7 +++++++
 arch/x86/net/bpf_jit_comp32.c     |    6 ++++++
 include/linux/filter.h            |   15 +++++++++++++++
 kernel/bpf/core.c                 |   18 +++++++++++++++++-
 kernel/bpf/disasm.c               |   16 +++++++++-------
 11 files changed, 87 insertions(+), 8 deletions(-)

--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1578,6 +1578,9 @@ exit:
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
@@ -685,6 +685,19 @@ emit_cond_jmp:
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
@@ -1282,6 +1282,9 @@ jeq_common:
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
@@ -597,6 +597,12 @@ emit_clear:
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
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -884,6 +884,11 @@ static noinline int bpf_jit_insn(struct
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
@@ -1261,6 +1261,9 @@ static int build_insn(const struct bpf_i
 		emit(opcode | RS1(src) | rs2 | RD(dst), ctx);
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
@@ -731,6 +731,13 @@ static int do_jit(struct bpf_prog *bpf_p
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
@@ -1683,6 +1683,12 @@ static int do_jit(struct bpf_prog *bpf_p
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
@@ -64,6 +64,11 @@ struct sock_reuseport;
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
@@ -352,6 +357,16 @@ struct sock_reuseport;
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
@@ -33,6 +33,7 @@
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
 
+#include <asm/barrier.h>
 #include <asm/unaligned.h>
 
 /* Registers */
@@ -1050,6 +1051,7 @@ static u64 ___bpf_prog_run(u64 *regs, co
 		/* Non-UAPI available opcodes. */
 		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
 		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
+		[BPF_ST  | BPF_NOSPEC] = &&ST_NOSPEC,
 	};
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
@@ -1356,7 +1358,21 @@ out:
 	JMP_EXIT:
 		return BPF_R0;
 
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
@@ -171,15 +171,17 @@ void print_bpf_insn(const struct bpf_ins
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


