Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3919F57EE15
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbiGWKG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbiGWKGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:06:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE8376955;
        Sat, 23 Jul 2022 03:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F082B82C22;
        Sat, 23 Jul 2022 10:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF6C341C0;
        Sat, 23 Jul 2022 10:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570456;
        bh=BFyioED30kwJD9PGGxY9ZF6TW0CFgre5ZqlPuYrWpL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMiu8dTBqOz0iMWuu4dmBRinvClG07BErClAeVmQw7ZbOCibktUK1n8UX8JWY3HHq
         Jgkwnk9VQoj547b+Tzn2GYv5GlbIR43kgj6yBF3pTHsyZ8bTnOvMF2gEgZ3QJfCmxi
         BqVA5qCaubz/vScT65dy0lnrLhyhdcWoO+C9uUHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 093/148] x86: Use return-thunk in asm code
Date:   Sat, 23 Jul 2022 11:55:05 +0200
Message-Id: <20220723095250.449568556@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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

commit aa3d480315ba6c3025a60958e1981072ea37c3df upstream.

Use the return thunk in asm code. If the thunk isn't needed, it will
get patched into a RET instruction during boot by apply_returns().

Since alternatives can't handle relocations outside of the first
instruction, putting a 'jmp __x86_return_thunk' in one is not valid,
therefore carve out the memmove ERMS path into a separate label and jump
to it.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: no RANDSTRUCT_CFLAGS]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[bwh: Backported to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vdso/Makefile   |    1 +
 arch/x86/include/asm/linkage.h |    8 ++++++++
 arch/x86/lib/memmove_64.S      |    7 ++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -91,6 +91,7 @@ endif
 endif
 
 $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs): KBUILD_AFLAGS += -DBUILD_VDSO
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,19 +18,27 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
+#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#define RET	jmp __x86_return_thunk
+#else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
 #define RET	ret; int3
 #else
 #define RET	ret
 #endif
+#endif /* CONFIG_RETPOLINE */
 
 #else /* __ASSEMBLY__ */
 
+#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#define ASM_RET	"jmp __x86_return_thunk\n\t"
+#else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
 #define ASM_RET	"ret; int3\n\t"
 #else
 #define ASM_RET	"ret\n\t"
 #endif
+#endif /* CONFIG_RETPOLINE */
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memmove)
 	/* FSRM implies ERMS => no length checks, do the copy directly */
 .Lmemmove_begin_forward:
 	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
-	ALTERNATIVE "", __stringify(movq %rdx, %rcx; rep movsb; RET), X86_FEATURE_ERMS
+	ALTERNATIVE "", "jmp .Lmemmove_erms", X86_FEATURE_ERMS
 
 	/*
 	 * movsq instruction have many startup latency
@@ -206,6 +206,11 @@ SYM_FUNC_START(__memmove)
 	movb %r11b, (%rdi)
 13:
 	RET
+
+.Lmemmove_erms:
+	movq %rdx, %rcx
+	rep movsb
+	RET
 SYM_FUNC_END(__memmove)
 SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)


