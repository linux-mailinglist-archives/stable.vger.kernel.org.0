Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8166AEEEA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjCGSST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCGSRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:17:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDFA91B55
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2B59B819C1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF69C4339B;
        Tue,  7 Mar 2023 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212735;
        bh=yb1h0VR3IbDMaA4+EsRACoGnUEk3F+0NQAQopa10+DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCRQ3oHGQ27QdB/PEASwSsjPaeN+QNo3rW9ND+I5mGWX/AFVCJH4LUmsrEw5PQANK
         UolwFWGteucHki2ouXodjZnrtTJFrfLjS9WAjPkialSDhlWb8RJJxXmv+11+QzqOti
         gBSwla8m4BCEcT3ekP6OiQop4TLGYgpRoi+5CPKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hengqi Chen <hengqi.chen@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/885] LoongArch, bpf: Use 4 instructions for function address in JIT
Date:   Tue,  7 Mar 2023 17:53:04 +0100
Message-Id: <20230307170012.866296231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit 64f50f6575721ef03d001e907455cbe3baa2a5b1 ]

This patch fixes the following issue of function calls in JIT, like:

  [   29.346981] multi-func JIT bug 105 != 103

The issus can be reproduced by running the "inline simple bpf_loop call"
verifier test.

This is because we are emiting 2-4 instructions for 64-bit immediate moves.
During the first pass of JIT, the placeholder address is zero, emiting two
instructions for it. In the extra pass, the function address is in XKVRANGE,
emiting four instructions for it. This change the instruction index in
JIT context. Let's always use 4 instructions for function address in JIT.
So that the instruction sequences don't change between the first pass and
the extra pass for function calls.

Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/bpf/20230214152633.2265699-1-hengqi.chen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c |  2 +-
 arch/loongarch/net/bpf_jit.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index bdcd0c7719a9e..2467bfb8889a9 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -782,7 +782,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 		if (ret < 0)
 			return ret;
 
-		move_imm(ctx, t1, func_addr, is32);
+		move_addr(ctx, t1, func_addr);
 		emit_insn(ctx, jirl, t1, LOONGARCH_GPR_RA, 0);
 		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
 		break;
diff --git a/arch/loongarch/net/bpf_jit.h b/arch/loongarch/net/bpf_jit.h
index e665ddb0aeb85..093885539e701 100644
--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -80,6 +80,27 @@ static inline void emit_sext_32(struct jit_ctx *ctx, enum loongarch_gpr reg, boo
 	emit_insn(ctx, addiw, reg, reg, 0);
 }
 
+static inline void move_addr(struct jit_ctx *ctx, enum loongarch_gpr rd, u64 addr)
+{
+	u64 imm_11_0, imm_31_12, imm_51_32, imm_63_52;
+
+	/* lu12iw rd, imm_31_12 */
+	imm_31_12 = (addr >> 12) & 0xfffff;
+	emit_insn(ctx, lu12iw, rd, imm_31_12);
+
+	/* ori rd, rd, imm_11_0 */
+	imm_11_0 = addr & 0xfff;
+	emit_insn(ctx, ori, rd, rd, imm_11_0);
+
+	/* lu32id rd, imm_51_32 */
+	imm_51_32 = (addr >> 32) & 0xfffff;
+	emit_insn(ctx, lu32id, rd, imm_51_32);
+
+	/* lu52id rd, rd, imm_63_52 */
+	imm_63_52 = (addr >> 52) & 0xfff;
+	emit_insn(ctx, lu52id, rd, rd, imm_63_52);
+}
+
 static inline void move_imm(struct jit_ctx *ctx, enum loongarch_gpr rd, long imm, bool is32)
 {
 	long imm_11_0, imm_31_12, imm_51_32, imm_63_52, imm_51_0, imm_51_31;
-- 
2.39.2



