Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66CF411FBB
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345430AbhITRpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353008AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3054E61B5F;
        Mon, 20 Sep 2021 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157750;
        bh=Vw+BeXgcof7+KDmUjYeZjZ0WztAkxSGe9rfe5mI+mLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+vFjTm0I9yII448iWeEOshf/q/72DyhI7WDQK2nF18PgCiQErx6TNcOv6M0zZAws
         D9VxaulINDcsKz4eD5WYjbbW+x7wV6yrsnXz+DsIVYomY7T+w3mAj/XNEcMlopFqo1
         eQUbaURZk5ZbIKWY51aeWFTfmdb5xrv/J/QnqZa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 133/293] selftests/bpf: Test variable offset stack access
Date:   Mon, 20 Sep 2021 18:41:35 +0200
Message-Id: <20210920163937.831591480@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 8ff80e96e3ccea5ff0a890d4f18997e0344dbec2 upstream.

Test different scenarios of indirect variable-offset stack access: out of
bound access (>0), min_off below initialized part of the stack,
max_off+size above initialized part of the stack, initialized stack.

Example of output:
  ...
  #856/p indirect variable-offset stack access, out of bound OK
  #857/p indirect variable-offset stack access, max_off+size > max_initialized OK
  #858/p indirect variable-offset stack access, min_off < min_initialized OK
  #859/p indirect variable-offset stack access, ok OK
  ...

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   79 +++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -8495,7 +8495,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
 	{
-		"indirect variable-offset stack access",
+		"indirect variable-offset stack access, out of bound",
 		.insns = {
 			/* Fill the top 8 bytes of the stack */
 			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
@@ -8516,11 +8516,86 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map1 = { 5 },
-		.errstr = "variable stack read R2",
+		.errstr = "invalid stack type R2 var_off",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
 	{
+		"indirect variable-offset stack access, max_off+size > max_initialized",
+		.insns = {
+		/* Fill only the second from top 8 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 0),
+		/* Get an unknown value. */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, but we don't know
+		 * which. fp-12 size 8 is partially uninitialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 5 },
+		.errstr = "invalid indirect read from stack var_off",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
+	{
+		"indirect variable-offset stack access, min_off < min_initialized",
+		.insns = {
+		/* Fill only the top 8 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+		/* Get an unknown value */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, but we don't know
+		 * which. fp-16 size 8 is partially uninitialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 5 },
+		.errstr = "invalid indirect read from stack var_off",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
+	{
+		"indirect variable-offset stack access, ok",
+		.insns = {
+		/* Fill the top 16 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 0),
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+		/* Get an unknown value. */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, we don't know
+		 * which, but either way it points to initialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 6 },
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
+	{
 		"direct stack access with 32-bit wraparound. test1",
 		.insns = {
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),


