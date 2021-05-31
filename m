Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FFC395C6B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhEaNcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232089AbhEaNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0CF86142D;
        Mon, 31 May 2021 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467390;
        bh=2mYgn0+xEy3LA8PX8utkbUKq+W5HQvza1lQI7eUtytQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc5pqr28NKbpeKgRzfW81SZagaMX2bSV6Lvtzlh3fwFsTzDzMwzW1c3Wsz5GSgsJR
         2YUBfxZFQth4LjwMI3J/YIQ+Comk9licVbbqZ/sRHevaLbFnB1aqufWxfLLfq10o3G
         YcI0q+MV5WU9Kwe/tVsHojdygNXOuX2+0+UqLROA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 048/116] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Mon, 31 May 2021 15:13:44 +0200
Message-Id: <20210531130641.806645614@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2730,12 +2730,18 @@ static struct bpf_insn_aux_data *cur_aux
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
@@ -2826,7 +2832,7 @@ static int sanitize_ptr_alu(struct bpf_v
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -2871,8 +2877,8 @@ static int adjust_ptr_min_max_vals(struc
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -2909,12 +2915,6 @@ static int adjust_ptr_min_max_vals(struc
 			dst);
 		return -EACCES;
 	}
-	if (ptr_reg->type == PTR_TO_MAP_VALUE &&
-	    !env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-		verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-			off_reg == dst_reg ? dst : src);
-		return -EACCES;
-	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.


