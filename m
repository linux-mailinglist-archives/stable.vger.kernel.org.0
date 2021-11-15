Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CBC451FA7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350620AbhKPAoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343727AbhKOTVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E383635D5;
        Mon, 15 Nov 2021 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001905;
        bh=1InN7D+Ew/U5KubiRBjbG77i9WwLWqSxHEm+CPX0evA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKpeERLBoS43i2fot9SH/nAO6cHWxWrrzzNuBgZ4ue0nIF1Lp6VRpNF4YL2tYDKJ3
         LIMlzhWYDSpftqlLHql4wyIps+PdmpEsZD5KSSUlPH4KHGr7uB465E9HRCRjIyqMDW
         DMFGQZ2Wn9LJ6mPUu+DA1TPjA9OrKI4oY6S9Zkpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Chaignon <paul@cilium.io>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/917] bpf/tests: Fix error in tail call limit tests
Date:   Mon, 15 Nov 2021 17:57:40 +0100
Message-Id: <20211115165441.138270904@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 18935a72eb25525b655262579e1652362a3b29bb ]

This patch fixes an error in the tail call limit test that caused the
test to fail on for x86-64 JIT. Previously, the register R0 was used to
report the total number of tail calls made. However, after a tail call
fall-through, the value of the R0 register is undefined. Now, all tail
call error path tests instead use context state to store the count.

Fixes: 874be05f525e ("bpf, tests: Add tail call test suite")
Reported-by: Paul Chaignon <paul@cilium.io>
Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/bpf/20210914091842.4186267-14-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 830a18ecffc88..68d125b409f20 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8992,10 +8992,15 @@ static __init int test_bpf(void)
 struct tail_call_test {
 	const char *descr;
 	struct bpf_insn insns[MAX_INSNS];
+	int flags;
 	int result;
 	int stack_depth;
 };
 
+/* Flags that can be passed to tail call test cases */
+#define FLAG_NEED_STATE		BIT(0)
+#define FLAG_RESULT_IN_STATE	BIT(1)
+
 /*
  * Magic marker used in test snippets for tail calls below.
  * BPF_LD/MOV to R2 and R2 with this immediate value is replaced
@@ -9065,32 +9070,38 @@ static struct tail_call_test tail_call_tests[] = {
 	{
 		"Tail call error path, max count reached",
 		.insns = {
-			BPF_ALU64_IMM(BPF_ADD, R1, 1),
-			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_LDX_MEM(BPF_W, R2, R1, 0),
+			BPF_ALU64_IMM(BPF_ADD, R2, 1),
+			BPF_STX_MEM(BPF_W, R1, R2, 0),
 			TAIL_CALL(0),
 			BPF_EXIT_INSN(),
 		},
-		.result = MAX_TAIL_CALL_CNT + 1,
+		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
+		.result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
 	},
 	{
 		"Tail call error path, NULL target",
 		.insns = {
-			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			BPF_LDX_MEM(BPF_W, R2, R1, 0),
+			BPF_ALU64_IMM(BPF_ADD, R2, 1),
+			BPF_STX_MEM(BPF_W, R1, R2, 0),
 			TAIL_CALL(TAIL_CALL_NULL),
-			BPF_ALU64_IMM(BPF_MOV, R0, 1),
 			BPF_EXIT_INSN(),
 		},
-		.result = 1,
+		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
+		.result = MAX_TESTRUNS,
 	},
 	{
 		"Tail call error path, index out of range",
 		.insns = {
-			BPF_ALU64_IMM(BPF_MOV, R0, -1),
+			BPF_LDX_MEM(BPF_W, R2, R1, 0),
+			BPF_ALU64_IMM(BPF_ADD, R2, 1),
+			BPF_STX_MEM(BPF_W, R1, R2, 0),
 			TAIL_CALL(TAIL_CALL_INVALID),
-			BPF_ALU64_IMM(BPF_MOV, R0, 1),
 			BPF_EXIT_INSN(),
 		},
-		.result = 1,
+		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
+		.result = MAX_TESTRUNS,
 	},
 };
 
@@ -9196,6 +9207,8 @@ static __init int test_tail_calls(struct bpf_array *progs)
 	for (i = 0; i < ARRAY_SIZE(tail_call_tests); i++) {
 		struct tail_call_test *test = &tail_call_tests[i];
 		struct bpf_prog *fp = progs->ptrs[i];
+		int *data = NULL;
+		int state = 0;
 		u64 duration;
 		int ret;
 
@@ -9212,7 +9225,11 @@ static __init int test_tail_calls(struct bpf_array *progs)
 		if (fp->jited)
 			jit_cnt++;
 
-		ret = __run_one(fp, NULL, MAX_TESTRUNS, &duration);
+		if (test->flags & FLAG_NEED_STATE)
+			data = &state;
+		ret = __run_one(fp, data, MAX_TESTRUNS, &duration);
+		if (test->flags & FLAG_RESULT_IN_STATE)
+			ret = state;
 		if (ret == test->result) {
 			pr_cont("%lld PASS", duration);
 			pass_cnt++;
-- 
2.33.0



