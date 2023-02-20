Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC25D69CDF7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjBTNyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjBTNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857B01E1E2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 172CC60EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CA9C433EF;
        Mon, 20 Feb 2023 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901278;
        bh=z6P+nbavqPCCSnqZJNVDs0VWHj0jFLX6EBinl3xYbdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikoTrNQlc49wI7QN+LrLrmgBygRlEo1vk8ndnHQqQjx0S7IpUtORN9YyXvAlrXvHD
         CmrbwLn4CEU8ytllboyvEO4cV954uJgHT+UCs3h1p+VGmIDhpuRMaUDrdJZBgGArWC
         btwIEk1PZsHCP/LABKl52hCXWdxUn+u5ZtBtIoNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/57] selftests/bpf: Verify copy_register_state() preserves parent/live fields
Date:   Mon, 20 Feb 2023 14:36:10 +0100
Message-Id: <20230220133549.443130670@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 7e50cb80873a5..7e36078f8f482 100644
--- a/tools/testing/selftests/bpf/verifier/search_pruning.c
+++ b/tools/testing/selftests/bpf/verifier/search_pruning.c
@@ -154,3 +154,39 @@
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



