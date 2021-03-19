Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB38341C35
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCSMTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhCSMTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C01864F65;
        Fri, 19 Mar 2021 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156357;
        bh=Qib/cu8GzEJrFkRn31c2O7ueeL+3hwFVBYr+dcAPL9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hr9JqIqTtuMkhRe3rxGlKavvyxyRXVKVGNL3nN7VNcef8U67UL0ZL860C55YdAHWI
         Nom2jA094OqzcHLcIh0VhMFybTsl8Vn1rfUrEBejk+w0g6e9GhJybXKAPOdF10D1gw
         Cv5dTVskKHAjZK15JLgb7DouFA2nyvXr3FsfMp+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 06/18] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Fri, 19 Mar 2021 13:18:44 +0100
Message-Id: <20210319121745.669914787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit 0a13e3537ea67452d549a6a80da3776d6b7dedb3 upstream.

Fix up test_verifier error messages for the case where the original error
message changed, or for the case where pointer alu errors differ between
privileged and unprivileged tests. Also, add alternative tests for keeping
coverage of the original verifier rejection error message (fp alu), and
newly reject map_ptr += rX where rX == 0 given we now forbid alu on these
types for unprivileged. All test_verifier cases pass after the change. The
test case fixups were kept separate to ease backporting of core changes.

Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/verifier/bounds_deduction.c |   27 +++++++++++-----
 tools/testing/selftests/bpf/verifier/unpriv.c           |   15 ++++++++
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c  |   23 +++++++++++++
 3 files changed, 55 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/bpf/verifier/bounds_deduction.c
+++ b/tools/testing/selftests/bpf/verifier/bounds_deduction.c
@@ -6,8 +6,9 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "R0 tried to subtract pointer from scalar",
+	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 2",
@@ -20,6 +21,8 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 1,
 },
@@ -31,8 +34,9 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "R0 tried to subtract pointer from scalar",
+	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 4",
@@ -45,6 +49,8 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
 {
@@ -55,8 +61,9 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "R0 tried to subtract pointer from scalar",
+	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 6",
@@ -67,8 +74,9 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "R0 tried to subtract pointer from scalar",
+	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 7",
@@ -80,8 +88,9 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "dereference of modified ctx ptr",
+	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -94,8 +103,9 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
 	.errstr = "dereference of modified ctx ptr",
+	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
@@ -106,8 +116,9 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
+	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 	.errstr = "R0 tried to subtract pointer from scalar",
+	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 10",
@@ -119,6 +130,6 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.result = REJECT,
 	.errstr = "math between ctx pointer and register with unbounded min value is not allowed",
+	.result = REJECT,
 },
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -495,7 +495,7 @@
 	.result = ACCEPT,
 },
 {
-	"unpriv: adding of fp",
+	"unpriv: adding of fp, reg",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_1, 0),
@@ -503,6 +503,19 @@
 	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 	BPF_EXIT_INSN(),
 	},
+	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
+{
+	"unpriv: adding of fp, imm",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0),
+	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
+	BPF_EXIT_INSN(),
+	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -169,7 +169,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps or paths",
+	.errstr_unpriv = "R2 tried to add from different maps, paths, or prohibited types",
 	.retval = 0,
 },
 {
@@ -517,6 +517,27 @@
 	.retval = 0xabcdef12,
 },
 {
+	"map access: value_ptr += N, value_ptr -= N known scalar",
+	.insns = {
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
+	BPF_MOV32_IMM(BPF_REG_1, 0x12345678),
+	BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 0),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 2),
+	BPF_MOV64_IMM(BPF_REG_1, 2),
+	BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_array_48b = { 3 },
+	.result = ACCEPT,
+	.retval = 0x12345678,
+},
+{
 	"map access: unknown scalar += value_ptr, 1",
 	.insns = {
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),


