Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784AE5F30DA
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJCNMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJCNM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:29 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B124F4E620;
        Mon,  3 Oct 2022 06:12:25 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id DECC742EBB;
        Mon,  3 Oct 2022 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802725;
        bh=es9OKLr/JMPhhfhlI6Lp1PYmtYa5VJbXBokGZuEHNKI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=TR5p28hoTJo4I7GVI6VlINkc/o0tUCShJRQoteGzjjdhVj0OXCVf1HUHDSu1mbKbh
         Jy+lp3ukLBKEut+DBs0OBLWr5R+8ohZTOYcOjy0Qr0etzm5G1CtgfH9lEjIck6hMQO
         T8BqLy7BpMDOfvG9Fbj7OPsHLV+sCZvMdQG1Qoncqb7faIcCRvo4a+4akU0fjil5Bm
         uBJgcc1Smw0riTQlpHzC7wj6uqwIY5fgH35N9SLsJpv5ROHcRQaxt7k31KnknU9k3j
         CPO7tWtCwXsbnoZSqnvFfRyyHf+u8aYSby+en/nGCkjHitKiAFuTjupPx5sygxP7z+
         ii+/O/6OeIF9g==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 19/37] x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
Date:   Mon,  3 Oct 2022 10:10:20 -0300
Message-Id: <20221003131038.12645-20-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
---
 arch/x86/entry/entry_32.S            | 2 --
 arch/x86/entry/entry_64.S            | 2 --
 arch/x86/include/asm/nospec-branch.h | 2 --
 3 files changed, 6 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index bde3e0f85425..2d837fb54c31 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -750,7 +750,6 @@ ENTRY(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -759,7 +758,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfl
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 4a45808a27c2..c82136030d58 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -305,7 +305,6 @@ ENTRY(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(fixed_percpu_data) + stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -314,7 +313,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popq	%r15
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 460360cfab5a..b7201f24796c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -155,11 +155,9 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
-#endif
 .endm
 
 #else /* __ASSEMBLY__ */
-- 
2.34.1

