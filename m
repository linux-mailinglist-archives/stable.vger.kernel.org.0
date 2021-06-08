Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDE539FFC7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbhFHSgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhFHSem (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C85E6136D;
        Tue,  8 Jun 2021 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177107;
        bh=xOS2PbQ2jw+mG5w9NoOKZXEQ4ElpEmkbT3G7YRh6QW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOp2MHonw65/dwCAv+3mai3e3+dlaERsUHaiPitM2T4WvaXglgUQU27JLQ7IAiFgZ
         XGanYKhQIU7qAnRjIgoTTXdGRoNRy5ylLQG9JV5dL1dMcJBeIs//txoyHivAJPGQal
         8vOD7MfJtKk6sHQISF2guLAHq+d+dDCVmukDKAWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 35/47] bpf: Update selftests to reflect new error states
Date:   Tue,  8 Jun 2021 20:27:18 +0200
Message-Id: <20210608175931.630730855@linuxfoundation.org>
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
[fllinden@amazon.com - 4.14 backport, account for split test_verifier and
different / missing tests]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   34 +++++++++-------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2243,7 +2243,7 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -6220,7 +6220,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6245,7 +6244,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6272,7 +6270,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6298,7 +6295,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6347,7 +6343,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6419,7 +6414,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6471,7 +6465,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6499,7 +6492,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6526,7 +6518,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6556,7 +6547,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6615,7 +6605,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -7779,7 +7768,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -7794,7 +7783,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -7806,22 +7795,23 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 4",
 		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_JMP_IMM(BPF_JSLE, BPF_REG_0, 0, 1),
 			BPF_EXIT_INSN(),
 			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
 			BPF_EXIT_INSN(),
-			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
+			BPF_ALU64_REG(BPF_SUB, BPF_REG_6, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R6 has pointer with unsupported alu operation",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -7833,7 +7823,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -7846,7 +7836,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -7860,7 +7850,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -7874,7 +7864,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -7886,7 +7876,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},


