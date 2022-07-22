Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1684957DE45
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiGVJMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiGVJMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:12:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3C8A0BA7;
        Fri, 22 Jul 2022 02:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1D5DB827B2;
        Fri, 22 Jul 2022 09:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468EBC341C6;
        Fri, 22 Jul 2022 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658480993;
        bh=uhBrisFVLThMsYeuo2ULPy9OQBk+D9VBI8P0/O0N2yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUXCllJYoxepP9ZFZkcfNMsHtQIrrFWWk5VFjuuXulr10RzMkiCvF+eUd/Kkk5DNx
         GNVZtkoo5T5C4BdMQOoXm+4WVvUnt7mKUGmIJIMG4fNSg9B73g+AgTi0ggDFmbk/Xg
         w90CgA2Vtol73R+GYe6pytMV9UxOyU2LQWDXZS2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 41/70] x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
Date:   Fri, 22 Jul 2022 11:07:36 +0200
Message-Id: <20220722090653.018672773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit b2620facef4889fefcbf2e87284f34dcd4189bce upstream.

If a kernel is built with CONFIG_RETPOLINE=n, but the user still wants
to mitigate Spectre v2 using IBRS or eIBRS, the RSB filling will be
silently disabled.

There's nothing retpoline-specific about RSB buffer filling.  Remove the
CONFIG_RETPOLINE guards around it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S            |    2 --
 arch/x86/entry/entry_64.S            |    2 --
 arch/x86/include/asm/nospec-branch.h |    2 --
 3 files changed, 6 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -698,7 +698,6 @@ SYM_CODE_START(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(__stack_chk_guard)
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -707,7 +706,6 @@ SYM_CODE_START(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* Restore flags or the incoming task to restore AC state. */
 	popfl
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -250,7 +250,6 @@ SYM_FUNC_START(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(fixed_percpu_data) + stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -259,7 +258,6 @@ SYM_FUNC_START(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popq	%r15
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -122,11 +122,9 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
-#endif
 .endm
 
 /*


