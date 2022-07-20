Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629B857AC7B
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbiGTBVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiGTBT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B7769F03;
        Tue, 19 Jul 2022 18:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E940B617EC;
        Wed, 20 Jul 2022 01:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA9C341C6;
        Wed, 20 Jul 2022 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279760;
        bh=1U3MoXaHg97XVksfWF7PC+ecrd9t1aS1+YbqjhckeKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U50hLjrW6bppgmzK3AAzW2sp96fqkK5rCfLsBfzQUA4dICJjdf0XzgnnT+lu/95Q7
         FsSg9Kp2VLtzjKnmhAeB8GvDRCnbC6OuBlf4dDRC5BnwbXziDZ0avGz4bn48IqYcAB
         g2CYN3h52sQ+6NDLsJprJVlC9TALK+SdU4jAYUoJ7hRqvXR5nSiBdv0n9p2G06QNxe
         ZzwzMzeL/4EacNJLDD3BgBFCxrzqItiOS9LDrgIQBjr5JwXvsthw23ZB8NdR1PT8ED
         VCvkpYJv/EAeR/uo28lS91Pv7lPcvGTTluf3S6F8rOHFNRnyFX1CwGjhsuKHw1Jzob
         A+I02Th8Y69gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Edward Tran <edward.tran@oracle.com>,
        Awais Tanveer <awais.tanveer@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, peterz@infradead.org,
        jpoimboe@kernel.org, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 5.15 35/42] x86/kexec: Disable RET on kexec
Date:   Tue, 19 Jul 2022 21:13:43 -0400
Message-Id: <20220720011350.1024134-35-sashal@kernel.org>
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

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

[ Upstream commit 697977d8415d61f3acbc4ee6d564c9dcf0309507 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/relocate_kernel_32.S | 25 +++++++++++++++++++------
 arch/x86/kernel/relocate_kernel_64.S | 23 +++++++++++++++++------
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index fcc8a7699103..c7c4b1917336 100644
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
@@ -159,12 +163,15 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
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
@@ -190,7 +197,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movl	%edi, %eax
 	addl	$(virtual_mapped - relocate_kernel), %eax
 	pushl	%eax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -208,7 +217,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
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
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 5019091af059..8a9cea950e39 100644
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
@@ -104,7 +105,9 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	/* jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8
 	pushq	%r8
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -191,7 +194,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl	%r14d, %r14d
 	xorl	%r15d, %r15d
 
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 1:
 	popq	%rdx
@@ -210,7 +215,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	call	swap_pages
 	movq	$virtual_mapped, %rax
 	pushq	%rax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -231,7 +238,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
 	popq	%r12
 	popq	%rbp
 	popq	%rbx
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -288,7 +297,9 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	lea	PAGE_SIZE(%rax), %rsi
 	jmp	0b
 3:
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
-- 
2.35.1

