Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEAD37057A
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhEAEbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:08 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:38307 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhEAEbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843418; x=1651379418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bOqMNLuPAU1m9w48WhK9GJ8lLWKtUkwrTY01KXT2FMY=;
  b=WzePGHxvG57vmXBKipwMhZ8rMzbnvACn0SqxOcH4BHEMSs0o8zQ1ljR7
   1JpcdKQxNgYa6wpCo5SojD27JeKCht8tXnF54hTpyU0HTizhkFmUapKm9
   sywbekVhedb0Fh9GBt2wOK3WCWk5gs3eBVx3H/c1JG0dJ98nV0+EvTo9N
   w=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="132286625"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 01 May 2021 04:30:18 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 70CDEA04F4;
        Sat,  1 May 2021 04:30:16 +0000 (UTC)
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d01UWA003.ant.amazon.com (10.43.160.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 459C3DAB; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 07/15] bpf: Improve verifier error messages for users
Date:   Sat, 1 May 2021 04:30:06 +0000
Message-ID: <20210501043014.33300-8-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Upstream commit a6aaece00a57fa6f22575364b3903dfbccf5345d

Consolidate all error handling and provide more user-friendly error messages
from sanitize_ptr_alu() and sanitize_val_alu().

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 84 +++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ef1fe213cbce..97a2e4347fe2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2024,6 +2024,14 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
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
@@ -2035,7 +2043,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return -EACCES;
+		return REASON_BOUNDS;
 
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
@@ -2059,11 +2067,11 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
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
@@ -2083,7 +2091,7 @@ static int update_alu_sanitation_state(struct bpf_insn_aux_data *aux,
 	if (aux->alu_state &&
 	    (aux->alu_state != alu_state ||
 	     aux->alu_limit != alu_limit))
-		return -EACCES;
+		return REASON_PATHS;
 
 	/* Corresponding fixup done in fixup_bpf_calls(). */
 	aux->alu_state = alu_state;
@@ -2156,7 +2164,46 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
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
@@ -2230,10 +2277,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
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
@@ -2285,10 +2331,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
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
@@ -2412,7 +2457,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
 	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
-	u32 dst = insn->dst_reg;
 	int ret;
 
 	if (insn_bitness == 32) {
@@ -2449,10 +2493,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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
@@ -2473,10 +2515,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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
-- 
2.23.3

