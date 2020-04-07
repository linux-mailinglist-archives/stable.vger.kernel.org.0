Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F391A0B0E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgDGKXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgDGKXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C8C8214AF;
        Tue,  7 Apr 2020 10:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255004;
        bh=VZOLvbe2+CsC7md2a7+ZU2PXb86w03z17EDGWoEiGuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ5v542wXEF6RrDNcAuaoJRx6z0QFGHVR/PFqFVGHpOBmxSGgjfQfOfy7oAfMMHug
         a3ijYng/Qu6gDOSVR01fYEJw+oZwK2a3awg+hSzSXjGuohUYkj0e1JJrk0xqM1pmta
         LMWtIo/YIxg7aU84Rj1ya+adHVOZnF26OH4KczJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/36] bpf: Fix tnum constraints for 32-bit comparisons
Date:   Tue,  7 Apr 2020 12:21:43 +0200
Message-Id: <20200407101455.655552813@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 604dca5e3af1db98bd123b7bfc02b017af99e3a0 ]

The BPF verifier tried to track values based on 32-bit comparisons by
(ab)using the tnum state via 581738a681b6 ("bpf: Provide better register
bounds after jmp32 instructions"). The idea is that after a check like
this:

    if ((u32)r0 > 3)
      exit

We can't meaningfully constrain the arithmetic-range-based tracking, but
we can update the tnum state to (value=0,mask=0xffff'ffff'0000'0003).
However, the implementation from 581738a681b6 didn't compute the tnum
constraint based on the fixed operand, but instead derives it from the
arithmetic-range-based tracking. This means that after the following
sequence of operations:

    if (r0 >= 0x1'0000'0001)
      exit
    if ((u32)r0 > 7)
      exit

The verifier assumed that the lower half of r0 is in the range (0, 0)
and apply the tnum constraint (value=0,mask=0xffff'ffff'0000'0000) thus
causing the overall tnum to be (value=0,mask=0x1'0000'0000), which was
incorrect. Provide a fixed implementation.

Fixes: 581738a681b6 ("bpf: Provide better register bounds after jmp32 instructions")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200330160324.15259-3-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 108 ++++++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 36 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a0b76b360d6f7..013780ef0bd7d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5325,6 +5325,70 @@ static bool cmp_val_with_extended_s64(s64 sval, struct bpf_reg_state *reg)
 		reg->smax_value <= 0 && reg->smin_value >= S32_MIN);
 }
 
+/* Constrain the possible values of @reg with unsigned upper bound @bound.
+ * If @is_exclusive, @bound is an exclusive limit, otherwise it is inclusive.
+ * If @is_jmp32, @bound is a 32-bit value that only constrains the low 32 bits
+ * of @reg.
+ */
+static void set_upper_bound(struct bpf_reg_state *reg, u64 bound, bool is_jmp32,
+			    bool is_exclusive)
+{
+	if (is_exclusive) {
+		/* There are no values for `reg` that make `reg<0` true. */
+		if (bound == 0)
+			return;
+		bound--;
+	}
+	if (is_jmp32) {
+		/* Constrain the register's value in the tnum representation.
+		 * For 64-bit comparisons this happens later in
+		 * __reg_bound_offset(), but for 32-bit comparisons, we can be
+		 * more precise than what can be derived from the updated
+		 * numeric bounds.
+		 */
+		struct tnum t = tnum_range(0, bound);
+
+		t.mask |= ~0xffffffffULL; /* upper half is unknown */
+		reg->var_off = tnum_intersect(reg->var_off, t);
+
+		/* Compute the 64-bit bound from the 32-bit bound. */
+		bound += gen_hi_max(reg->var_off);
+	}
+	reg->umax_value = min(reg->umax_value, bound);
+}
+
+/* Constrain the possible values of @reg with unsigned lower bound @bound.
+ * If @is_exclusive, @bound is an exclusive limit, otherwise it is inclusive.
+ * If @is_jmp32, @bound is a 32-bit value that only constrains the low 32 bits
+ * of @reg.
+ */
+static void set_lower_bound(struct bpf_reg_state *reg, u64 bound, bool is_jmp32,
+			    bool is_exclusive)
+{
+	if (is_exclusive) {
+		/* There are no values for `reg` that make `reg>MAX` true. */
+		if (bound == (is_jmp32 ? U32_MAX : U64_MAX))
+			return;
+		bound++;
+	}
+	if (is_jmp32) {
+		/* Constrain the register's value in the tnum representation.
+		 * For 64-bit comparisons this happens later in
+		 * __reg_bound_offset(), but for 32-bit comparisons, we can be
+		 * more precise than what can be derived from the updated
+		 * numeric bounds.
+		 */
+		struct tnum t = tnum_range(bound, U32_MAX);
+
+		t.mask |= ~0xffffffffULL; /* upper half is unknown */
+		reg->var_off = tnum_intersect(reg->var_off, t);
+
+		/* Compute the 64-bit bound from the 32-bit bound. */
+		bound += gen_hi_min(reg->var_off);
+	}
+	reg->umin_value = max(reg->umin_value, bound);
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
@@ -5380,15 +5444,8 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umax = opcode == BPF_JGT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JGT ? val + 1 : val;
-
-		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
-		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
+		set_upper_bound(false_reg, val, is_jmp32, opcode == BPF_JGE);
+		set_lower_bound(true_reg, val, is_jmp32, opcode == BPF_JGT);
 		break;
 	}
 	case BPF_JSGE:
@@ -5409,15 +5466,8 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umin = opcode == BPF_JLT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JLT ? val - 1 : val;
-
-		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
-		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
+		set_lower_bound(false_reg, val, is_jmp32, opcode == BPF_JLE);
+		set_upper_bound(true_reg, val, is_jmp32, opcode == BPF_JLT);
 		break;
 	}
 	case BPF_JSLE:
@@ -5492,15 +5542,8 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umin = opcode == BPF_JGT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JGT ? val - 1 : val;
-
-		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
-		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
+		set_lower_bound(false_reg, val, is_jmp32, opcode == BPF_JGE);
+		set_upper_bound(true_reg, val, is_jmp32, opcode == BPF_JGT);
 		break;
 	}
 	case BPF_JSGE:
@@ -5518,15 +5561,8 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umax = opcode == BPF_JLT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JLT ? val + 1 : val;
-
-		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
-		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
+		set_upper_bound(false_reg, val, is_jmp32, opcode == BPF_JLE);
+		set_lower_bound(true_reg, val, is_jmp32, opcode == BPF_JLT);
 		break;
 	}
 	case BPF_JSLE:
-- 
2.20.1



