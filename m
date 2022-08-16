Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B737C595BC3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiHPM3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiHPM3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:29:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BB77694D;
        Tue, 16 Aug 2022 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WRFrEjFxGdFkqA9SdI0feTAquv3GxGRi4A+yj2xL3D4=; b=qZqvj+IP94gLkHbyb+RHonL8CS
        HzJSE9cVbgrNYrex+Y7nMaL3qpckeManiGEzmHu1DdNFI/Cg+3QJmQwGdJ5w46kJYW9cOR4Z/Ycva
        EPVCCvj0HEJuH6A6IHPSdRBgsjMtZFE+zG6uqwPxke+Fe1W09ZqcGvobDmQuIQg//3jNWSqhd9tTj
        G1Ch5a8FGuNeUlIxigJv1u/7dhV+M2Zj+qkk/e5S4RLNybypWgkTBzSRDLDWZP7GhGyT4FS6JMpXh
        JDIKbk/Qk3eJQBKcF94oHW1x4XPSGxMVWwuzrcMo/JKNbeGmQeQgG6YrRfsxHm/czfljglqvqvH9v
        qk4X9IpQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNvgU-002xO9-4C; Tue, 16 Aug 2022 12:28:38 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9F175980120; Tue, 16 Aug 2022 14:28:36 +0200 (CEST)
Date:   Tue, 16 Aug 2022 14:28:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] x86/nospec: Unwreck the RSB stuffing
Message-ID: <YvuNdDWoUZSBjYcm@worktop.programming.kicks-ass.net>
References: <20220809175513.345597655@linuxfoundation.org>
 <20220809175513.979067723@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175513.979067723@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Replying here, because obviously there's no actual posting of this
patch... :/

> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -118,13 +118,28 @@
>  #endif
>  .endm
>  
> +.macro ISSUE_UNBALANCED_RET_GUARD
> +	ANNOTATE_INTRA_FUNCTION_CALL
> +	call .Lunbalanced_ret_guard_\@
> +	int3
> +.Lunbalanced_ret_guard_\@:
> +	add $(BITS_PER_LONG/8), %_ASM_SP
> +	lfence
> +.endm
> +
>   /*
>    * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
>    * monstrosity above, manually.
>    */
> -.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
> +.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2
> +.ifb \ftr2
>  	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
> +.else
> +	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", "", \ftr, "jmp .Lunbalanced_\@", \ftr2
> +.endif
>  	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
> +.Lunbalanced_\@:
> +	ISSUE_UNBALANCED_RET_GUARD
>  .Lskip_rsb_\@:
>  .endm

(/me deletes all the swear words and starts over)

This must absolutely be the most horrible patch you could come up with,
no? I suppose that's the price of me taking PTO :-(

Could you please test this; I've only compiled it.

---
Subject: x86/nospec: Unwreck the RSB stuffing

Commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
made a right mess of the RSB stuffing, rewrite the whole thing to not
suck.

Thanks to Andrew for the enlightening comment about Post-Barrier RSB
things so we can make this code less magical.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 cpufeatures.h   |    2 +
 nospec-branch.h |   80 +++++++++++++++++++++++++++-----------------------------
 2 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 235dc85c91c3..1a31ae6d758b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -420,6 +420,8 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 
+#define X86_FEATURE_NEVER		(-1) /* "" Logical complement of ALWAYS */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e64fd20778b6..336f8e8cebf8 100644
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
+.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2=X86_FEATURE_NEVER
+	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", \
+		__stringify(__FILL_RETURN_BUFFER(\reg,\nr)), \ftr, \
+		__stringify(__FILL_ONE_RETURN), \ftr2
+
 .Lskip_rsb_\@:
 .endm
 
