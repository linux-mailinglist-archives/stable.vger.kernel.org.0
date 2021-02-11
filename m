Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0C5318E2F
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBKPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhBKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 725FC64F14;
        Thu, 11 Feb 2021 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055959;
        bh=QJaX+ww6HEM03E1qGVlIdZ3A27656V+IThdNT4DddWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=As3WEn5jKJo0kknfGyZcjTQCjaD4HAhcXtXH6ywdCMRvN3inz9DtRGI7NqbE/5dpC
         5kznjKb8ho0gidbxgcMQu/PPlpo1AAqm7MtzFVsmdSEkxxvtDxanZtNhFmv73yOxLL
         hErrLxPNRi+PpeEMO10SYSVwtNourV1VUNeHnMC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 20/24] bpf: Fix 32 bit src register truncation on div/mod
Date:   Thu, 11 Feb 2021 16:02:43 +0100
Message-Id: <20210211150149.404852871@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit e88b2c6e5a4d9ce30d75391e4d950da74bb2bd90 upstream.

While reviewing a different fix, John and I noticed an oddity in one of the
BPF program dumps that stood out, for example:

  # bpftool p d x i 13
   0: (b7) r0 = 808464450
   1: (b4) w4 = 808464432
   2: (bc) w0 = w0
   3: (15) if r0 == 0x0 goto pc+1
   4: (9c) w4 %= w0
  [...]

In line 2 we noticed that the mov32 would 32 bit truncate the original src
register for the div/mod operation. While for the two operations the dst
register is typically marked unknown e.g. from adjust_scalar_min_max_vals()
the src register is not, and thus verifier keeps tracking original bounds,
simplified:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = -1
  1: R0_w=invP-1 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (b7) r1 = -1
  2: R0_w=invP-1 R1_w=invP-1 R10=fp0
  2: (3c) w0 /= w1
  3: R0_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=invP-1 R10=fp0
  3: (77) r1 >>= 32
  4: R0_w=invP(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R1_w=invP4294967295 R10=fp0
  4: (bf) r0 = r1
  5: R0_w=invP4294967295 R1_w=invP4294967295 R10=fp0
  5: (95) exit
  processed 6 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

Runtime result of r0 at exit is 0 instead of expected -1. Remove the
verifier mov32 src rewrite in div/mod and replace it with a jmp32 test
instead. After the fix, we result in the following code generation when
having dividend r1 and divisor r6:

  div, 64 bit:                             div, 32 bit:

   0: (b7) r6 = 8                           0: (b7) r6 = 8
   1: (b7) r1 = 8                           1: (b7) r1 = 8
   2: (55) if r6 != 0x0 goto pc+2           2: (56) if w6 != 0x0 goto pc+2
   3: (ac) w1 ^= w1                         3: (ac) w1 ^= w1
   4: (05) goto pc+1                        4: (05) goto pc+1
   5: (3f) r1 /= r6                         5: (3c) w1 /= w6
   6: (b7) r0 = 0                           6: (b7) r0 = 0
   7: (95) exit                             7: (95) exit

  mod, 64 bit:                             mod, 32 bit:

   0: (b7) r6 = 8                           0: (b7) r6 = 8
   1: (b7) r1 = 8                           1: (b7) r1 = 8
   2: (15) if r6 == 0x0 goto pc+1           2: (16) if w6 == 0x0 goto pc+1
   3: (9f) r1 %= r6                         3: (9c) w1 %= w6
   4: (b7) r0 = 0                           4: (b7) r0 = 0
   5: (95) exit                             5: (95) exit

x86 in particular can throw a 'divide error' exception for div
instruction not only for divisor being zero, but also for the case
when the quotient is too large for the designated register. For the
edx:eax and rdx:rax dividend pair it is not an issue in x86 BPF JIT
since we always zero edx (rdx). Hence really the only protection
needed is against divisor being zero.

Fixes: 68fda450a7df ("bpf: fix 32-bit divide by zero")
Co-developed-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9002,30 +9002,28 @@ static int fixup_bpf_calls(struct bpf_ve
 		    insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
 		    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
 			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
-			struct bpf_insn mask_and_div[] = {
-				BPF_MOV32_REG(insn->src_reg, insn->src_reg),
+			bool isdiv = BPF_OP(insn->code) == BPF_DIV;
+			struct bpf_insn *patchlet;
+			struct bpf_insn chk_and_div[] = {
 				/* Rx div 0 -> 0 */
-				BPF_JMP_IMM(BPF_JNE, insn->src_reg, 0, 2),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JNE | BPF_K, insn->src_reg,
+					     0, 2, 0),
 				BPF_ALU32_REG(BPF_XOR, insn->dst_reg, insn->dst_reg),
 				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
 				*insn,
 			};
-			struct bpf_insn mask_and_mod[] = {
-				BPF_MOV32_REG(insn->src_reg, insn->src_reg),
+			struct bpf_insn chk_and_mod[] = {
 				/* Rx mod 0 -> Rx */
-				BPF_JMP_IMM(BPF_JEQ, insn->src_reg, 0, 1),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JEQ | BPF_K, insn->src_reg,
+					     0, 1, 0),
 				*insn,
 			};
-			struct bpf_insn *patchlet;
 
-			if (insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
-			    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
-				patchlet = mask_and_div + (is64 ? 1 : 0);
-				cnt = ARRAY_SIZE(mask_and_div) - (is64 ? 1 : 0);
-			} else {
-				patchlet = mask_and_mod + (is64 ? 1 : 0);
-				cnt = ARRAY_SIZE(mask_and_mod) - (is64 ? 1 : 0);
-			}
+			patchlet = isdiv ? chk_and_div : chk_and_mod;
+			cnt = isdiv ? ARRAY_SIZE(chk_and_div) :
+				      ARRAY_SIZE(chk_and_mod);
 
 			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
 			if (!new_prog)


