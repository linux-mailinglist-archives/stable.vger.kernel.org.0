Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667263967F0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhEaS2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:28:19 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14146 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhEaS1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622485573; x=1654021573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1jEc7I/9tRcVYzVXtkPMeF4qBl3Aoc4IBMPa97CdcRI=;
  b=mvEctfOEy4weAYC81j7YP1582Gwq33Z/smZsw975AsvXt9oY7CpZQum1
   4oLbb/giQxKupHiNhcbDC7YPahlqpNB3AXSpd7K+sjjOhh1N+xnKTh8kt
   iETExcSNzsCBWud+/ja4vJvT0nRAegfQJT/PD2j+cklB4zqyC0erhc+5W
   k=;
X-IronPort-AV: E=Sophos;i="5.83,238,1616457600"; 
   d="scan'208";a="111190630"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 31 May 2021 18:26:00 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 1F160A0502;
        Mon, 31 May 2021 18:25:59 +0000 (UTC)
Received: from EX13D01UEA002.ant.amazon.com (10.43.61.37) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D01UEA002.ant.amazon.com (10.43.61.37) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 31 May 2021 18:25:58 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.18 via Frontend Transport; Mon, 31 May 2021 18:25:58
 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 8E9DE13FE; Mon, 31 May 2021 18:25:57 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <daniel@iogearbox.net>
Subject: [PATCH v2 4.14 15/17] bpf: Wrap aux data inside bpf_sanitize_info container
Date:   Mon, 31 May 2021 18:25:54 +0000
Message-ID: <20210531182556.25277-16-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210531182556.25277-1-fllinden@amazon.com>
References: <20210531182556.25277-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 3d0220f6861d713213b015b582e9f21e5b28d2e0 upstream.

Add a container structure struct bpf_sanitize_info which holds
the current aux info, and update call-sites to sanitize_ptr_alu()
to pass it in. This is needed for passing in additional state
later on.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 84779fe35ebc..db359b796442 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2110,15 +2110,19 @@ static bool sanitize_needed(u8 opcode)
 	return opcode == BPF_ADD || opcode == BPF_SUB;
 }
 
+struct bpf_sanitize_info {
+	struct bpf_insn_aux_data aux;
+};
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
 			    const struct bpf_reg_state *off_reg,
 			    struct bpf_reg_state *dst_reg,
-			    struct bpf_insn_aux_data *tmp_aux,
+			    struct bpf_sanitize_info *info,
 			    const bool commit_window)
 {
-	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
+	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : &info->aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
 	bool off_is_imm = tnum_is_const(off_reg->var_off);
 	bool off_is_neg = off_reg->smin_value < 0;
@@ -2147,8 +2151,8 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		/* In commit phase we narrow the masking window based on
 		 * the observed pointer move after the simulated operation.
 		 */
-		alu_state = tmp_aux->alu_state;
-		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
+		alu_state = info->aux.alu_state;
+		alu_limit = abs(info->aux.alu_limit - alu_limit);
 	} else {
 		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
 		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
@@ -2276,7 +2280,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	struct bpf_insn_aux_data tmp_aux = {};
+	struct bpf_sanitize_info info = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -2327,7 +2331,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
-				       &tmp_aux, false);
+				       &info, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
@@ -2468,7 +2472,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
-				       &tmp_aux, true);
+				       &info, true);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
-- 
2.23.4

