Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BE75724AE
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiGLTCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiGLTCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C7B109E;
        Tue, 12 Jul 2022 11:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18E761257;
        Tue, 12 Jul 2022 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B61BC3411C;
        Tue, 12 Jul 2022 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651751;
        bh=oCx4n0QKS697SzZZs9wYUrdZdNcVzFWsGdUnsN5H64Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYTRc2q0WApEGPyAkAVwLNG3pykzoJNWPWZSxio1vwwW7K8KwnivpXjXJrKKf3rgN
         uUoQjXzFzxkg83IchVehpIm9cogm/zfbvSfuCy0p+1XOTu7BHoBmp/X2SX1Tdqfw9N
         /GqO7bCipfz+Nr1IWWDO5Xs8lP55K9PxmLuR7Y8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 14/78] x86/retpoline: Create a retpoline thunk array
Date:   Tue, 12 Jul 2022 20:38:44 +0200
Message-Id: <20220712183239.421292726@linuxfoundation.org>
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
 		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
 
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


