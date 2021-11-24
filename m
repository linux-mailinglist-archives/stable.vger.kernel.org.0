Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D9C45C0D4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346489AbhKXNLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343951AbhKXNJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C3D613AB;
        Wed, 24 Nov 2021 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757664;
        bh=ROwCFgdjpCBfDfzMt1R1v0Ny/5XFfskpBjiRuGXfO7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oU5tpKKOQvJ3OGk23AJ+3Hzqga7ffkSc2ocKnx/2GruUo58lrkV/kxQK9S4aMGrkC
         JpSMo8Mbpjk8vOApFAEuGUv16PMk98au017aoWHwm4YI1NZ+59FXj4cof2FY2YI+PJ
         hLHFigJDVbBp3sQjZeGhhUph/n2qDoVnvY6GV8BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 237/323] powerpc/lib: Add helper to check if offset is within conditional branch range
Date:   Wed, 24 Nov 2021 12:57:07 +0100
Message-Id: <20211124115726.918148963@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

upstream commit 4549c3ea3160fa8b3f37dfe2f957657bb265eda9

Add a helper to check if a given offset is within the branch range for a
powerpc conditional branch instruction, and update some sites to use the
new helper.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/442b69a34ced32ca346a0d9a855f3f6cfdbbbd41.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/code-patching.h |    1 +
 arch/powerpc/lib/code-patching.c         |    7 ++++++-
 arch/powerpc/net/bpf_jit.h               |    7 +------
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -26,6 +26,7 @@
 #define BRANCH_ABSOLUTE	0x2
 
 bool is_offset_in_branch_range(long offset);
+bool is_offset_in_cond_branch_range(long offset);
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags);
 unsigned int create_cond_branch(const unsigned int *addr,
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -243,6 +243,11 @@ bool is_offset_in_branch_range(long offs
 	return (offset >= -0x2000000 && offset <= 0x1fffffc && !(offset & 0x3));
 }
 
+bool is_offset_in_cond_branch_range(long offset)
+{
+	return offset >= -0x8000 && offset <= 0x7fff && !(offset & 0x3);
+}
+
 /*
  * Helper to check if a given instruction is a conditional branch
  * Derived from the conditional checks in analyse_instr()
@@ -296,7 +301,7 @@ unsigned int create_cond_branch(const un
 		offset = offset - (unsigned long)addr;
 
 	/* Check we can represent the target in the instruction format */
-	if (offset < -0x8000 || offset > 0x7FFF || offset & 0x3)
+	if (!is_offset_in_cond_branch_range(offset))
 		return 0;
 
 	/* Mask out the flags and target, so they don't step on each other. */
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -221,11 +221,6 @@
 #define PPC_FUNC_ADDR(d,i) do { PPC_LI32(d, i); } while(0)
 #endif
 
-static inline bool is_nearbranch(int offset)
-{
-	return (offset < 32768) && (offset >= -32768);
-}
-
 /*
  * The fly in the ointment of code size changing from pass to pass is
  * avoided by padding the short branch case with a NOP.	 If code size differs
@@ -234,7 +229,7 @@ static inline bool is_nearbranch(int off
  * state.
  */
 #define PPC_BCC(cond, dest)	do {					      \
-		if (is_nearbranch((dest) - (ctx->idx * 4))) {		      \
+		if (is_offset_in_cond_branch_range((long)(dest) - (ctx->idx * 4))) {	\
 			PPC_BCC_SHORT(cond, dest);			      \
 			PPC_NOP();					      \
 		} else {						      \


