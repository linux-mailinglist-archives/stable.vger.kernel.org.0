Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6655E6AE9C3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjCGR1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjCGR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475529C99C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F61611A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD400C4339B;
        Tue,  7 Mar 2023 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209732;
        bh=DnzysaGZBjVQCIUX9rF6rBbtTkXGZeN4zPjwDCD6FxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxAlmWih9g1FshUGHbgl3ACmXylujQiOKwxZe79quZlmhce9Jb52+I708gA0FaZiT
         MvY8UB4CNOZqCgAggdx/yeJsikNmYVnlUkTY6olmxofUhLzz1gEF/rCEGHJlxrJJKS
         F9rGUbuPTnAqpliziDx4ALimmcB+GZNL+tGABmSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hengqi Chen <hengqi.chen@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0313/1001] LoongArch, bpf: Use 4 instructions for function address in JIT
Date:   Tue,  7 Mar 2023 17:51:25 +0100
Message-Id: <20230307170035.135545645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index c4b1947ebf768..288003a9f0cae 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -841,7 +841,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 		if (ret < 0)
 			return ret;
 
-		move_imm(ctx, t1, func_addr, is32);
+		move_addr(ctx, t1, func_addr);
 		emit_insn(ctx, jirl, t1, LOONGARCH_GPR_RA, 0);
 		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
 		break;
diff --git a/arch/loongarch/net/bpf_jit.h b/arch/loongarch/net/bpf_jit.h
index ca708024fdd3e..c335dc4eed370 100644
--- a/arch/loongarch/net/bpf_jit.h
+++ b/arch/loongarch/net/bpf_jit.h
@@ -82,6 +82,27 @@ static inline void emit_sext_32(struct jit_ctx *ctx, enum loongarch_gpr reg, boo
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



