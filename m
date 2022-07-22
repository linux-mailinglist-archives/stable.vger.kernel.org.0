Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB99257DEC2
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiGVJTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiGVJTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3CC140A7;
        Fri, 22 Jul 2022 02:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0F5461F94;
        Fri, 22 Jul 2022 09:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC78C341C6;
        Fri, 22 Jul 2022 09:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481196;
        bh=Lb9QWk96WPTUHtVIDQUUvFBZ7ad51b1dDmFNTdktXKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9vGtcIUEx3TN3e+7YEVI1rQRQg3mp7wm4adcnwRRcn+smkglYIelUdZ2o8WVxiG0
         XGLsgD188UlHvQMmCnlPLHBZzQzFV9fFR+7aHtxJRU2zgWEV/R4+rwTyvCxbxpveI0
         pe02AmgyWM0V8eXOu+Tk+bFiRRwTb0V1vPrBYW84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 28/89] x86/retpoline: Use -mfunction-return
Date:   Fri, 22 Jul 2022 11:11:02 +0200
Message-Id: <20220722091134.942401952@linuxfoundation.org>
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

commit 0b53c374b9eff2255a386f1f1cfb9a928e52a5ae upstream.

Utilize -mfunction-return=thunk-extern when available to have the
compiler replace RET instructions with direct JMPs to the symbol
__x86_return_thunk. This does not affect assembler (.S) sources, only C
sources.

-mfunction-return=thunk-extern has been available since gcc 7.3 and
clang 15.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: RETPOLINE_CFLAGS is at Makefile]
[cascardo: remove ANNOTATE_NOENDBR from __x86_return_thunk]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                             |    2 ++
 arch/x86/include/asm/nospec-branch.h |    2 ++
 arch/x86/lib/retpoline.S             |   12 ++++++++++++
 3 files changed, 16 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -687,11 +687,13 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
+RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
+RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 endif
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -120,6 +120,8 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
+extern void __x86_return_thunk(void);
+
 #ifdef CONFIG_RETPOLINE
 
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -66,3 +66,15 @@ SYM_CODE_END(__x86_indirect_thunk_array)
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
+
+/*
+ * This function name is magical and is used by -mfunction-return=thunk-extern
+ * for the compiler to generate JMPs to it.
+ */
+SYM_CODE_START(__x86_return_thunk)
+	UNWIND_HINT_EMPTY
+	ret
+	int3
+SYM_CODE_END(__x86_return_thunk)
+
+__EXPORT_THUNK(__x86_return_thunk)


