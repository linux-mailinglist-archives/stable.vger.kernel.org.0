Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98DD395C76
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhEaNdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhEaNbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F9C613B4;
        Mon, 31 May 2021 13:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467408;
        bh=qOG2WQlrocDbMaxMioSKn/8oclNT3wYn/6aiNmiOFyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvGDIfgNb9kZWJ8lciMhailfkaKYBbrJSC3Cgi5Ntj7FAeIkjgzoxZ6gOflVgsHn+
         yd0Gp6DZPTv5Z+hT9NA/0acDWRg/Ksv2hPkAnhfEVDeEBg7LuetR8wRXZZtQdxBEUS
         la3T2f3BWMe2C06qwSdzYOoqf0z4d1flDPEWdsNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 054/116] bpf: Update selftests to reflect new error states
Date:   Mon, 31 May 2021 15:13:50 +0200
Message-Id: <20210531130642.004430887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d7a5091351756d0ae8e63134313c455624e36a13 upstream

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
[OP: 4.19 backport, account for split test_verifier and
different / missing tests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   35 +++++++++-------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2873,7 +2873,7 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
@@ -7501,7 +7501,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7526,7 +7525,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7553,7 +7551,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7579,7 +7576,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7628,7 +7624,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7700,7 +7695,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7752,7 +7746,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7780,7 +7773,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7807,7 +7799,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7837,7 +7828,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7868,7 +7858,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 4 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -7897,7 +7886,6 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
-		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -9799,7 +9787,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9814,7 +9802,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 1,
@@ -9827,22 +9815,23 @@ static struct bpf_test tests[] = {
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
@@ -9854,7 +9843,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9867,7 +9856,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},
@@ -9881,7 +9870,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -9895,7 +9884,7 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, mark)),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "dereference of modified ctx ptr",
 		.result = REJECT,
 	},
@@ -9907,7 +9896,7 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+		.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 		.errstr = "R0 tried to subtract pointer from scalar",
 		.result = REJECT,
 	},


