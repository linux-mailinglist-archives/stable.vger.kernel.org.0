Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB557ABDB
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240990AbiGTBQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiGTBPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E36A65D73;
        Tue, 19 Jul 2022 18:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E761B81DA1;
        Wed, 20 Jul 2022 01:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B45C341CE;
        Wed, 20 Jul 2022 01:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279612;
        bh=DTpltMa20mOJ2hE5NgVoulPx1gBdW01YNjuT68G5eBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJq7F58nWB6uz+/3PEMcHEghga0GLjJoZ15laM0ZKXMSre7qs74QRWQ9dDf5nEQlA
         d93ryODKdZoGxG4mhW0hZK08AqAtLvAqS31FSQHoDnnlPWLP6AsghRW16IrjuMTA7j
         lg/5/rRfmG1TSP+c0Xkl7cizQdkcPypRvGwvJZViOHmm89l5paB1ot6t7850ic7lgM
         YNIysY+NvAEZff0nZZC33sYOqJVY4QaCxX7RUGxaW1IP27GQZZD6OT0e8cRZjqn7lu
         2cGjzAuhReeIcjZ5P74hQvY/TsOfRLa79NvoiapUQsFgcnNFEccinnIA7pR365g+Tr
         AsD3QpdmkXnSQ==
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
Subject: [PATCH AUTOSEL 5.18 46/54] x86/kexec: Disable RET on kexec
Date:   Tue, 19 Jul 2022 21:10:23 -0400
Message-Id: <20220720011031.1023305-46-sashal@kernel.org>
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
index c1d8626c53b6..4809c0dc4eb0 100644
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
@@ -200,7 +203,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl	%r14d, %r14d
 	xorl	%r15d, %r15d
 
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 1:
 	popq	%rdx
@@ -219,7 +224,9 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	call	swap_pages
 	movq	$virtual_mapped, %rax
 	pushq	%rax
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -241,7 +248,9 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
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
-- 
2.35.1

