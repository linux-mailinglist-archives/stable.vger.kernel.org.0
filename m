Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2744836433F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbhDSNQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240459AbhDSNOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACDF161360;
        Mon, 19 Apr 2021 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837962;
        bh=wsJbThG5akXZYP6Eh4T3CgwSyfAvBybPK5swGOWTeNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgyS7UcjbocOXh28tvzgDJG0fhrmkV/OyK/Ly+BC4Df0jb3mxZ93F7FcrNADyTLCn
         Cdc1yMgv7ggpAmbgRUTOqdH4YYCZoj5L62pvbcgEv0Esj1tk/wvuXC96cHmH54DzXF
         nXLgb7XB8eBGFK9ki7+eevtiHUyiV6P9gbydrFLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 117/122] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Mon, 19 Apr 2021 15:06:37 +0200
Message-Id: <20210419130534.143126272@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 24c109bb1537c12c02aeed2d51a347b4d6a9b76e ]

The mixed signed bounds check really belongs into retrieve_ptr_limit()
instead of outside of it in adjust_ptr_min_max_vals(). The reason is
that this check is not tied to PTR_TO_MAP_VALUE only, but to all pointer
types that we handle in retrieve_ptr_limit() and given errors from the latter
propagate back to adjust_ptr_min_max_vals() and lead to rejection of the
program, it's a better place to reside to avoid anything slipping through
for future types. The reason why we must reject such off_reg is that we
otherwise would not be able to derive a mask, see details in 9d7eceede769
("bpf: restrict unknown scalars of mixed signed bounds for unprivileged").

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b654174619e5..fe473e565092 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5385,12 +5385,18 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 }
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      u32 *ptr_limit, u8 opcode, bool off_is_neg)
+			      const struct bpf_reg_state *off_reg,
+			      u32 *ptr_limit, u8 opcode)
 {
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
 	u32 off, max;
 
+	if (!tnum_is_const(off_reg->var_off) &&
+	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+		return -EACCES;
+
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -5483,7 +5489,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -5528,8 +5534,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -5577,13 +5583,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
-	case PTR_TO_MAP_VALUE:
-		if (!env->env->bypass_spec_v1 && !known && (smin_val < 0) != (smax_val < 0)) {
-			verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-				off_reg == dst_reg ? dst : src);
-			return -EACCES;
-		}
-		fallthrough;
 	default:
 		break;
 	}
-- 
2.30.2



