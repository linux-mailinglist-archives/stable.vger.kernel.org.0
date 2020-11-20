Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99122BA86E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgKTLHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgKTLHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E7222255;
        Fri, 20 Nov 2020 11:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870467;
        bh=4vmCDo5Feohy25DsYOISnO1rV0AUL2cXqFvfb97ExBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6r0pz6/1MqZTp0gzDQnXVFGr5PjwJj3zbmoZ/H6YIUJnvJSFR3HdL8DptT+qxL6J
         5rQlPJuGqvLXcvrNPgvgLHHL1KWqqNg8CflTD3tXpw9IFsEz9qqy42KXre2CCp2QZZ
         efh3xrehS2vzH+syStcoUZn4+kCFdvzB4gV7N5E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 04/14] powerpc: Only include kup-radix.h for 64-bit Book3S
Date:   Fri, 20 Nov 2020 12:03:42 +0100
Message-Id: <20201120104541.388561008@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 178d52c6e89c38d0553b0ac8b99927b11eb995b0 upstream.

In kup.h we currently include kup-radix.h for all 64-bit builds, which
includes Book3S and Book3E. The latter doesn't make sense, Book3E
never uses the Radix MMU.

This has worked up until now, but almost by accident, and the recent
uaccess flush changes introduced a build breakage on Book3E because of
the bad structure of the code.

So disentangle things so that we only use kup-radix.h for Book3S. This
requires some more stubs in kup.h and fixing an include in
syscall_64.c.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h |    4 ++--
 arch/powerpc/include/asm/kup.h                 |   11 ++++++++---
 arch/powerpc/kernel/syscall_64.c               |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -27,6 +27,7 @@
 #endif
 .endm
 
+#ifdef CONFIG_PPC_KUAP
 .macro kuap_check_amr gpr1, gpr2
 #ifdef CONFIG_PPC_KUAP_DEBUG
 	BEGIN_MMU_FTR_SECTION_NESTED(67)
@@ -38,6 +39,7 @@
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
 #endif
 .endm
+#endif
 
 .macro kuap_save_amr_and_lock gpr1, gpr2, use_cr, msr_pr_cr
 #ifdef CONFIG_PPC_KUAP
@@ -148,8 +150,6 @@ static inline unsigned long kuap_get_and
 	return 0UL;
 }
 
-static inline void kuap_check_amr(void) { }
-
 static inline unsigned long get_kuap(void)
 {
 	return AMR_KUAP_BLOCKED;
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -14,7 +14,7 @@
 #define KUAP_CURRENT_WRITE	8
 #define KUAP_CURRENT		(KUAP_CURRENT_READ | KUAP_CURRENT_WRITE)
 
-#ifdef CONFIG_PPC64
+#ifdef CONFIG_PPC_BOOK3S_64
 #include <asm/book3s/64/kup-radix.h>
 #endif
 #ifdef CONFIG_PPC_8xx
@@ -35,6 +35,9 @@
 .macro kuap_check	current, gpr
 .endm
 
+.macro kuap_check_amr	gpr1, gpr2
+.endm
+
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -60,19 +63,21 @@ bad_kuap_fault(struct pt_regs *regs, uns
 	return false;
 }
 
+static inline void kuap_check_amr(void) { }
+
 /*
  * book3s/64/kup-radix.h defines these functions for the !KUAP case to flush
  * the L1D cache after user accesses. Only include the empty stubs for other
  * platforms.
  */
-#ifndef CONFIG_PPC64
+#ifndef CONFIG_PPC_BOOK3S_64
 static inline void allow_user_access(void __user *to, const void __user *from,
 				     unsigned long size, unsigned long dir) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size, unsigned long dir) { }
 static inline unsigned long prevent_user_access_return(void) { return 0UL; }
 static inline void restore_user_access(unsigned long flags) { }
-#endif /* CONFIG_PPC64 */
+#endif /* CONFIG_PPC_BOOK3S_64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
--- a/arch/powerpc/kernel/syscall_64.c
+++ b/arch/powerpc/kernel/syscall_64.c
@@ -2,7 +2,7 @@
 
 #include <linux/err.h>
 #include <asm/asm-prototypes.h>
-#include <asm/book3s/64/kup-radix.h>
+#include <asm/kup.h>
 #include <asm/cputime.h>
 #include <asm/hw_irq.h>
 #include <asm/kprobes.h>


