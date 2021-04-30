Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC2836FC20
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhD3OVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhD3OVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480426146D;
        Fri, 30 Apr 2021 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792446;
        bh=mRS9YFhUnQSVuNWeUHPfksr53HqyihNaE77PG9QXZVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8iGxw7sGV6d2IVkdhFkQ/R8dPxFX+K+19R3sc8ADdvMVJH2hSA4L+vEVtuyhZ8qY
         QWysxxJJ9b9Hi+UdWTk9ZpDm0ptdB6yUmZMAifb4mAuGW5kxszEAHB3J8vpzdH6P2o
         XXteOCakl55xhMEgWJwmfwhD9dPicCvxxMUzq7Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 5.4 8/8] bpf: Update selftests to reflect new error states
Date:   Fri, 30 Apr 2021 16:20:22 +0200
Message-Id: <20210430141911.426531351@linuxfoundation.org>
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

commit d7a5091351756d0ae8e63134313c455624e36a13 upstream.

Update various selftest error messages:

 * The 'Rx tried to sub from different maps, paths, or prohibited types'
   is reworked into more specific/differentiated error messages for better
   guidance.

 * The change into 'value -4294967168 makes map_value pointer be out of
   bounds' is due to moving the mixed bounds check into the speculation
   handling and thus occuring slightly later than above mentioned sanity
   check.

 * The change into 'math between map_value pointer and register with
   unbounded min value' is similarly due to register sanity check coming
   before the mixed bounds check.

 * The case of 'map access: known scalar += value_ptr from different maps'
   now loads fine given masks are the same from the different paths (despite
   max map value size being different).

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon - skip bounds.c test mods, they won't change error msg on 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/bounds_deduction.c       |   21 +++++-----
 tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c |   13 ------
 tools/testing/selftests/bpf/verifier/unpriv.c                 |    2 
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c        |    6 --
 4 files changed, 14 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/bounds_deduction.c
+++ b/tools/testing/selftests/bpf/verifier/bounds_deduction.c
@@ -6,7 +6,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -21,7 +21,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 1,
@@ -34,22 +34,23 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 4",
 	.insns = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_JMP_IMM(BPF_JSLE, BPF_REG_0, 0, 1),
 		BPF_EXIT_INSN(),
 		BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
 		BPF_EXIT_INSN(),
-		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
+		BPF_ALU64_REG(BPF_SUB, BPF_REG_6, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R6 has pointer with unsupported alu operation",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
@@ -61,7 +62,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -74,7 +75,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -88,7 +89,7 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "dereference of modified ctx ptr",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
@@ -103,7 +104,7 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "dereference of modified ctx ptr",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
@@ -116,7 +117,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
--- a/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
+++ b/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
@@ -19,7 +19,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -43,7 +42,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -69,7 +67,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -94,7 +91,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -141,7 +137,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -210,7 +205,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -260,7 +254,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -287,7 +280,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -313,7 +305,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -342,7 +333,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -372,7 +362,6 @@
 	},
 	.fixup_map_hash_8b = { 4 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -400,7 +389,5 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
-	.result_unpriv = REJECT,
 },
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -503,7 +503,7 @@
 	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -21,8 +21,6 @@
 	.fixup_map_hash_16b = { 5 },
 	.fixup_map_array_48b = { 8 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R1 tried to add from different maps",
 	.retval = 1,
 },
 {
@@ -122,7 +120,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different pointers or scalars",
+	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
 	.retval = 0,
 },
 {
@@ -169,7 +167,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
 	.retval = 0,
 },
 {


