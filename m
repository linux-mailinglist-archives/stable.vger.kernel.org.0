Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25F572559
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiGLTOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbiGLTNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:13:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB69C33343;
        Tue, 12 Jul 2022 11:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B333FB81B95;
        Tue, 12 Jul 2022 18:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD5AC3411C;
        Tue, 12 Jul 2022 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657652024;
        bh=Db31GERbbkoPzIxNMiIP982nUk5vWgFinkKHad116yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC1SLTwi+yCn0zXaYEItOSlZ3z9OErjw47jI+3svfsVIsxwwAjYfbKntfpKbw758r
         xBNWqFYybMedpo0owAh0T8FBPB+yOU1TzLu7EB7jcQwCL0JFk3QaHXsYe9HG1P2xp1
         EM8ZgLEpl3FfSOX2oerBvnSvlApvDntZ+7C/1Gog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 57/61] x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry
Date:   Tue, 12 Jul 2022 20:39:54 +0200
Message-Id: <20220712183239.144401501@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 2c08b9b38f5b0f4a6c2d29be22b695e4ec4a556b upstream.

Commit

  ee774dac0da1 ("x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()")

moved PUSH_AND_CLEAR_REGS out of error_entry, into its own function, in
part to avoid calling error_entry() for XenPV.

However, commit

  7c81c0c9210c ("x86/entry: Avoid very early RET")

had to change that because the 'ret' was too early and moved it into
idtentry, bloating the text size, since idtentry is expanded for every
exception vector.

However, with the advent of xen_error_entry() in commit

  d147553b64bad ("x86/xen: Add UNTRAIN_RET")

it became possible to remove PUSH_AND_CLEAR_REGS from idtentry, back
into *error_entry().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: error_entry still does cld]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -323,6 +323,8 @@ SYM_CODE_END(ret_from_fork)
 
 SYM_CODE_START_LOCAL(xen_error_entry)
 	UNWIND_HINT_FUNC
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
 	UNTRAIN_RET
 	RET
 SYM_CODE_END(xen_error_entry)
@@ -334,9 +336,6 @@ SYM_CODE_END(xen_error_entry)
  */
 .macro idtentry_body cfunc has_error_code:req
 
-	PUSH_AND_CLEAR_REGS
-	ENCODE_FRAME_POINTER
-
 	/*
 	 * Call error_entry() and switch to the task stack if from userspace.
 	 *
@@ -1035,6 +1034,10 @@ SYM_CODE_END(paranoid_exit)
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
 	cld
+
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
+
 	testb	$3, CS+8(%rsp)
 	jz	.Lerror_kernelspace
 


