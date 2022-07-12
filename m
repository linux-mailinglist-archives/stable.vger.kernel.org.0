Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03FB5724EA
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiGLTHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiGLTGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC469FB8C2;
        Tue, 12 Jul 2022 11:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A6861491;
        Tue, 12 Jul 2022 18:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A974FC3411C;
        Tue, 12 Jul 2022 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651880;
        bh=shRat7IUwl93UZ/ixdmyAqfcSvEzlZjfd1rUIGGZm38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxSogrnFqyfqhYwsMFHJDLbiwjBQ6lbs5pX8UComBPM0pOVA349r9rzZTSNF4V3jX
         +pa+2pjKIUJwAADzVtGGCpNc7P7yrYo5kJGSgRoFhEWy7scENU9GhJ8fwXkIVIxwGf
         aCbu+xkL1jS1fVwPnhuOPvDFc0x7mXHu1Lb8MsZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 02/61] x86/entry: Switch the stack after error_entry() returns
Date:   Tue, 12 Jul 2022 20:38:59 +0200
Message-Id: <20220712183237.044146273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

commit 520a7e80c96d655fbe4650d9cc985bd9d0443389 upstream.

error_entry() calls fixup_bad_iret() before sync_regs() if it is a fault
from a bad IRET, to copy pt_regs to the kernel stack. It switches to the
kernel stack directly after sync_regs().

But error_entry() itself is also a function call, so it has to stash
the address it is going to return to, in %r12 which is unnecessarily
complicated.

Move the stack switching after error_entry() and get rid of the need to
handle the return address.

  [ bp: Massage commit message. ]

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220503032107.680190-3-jiangshanlai@gmail.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -326,6 +326,8 @@ SYM_CODE_END(ret_from_fork)
 .macro idtentry_body cfunc has_error_code:req
 
 	call	error_entry
+	movq	%rax, %rsp			/* switch to the task stack if from userspace */
+	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
 	movq	%rsp, %rdi			/* pt_regs pointer into 1st argument*/
@@ -1003,14 +1005,10 @@ SYM_CODE_START_LOCAL(error_entry)
 	/* We have user CR3.  Change to kernel CR3. */
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
 
+	leaq	8(%rsp), %rdi			/* arg0 = pt_regs pointer */
 .Lerror_entry_from_usermode_after_swapgs:
 	/* Put us onto the real thread stack. */
-	popq	%r12				/* save return addr in %12 */
-	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
 	call	sync_regs
-	movq	%rax, %rsp			/* switch stack */
-	ENCODE_FRAME_POINTER
-	pushq	%r12
 	RET
 
 	/*
@@ -1042,6 +1040,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	 */
 .Lerror_entry_done_lfence:
 	FENCE_SWAPGS_KERNEL_ENTRY
+	leaq	8(%rsp), %rax			/* return pt_regs pointer */
 	RET
 
 .Lbstep_iret:
@@ -1062,12 +1061,9 @@ SYM_CODE_START_LOCAL(error_entry)
 	 * Pretend that the exception came from user mode: set up pt_regs
 	 * as if we faulted immediately after IRET.
 	 */
-	popq	%r12				/* save return addr in %12 */
-	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
+	leaq	8(%rsp), %rdi			/* arg0 = pt_regs pointer */
 	call	fixup_bad_iret
-	mov	%rax, %rsp
-	ENCODE_FRAME_POINTER
-	pushq	%r12
+	mov	%rax, %rdi
 	jmp	.Lerror_entry_from_usermode_after_swapgs
 SYM_CODE_END(error_entry)
 


