Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA35B5A450C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiH2Ia1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiH2Ia0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BC543E7C
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 01:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E325760E96
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0BCC433D6;
        Mon, 29 Aug 2022 08:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661761823;
        bh=d1Y1Exs7pAVjffHZl5ntqlcwwfoCfFwmXs4ghOlFKk4=;
        h=Subject:To:Cc:From:Date:From;
        b=0wJxuW0K24BuLV+RxqsEqkhDuQm7s2Z4aSUDxZIBzrbZrAlWK/pR7Z68FJ/Kbl6gG
         bFJQHoys4H+u+GCyILg0CeAVW+nSHijKtiMAQFqPyJyiNVHKnLpLNQUvhV2IRYeGzU
         sQDfgL0ne+JROdeeURO28q8wpiE/UXNG/0MAZ3fw=
Subject: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed to apply to 4.19-stable tree
To:     peterz@infradead.org, ben@decadent.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 10:30:12 +0200
Message-ID: <16617618121746@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 332924973725e8cdcc783c175f68cf7e162cb9e5 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 19 Aug 2022 13:01:35 +0200
Subject: [PATCH] x86/nospec: Fix i386 RSB stuffing

Turns out that i386 doesn't unconditionally have LFENCE, as such the
loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
chips.

Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 10731ccfed37..c936ce9f0c47 100644
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

