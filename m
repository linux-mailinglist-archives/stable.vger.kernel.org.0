Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A357AC40
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiGTBTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241435AbiGTBSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:18:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4466ADB;
        Tue, 19 Jul 2022 18:15:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D996B81DC0;
        Wed, 20 Jul 2022 01:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE03C341CB;
        Wed, 20 Jul 2022 01:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279698;
        bh=7uBNXbLggcuOPXNHQ1tqRrJpC5voLMlSHr8dtTMW67E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNJTyfkLKSiddmM9lP65EDCWXbtSDWBw0e8a7OfUq1FDWwXNEkcFLu65fMyJIyh+c
         FXa+HF3mICV5EhnNO19dB9Zh90ysjgUoftJ/fwAOUa4vX9fzRLC3Mdm+BmU7zsNqtt
         xbYZrDt4gre9rv57518iKEMP1z/fQSG52MyOMe2Btu0q3wjCRNh47MpypQIzzqbqka
         skIsVODkRbsEijQKVmo0yv27ArZBLxSpzwQHhJwe+biO2xJwplC9qmTMUFPBtn1Va4
         tjyh5r1+wzZBCwI+QgWsZGTyqM4lMUac3aYJfvV5WP21taVy+k2eu367UNRFQHYkDU
         96Sey0+POwdww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jgross@suse.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.15 16/42] x86/xen: Rename SYS* entry points
Date:   Tue, 19 Jul 2022 21:13:24 -0400
Message-Id: <20220720011350.1024134-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b75b7f8ef1148be1b9321ffc2f6c19238904b438 ]

Native SYS{CALL,ENTER} entry points are called
entry_SYS{CALL,ENTER}_{64,compat}, make sure the Xen versions are
named consistently.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c   |  6 +++---
 arch/x86/xen/xen-asm.S | 20 ++++++++++----------
 arch/x86/xen/xen-ops.h |  6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 8bfc10330107..1f80dd3a2dd4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -922,7 +922,7 @@ void xen_enable_sysenter(void)
 	if (!boot_cpu_has(sysenter_feature))
 		return;
 
-	ret = register_callback(CALLBACKTYPE_sysenter, xen_sysenter_target);
+	ret = register_callback(CALLBACKTYPE_sysenter, xen_entry_SYSENTER_compat);
 	if(ret != 0)
 		setup_clear_cpu_cap(sysenter_feature);
 }
@@ -931,7 +931,7 @@ void xen_enable_syscall(void)
 {
 	int ret;
 
-	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
+	ret = register_callback(CALLBACKTYPE_syscall, xen_entry_SYSCALL_64);
 	if (ret != 0) {
 		printk(KERN_ERR "Failed to set syscall callback: %d\n", ret);
 		/* Pretty fatal; 64-bit userspace has no other
@@ -940,7 +940,7 @@ void xen_enable_syscall(void)
 
 	if (boot_cpu_has(X86_FEATURE_SYSCALL32)) {
 		ret = register_callback(CALLBACKTYPE_syscall32,
-					xen_syscall32_target);
+					xen_entry_SYSCALL_compat);
 		if (ret != 0)
 			setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 	}
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 962d30ea01a2..2cf22624012c 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -227,7 +227,7 @@ SYM_CODE_END(xenpv_restore_regs_and_return_to_usermode)
  */
 
 /* Normal 64-bit system call target */
-SYM_CODE_START(xen_syscall_target)
+SYM_CODE_START(xen_entry_SYSCALL_64)
 	UNWIND_HINT_EMPTY
 	popq %rcx
 	popq %r11
@@ -241,12 +241,12 @@ SYM_CODE_START(xen_syscall_target)
 	movq $__USER_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_64_after_hwframe
-SYM_CODE_END(xen_syscall_target)
+SYM_CODE_END(xen_entry_SYSCALL_64)
 
 #ifdef CONFIG_IA32_EMULATION
 
 /* 32-bit compat syscall target */
-SYM_CODE_START(xen_syscall32_target)
+SYM_CODE_START(xen_entry_SYSCALL_compat)
 	UNWIND_HINT_EMPTY
 	popq %rcx
 	popq %r11
@@ -260,10 +260,10 @@ SYM_CODE_START(xen_syscall32_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_compat_after_hwframe
-SYM_CODE_END(xen_syscall32_target)
+SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 /* 32-bit compat sysenter target */
-SYM_CODE_START(xen_sysenter_target)
+SYM_CODE_START(xen_entry_SYSENTER_compat)
 	UNWIND_HINT_EMPTY
 	/*
 	 * NB: Xen is polite and clears TF from EFLAGS for us.  This means
@@ -281,18 +281,18 @@ SYM_CODE_START(xen_sysenter_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSENTER_compat_after_hwframe
-SYM_CODE_END(xen_sysenter_target)
+SYM_CODE_END(xen_entry_SYSENTER_compat)
 
 #else /* !CONFIG_IA32_EMULATION */
 
-SYM_CODE_START(xen_syscall32_target)
-SYM_CODE_START(xen_sysenter_target)
+SYM_CODE_START(xen_entry_SYSCALL_compat)
+SYM_CODE_START(xen_entry_SYSENTER_compat)
 	UNWIND_HINT_EMPTY
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
 	jmp hypercall_iret
-SYM_CODE_END(xen_sysenter_target)
-SYM_CODE_END(xen_syscall32_target)
+SYM_CODE_END(xen_entry_SYSENTER_compat)
+SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 #endif	/* CONFIG_IA32_EMULATION */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 8bc8b72a205d..16aed4b12129 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -10,10 +10,10 @@
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_failsafe_callback[];
 
-void xen_sysenter_target(void);
+void xen_entry_SYSENTER_compat(void);
 #ifdef CONFIG_X86_64
-void xen_syscall_target(void);
-void xen_syscall32_target(void);
+void xen_entry_SYSCALL_64(void);
+void xen_entry_SYSCALL_compat(void);
 #endif
 
 extern void *xen_initial_gdt;
-- 
2.35.1

