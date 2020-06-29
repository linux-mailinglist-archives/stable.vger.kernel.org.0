Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8EC20E756
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404187AbgF2V4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A3D246C7;
        Mon, 29 Jun 2020 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444018;
        bh=mRm22jjjhmYNa0dWj85l2ScqLQVog5bM7J59aF+g4kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVcHRrjhF9V0N1URwbarN/5SIti0FlcWx6sC6GnZ/kdKcFiW/gmCNX9Js2TrsaLIi
         Gece93Dhxq/R7N5Eez+rJXDNeHjEEGrWa2x8j03pcoxe7dtowi0vo4J1Doxrb+kLe+
         CXwn5jHxsea1ym6zRL8EJ0+1CgQ5a0io7Px10De4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/265] efi/x86: Setup stack correctly for efi_pe_entry
Date:   Mon, 29 Jun 2020 11:15:58 -0400
Message-Id: <20200629151818.2493727-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 41d90b0c1108d1e46c48cf79964636c553844f4c ]

Commit

  17054f492dfd ("efi/x86: Implement mixed mode boot without the handover protocol")

introduced a new entry point for the EFI stub to be booted in mixed mode
on 32-bit firmware.

When entered via efi32_pe_entry, control is first transferred to
startup_32 to setup for the switch to long mode, and then the EFI stub
proper is entered via efi_pe_entry. efi_pe_entry is an MS ABI function,
and the ABI requires 32 bytes of shadow stack space to be allocated by
the caller, as well as the stack being aligned to 8 mod 16 on entry.

Allocate 40 bytes on the stack before switching to 64-bit mode when
calling efi_pe_entry to account for this.

For robustness, explicitly align boot_stack_end to 16 bytes. It is
currently implicitly aligned since .bss is cacheline-size aligned,
head_64.o is the first object file with a .bss section, and the heap and
boot sizes are aligned.

Fixes: 17054f492dfd ("efi/x86: Implement mixed mode boot without the handover protocol")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200617131957.2507632-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 76d1d64d51e38..41f7922086220 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -213,7 +213,6 @@ SYM_FUNC_START(startup_32)
 	 * We place all of the values on our mini stack so lret can
 	 * used to perform that far jump.
 	 */
-	pushl	$__KERNEL_CS
 	leal	startup_64(%ebp), %eax
 #ifdef CONFIG_EFI_MIXED
 	movl	efi32_boot_args(%ebp), %edi
@@ -224,11 +223,20 @@ SYM_FUNC_START(startup_32)
 	movl	efi32_boot_args+8(%ebp), %edx	// saved bootparams pointer
 	cmpl	$0, %edx
 	jnz	1f
+	/*
+	 * efi_pe_entry uses MS calling convention, which requires 32 bytes of
+	 * shadow space on the stack even if all arguments are passed in
+	 * registers. We also need an additional 8 bytes for the space that
+	 * would be occupied by the return address, and this also results in
+	 * the correct stack alignment for entry.
+	 */
+	subl	$40, %esp
 	leal	efi_pe_entry(%ebp), %eax
 	movl	%edi, %ecx			// MS calling convention
 	movl	%esi, %edx
 1:
 #endif
+	pushl	$__KERNEL_CS
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
@@ -776,6 +784,7 @@ SYM_DATA_LOCAL(boot_heap,	.fill BOOT_HEAP_SIZE, 1, 0)
 
 SYM_DATA_START_LOCAL(boot_stack)
 	.fill BOOT_STACK_SIZE, 1, 0
+	.balign 16
 SYM_DATA_END_LABEL(boot_stack, SYM_L_LOCAL, boot_stack_end)
 
 /*
-- 
2.25.1

