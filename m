Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6239F47AFBE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbhLTPSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238269AbhLTPRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:17:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363ADC08EA37;
        Mon, 20 Dec 2021 06:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E26611D6;
        Mon, 20 Dec 2021 14:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA74C36AE7;
        Mon, 20 Dec 2021 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012315;
        bh=E4OaptgJo2cUz2drVHW3xg2rLF2KHxOol991At3mhSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkqC525uBIOg6tsZVOvJeFuagqaJtXPQOfKFH0fbmUIlM5Tme+bL2NN6aIdACpmcN
         vUEspfoONCpfCObhFcSuJiEjIxT7IbS1yOcInlI8F6IvpmVKVm6mhP8RpXONA7QirQ
         wK7U73g5ut9RmlS/79c/qhxcQeOOjTr5dz8nJg7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Meng <jmeng@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.15 157/177] bpf, x64: Factor out emission of REX byte in more cases
Date:   Mon, 20 Dec 2021 15:35:07 +0100
Message-Id: <20211220143045.362148358@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Meng <jmeng@fb.com>

commit 6364d7d75a0e015a405d1f8a07f267f076c36ca6 upstream.

Introduce a single reg version of maybe_emit_mod() and factor out
common code in more cases.

Signed-off-by: Jie Meng <jmeng@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20211006194135.608932-1-jmeng@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |   50 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -721,6 +721,20 @@ static void maybe_emit_mod(u8 **pprog, u
 	*pprog = prog;
 }
 
+/*
+ * Similar version of maybe_emit_mod() for a single register
+ */
+static void maybe_emit_1mod(u8 **pprog, u32 reg, bool is64)
+{
+	u8 *prog = *pprog;
+
+	if (is64)
+		EMIT1(add_1mod(0x48, reg));
+	else if (is_ereg(reg))
+		EMIT1(add_1mod(0x40, reg));
+	*pprog = prog;
+}
+
 /* LDX: dst_reg = *(u8*)(src_reg + off) */
 static void emit_ldx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 {
@@ -951,10 +965,8 @@ static int do_jit(struct bpf_prog *bpf_p
 			/* neg dst */
 		case BPF_ALU | BPF_NEG:
 		case BPF_ALU64 | BPF_NEG:
-			if (BPF_CLASS(insn->code) == BPF_ALU64)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_ALU64);
 			EMIT2(0xF7, add_1reg(0xD8, dst_reg));
 			break;
 
@@ -968,10 +980,8 @@ static int do_jit(struct bpf_prog *bpf_p
 		case BPF_ALU64 | BPF_AND | BPF_K:
 		case BPF_ALU64 | BPF_OR | BPF_K:
 		case BPF_ALU64 | BPF_XOR | BPF_K:
-			if (BPF_CLASS(insn->code) == BPF_ALU64)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_ALU64);
 
 			/*
 			 * b3 holds 'normal' opcode, b2 short form only valid
@@ -1112,10 +1122,8 @@ static int do_jit(struct bpf_prog *bpf_p
 		case BPF_ALU64 | BPF_LSH | BPF_K:
 		case BPF_ALU64 | BPF_RSH | BPF_K:
 		case BPF_ALU64 | BPF_ARSH | BPF_K:
-			if (BPF_CLASS(insn->code) == BPF_ALU64)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_ALU64);
 
 			b3 = simple_alu_opcodes[BPF_OP(insn->code)];
 			if (imm32 == 1)
@@ -1146,10 +1154,8 @@ static int do_jit(struct bpf_prog *bpf_p
 			}
 
 			/* shl %rax, %cl | shr %rax, %cl | sar %rax, %cl */
-			if (BPF_CLASS(insn->code) == BPF_ALU64)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_ALU64);
 
 			b3 = simple_alu_opcodes[BPF_OP(insn->code)];
 			EMIT2(0xD3, add_1reg(b3, dst_reg));
@@ -1459,10 +1465,8 @@ st:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_JSET | BPF_K:
 		case BPF_JMP32 | BPF_JSET | BPF_K:
 			/* test dst_reg, imm32 */
-			if (BPF_CLASS(insn->code) == BPF_JMP)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_JMP);
 			EMIT2_off32(0xF7, add_1reg(0xC0, dst_reg), imm32);
 			goto emit_cond_jmp;
 
@@ -1495,10 +1499,8 @@ st:			if (is_imm8(insn->off))
 			}
 
 			/* cmp dst_reg, imm8/32 */
-			if (BPF_CLASS(insn->code) == BPF_JMP)
-				EMIT1(add_1mod(0x48, dst_reg));
-			else if (is_ereg(dst_reg))
-				EMIT1(add_1mod(0x40, dst_reg));
+			maybe_emit_1mod(&prog, dst_reg,
+					BPF_CLASS(insn->code) == BPF_JMP);
 
 			if (is_imm8(imm32))
 				EMIT3(0x83, add_1reg(0xF8, dst_reg), imm32);


