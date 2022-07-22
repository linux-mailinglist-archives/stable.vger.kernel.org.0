Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39957DD85
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiGVJZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbiGVJZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:25:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5768AC5D4F;
        Fri, 22 Jul 2022 02:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D26761FFF;
        Fri, 22 Jul 2022 09:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643B9C341CA;
        Fri, 22 Jul 2022 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481372;
        bh=DfqqxgL1oa25Fb2YprLqTxborguWklpYaCo7MDYJn8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlpPVYJuxAOJvjn3Q90c4hAautuNGHsrTL10886cg3oCLEjyJhWAc/IFJcN7ZRK62
         MhAz9IMaZgwQmOhhRAVi4iT5nZzl8oW/5KkeRh40qSlUb+mmTRvcEHzcJa1gcPP5AE
         Y3dRCAfVkFUM8vFb5HfsqroPGm6hSkClsCKAJwAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 74/89] x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry
Date:   Fri, 22 Jul 2022 11:11:48 +0200
Message-Id: <20220722091137.485164274@linuxfoundation.org>
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
@@ -320,6 +320,8 @@ SYM_CODE_END(ret_from_fork)
 
 SYM_CODE_START_LOCAL(xen_error_entry)
 	UNWIND_HINT_FUNC
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
 	UNTRAIN_RET
 	RET
 SYM_CODE_END(xen_error_entry)
@@ -331,9 +333,6 @@ SYM_CODE_END(xen_error_entry)
  */
 .macro idtentry_body cfunc has_error_code:req
 
-	PUSH_AND_CLEAR_REGS
-	ENCODE_FRAME_POINTER
-
 	/*
 	 * Call error_entry() and switch to the task stack if from userspace.
 	 *
@@ -1014,6 +1013,10 @@ SYM_CODE_END(paranoid_exit)
 SYM_CODE_START_LOCAL(error_entry)
 	UNWIND_HINT_FUNC
 	cld
+
+	PUSH_AND_CLEAR_REGS save_ret=1
+	ENCODE_FRAME_POINTER 8
+
 	testb	$3, CS+8(%rsp)
 	jz	.Lerror_kernelspace
 


