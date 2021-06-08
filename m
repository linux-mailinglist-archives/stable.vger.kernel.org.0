Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A691C39FFBA
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhFHSfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234693AbhFHSd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EAA8610A2;
        Tue,  8 Jun 2021 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177098;
        bh=lovJ9qsAkOMqOiv2dIXZioanqUztSLwo8K6UliWUbyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+atR9gcXcb9K6KQFWNkJdaXi8gdlziD9Dko3NLD2TpBdH0YEfm2kY3y+6HqYQkXb
         4ysJy5dP6RuqLnZjqhcstPD+kc3iAg7cnzPZ1sEWtELjW8wcBhNDwbVk3aSGYamTHG
         oD0MNidPCwp+PCsQnBqA07W1kzHtouwpaY4kf/v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 31/47] bpf: Improve verifier error messages for users
Date:   Tue,  8 Jun 2021 20:27:14 +0200
Message-Id: <20210608175931.498244783@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a6aaece00a57fa6f22575364b3903dfbccf5345d upstream.

Consolidate all error handling and provide more user-friendly error messages
from sanitize_ptr_alu() and sanitize_val_alu().

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   84 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 22 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2024,6 +2024,14 @@ static struct bpf_insn_aux_data *cur_aux
 	return &env->insn_aux_data[env->insn_idx];
 }
 
+enum {
+	REASON_BOUNDS	= -1,
+	REASON_TYPE	= -2,
+	REASON_PATHS	= -3,
+	REASON_LIMIT	= -4,
+	REASON_STACK	= -5,
+};
+
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 			      const struct bpf_reg_state *off_reg,
 			      u32 *alu_limit, u8 opcode)
@@ -2035,7 +2043,7 @@ static int retrieve_ptr_limit(const stru
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return -EACCES;
+		return REASON_BOUNDS;
 
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
@@ -2059,11 +2067,11 @@ static int retrieve_ptr_limit(const stru
 		}
 		break;
 	default:
-		return -EINVAL;
+		return REASON_TYPE;
 	}
 
 	if (ptr_limit >= max)
-		return -ERANGE;
+		return REASON_LIMIT;
 	*alu_limit = ptr_limit;
 	return 0;
 }
@@ -2083,7 +2091,7 @@ static int update_alu_sanitation_state(s
 	if (aux->alu_state &&
 	    (aux->alu_state != alu_state ||
 	     aux->alu_limit != alu_limit))
-		return -EACCES;
+		return REASON_PATHS;
 
 	/* Corresponding fixup done in fixup_bpf_calls(). */
 	aux->alu_state = alu_state;
@@ -2156,7 +2164,46 @@ do_sim:
 	ret = push_stack(env, env->insn_idx + 1, env->insn_idx, true);
 	if (!ptr_is_dst_reg && ret)
 		*dst_reg = tmp;
-	return !ret ? -EFAULT : 0;
+	return !ret ? REASON_STACK : 0;
+}
+
+static int sanitize_err(struct bpf_verifier_env *env,
+			const struct bpf_insn *insn, int reason,
+			const struct bpf_reg_state *off_reg,
+			const struct bpf_reg_state *dst_reg)
+{
+	static const char *err = "pointer arithmetic with it prohibited for !root";
+	const char *op = BPF_OP(insn->code) == BPF_ADD ? "add" : "sub";
+	u32 dst = insn->dst_reg, src = insn->src_reg;
+
+	switch (reason) {
+	case REASON_BOUNDS:
+		verbose("R%d has unknown scalar with mixed signed bounds, %s\n",
+			off_reg == dst_reg ? dst : src, err);
+		break;
+	case REASON_TYPE:
+		verbose("R%d has pointer with unsupported alu operation, %s\n",
+			off_reg == dst_reg ? src : dst, err);
+		break;
+	case REASON_PATHS:
+		verbose("R%d tried to %s from different maps, paths or scalars, %s\n",
+			dst, op, err);
+		break;
+	case REASON_LIMIT:
+		verbose("R%d tried to %s beyond pointer bounds, %s\n",
+			dst, op, err);
+		break;
+	case REASON_STACK:
+		verbose("R%d could not be pushed for speculative verification, %s\n",
+			dst, err);
+		break;
+	default:
+		verbose("verifier internal error: unknown reason (%d)\n",
+			reason);
+		break;
+	}
+
+	return -EACCES;
 }
 
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
@@ -2230,10 +2277,9 @@ static int adjust_ptr_min_max_vals(struc
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose("R%d tried to add from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -2285,10 +2331,9 @@ static int adjust_ptr_min_max_vals(struc
 		break;
 	case BPF_SUB:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose("R%d tried to sub from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			if (!env->allow_ptr_leaks)
@@ -2412,7 +2457,6 @@ static int adjust_scalar_min_max_vals(st
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
 	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
-	u32 dst = insn->dst_reg;
 	int ret;
 
 	if (insn_bitness == 32) {
@@ -2449,10 +2493,8 @@ static int adjust_scalar_min_max_vals(st
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose("R%d tried to add from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -2473,10 +2515,8 @@ static int adjust_scalar_min_max_vals(st
 		break;
 	case BPF_SUB:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose("R%d tried to sub from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */


