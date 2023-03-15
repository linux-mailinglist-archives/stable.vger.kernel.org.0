Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97736BB297
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjCOMh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbjCOMhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A406C56789
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB6F6128D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E62AC433D2;
        Wed, 15 Mar 2023 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883776;
        bh=W1QfcQHVZVFp9rQvEhfqJH+RvdNqkFLq8fN0NrQTBe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruoVYKS2qGmY44SVJAh1y+DXwLfyIJM0pbxLXU7gmGsoRZVygSalCx7t5EzKJECcL
         0qcOJZ9RlrfG+9WbaI6WQZf/Qaf+csePKLmgzGIrsLKWLd1f5laOjnPfrUlleDT5CZ
         1cACG/UZzu5QfWULCUVB/rrxdDIQTRxSfwb2Amr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/143] powerpc/bpf/32: Only set a stack frame when necessary
Date:   Wed, 15 Mar 2023 13:13:34 +0100
Message-Id: <20230315115744.422072097@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d084dcf256bc4565b4b1af9b00297ac7b51c7049 ]

Until now a stack frame was set at all time due to the need
to keep tail call counter in the stack.

But since commit 89d21e259a94 ("powerpc/bpf/32: Fix Oops on tail call
tests") the tail call counter is passed via register r4. It is therefore
not necessary anymore to have a stack frame for that.

Just like PPC64, implement bpf_has_stack_frame() and only sets the frame
when needed.

The difference with PPC64 is that PPC32 doesn't have a redzone, so
the stack is required as soon as non volatile registers are used or
when tail call count is set up.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Fix commit reference in change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/62d7b654a3cfe73d998697cb29bbc5ffd89bfdb1.1675245773.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp32.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index a379b0ce19ffa..8643b2c8b76ef 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -79,6 +79,20 @@ static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
 #define SEEN_NVREG_FULL_MASK	0x0003ffff /* Non volatile registers r14-r31 */
 #define SEEN_NVREG_TEMP_MASK	0x00001e01 /* BPF_REG_5, BPF_REG_AX, TMP_REG */
 
+static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
+{
+	/*
+	 * We only need a stack frame if:
+	 * - we call other functions (kernel helpers), or
+	 * - we use non volatile registers, or
+	 * - we use tail call counter
+	 * - the bpf program uses its stack area
+	 * The latter condition is deduced from the usage of BPF_REG_FP
+	 */
+	return ctx->seen & (SEEN_FUNC | SEEN_TAILCALL | SEEN_NVREG_FULL_MASK) ||
+	       bpf_is_seen_register(ctx, bpf_to_ppc(BPF_REG_FP));
+}
+
 void bpf_jit_realloc_regs(struct codegen_context *ctx)
 {
 	unsigned int nvreg_mask;
@@ -118,7 +132,8 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 
 #define BPF_TAILCALL_PROLOGUE_SIZE	4
 
-	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
+	if (bpf_has_stack_frame(ctx))
+		EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_TAILCALL)
 		EMIT(PPC_RAW_STW(_R4, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
@@ -171,7 +186,8 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
 
 	/* Tear down our stack frame */
-	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
+	if (bpf_has_stack_frame(ctx))
+		EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
 
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_MTLR(_R0));
-- 
2.39.2



