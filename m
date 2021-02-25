Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15615324D4B
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhBYJzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235458AbhBYJya (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:54:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DE864EBA;
        Thu, 25 Feb 2021 09:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246829;
        bh=bM7ssA6s84dYWrlA8DbJqX2URTWuF8Poq3GYV7koc2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/uL7VOatzac0Zf6zrnitcj7+W01CTlFcv0V/dyNsnEO7z1vZSc4Do4pq8YMRWzk6
         xBrkiIkX/mhJBS7aQ2bQ/ifvt2d9XcYptXmP92r2JBNd6asm0vAlTkVgfVFTkJ01ir
         7GEw6qgS3AFWbfr6RI9o6FBx4nLW3xfQjmnm3NH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.11 01/12] bpf: Fix truncation handling for mod32 dst reg wrt zero
Date:   Thu, 25 Feb 2021 10:53:35 +0100
Message-Id: <20210225092515.085865222@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 9b00f1b78809309163dda2d044d9e94a3c0248a3 upstream.

Recently noticed that when mod32 with a known src reg of 0 is performed,
then the dst register is 32-bit truncated in verifier:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = 0
  1: R0_w=inv0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (b7) r1 = -1
  2: R0_w=inv0 R1_w=inv-1 R10=fp0
  2: (b4) w2 = -1
  3: R0_w=inv0 R1_w=inv-1 R2_w=inv4294967295 R10=fp0
  3: (9c) w1 %= w0
  4: R0_w=inv0 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  4: (b7) r0 = 1
  5: R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  5: (1d) if r1 == r2 goto pc+1
   R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  6: R0_w=inv1 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  6: (b7) r0 = 2
  7: R0_w=inv2 R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2_w=inv4294967295 R10=fp0
  7: (95) exit
  7: R0=inv1 R1=inv(id=0,umin_value=4294967295,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R2=inv4294967295 R10=fp0
  7: (95) exit

However, as a runtime result, we get 2 instead of 1, meaning the dst
register does not contain (u32)-1 in this case. The reason is fairly
straight forward given the 0 test leaves the dst register as-is:

  # ./bpftool p d x i 23
   0: (b7) r0 = 0
   1: (b7) r1 = -1
   2: (b4) w2 = -1
   3: (16) if w0 == 0x0 goto pc+1
   4: (9c) w1 %= w0
   5: (b7) r0 = 1
   6: (1d) if r1 == r2 goto pc+1
   7: (b7) r0 = 2
   8: (95) exit

This was originally not an issue given the dst register was marked as
completely unknown (aka 64 bit unknown). However, after 468f6eafa6c4
("bpf: fix 32-bit ALU op verification") the verifier casts the register
output to 32 bit, and hence it becomes 32 bit unknown. Note that for
the case where the src register is unknown, the dst register is marked
64 bit unknown. After the fix, the register is truncated by the runtime
and the test passes:

  # ./bpftool p d x i 23
   0: (b7) r0 = 0
   1: (b7) r1 = -1
   2: (b4) w2 = -1
   3: (16) if w0 == 0x0 goto pc+2
   4: (9c) w1 %= w0
   5: (05) goto pc+1
   6: (bc) w1 = w1
   7: (b7) r0 = 1
   8: (1d) if r1 == r2 goto pc+1
   9: (b7) r0 = 2
  10: (95) exit

Semantics also match with {R,W}x mod{64,32} 0 -> {R,W}x. Invalid div
has always been {R,W}x div{64,32} 0 -> 0. Rewrites are as follows:

  mod32:                            mod64:

  (16) if w0 == 0x0 goto pc+2       (15) if r0 == 0x0 goto pc+1
  (9c) w1 %= w0                     (9f) r1 %= r0
  (05) goto pc+1
  (bc) w1 = w1

Fixes: 468f6eafa6c4 ("bpf: fix 32-bit ALU op verification")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11006,7 +11006,7 @@ static int fixup_bpf_calls(struct bpf_ve
 			bool isdiv = BPF_OP(insn->code) == BPF_DIV;
 			struct bpf_insn *patchlet;
 			struct bpf_insn chk_and_div[] = {
-				/* Rx div 0 -> 0 */
+				/* [R,W]x div 0 -> 0 */
 				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
 					     BPF_JNE | BPF_K, insn->src_reg,
 					     0, 2, 0),
@@ -11015,16 +11015,18 @@ static int fixup_bpf_calls(struct bpf_ve
 				*insn,
 			};
 			struct bpf_insn chk_and_mod[] = {
-				/* Rx mod 0 -> Rx */
+				/* [R,W]x mod 0 -> [R,W]x */
 				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
 					     BPF_JEQ | BPF_K, insn->src_reg,
-					     0, 1, 0),
+					     0, 1 + (is64 ? 0 : 1), 0),
 				*insn,
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				BPF_MOV32_REG(insn->dst_reg, insn->dst_reg),
 			};
 
 			patchlet = isdiv ? chk_and_div : chk_and_mod;
 			cnt = isdiv ? ARRAY_SIZE(chk_and_div) :
-				      ARRAY_SIZE(chk_and_mod);
+				      ARRAY_SIZE(chk_and_mod) - (is64 ? 2 : 0);
 
 			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
 			if (!new_prog)


