Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F212310B991
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfK0Uyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbfK0Uyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:54:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 049EA21582;
        Wed, 27 Nov 2019 20:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888082;
        bh=+6aS1ImT4WmV3f7OiaiYoesrNZb5/9pfsLPO4niE78A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZ78xCCqTrdRSlyJR2L7Y6xK4ia3NngnfQvPtrXOTS2aOekxEFX8vYpAsKvgKaTT0
         5ez5/UbBaMOKRPpvyeUKo/C1Qn/0Jczmvcr4HRlthS/t95naPpya0lYG5sZ9KZEWTi
         iWYC3AjO8W+8dL6StfRUP5fYn10zgp4TIVDrEHfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthony Steinhauser <asteinhauser@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4.14 209/211] powerpc/book3s64: Fix link stack flush on context switch
Date:   Wed, 27 Nov 2019 21:32:22 +0100
Message-Id: <20191127203113.272304781@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 39e72bf96f5847ba87cc5bd7a3ce0fed813dc9ad upstream.

In commit ee13cb249fab ("powerpc/64s: Add support for software count
cache flush"), I added support for software to flush the count
cache (indirect branch cache) on context switch if firmware told us
that was the required mitigation for Spectre v2.

As part of that code we also added a software flush of the link
stack (return address stack), which protects against Spectre-RSB
between user processes.

That is all correct for CPUs that activate that mitigation, which is
currently Power9 Nimbus DD2.3.

What I got wrong is that on older CPUs, where firmware has disabled
the count cache, we also need to flush the link stack on context
switch.

To fix it we create a new feature bit which is not set by firmware,
which tells us we need to flush the link stack. We set that when
firmware tells us that either of the existing Spectre v2 mitigations
are enabled.

Then we adjust the patching code so that if we see that feature bit we
enable the link stack flush. If we're also told to flush the count
cache in software then we fall through and do that also.

On the older CPUs we don't need to do do the software count cache
flush, firmware has disabled it, so in that case we patch in an early
return after the link stack flush.

The naming of some of the functions is awkward after this patch,
because they're called "count cache" but they also do link stack. But
we'll fix that up in a later commit to ease backporting.

This is the fix for CVE-2019-18660.

Reported-by: Anthony Steinhauser <asteinhauser@google.com>
Fixes: ee13cb249fab ("powerpc/64s: Add support for software count cache flush")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[dja: straightforward backport to v4.14]
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/asm-prototypes.h    |    1 
 arch/powerpc/include/asm/security_features.h |    3 +
 arch/powerpc/kernel/entry_64.S               |    6 +++
 arch/powerpc/kernel/security.c               |   48 ++++++++++++++++++++++++---
 4 files changed, 54 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -129,6 +129,7 @@ unsigned long prepare_ftrace_return(unsi
 /* Patch sites */
 extern s32 patch__call_flush_count_cache;
 extern s32 patch__flush_count_cache_return;
+extern s32 patch__flush_link_stack_return;
 
 extern long flush_count_cache;
 
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -81,6 +81,9 @@ static inline bool security_ftr_enabled(
 // Software required to flush count cache on context switch
 #define SEC_FTR_FLUSH_COUNT_CACHE	0x0000000000000400ull
 
+// Software required to flush link stack on context switch
+#define SEC_FTR_FLUSH_LINK_STACK	0x0000000000001000ull
+
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -524,6 +524,7 @@ flush_count_cache:
 	/* Save LR into r9 */
 	mflr	r9
 
+	// Flush the link stack
 	.rept 64
 	bl	.+4
 	.endr
@@ -533,6 +534,11 @@ flush_count_cache:
 	.balign 32
 	/* Restore LR */
 1:	mtlr	r9
+
+	// If we're just flushing the link stack, return here
+3:	nop
+	patch_site 3b patch__flush_link_stack_return
+
 	li	r9,0x7fff
 	mtctr	r9
 
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -24,6 +24,7 @@ enum count_cache_flush_type {
 	COUNT_CACHE_FLUSH_HW	= 0x4,
 };
 static enum count_cache_flush_type count_cache_flush_type = COUNT_CACHE_FLUSH_NONE;
+static bool link_stack_flush_enabled;
 
 bool barrier_nospec_enabled;
 static bool no_nospec;
@@ -204,11 +205,19 @@ ssize_t cpu_show_spectre_v2(struct devic
 
 		if (ccd)
 			seq_buf_printf(&s, "Indirect branch cache disabled");
+
+		if (link_stack_flush_enabled)
+			seq_buf_printf(&s, ", Software link stack flush");
+
 	} else if (count_cache_flush_type != COUNT_CACHE_FLUSH_NONE) {
 		seq_buf_printf(&s, "Mitigation: Software count cache flush");
 
 		if (count_cache_flush_type == COUNT_CACHE_FLUSH_HW)
 			seq_buf_printf(&s, " (hardware accelerated)");
+
+		if (link_stack_flush_enabled)
+			seq_buf_printf(&s, ", Software link stack flush");
+
 	} else if (btb_flush_enabled) {
 		seq_buf_printf(&s, "Mitigation: Branch predictor state flush");
 	} else {
@@ -369,18 +378,40 @@ static __init int stf_barrier_debugfs_in
 device_initcall(stf_barrier_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
 
+static void no_count_cache_flush(void)
+{
+	count_cache_flush_type = COUNT_CACHE_FLUSH_NONE;
+	pr_info("count-cache-flush: software flush disabled.\n");
+}
+
 static void toggle_count_cache_flush(bool enable)
 {
-	if (!enable || !security_ftr_enabled(SEC_FTR_FLUSH_COUNT_CACHE)) {
+	if (!security_ftr_enabled(SEC_FTR_FLUSH_COUNT_CACHE) &&
+	    !security_ftr_enabled(SEC_FTR_FLUSH_LINK_STACK))
+		enable = false;
+
+	if (!enable) {
 		patch_instruction_site(&patch__call_flush_count_cache, PPC_INST_NOP);
-		count_cache_flush_type = COUNT_CACHE_FLUSH_NONE;
-		pr_info("count-cache-flush: software flush disabled.\n");
+		pr_info("link-stack-flush: software flush disabled.\n");
+		link_stack_flush_enabled = false;
+		no_count_cache_flush();
 		return;
 	}
 
+	// This enables the branch from _switch to flush_count_cache
 	patch_branch_site(&patch__call_flush_count_cache,
 			  (u64)&flush_count_cache, BRANCH_SET_LINK);
 
+	pr_info("link-stack-flush: software flush enabled.\n");
+	link_stack_flush_enabled = true;
+
+	// If we just need to flush the link stack, patch an early return
+	if (!security_ftr_enabled(SEC_FTR_FLUSH_COUNT_CACHE)) {
+		patch_instruction_site(&patch__flush_link_stack_return, PPC_INST_BLR);
+		no_count_cache_flush();
+		return;
+	}
+
 	if (!security_ftr_enabled(SEC_FTR_BCCTR_FLUSH_ASSIST)) {
 		count_cache_flush_type = COUNT_CACHE_FLUSH_SW;
 		pr_info("count-cache-flush: full software flush sequence enabled.\n");
@@ -399,11 +430,20 @@ void setup_count_cache_flush(void)
 	if (no_spectrev2 || cpu_mitigations_off()) {
 		if (security_ftr_enabled(SEC_FTR_BCCTRL_SERIALISED) ||
 		    security_ftr_enabled(SEC_FTR_COUNT_CACHE_DISABLED))
-			pr_warn("Spectre v2 mitigations not under software control, can't disable\n");
+			pr_warn("Spectre v2 mitigations not fully under software control, can't disable\n");
 
 		enable = false;
 	}
 
+	/*
+	 * There's no firmware feature flag/hypervisor bit to tell us we need to
+	 * flush the link stack on context switch. So we set it here if we see
+	 * either of the Spectre v2 mitigations that aim to protect userspace.
+	 */
+	if (security_ftr_enabled(SEC_FTR_COUNT_CACHE_DISABLED) ||
+	    security_ftr_enabled(SEC_FTR_FLUSH_COUNT_CACHE))
+		security_ftr_set(SEC_FTR_FLUSH_LINK_STACK);
+
 	toggle_count_cache_flush(enable);
 }
 


