Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF1B57234B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiGLSqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiGLSp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87147DAB9A;
        Tue, 12 Jul 2022 11:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C75D061ACC;
        Tue, 12 Jul 2022 18:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A96CC3411C;
        Tue, 12 Jul 2022 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651363;
        bh=D6Pxm5LuSsNkFmaR1etmsshRJ2ZUFrmrGMIFvboJej0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpNo/GkyjKCHucRkLpnmr20AbDK2b4rnwFAxc8lIVjCiuIFP/Ld3gPz4Tautq975V
         mVqcLWL+cumMHD8+jk3LLA5vxcZlyH/pXM3RmSbFHd3R1yRcJjXc+SrQswhrUT0UZZ
         sfxjVtZ8osgcwIjklvcw2CI5adzeoqp0LTgWFya4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 054/130] x86/retpoline: Create a retpoline thunk array
Date:   Tue, 12 Jul 2022 20:38:20 +0200
Message-Id: <20220712183248.936302019@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

commit 1a6f74429c42a3854980359a758e222005712aee upstream.

Stick all the retpolines in a single symbol and have the individual
thunks as inner labels, this should guarantee thunk order and layout.

Previously there were 16 (or rather 15 without rsp) separate symbols and
a toolchain might reasonably expect it could displace them however it
liked, with disregard for their relative position.

However, now they're part of a larger symbol. Any change to their
relative position would disrupt this larger _array symbol and thus not
be sound.

This is the same reasoning used for data symbols. On their own there
is no guarantee about their relative position wrt to one aonther, but
we're still able to do arrays because an array as a whole is a single
larger symbol.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.169659320@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    8 +++++++-
 arch/x86/lib/retpoline.S             |   14 +++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -12,6 +12,8 @@
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
 
+#define RETPOLINE_THUNK_SIZE	32
+
 /*
  * Fill the CPU return stack buffer.
  *
@@ -120,11 +122,15 @@
 
 #ifdef CONFIG_RETPOLINE
 
+typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
+
 #define GEN(reg) \
-	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
+	extern retpoline_thunk_t __x86_indirect_thunk_ ## reg;
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
 
+extern retpoline_thunk_t __x86_indirect_thunk_array[];
+
 #ifdef CONFIG_X86_64
 
 /*
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -28,16 +28,14 @@
 
 .macro THUNK reg
 
-	.align 32
-
-SYM_FUNC_START(__x86_indirect_thunk_\reg)
+	.align RETPOLINE_THUNK_SIZE
+SYM_INNER_LABEL(__x86_indirect_thunk_\reg, SYM_L_GLOBAL)
+	UNWIND_HINT_EMPTY
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
 		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 
-SYM_FUNC_END(__x86_indirect_thunk_\reg)
-
 .endm
 
 /*
@@ -55,10 +53,16 @@ SYM_FUNC_END(__x86_indirect_thunk_\reg)
 #define __EXPORT_THUNK(sym)	_ASM_NOKPROBE(sym); EXPORT_SYMBOL(sym)
 #define EXPORT_THUNK(reg)	__EXPORT_THUNK(__x86_indirect_thunk_ ## reg)
 
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_START(__x86_indirect_thunk_array)
+
 #define GEN(reg) THUNK reg
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
 
+	.align RETPOLINE_THUNK_SIZE
+SYM_CODE_END(__x86_indirect_thunk_array)
+
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 #undef GEN


