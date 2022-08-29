Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2861D5A43BB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiH2HZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiH2HZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:25:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC482D1D6
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82B7AB80C75
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A43C433B5;
        Mon, 29 Aug 2022 07:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661757925;
        bh=HWtDrIjWHbmBlymYu62t/mv7sRt2J446lZKv0E6VfXM=;
        h=Subject:To:Cc:From:Date:From;
        b=Y8hLqKocd3VcZvIl7xVFdGlzWO0JW9ljhiaK+QmZduN/FOc+cqzLZl2Kdbps9cC3E
         AiilHuHbKZnL+T1RQ5rd+2iP4UNEwDSKhcE1DSV/5OuQnes6YB/vCbWZdIfb1pzglL
         +bNMfCZb3g/rabYndLDCQsFdjSUMd7N4w4FBiP+Q=
Subject: FAILED: patch "[PATCH] x86/nospec: Unwreck the RSB stuffing" failed to apply to 5.10-stable tree
To:     peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:25:22 +0200
Message-ID: <166175792202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e3aa9238277597c6c7624f302d81a7b568b6f2d Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 16 Aug 2022 14:28:36 +0200
Subject: [PATCH] x86/nospec: Unwreck the RSB stuffing

Commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
made a right mess of the RSB stuffing, rewrite the whole thing to not
suck.

Thanks to Andrew for the enlightening comment about Post-Barrier RSB
things so we can make this code less magical.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e64fd20778b6..10731ccfed37 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -35,33 +35,44 @@
 #define RSB_CLEAR_LOOPS		32	/* To forcibly overwrite all entries */
 
 /*
+ * Common helper for __FILL_RETURN_BUFFER and __FILL_ONE_RETURN.
+ */
+#define __FILL_RETURN_SLOT			\
+	ANNOTATE_INTRA_FUNCTION_CALL;		\
+	call	772f;				\
+	int3;					\
+772:
+
+/*
+ * Stuff the entire RSB.
+ *
  * Google experimented with loop-unrolling and this turned out to be
  * the optimal version - two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
-#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
-	mov	$(nr/2), reg;			\
-771:						\
-	ANNOTATE_INTRA_FUNCTION_CALL;		\
-	call	772f;				\
-773:	/* speculation trap */			\
-	UNWIND_HINT_EMPTY;			\
-	pause;					\
-	lfence;					\
-	jmp	773b;				\
-772:						\
-	ANNOTATE_INTRA_FUNCTION_CALL;		\
-	call	774f;				\
-775:	/* speculation trap */			\
-	UNWIND_HINT_EMPTY;			\
-	pause;					\
-	lfence;					\
-	jmp	775b;				\
-774:						\
-	add	$(BITS_PER_LONG/8) * 2, sp;	\
-	dec	reg;				\
-	jnz	771b;				\
-	/* barrier for jnz misprediction */	\
+#define __FILL_RETURN_BUFFER(reg, nr)			\
+	mov	$(nr/2), reg;				\
+771:							\
+	__FILL_RETURN_SLOT				\
+	__FILL_RETURN_SLOT				\
+	add	$(BITS_PER_LONG/8) * 2, %_ASM_SP;	\
+	dec	reg;					\
+	jnz	771b;					\
+	/* barrier for jnz misprediction */		\
+	lfence;
+
+/*
+ * Stuff a single RSB slot.
+ *
+ * To mitigate Post-Barrier RSB speculation, one CALL instruction must be
+ * forced to retire before letting a RET instruction execute.
+ *
+ * On PBRSB-vulnerable CPUs, it is not safe for a RET to be executed
+ * before this point.
+ */
+#define __FILL_ONE_RETURN				\
+	__FILL_RETURN_SLOT				\
+	add	$(BITS_PER_LONG/8), %_ASM_SP;		\
 	lfence;
 
 #ifdef __ASSEMBLY__
@@ -132,28 +143,15 @@
 #endif
 .endm
 
-.macro ISSUE_UNBALANCED_RET_GUARD
-	ANNOTATE_INTRA_FUNCTION_CALL
-	call .Lunbalanced_ret_guard_\@
-	int3
-.Lunbalanced_ret_guard_\@:
-	add $(BITS_PER_LONG/8), %_ASM_SP
-	lfence
-.endm
-
  /*
   * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
   * monstrosity above, manually.
   */
-.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2
-.ifb \ftr2
-	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
-.else
-	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", "", \ftr, "jmp .Lunbalanced_\@", \ftr2
-.endif
-	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
-.Lunbalanced_\@:
-	ISSUE_UNBALANCED_RET_GUARD
+.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=ALT_NOT(X86_FEATURE_ALWAYS)
+	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
+		__stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
+		__stringify(__FILL_ONE_RETURN), \ftr2
+
 .Lskip_rsb_\@:
 .endm
 

