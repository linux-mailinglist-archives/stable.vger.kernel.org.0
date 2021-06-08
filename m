Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7047F39FFAB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhFHSfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234265AbhFHSdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C21613CA;
        Tue,  8 Jun 2021 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177086;
        bh=CV+6Ms9cUJpKJzjA46fy1qFGH4maCBS2w+i1QK2Dxfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6GoQcWB4CwlbC4Dz1KVzvjySN6Om6n8yAWPFOrlln+nTTzY7q0qPLht9haPSkiZv
         dfAUKE1ZXKBTXJK67aciDns/oMxfffEFqGqe78vKxje3IdN9aoQ1C6XXTEF1cwaLwR
         Z04QM/fjIIpu+v1aGotEiSx7SI/lMiy3cMYuwi00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 27/47] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Tue,  8 Jun 2021 20:27:10 +0200
Message-Id: <20210608175931.369868233@linuxfoundation.org>
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
[fllinden@amazon.com: backport to 4.14, skipping non-existent tests]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   44 +++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2235,7 +2235,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"unpriv: adding of fp",
+		"unpriv: adding of fp, reg",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
@@ -2243,9 +2243,22 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
-		.result = ACCEPT,
+		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
 		.result_unpriv = REJECT,
+		.result = ACCEPT,
+	},
+	{
+		"unpriv: adding of fp, imm",
+		.insns = {
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0),
+			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
+			BPF_EXIT_INSN(),
+		},
 		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
 	},
 	{
 		"unpriv: cmp of stack pointer",
@@ -7766,8 +7779,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 2",
@@ -7780,6 +7794,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -7790,8 +7806,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 4",
@@ -7804,6 +7821,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -7814,8 +7833,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 6",
@@ -7826,8 +7846,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 7",
@@ -7839,8 +7860,9 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "dereference of modified ctx ptr",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 8",
@@ -7852,8 +7874,9 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
 		.errstr = "dereference of modified ctx ptr",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 9",
@@ -7863,8 +7886,9 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
+		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
 		.errstr = "R0 tried to subtract pointer from scalar",
+		.result = REJECT,
 	},
 	{
 		"check deducing bounds from const, 10",
@@ -7876,8 +7900,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
 		.errstr = "math between ctx pointer and register with unbounded min value is not allowed",
+		.result = REJECT,
 	},
 	{
 		"XDP pkt read, pkt_end <= pkt_data', bad access 2",


