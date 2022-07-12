Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3140957246A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiGLTBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiGLTAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B6A65F9;
        Tue, 12 Jul 2022 11:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B66C6149A;
        Tue, 12 Jul 2022 18:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BEDC341C0;
        Tue, 12 Jul 2022 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651721;
        bh=5RuloE8Cs02J8LXghnnFBDDHsz8LkONNlijG0Dd4Fvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd4ThvTGG4JxVlO6oiVL4rekiU6XKLmgF6g5hXgNCrbkWwfmepCKgpE2WrUFAhnOU
         oVgbGsYwiT6yKACMXT40YGzJNAiJfcjpVyJcoVtnM6tDWtHPBs+Yua/a5Oy/Uc3DjD
         GSuNEP+FvJJeIfHANGcbkDglGHheK0ApXjqxWHKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 35/78] x86/kvm: Fix SETcc emulation for return thunks
Date:   Tue, 12 Jul 2022 20:39:05 +0200
Message-Id: <20220712183240.230694551@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit af2e140f34208a5dfb6b7a8ad2d56bda88f0524d upstream.

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
[cascardo: ignore ENDBR when computing SETCC_LENGTH]
[cascardo: conflict fixup]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -321,13 +321,15 @@ static int fastop(struct x86_emulate_ctx
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
 
@@ -431,15 +433,14 @@ static int fastop(struct x86_emulate_ctx
 /*
  * Depending on .config the SETcc functions look like:
  *
- * SETcc %al   [3 bytes]
- * RET         [1 byte]
- * INT3        [1 byte; CONFIG_SLS]
- *
- * Which gives possible sizes 4 or 5.  When rounded up to the
- * next power-of-two alignment they become 4 or 8.
+ * SETcc %al			[3 bytes]
+ * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETPOLINE]
+ * INT3				[1 byte; CONFIG_SLS]
  */
-#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
-#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETPOLINE)) + \
+			 IS_ENABLED(CONFIG_SLS))
+#define SETCC_LENGTH	(3 + RET_LENGTH)
+#define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
 static_assert(SETCC_LENGTH <= SETCC_ALIGN);
 
 #define FOP_SETCC(op) \
@@ -447,13 +448,14 @@ static_assert(SETCC_LENGTH <= SETCC_ALIG
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
-	__FOP_RET(#op)
+	__FOP_RET(#op) \
+	".skip " __stringify(SETCC_ALIGN) " - (.-" #op "), 0xcc \n\t"
 
 asm(".pushsection .fixup, \"ax\"\n"
     "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 
-FOP_START(setcc)
+__FOP_START(setcc, SETCC_ALIGN)
 FOP_SETCC(seto)
 FOP_SETCC(setno)
 FOP_SETCC(setc)


