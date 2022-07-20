Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054FC57ABB5
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiGTBNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240629AbiGTBNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:13:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3393965D67;
        Tue, 19 Jul 2022 18:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4DA6B81DE2;
        Wed, 20 Jul 2022 01:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F0BC341C6;
        Wed, 20 Jul 2022 01:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279540;
        bh=se13wqNAU03fkusB034b6xASwBWff55lqW/hoGYd2K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDkHxyizi2wjo7VeaiktZ9F4/H5R+EtJyJpf3OZonarB8LCuxq7TUAKLcYWH8bBJc
         OKr2VNbXY5iMk1EZj+WxHiIGlf/ZaJYTMKsIJHvZsPp38BJTwkNYmdTRoT3LGt515T
         EsIp55XnFPVSJvMDz11y0qNip2IWUJ4YeQAbtPCeOSH9q8jHxvsbM4KMaTjHMpf7JS
         QzWbrR8sNFNBtT8Sbauy1zz1Jif6SC7D+VNpNsVdARlwNQLdkxidSJvS9whwyG/Giz
         wh3pJoTI/NdYhUmSJUB8qN7aZVwM72RA8+y8C6ysW+22EfJ2Bxvgn2BNCk2hb0lqzi
         c3YlsDqUfbqvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        luto@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        pawan.kumar.gupta@linux.intel.com
Subject: [PATCH AUTOSEL 5.18 24/54] x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
Date:   Tue, 19 Jul 2022 21:10:01 -0400
Message-Id: <20220720011031.1023305-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit b2620facef4889fefcbf2e87284f34dcd4189bce ]

If a kernel is built with CONFIG_RETPOLINE=n, but the user still wants
to mitigate Spectre v2 using IBRS or eIBRS, the RSB filling will be
silently disabled.

There's nothing retpoline-specific about RSB buffer filling.  Remove the
CONFIG_RETPOLINE guards around it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_32.S            | 2 --
 arch/x86/entry/entry_64.S            | 2 --
 arch/x86/include/asm/nospec-branch.h | 2 --
 3 files changed, 6 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 887420844066..e309e7156038 100644
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
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index d8376e5fe1af..024367c81b7e 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -245,7 +245,6 @@ SYM_FUNC_START(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(fixed_percpu_data) + stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -254,7 +253,6 @@ SYM_FUNC_START(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popq	%r15
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index a790109f9337..257d24a67a81 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -111,11 +111,9 @@
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
2.35.1

