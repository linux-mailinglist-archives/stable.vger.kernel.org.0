Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16F6949CA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjBMPCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjBMPB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:01:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAA41DB90
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE47761159
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EF2C433EF;
        Mon, 13 Feb 2023 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300495;
        bh=U7Sjug3vMx8zOxVwzQpi9Va8D+ubftR8GxKHcVM0/B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAYHeFHNM2R8gUJLsHrl8rYI5MIKuxYP71io5Tp0aHPbf4BXAOtwFKsENgm4DsRT/
         uCBFIIiWgnQWFaku5gJDy7AJIB9h0HfZlBbcVsJ6Befe8wh8wzkWh2fXqaTSN1uYLl
         vgbRbj7OpsoN1Kc3AoOibkRBv6RZj095B6bmU+CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/139] powerpc/bpf: Move common helpers into bpf_jit.h
Date:   Mon, 13 Feb 2023 15:49:13 +0100
Message-Id: <20230213144746.106444205@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f1b1583d5faa86cb3dcb7b740594868debad7c30 ]

Move functions bpf_flush_icache(), bpf_is_seen_register() and
bpf_set_seen_register() in order to reuse them in future
bpf_jit_comp32.c

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/28e8d5a75e64807d7e9d39a4b52658755e259f8c.1616430991.git.christophe.leroy@csgroup.eu
Stable-dep-of: 71f656a50176 ("bpf: Fix to preserve reg parent/live fields when copying range info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit.h        | 35 +++++++++++++++++++++++++++++++
 arch/powerpc/net/bpf_jit64.h      | 19 -----------------
 arch/powerpc/net/bpf_jit_comp64.c | 16 --------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 1a5b4da8a235..cd9aab6ec2c5 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -117,6 +117,41 @@
 #define COND_LT		(CR0_LT | COND_CMP_TRUE)
 #define COND_LE		(CR0_GT | COND_CMP_FALSE)
 
+#define SEEN_FUNC	0x1000 /* might call external helpers */
+#define SEEN_STACK	0x2000 /* uses BPF stack */
+#define SEEN_TAILCALL	0x4000 /* uses tail calls */
+
+struct codegen_context {
+	/*
+	 * This is used to track register usage as well
+	 * as calls to external helpers.
+	 * - register usage is tracked with corresponding
+	 *   bits (r3-r10 and r27-r31)
+	 * - rest of the bits can be used to track other
+	 *   things -- for now, we use bits 16 to 23
+	 *   encoded in SEEN_* macros above
+	 */
+	unsigned int seen;
+	unsigned int idx;
+	unsigned int stack_size;
+};
+
+static inline void bpf_flush_icache(void *start, void *end)
+{
+	smp_wmb();	/* smp write barrier */
+	flush_icache_range((unsigned long)start, (unsigned long)end);
+}
+
+static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
+{
+	return ctx->seen & (1 << (31 - i));
+}
+
+static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
+{
+	ctx->seen |= 1 << (31 - i);
+}
+
 #endif
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit64.h b/arch/powerpc/net/bpf_jit64.h
index 4d164e865b39..201b83bfa869 100644
--- a/arch/powerpc/net/bpf_jit64.h
+++ b/arch/powerpc/net/bpf_jit64.h
@@ -86,25 +86,6 @@ static const int b2p[] = {
 				} while(0)
 #define PPC_BPF_STLU(r, base, i) do { EMIT(PPC_RAW_STDU(r, base, i)); } while(0)
 
-#define SEEN_FUNC	0x1000 /* might call external helpers */
-#define SEEN_STACK	0x2000 /* uses BPF stack */
-#define SEEN_TAILCALL	0x4000 /* uses tail calls */
-
-struct codegen_context {
-	/*
-	 * This is used to track register usage as well
-	 * as calls to external helpers.
-	 * - register usage is tracked with corresponding
-	 *   bits (r3-r10 and r27-r31)
-	 * - rest of the bits can be used to track other
-	 *   things -- for now, we use bits 16 to 23
-	 *   encoded in SEEN_* macros above
-	 */
-	unsigned int seen;
-	unsigned int idx;
-	unsigned int stack_size;
-};
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 7da59ddc90dd..ebad2c79cd6f 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -24,22 +24,6 @@ static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
 	memset32(area, BREAKPOINT_INSTRUCTION, size/4);
 }
 
-static inline void bpf_flush_icache(void *start, void *end)
-{
-	smp_wmb();
-	flush_icache_range((unsigned long)start, (unsigned long)end);
-}
-
-static inline bool bpf_is_seen_register(struct codegen_context *ctx, int i)
-{
-	return ctx->seen & (1 << (31 - i));
-}
-
-static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
-{
-	ctx->seen |= 1 << (31 - i);
-}
-
 static inline bool bpf_has_stack_frame(struct codegen_context *ctx)
 {
 	/*
-- 
2.39.0



