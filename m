Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D725A4802
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiH2LEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiH2LDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:03:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB9642F8;
        Mon, 29 Aug 2022 04:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB63B80EF1;
        Mon, 29 Aug 2022 11:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC19FC433D7;
        Mon, 29 Aug 2022 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770955;
        bh=uro6sn39/nlGYKDCpLWgCRVO+1kpnI9YO9HvkKBO8QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pka4C2nF9KMcXn5ZtUocx5316dsUzEXPhG2MTH/UsENoZ7hb8B7iYwQVp9BPNRS3I
         yyN3Tai3IupPHADyX6nRXTFKMUKjfd8+obxArjJQeOCu7FrkbdW2vZZNIxqZBRB4T5
         nR2ovZ03Eai5DQwREq/V0OzIRb8UTeCB1hGmCA+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Borislav Petkov <bp@suse.de>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 008/136] x86/entry: Move CLD to the start of the idtentry macro
Date:   Mon, 29 Aug 2022 12:57:55 +0200
Message-Id: <20220829105804.988641394@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

commit c64cc2802a784ecfd25d39945e57e7a147854a5b upstream.

Move it after CLAC.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220503032107.680190-5-jiangshanlai@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -373,6 +373,7 @@ SYM_CODE_END(xen_error_entry)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 	ASM_CLAC
+	cld
 
 	.if \has_error_code == 0
 		pushq	$-1			/* ORIG_RAX: no syscall to restart */
@@ -440,6 +441,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS
 	ASM_CLAC
+	cld
 
 	pushq	$-1			/* ORIG_RAX: no syscall to restart */
 
@@ -495,6 +497,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS
 	ASM_CLAC
+	cld
 
 	/*
 	 * If the entry is from userspace, switch stacks and treat it as
@@ -557,6 +560,7 @@ SYM_CODE_END(\asmsym)
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS offset=8
 	ASM_CLAC
+	cld
 
 	/* paranoid_entry returns GS information for paranoid_exit in EBX. */
 	call	paranoid_entry
@@ -876,7 +880,6 @@ SYM_CODE_END(xen_failsafe_callback)
  */
 SYM_CODE_START_LOCAL(paranoid_entry)
 	UNWIND_HINT_FUNC
-	cld
 	PUSH_AND_CLEAR_REGS save_ret=1
 	ENCODE_FRAME_POINTER 8
 
@@ -1012,7 +1015,6 @@ SYM_CODE_END(paranoid_exit)
  */
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
-	cld
 
 	PUSH_AND_CLEAR_REGS save_ret=1
 	ENCODE_FRAME_POINTER 8
@@ -1155,6 +1157,7 @@ SYM_CODE_START(asm_exc_nmi)
 	 */
 
 	ASM_CLAC
+	cld
 
 	/* Use %rdx as our temp variable throughout */
 	pushq	%rdx
@@ -1174,7 +1177,6 @@ SYM_CODE_START(asm_exc_nmi)
 	 */
 
 	swapgs
-	cld
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdx
 	movq	%rsp, %rdx


