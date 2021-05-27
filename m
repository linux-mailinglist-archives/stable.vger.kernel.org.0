Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982CB3931F8
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhE0POg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236885AbhE0POe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA59613AA;
        Thu, 27 May 2021 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128380;
        bh=rTUUvF7C+5eqi7RLIsHnuscfECV4eFNPhA1hcwbrQZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxKjNOl4dygtczq2U0OGpqI0P4gQYqUilBlvJS/nLt+feCa8A//foAtcqAMEpq9jv
         u74eD1t7JykCPy36CNVpw7riCHg49j1LhGlPWKL5hf/WMyUQzOgmS2h2uUDzmKArPm
         km2GEiUSyf3H/QCzAcfrNljHL+BoPXHTTotLQ4W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 1/7] bpf: Wrap aux data inside bpf_sanitize_info container
Date:   Thu, 27 May 2021 17:12:43 +0200
Message-Id: <20210527151139.271634716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
References: <20210527151139.224619013@linuxfoundation.org>
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

commit 3d0220f6861d713213b015b582e9f21e5b28d2e0 upstream.

Add a container structure struct bpf_sanitize_info which holds
the current aux info, and update call-sites to sanitize_ptr_alu()
to pass it in. This is needed for passing in additional state
later on.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4349,15 +4349,19 @@ static bool sanitize_needed(u8 opcode)
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
@@ -4386,8 +4390,8 @@ static int sanitize_ptr_alu(struct bpf_v
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
@@ -4517,7 +4521,7 @@ static int adjust_ptr_min_max_vals(struc
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	struct bpf_insn_aux_data tmp_aux = {};
+	struct bpf_sanitize_info info = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -4578,7 +4582,7 @@ static int adjust_ptr_min_max_vals(struc
 
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
-				       &tmp_aux, false);
+				       &info, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
@@ -4719,7 +4723,7 @@ static int adjust_ptr_min_max_vals(struc
 		return -EACCES;
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
-				       &tmp_aux, true);
+				       &info, true);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}


