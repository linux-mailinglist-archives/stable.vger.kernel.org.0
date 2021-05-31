Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50066395C5B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhEaNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhEaN3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9188F6142B;
        Mon, 31 May 2021 13:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467372;
        bh=bdfiguuJ0P4y4AyYwLBP0DPKjU1IzoDfx/j91ulOC9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJIBS1pKL/DliGYiLiMIq0EeDEPo4fXTLES3MG3J7FIlXCek1/D62kHr/Pf+5fbwA
         8gR5B/IBlg4dh9lfdA+drFpbYO2y1R28L3WB7iIRHWCnb74D7C/jorW+e6mUgRREQB
         XcuEPcg6R1l7UjlLScYqnthNjkH1saJw+kdXnI/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 041/116] bpf, selftests: Fix up some test_verifier cases for unprivileged
Date:   Mon, 31 May 2021 15:13:37 +0200
Message-Id: <20210531130641.556303903@linuxfoundation.org>
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

From: Piotr Krysiuk <piotras@gmail.com>

commit 0a13e3537ea67452d549a6a80da3776d6b7dedb3 upstream

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
[OP: backport to 4.19, skipping non-existent tests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   42 ++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2837,7 +2837,7 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 	},
 	{
-		"unpriv: adding of fp",
+		"unpriv: adding of fp, reg",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
@@ -2845,6 +2845,19 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+	},
+	{
+		"unpriv: adding of fp, imm",
+		.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 0),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
+		BPF_EXIT_INSN(),
+		},
 		.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 		.result_unpriv = REJECT,
 		.result = ACCEPT,
@@ -9758,8 +9771,9 @@ static struct bpf_test tests[] = {
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
@@ -9772,6 +9786,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 1,
 	},
@@ -9783,8 +9799,9 @@ static struct bpf_test tests[] = {
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
@@ -9797,6 +9814,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 	},
 	{
@@ -9807,8 +9826,9 @@ static struct bpf_test tests[] = {
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
@@ -9819,8 +9839,9 @@ static struct bpf_test tests[] = {
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
@@ -9832,8 +9853,9 @@ static struct bpf_test tests[] = {
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
@@ -9845,8 +9867,9 @@ static struct bpf_test tests[] = {
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
@@ -9856,8 +9879,9 @@ static struct bpf_test tests[] = {
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
@@ -9869,8 +9893,8 @@ static struct bpf_test tests[] = {
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-		.result = REJECT,
 		.errstr = "math between ctx pointer and register with unbounded min value is not allowed",
+		.result = REJECT,
 	},
 	{
 		"bpf_exit with invalid return code. test1",


