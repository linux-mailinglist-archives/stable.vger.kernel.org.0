Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E67579EEA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242973AbiGSNH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243067AbiGSNHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114C3BA247;
        Tue, 19 Jul 2022 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 806986195B;
        Tue, 19 Jul 2022 12:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CEFC341C6;
        Tue, 19 Jul 2022 12:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233621;
        bh=99oYuSj1M8WEb4HdX2609nGaiPr3UQnE0ldIVJt3eB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD/B/HsXfv6Bq9io5BgWp0LujqRuFrWCLsQBdW+SulnnLyT8vYfMkWMX8CUWpz+fq
         tVEjzSbiCy1vYSpy9cpFIKoqmkcxVL2IWHOLJ8j29bhmmkoQ4rNy5O05nPUO6mo5I3
         U1zKHmp8YYfxQIlopnWYmIZ+5qGqwoRYY9h/xKs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 145/231] x86/kvm: Fix SETcc emulation for return thunks
Date:   Tue, 19 Jul 2022 13:53:50 +0200
Message-Id: <20220719114726.554097958@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit af2e140f34208a5dfb6b7a8ad2d56bda88f0524d ]

Prepare the SETcc fastop stuff for when RET can be larger still.

The tricky bit here is that the expressions should not only be
constant C expressions, but also absolute GAS expressions. This means
no ?: and 'true' is ~0.

Also ensure em_setcc() has the same alignment as the actual FOP_SETCC()
ops, this ensures there cannot be an alignment hole between em_setcc()
and the first op.

Additionally, add a .skip directive to the FOP_SETCC() macro to fill
any remaining space with INT3 traps; however the primary purpose of
this directive is to generate AS warnings when the remaining space
goes negative. Which is a very good indication the alignment magic
went side-ways.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 89b11e7dca8a..b01437015f99 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -325,13 +325,15 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 #define FOP_RET(name) \
 	__FOP_RET(#name)
 
-#define FOP_START(op) \
+#define __FOP_START(op, align) \
 	extern void em_##op(struct fastop *fake); \
 	asm(".pushsection .text, \"ax\" \n\t" \
 	    ".global em_" #op " \n\t" \
-	    ".align " __stringify(FASTOP_SIZE) " \n\t" \
+	    ".align " __stringify(align) " \n\t" \
 	    "em_" #op ":\n\t"
 
+#define FOP_START(op) __FOP_START(op, FASTOP_SIZE)
+
 #define FOP_END \
 	    ".popsection")
 
@@ -435,16 +437,15 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 /*
  * Depending on .config the SETcc functions look like:
  *
- * ENDBR       [4 bytes; CONFIG_X86_KERNEL_IBT]
- * SETcc %al   [3 bytes]
- * RET         [1 byte]
- * INT3        [1 byte; CONFIG_SLS]
- *
- * Which gives possible sizes 4, 5, 8 or 9.  When rounded up to the
- * next power-of-two alignment they become 4, 8 or 16 resp.
+ * ENDBR			[4 bytes; CONFIG_X86_KERNEL_IBT]
+ * SETcc %al			[3 bytes]
+ * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETPOLINE]
+ * INT3				[1 byte; CONFIG_SLS]
  */
-#define SETCC_LENGTH	(ENDBR_INSN_SIZE + 4 + IS_ENABLED(CONFIG_SLS))
-#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS) << HAS_KERNEL_IBT)
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETPOLINE)) + \
+			 IS_ENABLED(CONFIG_SLS))
+#define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
+#define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
 static_assert(SETCC_LENGTH <= SETCC_ALIGN);
 
 #define FOP_SETCC(op) \
@@ -453,9 +454,10 @@ static_assert(SETCC_LENGTH <= SETCC_ALIGN);
 	#op ": \n\t" \
 	ASM_ENDBR \
 	#op " %al \n\t" \
-	__FOP_RET(#op)
+	__FOP_RET(#op) \
+	".skip " __stringify(SETCC_ALIGN) " - (.-" #op "), 0xcc \n\t"
 
-FOP_START(setcc)
+__FOP_START(setcc, SETCC_ALIGN)
 FOP_SETCC(seto)
 FOP_SETCC(setno)
 FOP_SETCC(setc)
-- 
2.35.1



