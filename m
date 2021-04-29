Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1524C36F26A
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhD2WJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:30 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45052 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhD2WJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734123; x=1651270123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gmNWx/A3o7P+Kw8wXRNXjVF41jEqA3d1gWnTLKT66Qg=;
  b=K6NmR3vcG5MO7N38A2CrApFEd7Q+WjFEPx7mM8/V62nQcJUkjKxchOdp
   zih5RyDjSjFnFDOII1IvtJLdbY3awUrFAPj0159Zw31S40fSLiH2p5+pu
   xtvZuH0iBJDAWDiWPePu6SJKCdcrvCi/eLItzbWlimHRlVM0DSkW/0BVQ
   U=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="104851474"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id A47A5A20FC;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D20UEB003.ant.amazon.com (10.43.60.73) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D20UEB003.ant.amazon.com (10.43.60.73) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:39 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D167AE6; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 4/8] bpf: Improve verifier error messages for users
Date:   Thu, 29 Apr 2021 22:08:35 +0000
Message-ID: <20210429220839.15667-5-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210429220839.15667-1-fllinden@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 kernel/bpf/verifier.c | 84 +++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a6ff4b26a462..59718101fd04 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4263,6 +4263,14 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
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
@@ -4274,7 +4282,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return -EACCES;
+		return REASON_BOUNDS;
 
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
@@ -4301,11 +4309,11 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
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
@@ -4325,7 +4333,7 @@ static int update_alu_sanitation_state(struct bpf_insn_aux_data *aux,
 	if (aux->alu_state &&
 	    (aux->alu_state != alu_state ||
 	     aux->alu_limit != alu_limit))
-		return -EACCES;
+		return REASON_PATHS;
 
 	/* Corresponding fixup done in fixup_bpf_calls(). */
 	aux->alu_state = alu_state;
@@ -4398,7 +4406,46 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
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
+		verbose(env, "R%d has unknown scalar with mixed signed bounds, %s\n",
+			off_reg == dst_reg ? dst : src, err);
+		break;
+	case REASON_TYPE:
+		verbose(env, "R%d has pointer with unsupported alu operation, %s\n",
+			off_reg == dst_reg ? src : dst, err);
+		break;
+	case REASON_PATHS:
+		verbose(env, "R%d tried to %s from different maps, paths or scalars, %s\n",
+			dst, op, err);
+		break;
+	case REASON_LIMIT:
+		verbose(env, "R%d tried to %s beyond pointer bounds, %s\n",
+			dst, op, err);
+		break;
+	case REASON_STACK:
+		verbose(env, "R%d could not be pushed for speculative verification, %s\n",
+			dst, err);
+		break;
+	default:
+		verbose(env, "verifier internal error: unknown reason (%d)\n",
+			reason);
+		break;
+	}
+
+	return -EACCES;
 }
 
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
@@ -4480,10 +4527,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -4535,10 +4581,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		break;
 	case BPF_SUB:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
@@ -4655,7 +4700,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
 	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
-	u32 dst = insn->dst_reg;
 	int ret;
 
 	if (insn_bitness == 32) {
@@ -4692,10 +4736,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose(env, "R%d tried to add from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -4716,10 +4758,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		break;
 	case BPF_SUB:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */
-- 
2.23.3

