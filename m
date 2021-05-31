Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3957E395C67
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhEaNcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhEaNa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E7661420;
        Mon, 31 May 2021 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467379;
        bh=gGrd305Iu6Iz8nAJAZDFuVio0yWyIPhWLrF6uC5ORu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjrdt5lIjrWWAwJuzRPeBQpJFtFuvax5+6/txIrIfi5k3w/tnmxurTjhxnLsscrQn
         3fhld49/e1HeaHoccTyzrQpVY0TSMT6vsCVMvTkltd0GAP5Jb1SJedO73IjXWNc14L
         A4hr0TjqjodfjFZTICqxEtLVdXqVqy49ljlrWuh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 044/116] bpf: extend is_branch_taken to registers
Date:   Mon, 31 May 2021 15:13:40 +0200
Message-Id: <20210531130641.652305969@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

commit fb8d251ee2a6bf4d7f4af5548e9c8f4fb5f90402 upstream

This patch extends is_branch_taken() logic from JMP+K instructions
to JMP+X instructions.
Conditional branches are often done when src and dst registers
contain known scalars. In such case the verifier can follow
the branch that is going to be taken when program executes.
That speeds up the verification and is essential feature to support
bounded loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: drop is_jmp32 parameter from is_branch_taken() calls and
     adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4127,8 +4127,9 @@ static int check_cond_jmp_op(struct bpf_
 	struct bpf_verifier_state *this_branch = env->cur_state;
 	struct bpf_verifier_state *other_branch;
 	struct bpf_reg_state *regs = this_branch->frame[this_branch->curframe]->regs;
-	struct bpf_reg_state *dst_reg, *other_branch_regs;
+	struct bpf_reg_state *dst_reg, *other_branch_regs, *src_reg = NULL;
 	u8 opcode = BPF_OP(insn->code);
+	int pred = -1;
 	int err;
 
 	if (opcode > BPF_JSLE) {
@@ -4152,6 +4153,7 @@ static int check_cond_jmp_op(struct bpf_
 				insn->src_reg);
 			return -EACCES;
 		}
+		src_reg = &regs[insn->src_reg];
 	} else {
 		if (insn->src_reg != BPF_REG_0) {
 			verbose(env, "BPF_JMP uses reserved fields\n");
@@ -4166,19 +4168,21 @@ static int check_cond_jmp_op(struct bpf_
 
 	dst_reg = &regs[insn->dst_reg];
 
-	if (BPF_SRC(insn->code) == BPF_K) {
-		int pred = is_branch_taken(dst_reg, insn->imm, opcode);
-
-		if (pred == 1) {
-			 /* only follow the goto, ignore fall-through */
-			*insn_idx += insn->off;
-			return 0;
-		} else if (pred == 0) {
-			/* only follow fall-through branch, since
-			 * that's where the program will go
-			 */
-			return 0;
-		}
+	if (BPF_SRC(insn->code) == BPF_K)
+		pred = is_branch_taken(dst_reg, insn->imm, opcode);
+	else if (src_reg->type == SCALAR_VALUE &&
+		 tnum_is_const(src_reg->var_off))
+		pred = is_branch_taken(dst_reg, src_reg->var_off.value,
+				       opcode);
+	if (pred == 1) {
+		/* only follow the goto, ignore fall-through */
+		*insn_idx += insn->off;
+		return 0;
+	} else if (pred == 0) {
+		/* only follow fall-through branch, since
+		 * that's where the program will go
+		 */
+		return 0;
 	}
 
 	other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,


