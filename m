Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8953E12C881
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbfL2Rzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732948AbfL2Rzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FEA222C3;
        Sun, 29 Dec 2019 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642136;
        bh=oxyRD9qgZnYVLj6ygz7d18ZCJ4L6stRCzg9ScMZ5rSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be0/wnbAQznyquE/A5Qak1CO72cIMI6YVg4DabJXWzRUv6NRh2BZQ65n50hc0MaIB
         Zw1Y8did/Elj1szrqr+sPaqGohGdEObN9qdCrgKB/w9usmzmXSUQ2haX7EKLVe06eR
         MFwLQ4oY10mbydI1gI6dz4nv3aqFLyc3lpolhJAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 356/434] bpf: Provide better register bounds after jmp32 instructions
Date:   Sun, 29 Dec 2019 18:26:49 +0100
Message-Id: <20191229172725.617663779@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 581738a681b6faae5725c2555439189ca81c0f1f ]

With latest llvm (trunk https://github.com/llvm/llvm-project),
test_progs, which has +alu32 enabled, failed for strobemeta.o.
The verifier output looks like below with edit to replace large
decimal numbers with hex ones.
 193: (85) call bpf_probe_read_user_str#114
   R0=inv(id=0)
 194: (26) if w0 > 0x1 goto pc+4
   R0_w=inv(id=0,umax_value=0xffffffff00000001)
 195: (6b) *(u16 *)(r7 +80) = r0
 196: (bc) w6 = w0
   R6_w=inv(id=0,umax_value=0xffffffff,var_off=(0x0; 0xffffffff))
 197: (67) r6 <<= 32
   R6_w=inv(id=0,smax_value=0x7fffffff00000000,umax_value=0xffffffff00000000,
            var_off=(0x0; 0xffffffff00000000))
 198: (77) r6 >>= 32
   R6=inv(id=0,umax_value=0xffffffff,var_off=(0x0; 0xffffffff))
 ...
 201: (79) r8 = *(u64 *)(r10 -416)
   R8_w=map_value(id=0,off=40,ks=4,vs=13872,imm=0)
 202: (0f) r8 += r6
   R8_w=map_value(id=0,off=40,ks=4,vs=13872,umax_value=0xffffffff,var_off=(0x0; 0xffffffff))
 203: (07) r8 += 9696
   R8_w=map_value(id=0,off=9736,ks=4,vs=13872,umax_value=0xffffffff,var_off=(0x0; 0xffffffff))
 ...
 255: (bf) r1 = r8
   R1_w=map_value(id=0,off=9736,ks=4,vs=13872,umax_value=0xffffffff,var_off=(0x0; 0xffffffff))
 ...
 257: (85) call bpf_probe_read_user_str#114
 R1 unbounded memory access, make sure to bounds check any array access into a map

The value range for register r6 at insn 198 should be really just 0/1.
The umax_value=0xffffffff caused later verification failure.

After jmp instructions, the current verifier already tried to use just
obtained information to get better register range. The current mechanism is
for 64bit register only. This patch implemented to tighten the range
for 32bit sub-registers after jmp32 instructions.
With the patch, we have the below range ranges for the
above code sequence:
 193: (85) call bpf_probe_read_user_str#114
   R0=inv(id=0)
 194: (26) if w0 > 0x1 goto pc+4
   R0_w=inv(id=0,smax_value=0x7fffffff00000001,umax_value=0xffffffff00000001,
            var_off=(0x0; 0xffffffff00000001))
 195: (6b) *(u16 *)(r7 +80) = r0
 196: (bc) w6 = w0
   R6_w=inv(id=0,umax_value=0xffffffff,var_off=(0x0; 0x1))
 197: (67) r6 <<= 32
   R6_w=inv(id=0,umax_value=0x100000000,var_off=(0x0; 0x100000000))
 198: (77) r6 >>= 32
   R6=inv(id=0,umax_value=1,var_off=(0x0; 0x1))
 ...
 201: (79) r8 = *(u64 *)(r10 -416)
   R8_w=map_value(id=0,off=40,ks=4,vs=13872,imm=0)
 202: (0f) r8 += r6
   R8_w=map_value(id=0,off=40,ks=4,vs=13872,umax_value=1,var_off=(0x0; 0x1))
 203: (07) r8 += 9696
   R8_w=map_value(id=0,off=9736,ks=4,vs=13872,umax_value=1,var_off=(0x0; 0x1))
 ...
 255: (bf) r1 = r8
   R1_w=map_value(id=0,off=9736,ks=4,vs=13872,umax_value=1,var_off=(0x0; 0x1))
 ...
 257: (85) call bpf_probe_read_user_str#114
 ...

At insn 194, the register R0 has better var_off.mask and smax_value.
Especially, the var_off.mask ensures later lshift and rshift
maintains proper value range.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191121170650.449030-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ffc3e53f5300..9e7cee5307e0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -978,6 +978,17 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
 						 reg->umax_value));
 }
 
+static void __reg_bound_offset32(struct bpf_reg_state *reg)
+{
+	u64 mask = 0xffffFFFF;
+	struct tnum range = tnum_range(reg->umin_value & mask,
+				       reg->umax_value & mask);
+	struct tnum lo32 = tnum_cast(reg->var_off, 4);
+	struct tnum hi32 = tnum_lshift(tnum_rshift(reg->var_off, 32), 32);
+
+	reg->var_off = tnum_or(hi32, tnum_intersect(lo32, range));
+}
+
 /* Reset the min/max bounds of a register */
 static void __mark_reg_unbounded(struct bpf_reg_state *reg)
 {
@@ -5433,6 +5444,10 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	/* We might have learned some bits from the bounds. */
 	__reg_bound_offset(false_reg);
 	__reg_bound_offset(true_reg);
+	if (is_jmp32) {
+		__reg_bound_offset32(false_reg);
+		__reg_bound_offset32(true_reg);
+	}
 	/* Intersecting with the old var_off might have improved our bounds
 	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
 	 * then new var_off is (0; 0x7f...fc) which improves our umax.
@@ -5542,6 +5557,10 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 	/* We might have learned some bits from the bounds. */
 	__reg_bound_offset(false_reg);
 	__reg_bound_offset(true_reg);
+	if (is_jmp32) {
+		__reg_bound_offset32(false_reg);
+		__reg_bound_offset32(true_reg);
+	}
 	/* Intersecting with the old var_off might have improved our bounds
 	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
 	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-- 
2.20.1



