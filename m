Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DC157AB8C
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbiGTBNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiGTBMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:12:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD59265D4A;
        Tue, 19 Jul 2022 18:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E21FB81DE0;
        Wed, 20 Jul 2022 01:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15B0C341D1;
        Wed, 20 Jul 2022 01:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279525;
        bh=c9nhF8SJnbgT1PcdEw9BhinCExmguSEsqIqZEydceYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3cR5F6y+stgqYnzhXPjbUzIQhCS5sZXrXN4QVNkuR7VlyfyV/5YA9/Q7emGkuSJI
         eyJcQ8TuaKGeFLk8/qUpYzovHxJ/F4tBcF7sPHtRw+witDUi8Ve3QiVrf0llTLc7kv
         PlQ9prkBWq87sUzL5uWuS+gFMrP84HcSxYT2DD9i1HTSTcMIatlYXy9tk5ctziLAJs
         Mdm8kFKq4qfrpUq1Q0EIMxE1JvdpOaMcdpoAtpQUtINBsFGxENOwUC9dkdD2WrbNhK
         GWq7gvObl89raDRtsHCxkX2+HbYpf4cmerLw3LjF24BdNcyVR/kD09i9hg6aso02OG
         RulKTONQgHJug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jgross@suse.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.18 21/54] x86/xen: Rename SYS* entry points
Date:   Tue, 19 Jul 2022 21:09:58 -0400
Message-Id: <20220720011031.1023305-21-sashal@kernel.org>
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
index 81aa46f770c5..cfa99e8f054b 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -918,7 +918,7 @@ void xen_enable_sysenter(void)
 	if (!boot_cpu_has(sysenter_feature))
 		return;
 
-	ret = register_callback(CALLBACKTYPE_sysenter, xen_sysenter_target);
+	ret = register_callback(CALLBACKTYPE_sysenter, xen_entry_SYSENTER_compat);
 	if(ret != 0)
 		setup_clear_cpu_cap(sysenter_feature);
 }
@@ -927,7 +927,7 @@ void xen_enable_syscall(void)
 {
 	int ret;
 
-	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
+	ret = register_callback(CALLBACKTYPE_syscall, xen_entry_SYSCALL_64);
 	if (ret != 0) {
 		printk(KERN_ERR "Failed to set syscall callback: %d\n", ret);
 		/* Pretty fatal; 64-bit userspace has no other
@@ -936,7 +936,7 @@ void xen_enable_syscall(void)
 
 	if (boot_cpu_has(X86_FEATURE_SYSCALL32)) {
 		ret = register_callback(CALLBACKTYPE_syscall32,
-					xen_syscall32_target);
+					xen_entry_SYSCALL_compat);
 		if (ret != 0)
 			setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 	}
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index caa9bc2fa100..6bf9d45b9178 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -234,7 +234,7 @@ SYM_CODE_END(xenpv_restore_regs_and_return_to_usermode)
  */
 
 /* Normal 64-bit system call target */
-SYM_CODE_START(xen_syscall_target)
+SYM_CODE_START(xen_entry_SYSCALL_64)
 	UNWIND_HINT_EMPTY
 	ENDBR
 	popq %rcx
@@ -249,12 +249,12 @@ SYM_CODE_START(xen_syscall_target)
 	movq $__USER_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_64_after_hwframe
-SYM_CODE_END(xen_syscall_target)
+SYM_CODE_END(xen_entry_SYSCALL_64)
 
 #ifdef CONFIG_IA32_EMULATION
 
 /* 32-bit compat syscall target */
-SYM_CODE_START(xen_syscall32_target)
+SYM_CODE_START(xen_entry_SYSCALL_compat)
 	UNWIND_HINT_EMPTY
 	ENDBR
 	popq %rcx
@@ -269,10 +269,10 @@ SYM_CODE_START(xen_syscall32_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_compat_after_hwframe
-SYM_CODE_END(xen_syscall32_target)
+SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 /* 32-bit compat sysenter target */
-SYM_CODE_START(xen_sysenter_target)
+SYM_CODE_START(xen_entry_SYSENTER_compat)
 	UNWIND_HINT_EMPTY
 	ENDBR
 	/*
@@ -291,19 +291,19 @@ SYM_CODE_START(xen_sysenter_target)
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
 	ENDBR
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
index fd0fec6e92f4..9a8bb972193d 100644
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

