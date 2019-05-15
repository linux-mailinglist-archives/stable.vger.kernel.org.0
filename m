Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A001ECF6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfEOLDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbfEOLDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0443C2084F;
        Wed, 15 May 2019 11:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918221;
        bh=++UBiiiSza5chgC0MTfNpc7+6jP7+knBuzcFNRQ+J0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PfEU2K1YVwfLhpv/5vmb+xXKusDRuBEfXb6rF7vyKSI/J3x3JOjxhpiH221+Vfig
         MIiwxtxxdwuylkH0rv5AnicUV7/gkGQfCUGdeJ/0AgYWl7zxm6n7HazJFpdshmHBGH
         EJtcV8gnw97i77L78eqCex+wXwf7RzPPfoSFQsHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 051/266] powerpc/asm: Add a patch_site macro & helpers for patching instructions
Date:   Wed, 15 May 2019 12:52:38 +0200
Message-Id: <20190515090724.174251222@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 06d0bbc6d0f56dacac3a79900e9a9a0d5972d818 upstream.

Add a macro and some helper C functions for patching single asm
instructions.

The gas macro means we can do something like:

  1:	nop
  	patch_site 1b, patch__foo

Which is less visually distracting than defining a GLOBAL symbol at 1,
and also doesn't pollute the symbol table which can confuse eg. perf.

These are obviously similar to our existing feature sections, but are
not automatically patched based on CPU/MMU features, rather they are
designed to be manually patched by C code at some arbitrary point.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/code-patching-asm.h |   18 ++++++++++++++++++
 arch/powerpc/include/asm/code-patching.h     |    2 ++
 arch/powerpc/lib/code-patching.c             |   16 ++++++++++++++++
 3 files changed, 36 insertions(+)
 create mode 100644 arch/powerpc/include/asm/code-patching-asm.h

--- /dev/null
+++ b/arch/powerpc/include/asm/code-patching-asm.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright 2018, Michael Ellerman, IBM Corporation.
+ */
+#ifndef _ASM_POWERPC_CODE_PATCHING_ASM_H
+#define _ASM_POWERPC_CODE_PATCHING_ASM_H
+
+/* Define a "site" that can be patched */
+.macro patch_site label name
+	.pushsection ".rodata"
+	.balign 4
+	.global \name
+\name:
+	.4byte	\label - .
+	.popsection
+.endm
+
+#endif /* _ASM_POWERPC_CODE_PATCHING_ASM_H */
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -28,6 +28,8 @@ unsigned int create_cond_branch(const un
 				unsigned long target, int flags);
 int patch_branch(unsigned int *addr, unsigned long target, int flags);
 int patch_instruction(unsigned int *addr, unsigned int instr);
+int patch_instruction_site(s32 *addr, unsigned int instr);
+int patch_branch_site(s32 *site, unsigned long target, int flags);
 
 int instr_is_relative_branch(unsigned int instr);
 int instr_is_branch_to_addr(const unsigned int *instr, unsigned long addr);
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -32,6 +32,22 @@ int patch_branch(unsigned int *addr, uns
 	return patch_instruction(addr, create_branch(addr, target, flags));
 }
 
+int patch_branch_site(s32 *site, unsigned long target, int flags)
+{
+	unsigned int *addr;
+
+	addr = (unsigned int *)((unsigned long)site + *site);
+	return patch_instruction(addr, create_branch(addr, target, flags));
+}
+
+int patch_instruction_site(s32 *site, unsigned int instr)
+{
+	unsigned int *addr;
+
+	addr = (unsigned int *)((unsigned long)site + *site);
+	return patch_instruction(addr, instr);
+}
+
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags)
 {


