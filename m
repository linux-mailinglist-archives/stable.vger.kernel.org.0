Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D93572520
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiGLTHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiGLTHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B2E43F9;
        Tue, 12 Jul 2022 11:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D42561578;
        Tue, 12 Jul 2022 18:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E3DC3411C;
        Tue, 12 Jul 2022 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651873;
        bh=DfqqxgL1oa25Fb2YprLqTxborguWklpYaCo7MDYJn8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX7McGpuCrFGJA8xgVuYAaq/j+Gi3LJh2ocD20oAHGgHWTDiP06/BAZGFNi/FhfH3
         ggnMZuHzYVIa1/OLBZnvIYU+zVZaXQ/iDErEVeyCb8oDLIenB/pl7DLdVXE5JufDR7
         1NZKkJTj+aiJ8N7Ya+6iegG3abFB4fxZm+rFVFu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 74/78] x86/entry: Move PUSH_AND_CLEAR_REGS() back into error_entry
Date:   Tue, 12 Jul 2022 20:39:44 +0200
Message-Id: <20220712183241.888485231@linuxfoundation.org>
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
 


