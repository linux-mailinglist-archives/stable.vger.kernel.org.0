Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0057243C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbiGLS6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbiGLS5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017A6DD219;
        Tue, 12 Jul 2022 11:47:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 583C8B81B96;
        Tue, 12 Jul 2022 18:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C95C3411C;
        Tue, 12 Jul 2022 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651645;
        bh=YvCCv6eVb0NnonWUapO+9jBOvrlJBiS1ajCBCiUvIjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQqhKm3+/hvEuBFSfvB/N8XmM4D54N4v9AsVqKqJBiyuyq9VK3ulRFUMWgk3Uwoy9
         8jFqV127BSQ55Dw2TytU+yxGtgLo6Qh2ypUtfzpKDNtYETBRPsR+RxrsNhzMygf/X2
         wTfXSUtsGoydZcULaqbPpc6Q9+xZwvsNGFh48CVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>, Juergen Gross <jgross@suse.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 03/78] x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()
Date:   Tue, 12 Jul 2022 20:38:33 +0200
Message-Id: <20220712183238.970721477@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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
 


