Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61239FFB9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhFHSfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234325AbhFHSd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67468613CC;
        Tue,  8 Jun 2021 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177091;
        bh=p8yMx1k89PtuQYKI+/EhSCxcOlQ4VnLlIA7C4ZYk+0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdO7cavKuY1x4WoW7kAAy9t0Z5vXQhJTIK86wHR5sasOhkYaBdnuaON4VViY7nJ2y
         wtCZao4WE5xLJ1+m2oPT4Y4wQ1KXlWq6BohhvsepiiTsqSiH9Sz8/e76ZCxen1AHW8
         pqUajpkxWSf+KS/1Wwagm8HwgCUs4rqngTFu6SaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 29/47] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Tue,  8 Jun 2021 20:27:12 +0200
Message-Id: <20210608175931.434363550@linuxfoundation.org>
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
[fllinden@amazon.com: backport to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2025,12 +2025,18 @@ static struct bpf_insn_aux_data *cur_aux
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
@@ -2121,7 +2127,7 @@ static int sanitize_ptr_alu(struct bpf_v
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -2164,8 +2170,8 @@ static int adjust_ptr_min_max_vals(struc
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -2205,13 +2211,6 @@ static int adjust_ptr_min_max_vals(struc
 				dst);
 		return -EACCES;
 	}
-	if (ptr_reg->type == PTR_TO_MAP_VALUE) {
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-			verbose("R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-				off_reg == dst_reg ? dst : src);
-			return -EACCES;
-		}
-	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.


