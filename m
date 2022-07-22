Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD6057DE1E
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiGVJML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiGVJLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C9A9BA5;
        Fri, 22 Jul 2022 02:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADA98B827BC;
        Fri, 22 Jul 2022 09:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11045C341C6;
        Fri, 22 Jul 2022 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658480981;
        bh=b6ihENthbUbQ5lJ4c2//Yhi5Ha1tezAvuDGyRHTe7Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QG0K8ydh7cL5RNJKKDopSCx+k8XQO0M9qs+0thM1XD1uv8XmUeroNDQUQvTb0qAlf
         Woxj32tpEYgeqeYRsVtdjGLv350zBSml8SHpsnGvJ5sO1RPOsDiVCimLYTk7IAlnrE
         C3lbG99IOadybsFkjC5d2INYUNUDMS16HPbcPjpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 17/70] x86/kvm: Fix SETcc emulation for return thunks
Date:   Fri, 22 Jul 2022 11:07:12 +0200
Message-Id: <20220722090651.688629311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -325,13 +325,15 @@ static int fastop(struct x86_emulate_ctx
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
 
@@ -435,16 +437,15 @@ static int fastop(struct x86_emulate_ctx
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
@@ -453,9 +454,10 @@ static_assert(SETCC_LENGTH <= SETCC_ALIG
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


