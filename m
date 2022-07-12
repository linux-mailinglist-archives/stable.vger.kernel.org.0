Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A5572500
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiGLTKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiGLTJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E508D31D5;
        Tue, 12 Jul 2022 11:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 278C6B81BAB;
        Tue, 12 Jul 2022 18:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A328C3411C;
        Tue, 12 Jul 2022 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651928;
        bh=8XmEH2KkaR85M0+HGzx6p/eDV1VjnMNBHree5pGpxsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asDBiuBPLQODPLFsAhUIWebDnZ9JO59Dd3OU36vDvwq8IIlqPRdbWc+bRRSFJWG7l
         UQgzitm7kSNvtKSJtz7hl3LZjhaGEZTHIrJmEz0O7v4yxe9V8oAcP7v4MhM2pP7iyn
         PgthtPW6VqRbOUiT8vutQ8AivIcngVIoUNfkWfjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 08/61] x86/retpoline: Cleanup some #ifdefery
Date:   Tue, 12 Jul 2022 20:39:05 +0200
Message-Id: <20220712183237.288892049@linuxfoundation.org>
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

commit 369ae6ffc41a3c1137cab697635a84d0cc7cdcea upstream.

On it's own not much of a cleanup but it prepares for more/similar
code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/disabled-features.h |    9 ++++++++-
 arch/x86/include/asm/nospec-branch.h     |    7 +++----
 arch/x86/net/bpf_jit_comp.c              |    7 +++----
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,13 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_RETPOLINE
+# define DISABLE_RETPOLINE	0
+#else
+# define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 # define DISABLE_ENQCMD		0
 #else
@@ -82,7 +89,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_RETPOLINE)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -120,17 +120,16 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
-#ifdef CONFIG_RETPOLINE
-
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
+extern retpoline_thunk_t __x86_indirect_thunk_array[];
+
+#ifdef CONFIG_RETPOLINE
 
 #define GEN(reg) \
 	extern retpoline_thunk_t __x86_indirect_thunk_ ## reg;
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
 
-extern retpoline_thunk_t __x86_indirect_thunk_array[];
-
 #ifdef CONFIG_X86_64
 
 /*
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -407,16 +407,15 @@ static void emit_indirect_jump(u8 **ppro
 {
 	u8 *prog = *pprog;
 
-#ifdef CONFIG_RETPOLINE
 	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
 		OPTIMIZER_HIDE_VAR(reg);
 		emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
-	} else
-#endif
-	EMIT2(0xFF, 0xE0 + reg);
+	} else {
+		EMIT2(0xFF, 0xE0 + reg);
+	}
 
 	*pprog = prog;
 }


