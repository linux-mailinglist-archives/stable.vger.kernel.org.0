Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA2690652
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjBILQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjBILPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF95611FD;
        Thu,  9 Feb 2023 03:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C8E161A18;
        Thu,  9 Feb 2023 11:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885B2C433EF;
        Thu,  9 Feb 2023 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941331;
        bh=AaIeNztZETm3XHMGdo+mMQ5+5jHu/pRFxpqdKXj9vvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVhd5O1A+cQHXlzU0PWhu8Tk0OrDrBaBeN51uHe8nQFyUznOB0lqy9vBWhw288wYa
         sELO1e4OKqEev+9W4jwVu+CPwcgCzJh3V83Dtv4/r/bgbag9clTlraes+f+4npy0wX
         AEL5HRDRqfYFHC4hiUV5uQiUoDhliM58lTpXayrJOzB1vfQlU6byFf8F7cPbKYRZtB
         FaGQs1Avtu5+A4PCdImIP/w2N7HNKVZ/r1dzZeOj1kNS8Hyx2BPhto4G9xxLxSF8aV
         hnuAVjfl5YG5RBgNLNGeVbwCmUI3RSJ3Rj6Zp31XvhhtkWtKZ9s+5zaG9FvjHyzitS
         ZR1ZrUkpRJDaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eduard Zingerman <eddyz87@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, shuah@kernel.org, mykolal@fb.com,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/38] selftests/bpf: Verify copy_register_state() preserves parent/live fields
Date:   Thu,  9 Feb 2023 06:14:27 -0500
Message-Id: <20230209111459.1891941-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit b9fa9bc839291020b362ab5392e5f18ba79657ac ]

A testcase to check that verifier.c:copy_register_state() preserves
register parentage chain and livness information.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20230106142214.1040390-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/verifier/search_pruning.c   | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/search_pruning.c b/tools/testing/selftests/bpf/verifier/search_pruning.c
index 68b14fdfebdb1..d63fd8991b03a 100644
--- a/tools/testing/selftests/bpf/verifier/search_pruning.c
+++ b/tools/testing/selftests/bpf/verifier/search_pruning.c
@@ -225,3 +225,39 @@
 	.result_unpriv = ACCEPT,
 	.insn_processed = 15,
 },
+/* The test performs a conditional 64-bit write to a stack location
+ * fp[-8], this is followed by an unconditional 8-bit write to fp[-8],
+ * then data is read from fp[-8]. This sequence is unsafe.
+ *
+ * The test would be mistakenly marked as safe w/o dst register parent
+ * preservation in verifier.c:copy_register_state() function.
+ *
+ * Note the usage of BPF_F_TEST_STATE_FREQ to force creation of the
+ * checkpoint state after conditional 64-bit assignment.
+ */
+{
+	"write tracking and register parent chain bug",
+	.insns = {
+	/* r6 = ktime_get_ns() */
+	BPF_EMIT_CALL(BPF_FUNC_ktime_get_ns),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	/* r0 = ktime_get_ns() */
+	BPF_EMIT_CALL(BPF_FUNC_ktime_get_ns),
+	/* if r0 > r6 goto +1 */
+	BPF_JMP_REG(BPF_JGT, BPF_REG_0, BPF_REG_6, 1),
+	/* *(u64 *)(r10 - 8) = 0xdeadbeef */
+	BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 0xdeadbeef),
+	/* r1 = 42 */
+	BPF_MOV64_IMM(BPF_REG_1, 42),
+	/* *(u8 *)(r10 - 8) = r1 */
+	BPF_STX_MEM(BPF_B, BPF_REG_FP, BPF_REG_1, -8),
+	/* r2 = *(u64 *)(r10 - 8) */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_FP, -8),
+	/* exit(0) */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.errstr = "invalid read from stack off -8+1 size 8",
+	.result = REJECT,
+},
-- 
2.39.0

