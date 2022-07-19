Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6435579D51
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbiGSMuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiGSMtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190EF8E4F1;
        Tue, 19 Jul 2022 05:19:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF13617B2;
        Tue, 19 Jul 2022 12:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA1DC341CA;
        Tue, 19 Jul 2022 12:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233170;
        bh=wt4k0BMHgTqMtsDUiI5OoAhxupig8hdc03zTNxLLy00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBbZJ2U++1hAKuOdpdt2gxPKlU1hujt/Im+NPNUKgwYYAWECie+Bfukz4muHXq6Q6
         YN9ceJK1n5OTQdg94HRzFdkY7BJ1rnQhY3QwqbqwKM/swJZtKJu7W5X4SXieHQWLV1
         gU/ipfiJOi46r2uXnZ9e++DkljU5bWdjsCCqnTlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.18 006/231] x86/xen: Use clear_bss() for Xen PV guests
Date:   Tue, 19 Jul 2022 13:51:31 +0200
Message-Id: <20220719114714.704934047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit 96e8fc5818686d4a1591bb6907e7fdb64ef29884 upstream.

Instead of clearing the bss area in assembly code, use the clear_bss()
function.

This requires to pass the start_info address as parameter to
xen_start_kernel() in order to avoid the xen_start_info being zeroed
again.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20220630071441.28576-2-jgross@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/setup.h |    3 +++
 arch/x86/kernel/head64.c     |    2 +-
 arch/x86/xen/enlighten_pv.c  |    8 ++++++--
 arch/x86/xen/xen-head.S      |   10 +---------
 4 files changed, 11 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -132,6 +132,9 @@ void *extend_brk(size_t size, size_t ali
 	}
 
 extern void probe_roms(void);
+
+void clear_bss(void);
+
 #ifdef __i386__
 
 asmlinkage void __init i386_start_kernel(void);
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -421,7 +421,7 @@ void __init do_early_exception(struct pt
 
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
-static void __init clear_bss(void)
+void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1183,15 +1183,19 @@ static void __init xen_domu_set_legacy_f
 extern void early_xen_iret_patch(void);
 
 /* First C function to be called on Xen boot */
-asmlinkage __visible void __init xen_start_kernel(void)
+asmlinkage __visible void __init xen_start_kernel(struct start_info *si)
 {
 	struct physdev_set_iopl set_iopl;
 	unsigned long initrd_start = 0;
 	int rc;
 
-	if (!xen_start_info)
+	if (!si)
 		return;
 
+	clear_bss();
+
+	xen_start_info = si;
+
 	__text_gen_insn(&early_xen_iret_patch,
 			JMP32_INSN_OPCODE, &early_xen_iret_patch, &xen_iret,
 			JMP32_INSN_SIZE);
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -48,15 +48,6 @@ SYM_CODE_START(startup_xen)
 	ANNOTATE_NOENDBR
 	cld
 
-	/* Clear .bss */
-	xor %eax,%eax
-	mov $__bss_start, %rdi
-	mov $__bss_stop, %rcx
-	sub %rdi, %rcx
-	shr $3, %rcx
-	rep stosq
-
-	mov %rsi, xen_start_info
 	mov initial_stack(%rip), %rsp
 
 	/* Set up %gs.
@@ -71,6 +62,7 @@ SYM_CODE_START(startup_xen)
 	cdq
 	wrmsr
 
+	mov	%rsi, %rdi
 	call xen_start_kernel
 SYM_CODE_END(startup_xen)
 	__FINIT


