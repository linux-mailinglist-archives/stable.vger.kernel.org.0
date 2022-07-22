Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B7357DE9B
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiGVJR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiGVJRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:17:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84149B8512;
        Fri, 22 Jul 2022 02:12:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A22D861F6A;
        Fri, 22 Jul 2022 09:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A480EC341C6;
        Fri, 22 Jul 2022 09:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481151;
        bh=Wt+EB/dW/0u8BsAcTs5fV+lx/gIguU83xTSddMOXCJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPGvNTrIjgEBFUPPIacWJlokHwpKa9Bixk9PCH4YGp8hhZ7dMsB3W8PIvOueyqOjR
         eiFucSsTCs0TIyqJlcgws4NHgrr0e1j6Rc/NU8lAsWZKF4vBWNwL+96MWPT1Ci28uP
         cZcHiOl8/mzFN5ioa1vZEOi5lXR9IBPjSH2C9XCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 13/89] x86/retpoline: Move the retpoline thunk declarations to nospec-branch.h
Date:   Fri, 22 Jul 2022 11:10:47 +0200
Message-Id: <20220722091134.116235762@linuxfoundation.org>
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

commit 6fda8a38865607db739be3e567a2387376222dbd upstream.

Because it makes no sense to split the retpoline gunk over multiple
headers.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.106290934@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm-prototypes.h |    8 --------
 arch/x86/include/asm/nospec-branch.h  |    7 +++++++
 arch/x86/net/bpf_jit_comp.c           |    1 -
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -17,11 +17,3 @@
 extern void cmpxchg8b_emu(void);
 #endif
 
-#ifdef CONFIG_RETPOLINE
-
-#define GEN(reg) \
-	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
-#include <asm/GEN-for-each-reg.h>
-#undef GEN
-
-#endif /* CONFIG_RETPOLINE */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -5,6 +5,7 @@
 
 #include <linux/static_key.h>
 #include <linux/objtool.h>
+#include <linux/linkage.h>
 
 #include <asm/alternative.h>
 #include <asm/cpufeatures.h>
@@ -118,6 +119,12 @@
 	".popsection\n\t"
 
 #ifdef CONFIG_RETPOLINE
+
+#define GEN(reg) \
+	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
+#include <asm/GEN-for-each-reg.h>
+#undef GEN
+
 #ifdef CONFIG_X86_64
 
 /*
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -15,7 +15,6 @@
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
 #include <asm/text-patching.h>
-#include <asm/asm-prototypes.h>
 
 static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 {


