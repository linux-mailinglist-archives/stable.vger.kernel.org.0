Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD0551A36
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244526AbiFTNFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244855AbiFTNEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501C71ADB4;
        Mon, 20 Jun 2022 05:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AD7CB811A6;
        Mon, 20 Jun 2022 12:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEAEC3411B;
        Mon, 20 Jun 2022 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729935;
        bh=hoomPFvizVhvLiU8GGXlQ5OeL4zUjz8Sg1399iIawpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmsjvorF7akC2HHLoJpKIM3hLtfacVs120xx7ynyWyeNUXxykh/7sk3wkpq4+L4zm
         Ykk8q1y4nQSpAk/8WxHltgjYb4rS1er+9e3aZwgy3NB/3Dtjf9ues+Evvwpq+KJrtq
         WEKupau2aQjS3i5GmO1VxLscN4upIWYlA3Lf8brk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/141] x86/ftrace: Remove OBJECT_FILES_NON_STANDARD usage
Date:   Mon, 20 Jun 2022 14:50:27 +0200
Message-Id: <20220620124732.176155347@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 7b6c7a877cc616bc7dc9cd39646fe454acbed48b ]

The file-wide OBJECT_FILES_NON_STANDARD annotation is used with
CONFIG_FRAME_POINTER to tell objtool to skip the entire file when frame
pointers are enabled.  However that annotation is now deprecated because
it doesn't work with IBT, where objtool runs on vmlinux.o instead of
individual translation units.

Instead, use more fine-grained function-specific annotations:

- The 'save_mcount_regs' macro does funny things with the frame pointer.
  Use STACK_FRAME_NON_STANDARD_FP to tell objtool to ignore the
  functions using it.

- The return_to_handler() "function" isn't actually a callable function.
  Instead of being called, it's returned to.  The real return address
  isn't on the stack, so unwinding is already doomed no matter which
  unwinder is used.  So just remove the STT_FUNC annotation, telling
  objtool to ignore it.  That also removes the implicit
  ANNOTATE_NOENDBR, which now needs to be made explicit.

Fixes the following warning:

  vmlinux.o: warning: objtool: __fentry__+0x16: return with modified stack frame

Fixes: ed53a0d97192 ("x86/alternative: Use .ibt_endbr_seal to seal indirect calls")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/b7a7a42fe306aca37826043dac89e113a1acdbac.1654268610.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/Makefile      |  4 ----
 arch/x86/kernel/ftrace_64.S   | 11 ++++++++---
 include/linux/objtool.h       |  6 ++++++
 tools/include/linux/objtool.h |  6 ++++++
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index c41ef42adbe8..25828e4c6237 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,10 +36,6 @@ KCSAN_SANITIZE := n
 
 OBJECT_FILES_NON_STANDARD_test_nx.o			:= y
 
-ifdef CONFIG_FRAME_POINTER
-OBJECT_FILES_NON_STANDARD_ftrace_$(BITS).o		:= y
-endif
-
 # If instrumentation of this dir is enabled, boot hangs during first second.
 # Probably could be more selective here, but note that files related to irqs,
 # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 4ec13608d3c6..dfeb227de561 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -175,6 +175,7 @@ SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
 
 	jmp ftrace_epilogue
 SYM_FUNC_END(ftrace_caller);
+STACK_FRAME_NON_STANDARD_FP(ftrace_caller)
 
 SYM_FUNC_START(ftrace_epilogue)
 /*
@@ -282,6 +283,7 @@ SYM_INNER_LABEL(ftrace_regs_caller_end, SYM_L_GLOBAL)
 	jmp	ftrace_epilogue
 
 SYM_FUNC_END(ftrace_regs_caller)
+STACK_FRAME_NON_STANDARD_FP(ftrace_regs_caller)
 
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
@@ -311,10 +313,14 @@ trace:
 	jmp ftrace_stub
 SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
+STACK_FRAME_NON_STANDARD_FP(__fentry__)
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-SYM_FUNC_START(return_to_handler)
+SYM_CODE_START(return_to_handler)
+	UNWIND_HINT_EMPTY
+	ANNOTATE_NOENDBR
 	subq  $16, %rsp
 
 	/* Save the return values */
@@ -339,7 +345,6 @@ SYM_FUNC_START(return_to_handler)
 	int3
 .Ldo_rop:
 	mov %rdi, (%rsp)
-	UNWIND_HINT_FUNC
 	RET
-SYM_FUNC_END(return_to_handler)
+SYM_CODE_END(return_to_handler)
 #endif
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 586d35720f13..c81ea2264ad8 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD_FP func:req
+#ifdef CONFIG_FRAME_POINTER
+	STACK_FRAME_NON_STANDARD \func
+#endif
+.endm
+
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 586d35720f13..c81ea2264ad8 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -141,6 +141,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD_FP func:req
+#ifdef CONFIG_FRAME_POINTER
+	STACK_FRAME_NON_STANDARD \func
+#endif
+.endm
+
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
-- 
2.35.1



