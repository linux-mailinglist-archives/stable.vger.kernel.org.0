Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5545CAD8
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGBIIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbfGBIIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3611B21852;
        Tue,  2 Jul 2019 08:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054916;
        bh=bepyEuJ7VKt5PlHukT07zZ7vkKBfY4wW8MJPJyShlrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOvtFWdDUQzt5QHppyw56EddBqmHR3nR5F7qQ31cu8MwdvHtMgGjS4DmmF86ezdH1
         aEEc25Uv1PZYC/uhMMjGDXy67xvjKI6YAtWjDqL5HTvseXLY980+WINqQroBt2kjiU
         PrAmkVA2FqYv58J6s+T+7HK4+mNBv8WwJQ6wb+Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 69/72] bpf, arm64: use more scalable stadd over ldxr / stxr loop in xadd
Date:   Tue,  2 Jul 2019 10:02:10 +0200
Message-Id: <20190702080128.224128183@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 34b8ab091f9ef57a2bb3c8c8359a0a03a8abf2f9 upstream.

Since ARMv8.1 supplement introduced LSE atomic instructions back in 2016,
lets add support for STADD and use that in favor of LDXR / STXR loop for
the XADD mapping if available. STADD is encoded as an alias for LDADD with
XZR as the destination register, therefore add LDADD to the instruction
encoder along with STADD as special case and use it in the JIT for CPUs
that advertise LSE atomics in CPUID register. If immediate offset in the
BPF XADD insn is 0, then use dst register directly instead of temporary
one.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/insn.h |    8 ++++++++
 arch/arm64/kernel/insn.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/net/bpf_jit.h      |    4 ++++
 arch/arm64/net/bpf_jit_comp.c |   28 +++++++++++++++++++---------
 4 files changed, 71 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -272,6 +272,7 @@ __AARCH64_INSN_FUNCS(adrp,	0x9F000000, 0
 __AARCH64_INSN_FUNCS(prfm,	0x3FC00000, 0x39800000)
 __AARCH64_INSN_FUNCS(prfm_lit,	0xFF000000, 0xD8000000)
 __AARCH64_INSN_FUNCS(str_reg,	0x3FE0EC00, 0x38206800)
+__AARCH64_INSN_FUNCS(ldadd,	0x3F20FC00, 0xB8200000)
 __AARCH64_INSN_FUNCS(ldr_reg,	0x3FE0EC00, 0x38606800)
 __AARCH64_INSN_FUNCS(ldr_lit,	0xBF000000, 0x18000000)
 __AARCH64_INSN_FUNCS(ldrsw_lit,	0xFF000000, 0x98000000)
@@ -389,6 +390,13 @@ u32 aarch64_insn_gen_load_store_ex(enum
 				   enum aarch64_insn_register state,
 				   enum aarch64_insn_size_type size,
 				   enum aarch64_insn_ldst_type type);
+u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
+			   enum aarch64_insn_register address,
+			   enum aarch64_insn_register value,
+			   enum aarch64_insn_size_type size);
+u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
+			   enum aarch64_insn_register value,
+			   enum aarch64_insn_size_type size);
 u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
 				 enum aarch64_insn_register src,
 				 int imm, enum aarch64_insn_variant variant,
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -734,6 +734,46 @@ u32 aarch64_insn_gen_load_store_ex(enum
 					    state);
 }
 
+u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
+			   enum aarch64_insn_register address,
+			   enum aarch64_insn_register value,
+			   enum aarch64_insn_size_type size)
+{
+	u32 insn = aarch64_insn_get_ldadd_value();
+
+	switch (size) {
+	case AARCH64_INSN_SIZE_32:
+	case AARCH64_INSN_SIZE_64:
+		break;
+	default:
+		pr_err("%s: unimplemented size encoding %d\n", __func__, size);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn = aarch64_insn_encode_ldst_size(size, insn);
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RT, insn,
+					    result);
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn,
+					    address);
+
+	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RS, insn,
+					    value);
+}
+
+u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
+			   enum aarch64_insn_register value,
+			   enum aarch64_insn_size_type size)
+{
+	/*
+	 * STADD is simply encoded as an alias for LDADD with XZR as
+	 * the destination register.
+	 */
+	return aarch64_insn_gen_ldadd(AARCH64_INSN_REG_ZR, address,
+				      value, size);
+}
+
 static u32 aarch64_insn_encode_prfm_imm(enum aarch64_insn_prfm_type type,
 					enum aarch64_insn_prfm_target target,
 					enum aarch64_insn_prfm_policy policy,
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -100,6 +100,10 @@
 #define A64_STXR(sf, Rt, Rn, Rs) \
 	A64_LSX(sf, Rt, Rn, Rs, STORE_EX)
 
+/* LSE atomics */
+#define A64_STADD(sf, Rn, Rs) \
+	aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
+
 /* Add/subtract (immediate) */
 #define A64_ADDSUB_IMM(sf, Rd, Rn, imm12, type) \
 	aarch64_insn_gen_add_sub_imm(Rd, Rn, imm12, \
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -364,7 +364,7 @@ static int build_insn(const struct bpf_i
 	const int i = insn - ctx->prog->insnsi;
 	const bool is64 = BPF_CLASS(code) == BPF_ALU64;
 	const bool isdw = BPF_SIZE(code) == BPF_DW;
-	u8 jmp_cond;
+	u8 jmp_cond, reg;
 	s32 jmp_offset;
 
 #define check_imm(bits, imm) do {				\
@@ -730,18 +730,28 @@ emit_cond_jmp:
 			break;
 		}
 		break;
+
 	/* STX XADD: lock *(u32 *)(dst + off) += src */
 	case BPF_STX | BPF_XADD | BPF_W:
 	/* STX XADD: lock *(u64 *)(dst + off) += src */
 	case BPF_STX | BPF_XADD | BPF_DW:
-		emit_a64_mov_i(1, tmp, off, ctx);
-		emit(A64_ADD(1, tmp, tmp, dst), ctx);
-		emit(A64_LDXR(isdw, tmp2, tmp), ctx);
-		emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
-		emit(A64_STXR(isdw, tmp2, tmp, tmp3), ctx);
-		jmp_offset = -3;
-		check_imm19(jmp_offset);
-		emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+		if (!off) {
+			reg = dst;
+		} else {
+			emit_a64_mov_i(1, tmp, off, ctx);
+			emit(A64_ADD(1, tmp, tmp, dst), ctx);
+			reg = tmp;
+		}
+		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS)) {
+			emit(A64_STADD(isdw, reg, src), ctx);
+		} else {
+			emit(A64_LDXR(isdw, tmp2, reg), ctx);
+			emit(A64_ADD(isdw, tmp2, tmp2, src), ctx);
+			emit(A64_STXR(isdw, tmp2, reg, tmp3), ctx);
+			jmp_offset = -3;
+			check_imm19(jmp_offset);
+			emit(A64_CBNZ(0, tmp3, jmp_offset), ctx);
+		}
 		break;
 
 	default:


