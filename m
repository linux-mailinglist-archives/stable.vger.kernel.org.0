Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3585723C6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiGLSwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiGLSve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:51:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD673E5850;
        Tue, 12 Jul 2022 11:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4D43B81BBB;
        Tue, 12 Jul 2022 18:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF02C3411C;
        Tue, 12 Jul 2022 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651482;
        bh=9U0r2uHXT1NBk+EpHeWfpqK2tFsMJfPQcA+s6ZHAngc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brW77b1Z+6nrhan5QDaGSfeCUaHFNWF98k/xE6qZ3lavKfsF6nRpN27jA4xObjfTe
         q53QxEy8mul6Lg9eZkGoibAQH+51UFXYYdWmqFwDYuPvvd09ZbkfHs3OPnFlyRW/vU
         YGbBX4YEKTWLhhB8K4GCMdzY3M2sNKfVFiPUHOpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 090/130] x86/kvm: Fix SETcc emulation for return thunks
Date:   Tue, 12 Jul 2022 20:38:56 +0200
Message-Id: <20220712183250.610698458@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -322,13 +322,15 @@ static int fastop(struct x86_emulate_ctx
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
 
@@ -432,15 +434,14 @@ static int fastop(struct x86_emulate_ctx
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
@@ -448,14 +449,15 @@ static_assert(SETCC_LENGTH <= SETCC_ALIG
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
-	__FOP_RET(#op)
+	__FOP_RET(#op) \
+	".skip " __stringify(SETCC_ALIGN) " - (.-" #op "), 0xcc \n\t"
 
 asm(".pushsection .fixup, \"ax\"\n"
     ".global kvm_fastop_exception \n"
     "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 
-FOP_START(setcc)
+__FOP_START(setcc, SETCC_ALIGN)
 FOP_SETCC(seto)
 FOP_SETCC(setno)
 FOP_SETCC(setc)


