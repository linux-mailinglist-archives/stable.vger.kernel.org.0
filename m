Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08B4370583
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 06:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhEAEbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 00:31:10 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:40401 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhEAEbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 00:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619843420; x=1651379420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jPPn/7vz4skcdKKfXFA/l1Q2YdevheSy2Ys5Z2AS2Ok=;
  b=E2z39KotpPbCOztKpacB90vDyMDn4OQ0Ai48j1hkF1JPQtED6DoTRA4O
   oxvdlQM24HRWJX/kivWsUEj78+Dr7RKpthcl3SA98aH0ZMXogEH8lfqUK
   tkhG32o0jkX6Cbq1YSoYFCdhYhp5Pr9rfM7QWwS6dxo5wUSbwH5WuEUfo
   4=;
X-IronPort-AV: E=Sophos;i="5.82,264,1613433600"; 
   d="scan'208";a="110970699"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 01 May 2021 04:30:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 0BCE5240A7A;
        Sat,  1 May 2021 04:30:15 +0000 (UTC)
Received: from EX13D01UWB001.ant.amazon.com (10.43.161.75) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d01UWB001.ant.amazon.com (10.43.161.75) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 04:30:15 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 04:30:15 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 40B43B52; Sat,  1 May 2021 04:30:14 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <samjonas@amazon.com>
Subject: [PATCH 4.14 11/15] bpf: Update selftests to reflect new error states
Date:   Sat, 1 May 2021 04:30:10 +0000
Message-ID: <20210501043014.33300-12-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210501043014.33300-1-fllinden@amazon.com>
References: <20210501043014.33300-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Upstream commit d7a5091351756d0ae8e63134313c455624e36a13

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
---
 tools/testing/selftests/bpf/test_verifier.c | 34 ++++++++-------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 43d91b2d2a21..bab9942b20b2 100644
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
-- 
2.23.3

