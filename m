Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5893236FC0E
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhD3OVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhD3OVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB46461459;
        Fri, 30 Apr 2021 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792433;
        bh=eq8jXJ9NK2xLpyIpZhNthE6qU2pZf4FZ+ks1FZ7G1DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEHDiEuEPBUK6fW4oPEpwckfeHXz2vyl7Ix3g7+Y1dXisIWzI1RXwzElJzLpFv5bI
         dMgbHD6Jta+1U07E6oNyMrQH1kkfnsLUSMiYKet6XRJJDpUeRJtwlpSrFcPCNC7JDL
         QDRvCE5zYJDqdFILIarOKCSXyjecclZnG2MEl/84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 5.4 2/8] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Fri, 30 Apr 2021 16:20:16 +0200
Message-Id: <20210430141911.223546912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
References: <20210430141911.137473863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 24c109bb1537c12c02aeed2d51a347b4d6a9b76e upstream.

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
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4264,12 +4264,18 @@ static struct bpf_insn_aux_data *cur_aux
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
@@ -4363,7 +4369,7 @@ static int sanitize_ptr_alu(struct bpf_v
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -4408,8 +4414,8 @@ static int adjust_ptr_min_max_vals(struc
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -4452,13 +4458,6 @@ static int adjust_ptr_min_max_vals(struc
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
-	case PTR_TO_MAP_VALUE:
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-			verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-				off_reg == dst_reg ? dst : src);
-			return -EACCES;
-		}
-		/* fall-through */
 	default:
 		break;
 	}


