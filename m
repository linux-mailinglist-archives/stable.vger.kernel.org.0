Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5F572542
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbiGLTOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbiGLTOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F85C765C;
        Tue, 12 Jul 2022 11:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA2661491;
        Tue, 12 Jul 2022 18:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB88C3411C;
        Tue, 12 Jul 2022 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657652034;
        bh=f+uU6J9TFzo69g/2PpcA8Me0kRnOl5SAjGpZBeSmyRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FImkjRZZehV/g+Ad/s8jBpBkBKT34624kgdM6pv9EzHKs0cehQceM8S8QgZQNeBCv
         evV20WQR/Log+3kVOKDFn3i07TyYbNY2G6OyzLCtavaEXesIkv0kbJfUzXN9lrqfyF
         GSGl5d9wCpGx2+OFzEPdtbo1OIGVqP/RqzszEv+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Tran <edward.tran@oracle.com>,
        Awais Tanveer <awais.tanveer@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 59/61] x86/kexec: Disable RET on kexec
Date:   Tue, 12 Jul 2022 20:39:56 +0200
Message-Id: <20220712183239.220828759@linuxfoundation.org>
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

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 697977d8415d61f3acbc4ee6d564c9dcf0309507 upstream.

All the invocations unroll to __x86_return_thunk and this file
must be PIC independent.

This fixes kexec on 64-bit AMD boxes.

  [ bp: Fix 32-bit build. ]

Reported-by: Edward Tran <edward.tran@oracle.com>
Reported-by: Awais Tanveer <awais.tanveer@oracle.com>
Suggested-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/relocate_kernel_32.S |   25 +++++++++++++++++++------
 arch/x86/kernel/relocate_kernel_64.S |   23 +++++++++++++++++------
 2 files changed, 36 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -7,10 +7,12 @@
 #include <linux/linkage.h>
 #include <asm/page_types.h>
 #include <asm/kexec.h>
+#include <asm/nospec-branch.h>
 #include <asm/processor-flags.h>
 
 /*
- * Must be relocatable PIC code callable as a C function
+ * Must be relocatable PIC code callable as a C function, in particular
+ * there must be a plain RET and not jump to return thunk.
  */
 
 #define PTR(x) (x << 2)
@@ -91,7 +93,9 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	movl    %edi, %eax
 	addl    $(identity_mapped - relocate_kernel), %eax
 	pushl   %eax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -159,12 +163,15 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_ma
 	xorl    %edx, %edx
 	xorl    %esi, %esi
 	xorl    %ebp, %ebp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 1:
 	popl	%edx
 	movl	CP_PA_SWAP_PAGE(%edi), %esp
 	addl	$PAGE_SIZE, %esp
 2:
+	ANNOTATE_RETPOLINE_SAFE
 	call	*%edx
 
 	/* get the re-entry point of the peer system */
@@ -190,7 +197,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_ma
 	movl	%edi, %eax
 	addl	$(virtual_mapped - relocate_kernel), %eax
 	pushl	%eax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -208,7 +217,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_map
 	popl	%edi
 	popl	%esi
 	popl	%ebx
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -271,7 +282,9 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	popl	%edi
 	popl	%ebx
 	popl	%ebp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -13,7 +13,8 @@
 #include <asm/unwind_hints.h>
 
 /*
- * Must be relocatable PIC code callable as a C function
+ * Must be relocatable PIC code callable as a C function, in particular
+ * there must be a plain RET and not jump to return thunk.
  */
 
 #define PTR(x) (x << 3)
@@ -105,7 +106,9 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	/* jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8
 	pushq	%r8
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -200,7 +203,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_ma
 	xorl	%r14d, %r14d
 	xorl	%r15d, %r15d
 
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 1:
 	popq	%rdx
@@ -219,7 +224,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_ma
 	call	swap_pages
 	movq	$virtual_mapped, %rax
 	pushq	%rax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -241,7 +248,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_map
 	popq	%r12
 	popq	%rbp
 	popq	%rbx
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -298,7 +307,9 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	lea	PAGE_SIZE(%rax), %rsi
 	jmp	0b
 3:
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size


