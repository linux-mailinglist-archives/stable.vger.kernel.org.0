Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB11E57DE4C
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiGVJST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiGVJRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:17:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB3EA0B93;
        Fri, 22 Jul 2022 02:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F257B827B6;
        Fri, 22 Jul 2022 09:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8ADC341CA;
        Fri, 22 Jul 2022 09:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481160;
        bh=YvCCv6eVb0NnonWUapO+9jBOvrlJBiS1ajCBCiUvIjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Un/x3LIEQv15xQMITwstqA1CMWPFSrWRQu6b1JTlvou7mwlehn8gmsoI/KXuchtGV
         b5J9ZGbhMxKNp144pJjM9xlpWAN4E9KhwsYjmvTzfK5E/+1dLOT0cobv7cxatqdDG1
         2rdDeoUe6LCNnsTFAw3SAtjuuZFgy73yvYHHHswg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>, Juergen Gross <jgross@suse.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 03/89] x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()
Date:   Fri, 22 Jul 2022 11:10:37 +0200
Message-Id: <20220722091133.555153955@linuxfoundation.org>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

commit ee774dac0da1543376a69fd90840af6aa86879b3 upstream.

The macro idtentry() (through idtentry_body()) calls error_entry()
unconditionally even on XENPV. But XENPV needs to only push and clear
regs.

PUSH_AND_CLEAR_REGS in error_entry() makes the stack not return to its
original place when the function returns, which means it is not possible
to convert it to a C function.

Carve out PUSH_AND_CLEAR_REGS out of error_entry() and into a separate
function and call it before error_entry() in order to avoid calling
error_entry() on XENPV.

It will also allow for error_entry() to be converted to C code that can
use inlined sync_regs() and save a function call.

  [ bp: Massage commit message. ]

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220503032107.680190-4-jiangshanlai@gmail.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -315,6 +315,14 @@ SYM_CODE_END(ret_from_fork)
 #endif
 .endm
 
+/* Save all registers in pt_regs */
+SYM_CODE_START_LOCAL(push_and_clear_regs)
+	UNWIND_HINT_FUNC
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
+	RET
+SYM_CODE_END(push_and_clear_regs)
+
 /**
  * idtentry_body - Macro to emit code calling the C function
  * @cfunc:		C function to be called
@@ -322,6 +330,9 @@ SYM_CODE_END(ret_from_fork)
  */
 .macro idtentry_body cfunc has_error_code:req
 
+	call push_and_clear_regs
+	UNWIND_HINT_REGS
+
 	call	error_entry
 	movq	%rax, %rsp			/* switch to the task stack if from userspace */
 	ENCODE_FRAME_POINTER
@@ -965,13 +976,11 @@ SYM_CODE_START_LOCAL(paranoid_exit)
 SYM_CODE_END(paranoid_exit)
 
 /*
- * Save all registers in pt_regs, and switch GS if needed.
+ * Switch GS and CR3 if needed.
  */
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
 	cld
-	PUSH_AND_CLEAR_REGS save_ret=1
-	ENCODE_FRAME_POINTER 8
 	testb	$3, CS+8(%rsp)
 	jz	.Lerror_kernelspace
 


