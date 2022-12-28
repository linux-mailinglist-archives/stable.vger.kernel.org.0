Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC654657EB5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiL1P4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiL1P4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:56:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1F7D98
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE246B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF07C433EF;
        Wed, 28 Dec 2022 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242990;
        bh=Lmcw3TOe2AlptIzFhBZvvS38VLzYip5lBfUY/kKNdNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dW0bPJ1rj84pnTubB+FvwyqwK47dPoqaLVKDTeL6fbfo6hsJCUB+1Zm+fvtfhwt2X
         AnEbDv5Ywf86gXrZPxLEa3TAYmZ7Q/8wCu+P6Hb8Vprcy0M2aCk/evNvxRa8hfIU+v
         bEdhnbZLO4DPmIVhrldXae2qDzD/k59m4QaKEXlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Pu Lehui <pulehui@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0476/1073] riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC
Date:   Wed, 28 Dec 2022 15:34:24 +0100
Message-Id: <20221228144340.965877667@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit b54b6003612a376e7be32cbc5c1af3754bbbbb3d ]

For BPF_PSEUDO_FUNC instruction, verifier will refill imm with
correct addresses of bpf_calls and then run last pass of JIT.
Since the emit_imm of RV64 is variable-length, which will emit
appropriate length instructions accorroding to the imm, it may
broke ctx->offset, and lead to unpredictable problem, such as
inaccurate jump. So let's fix it with fixed-length instructions.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Suggested-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20221206091410.1584784-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 00df3a8f92ac..f2417ac54edd 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -136,6 +136,25 @@ static bool in_auipc_jalr_range(s64 val)
 		val < ((1L << 31) - (1L << 11));
 }
 
+/* Emit fixed-length instructions for address */
+static int emit_addr(u8 rd, u64 addr, bool extra_pass, struct rv_jit_context *ctx)
+{
+	u64 ip = (u64)(ctx->insns + ctx->ninsns);
+	s64 off = addr - ip;
+	s64 upper = (off + (1 << 11)) >> 12;
+	s64 lower = off & 0xfff;
+
+	if (extra_pass && !in_auipc_jalr_range(off)) {
+		pr_err("bpf-jit: target offset 0x%llx is out of range\n", off);
+		return -ERANGE;
+	}
+
+	emit(rv_auipc(rd, upper), ctx);
+	emit(rv_addi(rd, rd, lower), ctx);
+	return 0;
+}
+
+/* Emit variable-length instructions for 32-bit and 64-bit imm */
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -1050,7 +1069,15 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_imm(rd, imm64, ctx);
+		if (bpf_pseudo_func(insn)) {
+			/* fixed-length insns for extra jit pass */
+			ret = emit_addr(rd, imm64, extra_pass, ctx);
+			if (ret)
+				return ret;
+		} else {
+			emit_imm(rd, imm64, ctx);
+		}
+
 		return 1;
 	}
 
-- 
2.35.1



