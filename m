Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A536F266
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 00:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhD2WJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 18:09:28 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:24150 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhD2WJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 18:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619734121; x=1651270121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L66IWBysSlzunmTeAdjPIGA1aXDT/WuvcDYxnTtmUYo=;
  b=pICOjS9jmu+MCeuSvOwaO5t6r53fTIi9FWzqZUbcvcPC2TIQM0U0bdB7
   ovDCs+us8H4Q0w91P4MFmmoJF/zTUbMAdSgC41ct5xGgAJbffHFQII0o/
   2Od9E8C5wF9DZnyDMhtSoq/2buYDEITmJdgidHGjEBbhx2UB+w/oYU+ZL
   8=;
X-IronPort-AV: E=Sophos;i="5.82,260,1613433600"; 
   d="scan'208";a="930209832"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 29 Apr 2021 22:08:41 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id D1DF7A0657;
        Thu, 29 Apr 2021 22:08:40 +0000 (UTC)
Received: from EX13D06UEA004.ant.amazon.com (10.43.61.121) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D06UEA004.ant.amazon.com (10.43.61.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 22:08:40 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 22:08:40 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id D3588972; Thu, 29 Apr 2021 22:08:39 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>
Subject: [PATCH 5.4 8/8] bpf: Update selftests to reflect new error states
Date:   Thu, 29 Apr 2021 22:08:39 +0000
Message-ID: <20210429220839.15667-9-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
In-Reply-To: <20210429220839.15667-1-fllinden@amazon.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
---
 .../selftests/bpf/verifier/bounds_deduction.c | 21 ++++++++++---------
 .../bpf/verifier/bounds_mix_sign_unsign.c     | 13 ------------
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c  |  6 ++----
 4 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds_deduction.c b/tools/testing/selftests/bpf/verifier/bounds_deduction.c
index c162498a64fc..91869aea6d64 100644
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
diff --git a/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c b/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
index 9baca7a75c42..c2aa6f26738b 100644
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
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index 0d621c841db1..c3f6f650deb7 100644
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
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 00b59d5d7a7f..28d44e6aa0b7 100644
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
-- 
2.23.3

