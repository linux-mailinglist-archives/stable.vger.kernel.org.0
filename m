Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1E6137EAA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgAKKMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgAKKMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:12:32 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825C6206DA;
        Sat, 11 Jan 2020 10:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737551;
        bh=ZrMTsz0LXDOUVHBpgMWAsczBvlgMAz3zknDyfWbG7dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dD7LUDF5RO1+OgtdLo3I9Ye8xpzR29HUn4A9rW8pvVGioxb1qPc33u+MWEshJeVx
         H3EqY/84gPWyFu5C2vicA1VxgCCSTMMwQuPWbqNlawBE4SIN8/CAgjX5xHeX5kj+DA
         jOyoCNMV+g5ZAJ7JOKWYXlDsBAHNHFYVIP4ZI2tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3d0b2441dbb71751615e@syzkaller.appspotmail.com,
        syzbot+c8504affd4fdd0c1b626@syzkaller.appspotmail.com,
        syzbot+e5190cb881d8660fb1a3@syzkaller.appspotmail.com,
        syzbot+efae31b384d5badbd620@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Edward Cree <ecree@solarflare.com>
Subject: [PATCH 4.14 40/62] bpf: reject passing modified ctx to helper functions
Date:   Sat, 11 Jan 2020 10:50:22 +0100
Message-Id: <20200111094848.163822410@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 58990d1ff3f7896ee341030e9a7c2e4002570683 upstream.

As commit 28e33f9d78ee ("bpf: disallow arithmetic operations on
context pointer") already describes, f1174f77b50c ("bpf/verifier:
rework value tracking") removed the specific white-listed cases
we had previously where we would allow for pointer arithmetic in
order to further generalize it, and allow e.g. context access via
modified registers. While the dereferencing of modified context
pointers had been forbidden through 28e33f9d78ee, syzkaller did
recently manage to trigger several KASAN splats for slab out of
bounds access and use after frees by simply passing a modified
context pointer to a helper function which would then do the bad
access since verifier allowed it in adjust_ptr_min_max_vals().

Rejecting arithmetic on ctx pointer in adjust_ptr_min_max_vals()
generally could break existing programs as there's a valid use
case in tracing in combination with passing the ctx to helpers as
bpf_probe_read(), where the register then becomes unknown at
verification time due to adding a non-constant offset to it. An
access sequence may look like the following:

  offset = args->filename;  /* field __data_loc filename */
  bpf_probe_read(&dst, len, (char *)args + offset); // args is ctx

There are two options: i) we could special case the ctx and as
soon as we add a constant or bounded offset to it (hence ctx type
wouldn't change) we could turn the ctx into an unknown scalar, or
ii) we generalize the sanity test for ctx member access into a
small helper and assert it on the ctx register that was passed
as a function argument. Fwiw, latter is more obvious and less
complex at the same time, and one case that may potentially be
legitimate in future for ctx member access at least would be for
ctx to carry a const offset. Therefore, fix follows approach
from ii) and adds test cases to BPF kselftests.

Fixes: f1174f77b50c ("bpf/verifier: rework value tracking")
Reported-by: syzbot+3d0b2441dbb71751615e@syzkaller.appspotmail.com
Reported-by: syzbot+c8504affd4fdd0c1b626@syzkaller.appspotmail.com
Reported-by: syzbot+e5190cb881d8660fb1a3@syzkaller.appspotmail.com
Reported-by: syzbot+efae31b384d5badbd620@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c                       |   45 ++++++++++++++-------
 tools/testing/selftests/bpf/test_verifier.c |   58 +++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 16 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1251,6 +1251,30 @@ static int check_ptr_alignment(struct bp
 	return check_generic_ptr_alignment(reg, pointer_desc, off, size, strict);
 }
 
+static int check_ctx_reg(struct bpf_verifier_env *env,
+			 const struct bpf_reg_state *reg, int regno)
+{
+	/* Access to ctx or passing it to a helper is only allowed in
+	 * its original, unmodified form.
+	 */
+
+	if (reg->off) {
+		verbose("dereference of modified ctx ptr R%d off=%d disallowed\n",
+			regno, reg->off);
+		return -EACCES;
+	}
+
+	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
+		char tn_buf[48];
+
+		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+		verbose("variable ctx access var_off=%s disallowed\n", tn_buf);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
 /* truncate register to smaller size (in bytes)
  * must be called with size < BPF_REG_SIZE
  */
@@ -1320,22 +1344,10 @@ static int check_mem_access(struct bpf_v
 			verbose("R%d leaks addr into ctx\n", value_regno);
 			return -EACCES;
 		}
-		/* ctx accesses must be at a fixed offset, so that we can
-		 * determine what type of data were returned.
-		 */
-		if (reg->off) {
-			verbose("dereference of modified ctx ptr R%d off=%d+%d, ctx+const is allowed, ctx+const+const is not\n",
-				regno, reg->off, off - reg->off);
-			return -EACCES;
-		}
-		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
-			char tn_buf[48];
+		err = check_ctx_reg(env, reg, regno);
+		if (err < 0)
+			return err;
 
-			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-			verbose("variable ctx access var_off=%s off=%d size=%d",
-				tn_buf, off, size);
-			return -EACCES;
-		}
 		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type);
 		if (!err && t == BPF_READ && value_regno >= 0) {
 			/* ctx access returns either a scalar, or a
@@ -1573,6 +1585,9 @@ static int check_func_arg(struct bpf_ver
 		expected_type = PTR_TO_CTX;
 		if (type != expected_type)
 			goto err_type;
+		err = check_ctx_reg(env, reg, regno);
+		if (err < 0)
+			return err;
 	} else if (arg_type == ARG_PTR_TO_MEM ||
 		   arg_type == ARG_PTR_TO_UNINIT_MEM) {
 		expected_type = PTR_TO_STACK;
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -7281,7 +7281,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr = "dereference of modified ctx ptr R1 off=68+8, ctx+const is allowed, ctx+const+const is not",
+		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	},
@@ -7944,6 +7944,62 @@ static struct bpf_test tests[] = {
 		.errstr = "BPF_XADD stores into R2 packet",
 		.prog_type = BPF_PROG_TYPE_XDP,
 	},
+	{
+		"pass unmodified ctx pointer to helper",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_2, 0),
+			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				     BPF_FUNC_csum_update),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.result = ACCEPT,
+	},
+	{
+		"pass modified ctx pointer to helper, 1",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -612),
+			BPF_MOV64_IMM(BPF_REG_2, 0),
+			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				     BPF_FUNC_csum_update),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.result = REJECT,
+		.errstr = "dereference of modified ctx ptr",
+	},
+	{
+		"pass modified ctx pointer to helper, 2",
+		.insns = {
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -612),
+			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				     BPF_FUNC_get_socket_cookie),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.result_unpriv = REJECT,
+		.result = REJECT,
+		.errstr_unpriv = "dereference of modified ctx ptr",
+		.errstr = "dereference of modified ctx ptr",
+	},
+	{
+		"pass modified ctx pointer to helper, 3",
+		.insns = {
+			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1, 0),
+			BPF_ALU64_IMM(BPF_AND, BPF_REG_3, 4),
+			BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_3),
+			BPF_MOV64_IMM(BPF_REG_2, 0),
+			BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				     BPF_FUNC_csum_update),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+		.result = REJECT,
+		.errstr = "variable ctx access var_off=(0x0; 0x4)",
+	},
 };
 
 static int probe_filter_length(const struct bpf_insn *fp)


