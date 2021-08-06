Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E03E257F
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244159AbhHFIUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244311AbhHFITg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826856103B;
        Fri,  6 Aug 2021 08:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237960;
        bh=7IQXGQwsEbgjIl8djSf8uz+9rEQ60+mQnvbTRkbRZGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ui833pNLAHG89cL+R6SAmbd5CVuRePHZ3cvIsJ2cxXca4Ejr9m8j2MoIwv1suS+2y
         8TK7bawDXUsnUSlOSxj0cuy86qVHIwqiSmi/mPdWxCuJ1LNakT0q7tcYOBPfdrxqce
         cGSaMEx4lN0SwSl6wr2kFLErVI9GIkZXIlsp0HP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 29/30] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Fri,  6 Aug 2021 10:17:07 +0200
Message-Id: <20210806081114.120480962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 973377ffe8148180b2651825b92ae91988141b05 upstream

In almost all cases from test_verifier that have been changed in here, we've
had an unreachable path with a load from a register which has an invalid
address on purpose. This was basically to make sure that we never walk this
path and to have the verifier complain if it would otherwise. Change it to
match on the right error for unprivileged given we now test these paths
under speculative execution.

There's one case where we match on exact # of insns_processed. Due to the
extra path, this will of course mismatch on unprivileged. Thus, restrict the
test->insn_processed check to privileged-only.

In one other case, we result in a 'pointer comparison prohibited' error. This
is similarly due to verifying an 'invalid' branch where we end up with a value
pointer on one side of the comparison.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c            |    2 -
 tools/testing/selftests/bpf/verifier/and.c             |    2 +
 tools/testing/selftests/bpf/verifier/bounds.c          |   14 ++++++++++
 tools/testing/selftests/bpf/verifier/dead_code.c       |    2 +
 tools/testing/selftests/bpf/verifier/jmp32.c           |   22 +++++++++++++++++
 tools/testing/selftests/bpf/verifier/jset.c            |   10 ++++---
 tools/testing/selftests/bpf/verifier/unpriv.c          |    2 +
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c |    7 +++--
 8 files changed, 53 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1036,7 +1036,7 @@ static void do_test_single(struct bpf_te
 		}
 	}
 
-	if (test->insn_processed) {
+	if (!unpriv && test->insn_processed) {
 		uint32_t insn_processed;
 		char *proc;
 
--- a/tools/testing/selftests/bpf/verifier/and.c
+++ b/tools/testing/selftests/bpf/verifier/and.c
@@ -61,6 +61,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0
 },
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -508,6 +508,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -528,6 +530,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT
 },
 {
@@ -569,6 +573,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -589,6 +595,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -609,6 +617,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -674,6 +684,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
@@ -695,6 +707,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 min value is outside of the allowed memory range",
+	.result_unpriv = REJECT,
 	.fixup_map_hash_8b = { 3 },
 	.result = ACCEPT,
 },
--- a/tools/testing/selftests/bpf/verifier/dead_code.c
+++ b/tools/testing/selftests/bpf/verifier/dead_code.c
@@ -8,6 +8,8 @@
 	BPF_JMP_IMM(BPF_JGE, BPF_REG_0, 10, -4),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 7,
 },
--- a/tools/testing/selftests/bpf/verifier/jmp32.c
+++ b/tools/testing/selftests/bpf/verifier/jmp32.c
@@ -87,6 +87,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -150,6 +152,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -213,6 +217,8 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -280,6 +286,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -348,6 +356,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -416,6 +426,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -484,6 +496,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -552,6 +566,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -620,6 +636,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -688,6 +706,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
@@ -756,6 +776,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 2,
 },
--- a/tools/testing/selftests/bpf/verifier/jset.c
+++ b/tools/testing/selftests/bpf/verifier/jset.c
@@ -82,8 +82,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.retval_unpriv = 1,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.retval = 1,
 	.result = ACCEPT,
 },
@@ -141,7 +141,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -162,6 +163,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
-	.result_unpriv = ACCEPT,
+	.errstr_unpriv = "R9 !read_ok",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -419,6 +419,8 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R7 invalid mem access 'inv'",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 0,
 },
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -120,7 +120,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R2 pointer comparison prohibited",
 	.retval = 0,
 },
 {
@@ -159,7 +159,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	// fake-dead code; targeted from branch A to
-	// prevent dead code sanitization
+	// prevent dead code sanitization, rejected
+	// via branch B however
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
@@ -167,7 +168,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
+	.errstr_unpriv = "R0 invalid mem access 'inv'",
 	.retval = 0,
 },
 {


