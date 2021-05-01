Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA65370580
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhEAEbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:09 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:18532 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhEAEbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843420; x=1651379420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bo04P3Yzf88/4NOLOe0xaMx4v4L4XwfGIuNfYgibCJ4=;
  b=B+TuXWf5g9Cfq3y47mreJ+j7AM1VmTv2ThPAL2B2J85SB75BpaVJDp15
   iosh9GdMiHwWCArRjysZ5+wqcSdAQfq/2b5FhrXU7Rfskp6lpuSIRdVH7
   aGZHrQE7l3zIHXnr8JnmOYoC5bM21UPsZ25sJo/AZDSQRnlFJU/H7Swmm
   M=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="123084989"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 01 May 2021 04:30:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 02D23C018F;
        Sat,  1 May 2021 04:30:15 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 3FB3DDDC; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 03/15] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Sat, 1 May 2021 04:30:02 +0000
Message-ID: <20210501043014.33300-4-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

Upstream commit 0a13e3537ea67452d549a6a80da3776d6b7dedb3

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
---
 tools/testing/selftests/bpf/test_verifier.c | 44 ++++++++++++++++-----
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9f7fc30d247d..43d91b2d2a21 100644
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
-- 
2.23.3

