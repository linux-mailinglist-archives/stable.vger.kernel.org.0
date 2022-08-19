Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E55599A52
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348415AbiHSLCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348084AbiHSLCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:02:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B205F4CB5;
        Fri, 19 Aug 2022 04:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yNbb9DcZhKAMxe5tLSY8DOtaWoVmJm1w9u6wWD3tWtU=; b=g8Ut10YmlQXyyHUmopkV7/LoGs
        ijbuy5AH+slUSkC1AjgbFYfFaW7E8p1mbCNNpEPAtySeudz3+3JaHTkAaVJPImQvjOTENtUlv0iBp
        t+EhhtMfvuzzAcxxqfOmp8qnheJzhMg2tMMSZ+EdsmgRbkjY0g/9UEe24KPn4PNxE1FP4OM7k0Wyg
        G9RaHFO2Wb9nIO9h6dr5MzS6RU+4DYUaIfByiu/ZNRpZ+Otz4kaACgU4cY3YA8VrxYO6Gac802GC9
        OWY0ESm/ovWmRVTgQUSlqOtQN1/SpBZAqhDUbmuhdnJXo977bXIt+K61zl8xoLOtHjesovMuq7Kbi
        C7OP7tqg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oOzku-003qr4-V2; Fri, 19 Aug 2022 11:01:37 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3C2FA980163; Fri, 19 Aug 2022 13:01:35 +0200 (CEST)
Date:   Fri, 19 Aug 2022 13:01:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        1017425@bugs.debian.org,
        =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
Message-ID: <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
 <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 10:47:21AM +0200, Peter Zijlstra wrote:
> On Fri, Aug 19, 2022 at 02:33:08AM +0200, Ben Hutchings wrote:
> > From: Ben Hutchings <benh@debian.org>
> > 
> > The mitigation for PBRSB includes adding LFENCE instructions to the
> > RSB filling sequence.  However, RSB filling is done on some older CPUs
> > that don't support the LFENCE instruction.
> > 
> 
> Wait; what? There are chips that enable the RSB mitigations and DONT
> have LFENCE ?!?

So I gave in and clicked on the horrible bugzilla thing. Apparently this
is P3/Athlon64 era crud.

Anyway, the added LFENCE isn't because of retbleed; it is because you
can steer the jnz and terminate the loop early and then not actually
complete the RSB stuffing.

New insights etc.. So it's a geniune fix for the existing rsb stuffing.

I'm not entirly sure what to do here. On the one hand, it's 32bit, so
who gives a crap, otoh we shouldn't break these ancient chips either I
suppose.

How's something like so then? It goes on top of my other patch cleaning
up this RSB mess:

  https://lkml.kernel.org/r/Yv9m%2FhuNJLuyviIn%40worktop.programming.kicks-ass.net

---
Subject: x86/nospec: Fix i386 RSB stuffing

Turns out that i386 doesn't unconditionally have LFENCE, as such the
loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
chips.

Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -50,6 +50,7 @@
  * the optimal version - two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr)			\
 	mov	$(nr/2), reg;				\
 771:							\
@@ -60,6 +61,17 @@
 	jnz	771b;					\
 	/* barrier for jnz misprediction */		\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr)			\
+	.rept nr;					\
+	__FILL_RETURN_SLOT;				\
+	.endr;						\
+	add	$(BITS_PER_LONG/8) * nr, %_ASM_SP;
+#endif
 
 /*
  * Stuff a single RSB slot.


