Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5057EE33
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbiGWKI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiGWKHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521BCC5D44;
        Sat, 23 Jul 2022 03:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9324EB82B92;
        Sat, 23 Jul 2022 10:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03581C341C0;
        Sat, 23 Jul 2022 10:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570467;
        bh=ay3LWH7pBox0dI17p/VUYfmLXWQBubpVZeIlarQLFx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmdSTK5LKt9L4et0jru278zv+SiwnM6s7fcIIetPWX0xeFRy58eo5qubSXVNOgE6v
         1dGzh0aElSUEVCthRz1JC2L95wr4akXTot+l55jHiue/duZX1jHfzQro4ZZ91pOBrw
         vusk7OxLm+bgSNJZBAVuls75q4YSmmE5gBwruS8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 107/148] x86/xen: Rename SYS* entry points
Date:   Sat, 23 Jul 2022 11:55:19 +0200
Message-Id: <20220723095254.324728586@linuxfoundation.org>
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

commit b75b7f8ef1148be1b9321ffc2f6c19238904b438 upstream.

Native SYS{CALL,ENTER} entry points are called
entry_SYS{CALL,ENTER}_{64,compat}, make sure the Xen versions are
named consistently.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/setup.c   |    6 +++---
 arch/x86/xen/xen-asm.S |   20 ++++++++++----------
 arch/x86/xen/xen-ops.h |    6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

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
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -276,7 +276,7 @@ SYM_CODE_END(xenpv_restore_regs_and_retu
  */
 
 /* Normal 64-bit system call target */
-SYM_CODE_START(xen_syscall_target)
+SYM_CODE_START(xen_entry_SYSCALL_64)
 	UNWIND_HINT_EMPTY
 	popq %rcx
 	popq %r11
@@ -290,12 +290,12 @@ SYM_CODE_START(xen_syscall_target)
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
@@ -309,10 +309,10 @@ SYM_CODE_START(xen_syscall32_target)
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
@@ -330,18 +330,18 @@ SYM_CODE_START(xen_sysenter_target)
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


