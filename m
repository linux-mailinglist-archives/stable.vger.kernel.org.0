Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011E457247B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiGLTAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiGLS7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABB2F4239;
        Tue, 12 Jul 2022 11:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6970260A5A;
        Tue, 12 Jul 2022 18:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581A4C3411C;
        Tue, 12 Jul 2022 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651699;
        bh=Lb9QWk96WPTUHtVIDQUUvFBZ7ad51b1dDmFNTdktXKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tm9+oXXdw20XKg5UIC5GyI1+mXJq9HKr7f1sIUkWqGmyOrJ4YxWQM6TBQaRjE+3iM
         S8IRbXTa0BZu/fhkuITjznLDhAP339iiF7TLw49qR6n5ZfAfXSjllBCC6vmDelLBEw
         HCGg1bmC0vXITFHmYpaW+qmjpDf3iZ42N+yqjFR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 28/78] x86/retpoline: Use -mfunction-return
Date:   Tue, 12 Jul 2022 20:38:58 +0200
Message-Id: <20220712183239.940184256@linuxfoundation.org>
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


