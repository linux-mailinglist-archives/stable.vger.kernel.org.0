Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B97514725
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357703AbiD2Kpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357635AbiD2Kpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4094C749E;
        Fri, 29 Apr 2022 03:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CF52CE31AF;
        Fri, 29 Apr 2022 10:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF83C385A4;
        Fri, 29 Apr 2022 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228921;
        bh=dNuZwPRwnqBgUohvCWXMh+zRpw7Ey1IgPmtXMhJ6YnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwPFdTwBz7Aectl0hIa73673jfK1EtQusgylQJ9wOJCF1kfi1anURN6k7BqAW3x96
         hHAFXDCBLgwfjcgcoEUV3Wy5pBDxC7l6QyBlNDlxo3zkwo2U0WYbqBE7Cm5fNHtz0l
         Bl6H6hEeurUfj9TOgUToSCNRG7LRqn6N8dJo8hyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 06/12] powerpc/64/interrupt: Temporarily save PPR on stack to fix register corruption due to SLB miss
Date:   Fri, 29 Apr 2022 12:41:23 +0200
Message-Id: <20220429104048.645508753@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

This is a minimal stable kernel fix for the problem solved by
4c2de74cc869 ("powerpc/64: Interrupts save PPR on stack rather than
thread_struct").

Upstream kernels between 4.17-4.20 have this bug, so I propose this
patch for 4.19 stable.

Longer description from mpe:

In commit f384796c4 ("powerpc/mm: Add support for handling > 512TB
address in SLB miss") we added support for using multiple context ids
per process. Previously accessing past the first context id was a fatal
error for the process. With the new support it became non-fatal, and so
the previous "bad_addr_slb" handler was changed to be the
"large_addr_slb" handler.

That handler uses the EXCEPTION_PROLOG_COMMON() macro, which in-turn
calls the SAVE_PPR() macro. At the point where SAVE_PPR() is used, the
r9-13 register values from the original user fault are saved in
paca->exslb. It's not until later in EXCEPTION_PROLOG_COMMON_2() that
they are saved from paca->exslb onto the kernel stack.

The PPR is saved into current->thread.ppr, which is notably not on the
kernel stack the way pt_regs are. This means we can take an SLB miss on
current->thread.ppr. If that happens in the "large_addr_slb" case we
will clobber the saved user r9-r13 in paca->exslb with kernel values.
Later we will save those clobbered values into the pt_regs on the stack,
and when we return to userspace those kernel values will be restored.

Typically this appears as some sort of segfault in userspace, with an
address that looks like a kernel address. In dmesg it can appear as:

  [19117.440331] some_program[1869625]: unhandled signal 11 at c00000000f6bda10 nip 00007fff780d559c lr 00007fff781ae56c code 30001

The upstream fix for this issue was to move PPR into pt_regs, on the
kernel stack, avoiding the possibility of an SLB fault when saving it.

However changing the size of pt_regs is an intrusive change, and has
side effects in other parts of the kernel. A minimal fix is to
temporarily save the PPR in an unused part of pt_regs, then save the
user register values from paca->exslb into pt_regs, and then move the
saved PPR into thread.ppr.

Fixes: f384796c40dc ("powerpc/mm: Add support for handling > 512TB address in SLB miss")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220316033235.903657-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/exception-64s.h |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -243,10 +243,22 @@
  * PPR save/restore macros used in exceptions_64s.S  
  * Used for P7 or later processors
  */
-#define SAVE_PPR(area, ra, rb)						\
+#define SAVE_PPR(area, ra)						\
+BEGIN_FTR_SECTION_NESTED(940)						\
+	ld	ra,area+EX_PPR(r13);	/* Read PPR from paca */	\
+	std	ra,RESULT(r1);		/* Store PPR in RESULT for now */ \
+END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,CPU_FTR_HAS_PPR,940)
+
+/*
+ * This is called after we are finished accessing 'area', so we can now take
+ * SLB faults accessing the thread struct, which will use PACA_EXSLB area.
+ * This is required because the large_addr_slb handler uses EXSLB and it also
+ * uses the common exception macros including this PPR saving.
+ */
+#define MOVE_PPR_TO_THREAD(ra, rb)					\
 BEGIN_FTR_SECTION_NESTED(940)						\
 	ld	ra,PACACURRENT(r13);					\
-	ld	rb,area+EX_PPR(r13);	/* Read PPR from paca */	\
+	ld	rb,RESULT(r1);		/* Read PPR from stack */	\
 	std	rb,TASKTHREADPPR(ra);					\
 END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,CPU_FTR_HAS_PPR,940)
 
@@ -515,9 +527,11 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 3:	EXCEPTION_PROLOG_COMMON_1();					   \
 	beq	4f;			/* if from kernel mode		*/ \
 	ACCOUNT_CPU_USER_ENTRY(r13, r9, r10);				   \
-	SAVE_PPR(area, r9, r10);					   \
+	SAVE_PPR(area, r9);						   \
 4:	EXCEPTION_PROLOG_COMMON_2(area)					   \
-	EXCEPTION_PROLOG_COMMON_3(n)					   \
+	beq	5f;			/* if from kernel mode		*/ \
+	MOVE_PPR_TO_THREAD(r9, r10);					   \
+5:	EXCEPTION_PROLOG_COMMON_3(n)					   \
 	ACCOUNT_STOLEN_TIME
 
 /* Save original regs values from save area to stack frame. */


