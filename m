Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6159557DE8E
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiGVJYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiGVJXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:23:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663B26556;
        Fri, 22 Jul 2022 02:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06134CE288C;
        Fri, 22 Jul 2022 09:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9FC341C6;
        Fri, 22 Jul 2022 09:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481311;
        bh=5RuloE8Cs02J8LXghnnFBDDHsz8LkONNlijG0Dd4Fvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSvEI/C9f+8zD0KHf2mioVKRRDOdbo+17TJ4O3UekLDUsPq8DZ5KNLJfu0zkZX46B
         G6SrWp2ADJwF91s4DdEfOWoaaH1gOE2KPvPih0EvCnoi4Ejf5SrqiKiddRYruKIZ6z
         xmkFdRgBlf8N5IpCGwIxKxmoAcp+vOH4DdW05MCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 35/89] x86/kvm: Fix SETcc emulation for return thunks
Date:   Fri, 22 Jul 2022 11:11:09 +0200
Message-Id: <20220722091135.327192365@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
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


