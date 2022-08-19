Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB201599A0F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 12:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346578AbiHSKdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 06:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347681AbiHSKdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 06:33:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9687E2C108;
        Fri, 19 Aug 2022 03:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dotXOKDiE1Y3p77G/61a0SdN8QdKHMNUsMOBOW8ypLA=; b=blckdN/WSOPTEjHVqp8yk9NPT0
        QIdwpSuyVgGGsN7RFjen+tZmn7irX96jkAlgWREvYD3NBXcNsZabMpHJRyxxcft0HguTNOtzuRVMY
        wUhxjGNmqIRMXtR4hI7b47Uz06VpsOE7u6lpU0tsXVrItxQrPz3O9pnM2Qsw79QeMKPOmDco+ct5T
        psua+uKaS26T+MITqkD2Vse88mEwa06rym4C7jN6SDs2tsR0XodwEKp9OZAMR55h6KBWib5vY9qjA
        3jjLJSL14hWNyCj/0/dlZTIsJwaXPIwgy05dVRLM3LBVJ7wMQe2d87iEOrbySSWXICOtNM1DlPfFG
        39gq9tkQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oOzJn-00B1c4-Ui; Fri, 19 Aug 2022 10:33:36 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E61AF980163; Fri, 19 Aug 2022 12:33:34 +0200 (CEST)
Date:   Fri, 19 Aug 2022 12:33:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <Yv9m/huNJLuyviIn@worktop.programming.kicks-ass.net>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
 <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
 <839e2877-bb16-dbb5-d4da-bc611733c7e1@linux.intel.com>
 <84f4b1ea-d837-9a53-a21c-4ac602ff8e75@linux.intel.com>
 <YvyQzHzLJpalcvbZ@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvyQzHzLJpalcvbZ@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 08:55:08AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 16, 2022 at 11:04:36AM -0700, Daniel Sneddon wrote:
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 1a31ae6d758b..c5b55c9f2849 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -420,7 +420,7 @@
> >  #define X86_FEATURE_V_TSC_AUX          (19*32+ 9) /* "" Virtual TSC_AUX */
> >  #define X86_FEATURE_SME_COHERENT       (19*32+10) /* "" AMD hardware-enforced
> > cache coherency */
> > 
> > -#define X86_FEATURE_NEVER              (-1) /* "" Logical complement of ALWAYS */
> > +#define X86_FEATURE_NEVER              (0x7FFF) /* "" Logical complement of
> > ALWAYS */
> 
> 
> Bah, I initially spelled that: ALT_NOT(X86_FEATURE_ALWAYS), but Boris
> made me do the -1 thing there. Oh well, Boris can fix that :-)

Boris, how's this then? Will you cram it into x86/urgent ?

---

Subject: x86/nospec: Unwreck the RSB stuffing
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 16 Aug 2022 14:28:36 +0200

Commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
made a right mess of the RSB stuffing, rewrite the whole thing to not
suck.

Thanks to Andrew for the enlightening comment about Post-Barrier RSB
things so we can make this code less magical.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/nospec-branch.h |   80 +++++++++++++++++------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

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
 
