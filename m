Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0C6949BE
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjBMPBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjBMPBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:01:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7971D90F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5374C6116A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3B2C433EF;
        Mon, 13 Feb 2023 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300466;
        bh=+hoUKtyQQs93+XIhEBfSYCitFULRI/YKwOtWvZUUf2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYndZaIAdfm0rQuiN8LaEV6kYxHzUO3fdrIBBvd1Jb6+XQB1C18K5QGm8WJpL2BUb
         8VyNaiSI4N7+AP3nTP2+Ei87YoX8exS43MS+FKB2AD93JcLVucAdDu/RiqnDVfKAQD
         H7jcsUFbOBAHSHXP+qrseizXY2/vEkoKEGBmzPWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/139] powerpc/bpf: Change register numbering for bpf_set/is_seen_register()
Date:   Mon, 13 Feb 2023 15:49:12 +0100
Message-Id: <20230213144746.063364820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit ed573b57e77a7860fe4026e1700faa2f6938caf1 ]

Instead of using BPF register number as input in functions
bpf_set_seen_register() and bpf_is_seen_register(), use
CPU register number directly.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0cd2506f598e7095ea43e62dca1f472de5474a0d.1616430991.git.christophe.leroy@csgroup.eu
Stable-dep-of: 71f656a50176 ("bpf: Fix to preserve reg parent/live fields when copying range info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp64.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 0d47514e8870..7da59ddc90dd 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -32,12 +32,12 @@ static inline void bpf_flush_icache(void *start, void *end)
 
 static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
 {
-	return (ctx->seen & (1 << (31 - b2p[i])));
+	return ctx->seen & (1 << (31 - i));
 }
 
 static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
 {
-	ctx->seen |= (1 << (31 - b2p[i]));
+	ctx->seen |= 1 << (31 - i);
 }
 
 static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
@@ -48,7 +48,7 @@ static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
 	 * - the bpf program uses its stack area
 	 * The latter condition is deduced from the usage of BPF_REG_FP
 	 */
-	return ctx->seen & SEEN_FUNC || bpf_is_seen_register(ctx, BPF_REG_FP);
+	return ctx->seen & SEEN_FUNC || bpf_is_seen_register(ctx, b2p[BPF_REG_FP]);
 }
 
 /*
@@ -125,11 +125,11 @@ static void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 	 * in the protected zone below the previous stack frame
 	 */
 	for (i = BPF_REG_6; i <= BPF_REG_10; i++)
-		if (bpf_is_seen_register(ctx, i))
+		if (bpf_is_seen_register(ctx, b2p[i]))
 			PPC_BPF_STL(b2p[i], 1, bpf_jit_stack_offsetof(ctx, b2p[i]));
 
 	/* Setup frame pointer to point to the bpf stack area */
-	if (bpf_is_seen_register(ctx, BPF_REG_FP))
+	if (bpf_is_seen_register(ctx, b2p[BPF_REG_FP]))
 		EMIT(PPC_RAW_ADDI(b2p[BPF_REG_FP], 1,
 				STACK_FRAME_MIN_SIZE + ctx->stack_size));
 }
@@ -140,7 +140,7 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 
 	/* Restore NVRs */
 	for (i = BPF_REG_6; i <= BPF_REG_10; i++)
-		if (bpf_is_seen_register(ctx, i))
+		if (bpf_is_seen_register(ctx, b2p[i]))
 			PPC_BPF_LL(b2p[i], 1, bpf_jit_stack_offsetof(ctx, b2p[i]));
 
 	/* Tear down our stack frame */
@@ -356,9 +356,9 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 * any issues.
 		 */
 		if (dst_reg >= BPF_PPC_NVR_MIN && dst_reg < 32)
-			bpf_set_seen_register(ctx, insn[i].dst_reg);
+			bpf_set_seen_register(ctx, dst_reg);
 		if (src_reg >= BPF_PPC_NVR_MIN && src_reg < 32)
-			bpf_set_seen_register(ctx, insn[i].src_reg);
+			bpf_set_seen_register(ctx, src_reg);
 
 		switch (code) {
 		/*
-- 
2.39.0



